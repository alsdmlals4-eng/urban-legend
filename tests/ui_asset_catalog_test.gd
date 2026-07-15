extends SceneTree


func _init() -> void:
	var catalog_script = load("res://scripts/ui/ui_asset_catalog.gd")
	assert(catalog_script != null)
	var catalog = catalog_script.new()

	assert(catalog.get_risk_stage(0) == "B")
	assert(catalog.get_risk_stage(34) == "B")
	assert(catalog.get_risk_stage(35) == "C")
	assert(catalog.get_risk_stage(69) == "C")
	assert(catalog.get_risk_stage(70) == "D")
	assert(catalog.get_background_id("episode_001_afterlife_station", "investigation") == "afterlife_platform")
	assert(catalog.get_background_id("episode_002_red_umbrella_alley", "recovery") == "red_recovery")
	assert(catalog.get_anomaly_id("episode_002_red_umbrella_alley", 75) == "red_umbrella_d")
	assert(catalog.get_anomaly_cutout_id("episode_002_red_umbrella_alley", 75) == "red_umbrella_d_cutout")
	assert(catalog.get_agent_asset_id("agent_kang_ijun") == "kang_ijun_expressions")
	assert(catalog.get_agent_cutout_asset_id("agent_kang_ijun") == "kang_ijun_cutout_sheet")
	assert(not catalog.get_asset_path("afterlife_b_cutout").is_empty())
	assert(catalog.get_texture("kang_ijun_cutout_sheet") != null)
	assert(catalog.get_texture("afterlife_b_cutout") != null)
	var face_portrait = catalog.get_agent_face_portrait("agent_kang_ijun", 0)
	assert(face_portrait != null)
	assert(face_portrait.get_width() > 0 and face_portrait.get_height() > 0)
	for agent_id in ["agent_kwon_narae", "agent_yoon_seoha", "agent_oh_hyun", "agent_kang_ijun", "agent_han_yuri"]:
		assert(catalog.get_agent_production_texture(agent_id, "full_body") != null)
		assert(catalog.get_agent_production_texture(agent_id, "portrait") != null)
		assert(catalog.get_agent_production_texture(agent_id, "investigation_support") != null)
		assert(catalog.get_agent_production_texture(agent_id, "recovery_support") != null)
	for contact_id in ["park_doyoon", "lee_serin", "raymond_kane", "camila_vargas"]:
		assert(catalog.get_contact_texture(contact_id, "portrait") != null)
		assert(catalog.get_contact_texture(contact_id, "hq_contact") != null)
	assert(catalog.get_asset_path("missing") == "")

	print("ui_asset_catalog_test: PASS")
	quit()
