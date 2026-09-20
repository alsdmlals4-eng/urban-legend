extends SceneTree

var failures: Array[String] = []
func _init() -> void:
	call_deferred("run")
func check(value: bool, message: String) -> void:
	if not value:
		failures.append(message)
func frames() -> void:
	for i in range(6):
		await process_frame
func run() -> void:
	var state := root.get_node("GameState")
	var pending: String = state.get_save_file_path() + ".pending"
	if FileAccess.file_exists(pending) or DirAccess.dir_exists_absolute(pending):
		push_error("Test requires unused isolated pending path")
		quit(1)
		return
	var guard = load("res://tests/test_save_guard.gd").new()
	if not guard.prepare(state.get_save_file_path()).is_empty():
		quit(1)
		return
	for successful in [false, true]:
		state.reset_run_state()
		state.start_episode_from_preparation("res://data/episodes/episode_002_red_umbrella_alley.json")
		state.set_current_minigame_id("minigame_rain_sync")
		change_scene_to_file("res://scenes/minigame_scene.tscn")
		await frames()
		check(state.save_game(), "baseline save")
		var before := FileAccess.get_file_as_bytes(state.get_save_file_path())
		check(DirAccess.make_dir_absolute(pending) == OK, "create owned empty stage obstacle")
		var scene := current_scene
		var game: Control = scene.get("_game_control")
		game.call("_complete", successful)
		await frames()
		var button: Button = scene.get("_return_button")
		check(button.visible and button.text.contains("저장"), "failed result persistence exposes a save retry action")
		check(str(scene.get("_result_label").text).contains("저장"), "result explains unsaved state")
		check(FileAccess.get_file_as_bytes(state.get_save_file_path()) == before, "failed result save preserves primary bytes")
		check(root.get_visible_rect().encloses(button.get_global_rect()), "save retry remains on screen")
		var manual_button: Button = scene.get("_manual_toggle_button")
		check(not button.get_global_rect().intersects(manual_button.get_global_rect()), "manual entry cannot cover the save retry action")
		if "--capture" in OS.get_cmdline_user_args() and not successful:
			await RenderingServer.frame_post_draw
			check(root.get_texture().get_image().save_png(ProjectSettings.globalize_path("res://.artifacts/daily-case-20260912/minigame-save-retry.png")) == OK, "capture unsaved result state")
		var snapshot: Dictionary = state.call("_make_save_data").duplicate(true)
		scene.call("_on_game_completed", successful, {})
		button.pressed.emit()
		await frames()
		check(current_scene == scene, "failed retry must not leave the minigame")
		check(state.get_current_scene_path() == "res://scenes/minigame_scene.tscn", "failed navigation save retains the actual current scene")
		var after: Dictionary = state.call("_make_save_data")
		for key in ["anomaly_risk", "anomaly_understanding", "anomaly_stability", "mental_stamina", "minigame_results"]:
			check(snapshot.has(key), "fixture contains real save field " + key)
			check(after.get(key) == snapshot.get(key), "retry cannot reapply " + key)
		check(DirAccess.remove_absolute(pending) == OK, "remove only owned empty stage obstacle")
		if current_scene == scene:
			button.pressed.emit()
			await frames()
		check(current_scene.scene_file_path == "res://scenes/investigation_scene.tscn", "successful retry reaches investigation")
		check(state.load_game(), "retry disk data reloads")
		var restored: Dictionary = state.get_minigame_result("minigame_rain_sync")
		check(not restored.is_empty() and bool(restored.get("successful", false)) == successful, "reload preserves original outcome")
		check(state.get_current_scene_path() == "res://scenes/investigation_scene.tscn", "disk resume points to the destination")
		var reloaded: Dictionary = state.call("_make_save_data")
		for key in ["anomaly_risk", "anomaly_understanding", "anomaly_stability", "mental_stamina", "minigame_results"]:
			# JSON reload represents every number as float; compare serialized meaning.
			check(reloaded.get(key) == JSON.parse_string(JSON.stringify(snapshot.get(key))), "disk retry preserves settled " + key)
	var audio_probe := preload("res://tests/test_audio_lifecycle.gd").new()
	audio_probe.capture(current_scene)
	current_scene.queue_free()
	await frames()
	var retained: Array[String] = await audio_probe.wait_for_release(self)
	check(retained.is_empty(), "investigation audio must retire after minigame return: %s" % str(retained))
	check(guard.restore().is_empty(), "restore isolated save")
	for message in failures:
		push_error(message)
	print("Minigame save retry: ", failures.size(), " failures")
	quit(0 if failures.is_empty() else 1)
