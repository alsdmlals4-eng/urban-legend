extends Control

const ThemeFactory = preload("res://scripts/ui/ui_theme_factory.gd")
const AssetCatalog = preload("res://scripts/ui/ui_asset_catalog.gd")
const AccessibilitySettings = preload("res://scripts/ui/accessibility_settings.gd")
const PresentationRegistry = preload("res://scripts/ui/presentation_registry.gd")
const PresentationStage = preload("res://scripts/ui/presentation_stage.gd")

var _content: VBoxContainer
var _result_box: VBoxContainer
var _choice_box: VBoxContainer
var _relationship_mode := false
var _presentation_registry := PresentationRegistry.new()
var _presentation_stage := PresentationStage.new()
var _accessibility := AccessibilitySettings.new()


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
	title.name = "EpisodeCategoryTitle"
	title.text = "%s · %s" % [_get_category_label(String(episode.get("category", "daily"))), String(episode.get("title", "기록 확인"))]
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
	if _relationship_mode:
		_add_relationship_presentation(episode)

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


func _add_relationship_presentation(episode: Dictionary) -> void:
	var strip := HBoxContainer.new()
	strip.name = "RelationshipPresentationStrip"
	strip.alignment = BoxContainer.ALIGNMENT_CENTER
	strip.add_theme_constant_override("separation", 18)
	_content.add_child(strip)
	var pair_key := String(episode.get("pair_key", ""))
	for participant_id in pair_key.split("::", false):
		_add_relationship_participant(strip, String(participant_id))

	var cutin_id := _presentation_registry.get_relationship_cutin(String(episode.get("id", "")))
	if cutin_id.is_empty():
		return
	_presentation_stage.present_cutin(cutin_id)
	var cutin := PanelContainer.new()
	cutin.name = "RelationshipCutin"
	cutin.tooltip_text = "표현 연출입니다. 선택 결과나 저장 상태를 바꾸지 않습니다."
	cutin.modulate = Color(1.0, 1.0, 1.0, 0.0)
	_content.add_child(cutin)
	var label := Label.new()
	label.text = "기록 연출 · %s" % _presentation_registry.get_cutin_label(cutin_id)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cutin.add_child(label)
	var duration := lerpf(0.01, 0.14, _accessibility.get_strength("cutin_motion"))
	var tween := create_tween()
	tween.tween_property(cutin, "modulate:a", 1.0, duration)


func _add_relationship_participant(parent: HBoxContainer, participant_id: String) -> void:
	var card := VBoxContainer.new()
	card.custom_minimum_size = Vector2(144, 118)
	card.add_theme_constant_override("separation", 4)
	parent.add_child(card)
	var catalog := AssetCatalog.new()
	var texture := catalog.get_agent_production_texture(participant_id, "portrait")
	if texture == null:
		texture = _get_relationship_contact_texture(catalog, participant_id)
	if texture != null:
		var portrait := TextureRect.new()
		portrait.custom_minimum_size = Vector2(96, 86)
		portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		portrait.texture = texture
		card.add_child(portrait)
	var name_label := Label.new()
	name_label.text = _get_relationship_participant_name(participant_id)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	card.add_child(name_label)


func _get_relationship_contact_texture(catalog: AssetCatalog, participant_id: String) -> Texture2D:
	var contact_id := ""
	if participant_id.contains("park_doyoon"):
		contact_id = "park_doyoon"
	elif participant_id.contains("lee_serin"):
		contact_id = "lee_serin"
	elif participant_id.contains("raymond_kane"):
		contact_id = "raymond_kane"
	elif participant_id.contains("camila_vargas"):
		contact_id = "camila_vargas"
	return catalog.get_contact_texture(contact_id, "portrait") if not contact_id.is_empty() else null


func _get_relationship_participant_name(participant_id: String) -> String:
	var agent := GameState.get_agent_by_id(participant_id)
	if not agent.is_empty():
		return String(agent.get("name", participant_id))
	var names := {
		"faction_rumor_market_park_doyoon": "박도윤",
		"faction_mage_society_lee_serin": "이세린",
		"mercenary_raymond_kane": "레이먼드 케인",
		"exorcist_camila_vargas": "카밀라 바르가스"
	}
	return String(names.get(participant_id, participant_id))


func _get_category_label(category: String) -> String:
	match category:
		"after":
			return "후일담 기록"
		"faction":
			return "세력 교류"
		_:
			return "기록국 일상"


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
