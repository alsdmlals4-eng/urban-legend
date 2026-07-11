# 사건별 짧은 동기화 판정과 조사·회수 결과 연결을 관리한다.
extends Control

var _minigame: Dictionary = {}
var _equipment_hint: Dictionary = {}
var _target_sequence: Array[String] = []
var _input_options: Array[Dictionary] = []
var _entered_sequence: Array[String] = []
var _current_step := 0
var _mistakes := 0
var _max_mistakes := 2
var _input_count := 0
var _last_successful := false

var _progress_label: Label
var _result_label: Label
var _progress_bar: ProgressBar
var _input_buttons: Array[Button] = []
var _return_button: Button


func _ready() -> void:
	if GameState.get_current_episode().is_empty():
		GameState.load_episode()

	GameState.set_current_scene_path("res://scenes/minigame_scene.tscn")
	_minigame = GameState.get_current_minigame()
	_equipment_hint = GameState.try_use_frequency_filter_hint(String(_minigame.get("id", GameState.get_current_minigame_id())))
	_load_sequence_rules()
	_build_ui()
	_update_result(_make_intro_text())


func _load_sequence_rules() -> void:
	for value in _minigame.get("target_sequence", []):
		_target_sequence.append(String(value))
	for option in _minigame.get("input_options", []):
		if typeof(option) == TYPE_DICTIONARY:
			_input_options.append(option)

	if _target_sequence.is_empty():
		_target_sequence = ["signal", "silence", "signal"]
	if _input_options.is_empty():
		_input_options = [
			{"id": "signal", "label": "신호"},
			{"id": "silence", "label": "정적"}
		]

	_max_mistakes = max(1, int(_minigame.get("max_mistakes", 2)))
	if not _equipment_hint.is_empty():
		_max_mistakes += 1


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.035, 0.055, 0.065, 1.0)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_top", 18)
	margin.add_theme_constant_override("margin_right", 24)
	margin.add_theme_constant_override("margin_bottom", 18)
	add_child(margin)

	var root := VBoxContainer.new()
	root.custom_minimum_size = Vector2(960, 0)
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.add_theme_constant_override("separation", 12)
	margin.add_child(root)

	_add_navigation(root)
	var title := Label.new()
	title.text = "현장 판정 / %s" % String(_minigame.get("title", "동기화"))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root.add_child(title)

	var columns := HBoxContainer.new()
	columns.size_flags_vertical = Control.SIZE_EXPAND_FILL
	columns.add_theme_constant_override("separation", 12)
	root.add_child(columns)

	var briefing := _add_section(columns, "판정 규칙", "조사 중 확보한 신호를 짧게 대조합니다. 실패해도 사건은 계속됩니다.")
	var briefing_panel := briefing.get_parent() as Control
	briefing_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	briefing_panel.size_flags_stretch_ratio = 0.9
	var description := Label.new()
	description.text = String(_minigame.get("description", "미니게임 설명이 없습니다."))
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	briefing.add_child(description)
	var rule_label := Label.new()
	rule_label.text = String(_minigame.get("rules_text", "표시된 순서대로 신호를 선택하세요."))
	rule_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	briefing.add_child(rule_label)
	if not _equipment_hint.is_empty():
		var equipment_label := Label.new()
		equipment_label.text = "장비 보정: %s\n%s\n허용 오류 +1" % [String(_equipment_hint.get("equipment_name", "폐주파수 필터")), String(_equipment_hint.get("effect_text", ""))]
		equipment_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		briefing.add_child(equipment_label)

	var interaction := _add_section(columns, "신호 입력", "목표 순서를 읽고 입력을 완성하세요.")
	var interaction_panel := interaction.get_parent() as Control
	interaction_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	interaction_panel.size_flags_stretch_ratio = 1.25
	var target_label := Label.new()
	target_label.text = "목표: %s" % _make_target_sequence_text()
	target_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	target_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	interaction.add_child(target_label)
	_progress_bar = ProgressBar.new()
	_progress_bar.min_value = 0
	_progress_bar.max_value = _target_sequence.size()
	interaction.add_child(_progress_bar)
	_progress_label = Label.new()
	_progress_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	interaction.add_child(_progress_label)
	var input_grid := GridContainer.new()
	input_grid.columns = min(3, _input_options.size())
	input_grid.add_theme_constant_override("h_separation", 8)
	input_grid.add_theme_constant_override("v_separation", 8)
	interaction.add_child(input_grid)
	for option in _input_options:
		_add_input_button(input_grid, option)
	_return_button = Button.new()
	_return_button.text = "조사 흐름으로 돌아가기"
	_return_button.visible = false
	_return_button.pressed.connect(_return_to_flow)
	interaction.add_child(_return_button)

	var outcome := _add_section(columns, "판정 결과", "결과는 현장 상태, 회수 조건, 사건 보고서와 DB에 기록됩니다.")
	var outcome_panel := outcome.get_parent() as Control
	outcome_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	outcome_panel.size_flags_stretch_ratio = 1.0
	_result_label = Label.new()
	_result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	outcome.add_child(_result_label)
	_refresh_progress()


func _add_section(parent: Control, title_text: String, description_text: String) -> VBoxContainer:
	var panel := PanelContainer.new()
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	parent.add_child(panel)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 10)
	panel.add_child(content)
	var title := Label.new()
	title.text = title_text
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(title)
	var description := Label.new()
	description.text = description_text
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(description)
	return content


func _add_input_button(parent: Control, option: Dictionary) -> void:
	var button := Button.new()
	button.text = String(option.get("label", option.get("id", "신호")))
	button.custom_minimum_size = Vector2(0, 64)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var option_id := String(option.get("id", ""))
	button.pressed.connect(func() -> void: _submit_input(option_id))
	parent.add_child(button)
	_input_buttons.append(button)


func _submit_input(option_id: String) -> void:
	if _current_step >= _target_sequence.size():
		return
	_input_count += 1
	_entered_sequence.append(_get_option_label(option_id))
	if option_id == _target_sequence[_current_step]:
		_current_step += 1
		_progress_bar.value = _current_step
		if _current_step >= _target_sequence.size():
			_complete_minigame(true)
		else:
			_update_result("신호 %d/%d 일치. 다음 박자를 선택하세요." % [_current_step, _target_sequence.size()])
	else:
		_mistakes += 1
		_current_step = 0
		_progress_bar.value = 0
		if _mistakes >= _max_mistakes:
			_complete_minigame(false)
		else:
			_update_result("순서가 어긋났습니다. 처음부터 다시 맞추세요. 남은 오류 허용 %d회" % (_max_mistakes - _mistakes))
	_refresh_progress()


func _complete_minigame(successful: bool) -> void:
	_last_successful = successful
	var minigame_id := String(_minigame.get("id", GameState.get_current_minigame_id()))
	GameState.save_minigame_result(minigame_id, successful, {
		"attempt_count": _input_count,
		"mistake_count": _mistakes,
		"input_summary": " → ".join(_entered_sequence),
		"effect_summary": _make_effect_summary(successful)
	})
	for button in _input_buttons:
		button.disabled = true
	_return_button.visible = true
	_update_result(_make_result_text(successful))


func _make_intro_text() -> String:
	return "목표 신호를 확인하고 순서대로 입력하세요.\n허용 오류: %d회 / 실패해도 조사와 회수는 계속됩니다." % _max_mistakes


func _make_result_text(successful: bool) -> String:
	var outcome := "성공" if successful else "실패"
	var text_key := "success_result_text" if successful else "failure_result_text"
	var result_text := String(_minigame.get(text_key, "미니게임 결과가 기록되었습니다."))
	var reaction_key := "success_agent_reaction" if successful else "failure_agent_reaction"
	var agent_reaction := String(_minigame.get(reaction_key, "요원 팀이 판정 결과를 회수 근거에 반영합니다."))
	return "판정: %s\n결과: %s\n\n상태 변화\n%s\n\n요원 반응\n%s\n\n다음 행동\n조사 현장으로 돌아가 남은 단서를 확인하거나 회수/안정화에 진입하세요." % [outcome, result_text, _make_effect_summary(successful), agent_reaction]


func _make_effect_summary(successful: bool) -> String:
	var prefix := "success" if successful else "failure"
	return "위험도 %s / 이해도 %s / 정신력 %s / 괴이 안정도 %s / 회수 기준 %s" % [
		_format_delta(int(_minigame.get("%s_anomaly_risk_delta" % prefix, 0))),
		_format_delta(int(_minigame.get("%s_anomaly_understanding_delta" % prefix, 0))),
		_format_delta(int(_minigame.get("%s_mental_stamina_delta" % prefix, 0))),
		_format_delta(int(_minigame.get("%s_anomaly_stability_delta" % prefix, 0))),
		_format_delta(int(_minigame.get("%s_recovery_threshold_delta" % prefix, 0)))
	]


func _format_delta(value: int) -> String:
	return "+%d" % value if value > 0 else str(value)


func _make_target_sequence_text() -> String:
	var labels: Array[String] = []
	for option_id in _target_sequence:
		labels.append(_get_option_label(option_id))
	return " → ".join(labels)


func _get_option_label(option_id: String) -> String:
	for option in _input_options:
		if String(option.get("id", "")) == option_id:
			return String(option.get("label", option_id))
	return option_id


func _refresh_progress() -> void:
	if _progress_label != null:
		_progress_label.text = "일치 %d/%d  |  오류 %d/%d" % [_current_step, _target_sequence.size(), _mistakes, _max_mistakes]


func _return_to_flow() -> void:
	var key := "success_next_scene_path" if _last_successful else "failure_next_scene_path"
	var scene_path := String(_minigame.get(key, ""))
	if scene_path.is_empty():
		scene_path = String(_minigame.get("return_scene_path", "res://scenes/investigation_scene.tscn"))
	GameState.set_current_scene_path(scene_path)
	GameState.save_game()
	get_tree().change_scene_to_file(scene_path)


func _update_result(text: String) -> void:
	if _result_label != null:
		_result_label.text = text


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
