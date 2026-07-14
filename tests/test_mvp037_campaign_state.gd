# MVP-037의 10일 캠페인 상태와 구버전 저장 이관을 검증한다.
extends Node

const TestSaveGuard = preload("res://tests/test_save_guard.gd")

const AFTERLIFE := "episode_001_afterlife_station"
const RED_UMBRELLA := "episode_002_red_umbrella_alley"
const DEAD_FREQUENCY := "episode_003_dead_frequency_station"

var _guard := TestSaveGuard.new()
var _passed := 0
var _failed := 0


func _ready() -> void:
	var prepare_error := _guard.prepare(GameState.SAVE_FILE_PATH)
	if not prepare_error.is_empty():
		push_error("test aborted: %s" % prepare_error)
		get_tree().quit(1)
		return

	_run_tests()

	var restore_error := _guard.restore()
	if not restore_error.is_empty():
		push_error("test save guard restore failed: %s" % restore_error)
		_failed += 1

	print("MVP-037 campaign: %d passed, %d failed" % [_passed, _failed])
	get_tree().quit(0 if _failed == 0 else 1)


func _run_tests() -> void:
	_test_initial_campaign_state()
	_test_agent_schedule_persistence()
	_test_operation_finishes_one_day_once()
	_test_resolved_case_leaves_risk_rotation()
	_test_daily_risk_rotation_and_limits()
	_test_discovery_and_outbreak_thresholds()
	_test_optional_daily_understanding_reward()
	_test_ten_day_deadline()
	_test_save_round_trip_and_mvp035_migration()


func _test_initial_campaign_state() -> void:
	GameState.call("reset_campaign_state")
	var state: Dictionary = GameState.call("get_campaign_snapshot")
	_expect(int(state.get("day", 0)) == 1, "campaign starts on day 1")
	_expect(String(state.get("time_slot", "")) == "morning", "campaign starts in morning slot")
	_expect(int(state.get("max_days", 0)) == 10, "campaign has a 10-day limit")
	var cases: Dictionary = state.get("cases", {})
	_expect(String(cases.get(AFTERLIFE, {}).get("discovery_state", "")) == "lead", "afterlife starts as a lead")
	_expect(String(cases.get(RED_UMBRELLA, {}).get("discovery_state", "")) == "lead", "red umbrella starts as a lead")
	_expect(String(cases.get(DEAD_FREQUENCY, {}).get("discovery_state", "")) == "unknown", "dead frequency starts hidden")


func _test_agent_schedule_persistence() -> void:
	GameState.call("reset_campaign_state")
	_expect(not bool(GameState.call("is_campaign_schedule_complete", ["agent_kang_ijun"])), "empty agent schedule is incomplete")
	_expect(bool(GameState.call("set_campaign_schedule", "agent_kang_ijun", "morning", "investigation")), "morning assignment is accepted")
	_expect(bool(GameState.call("set_campaign_schedule", "agent_kang_ijun", "afternoon", "research")), "afternoon assignment is accepted")
	_expect(bool(GameState.call("is_campaign_schedule_complete", ["agent_kang_ijun"])), "both slots complete one agent schedule")
	var schedule: Dictionary = GameState.call("get_campaign_agent_schedule", "agent_kang_ijun")
	_expect(String(schedule.get("morning", "")) == "investigation" and String(schedule.get("afternoon", "")) == "research", "schedule returns both assignments")
	_expect(not bool(GameState.call("set_campaign_schedule", "agent_kang_ijun", "night", "research")), "unknown time slot is rejected")


func _test_operation_finishes_one_day_once() -> void:
	GameState.call("reset_campaign_state")
	_expect(bool(GameState.call("begin_campaign_operation", AFTERLIFE)), "investigation marks the current operation day")
	var result: Dictionary = GameState.call("finish_campaign_operation_day")
	_expect(bool(result.get("advanced", false)) and int(result.get("day", 0)) == 2, "result return advances exactly one day")
	result = GameState.call("finish_campaign_operation_day")
	_expect(not bool(result.get("advanced", true)), "reopening result cannot advance the same operation twice")


func _test_resolved_case_leaves_risk_rotation() -> void:
	GameState.call("reset_campaign_state")
	_expect(bool(GameState.call("resolve_campaign_case", AFTERLIFE, "standard")), "successful case can be marked resolved")
	for index in range(4):
		var result: Dictionary = GameState.call("advance_campaign_day", true)
		_expect(not (result.get("changed_case_ids", []) as Array).has(AFTERLIFE), "resolved case is excluded from daily risk")


func _test_daily_risk_rotation_and_limits() -> void:
	GameState.call("reset_campaign_state")
	var first: Dictionary = GameState.call("advance_campaign_day", false)
	var second: Dictionary = GameState.call("advance_campaign_day", false)
	var third: Dictionary = GameState.call("advance_campaign_day", false)
	_expect((first.get("changed_case_ids", []) as Array).size() == 1, "normal day raises one unresolved case")
	_expect((second.get("changed_case_ids", []) as Array).size() == 1, "second normal day raises one unresolved case")
	_expect((third.get("changed_case_ids", []) as Array).size() == 1, "third normal day raises one unresolved case")
	var rotated: Array = []
	rotated.append_array(first.get("changed_case_ids", []))
	rotated.append_array(second.get("changed_case_ids", []))
	rotated.append_array(third.get("changed_case_ids", []))
	_expect(rotated.has(AFTERLIFE) and rotated.has(RED_UMBRELLA) and rotated.has(DEAD_FREQUENCY), "rotation does not exclude an unresolved case for over two days")
	var high_spread: Dictionary = GameState.call("advance_campaign_day", true)
	_expect((high_spread.get("changed_case_ids", []) as Array).size() == 2, "high spread can raise only two cases")


func _test_discovery_and_outbreak_thresholds() -> void:
	GameState.call("reset_campaign_state")
	var state: Dictionary = GameState.call("get_campaign_snapshot")
	var thresholds: Dictionary = state.get("thresholds", {})
	GameState.call("apply_campaign_case_risk", DEAD_FREQUENCY, int(thresholds.get("auto_discovery", 60)))
	state = GameState.call("get_campaign_snapshot")
	_expect(String(state.get("cases", {}).get(DEAD_FREQUENCY, {}).get("discovery_state", "")) == "lead", "risk threshold auto-discovers hidden case")
	GameState.call("apply_campaign_case_risk", DEAD_FREQUENCY, 100)
	state = GameState.call("get_campaign_snapshot")
	_expect(String(state.get("emergency_case_id", "")) == DEAD_FREQUENCY, "outbreak marks an emergency case without game over")
	_expect(not bool(state.get("game_over", true)), "outbreak never creates a game-over state")


func _test_optional_daily_understanding_reward() -> void:
	GameState.call("reset_campaign_state")
	_expect(int(GameState.call("grant_daily_case_understanding", AFTERLIFE, "first_view", "daily_afterlife_01")) == 2, "first daily scene grants +2 understanding")
	_expect(int(GameState.call("grant_daily_case_understanding", AFTERLIFE, "follow_up", "daily_afterlife_01_followup")) == 0, "only one daily reward is granted per day")
	for index in range(12):
		GameState.call("advance_campaign_day", false)
		GameState.call("grant_daily_case_understanding", AFTERLIFE, "first_view", "daily_afterlife_%02d" % [index + 2])
	var state: Dictionary = GameState.call("get_campaign_snapshot")
	_expect(int(state.get("cases", {}).get(AFTERLIFE, {}).get("daily_understanding", -1)) == 10, "daily understanding has a +10 per-case cap")


func _test_ten_day_deadline() -> void:
	GameState.call("reset_campaign_state")
	for index in range(9):
		GameState.call("advance_campaign_day", false)
	var state: Dictionary = GameState.call("get_campaign_snapshot")
	_expect(int(state.get("day", 0)) == 10 and not bool(state.get("demo_ended", true)), "day 10 remains playable")
	GameState.call("advance_campaign_day", false)
	state = GameState.call("get_campaign_snapshot")
	_expect(int(state.get("day", 0)) == 10 and bool(state.get("demo_ended", false)), "advancing past day 10 ends the demo")


func _test_save_round_trip_and_mvp035_migration() -> void:
	GameState.call("reset_campaign_state")
	GameState.call("advance_campaign_day", true)
	GameState.call("grant_daily_case_understanding", RED_UMBRELLA, "first_view", "daily_red_umbrella_01")
	GameState.call("set_campaign_schedule", "agent_kang_ijun", "morning", "maintenance")
	GameState.call("set_campaign_schedule", "agent_kang_ijun", "afternoon", "rest")
	_expect(GameState.save_game(), "mvp-037 campaign save writes")
	GameState.call("reset_campaign_state")
	_expect(GameState.load_game(), "mvp-037 campaign save loads")
	var restored: Dictionary = GameState.call("get_campaign_snapshot")
	_expect(int(restored.get("day", 0)) == 2, "campaign day survives save round trip")
	_expect(int(restored.get("cases", {}).get(RED_UMBRELLA, {}).get("daily_understanding", 0)) == 2, "daily understanding survives save round trip")
	var restored_schedule: Dictionary = GameState.call("get_campaign_agent_schedule", "agent_kang_ijun")
	_expect(String(restored_schedule.get("morning", "")) == "maintenance" and String(restored_schedule.get("afternoon", "")) == "rest", "current-day schedule survives save round trip")

	var legacy_file := FileAccess.open(GameState.SAVE_FILE_PATH, FileAccess.WRITE)
	legacy_file.store_string(JSON.stringify({
		"save_version": "mvp-035",
		"episode_path": GameState.DEFAULT_EPISODE_PATH,
		"current_scene_path": GameState.SCENE_PREPARATION,
		"selected_agent_ids": []
	}))
	legacy_file.close()
	_expect(GameState.load_game(), "mvp-035 save migrates")
	var migrated: Dictionary = GameState.call("get_campaign_snapshot")
	_expect(int(migrated.get("day", 0)) == 1, "legacy save receives default campaign day")
	_expect(String(migrated.get("cases", {}).get(DEAD_FREQUENCY, {}).get("discovery_state", "")) == "unknown", "legacy save receives hidden third case")


func _expect(condition: bool, label: String) -> void:
	if condition:
		_passed += 1
		print("  PASS: %s" % label)
	else:
		_failed += 1
		push_error("  FAIL: %s" % label)
