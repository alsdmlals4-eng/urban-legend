extends SceneTree

const ORCHESTRATOR_PATH := "res://scripts/core/m01_first_session_orchestrator.gd"
const GAME_STATE_PATH := "res://scripts/core/afterlife_migrating_game_state.gd"
const M01_CASE_ID := "episode_001_afterlife_station"
const PHASES := [
	"OPENING_RECORD",
	"BUREAU_FIRST_TASK",
	"RESTRICTED_SCHEDULE",
	"M01_DISPATCHABLE",
	"M01_INVESTIGATION",
	"M01_DEDUCTION",
	"M01_RESCUE",
	"M01_RECOVERY",
	"M01_COMPOSITE_RESULT",
	"MONTHLY_AFTERMATH"
]

var _failures: Array[String] = []


func _init() -> void:
	_expect(FileAccess.file_exists(ORCHESTRATOR_PATH), "M01 first-session orchestrator missing")
	if FileAccess.file_exists(ORCHESTRATOR_PATH):
		var script_value: Variant = load(ORCHESTRATOR_PATH)
		_expect(script_value is Script, "M01 first-session orchestrator failed to load")
		if script_value is Script:
			var orchestrator = (script_value as Script).new()
			_test_exact_causal_sequence(orchestrator)
			_test_serial_exam_fatigue_guard(orchestrator)
	_test_game_state_integration_contract()
	_finish()


func _test_exact_causal_sequence(orchestrator: Object) -> void:
	_expect(orchestrator.has_method("default_state"), "default_state missing")
	_expect(orchestrator.has_method("available_actions"), "available_actions missing")
	_expect(orchestrator.has_method("apply_event"), "apply_event missing")
	if not orchestrator.has_method("default_state") or not orchestrator.has_method("apply_event"):
		return
	var state := orchestrator.default_state() as Dictionary
	_expect(String(state.get("phase", "")) == PHASES[0], "first-session default phase mismatch")
	_expect(not _contains_truth_owner_key(state), "orchestrator state owns forbidden case truth")

	var runtime := _base_runtime_snapshot()
	for target_phase in PHASES.slice(1):
		_match_runtime_for_target(runtime, String(target_phase))
		var actions := orchestrator.available_actions(state, runtime) as Array
		_expect(String(target_phase) in actions, "target phase unavailable: %s" % target_phase)
		var applied := orchestrator.apply_event(state, String(target_phase), runtime) as Dictionary
		_expect(bool(applied.get("ok", false)), "causal transition failed: %s (%s)" % [target_phase, applied.get("code", "")])
		if not bool(applied.get("ok", false)):
			return
		state = applied.get("state", {}) as Dictionary
		_expect(String(state.get("phase", "")) == String(target_phase), "phase did not advance: %s" % target_phase)
		_expect(not _contains_truth_owner_key(state), "orchestrator acquired forbidden truth ownership at %s" % target_phase)


func _test_serial_exam_fatigue_guard(orchestrator: Object) -> void:
	var no_context := _base_runtime_snapshot()
	var deduction_state := {"schema_version": 1, "phase": "M01_DEDUCTION"}
	var rescue_attempt := orchestrator.apply_event(deduction_state, "M01_RESCUE", no_context) as Dictionary
	_expect(not bool(rescue_attempt.get("ok", true)), "rescue opened without earned records/manual rules")
	_expect(String(rescue_attempt.get("code", "")) == "EARNED_CONTEXT_REQUIRED", "wrong rescue earned-context gate")

	var polluted := _earned_runtime_snapshot()
	polluted["ui_prompt"] = {"correct_response_id": "hidden_new_answer"}
	var polluted_attempt := orchestrator.apply_event(deduction_state, "M01_RESCUE", polluted) as Dictionary
	_expect(not bool(polluted_attempt.get("ok", true)), "hidden correct_response_id bypassed fatigue guard")
	_expect(String(polluted_attempt.get("code", "")) == "SERIAL_EXAM_FATIGUE_GUARD_BLOCKED", "hidden truth gate code mismatch")

	var rescue_state := {"schema_version": 1, "phase": "M01_RESCUE"}
	var no_rescue_snapshot := _earned_runtime_snapshot()
	var recovery_attempt := orchestrator.apply_event(rescue_state, "M01_RECOVERY", no_rescue_snapshot) as Dictionary
	_expect(not bool(recovery_attempt.get("ok", true)), "recovery opened without rescue outcome snapshot")
	_expect(String(recovery_attempt.get("code", "")) == "RESCUE_OUTCOME_REQUIRED", "recovery rescue gate mismatch")

	var recovery_state := {"schema_version": 1, "phase": "M01_RECOVERY"}
	var no_result := _earned_runtime_snapshot()
	(no_result["canon_v2_runtime"] as Dictionary)["rescue_outcome_snapshot"] = {"snapshot_id": "rescue:test"}
	var result_attempt := orchestrator.apply_event(recovery_state, "M01_COMPOSITE_RESULT", no_result) as Dictionary
	_expect(not bool(result_attempt.get("ok", true)), "composite result opened without Canon v2 incident packet")
	_expect(String(result_attempt.get("code", "")) == "COMPOSITE_RESULT_REQUIRED", "composite result gate mismatch")


func _test_game_state_integration_contract() -> void:
	_expect(FileAccess.file_exists(GAME_STATE_PATH), "active GameState script missing")
	if not FileAccess.file_exists(GAME_STATE_PATH):
		return
	var script_value: Variant = load(GAME_STATE_PATH)
	_expect(script_value is Script, "active GameState failed to load")
	if not script_value is Script:
		return
	var game_state = (script_value as Script).new()
	for method_name in ["transition_monthly_state", "get_m01_first_session_state", "apply_m01_first_session_event"]:
		_expect(game_state.has_method(method_name), "GameState orchestration method missing: %s" % method_name)
	if not game_state.has_method("get_m01_first_session_state") or not game_state.has_method("apply_m01_first_session_event"):
		return
	game_state.call("_hydrate_afterlife_fields", _minimal_payload())
	var initial := game_state.call("get_m01_first_session_state") as Dictionary
	_expect(String(initial.get("phase", "")) == "OPENING_RECORD", "missing M01 state did not default safely")
	var applied := game_state.call("apply_m01_first_session_event", "BUREAU_FIRST_TASK") as Dictionary
	_expect(bool(applied.get("ok", false)), "GameState did not delegate first-session transition")
	_expect(String((game_state.call("get_m01_first_session_state") as Dictionary).get("phase", "")) == "BUREAU_FIRST_TASK", "GameState did not commit first-session phase")
	var missing := _minimal_payload()
	_expect(bool(game_state.call("_validate_main_v2_payload", missing)), "legacy-compatible payload without M01 orchestration rejected")
	var valid := _minimal_payload()
	valid["m01_first_session"] = {"schema_version": 1, "phase": "M01_DEDUCTION"}
	_expect(bool(game_state.call("_validate_main_v2_payload", valid)), "valid optional M01 orchestration state rejected")
	var invalid := _minimal_payload()
	invalid["m01_first_session"] = {"schema_version": 1, "phase": "NOT_A_PHASE"}
	_expect(not bool(game_state.call("_validate_main_v2_payload", invalid)), "invalid M01 orchestration phase accepted")


func _base_runtime_snapshot() -> Dictionary:
	return {
		"monthly_state": {
			"schema_version": 1,
			"month_index": 1,
			"week_index": 1,
			"active_main_case_id": "",
			"main_case_status": "DORMANT",
			"dispatch_risk": 0,
			"resolved_this_month": false,
			"aftermath_available": false,
			"last_month_result_ref": ""
		},
		"manual_state": {
			"active_rule_ids": [],
			"evidence_records": []
		},
		"canon_v2_runtime": {
			"rescue_outcome_snapshot": {},
			"incident_end_packet": {},
			"representative_outcome": ""
		}
	}


func _earned_runtime_snapshot() -> Dictionary:
	var runtime := _base_runtime_snapshot()
	runtime["manual_state"] = {
		"active_rule_ids": ["manual_afterlife_page_01_destination_projection"],
		"evidence_records": [
			{"id": "record_afterlife_r1_broadcast_original", "state": "verified"},
			{"id": "record_afterlife_r1_concurrent_destination_mismatch", "state": "verified"},
			{"id": "record_afterlife_official_operation_log", "state": "verified"}
		]
	}
	return runtime


func _match_runtime_for_target(runtime: Dictionary, target_phase: String) -> void:
	if target_phase == "M01_DISPATCHABLE":
		runtime["monthly_state"] = {
			"schema_version": 1,
			"month_index": 1,
			"week_index": 2,
			"active_main_case_id": M01_CASE_ID,
			"main_case_status": "DISPATCHABLE",
			"dispatch_risk": 0,
			"resolved_this_month": false,
			"aftermath_available": false,
			"last_month_result_ref": ""
		}
	elif target_phase in ["M01_DEDUCTION", "M01_RESCUE", "M01_RECOVERY", "M01_COMPOSITE_RESULT", "MONTHLY_AFTERMATH"]:
		var earned := _earned_runtime_snapshot()
		runtime["manual_state"] = (earned["manual_state"] as Dictionary).duplicate(true)
	if target_phase in ["M01_RECOVERY", "M01_COMPOSITE_RESULT", "MONTHLY_AFTERMATH"]:
		(runtime["canon_v2_runtime"] as Dictionary)["rescue_outcome_snapshot"] = {
			"snapshot_id": "rescue:m01:verified",
			"provenance": {"source": "minigame_result"}
		}
	if target_phase in ["M01_COMPOSITE_RESULT", "MONTHLY_AFTERMATH"]:
		(runtime["canon_v2_runtime"] as Dictionary)["incident_end_packet"] = {
			"case_canon_reference": "%s:incident_end" % M01_CASE_ID,
			"representative_outcome": "residue_recovered"
		}
		(runtime["canon_v2_runtime"] as Dictionary)["representative_outcome"] = "residue_recovered"
	if target_phase == "MONTHLY_AFTERMATH":
		var monthly := runtime["monthly_state"] as Dictionary
		monthly["resolved_this_month"] = true
		monthly["aftermath_available"] = true
		monthly["main_case_status"] = "AFTERMATH"
		monthly["last_month_result_ref"] = "result:m01:composite"


func _minimal_payload() -> Dictionary:
	return {
		"save_version": "mvp-040",
		"episode_id": M01_CASE_ID,
		"content_contract_id": "afterlife-station-canon-v2",
		"afterlife_canon_v2": {
			"manual": {
				"filled_slots": {},
				"evidence_records": []
			}
		},
		"migration_history": []
	}


func _contains_truth_owner_key(value: Variant) -> bool:
	match typeof(value):
		TYPE_DICTIONARY:
			var dictionary := value as Dictionary
			for key in dictionary.keys():
				var key_string := String(key)
				if key_string in ["answer_id", "correct_response_id", "true_hypothesis_id", "reward_ids", "hypotheses"]:
					return true
				if _contains_truth_owner_key(dictionary.get(key)):
					return true
		TYPE_ARRAY:
			for child in value as Array:
				if _contains_truth_owner_key(child):
					return true
	return false


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("M01 FIRST SESSION ORCHESTRATION: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
