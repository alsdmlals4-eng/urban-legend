# 사건 준비 화면에서 요원, 장비, 기록물, 로그 안내를 확인하고 조사 시작을 연결한다.
extends Control

var _equipment_list: VBoxContainer
var _equipped_label: Label
var _modifier_label: Label
var _record_list: VBoxContainer
var _log_list: VBoxContainer
var _status_label: Label


func _ready() -> void:
	if GameState.get_current_episode().is_empty():
		GameState.load_episode()

	GameState.set_current_scene_path(GameState.SCENE_PREPARATION)
	GameState.save_game()
	_build_ui()
	_refresh()


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.052, 0.058, 0.069, 1.0)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	add_child(margin)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(scroll)

	var root := VBoxContainer.new()
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.add_theme_constant_override("separation", 10)
	scroll.add_child(root)

	_add_navigation(root)
	_add_header(root)
	_add_agent_panel(root)
	_add_equipment_panel(root)
	_add_record_panel(root)
	_add_log_panel(root)
	_add_start_panel(root)


func _add_navigation(parent: Control) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	parent.add_child(row)

	_add_scene_button(row, "메뉴", GameState.SCENE_MAIN_MENU)
	_add_scene_button(row, "기록국 DB", "res://scenes/database_view.tscn")
	_add_scene_button(row, "조사", GameState.SCENE_INVESTIGATION)


func _add_header(parent: Control) -> void:
	var title := Label.new()
	title.text = "사건 준비"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	parent.add_child(title)

	var case_label := Label.new()
	case_label.text = "현재 사건: %s\n%s" % [
		GameState.get_current_episode_title(),
		GameState.get_project_core_sentence()
	]
	case_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	case_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	parent.add_child(case_label)


func _add_agent_panel(parent: Control) -> void:
	var panel := PanelContainer.new()
	parent.add_child(panel)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 6)
	panel.add_child(content)

	var title := Label.new()
	title.text = "요원 편성"
	content.add_child(title)

	var summary := Label.new()
	summary.text = "%s\n선택된 요원: %s" % [
		GameState.get_agent_selection_status_text(),
		GameState.get_selected_agent_summary()
	]
	summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(summary)


func _add_equipment_panel(parent: Control) -> void:
	var panel := PanelContainer.new()
	parent.add_child(panel)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 8)
	panel.add_child(content)

	var title := Label.new()
	title.text = "장비 장착"
	content.add_child(title)

	_equipped_label = Label.new()
	_equipped_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(_equipped_label)

	_modifier_label = Label.new()
	_modifier_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(_modifier_label)

	_equipment_list = VBoxContainer.new()
	_equipment_list.add_theme_constant_override("separation", 6)
	content.add_child(_equipment_list)


func _add_record_panel(parent: Control) -> void:
	var panel := PanelContainer.new()
	parent.add_child(panel)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 8)
	panel.add_child(content)

	var title := Label.new()
	title.text = "참고 기록물"
	content.add_child(title)

	_record_list = VBoxContainer.new()
	_record_list.add_theme_constant_override("separation", 6)
	content.add_child(_record_list)


func _add_log_panel(parent: Control) -> void:
	var panel := PanelContainer.new()
	parent.add_child(panel)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 8)
	panel.add_child(content)

	var title := Label.new()
	title.text = "로그 안내 패널"
	content.add_child(title)

	var profile := Label.new()
	profile.text = "로그 / 기관에서 지급한 괴담 기록 단말기 속 안내 AI / 작은 픽셀 유령 또는 말하는 부적 스티커"
	profile.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(profile)

	_log_list = VBoxContainer.new()
	_log_list.add_theme_constant_override("separation", 5)
	content.add_child(_log_list)


func _add_start_panel(parent: Control) -> void:
	_status_label = Label.new()
	_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	parent.add_child(_status_label)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	parent.add_child(row)

	var start_button := Button.new()
	start_button.text = "조사 시작"
	start_button.pressed.connect(_start_investigation)
	row.add_child(start_button)

	var save_button := Button.new()
	save_button.text = "준비 저장"
	save_button.pressed.connect(func() -> void:
		GameState.save_game()
		_status_label.text = "준비 상태를 저장했습니다."
	)
	row.add_child(save_button)


func _refresh() -> void:
	_refresh_equipment()
	_refresh_records()
	_refresh_log()
	_status_label.text = "조사 시작 전 장비와 기록물을 확인하세요."


func _refresh_equipment() -> void:
	var equipped_entries := GameState.get_equipped_equipment_entries()
	if equipped_entries.is_empty():
		_equipped_label.text = "장착 장비: 없음"
	else:
		var names: Array = []
		for item in equipped_entries:
			if typeof(item) == TYPE_DICTIONARY:
				names.append(String(item.get("name", "")))
		_equipped_label.text = "장착 장비: %s" % ", ".join(names)

	_modifier_label.text = "적용될 조사 보정: %s" % GameState.get_next_investigation_modifier_text()
	_clear_children(_equipment_list)

	var equipment_entries := GameState.get_unlocked_equipment_entries()
	if equipment_entries.is_empty():
		_equipment_list.add_child(_make_label("- 해금된 장비가 없습니다. 회수 결과에서 연구 보상을 먼저 확보해야 합니다."))
		return

	for item in equipment_entries:
		if typeof(item) != TYPE_DICTIONARY:
			continue
		var equipment_id := String(item.get("id", ""))
		var equipped := GameState.has_equipped_item(equipment_id)
		var button := Button.new()
		button.text = "%s: %s" % ["장착 해제" if equipped else "장착", String(item.get("name", equipment_id))]
		button.pressed.connect(_toggle_equipment.bind(equipment_id))
		_equipment_list.add_child(button)

		var description := Label.new()
		description.text = "%s\n효과: %s" % [
			String(item.get("description", "")),
			String(item.get("next_investigation_modifier", ""))
		]
		description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_equipment_list.add_child(description)


func _refresh_records() -> void:
	_clear_children(_record_list)
	var records := GameState.get_unlocked_record_entries()
	if records.is_empty():
		_record_list.add_child(_make_label("- 참고 가능한 해금 기록물이 없습니다."))
		return

	for record in records:
		if typeof(record) != TYPE_DICTIONARY:
			continue
		var effect := String(record.get("next_investigation_effect", "다음 조사 전 규칙 확인용 참고 기록입니다."))
		_record_list.add_child(_make_label("- %s\n  %s\n  다음 조사 영향: %s" % [
			String(record.get("title", "")),
			String(record.get("description", "")),
			effect
		]))


func _refresh_log() -> void:
	_clear_children(_log_list)
	for line in GameState.get_preparation_log_lines():
		_log_list.add_child(_make_label("- %s" % String(line)))


func _toggle_equipment(equipment_id: String) -> void:
	if GameState.has_equipped_item(equipment_id):
		GameState.unequip_item(equipment_id)
	else:
		GameState.equip_item(equipment_id)
	_refresh()


func _start_investigation() -> void:
	if not GameState.can_start_mission_with_agents():
		_status_label.text = GameState.get_agent_selection_status_text()
		return

	GameState.set_current_scene_path(GameState.SCENE_INVESTIGATION)
	GameState.save_game()
	get_tree().change_scene_to_file(GameState.SCENE_INVESTIGATION)


func _add_scene_button(parent: Control, label: String, scene_path: String) -> void:
	var button := Button.new()
	button.text = label
	button.pressed.connect(func() -> void:
		GameState.set_current_scene_path(scene_path)
		GameState.save_game()
		get_tree().change_scene_to_file(scene_path)
	)
	parent.add_child(button)


func _make_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label


func _clear_children(parent: Node) -> void:
	if parent == null:
		return

	for child in parent.get_children():
		child.queue_free()
