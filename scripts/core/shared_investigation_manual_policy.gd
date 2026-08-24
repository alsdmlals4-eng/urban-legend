class_name SharedInvestigationManualPolicy
extends RefCounted

const SCHEMA_VERSION := 1
const FORBIDDEN_TRUTH_FIELDS := [
	"answer_id",
	"true_answer_id",
	"correct_answer_id",
	"hypothesis_id",
	"true_hypothesis_id",
	"correct_hypothesis_id",
	"response_id",
	"true_response_id",
	"correct_response_id"
]


func validate_contract(contract: Dictionary) -> Dictionary:
	var forbidden := _find_forbidden_truth_field(contract)
	if not forbidden.is_empty():
		return {
			"ok": false,
			"code": "HIDDEN_TRUTH_FIELD_FORBIDDEN",
			"field": forbidden
		}
	if int(contract.get("schema_version", 0)) != SCHEMA_VERSION:
		return {"ok": false, "code": "INVALID_SCHEMA_VERSION"}
	if String(contract.get("case_id", "")).is_empty():
		return {"ok": false, "code": "CASE_ID_REQUIRED"}
	var record_ids := _unique_string_array(contract.get("record_ids", []))
	if record_ids.is_empty():
		return {"ok": false, "code": "RECORD_IDS_REQUIRED"}
	if record_ids.size() != (contract.get("record_ids", []) as Array).size():
		return {"ok": false, "code": "DUPLICATE_OR_INVALID_RECORD_ID"}
	var rule_pages_value: Variant = contract.get("rule_pages")
	if typeof(rule_pages_value) != TYPE_ARRAY or (rule_pages_value as Array).is_empty():
		return {"ok": false, "code": "RULE_PAGES_REQUIRED"}
	var rule_ids: Dictionary = {}
	for page_value in rule_pages_value as Array:
		if typeof(page_value) != TYPE_DICTIONARY:
			return {"ok": false, "code": "INVALID_RULE_PAGE"}
		var page := page_value as Dictionary
		var rule_id := String(page.get("id", ""))
		if rule_id.is_empty() or rule_ids.has(rule_id):
			return {"ok": false, "code": "DUPLICATE_OR_MISSING_RULE_ID", "rule_id": rule_id}
		rule_ids[rule_id] = true
		if String(page.get("player_rule_summary", "")).is_empty():
			return {"ok": false, "code": "PLAYER_RULE_SUMMARY_REQUIRED", "rule_id": rule_id}
		var required_value: Variant = page.get("required_record_ids")
		if typeof(required_value) != TYPE_ARRAY or (required_value as Array).is_empty():
			return {"ok": false, "code": "REQUIRED_RECORDS_MISSING", "rule_id": rule_id}
		for record_value in required_value as Array:
			var record_id := String(record_value)
			if record_id.is_empty() or record_id not in record_ids:
				return {
					"ok": false,
					"code": "UNKNOWN_RECORD_REFERENCE",
					"rule_id": rule_id,
					"record_id": record_id
				}
	var gate_value: Variant = contract.get("rescue_gate")
	if typeof(gate_value) != TYPE_DICTIONARY:
		return {"ok": false, "code": "RESCUE_GATE_REQUIRED"}
	var gate := gate_value as Dictionary
	var minimum_records := int(gate.get("minimum_earned_records", 0))
	var minimum_rules := int(gate.get("minimum_completed_rules", 0))
	if minimum_records < 1 or minimum_records > record_ids.size():
		return {"ok": false, "code": "INVALID_MINIMUM_EARNED_RECORDS"}
	if minimum_rules < 1 or minimum_rules > rule_ids.size():
		return {"ok": false, "code": "INVALID_MINIMUM_COMPLETED_RULES"}
	return {
		"ok": true,
		"code": "VALID",
		"record_ids": record_ids,
		"rule_ids": rule_ids.keys()
	}


func evaluate_context(
	contract: Dictionary,
	earned_record_ids_value: Variant,
	completed_rule_ids_value: Variant
) -> Dictionary:
	var validation := validate_contract(contract)
	if not bool(validation.get("ok", false)):
		return validation
	var known_records := _unique_string_array(contract.get("record_ids", []))
	var known_rules: Array[String] = []
	for page_value in contract.get("rule_pages", []) as Array:
		known_rules.append(String((page_value as Dictionary).get("id", "")))
	var earned: Array[String] = []
	for record_id in _unique_string_array(earned_record_ids_value):
		if record_id in known_records:
			earned.append(record_id)
	var completed: Array[String] = []
	for rule_id in _unique_string_array(completed_rule_ids_value):
		if rule_id in known_rules:
			completed.append(rule_id)
	var gate := contract.get("rescue_gate", {}) as Dictionary
	var minimum_records := int(gate.get("minimum_earned_records", 1))
	var minimum_rules := int(gate.get("minimum_completed_rules", 1))
	return {
		"ok": true,
		"code": "CONTEXT_EVALUATED",
		"earned_record_ids": earned,
		"completed_rule_ids": completed,
		"rescue_context_ready": earned.size() >= minimum_records and completed.size() >= minimum_rules,
		"missing_record_count": maxi(minimum_records - earned.size(), 0),
		"missing_rule_count": maxi(minimum_rules - completed.size(), 0)
	}


func _find_forbidden_truth_field(value: Variant) -> String:
	match typeof(value):
		TYPE_DICTIONARY:
			var dictionary := value as Dictionary
			for key_value in dictionary.keys():
				var key := String(key_value)
				if key in FORBIDDEN_TRUTH_FIELDS:
					return key
				var child_result := _find_forbidden_truth_field(dictionary.get(key_value))
				if not child_result.is_empty():
					return child_result
		TYPE_ARRAY:
			for child in value as Array:
				var child_result := _find_forbidden_truth_field(child)
				if not child_result.is_empty():
					return child_result
	return ""


func _unique_string_array(value: Variant) -> Array[String]:
	var result: Array[String] = []
	if typeof(value) != TYPE_ARRAY:
		return result
	for item in value as Array:
		var text := String(item)
		if not text.is_empty() and text not in result:
			result.append(text)
	return result
