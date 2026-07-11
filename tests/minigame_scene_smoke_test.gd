# 두 사건의 미니게임 호스트와 게임 컨트롤 생성을 headless로 확인한다.
extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")

var _save_guard := TestSaveGuard.new()

func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node_or_null("GameState")
	if game_state == null:
		push_error("GameState autoload is unavailable")
		quit(1)
		return
	var prepare_error := _save_guard.prepare(game_state.get_save_file_path())
	if not prepare_error.is_empty():
		push_error(prepare_error)
		quit(1)
		return

	var red_umbrella := OS.get_cmdline_user_args().has("--red-umbrella")
	var episode_path := "res://data/episodes/episode_002_red_umbrella_alley.json" if red_umbrella else "res://data/episodes/episode_001_afterlife_station.json"
	var minigame_id := "minigame_rain_sync" if red_umbrella else "minigame_frequency_sync"
	if not game_state.load_episode(episode_path):
		_finish(1, "Failed to load episode: %s" % episode_path)
		return

	game_state.set_current_minigame_id(minigame_id)
	change_scene_to_file("res://scenes/minigame_scene.tscn")
	for frame in range(4):
		await process_frame

	var scene := current_scene
	var expected_script := "rain_dodge_game.gd" if red_umbrella else "rhythm_timing_game.gd"
	var found := _has_script_named(scene, expected_script)
	if not found:
		_finish(1, "Expected child script was not created: %s" % expected_script)
		return

	_finish(0, "MINIGAME SCENE OK: %s" % expected_script)


func _finish(exit_code: int, message: String) -> void:
	var restore_error := _save_guard.restore()
	if not restore_error.is_empty():
		push_error(restore_error)
		quit(1)
		return
	if exit_code == 0:
		print(message)
	else:
		push_error(message)
	quit(exit_code)


func _has_script_named(node: Node, script_name: String) -> bool:
	if node == null:
		return false
	var node_script: Variant = node.get_script()
	if node_script != null and String(node_script.resource_path).ends_with(script_name):
		return true
	for child in node.get_children():
		if _has_script_named(child, script_name):
			return true
	return false
