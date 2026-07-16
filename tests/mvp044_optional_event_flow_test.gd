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
	var events: Array = []
	for event_value in game_state.daily_episode_catalog.get_all():
		if typeof(event_value) != TYPE_DICTIONARY:
			continue
		var event: Dictionary = event_value
		var event_id := String(event.get("id", ""))
		if event_id.begins_with("AFTER-") or event_id.begins_with("DAILY-") or event_id.begins_with("FACTION-"):
			events.append(event)
	_expect(events.size() == 25, "all 25 MVP-044 optional events are registered")
	for event in events:
		_run_event(game_state, event)
	_finish()


func _run_event(game_state, event: Dictionary) -> void:
	game_state.reset_run_state()
	for case_id in ["episode_001_afterlife_station", "episode_002_red_umbrella_alley", "episode_003_dead_frequency_station"]:
		game_state.resolve_campaign_case(case_id, "standard")
	var unlock: Dictionary = event.get("unlock_conditions", {})
	for prerequisite in unlock.get("requires_events", []):
		game_state.completed_daily_episode_records.append({"episode_id": String(prerequisite)})
	var event_id := String(event.get("id", ""))
	var started: Dictionary = game_state.begin_daily_episode(event_id)
	_expect(bool(started.get("successful", false)), "%s opens through its actual unlock conditions" % event_id)
	var choices: Array = event.get("choices", [])
	_expect(choices.size() == 3, "%s presents the three approved choices" % event_id)
	if choices.is_empty() or typeof(choices[0]) != TYPE_DICTIONARY:
		return
	var resolved: Dictionary = game_state.resolve_daily_episode_choice(String((choices[0] as Dictionary).get("id", "")))
	_expect(bool(resolved.get("successful", false)), "%s records one selected outcome" % event_id)
	_expect(game_state.get_completed_daily_episode_records().any(func(value): return typeof(value) == TYPE_DICTIONARY and String((value as Dictionary).get("episode_id", "")) == event_id), "%s remains unavailable after completion" % event_id)


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
		print("MVP-044 optional event flow: %d passed, 0 failed" % _passed)
		quit(0)
	else:
		push_error("MVP-044 optional event flow: %d passed, %d failed" % [_passed, _failed])
		quit(1)
