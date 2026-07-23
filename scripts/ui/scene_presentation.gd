class_name ScenePresentation
extends RefCounted

const AssetCatalog = preload("res://scripts/ui/ui_asset_catalog.gd")
const ThemeFactory = preload("res://scripts/ui/ui_theme_factory.gd")
const InvestigationDisclosure = preload("res://scripts/ui/investigation_progressive_disclosure.gd")


static func apply_background(scene: Control, role: String) -> TextureRect:
	scene.theme = ThemeFactory.create_theme()
	if role == "investigation":
		var disclosure := InvestigationDisclosure.new()
		scene.add_child(disclosure)
		disclosure.bind(scene)
	var texture_rect := scene.get_node_or_null("ArtLayer/Background") as TextureRect
	if texture_rect == null:
		return null
	var catalog := AssetCatalog.new()
	var asset_id := catalog.get_background_id(GameState.get_current_episode_id(), role)
	texture_rect.texture = catalog.get_texture(asset_id)
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	return texture_rect


static func populate_agent_strip(parent: Control, agents: Array, speaker_name: String = "") -> void:
	for child in parent.get_children():
		child.queue_free()
	var catalog := AssetCatalog.new()
	for agent in agents:
		if typeof(agent) != TYPE_DICTIONARY:
			continue
		var portrait := TextureRect.new()
		portrait.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		portrait.size_flags_vertical = Control.SIZE_EXPAND_FILL
		portrait.texture = catalog.get_agent_expression(String(agent.get("id", "")), 1 if String(agent.get("name", "")) == speaker_name else 0)
		portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		portrait.custom_minimum_size = Vector2(180, 0)
		portrait.tooltip_text = "%s · %s" % [String(agent.get("name", "요원")), String(agent.get("specialty", "현장 지원"))]
		portrait.modulate = Color.WHITE if String(agent.get("name", "")) == speaker_name or speaker_name.is_empty() else Color(0.66, 0.7, 0.74, 0.86)
		parent.add_child(portrait)


static func apply_anomaly(texture_rect: TextureRect, risk: int) -> String:
	var catalog := AssetCatalog.new()
	var stage := catalog.get_risk_stage(risk)
	texture_rect.texture = catalog.get_texture(catalog.get_anomaly_cutout_id(GameState.get_current_episode_id(), risk))
	if texture_rect.texture == null:
		texture_rect.texture = catalog.get_texture(catalog.get_anomaly_id(GameState.get_current_episode_id(), risk))
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.modulate = Color(1.0, 0.9, 0.9) if stage == "D" else Color.WHITE
	return stage
