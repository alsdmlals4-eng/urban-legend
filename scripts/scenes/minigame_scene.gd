# 사건별 현장 검증을 표시하고 결과를 기존 조사·회수 저장 흐름에 연결한다.
extends Control

const ThemeFactory = preload("res://scripts/ui/ui_theme_factory.gd")
const RhythmGame = preload("res://scripts/minigames/rhythm_timing_game.gd")
const RainDodgeGame = preload("res://scripts/minigames/rain_dodge_game.gd")
const RouteRestoreGame = preload("res://scripts/minigames/route_restore_game.gd")

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


func _ready() -> void:
	theme = ThemeFactory.create_theme()
	if GameState.get_current_episode().is_empty():
		GameState.load_episode()

	GameState.set_current_scene_path("res://scenes/minigame_scene.tscn")
	_minigame = GameState.get_current_minigame()
	_apply_runtime_minigame_overrides()
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
	_minigame["description"] = "오현의 공식 운행 기록과 권나래의 현장 보고를 대조해, 강이준이 유지하는 현실 출구까지 피해자 호송 노선을 복원합니다."
	_minigame["rules_text"] = "타일을 회전하고 분기 스위치를 바꿔 안전 목적지까지 연결하세요. 조작 4회가 기본 최적이며 6회 이내 완료하면 정밀 복원으로 기록됩니다. 횟수 초과는 실패가 아닙니다."
	_minigame["optimal_move_count"] = 4
	_minigame["precision_move_limit"] = 6
	_minigame["success_result_text"] = "공식 운행 기록과 일치하는 첫 안전 구간을 복원했습니다. 개인이 인식한 목적지는 실제 방송 원본의 목적지가 아님을 현장에서 확인했습니다."
	_minigame["failure_result_text"] = "노선 검증을 계속할 수 있습니다. 끊긴 구간과 공식 식별 기록을 다시 대조하세요."
	_minigame["success_agent_reaction"] = "오현이 공식 기록과 실제 이동 경로의 일치를 확인합니다. 권나래는 피해자 호송을 재개하고, 강이준은 복원된 현실 경계를 고정합니다."
	_minigame["failure_agent_reaction"] = "세 요원이 현재 노선 상태를 유지한 채 잘못된 경로를 위험 사례로 분리합니다."


func _is_route_restore_minigame() -> bool:
	return String(_minigame.get("type", "")) == "route_restore"


func _build_ui() -> void:
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

	var briefing := _add_section(columns, "검증 규칙", 0.78)
	var description := _make_body_label(String(_minigame.get("description", "현장 검증을 준비합니다.")))
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

	var outcome := _add_section(columns, "현장 기록", 0.9)
	_result_label = _make_body_label("검증이 끝나면 마지막 단서와 요원 반응을 이곳에 기록합니다.")
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
		_game_control.configure(_minigame, not _equipment_hint.is_empty())
	else:
		_show_saved_result(playfield_frame)


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
	_result_label.text = _make_result_text(successful, saved_details)
	_return_button.visible = true
	_return_button.grab_focus()


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
	var key := "success_next_scene_path" if _last_successful else "failure_next_scene_path"
	var scene_path := String(_minigame.get(key, ""))
	if scene_path.is_empty():
		scene_path = String(_minigame.get("return_scene_path", "res://scenes/investigation_scene.tscn"))
	GameState.set_current_scene_path(scene_path)
	GameState.save_game()
	get_tree().change_scene_to_file(scene_path)


func _add_navigation(parent: Control) -> void:
	var notice := Label.new()
	notice.text = "현장 검증 중에는 저장할 수 없습니다. 종료하거나 불러오면 이 미니게임의 처음부터 다시 시작합니다."
	notice.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	notice.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	notice.add_theme_font_size_override("font_size", 13)
	notice.add_theme_color_override("font_color", Color(0.82, 0.68, 0.42))
	parent.add_child(notice)
