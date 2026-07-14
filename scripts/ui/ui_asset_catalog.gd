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


func get_log_expression(expression: String = "normal") -> Texture2D:
	var clean_expression := expression if expression in ["normal", "focus", "warning"] else "normal"
	return get_texture("log_%s" % clean_expression)
