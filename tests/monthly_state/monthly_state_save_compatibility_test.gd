extends SceneTree

const GAME_STATE_PATH := "res://scripts/core/afterlife_migrating_game_state.gd"

var _failures: Array[String] = []


func _init() -> void:
	_expect(FileAccess.file_exists(GAME_STATE_PATH), "afterlife migrating game state missing")
	if FileAccess.file_exists(GAME_STATE_PATH):
		var script_value: Variant = load(GAME_STATE_PATH)
		_expect(script_value is Script, "afterlife migrating game state failed to load")
		if script_value is Script:
			var state = (script_value as Script).new()
			_test_missing_block_defaults(state)
			_test_bounded_transition_hook(state)
			_test_optional_validation(state)
	_finish()


func _test_missing_block_defaults(state: Object) -> void:
	_expect(state.has_method("get_monthly_state"), "monthly state getter missing")
	if not state.has_method("get_monthly_state"):
		return
	state.call("_hydrate_afterlife_fields", _minimal_payload(false))
	var monthly := state.call("get_monthly_state") as Dictionary
	_expect(int(monthly.get("schema_version", 0)) == 1, "missing monthly block did not get schema default")
	_expect(int(monthly.get("month_index", 0)) == 1, "missing monthly block did not get deterministic month")
	_expect(int(monthly.get("week_index", 0)) == 1, "missing monthly block did not get deterministic week")
	_expect(not bool(monthly.get("resolved_this_month", true)), "old report history inferred monthly resolution")
	_expect(String(monthly.get("main_case_status", "")) == "DORMANT", "missing monthly block status mismatch")


func _test_bounded_transition_hook(state: Object) -> void:
	_expect(state.has_method("transition_monthly_state"), "GameState monthly transition hook missing")
	if not state.has_method("transition_monthly_state"):
		return
	state.call("_hydrate_afterlife_fields", _minimal_payload(false))
	var result := state.call(
		"transition_monthly_state",
		"MAKE_DISPATCHABLE",
		{"case_id": "episode_001_afterlife_station", "week_index": 2}
	) as Dictionary
	_expect(bool(result.get("ok", false)), "GameState bounded monthly transition failed")
	_expect(String(result.get("code", "")) == "TRANSITION_APPLIED", "GameState transition did not preserve policy code")
	var monthly := state.call("get_monthly_state") as Dictionary
	_expect(String(monthly.get("main_case_status", "")) == "DISPATCHABLE", "GameState did not commit monthly transition")
	_expect(int(monthly.get("week_index", 0)) == 2, "GameState transition week mismatch")


func _test_optional_validation(state: Object) -> void:
	var missing := _minimal_payload(false)
	_expect(bool(state.call("_validate_main_v2_payload", missing)), "legacy-compatible payload without monthly_state rejected")
	var valid := _minimal_payload(true)
	_expect(bool(state.call("_validate_main_v2_payload", valid)), "valid optional monthly_state rejected")
	var invalid := _minimal_payload(true)
	(invalid["monthly_state"] as Dictionary)["week_index"] = 5
	_expect(not bool(state.call("_validate_main_v2_payload", invalid)), "invalid monthly_state accepted")


func _minimal_payload(include_monthly: bool) -> Dictionary:
	var payload := {
		"save_version": "mvp-040",
		"episode_id": "episode_001_afterlife_station",
		"content_contract_id": "afterlife-station-canon-v2",
		"afterlife_canon_v2": {
			"manual": {
				"filled_slots": {},
				"evidence_records": []
			}
		},
		"migration_history": [],
		"completed_case_reports": [{"episode_id": "episode_001_afterlife_station", "grade": "A"}]
	}
	if include_monthly:
		payload["monthly_state"] = {
			"schema_version": 1,
			"month_index": 1,
			"week_index": 2,
			"active_main_case_id": "episode_001_afterlife_station",
			"main_case_status": "DISPATCHABLE",
			"dispatch_risk": 0,
			"resolved_this_month": false,
			"aftermath_available": false,
			"last_month_result_ref": ""
		}
	return payload


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("MONTHLY STATE SAVE COMPATIBILITY: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
