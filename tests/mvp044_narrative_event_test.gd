extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")
const AFTERLIFE := "episode_001_afterlife_station"

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

	var after_event: Dictionary = game_state.get_daily_episode("AFTER-01")
	_expect(String(after_event.get("category", "")) == "after", "AFTER-01 is loaded as an after-event")
	_expect((after_event.get("choices", []) as Array).size() == 3, "AFTER-01 has its three approved choices")
	_expect(not _available_ids(game_state).has("AFTER-01"), "after-event stays locked before its case is stabilized")

	_expect(game_state.resolve_campaign_case(AFTERLIFE, "standard"), "afterlife stabilization can unlock optional narrative events")
	_expect(_available_ids(game_state).has("AFTER-01"), "AFTER-01 opens after afterlife stabilization")
	var before := _campaign_invariants(game_state.get_campaign_snapshot())
	var started: Dictionary = game_state.begin_daily_episode("AFTER-01")
	_expect(bool(started.get("successful", false)), "after-event starts through the existing optional-event flow")
	var resolved: Dictionary = game_state.resolve_daily_episode_choice("after01_keep_blank")
	_expect(bool(resolved.get("successful", false)), "after-event choice resolves once")
	var record: Dictionary = resolved.get("record", {})
	_expect(String(record.get("category", "")) == "after", "after-event record keeps its category")
	_expect(int(record.get("understanding_reward", -1)) == 0, "after-event does not grant daily understanding")
	_expect(before == _campaign_invariants(game_state.get_campaign_snapshot()), "after-event does not consume schedule, risk, or campaign time")
	_expect(not _available_ids(game_state).has("AFTER-01"), "completed after-event cannot reopen")

	_finish()


func _available_ids(game_state: Node) -> Array:
	var ids: Array = []
	for value in game_state.get_available_daily_episodes():
		if typeof(value) == TYPE_DICTIONARY:
			ids.append(String((value as Dictionary).get("id", "")))
	return ids


func _campaign_invariants(campaign: Dictionary) -> Dictionary:
	return {
		"day": int(campaign.get("day", 0)),
		"time_slot": String(campaign.get("time_slot", "")),
		"slot_phase": String(campaign.get("slot_phase", "")),
		"planned_case_id": String(campaign.get("planned_case_id", "")),
		"active_operation": campaign.get("active_operation", {}),
		"schedules": campaign.get("schedules", {}),
		"request_board": campaign.get("request_board", [])
	}


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
		print("MVP-044 narrative event: %d passed, 0 failed" % _passed)
		quit(0)
	else:
		push_error("MVP-044 narrative event: %d passed, %d failed" % [_passed, _failed])
		quit(1)
