# 사건별 현장 검증을 표시하고 결과를 기존 조사·회수 저장 흐름에 연결한다.
extends Control

const ThemeFactory = preload("res://scripts/ui/ui_theme_factory.gd")
const AfterlifeTheme = preload("res://scripts/ui/afterlife_station_theme.gd")
const AfterlifeHeaderScene = preload("res://scenes/ui/afterlife_header.tscn")
const TeamStatusPopoverScene = preload("res://scenes/ui/team_status_popover.tscn")
const GameSettingsDialogScript = preload("res://scripts/ui/game_settings_dialog.gd")
const RhythmGame = preload("res://scripts/minigames/rhythm_timing_game.gd")
const RainDodgeGame = preload("res://scripts/minigames/rain_dodge_game.gd")
const RouteRestoreGame = preload("res://scripts/minigames/route_restore_game.gd")
const AnomalyManualDrawerScript = preload("res://scripts/ui/anomaly_manual_drawer.gd")

var _minigame: Dictionary = {}
var _equipment_hint: Dictionary = {}
var _existing_result: Dictionary = {}
var _last_successful := false
var _completed := false

var _status_label: Label
var _result_label: Label
var _progress_bar: ProgressBar
var _return_button: Button
var _game_control: Control
var _manual_drawer: AnomalyManualDrawer
var _manual_toggle_button: Button


func _ready() -> void:
	theme = ThemeFactory.create_theme()
	if GameState.get_current_episode().is_empty():
		GameState.load_episode()

	GameState.set_current_scene_path("res://scenes/minigame_scene.tscn")
	_minigame = GameState.get_current_minigame()
	_apply_runtime_minigame_overrides()
	if _is_route_restore_minigame():
		theme = AfterlifeTheme.create_theme()
	var minigame_id := String(_minigame.get("id", GameState.get_current_minigame_id()))
	_existing_result = GameState.get_minigame_result(minigame_id)
	if _existing_result.is_empty() and not _is_route_restore_minigame():
		_equipment_hint = GameState.try_use_frequency_filter_hint(minigame_id)
	_build_ui()


func _apply_runtime_minigame_overrides() -> void:
	if String(_minigame.get("id", "")) != "minigame_frequency_sync":
		return
	_minigame = _minigame.duplicate(true)
	_minigame["type"] = "route_restore"
	_minigame["title"] = "저승역 노선 복원"
	_minigame["description"] = "오현의 공식 운행 기록과 권나래의 현장 보고를 대조해, 강이준이 유지하는 현실 출구까지 피해자 호송 노선을 복원합니다. 3×3은 조작 학습이고 4×4가 마지막 현장 검증입니다."
	_minigame["rules_text"] = "타일을 회전하고 분기 스위치를 바꿔 안전 목적지까지 연결하세요. 4×4의 최적은 8회, 정밀 기준은 10회입니다. 횟수 초과는 실패가 아닙니다."
	_minigame["optimal_move_count"] = 8
	_minigame["precision_move_limit"] = 10
	_minigame["route_risk"] = GameState.get_anomaly_risk()
	_minigame["route_entrenchment"] = 100 - GameState.get_anomaly_stability()
	_minigame["success_result_text"] = "안전 노선 검증 기록을 확보했습니다. 개인이 인식한 목적지는 실제 방송 원본에 없었고, 공식 식별 번호와 일치한 경로만 현실 승강장으로 연결됐습니다."
	_minigame["failure_result_text"] = "노선 검증을 계속할 수 있습니다. 끊긴 구간과 공식 식별 기록을 다시 대조하세요."
	_minigame["success_agent_reaction"] = "오현이 공식 기록과 실제 이동 경로의 일치를 확인합니다. 권나래는 피해자 호송을 재개하고, 강이준은 복원된 현실 경계를 고정합니다."
	_minigame["failure_agent_reaction"] = "세 요원이 현재 노선 상태를 유지한 채 잘못된 경로를 위험 사례로 분리합니다."


func _is_route_restore_minigame() -> bool:
	return String(_minigame.get("type", "")) == "route_restore"


func _build_ui() -> void:
	if _is_route_restore_minigame():
		_build_route_restore_ui()
		return
	var background := ColorRect.new()
	background.color = Color(0.018, 0.028, 0.038)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 28)
	margin.add_theme_constant_override("margin_top", 18)
	margin.add_theme_constant_override("margin_right", 28)
	margin.add_theme_constant_override("margin_bottom", 22)
	add_child(margin)

	var root := VBoxContainer.new()
	root.custom_minimum_size = Vector2(1080, 0)
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.add_theme_constant_override("separation", 12)
	margin.add_child(root)
	_add_navigation(root)
	_build_manual_drawer()

	var eyebrow := Label.new()
	eyebrow.text = "FIELD VERIFICATION  /  %s" % GameState.get_current_episode_title()
	eyebrow.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	eyebrow.add_theme_font_size_override("font_size", 13)
	eyebrow.add_theme_color_override("font_color", Color(0.48, 0.68, 0.72))
	root.add_child(eyebrow)

	var title := Label.new()
	title.text = String(_minigame.get("title", "현장 검증"))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 26)
	root.add_child(title)

	var columns := HBoxContainer.new()
	columns.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	columns.size_flags_vertical = Control.SIZE_EXPAND_FILL
	columns.add_theme_constant_override("separation", 14)
	root.add_child(columns)

	var briefing := _add_section(columns, "비교 근거" if _is_route_restore_minigame() else "검증 규칙", 0.78)
	var description_text := String(_minigame.get("description", "현장 검증을 준비합니다."))
	if _is_route_restore_minigame():
		description_text = "공식 운행 기록\n· 2번 승강장에서 출발\n· 3번 환승 후 1번 도착\n· 직선 구간 최소 1회 포함\n\n방송 원본\n· 다음은 3번 환승역입니다\n· 종료 식별음 뒤 이동\n\n현장 표기\n· 개인별 목적지 표기는 배제"
	var description := _make_body_label(description_text)
	briefing.add_child(description)
	var rule := _make_body_label(String(_minigame.get("rules_text", "화면 안내에 따라 입력하세요.")))
	rule.add_theme_color_override("font_color", Color(0.82, 0.88, 0.9))
	briefing.add_child(rule)

	var control_hint := Label.new()
	control_hint.text = _make_control_hint()
	control_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	control_hint.add_theme_font_size_override("font_size", 17)
	control_hint.add_theme_color_override("font_color", Color(0.35, 0.88, 0.74))
	briefing.add_child(control_hint)

	if not _equipment_hint.is_empty():
		var assist := _make_body_label("장비 보정\n%s" % String(_equipment_hint.get("effect_text", "판정 보정이 활성화되었습니다.")))
		assist.add_theme_color_override("font_color", Color(0.95, 0.76, 0.38))
		briefing.add_child(assist)

	var play := _add_section(columns, _make_play_title(), 1.8)
	_status_label = Label.new()
	_status_label.text = "현장 정보를 불러오는 중"
	_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_status_label.add_theme_font_size_override("font_size", 17)
	play.add_child(_status_label)

	_progress_bar = ProgressBar.new()
	_progress_bar.min_value = 0
	_progress_bar.max_value = 100
	_progress_bar.show_percentage = false
	_progress_bar.custom_minimum_size.y = 10
	play.add_child(_progress_bar)

	var playfield_frame := PanelContainer.new()
	playfield_frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	playfield_frame.size_flags_vertical = Control.SIZE_EXPAND_FILL
	playfield_frame.add_theme_stylebox_override("panel", _make_panel_style(Color(0.012, 0.025, 0.034), Color(0.18, 0.42, 0.46)))
	play.add_child(playfield_frame)

	var outcome := _add_section(columns, "현장 반응" if _is_route_restore_minigame() else "현장 기록", 0.9)
	_result_label = _make_body_label("목적지 혼선 · 정상\n노선 고착 · 확인 전\n관측 위험 · 경로 확인 전" if _is_route_restore_minigame() else "검증이 끝나면 마지막 단서와 요원 반응을 이곳에 기록합니다.")
	outcome.add_child(_result_label)
	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	outcome.add_child(spacer)
	_return_button = Button.new()
	_return_button.text = "조사 현장으로 복귀"
	_return_button.custom_minimum_size.y = 48
	_return_button.visible = false
	_return_button.pressed.connect(_return_to_flow)
	outcome.add_child(_return_button)

	if _existing_result.is_empty():
		_game_control = _make_game_control()
		playfield_frame.add_child(_game_control)
		_game_control.status_changed.connect(_on_status_changed)
		_game_control.completed.connect(_on_game_completed)
		if _game_control.has_signal("stage_changed"):
			_game_control.connect("stage_changed", _on_route_stage_changed)
		_game_control.configure(_minigame, not _equipment_hint.is_empty())
	else:
		_show_saved_result(playfield_frame)


func _build_route_restore_ui() -> void:
	var surface := TextureRect.new()
	surface.texture = load("res://assets/ui/afterlife/generated/afterlife_metal_panel_v1.png")
	surface.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	surface.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	surface.stretch_mode = TextureRect.STRETCH_SCALE
	surface.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(surface)
	var shade := ColorRect.new()
	shade.color = Color(0.01, 0.008, 0.012, 0.32)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_bottom", 12)
	add_child(margin)
	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 6)
	margin.add_child(root)
	var header := AfterlifeHeaderScene.instantiate() as AfterlifeHeader
	header.configure("저승역 · 최종 검증", "팀 상태")
	root.add_child(header)
	var team_popover := TeamStatusPopoverScene.instantiate() as TeamStatusPopover
	add_child(team_popover)
	team_popover.set_anchors_preset(Control.PRESET_CENTER)
	team_popover.position = Vector2(-180, -110)
	header.team_requested.connect(func() -> void: team_popover.open(_make_team_status_entries()))
	header.settings_requested.connect(func() -> void: GameSettingsDialogScript.open_for(self))

	var stage_bar := PanelContainer.new()
	stage_bar.custom_minimum_size.y = 36
	stage_bar.theme_type_variation = &"AfterlifeHeader"
	root.add_child(stage_bar)
	var stage_row := HBoxContainer.new()
	stage_bar.add_child(stage_row)
	var stage_label := Label.new()
	stage_label.text = "현장 검증 2/2"
	stage_label.theme_type_variation = &"AfterlifeMeta"
	stage_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	stage_row.add_child(stage_label)
	var objective := Label.new()
	objective.text = "현재 목표  ·  안전 노선 복원"
	objective.theme_type_variation = &"AfterlifeMeta"
	stage_row.add_child(objective)

	var columns := HBoxContainer.new()
	columns.size_flags_vertical = Control.SIZE_EXPAND_FILL
	columns.add_theme_constant_override("separation", 6)
	root.add_child(columns)
	var evidence := _add_route_panel(columns, "비교 근거", 0.28)
	_add_route_evidence_card(evidence, "공식 운행 기록", "2번 승강장에서 출발\n3번 환승 후 1번 도착\n직선 구간 최소 1회 포함", "▤")
	_add_route_evidence_card(evidence, "방송 원본", "종료 식별음 뒤 이동\n정적 뒤 같은 안내 반복", "◉")
	_add_route_evidence_card(evidence, "현장 표기", "개인 목적지 표기 배제\n공식 식별 번호만 대조", "◇")

	var play := _add_route_panel(columns, "노선 복원", 0.44)
	_status_label = Label.new()
	_status_label.text = "현장 정보를 불러오는 중"
	_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_status_label.theme_type_variation = &"AfterlifeMeta"
	play.add_child(_status_label)
	_progress_bar = ProgressBar.new()
	_progress_bar.min_value = 0
	_progress_bar.max_value = 100
	_progress_bar.show_percentage = false
	_progress_bar.custom_minimum_size.y = 5
	play.add_child(_progress_bar)
	var playfield_frame := PanelContainer.new()
	playfield_frame.size_flags_vertical = Control.SIZE_EXPAND_FILL
	playfield_frame.theme_type_variation = &"AfterlifePanel"
	play.add_child(playfield_frame)

	var outcome := _add_route_panel(columns, "현장 반응", 0.28)
	_result_label = Label.new()
	_result_label.visible = false
	outcome.add_child(_result_label)
	_add_route_status_card(outcome, "목적지 혼선", "경로가 불일치하면 목적지 표기가 왜곡됩니다.", "현재 · 정상", "?")
	_add_route_status_card(outcome, "노선 고착", "고착된 구간은 공식 기록과 맞지 않으면 움직이지 않습니다.", "고착 구간 · 확인 전", "▣")
	_add_route_status_card(outcome, "관측 위험", "노선이 왜곡되면 현장 반응이 불안정해질 수 있습니다.", "관측 기록 · 대기", "◉")
	var outcome_spacer := Control.new()
	outcome_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	outcome.add_child(outcome_spacer)
	_return_button = Button.new()
	_return_button.text = "현장 기록으로 복귀"
	_return_button.visible = false
	_return_button.pressed.connect(_return_to_flow)
	outcome.add_child(_return_button)

	_manual_toggle_button = Button.new()
	_manual_toggle_button.visible = false
	add_child(_manual_toggle_button)
	_build_manual_drawer()
	header.record_requested.connect(func() -> void: _manual_drawer.toggle())
	header.hq_requested.connect(func() -> void:
		if _completed:
			_return_to_flow()
	)

	if _existing_result.is_empty():
		_game_control = _make_game_control()
		playfield_frame.add_child(_game_control)
		_game_control.status_changed.connect(_on_status_changed)
		_game_control.completed.connect(_on_game_completed)
		if _game_control.has_signal("stage_changed"):
			_game_control.connect("stage_changed", _on_route_stage_changed)
		_game_control.configure(_minigame, false)
	else:
		_show_saved_result(playfield_frame)


func _add_route_panel(parent: Control, title_text: String, ratio: float) -> VBoxContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.size_flags_stretch_ratio = ratio
	panel.theme_type_variation = &"AfterlifePanel"
	parent.add_child(panel)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 8)
	panel.add_child(content)
	var title := Label.new()
	title.text = title_text
	title.theme_type_variation = &"AfterlifeSection"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(title)
	return content


func _make_team_status_entries() -> Array:
	var entries: Array = []
	for agent in GameState.get_selected_agents():
		if typeof(agent) != TYPE_DICTIONARY:
			continue
		var agent_id := String(agent.get("id", ""))
		entries.append({"name": String(agent.get("name", agent_id)), "hp": GameState.get_agent_current_hp(agent_id), "max_hp": GameState.get_agent_max_hp(agent_id), "mental": GameState.get_agent_current_mental(agent_id), "max_mental": GameState.get_agent_max_mental(agent_id), "active": GameState.is_agent_active(agent_id)})
	return entries


func _add_route_evidence_card(parent: VBoxContainer, title_text: String, body_text: String, icon_text: String) -> void:
	var card := PanelContainer.new()
	card.size_flags_vertical = Control.SIZE_EXPAND_FILL
	card.theme_type_variation = &"AfterlifePanel"
	parent.add_child(card)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 9)
	card.add_child(row)
	var icon := Label.new()
	icon.text = icon_text
	icon.custom_minimum_size.x = 30
	icon.add_theme_font_size_override("font_size", 20)
	icon.add_theme_color_override("font_color", AfterlifeTheme.GOLD)
	row.add_child(icon)
	var stack := VBoxContainer.new()
	stack.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(stack)
	var title := Label.new()
	title.text = title_text
	title.add_theme_color_override("font_color", Color("c3ad87"))
	stack.add_child(title)
	var body := Label.new()
	body.text = body_text
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.theme_type_variation = &"AfterlifeMeta"
	stack.add_child(body)


func _add_route_status_card(parent: VBoxContainer, title_text: String, body_text: String, state_text: String, icon_text: String) -> void:
	var card := PanelContainer.new()
	card.theme_type_variation = &"AfterlifePanel"
	parent.add_child(card)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 9)
	card.add_child(row)
	var icon := Label.new()
	icon.text = icon_text
	icon.custom_minimum_size.x = 30
	icon.add_theme_font_size_override("font_size", 20)
	icon.add_theme_color_override("font_color", AfterlifeTheme.GOLD)
	row.add_child(icon)
	var stack := VBoxContainer.new()
	stack.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(stack)
	var title := Label.new()
	title.text = title_text
	stack.add_child(title)
	var body := Label.new()
	body.text = body_text
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.theme_type_variation = &"AfterlifeMeta"
	stack.add_child(body)
	var state := Label.new()
	state.text = state_text
	state.add_theme_color_override("font_color", Color("ba8d4b"))
	state.theme_type_variation = &"AfterlifeMeta"
	stack.add_child(state)


func _show_saved_result(playfield_frame: PanelContainer) -> void:
	_completed = true
	_last_successful = bool(_existing_result.get("successful", false))
	_status_label.text = "검증 기록 완료  |  %s" % ("성공" if _last_successful else "실패")
	_progress_bar.value = 100.0
	var summary := Label.new()
	summary.text = "이 미니게임의 결과는 이미 저장되었습니다.\n\n%s" % String(_existing_result.get("input_summary", "플레이 기록을 확인하세요."))
	summary.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	summary.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	summary.add_theme_font_size_override("font_size", 20)
	playfield_frame.add_child(summary)
	_result_label.text = _make_result_text(_last_successful, _existing_result)
	_return_button.visible = true


func _make_game_control() -> Control:
	match String(_minigame.get("type", "rhythm_timing")):
		"route_restore": return RouteRestoreGame.new()
		"rain_dodge": return RainDodgeGame.new()
		_: return RhythmGame.new()


func _on_status_changed(text: String, progress: float) -> void:
	_status_label.text = text
	_progress_bar.value = clampf(progress, 0.0, 1.0) * 100.0


func _on_route_stage_changed(stage_id: String, title: String, details: Dictionary) -> void:
	if _result_label == null:
		return
	if stage_id == "tutorial":
		_result_label.text = "%s\n\n목적지 혼선 · 관찰 중\n노선 고착 · 적용 안 함\n관측 위험 · 기록만 유지" % title
	else:
		_result_label.text = "%s\n\n목적지 혼선 · 개인 표기 배제\n노선 고착 · 공식 기록으로 해제\n관측 위험 · 직전 반응을 여기 기록" % title


func _on_game_completed(successful: bool, details: Dictionary) -> void:
	if _completed:
		return
	_completed = true
	_last_successful = successful
	var saved_details := details.duplicate(true)
	saved_details["effect_summary"] = _make_effect_summary(successful)
	saved_details["equipment_assisted"] = not _equipment_hint.is_empty()
	saved_details["display_title"] = String(_minigame.get("title", "현장 검증"))
	GameState.save_minigame_result(String(_minigame.get("id", GameState.get_current_minigame_id())), successful, saved_details)
	if _is_route_restore_minigame() and successful:
		GameState.collect_clue("clue_black_ticket")
	_result_label.text = _make_result_text(successful, saved_details)
	_return_button.visible = true
	_return_button.grab_focus()
	if _manual_drawer != null:
		_manual_drawer.mark_new_entries()


func _make_result_text(successful: bool, details: Dictionary) -> String:
	var result_key := "success_result_text" if successful else "failure_result_text"
	var reaction_key := "success_agent_reaction" if successful else "failure_agent_reaction"
	var heading := "검증 성공" if successful else "검증 실패 · 사건 진행 가능"
	if _is_route_restore_minigame() and successful:
		heading = "노선 복원 완료 · %s" % String(details.get("clear_grade_label", "일반 복원"))
	var extra := ""
	if bool(details.get("danger_case_seen", false)):
		extra = "\n\n위험 사례\n개인이 인식한 목적지를 공식 경로로 적용하면 같은 승강장으로 되돌아갑니다."
	return "%s\n\n%s%s\n\n상태 변화\n%s\n\n요원 반응\n%s" % [
		heading,
		String(_minigame.get(result_key, "검증 결과가 기록되었습니다.")),
		extra,
		String(details.get("effect_summary", "변화 없음")),
		String(_minigame.get(reaction_key, "팀이 검증 결과를 회수 근거에 반영합니다."))
	]


func _make_effect_summary(successful: bool) -> String:
	var prefix := "success" if successful else "failure"
	return "위험도 %s  ·  이해도 %s\n정신력 %s  ·  괴이 고착도 %s\n회수 기준 %s" % [
		_format_delta(int(_minigame.get("%s_anomaly_risk_delta" % prefix, 0))),
		_format_delta(int(_minigame.get("%s_anomaly_understanding_delta" % prefix, 0))),
		_format_delta(int(_minigame.get("%s_mental_stamina_delta" % prefix, 0))),
		_format_delta(int(_minigame.get("%s_anomaly_stability_delta" % prefix, 0))),
		_format_delta(int(_minigame.get("%s_recovery_threshold_delta" % prefix, 0)))
	]


func _format_delta(value: int) -> String:
	return "+%d" % value if value > 0 else str(value)


func _make_play_title() -> String:
	match String(_minigame.get("type", "")):
		"route_restore": return "노선 복원 보드"
		"rain_dodge": return "빗속 이동"
		_: return "폐주파수 동기화"


func _make_control_hint() -> String:
	match String(_minigame.get("type", "")):
		"route_restore": return "조작  타일 클릭 또는 방향키+Enter 회전  /  C 경로 확인  /  R 초기화"
		"rain_dodge": return "조작  방향키"
		_: return "조작  SPACE / ENTER"


func _add_section(parent: Control, title_text: String, stretch_ratio: float) -> VBoxContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.size_flags_stretch_ratio = stretch_ratio
	panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.055, 0.067, 0.078), Color(0.15, 0.22, 0.25)))
	parent.add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_bottom", 16)
	panel.add_child(margin)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 12)
	margin.add_child(content)
	var title := Label.new()
	title.text = title_text
	title.add_theme_font_size_override("font_size", 19)
	title.add_theme_color_override("font_color", Color(0.88, 0.92, 0.93))
	content.add_child(title)
	return content


func _make_body_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", 15)
	label.add_theme_color_override("font_color", Color(0.68, 0.74, 0.77))
	return label


func _make_panel_style(background: Color, border: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(1)
	style.corner_radius_top_left = 4
	style.corner_radius_top_right = 4
	style.corner_radius_bottom_left = 4
	style.corner_radius_bottom_right = 4
	return style


func _return_to_flow() -> void:
	if _is_route_restore_minigame() and _last_successful:
		GameState.set_current_scene_path("res://scenes/battle_scene.tscn")
		GameState.save_game()
		get_tree().change_scene_to_file("res://scenes/battle_scene.tscn")
		return
	var key := "success_next_scene_path" if _last_successful else "failure_next_scene_path"
	var scene_path := String(_minigame.get(key, ""))
	if scene_path.is_empty():
		scene_path = String(_minigame.get("return_scene_path", "res://scenes/investigation_scene.tscn"))
	GameState.set_current_scene_path(scene_path)
	GameState.save_game()
	get_tree().change_scene_to_file(scene_path)


func _add_navigation(parent: Control) -> void:
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 8)
	parent.add_child(row)
	var notice := Label.new()
	notice.text = "현장 검증 중에는 저장할 수 없습니다. 종료하거나 불러오면 이 미니게임의 처음부터 다시 시작합니다."
	notice.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	notice.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	notice.add_theme_font_size_override("font_size", 13)
	notice.add_theme_color_override("font_color", Color(0.82, 0.68, 0.42))
	notice.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(notice)
	_manual_toggle_button = Button.new()
	_manual_toggle_button.text = "괴이 매뉴얼"
	row.add_child(_manual_toggle_button)


func _build_manual_drawer() -> void:
	_manual_drawer = AnomalyManualDrawerScript.new()
	add_child(_manual_drawer)
	_manual_drawer.anchor_left = 0.67
	_manual_drawer.anchor_top = 0.14
	_manual_drawer.anchor_right = 0.985
	_manual_drawer.anchor_bottom = 0.86
	_manual_drawer.set_sections([
		{"title": "검증 규칙", "text": String(_minigame.get("rules_text", "공식 기록과 현재 경로를 대조합니다."))},
		{"title": "현재 기록", "text": String(_minigame.get("description", "현장 검증을 진행합니다."))},
		{"title": "요원 지원", "text": "요원 지원과 결과 상세는 검증이 끝난 뒤 기록에 반영됩니다."}
	])
	_manual_drawer.bind_toggle_button(_manual_toggle_button)
	_manual_drawer.drawer_opened.connect(_set_manual_input_lock.bind(true))
	_manual_drawer.drawer_closed.connect(_set_manual_input_lock.bind(false))


func _set_manual_input_lock(locked: bool) -> void:
	if _game_control != null:
		_game_control.set_process_unhandled_input(not locked)
		_game_control.set_process_unhandled_key_input(not locked)
		if _game_control.has_method("set_input_locked"):
			_game_control.call("set_input_locked", locked)
