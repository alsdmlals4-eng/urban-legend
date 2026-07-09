# 사건 데이터 확인 화면의 단서 수집률과 저승역 데이터를 표시한다.
extends Control

var _summary_label: Label
var _progress_label: Label
var _progress_bar: ProgressBar
var _resolution_label: Label
var _clue_list: VBoxContainer
var _hint_list: VBoxContainer
var _reward_label: Label


func _ready() -> void:
	if GameState.get_current_episode().is_empty():
		GameState.load_episode()

	_build_ui()
	_refresh_data_view()


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.045, 0.045, 0.055, 1.0)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 18)
	add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 10)
	margin.add_child(root)

	_add_navigation(root)
	_add_title(root)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(scroll)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 10)
	scroll.add_child(content)

	_summary_label = Label.new()
	_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(_summary_label)

	var progress_panel := PanelContainer.new()
	content.add_child(progress_panel)

	var progress_content := VBoxContainer.new()
	progress_content.add_theme_constant_override("separation", 8)
	progress_panel.add_child(progress_content)

	_progress_label = Label.new()
	_progress_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	progress_content.add_child(_progress_label)

	_progress_bar = ProgressBar.new()
	_progress_bar.min_value = 0
	_progress_bar.max_value = 100
	progress_content.add_child(_progress_bar)

	_resolution_label = Label.new()
	_resolution_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	progress_content.add_child(_resolution_label)

	var action_row := HBoxContainer.new()
	action_row.add_theme_constant_override("separation", 8)
	progress_content.add_child(action_row)

	var collect_next_button := Button.new()
	collect_next_button.text = "테스트: 다음 단서 수집"
	collect_next_button.pressed.connect(_collect_next_clue)
	action_row.add_child(collect_next_button)

	var reset_button := Button.new()
	reset_button.text = "수집 초기화"
	reset_button.pressed.connect(func() -> void:
		GameState.reset_clue_collection()
		_refresh_data_view()
	)
	action_row.add_child(reset_button)

	content.add_child(_make_section_label("단서 목록"))
	_clue_list = VBoxContainer.new()
	_clue_list.add_theme_constant_override("separation", 6)
	content.add_child(_clue_list)

	content.add_child(_make_section_label("힌트 목록"))
	_hint_list = VBoxContainer.new()
	_hint_list.add_theme_constant_override("separation", 6)
	content.add_child(_hint_list)

	content.add_child(_make_section_label("현재 해결 등급 연구 보상"))
	_reward_label = Label.new()
	_reward_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(_reward_label)


func _add_title(parent: Control) -> void:
	var title := Label.new()
	title.text = "MVP-002 사건 데이터 확인"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	parent.add_child(title)


func _refresh_data_view() -> void:
	var episode_data := GameState.get_current_episode()
	var episode: Dictionary = episode_data.get("episode", {})
	var victims := GameState.get_victims()
	var victim_text := "피해자 데이터 없음"
	if not victims.is_empty() and typeof(victims[0]) == TYPE_DICTIONARY:
		var victim: Dictionary = victims[0]
		victim_text = "%s / 상태: %s / 마지막 위치: %s" % [
			victim.get("name", ""),
			victim.get("status", ""),
			victim.get("last_seen_location", "")
		]

	_summary_label.text = "에피소드: %s\n괴담 유형: %s\n괴이의 핵: %s\n피해자: %s" % [
		episode.get("title", ""),
		episode.get("legend_type", ""),
		episode.get("anomaly_core", ""),
		victim_text
	]

	var collected_count := GameState.get_collected_clue_count()
	var total_count := GameState.get_total_clue_count()
	var collection_rate := GameState.get_clue_collection_rate()
	_progress_label.text = "단서 수집률: %.0f%% (%d/%d)" % [collection_rate, collected_count, total_count]
	_progress_bar.value = collection_rate
	_resolution_label.text = "현재 해결 단계: %s" % GameState.get_resolution_label()

	_refresh_clues()
	_refresh_hints()
	_refresh_reward()


func _refresh_clues() -> void:
	_clear_children(_clue_list)
	for clue in GameState.get_clues():
		if typeof(clue) != TYPE_DICTIONARY:
			continue

		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 8)
		_clue_list.add_child(row)

		var state_label := Label.new()
		state_label.text = "수집됨" if clue.get("collected", false) else "미수집"
		state_label.custom_minimum_size = Vector2(54, 0)
		row.add_child(state_label)

		var detail := Label.new()
		detail.text = clue.get("title", "")
		detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		detail.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(detail)

		var collect_button := Button.new()
		collect_button.text = "수집"
		collect_button.disabled = clue.get("collected", false)
		var clue_id := String(clue.get("id", ""))
		collect_button.pressed.connect(func() -> void:
			GameState.collect_clue(clue_id)
			_refresh_data_view()
		)
		row.add_child(collect_button)


func _refresh_hints() -> void:
	_clear_children(_hint_list)
	for hint in GameState.get_hints():
		if typeof(hint) != TYPE_DICTIONARY:
			continue

		var label := Label.new()
		label.text = "- %s\n  대상 단서: %s" % [hint.get("text", ""), hint.get("target_clue_id", "")]
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_hint_list.add_child(label)


func _refresh_reward() -> void:
	var reward := GameState.get_current_research_reward()
	if reward.is_empty():
		_reward_label.text = "현재 단계에서는 받을 연구 보상이 없습니다."
		return

	_reward_label.text = "%s\n%s\n다음 사건 영향: %s" % [
		reward.get("ability_name", ""),
		reward.get("ability_description", ""),
		reward.get("next_episode_effect", "")
	]


func _collect_next_clue() -> void:
	for clue in GameState.get_clues():
		if typeof(clue) == TYPE_DICTIONARY and not clue.get("collected", false):
			GameState.collect_clue(String(clue.get("id", "")))
			_refresh_data_view()
			return


func _add_navigation(parent: Control) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	parent.add_child(row)
	_add_scene_button(row, "메뉴", "res://scenes/main_menu.tscn")
	_add_scene_button(row, "조사", "res://scenes/investigation_scene.tscn")
	_add_scene_button(row, "대화", "res://scenes/dialogue_scene.tscn")
	_add_scene_button(row, "전투", "res://scenes/battle_scene.tscn")


func _add_scene_button(parent: Control, label: String, scene_path: String) -> void:
	var button := Button.new()
	button.text = label
	button.pressed.connect(func() -> void:
		get_tree().change_scene_to_file(scene_path)
	)
	parent.add_child(button)


func _make_section_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	return label


func _clear_children(parent: Node) -> void:
	for child in parent.get_children():
		child.queue_free()
