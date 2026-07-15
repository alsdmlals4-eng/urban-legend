class_name UiAssetCatalog
extends RefCounted

const ASSET_PATHS := {
	"afterlife_entrance": "res://assets/backgrounds/afterlife_entrance.png",
	"afterlife_platform": "res://assets/backgrounds/afterlife_platform.png",
	"afterlife_recovery": "res://assets/backgrounds/afterlife_recovery.png",
	"red_alley_entrance": "res://assets/backgrounds/red_alley_entrance.png",
	"red_crossroads": "res://assets/backgrounds/red_crossroads.png",
	"red_recovery": "res://assets/backgrounds/red_recovery.png",
	"kang_ijun_expressions": "res://assets/agents/kang_ijun_expressions.png",
	"kwon_narae_expressions": "res://assets/agents/kwon_narae_expressions.png",
	"oh_hyun_expressions": "res://assets/agents/oh_hyun_expressions.png",
	"kang_ijun_cutout_sheet": "res://assets/agents/cutouts/kang_ijun_cutout_sheet.png",
	"kwon_narae_cutout_sheet": "res://assets/agents/cutouts/kwon_narae_cutout_sheet.png",
	"oh_hyun_cutout_sheet": "res://assets/agents/cutouts/oh_hyun_cutout_sheet.png",
	"afterlife_b": "res://assets/anomalies/afterlife_b.png",
	"afterlife_d": "res://assets/anomalies/afterlife_d.png",
	"red_umbrella_b": "res://assets/anomalies/red_umbrella_b.png",
	"red_umbrella_d": "res://assets/anomalies/red_umbrella_d.png",
	"afterlife_b_cutout": "res://assets/anomalies/cutouts/afterlife_b_cutout.png",
	"afterlife_d_cutout": "res://assets/anomalies/cutouts/afterlife_d_cutout.png",
	"red_umbrella_b_cutout": "res://assets/anomalies/cutouts/red_umbrella_b_cutout.png",
	"red_umbrella_d_cutout": "res://assets/anomalies/cutouts/red_umbrella_d_cutout.png",
	"log_normal": "res://assets/log/log_normal.png",
	"log_focus": "res://assets/log/log_focus.png",
	"log_warning": "res://assets/log/log_warning.png",
	"kwon_narae_full_body": "res://assets/characters/mvp043/agents/kwon_narae/full_body.png",
	"kwon_narae_portrait": "res://assets/characters/mvp043/agents/kwon_narae/portrait.png",
	"kwon_narae_investigation_support": "res://assets/characters/mvp043/agents/kwon_narae/investigation_support.png",
	"kwon_narae_recovery_support": "res://assets/characters/mvp043/agents/kwon_narae/recovery_support.png",
	"yoon_seoha_full_body": "res://assets/characters/mvp043/agents/yoon_seoha/full_body.png",
	"yoon_seoha_portrait": "res://assets/characters/mvp043/agents/yoon_seoha/portrait.png",
	"yoon_seoha_investigation_support": "res://assets/characters/mvp043/agents/yoon_seoha/investigation_support.png",
	"yoon_seoha_recovery_support": "res://assets/characters/mvp043/agents/yoon_seoha/recovery_support.png",
	"oh_hyun_full_body": "res://assets/characters/mvp043/agents/oh_hyun/full_body.png",
	"oh_hyun_portrait": "res://assets/characters/mvp043/agents/oh_hyun/portrait.png",
	"oh_hyun_investigation_support": "res://assets/characters/mvp043/agents/oh_hyun/investigation_support.png",
	"oh_hyun_recovery_support": "res://assets/characters/mvp043/agents/oh_hyun/recovery_support.png",
	"kang_ijun_full_body": "res://assets/characters/mvp043/agents/kang_ijun/full_body.png",
	"kang_ijun_portrait": "res://assets/characters/mvp043/agents/kang_ijun/portrait.png",
	"kang_ijun_investigation_support": "res://assets/characters/mvp043/agents/kang_ijun/investigation_support.png",
	"kang_ijun_recovery_support": "res://assets/characters/mvp043/agents/kang_ijun/recovery_support.png",
	"han_yuri_full_body": "res://assets/characters/mvp043/agents/han_yuri/full_body.png",
	"han_yuri_portrait": "res://assets/characters/mvp043/agents/han_yuri/portrait.png",
	"han_yuri_investigation_support": "res://assets/characters/mvp043/agents/han_yuri/investigation_support.png",
	"han_yuri_recovery_support": "res://assets/characters/mvp043/agents/han_yuri/recovery_support.png",
	"park_doyoon_portrait": "res://assets/characters/mvp043/contacts/park_doyoon/portrait.png",
	"park_doyoon_hq_contact": "res://assets/characters/mvp043/contacts/park_doyoon/hq_contact.png",
	"lee_serin_portrait": "res://assets/characters/mvp043/contacts/lee_serin/portrait.png",
	"lee_serin_hq_contact": "res://assets/characters/mvp043/contacts/lee_serin/hq_contact.png",
	"raymond_kane_portrait": "res://assets/characters/mvp043/contacts/raymond_kane/portrait.png",
	"raymond_kane_hq_contact": "res://assets/characters/mvp043/contacts/raymond_kane/hq_contact.png",
	"camila_vargas_portrait": "res://assets/characters/mvp043/contacts/camila_vargas/portrait.png",
	"camila_vargas_hq_contact": "res://assets/characters/mvp043/contacts/camila_vargas/hq_contact.png",
}

const MVP043_AGENT_SLUGS := {
	"agent_kwon_narae": "kwon_narae",
	"agent_yoon_seoha": "yoon_seoha",
	"agent_oh_hyun": "oh_hyun",
	"agent_kang_ijun": "kang_ijun",
	"agent_han_yuri": "han_yuri",
}

const MVP043_CONTACT_SLUGS := {
	"park_doyoon": "park_doyoon",
	"lee_serin": "lee_serin",
	"raymond_kane": "raymond_kane",
	"camila_vargas": "camila_vargas",
}

const BACKGROUNDS := {
	"episode_001_afterlife_station": {
		"dialogue": "afterlife_entrance",
		"investigation": "afterlife_platform",
		"recovery": "afterlife_recovery",
	},
	"episode_002_red_umbrella_alley": {
		"dialogue": "red_alley_entrance",
		"investigation": "red_crossroads",
		"recovery": "red_recovery",
	},
	"episode_003_dead_frequency_station": {
		"dialogue": "afterlife_entrance",
		"investigation": "afterlife_platform",
		"recovery": "afterlife_recovery",
	},
}

const AGENT_ASSETS := {
	"agent_kang_ijun": "kang_ijun_expressions",
	"agent_kwon_narae": "kwon_narae_expressions",
	"agent_oh_hyun": "oh_hyun_expressions",
	"kang_ijun": "kang_ijun_expressions",
	"kwon_narae": "kwon_narae_expressions",
	"oh_hyun": "oh_hyun_expressions",
}

const AGENT_CUTOUT_ASSETS := {
	"agent_kang_ijun": "kang_ijun_cutout_sheet",
	"agent_kwon_narae": "kwon_narae_cutout_sheet",
	"agent_oh_hyun": "oh_hyun_cutout_sheet",
	"kang_ijun": "kang_ijun_cutout_sheet",
	"kwon_narae": "kwon_narae_cutout_sheet",
	"oh_hyun": "oh_hyun_cutout_sheet",
}


func get_risk_stage(risk: int) -> String:
	if risk >= 70:
		return "D"
	if risk >= 35:
		return "C"
	return "B"


func get_background_id(episode_id: String, role: String) -> String:
	var episode_assets: Dictionary = BACKGROUNDS.get(episode_id, {})
	return String(episode_assets.get(role, ""))


func get_anomaly_id(episode_id: String, risk: int) -> String:
	var prefix := "red_umbrella" if episode_id == "episode_002_red_umbrella_alley" else "afterlife"
	var suffix := "d" if get_risk_stage(risk) == "D" else "b"
	return "%s_%s" % [prefix, suffix]


func get_anomaly_cutout_id(episode_id: String, risk: int) -> String:
	return "%s_cutout" % get_anomaly_id(episode_id, risk)


func get_agent_asset_id(agent_id: String) -> String:
	return String(AGENT_ASSETS.get(agent_id, ""))


func get_agent_cutout_asset_id(agent_id: String) -> String:
	return String(AGENT_CUTOUT_ASSETS.get(agent_id, ""))


func get_asset_path(asset_id: String) -> String:
	return String(ASSET_PATHS.get(asset_id, ""))


func get_texture(asset_id: String) -> Texture2D:
	var path := get_asset_path(asset_id)
	if path.is_empty():
		return null
	if ResourceLoader.exists(path):
		return load(path) as Texture2D
	if not FileAccess.file_exists(path):
		return null
	var image := Image.load_from_file(path)
	if image == null or image.is_empty():
		return null
	return ImageTexture.create_from_image(image)


func get_agent_expression(agent_id: String, expression_index: int = 0) -> Texture2D:
	var source := get_texture(get_agent_cutout_asset_id(agent_id))
	if source == null:
		source = get_texture(get_agent_asset_id(agent_id))
	if source == null:
		return null
	var atlas := AtlasTexture.new()
	atlas.atlas = source
	var frame_width := source.get_width() / 3.0
	atlas.region = Rect2(frame_width * clampi(expression_index, 0, 2), 0.0, frame_width, source.get_height())
	return atlas


func get_agent_face_portrait(agent_id: String, expression_index: int = 0) -> Texture2D:
	var production_portrait := get_agent_production_texture(agent_id, "portrait")
	if production_portrait != null:
		return production_portrait
	var source := get_texture(get_agent_cutout_asset_id(agent_id))
	if source == null:
		source = get_texture(get_agent_asset_id(agent_id))
	if source == null:
		return null
	var frame_width := source.get_width() / 3.0
	var crop_size := minf(frame_width * 0.62, source.get_height() * 0.38)
	var atlas := AtlasTexture.new()
	atlas.atlas = source
	atlas.region = Rect2(
		frame_width * clampi(expression_index, 0, 2) + (frame_width - crop_size) * 0.5,
		source.get_height() * 0.02,
		crop_size,
		crop_size
	)
	return atlas


func get_agent_production_texture(agent_id: String, role: String) -> Texture2D:
	var slug := String(MVP043_AGENT_SLUGS.get(agent_id, ""))
	if slug.is_empty() or role not in ["full_body", "portrait", "investigation_support", "recovery_support"]:
		return null
	return get_texture("%s_%s" % [slug, role])


func get_contact_texture(contact_id: String, role: String) -> Texture2D:
	var slug := String(MVP043_CONTACT_SLUGS.get(contact_id, ""))
	if slug.is_empty() or role not in ["portrait", "hq_contact"]:
		return null
	return get_texture("%s_%s" % [slug, role])


func get_log_expression(expression: String = "normal") -> Texture2D:
	var clean_expression := expression if expression in ["normal", "focus", "warning"] else "normal"
	return get_texture("log_%s" % clean_expression)
