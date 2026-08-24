extends SceneTree

const POLICY_PATH := "res://scripts/core/shared_investigation_manual_policy.gd"
var _failures: Array[String] = []


func _init() -> void:
	_expect(FileAccess.file_exists(POLICY_PATH), "shared investigation manual policy missing")
	if FileAccess.file_exists(POLICY_PATH):
		var script_value: Variant = load(POLICY_PATH)
		_expect(script_value is Script, "shared investigation manual policy failed to load")
		if script_value is Script:
			var policy = (script_value as Script).new()
			_test_valid_contract(policy)
			_test_hidden_truth_rejected(policy)
			_test_missing_record_reference_rejected(policy)
	_finish()


func _test_valid_contract(policy: Object) -> void:
	var contract := _valid_contract()
	var result: Dictionary = policy.validate_contract(contract)
	_expect(bool(result.get("ok", false)), "valid shared manual contract rejected")
	_expect(String(result.get("code", "")) == "VALID", "valid contract code mismatch")
	var context: Dictionary = policy.evaluate_context(
		contract,
		["clue_a", "clue_b"],
		["rule_page_a"]
	)
	_expect(bool(context.get("ok", false)), "earned context evaluation failed")
	_expect(bool(context.get("rescue_context_ready", false)), "earned context should unlock rescue grammar")
	_expect((context.get("earned_record_ids", []) as Array).size() == 2, "earned record count mismatch")


func _test_hidden_truth_rejected(policy: Object) -> void:
	var contract := _valid_contract()
	(contract["rule_pages"] as Array)[0]["correct_response_id"] = "hidden_answer"
	var result: Dictionary = policy.validate_contract(contract)
	_expect(not bool(result.get("ok", true)), "shared manual accepted hidden correct response")
	_expect(String(result.get("code", "")) == "HIDDEN_TRUTH_FIELD_FORBIDDEN", "hidden truth rejection code mismatch")


func _test_missing_record_reference_rejected(policy: Object) -> void:
	var contract := _valid_contract()
	(contract["rule_pages"] as Array)[0]["required_record_ids"] = ["missing_record"]
	var result: Dictionary = policy.validate_contract(contract)
	_expect(not bool(result.get("ok", true)), "shared manual accepted missing record reference")
	_expect(String(result.get("code", "")) == "UNKNOWN_RECORD_REFERENCE", "missing record rejection code mismatch")


func _valid_contract() -> Dictionary:
	return {
		"schema_version": 1,
		"case_id": "case_test",
		"record_ids": ["clue_a", "clue_b", "clue_c"],
		"rule_pages": [
			{
				"id": "rule_page_a",
				"required_record_ids": ["clue_a", "clue_b"],
				"player_rule_summary": "관찰된 두 기록을 대조해 안전 행동을 추론한다."
			}
		],
		"rescue_gate": {
			"minimum_earned_records": 2,
			"minimum_completed_rules": 1
		}
	}


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("SHARED INVESTIGATION MANUAL: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
