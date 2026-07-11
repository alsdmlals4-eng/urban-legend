# 사건별 액션 판정을 표시하고 결과를 기존 조사·회수 저장 흐름에 연결한다.
extends Control

const RhythmGame = preload("res://scripts/minigames/rhythm_timing_game.gd")
const RainDodgeGame = preload("res://scripts/minigames/rain_dodge_game.gd")

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
	if GameState.get_current_episode().is_empty():
		GameState.load_episode()

	GameState.set_current_scene_path("res://scenes/minigame_scene.tscn")
	_minigame = GameState.get_current_minigame()
	var minigame_id := String(_minigame.get("id", GameState.get_current_minigame_id()))
	_existing_result = GameState.get_minigame_result(minigame_id)
	if _existing_result.is_empty():
		_equipment_hint = GameState.try_use_frequency_filter_hint(minigame_id)
	_build_ui()


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
	eyebrow.text = "FIELD JUDGEMENT  /  %s" % GameState.get_current_episode_title()
	eyebrow.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	eyebrow.add_theme_font_size_override("font_size", 13)
	eyebrow.add_theme_color_override("font_color", Color(0.48, 0.68, 0.72))
	root.add_child(eyebrow)

	var title := Label.new()
	title.text = String(_minigame.get("title", "현장 판정"))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 26)
	root.add_child(title)

	var columns := HBoxContainer.new()
	columns.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	columns.size_flags_vertical = Control.SIZE_EXPAND_FILL
	columns.add_theme_constant_override("separation", 14)
	root.add_child(columns)

	var briefing := _add_section(columns, "판정 규칙", 0.78)
	var description := _make_body_label(String(_minigame.get("description", "현장 판정을 준비합니다.")))
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
	_status_label.text = "현장 신호를 불러오는 중"
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
	_result_label = _make_body_label("판정이 끝나면 상태 변화와 요원 반응을 이곳에 기록합니다.")
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
	_status_label.text = "판정 기록 완료  |  %s" % ("성공" if _last_successful else "실패")
	_progress_bar.value = 100.0
	var summary := Label.new()
	summary.text = "이 미니게임의 판정은 이미 저장되었습니다.\n\n%s" % String(_existing_result.get("input_summary", "플레이 기록을 확인하세요."))
	summary.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	summary.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	summary.add_theme_font_size_override("font_size", 20)
	playfield_frame.add_child(summary)
	_result_label.text = _make_result_text(_last_successful, _existing_result)
	_return_button.visible = true


func _make_game_control() -> Control:
	if String(_minigame.get("type", "rhythm_timing")) == "rain_dodge":
		return RainDodgeGame.new()
	return RhythmGame.new()


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
	GameState.save_minigame_result(String(_minigame.get("id", GameState.get_current_minigame_id())), successful, saved_details)
	_result_label.text = _make_result_text(successful, saved_details)
	_return_button.visible = true
	_return_button.grab_focus()


func _make_result_text(successful: bool, details: Dictionary) -> String:
	var result_key := "success_result_text" if successful else "failure_result_text"
	var reaction_key := "success_agent_reaction" if successful else "failure_agent_reaction"
	return "%s\n\n%s\n\n상태 변화\n%s\n\n요원 반응\n%s" % [
		"판정 성공" if successful else "판정 실패 · 사건 진행 가능",
		String(_minigame.get(result_key, "판정 결과가 기록되었습니다.")),
		String(details.get("effect_summary", "변화 없음")),
		String(_minigame.get(reaction_key, "팀이 판정 결과를 회수 근거에 반영합니다."))
	]


func _make_effect_summary(successful: bool) -> String:
	var prefix := "success" if successful else "failure"
	return "위험도 %s  ·  이해도 %s\n정신력 %s  ·  안정도 %s\n회수 기준 %s" % [
		_format_delta(int(_minigame.get("%s_anomaly_risk_delta" % prefix, 0))),
		_format_delta(int(_minigame.get("%s_anomaly_understanding_delta" % prefix, 0))),
		_format_delta(int(_minigame.get("%s_mental_stamina_delta" % prefix, 0))),
		_format_delta(int(_minigame.get("%s_anomaly_stability_delta" % prefix, 0))),
		_format_delta(int(_minigame.get("%s_recovery_threshold_delta" % prefix, 0)))
	]


func _format_delta(value: int) -> String:
	return "+%d" % value if value > 0 else str(value)


func _make_play_title() -> String:
	return "빗속 이동" if String(_minigame.get("type", "")) == "rain_dodge" else "폐주파수 동기화"


func _make_control_hint() -> String:
	if String(_minigame.get("type", "")) == "rain_dodge":
		return "조작  방향키"
	return "조작  SPACE / ENTER"


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
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	parent.add_child(row)
	_add_scene_button(row, "메뉴", "res://scenes/main_menu.tscn")
	_add_scene_button(row, "조사", "res://scenes/investigation_scene.tscn")
	_add_scene_button(row, "대화", "res://scenes/dialogue_scene.tscn")
	_add_scene_button(row, "회수", "res://scenes/battle_scene.tscn")


func _add_scene_button(parent: Control, label: String, scene_path: String) -> void:
	var button := Button.new()
	button.text = label
	button.pressed.connect(func() -> void:
		GameState.set_current_scene_path(scene_path)
		GameState.save_game()
		get_tree().change_scene_to_file(scene_path)
	)
	parent.add_child(button)
