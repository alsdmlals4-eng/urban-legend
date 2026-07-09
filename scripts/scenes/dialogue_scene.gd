# 대화 씬의 JSON 기반 대사 노드와 선택지 분기를 관리한다.
extends Control

const FALLBACK_LINES: Array[Dictionary] = [
	{"speaker": "연하린", "text": "이 역은 지도에도, 기록국 데이터에도 남아 있지 않아요.", "expression": "default"},
	{"speaker": "신입 요원", "text": "그럼 지금 우리가 보고 있는 전광판은 뭘 기준으로 움직이는 거죠?", "expression": "question"},
	{"speaker": "연하린", "text": "괴담은 믿는 사람의 기억을 노선처럼 씁니다. 선택해야 해요.", "expression": "serious"}
]

var _line_index := 0
var _hint_index := 0
var _dialogue_node: Dictionary = {}
var _waiting_for_result_continue := false
var _pending_next_node_id := ""
var _pending_next_scene_path := ""

var _stage_label: Label
var _standing_label: Label
var _name_label: Label
var _dialogue_label: Label
var _condition_label: Label
var _next_button: Button
var _choice_box: VBoxContainer
var _hint_label: Label
var _clue_status_label: Label


func _ready() -> void:
	if GameState.get_current_episode().is_empty():
		GameState.load_episode()

	GameState.set_current_scene_path("res://scenes/dialogue_scene.tscn")
	_dialogue_node = GameState.get_current_dialogue_node()
	_build_ui()
	_show_line()
	_refresh_clue_status()
	_refresh_condition_label()


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.055, 0.055, 0.075, 1.0)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 10)
	margin.add_child(root)

	_add_navigation(root)

	var title := Label.new()
	title.text = "대화 씬"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root.add_child(title)

	var stage := PanelContainer.new()
	stage.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(stage)

	var stage_scroll := ScrollContainer.new()
	stage_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stage.add_child(stage_scroll)

	var stage_layout := VBoxContainer.new()
	stage_layout.add_theme_constant_override("separation", 10)
	stage_layout.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	stage_scroll.add_child(stage_layout)

	_stage_label = Label.new()
	_stage_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stage_layout.add_child(_stage_label)

	var standing := PanelContainer.new()
	standing.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stage_layout.add_child(standing)

	_standing_label = Label.new()
	_standing_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_standing_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	standing.add_child(_standing_label)

	_name_label = Label.new()
	_name_label.text = "이름"
	stage_layout.add_child(_name_label)

	_dialogue_label = Label.new()
	_dialogue_label.text = "대사"
	_dialogue_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	stage_layout.add_child(_dialogue_label)

	_condition_label = Label.new()
	_condition_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	stage_layout.add_child(_condition_label)

	_next_button = Button.new()
	_next_button.text = "다음 대사"
	_next_button.pressed.connect(_advance_line)
	stage_layout.add_child(_next_button)

	var investigation_button := Button.new()
	investigation_button.text = "조사 시작"
	investigation_button.pressed.connect(func() -> void:
		_go_to_scene("res://scenes/investigation_scene.tscn")
	)
	stage_layout.add_child(investigation_button)

	_choice_box = VBoxContainer.new()
	_choice_box.visible = false
	_choice_box.add_theme_constant_override("separation", 6)
	stage_layout.add_child(_choice_box)

	var hint_panel := PanelContainer.new()
	stage_layout.add_child(hint_panel)

	var hint_content := VBoxContainer.new()
	hint_content.add_theme_constant_override("separation", 6)
	hint_panel.add_child(hint_content)

	var hint_title := Label.new()
	hint_title.text = "동료 힌트 목록"
	hint_content.add_child(hint_title)

	var hint_button := Button.new()
	hint_button.text = "동료 힌트 확인"
	hint_button.pressed.connect(_show_next_hint)
	hint_content.add_child(hint_button)

	_hint_label = Label.new()
	_hint_label.text = "힌트는 아직 찾지 못한 단서의 방향만 알려주며, 단서 수집률에는 반영되지 않습니다."
	_hint_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hint_content.add_child(_hint_label)

	var clue_title := Label.new()
	clue_title.text = "단서 목록"
	hint_content.add_child(clue_title)

	_clue_status_label = Label.new()
	_clue_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hint_content.add_child(_clue_status_label)


func _show_line() -> void:
	var lines := _get_current_lines()
	if lines.is_empty():
		return

	_line_index = clampi(_line_index, 0, lines.size() - 1)
	var line: Dictionary = lines[_line_index]
	_stage_label.text = "배경 placeholder: %s" % String(_dialogue_node.get("background_id", "사라진 승강장"))
	_standing_label.text = "캐릭터 스탠딩 placeholder: %s" % String(_dialogue_node.get("standing_id", "agent_yeon_harin"))
	_name_label.text = String(line.get("speaker", line.get("name", "")))
	_dialogue_label.text = "%s\n[표정: %s]" % [
		String(line.get("text", "")),
		String(line.get("expression", "default"))
	]
	_choice_box.visible = false
	_waiting_for_result_continue = false
	_pending_next_node_id = ""
	_pending_next_scene_path = ""
	_next_button.disabled = false
	_next_button.text = "다음 대사"


func _advance_line() -> void:
	if _waiting_for_result_continue:
		_continue_after_result()
		return

	var lines := _get_current_lines()
	if _line_index < lines.size() - 1:
		_line_index += 1
		_show_line()
		return

	_show_choices()


func _show_choices() -> void:
	_choice_box.visible = true
	_clear_children(_choice_box)

	var choices := _get_current_choices()
	if choices.is_empty():
		var label := Label.new()
		label.text = "표시할 선택지가 없습니다. 조사 시작 버튼으로 이동하세요."
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_choice_box.add_child(label)
		_next_button.disabled = true
		return

	for choice in choices:
		if typeof(choice) == TYPE_DICTIONARY:
			_add_choice(choice)

	_next_button.disabled = true


func _add_choice(choice: Dictionary) -> void:
	var button := Button.new()
	var conditions: Dictionary = choice.get("conditions", {})
	var can_select := GameState.check_conditions(conditions)
	button.text = String(choice.get("text", "선택지"))
	if not can_select:
		button.text += " (조건 미충족)"
		button.disabled = true
	button.pressed.connect(func() -> void:
		_select_choice(choice)
	)
	_choice_box.add_child(button)


func _select_choice(choice: Dictionary) -> void:
	GameState.apply_story_effects(choice)
	_name_label.text = "선택"
	_dialogue_label.text = _make_choice_result_text(choice)
	_choice_box.visible = false
	_pending_next_node_id = String(choice.get("next_node_id", ""))
	_pending_next_scene_path = String(choice.get("next_scene_path", ""))
	_waiting_for_result_continue = true
	_next_button.disabled = false
	_next_button.text = _make_next_button_text()
	_refresh_clue_status()
	_refresh_condition_label()
	GameState.save_game()


func _continue_after_result() -> void:
	if not _pending_next_scene_path.is_empty():
		_go_to_scene(_pending_next_scene_path)
		return

	if not _pending_next_node_id.is_empty():
		_load_dialogue_node(_pending_next_node_id)
		return

	_waiting_for_result_continue = false
	_show_choices()


func _load_dialogue_node(dialogue_node_id: String) -> void:
	var next_node := GameState.get_dialogue_node(dialogue_node_id)
	if next_node.is_empty():
		_dialogue_label.text = "다음 대화 노드를 찾지 못했습니다: %s" % dialogue_node_id
		return

	_dialogue_node = next_node
	GameState.set_current_dialogue_node_id(dialogue_node_id)
	GameState.save_game()
	_line_index = 0
	_show_line()
	_refresh_condition_label()


func _show_next_hint() -> void:
	var hints := GameState.get_available_hints()
	if hints.is_empty():
		_hint_label.text = "현재 조건에서 표시할 힌트가 없습니다. 조사나 선택으로 플래그를 더 확보하세요."
		return

	var hint: Dictionary = hints[_hint_index % hints.size()]
	_hint_index += 1
	var hint_id := String(hint.get("id", ""))
	var was_seen := GameState.has_seen_hint(hint_id)
	GameState.mark_hint_seen(hint_id)
	_hint_label.text = "대상 단서: %s\n힌트: %s\n단서 수집률 변화 없음: %.0f%%" % [
		hint.get("target_clue_id", ""),
		hint.get("text", ""),
		GameState.get_clue_collection_rate()
	]
	if was_seen:
		_hint_label.text += "\n힌트 상태: 이미 확인한 힌트"
	else:
		_hint_label.text += "\n힌트 상태: 새로 확인함"
	_refresh_clue_status()


func _refresh_clue_status() -> void:
	var text := "단서 수집률: %.0f%% (%d/%d)\n" % [
		GameState.get_clue_collection_rate(),
		GameState.get_collected_clue_count(),
		GameState.get_total_clue_count()
	]
	for clue in GameState.get_clues():
		if typeof(clue) != TYPE_DICTIONARY:
			continue

		var state_text := "수집됨" if clue.get("collected", false) else "미수집"
		text += "%s - %s\n" % [state_text, clue.get("title", "")]

	_clue_status_label.text = text.strip_edges()


func _refresh_condition_label() -> void:
	if _condition_label == null:
		return

	_condition_label.text = "현재 대화 노드: %s\n보유 플래그: %s" % [
		String(_dialogue_node.get("id", "fallback")),
		", ".join(GameState.get_flags()) if not GameState.get_flags().is_empty() else "없음"
	]


func _make_choice_result_text(choice: Dictionary) -> String:
	var text := String(choice.get("result_text", "선택 결과가 기록되었습니다."))
	var hint_texts := GameState.get_hint_texts_by_ids(choice.get("show_hint_ids", []))
	if not hint_texts.is_empty():
		text += "\n\n기록된 힌트\n- %s" % "\n- ".join(hint_texts)
	return text


func _make_next_button_text() -> String:
	if not _pending_next_scene_path.is_empty():
		return "다음 장면"
	if not _pending_next_node_id.is_empty():
		return "다음 대화"
	return "선택지 보기"


func _go_to_scene(scene_path: String) -> void:
	GameState.set_current_scene_path(scene_path)
	GameState.save_game()
	get_tree().change_scene_to_file(scene_path)


func _get_current_lines() -> Array:
	var lines: Variant = _dialogue_node.get("lines", [])
	if typeof(lines) == TYPE_ARRAY and not lines.is_empty():
		return lines
	return FALLBACK_LINES


func _get_current_choices() -> Array:
	var choices: Variant = _dialogue_node.get("choices", [])
	if typeof(choices) == TYPE_ARRAY:
		return choices
	return []


func _clear_children(parent: Node) -> void:
	for child in parent.get_children():
		child.queue_free()


func _add_navigation(parent: Control) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	parent.add_child(row)
	_add_scene_button(row, "메뉴", "res://scenes/main_menu.tscn")
	_add_scene_button(row, "조사", "res://scenes/investigation_scene.tscn")
	_add_scene_button(row, "데이터", "res://scenes/case_data_scene.tscn")
	_add_scene_button(row, "전투", "res://scenes/battle_scene.tscn")


func _add_scene_button(parent: Control, label: String, scene_path: String) -> void:
	var button := Button.new()
	button.text = label
	button.pressed.connect(func() -> void:
		_go_to_scene(scene_path)
	)
	parent.add_child(button)
