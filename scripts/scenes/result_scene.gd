# 결과 화면의 회수 결과, 연구 보상, 기록물과 장비 해금을 표시한다.
extends Control


func _ready() -> void:
	if GameState.get_current_episode().is_empty():
		GameState.load_episode()

	GameState.set_current_scene_path("res://scenes/result_scene.tscn")
	GameState.save_game()
	_build_ui()


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.045, 0.048, 0.06, 1.0)
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

	var title := Label.new()
	title.text = "결과 / 연구 보상"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root.add_child(title)

	_add_result_panel(root)
	_add_navigation_buttons(root)


func _add_result_panel(parent: Control) -> void:
	var panel := PanelContainer.new()
	parent.add_child(panel)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 8)
	panel.add_child(content)

	content.add_child(_make_label("에피소드명: %s" % GameState.get_current_episode_title()))
	content.add_child(_make_label("해결 등급: %s" % GameState.get_result_resolution_label()))
	content.add_child(_make_label("피해자 구조 결과: %s" % GameState.get_current_victim_rescue_result()))
	content.add_child(_make_label("피해자 후일담: %s" % GameState.get_current_victim_after_story()))
	content.add_child(_make_label("괴이 핵 회수 상태: %s" % _make_recovery_status_text()))
	content.add_child(_make_label("연구 결과: %s" % GameState.get_current_research_result()))
	_add_unlock_list(content, "기록물 획득", GameState.get_current_result_unlocked_records(), "title", "description")
	_add_unlock_list(content, "연구 보상", GameState.get_current_result_unlocked_research_rewards(), "ability_name", "ability_description")
	_add_unlock_list(content, "장비 해금", GameState.get_current_result_unlocked_equipment(), "name", "description")
	content.add_child(_make_label("다음 조사 보정: %s" % GameState.get_next_investigation_modifier_text()))

	var reward := GameState.get_current_result_research_reward()
	if reward.is_empty():
		content.add_child(_make_label("기존 연구 보상: 없음"))
		return

	content.add_child(_make_label("기존 연구 보상명: %s" % reward.get("ability_name", "")))
	content.add_child(_make_label("기존 연구 보상 설명: %s" % reward.get("ability_description", "")))
	content.add_child(_make_label("다음 사건 영향: %s" % reward.get("next_episode_effect", "")))


func _add_unlock_list(parent: Control, title: String, entries: Array, name_key: String, description_key: String) -> void:
	if entries.is_empty():
		parent.add_child(_make_label("%s: 없음" % title))
		return

	var lines: Array = []
	for entry in entries:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		lines.append("%s - %s" % [
			String(entry.get(name_key, "")),
			String(entry.get(description_key, ""))
		])
	parent.add_child(_make_label("%s\n- %s" % [title, "\n- ".join(lines)]))


func _add_navigation_buttons(parent: Control) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	parent.add_child(row)

	var menu_button := Button.new()
	menu_button.text = "메인 메뉴로"
	menu_button.pressed.connect(func() -> void:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	)
	row.add_child(menu_button)

	var restart_button := Button.new()
	restart_button.text = "저승역 다시 시작"
	restart_button.pressed.connect(func() -> void:
		var selected_agent_ids := GameState.get_selected_agent_ids()
		GameState.clear_save_file()
		GameState.restart_afterlife_station_flow(selected_agent_ids)
		GameState.set_current_scene_path(GameState.SCENE_PREPARATION)
		GameState.save_game()
		get_tree().change_scene_to_file(GameState.SCENE_PREPARATION)
	)
	row.add_child(restart_button)

	var prepare_button := Button.new()
	prepare_button.text = "사건 준비로"
	prepare_button.pressed.connect(func() -> void:
		GameState.set_current_scene_path(GameState.SCENE_PREPARATION)
		GameState.save_game()
		get_tree().change_scene_to_file(GameState.SCENE_PREPARATION)
	)
	row.add_child(prepare_button)

	var investigate_button := Button.new()
	investigate_button.text = "조사로"
	investigate_button.pressed.connect(func() -> void:
		GameState.set_current_scene_path("res://scenes/investigation_scene.tscn")
		GameState.save_game()
		get_tree().change_scene_to_file("res://scenes/investigation_scene.tscn")
	)
	row.add_child(investigate_button)


func _make_recovery_status_text() -> String:
	if GameState.is_recovery_successful():
		return "회수 성공 / 상태: %s / 안정도 %d" % [
			GameState.get_recovery_result_status(),
			GameState.get_recovery_result_stability()
		]
	return "회수 기록 없음"


func _make_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label
