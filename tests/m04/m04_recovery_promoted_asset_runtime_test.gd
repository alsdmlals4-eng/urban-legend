# M04 Recovery의 승인 에셋이 실제 Background 및 D-risk AnomalyVisual 소비처에서 해상도별로 로드되는지 검증한다.
extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")
const M04_EPISODE_PATH := "res://data/episodes/episode_002_red_umbrella_alley.json"
const EXPECTED_BACKGROUND_PATH := "res://assets/backgrounds/red_recovery.png"
const EXPECTED_D_CUTOUT_PATH := "res://assets/anomalies/cutouts/red_umbrella_d_cutout.png"

var _guard := TestSaveGuard.new()
var _prepared := false
var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node_or_null("GameState")
	if game_state == null:
		_failures.append("GameState autoload is unavailable")
		_finish()
		return
	var guard_error := _guard.prepare(game_state.get_save_file_path())
	if not guard_error.is_empty():
		_failures.append(guard_error)
		_finish()
		return
	_prepared = true
	game_state.reset_run_state()
	_expect(game_state.load_episode(M04_EPISODE_PATH), "M04 episode loads for Recovery asset verification")
	game_state.investigation_risk = 85
	_expect(change_scene_to_file(game_state.SCENE_BATTLE) == OK, "M04 Recovery scene loads")
	for _frame in range(8):
		await process_frame
	for target_size in [Vector2i(1280, 720), Vector2i(1920, 1080)]:
		root.size = target_size
		for _frame in range(3):
			await process_frame
		_verify_runtime_consumers(target_size)
	_finish()


func _verify_runtime_consumers(target_size: Vector2i) -> void:
	var background := current_scene.get_node_or_null("ArtLayer/Background") as TextureRect
	var anomaly := current_scene.get_node_or_null("CinematicStage/AnomalyPanel/Content/AnomalyVisual") as TextureRect
	_expect(background != null and background.texture != null, "Recovery Background resolves at %dx%d" % [target_size.x, target_size.y])
	_expect(anomaly != null and anomaly.texture != null, "Recovery D AnomalyVisual resolves at %dx%d" % [target_size.x, target_size.y])
	if background != null and background.texture != null:
		_expect(background.texture.resource_path == EXPECTED_BACKGROUND_PATH, "Recovery background uses the canonical approved path at %dx%d" % [target_size.x, target_size.y])
		_expect(background.stretch_mode == TextureRect.STRETCH_KEEP_ASPECT_COVERED, "Recovery background retains environment coverage at %dx%d" % [target_size.x, target_size.y])
	if anomaly != null and anomaly.texture != null:
		_expect(anomaly.texture.resource_path == EXPECTED_D_CUTOUT_PATH, "Recovery D uses the canonical transparent cutout at %dx%d" % [target_size.x, target_size.y])
		_expect(anomaly.stretch_mode == TextureRect.STRETCH_KEEP_ASPECT_CENTERED, "Recovery D retains the uncropped cutout presentation at %dx%d" % [target_size.x, target_size.y])


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
		print("M04 RECOVERY PROMOTED ASSET RUNTIME: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
