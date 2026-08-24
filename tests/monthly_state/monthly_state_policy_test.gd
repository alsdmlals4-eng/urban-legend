extends SceneTree

const POLICY_PATH := "res://scripts/core/monthly_state_policy.gd"
const AFTERLIFE_CASE_ID := "episode_001_afterlife_station"

var _failures: Array[String] = []


func _init() -> void:
	_expect(FileAccess.file_exists(POLICY_PATH), "monthly state policy missing")
	if FileAccess.file_exists(POLICY_PATH):
		var script_value: Variant = load(POLICY_PATH)
		_expect(script_value is Script, "monthly state policy failed to load")
		if script_value is Script:
			var policy = (script_value as Script).new()
			_test_default(policy)
			_test_transition_interface(policy)
			_test_dispatch_risk(policy)
			_test_active_transition(policy)
			_test_resolution_lock(policy)
			_test_case_truth_boundary(policy)
	_finish()


func _test_default(policy: Object) -> void:
	var state: Dictionary = policy.default_state(1)
	_expect(int(state.get("schema_version", 0)) == 1, "monthly schema mismatch")
	_expect(int(state.get("month_index", 0)) == 1, "default month mismatch")
	_expect(int(state.get("week_index", 0)) == 1, "default week mismatch")
	_expect(String(state.get("active_main_case_id", "")) == "", "default case should be empty")
	_expect(String(state.get("main_case_status", "")) == "DORMANT", "default status mismatch")
	_expect(int(state.get("dispatch_risk", -1)) == 0, "default risk mismatch")
	_expect(not bool(state.get("resolved_this_month", true)), "default resolved flag mismatch")
	_expect(not bool(state.get("aftermath_available", true)), "default aftermath flag mismatch")
	_expect(String(state.get("last_month_result_ref", "")) == "", "default result ref mismatch")
	var validation: Dictionary = policy.validate(state)
	_expect(bool(validation.get("ok", false)), "default state should validate")
	_expect(String(validation.get("code", "")) == "VALID", "validation result code missing")


func _test_transition_interface(policy: Object) -> void:
	_expect(policy.has_method("transition"), "monthly transition interface missing")
	if not policy.has_method("transition"):
		return
	var dispatched: Dictionary = policy.transition(
		policy.default_state(1),
		"MAKE_DISPATCHABLE",
		{"case_id": AFTERLIFE_CASE_ID, "week_index": 2}
	)
	_expect(bool(dispatched.get("ok", false)), "transition interface could not dispatch M01")
	_expect(String(dispatched.get("code", "")) == "TRANSITION_APPLIED", "transition success code missing")
	var advanced: Dictionary = policy.transition(dispatched.get("state", {}) as Dictionary, "ADVANCE_WEEK")
	_expect(bool(advanced.get("ok", false)), "transition interface could not advance week")
	var unknown: Dictionary = policy.transition(policy.default_state(1), "UNKNOWN_EVENT")
	_expect(not bool(unknown.get("ok", true)), "unknown monthly transition was accepted")
	_expect(String(unknown.get("code", "")) == "UNKNOWN_EVENT", "unknown transition code mismatch")


func _test_dispatch_risk(policy: Object) -> void:
	var base: Dictionary = policy.default_state(1)
	for pair in [[2, 0], [3, 15], [4, 30]]:
		var changed: Dictionary = policy.transition(
			base,
			"MAKE_DISPATCHABLE",
			{"case_id": AFTERLIFE_CASE_ID, "week_index": int(pair[0])}
		)
		_expect(bool(changed.get("ok", false)), "dispatchable transition failed for week %s" % pair[0])
		var state := changed.get("state", {}) as Dictionary
		_expect(int(state.get("week_index", 0)) == int(pair[0]), "week transition mismatch")
		_expect(int(state.get("dispatch_risk", -1)) == int(pair[1]), "dispatch risk mismatch for week %s" % pair[0])
		_expect(String(state.get("main_case_status", "")) == "DISPATCHABLE", "dispatchable status missing")


func _test_active_transition(policy: Object) -> void:
	var dispatched: Dictionary = policy.transition(
		policy.default_state(1),
		"MAKE_DISPATCHABLE",
		{"case_id": AFTERLIFE_CASE_ID, "week_index": 2}
	)
	var started: Dictionary = policy.transition(
		dispatched.get("state", {}) as Dictionary,
		"START_MAIN_CASE",
		{"case_id": AFTERLIFE_CASE_ID}
	)
	_expect(bool(started.get("ok", false)), "dispatchable main case could not become ACTIVE")
	_expect(String((started.get("state", {}) as Dictionary).get("main_case_status", "")) == "ACTIVE", "START_MAIN_CASE did not set ACTIVE")
	var wrong_case: Dictionary = policy.transition(
		dispatched.get("state", {}) as Dictionary,
		"START_MAIN_CASE",
		{"case_id": "episode_999_wrong_case"}
	)
	_expect(not bool(wrong_case.get("ok", true)), "different case could start over active monthly case")


func _test_resolution_lock(policy: Object) -> void:
	var dispatched: Dictionary = policy.transition(
		policy.default_state(1),
		"MAKE_DISPATCHABLE",
		{"case_id": AFTERLIFE_CASE_ID, "week_index": 2}
	)
	var resolved: Dictionary = policy.transition(
		dispatched.get("state", {}) as Dictionary,
		"RESOLVE_MAIN_CASE",
		{"result_ref": "result:m01:001"}
	)
	_expect(bool(resolved.get("ok", false)), "main case resolution failed")
	var state := resolved.get("state", {}) as Dictionary
	_expect(bool(state.get("resolved_this_month", false)), "monthly resolution flag missing")
	_expect(bool(state.get("aftermath_available", false)), "aftermath should be available after resolution")
	_expect(String(state.get("main_case_status", "")) == "AFTERMATH", "resolved main case should route to aftermath")
	var blocked: Dictionary = policy.transition(
		state,
		"MAKE_DISPATCHABLE",
		{"case_id": "episode_002_other_case", "week_index": 3}
	)
	_expect(not bool(blocked.get("ok", true)), "second main case spawned after monthly resolution")
	_expect(String(blocked.get("code", "")) == "MAIN_CASE_ALREADY_RESOLVED_THIS_MONTH", "wrong second-case block code")
	var advanced: Dictionary = policy.transition(state, "ADVANCE_WEEK")
	_expect(bool(advanced.get("ok", false)), "aftermath week advance failed")
	_expect(String((advanced.get("state", {}) as Dictionary).get("main_case_status", "")) == "AFTERMATH", "early resolution did not preserve aftermath routing")


func _test_case_truth_boundary(policy: Object) -> void:
	for forbidden_key in ["answer_id", "correct_response_id", "true_hypothesis_id"]:
		var polluted: Dictionary = policy.default_state(1)
		polluted[forbidden_key] = "hidden_truth"
		var validation: Dictionary = policy.validate(polluted)
		_expect(not bool(validation.get("ok", true)), "monthly state accepted case-truth field: %s" % forbidden_key)
		_expect(String(validation.get("code", "")) == "CASE_TRUTH_FIELD_FORBIDDEN", "case-truth boundary code mismatch: %s" % forbidden_key)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("MONTHLY STATE POLICY: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
