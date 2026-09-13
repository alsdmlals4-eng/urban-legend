extends SceneTree

var failures := 0
var results: Array[Dictionary] = []

func _initialize() -> void:
	call_deferred("run")

func check(ok: bool, message: String) -> void:
	if not ok:
		failures += 1
		push_error(message)

func make_game() -> Control:
	var host = load("res://scripts/scenes/minigame_scene.gd").new()
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/episodes/episode_002_red_umbrella_alley.json"))
	host.set("_minigame", data.minigames[0])
	var game: Control = host.call("_make_game_control")
	host.free()
	root.add_child(game)
	game.configure(data.minigames[0], false)
	game.set_process(false)
	game.completed.connect(func(successful: bool, details: Dictionary): results.append({"success": successful, "details": details}))
	return game

func run() -> void:
	var probe := make_game()
	check(probe.has_method("_capture_frame"), "M04 must route to an observation-timed capture, not dodge-by-waiting")
	if not probe.has_method("_capture_frame"):
		probe.free()
		print("rain_frame_sync: %d failures" % failures)
		quit(1)
		return
	probe.free()
	for sample in [{"time": 0.2, "success": false}, {"time": 2.5, "success": false}, {"time": 3.2, "success": true}]:
		results.clear()
		var game := make_game()
		game.call("_capture_frame") # Explicit start is not an attempt.
		game.call("_process", sample.time)
		game.call("_capture_frame")
		check((not results.is_empty()) == sample.success, "only after the third cue may capture finish successfully")
		if sample.success:
			check(results[0].success, "clear-frame capture succeeds")
			check(results[0].details.get("game_type", "") == "rain_frame_sync" and not String(results[0].details.get("input_summary", "")).is_empty(), "saved report identifies the actual execution and input")
			game.call("_capture_frame")
			check(results.size() == 1, "completed capture cannot settle twice")
		else:
			check(game.get("_mistakes") == 1, "wrong timing yields one observed failed capture")
		game.free()
	results.clear()
	var waiting := make_game()
	waiting.call("_capture_frame")
	waiting.call("set_input_locked", true)
	waiting.call("_process", 12.0)
	waiting.call("_capture_frame")
	check(waiting.get("_elapsed") == 0.0 and results.is_empty(), "manual lock freezes time and capture")
	waiting.call("set_input_locked", false)
	waiting.call("_process", 12.0)
	check(results.size() == 1 and not results[0].success, "waiting without a capture cannot win")
	waiting.free()
	results.clear()
	var errors := make_game()
	errors.call("_capture_frame")
	for i in range(3):
		errors.call("_capture_frame")
	check(results.size() == 1 and not results[0].success, "three failed capture actions end recording once")
	errors.free()
	results.clear()
	var boundary := make_game()
	boundary.call("_capture_frame")
	boundary.call("_process", 4.0)
	boundary.call("_capture_frame")
	check(results.is_empty() and boundary.get("_mistakes") == 1, "next-cycle first cue cannot inherit the prior clear window")
	boundary.free()
	var host = load("res://scripts/scenes/minigame_scene.gd").new()
	host.set("_minigame", {"type": "rain_frame_sync"})
	check(String(host.call("_make_result_text", false, {"observation": "녹화 구간이 끝났습니다. 고정된 영상이 없습니다."})).contains("고정된 영상이 없습니다"), "result must distinguish missing input from a wrong rule interpretation")
	host.free()
	print("rain_frame_sync: %d failures" % failures)
	quit(0 if failures == 0 else 1)
