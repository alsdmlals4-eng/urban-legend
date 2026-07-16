extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")

var _guard := TestSaveGuard.new()
var _prepared := false
var _passed := 0
var _failed := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node("GameState")
	var guard_error := _guard.prepare(game_state.SAVE_FILE_PATH)
	if not guard_error.is_empty():
		_fail(guard_error)
		_finish()
		return
	_prepared = true
	game_state.reset_run_state()

	await _expect_category_title(game_state, "AFTER-01", "후일담 기록")
	await _expect_category_title(game_state, "DAILY-01", "기록국 일상")
	await _expect_category_title(game_state, "FACTION-01", "세력 교류")
	_finish()


func _expect_category_title(game_state: Node, episode_id: String, expected_prefix: String) -> void:
	game_state.active_daily_episode = {
		"episode_id": episode_id,
		"day": 1,
		"time_slot": "morning"
	}
	var scene_script = load("res://scripts/scenes/daily_episode_scene.gd")
	_expect(scene_script != null, "%s scene script loads" % episode_id)
	_expect(scene_script != null and scene_script.can_instantiate(), "%s scene script parses and instantiates" % episode_id)
	if scene_script == null or not scene_script.can_instantiate():
		return
	var scene: Node = scene_script.new()
	root.add_child(scene)
	await process_frame
	var title := scene.find_child("EpisodeCategoryTitle", true, false) as Label
	_expect(title != null, "%s exposes its narrative category title" % episode_id)
	if title != null:
		_expect(title.text.begins_with(expected_prefix), "%s renders %s instead of the generic daily label" % [episode_id, expected_prefix])
	scene.queue_free()
	await process_frame


func _expect(condition: bool, message: String) -> void:
	if condition:
		_passed += 1
	else:
		_fail(message)


func _fail(message: String) -> void:
	_failed += 1
	push_error(message)


func _finish() -> void:
	if _prepared:
		var restore_error := _guard.restore()
		_prepared = false
		if not restore_error.is_empty():
			_fail(restore_error)
	if _failed == 0:
		print("MVP-044 category UI: %d passed, 0 failed" % _passed)
		quit(0)
	else:
		push_error("MVP-044 category UI: %d passed, %d failed" % [_passed, _failed])
		quit(1)
