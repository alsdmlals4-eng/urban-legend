# M04 B/C 현현 후보가 실제 Recovery AnomalyVisual 소비처에서 해상도별로 로드되는지 검증한다.
extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")
const M04_EPISODE_PATH := "res://data/episodes/episode_002_red_umbrella_alley.json"
const EXPECTED_RESOURCE_PATH := "res://assets/anomalies/cutouts/red_umbrella_b_cutout.png"
const OUTPUT_ENV := "M04_BC_QA_OUTPUT"

var _guard := TestSaveGuard.new()
var _prepared := false
var _failures: Array[String] = []
var _output_dir := ""


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_output_dir = OS.get_environment(OUTPUT_ENV)
	if _output_dir.is_empty():
		_output_dir = ProjectSettings.globalize_path("res://docs/qa/captures/m04/bc_promotion_20260827")
	DirAccess.make_dir_recursive_absolute(_output_dir)
	var game_state := root.get_node("GameState")
	var guard_error := _guard.prepare(game_state.get_save_file_path())
	if not guard_error.is_empty():
		_failures.append(guard_error)
		_finish()
		return
	_prepared = true
	game_state.load_episode(M04_EPISODE_PATH)
	if change_scene_to_file(game_state.SCENE_BATTLE) != OK:
		_failures.append("M04 recovery scene failed to load")
		_finish()
		return
	for _frame in range(8):
		await process_frame
	var visual := current_scene.get_node_or_null("CinematicStage/AnomalyPanel/Content/AnomalyVisual") as TextureRect
	_expect(visual != null, "M04 recovery AnomalyVisual is missing")
	_expect(visual != null and visual.texture != null, "M04 B/C AnomalyVisual must resolve a texture")
	if visual != null and visual.texture != null:
		_expect(visual.texture.resource_path == EXPECTED_RESOURCE_PATH, "M04 B/C must resolve the canonical cutout path")
		_expect(visual.stretch_mode == TextureRect.STRETCH_KEEP_ASPECT_COVERED, "M04 B/C must retain the existing aspect-covered presentation")
	await _capture("m04-bc-promoted", Vector2i(1280, 720))
	await _capture("m04-bc-promoted", Vector2i(1920, 1080))
	_finish()


func _capture(label: String, size: Vector2i) -> void:
	root.size = size
	for _frame in range(6):
		await process_frame
	RenderingServer.force_draw(false)
	await process_frame
	var image := root.get_texture().get_image()
	if image == null or image.is_empty():
		_failures.append("empty image for %s at %s" % [label, size])
		return
	var filename := "%s-%dx%d.png" % [label, size.x, size.y]
	var error := image.save_png(_output_dir.path_join(filename))
	_expect(error == OK, "failed to save %s: %s" % [filename, error_string(error)])


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _prepared:
		var restore_error := _guard.restore()
		if not restore_error.is_empty():
			_failures.append(restore_error)
		_prepared = false
	if _failures.is_empty():
		print("M04 RECOVERY B/C ANOMALY CAPTURE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
