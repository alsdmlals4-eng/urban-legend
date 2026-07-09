# 데이터베이스 화면의 섹션 선택과 MVP-013 해금 상태 표시를 관리한다.
extends Control

var _section_list: VBoxContainer
var _detail_title: Label
var _detail_summary: Label
var _detail_items: VBoxContainer


func _ready() -> void:
	if GameState.get_current_episode().is_empty():
		GameState.load_episode()
	_build_ui()
	_show_section("overview")


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.045, 0.047, 0.055, 1.0)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 24)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 24)
	add_child(margin)

	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 12)
	margin.add_child(layout)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	layout.add_child(header)

	var back_button := Button.new()
	back_button.text = "뒤로"
	back_button.pressed.connect(_back_to_menu)
	header.add_child(back_button)

	var prepare_button := Button.new()
	prepare_button.text = "사건 준비"
	prepare_button.pressed.connect(_open_preparation)
	header.add_child(prepare_button)

	var title := Label.new()
	title.text = "기록국 데이터베이스"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header.add_child(title)

	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 10)
	layout.add_child(body)

	var left_panel := PanelContainer.new()
	left_panel.custom_minimum_size = Vector2(170, 0)
	body.add_child(left_panel)

	_section_list = VBoxContainer.new()
	_section_list.add_theme_constant_override("separation", 6)
	left_panel.add_child(_section_list)

	var right_panel := PanelContainer.new()
	right_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_child(right_panel)

	var detail := VBoxContainer.new()
	detail.add_theme_constant_override("separation", 10)
	right_panel.add_child(detail)

	_detail_title = Label.new()
	_detail_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_detail_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail.add_child(_detail_title)

	_detail_summary = Label.new()
	_detail_summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail.add_child(_detail_summary)

	_detail_items = VBoxContainer.new()
	_detail_items.add_theme_constant_override("separation", 6)
	detail.add_child(_detail_items)

	_build_section_buttons()


func _build_section_buttons() -> void:
	for section in UrbanLegendState.get_sections():
		var button := Button.new()
		button.text = section.get("title", "섹션")
		button.pressed.connect(func() -> void:
			_show_section(section.get("id", "overview"))
		)
		_section_list.add_child(button)

	var mvp13_button := Button.new()
	mvp13_button.text = "MVP-013 보상"
	mvp13_button.pressed.connect(func() -> void:
		_show_section("mvp13_rewards")
	)
	_section_list.add_child(mvp13_button)


func _show_section(section_id: String) -> void:
	if section_id == "mvp13_rewards":
		_show_mvp13_rewards()
		return

	var section := UrbanLegendState.get_section(section_id)
	_detail_title.text = section.get("title", "섹션")
	_detail_summary.text = section.get("summary", "")
	_clear_detail_items()

	for item in section.get("items", []):
		var label := Label.new()
		label.text = "- %s" % item
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_detail_items.add_child(label)


func _show_mvp13_rewards() -> void:
	_detail_title.text = "MVP-013 기록물 / 연구 보상 / 장비"
	_detail_summary.text = "회수 결과로 해금된 기록국 보상 상태입니다. 완성형 도감이 아니라 현재 해금 여부를 확인하는 1차 DB 화면입니다."
	_clear_detail_items()
	_add_dynamic_entry_list("해금 기록물", GameState.get_unlocked_record_entries(), "title", "description")
	_add_dynamic_entry_list("연구 보상", GameState.get_unlocked_research_reward_entries(), "ability_name", "ability_description")
	_add_dynamic_entry_list("해금 장비", GameState.get_unlocked_equipment_entries(), "name", "description")
	_add_dynamic_entry_list("장착 장비", GameState.get_equipped_equipment_entries(), "name", "description")
	var modifier_label := Label.new()
	modifier_label.text = "- 다음 조사 보정: %s" % GameState.get_next_investigation_modifier_text()
	modifier_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_detail_items.add_child(modifier_label)


func _add_dynamic_entry_list(title: String, entries: Array, name_key: String, description_key: String) -> void:
	var title_label := Label.new()
	title_label.text = title
	title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_detail_items.add_child(title_label)
	if entries.is_empty():
		var empty_label := Label.new()
		empty_label.text = "- 아직 해금된 항목이 없습니다."
		empty_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_detail_items.add_child(empty_label)
		return

	for entry in entries:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var label := Label.new()
		label.text = "- %s: %s" % [
			String(entry.get(name_key, "")),
			String(entry.get(description_key, ""))
		]
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_detail_items.add_child(label)


func _clear_detail_items() -> void:
	for child in _detail_items.get_children():
		child.queue_free()


func _back_to_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _open_preparation() -> void:
	GameState.set_current_scene_path(GameState.SCENE_PREPARATION)
	GameState.save_game()
	get_tree().change_scene_to_file(GameState.SCENE_PREPARATION)
