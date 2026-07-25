extends SceneTree

const SCENE_PATH := "res://scenes/poc/annual_mvp_001/annual_mvp_001_scene.tscn"
const OUTPUT_ENV := "ANNUAL_QA_OUTPUT"

var _failures: Array[String] = []
var _manifest: Array[Dictionary] = []
var _output_dir := ""


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_output_dir = OS.get_environment(OUTPUT_ENV)
	if _output_dir.is_empty():
		_output_dir = ProjectSettings.globalize_path("res://annual-qa-artifacts")
	DirAccess.make_dir_recursive_absolute(_output_dir)

	await _capture_initial_planning()
	await _run_path("early", false, false, "normal_capture", "verified")
	await _run_path("delayed", true, false, "costly_capture", "verified")
	await _run_path("emergency", true, true, "emergency_capture", "candidate")

	var manifest_path := _output_dir.path_join("manifest.json")
	var manifest_file := FileAccess.open(manifest_path, FileAccess.WRITE)
	if manifest_file == null:
		_failures.append("manifest file could not be opened")
	else:
		manifest_file.store_string(JSON.stringify({"captures": _manifest, "failures": _failures}, "  "))

	if _failures.is_empty():
		print("ANNUAL MVP 001 VISUAL CAPTURE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)


func _capture_initial_planning() -> void:
	var scene := await _new_scene()
	if scene == null:
		return
	await _capture(scene, "planning_initial", Vector2i(1280, 720))
	await _capture(scene, "planning_initial", Vector2i(1920, 1080))
	await _free_scene(scene)


func _run_path(
	path_id: String,
	delay_to_week_three: bool,
	force_emergency: bool,
	recovery_quality: String,
	manual_status: String
) -> void:
	var scene := await _new_scene()
	if scene == null:
		return

	await _commit_week(scene, [
		"annual001_activity_signal_research",
		"annual001_activity_companion_drill",
		"annual001_activity_field_training"
	])
	_scene_confirm(scene)
	await process_frame

	await _commit_week(scene, [
		"annual001_activity_observation_drill",
		"annual001_activity_analysis_desk",
		"annual001_activity_rest"
	])
	_scene_confirm(scene)
	await process_frame

	_expect_phase(scene, "DEPLOYMENT_DECISION", "%s week 2 deployment" % path_id)
	if delay_to_week_three:
		_click_button(scene, "1주 더 준비")
		await process_frame
		await _commit_week(scene, [
			"annual001_activity_signal_research",
			"annual001_activity_field_training",
			"annual001_activity_rest"
		])
		_scene_confirm(scene)
		await process_frame
		_expect_phase(scene, "DEPLOYMENT_DECISION", "%s week 3 deployment" % path_id)

	await _capture(scene, "%s_deployment" % path_id, Vector2i(1280, 720))
	await _capture(scene, "%s_deployment" % path_id, Vector2i(1920, 1080))

	_click_button(scene, "1주 더 준비" if force_emergency else "지금 출동")
	await process_frame
	_expect_phase(scene, "PREPARATION", "%s preparation" % path_id)

	var state := scene.get("_state") as Object
	var pre_research: Dictionary = state.call("complete_research_project", "annual001_research_signal_buffer")
	if not bool(pre_research.get("ok", false)):
		_failures.append("%s pre-incident research failed: %s" % [path_id, pre_research.get("error", "")])
	var snapshot: Dictionary = scene.call("debug_snapshot")
	var public_skill := "annual001_skill_emergency_cover" if (snapshot.get("unlocked_skill_ids", []) as Array).has("annual001_skill_emergency_cover") else ""
	var modules: Array[String] = []
	if (snapshot.get("unlocked_module_ids", []) as Array).has("annual001_module_signal_buffer"):
		modules.append("annual001_module_signal_buffer")
	scene.set("_selected_public_skill_id", public_skill)
	scene.set("_selected_module_ids", modules)
	scene.call("_render")

	await _capture(scene, "%s_preparation" % path_id, Vector2i(1280, 720))
	await _capture(scene, "%s_preparation" % path_id, Vector2i(1920, 1080))

	if path_id == "early":
		scene.call("_start_incident")
		for _frame in range(8):
			await process_frame
		_expect_phase(scene, "INCIDENT_ACTIVE", "early incident active")
		await _capture(scene, "early_incident", Vector2i(1280, 720))
		await _capture(scene, "early_incident", Vector2i(1920, 1080))
		var incident_host := scene.find_child("IncidentHost", true, false)
		if incident_host != null:
			for child in incident_host.get_children():
				child.queue_free()
			await process_frame
	else:
		var configured: Dictionary = state.call(
			"configure_loadout",
			"annual001_companion_oh_hyun",
			public_skill,
			modules
		)
		if not bool(configured.get("ok", false)):
			_failures.append("%s loadout failed: %s" % [path_id, configured.get("error", "")])
		var begun: Dictionary = state.call("begin_incident")
		if not bool(begun.get("ok", false)):
			_failures.append("%s incident begin failed: %s" % [path_id, begun.get("error", "")])

	var result := {
		"recovery_quality": recovery_quality,
		"damage_management": "controlled" if recovery_quality == "normal_capture" else "strained",
		"damage": 12 if recovery_quality == "normal_capture" else 28
	}
	var manual_delta := {
		"status": manual_status,
		"danger_cases": [] if recovery_quality == "normal_capture" else [{"id": "%s_danger" % path_id}],
		"observed_pattern_ids": ["poc001_pattern_false_terminal"]
	}
	var applied: Dictionary = state.call("apply_incident_result", result, manual_delta, [])
	if not bool(applied.get("ok", false)):
		_failures.append("%s incident result failed: %s" % [path_id, applied.get("error", "")])
	state.call("advance_from_incident_result")
	if manual_status == "verified":
		var post_research: Dictionary = state.call("complete_research_project", "annual001_research_ticket_protocol")
		if not bool(post_research.get("ok", false)):
			_failures.append("%s post-incident research failed: %s" % [path_id, post_research.get("error", "")])
	else:
		state.call("skip_post_incident_research")
	scene.call("_render")
	await process_frame
	_expect_phase(scene, "QUARTER_SUMMARY", "%s quarter summary" % path_id)

	await _capture(scene, "%s_summary" % path_id, Vector2i(1280, 720))
	await _capture(scene, "%s_summary" % path_id, Vector2i(1920, 1080))
	_manifest.append({
		"path": path_id,
		"final_snapshot": scene.call("debug_snapshot")
	})
	await _free_scene(scene)


func _new_scene() -> Control:
	var packed := load(SCENE_PATH) as PackedScene
	if packed == null:
		_failures.append("annual scene failed to load")
		return null
	var scene := packed.instantiate() as Control
	root.add_child(scene)
	for _frame in range(6):
		await process_frame
	return scene


func _free_scene(scene: Control) -> void:
	scene.queue_free()
	for _frame in range(3):
		await process_frame


func _commit_week(scene: Control, activity_ids: Array[String]) -> void:
	for activity_id in activity_ids:
		scene.call("debug_select_activity", activity_id)
	scene.call("debug_confirm")
	await process_frame
	_expect_phase(scene, "WEEK_RESULT", "week commit")


func _scene_confirm(scene: Control) -> void:
	scene.call("debug_confirm")


func _expect_phase(scene: Control, expected: String, context: String) -> void:
	var actual := String((scene.call("debug_snapshot") as Dictionary).get("phase", ""))
	if actual != expected:
		_failures.append("%s expected %s, got %s" % [context, expected, actual])


func _click_button(scene: Node, text: String) -> void:
	var button := _find_button(scene, text)
	if button == null:
		_failures.append("button not found: %s" % text)
		return
	button.pressed.emit()


func _find_button(node: Node, text: String) -> BaseButton:
	if node is BaseButton and (node as BaseButton).text == text:
		return node as BaseButton
	for child in node.get_children():
		var found := _find_button(child, text)
		if found != null:
			return found
	return null


func _capture(scene: Control, label: String, size: Vector2i) -> void:
	root.size = size
	for _frame in range(6):
		await process_frame
	RenderingServer.force_draw(false)
	await process_frame
	var image := root.get_texture().get_image()
	if image == null or image.is_empty():
		_failures.append("empty image for %s at %s" % [label, size])
		return
	var filename := "%s_%dx%d.png" % [label, size.x, size.y]
	var error := image.save_png(_output_dir.path_join(filename))
	if error != OK:
		_failures.append("save failed for %s: %s" % [filename, error_string(error)])
		return
	_manifest.append({
		"capture": filename,
		"phase": String((scene.call("debug_snapshot") as Dictionary).get("phase", "")),
		"visible_panel": String(scene.call("debug_visible_panel")),
		"size": [size.x, size.y]
	})
