extends SceneTree

const SCENE_PATH := "res://scenes/poc/annual_mvp_002/annual_mvp_002_scene.tscn"
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
	var scene := await _new_scene()
	if scene == null:
		_finish()
		return
	await _capture(scene, "annual-mvp-002-planning-empty", Vector2i(1280, 720))
	await _capture(scene, "annual-mvp-002-planning-empty", Vector2i(1920, 1080))
	var planned: Dictionary = scene.call("debug_set_plan", [
		"annual001_activity_field_training",
		"annual001_activity_observation_drill",
		"annual001_activity_rest",
		"annual001_activity_rest",
	])
	_expect(planned.get("ok", false), "seven-day preview plan should apply")
	await _capture(scene, "annual-mvp-002-planning-preview", Vector2i(1280, 720))
	await _capture(scene, "annual-mvp-002-planning-preview", Vector2i(1920, 1080))
	scene.call("debug_confirm")
	await process_frame
	_expect_phase(scene, "WEEK_RESULT", "week result capture")
	await _capture(scene, "annual-mvp-002-causal-summary", Vector2i(1280, 720))
	await _capture(scene, "annual-mvp-002-causal-summary", Vector2i(1920, 1080))
	scene.call("debug_force_preparation_phase")
	await process_frame
	_expect_phase(scene, "PREPARATION", "preparation capture")
	scene.call("debug_toggle_companion", "annual002_companion_ohyun", true)
	scene.call("debug_toggle_companion", "annual002_companion_han_serin", true)
	scene.call("debug_set_support", "annual002_companion_ohyun", "annual002_support_damage_buffer")
	scene.call("debug_set_support", "annual002_companion_han_serin", "annual002_support_second_read")
	scene.call("debug_set_equipment", "annual002_equipment_echo_recorder")
	scene.call("debug_set_module", "annual002_module_noise_filter")
	await process_frame
	var support_label := scene.find_child("SupportStatusLabel", true, false) as Label
	_expect(support_label != null and support_label.text.contains("확률"), "support transparency text should render")
	await _capture(scene, "annual-mvp-002-preparation", Vector2i(1280, 720))
	await _capture(scene, "annual-mvp-002-preparation", Vector2i(1920, 1080))
	_manifest.append({
		"final_phase": String((scene.call("debug_snapshot") as Dictionary).get("phase", "")),
		"loadout": scene.call("debug_loadout_snapshot"),
	})
	scene.queue_free()
	await process_frame
	_finish()


func _new_scene() -> Control:
	var packed := load(SCENE_PATH) as PackedScene
	if packed == null:
		_failures.append("ANNUAL-MVP-002 scene failed to load")
		return null
	var scene := packed.instantiate() as Control
	root.add_child(scene)
	for _frame in range(6):
		await process_frame
	return scene


func _capture(scene: Control, label: String, size: Vector2i) -> void:
	root.size = size
	for _frame in range(6):
		await process_frame
	RenderingServer.force_draw(false)
	await process_frame
	var image := root.get_texture().get_image()
	if image == null or image.is_empty():
		_failures.append("empty image: %s %s" % [label, size])
		return
	var filename := "%s_%dx%d.png" % [label, size.x, size.y]
	var error := image.save_png(_output_dir.path_join(filename))
	if error != OK:
		_failures.append("failed to save %s: %s" % [filename, error_string(error)])
		return
	_manifest.append({
		"capture": filename,
		"phase": String((scene.call("debug_snapshot") as Dictionary).get("phase", "")),
		"size": [size.x, size.y],
	})


func _expect_phase(scene: Control, expected: String, context: String) -> void:
	var actual := String((scene.call("debug_snapshot") as Dictionary).get("phase", ""))
	_expect(actual == expected, "%s expected %s, got %s" % [context, expected, actual])


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	var manifest_file := FileAccess.open(_output_dir.path_join("annual-mvp-002-manifest.json"), FileAccess.WRITE)
	if manifest_file != null:
		manifest_file.store_string(JSON.stringify({"captures": _manifest, "failures": _failures}, "  "))
	if _failures.is_empty():
		print("ANNUAL MVP 002 VISUAL CAPTURE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
