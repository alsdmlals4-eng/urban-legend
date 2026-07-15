extends Control

const ThemeFactory = preload("res://scripts/ui/ui_theme_factory.gd")

var _content: VBoxContainer
var _result_box: VBoxContainer
var _choice_box: VBoxContainer
var _relationship_mode := false


func _ready() -> void:
	theme = ThemeFactory.create_theme()
	_relationship_mode = not GameState.active_relationship_scene.is_empty()
	if GameState.get_active_daily_episode().is_empty() and not _relationship_mode:
		_return_to_preparation()
		return
	GameState.set_current_scene_path(GameState.SCENE_DAILY_EPISODE)
	GameState.save_game()
	_build_ui()


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.045, 0.048, 0.06, 1.0)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 96)
	margin.add_theme_constant_override("margin_top", 54)
	margin.add_theme_constant_override("margin_right", 96)
	margin.add_theme_constant_override("margin_bottom", 54)
	add_child(margin)

	var panel := PanelContainer.new()
	margin.add_child(panel)
	_content = VBoxContainer.new()
	_content.add_theme_constant_override("separation", 14)
	panel.add_child(_content)

	var episode := GameState.get_active_daily_episode_data()
	if _relationship_mode:
		episode = GameState.active_relationship_scene.duplicate(true)
	var title := Label.new()
	title.text = "일상 에피소드 · %s" % String(episode.get("title", "기록 확인"))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_content.add_child(title)

	var meta := Label.new()
	meta.text = "%s / %s\n일정 소모 없음 · 완료 기록과 선택형 이해도 보상만 남습니다." % [
		String(episode.get("agent_name", "요원")),
		String(episode.get("case_title", "관련 사건"))
	]
	meta.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	meta.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_content.add_child(meta)

	var intro := Label.new()
	intro.text = String(episode.get("intro", ""))
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	intro.custom_minimum_size.y = 126
	_content.add_child(intro)

	var prompt := Label.new()
	prompt.text = "어떤 기록을 남길까요?"
	prompt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_content.add_child(prompt)

	_choice_box = VBoxContainer.new()
	_choice_box.name = "DailyEpisodeChoices"
	_choice_box.add_theme_constant_override("separation", 8)
	_content.add_child(_choice_box)
	for choice_value in episode.get("choices", []):
		if typeof(choice_value) != TYPE_DICTIONARY:
			continue
		var choice: Dictionary = choice_value
		var button := Button.new()
		button.name = "DailyChoice_%s" % String(choice.get("id", "choice"))
		button.text = String(choice.get("label", "기록을 남긴다"))
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.custom_minimum_size.y = 54
		button.pressed.connect(func() -> void: _resolve_choice(String(choice.get("id", ""))))
		_choice_box.add_child(button)

	_result_box = VBoxContainer.new()
	_result_box.name = "DailyEpisodeResult"
	_result_box.add_theme_constant_override("separation", 8)
	_content.add_child(_result_box)


func _resolve_choice(choice_id: String) -> void:
	var result := GameState.resolve_relationship_choice(choice_id) if _relationship_mode else GameState.resolve_daily_episode_choice(choice_id)
	if not bool(result.get("successful", false)):
		_show_result("기록을 확정하지 못했습니다. HQ 준비 화면으로 돌아가 다시 확인하세요.", "")
		return
	for child in _choice_box.get_children():
		if child is Button:
			(child as Button).disabled = true
	var record: Dictionary = result.get("record", {})
	_show_result(String(record.get("result_text", record.get("result", "기록을 남겼습니다."))), String(record.get("agent_reaction", "")))


func _show_result(result_text: String, reaction: String) -> void:
	_clear_children(_result_box)
	var result_label := Label.new()
	result_label.text = "즉시 결과\n%s" % result_text
	result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_result_box.add_child(result_label)
	if not reaction.is_empty():
		var reaction_label := Label.new()
		reaction_label.text = reaction
		reaction_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_result_box.add_child(reaction_label)
	var reward_label := Label.new()
	reward_label.text = "기록국 DB에 선택이 남았습니다. 보상은 기존 사건별 일상 이해도 상한 안에서만 적용됩니다."
	reward_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_result_box.add_child(reward_label)
	var return_button := Button.new()
	return_button.name = "ReturnToPreparationButton"
	return_button.text = "HQ 준비 화면으로 돌아가기"
	return_button.pressed.connect(_return_to_preparation)
	_result_box.add_child(return_button)


func _return_to_preparation() -> void:
	GameState.set_current_scene_path(GameState.SCENE_PREPARATION)
	GameState.save_game()
	get_tree().change_scene_to_file(GameState.SCENE_PREPARATION)


func _clear_children(parent: Node) -> void:
	for child in parent.get_children():
		child.queue_free()
