extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")

var _guard := TestSaveGuard.new()
var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node("GameState")
	var guard_error := _guard.prepare(game_state.get_save_file_path())
	if not guard_error.is_empty():
		_failures.append(guard_error)
		_finish()
		return
	game_state.load_episode("res://data/episodes/episode_001_afterlife_station.json")
	if change_scene_to_file("res://scenes/dialogue_scene.tscn") != OK:
		_failures.append("dialogue scene failed to load")
		_finish()
		return
	for _frame in range(5):
		await process_frame
	_expect(current_scene.find_child("LocationPanel", true, false) != null, "dialogue must keep the left field image")
	_expect(current_scene.find_child("BriefingFacts", true, false) == null, "dialogue must remove the three briefing fact cards")
	var manual := current_scene.find_child("AnomalyManualBook", true, false) as AnomalyManualDrawer
	_expect(manual != null and manual.visible and manual.find_child("BookFrame", true, false) != null, "dialogue must show a persistent book-style anomaly manual")
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	var restore_error := _guard.restore()
	if not restore_error.is_empty():
		_failures.append(restore_error)
	if _failures.is_empty():
		print("DIALOGUE MANUAL BOOK LAYOUT: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
