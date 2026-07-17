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
	game_state.resolve_campaign_case("episode_001_afterlife_station", "standard")
	game_state.begin_daily_episode("AFTER-02")
	game_state.resolve_daily_episode_choice("after02_compare_structures")

	var started: Dictionary = game_state.begin_relationship_scene("REL-P01-01")
	_expect(bool(started.get("successful", false)), "relationship scene starts before save")
	_expect(game_state.get_current_scene_path() == game_state.SCENE_DAILY_EPISODE, "active relationship scene owns the daily episode route")
	_expect(game_state.save_game(), "active relationship scene saves")
	_expect(game_state.load_game(), "active relationship scene loads")
	_expect(String(game_state.active_relationship_scene.get("id", "")) == "REL-P01-01", "unresolved relationship scene survives reload")
	_expect(game_state.get_current_scene_path() == game_state.SCENE_DAILY_EPISODE, "reload returns to the relationship scene route")

	var resolved: Dictionary = game_state.resolve_relationship_choice("observe_then_burn")
	_expect(bool(resolved.get("successful", false)), "resumed relationship choice resolves once")
	_expect(game_state.active_relationship_scene.is_empty(), "completed relationship scene is cleared")
	_expect(game_state.get_current_scene_path() == game_state.SCENE_PREPARATION, "completed relationship returns to preparation")
	_expect(game_state.save_game(), "completed relationship record saves")
	_expect(game_state.load_game(), "completed relationship record reloads")
	_expect(game_state.active_relationship_scene.is_empty(), "completed relationship does not reopen after reload")
	_expect(game_state.get_relationship_records().size() == 1, "relationship record remains singular after reload")
	_finish()


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
		print("MVP-045 relationship resume: %d passed, 0 failed" % _passed)
		quit(0)
	else:
		push_error("MVP-045 relationship resume: %d passed, %d failed" % [_passed, _failed])
		quit(1)
