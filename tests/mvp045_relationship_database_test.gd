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
	_expect(bool(game_state.begin_relationship_scene("REL-P01-01").get("successful", false)), "relationship scene opens for presentation")
	var daily_script = load("res://scripts/scenes/daily_episode_scene.gd")
	_expect(daily_script != null, "daily episode scene script loads for relationship presentation")
	if daily_script != null:
		var daily: Node = daily_script.new()
		root.add_child(daily)
		await process_frame
		_expect(daily.find_child("RelationshipPresentationStrip", true, false) != null, "relationship scene renders its participant strip")
		_expect(daily.find_child("RelationshipCutin", true, false) != null, "signature relationship scene renders its transient cut-in")
		daily.queue_free()
		await process_frame
	game_state.resolve_relationship_choice("observe_then_burn")

	var database_script = load("res://scripts/ui/database_view.gd")
	_expect(database_script != null, "database view script loads after autoload initialization")
	if database_script == null:
		_finish()
		return
	var database: Node = database_script.new()
	root.add_child(database)
	await process_frame
	_expect(database.find_child("RelationshipRecordsButton", true, false) != null, "database exposes a relationship-record section")
	_expect(database.has_method("_show_relationship_records"), "database can render completed relationship records")
	database.queue_free()
	await process_frame
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
		print("MVP-045 relationship database: %d passed, 0 failed" % _passed)
		quit(0)
	else:
		push_error("MVP-045 relationship database: %d passed, %d failed" % [_passed, _failed])
		quit(1)
