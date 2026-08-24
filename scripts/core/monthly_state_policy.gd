extends RefCounted

const SCHEMA_VERSION := 1
const VALID_STATUSES := ["DORMANT", "DISPATCHABLE", "ACTIVE", "RESOLVED", "AFTERMATH"]
const FORBIDDEN_CASE_TRUTH_FIELDS := [
	"answer_id",
	"true_answer_id",
	"hypothesis_id",
	"true_hypothesis_id",
	"correct_hypothesis_id"
]


func default_state(month_index: int = 1) -> Dictionary:
	return {
		"schema_version": SCHEMA_VERSION,
		"month_index": maxi(month_index, 1),
		"week_index": 1,
		"active_main_case_id": "",
		"main_case_status": "DORMANT",
		"dispatch_risk": 0,
		"resolved_this_month": false,
		"aftermath_available": false,
		"last_month_result_ref": ""
	}


func normalize(candidate: Dictionary, fallback_month_index: int = 1) -> Dictionary:
	if candidate.is_empty():
		return default_state(fallback_month_index)
	var normalized := default_state(int(candidate.get("month_index", fallback_month_index)))
	for key in normalized:
		if candidate.has(key):
			normalized[key] = candidate.get(key)
	normalized["schema_version"] = SCHEMA_VERSION
	normalized["month_index"] = int(normalized.get("month_index", fallback_month_index))
	normalized["week_index"] = int(normalized.get("week_index", 1))
	normalized["active_main_case_id"] = String(normalized.get("active_main_case_id", ""))
	normalized["main_case_status"] = String(normalized.get("main_case_status", "DORMANT"))
	normalized["dispatch_risk"] = int(normalized.get("dispatch_risk", 0))
	normalized["resolved_this_month"] = bool(normalized.get("resolved_this_month", false))
	normalized["aftermath_available"] = bool(normalized.get("aftermath_available", false))
	normalized["last_month_result_ref"] = String(normalized.get("last_month_result_ref", ""))
	return normalized


func validate(state: Dictionary) -> Dictionary:
	for forbidden_key in FORBIDDEN_CASE_TRUTH_FIELDS:
		if state.has(forbidden_key):
			return {"ok": false, "reason": "case_truth_field_forbidden", "field": forbidden_key}
	if int(state.get("schema_version", 0)) != SCHEMA_VERSION:
		return {"ok": false, "reason": "invalid_schema_version"}
	if int(state.get("month_index", 0)) < 1:
		return {"ok": false, "reason": "invalid_month_index"}
	var week_index := int(state.get("week_index", 0))
	if week_index < 1 or week_index > 4:
		return {"ok": false, "reason": "invalid_week_index"}
	var status := String(state.get("main_case_status", ""))
	if status not in VALID_STATUSES:
		return {"ok": false, "reason": "invalid_main_case_status"}
	var dispatch_risk := int(state.get("dispatch_risk", -1))
	if dispatch_risk not in [0, 15, 30]:
		return {"ok": false, "reason": "invalid_dispatch_risk"}
	if typeof(state.get("resolved_this_month")) != TYPE_BOOL:
		return {"ok": false, "reason": "invalid_resolved_flag"}
	if typeof(state.get("aftermath_available")) != TYPE_BOOL:
		return {"ok": false, "reason": "invalid_aftermath_flag"}
	var active_case_id := String(state.get("active_main_case_id", ""))
	var resolved := bool(state.get("resolved_this_month", false))
	var aftermath := bool(state.get("aftermath_available", false))
	if status == "DORMANT" and not active_case_id.is_empty():
		return {"ok": false, "reason": "dormant_state_has_active_case"}
	if status in ["DISPATCHABLE", "ACTIVE", "RESOLVED", "AFTERMATH"] and active_case_id.is_empty():
		return {"ok": false, "reason": "active_status_missing_case"}
	if status in ["RESOLVED", "AFTERMATH"] and not resolved:
		return {"ok": false, "reason": "resolved_status_missing_flag"}
	if aftermath and status != "AFTERMATH":
		return {"ok": false, "reason": "aftermath_flag_status_mismatch"}
	if status == "AFTERMATH" and not aftermath:
		return {"ok": false, "reason": "aftermath_status_missing_flag"}
	return {"ok": true}


func make_dispatchable(state: Dictionary, case_id: String, week_index: int) -> Dictionary:
	var normalized := normalize(state)
	var validation := validate(normalized)
	if not bool(validation.get("ok", false)):
		return validation
	if bool(normalized.get("resolved_this_month", false)):
		return {"ok": false, "reason": "main_case_already_resolved_this_month"}
	if case_id.is_empty():
		return {"ok": false, "reason": "main_case_id_required"}
	if week_index < 2 or week_index > 4:
		return {"ok": false, "reason": "dispatch_week_out_of_range"}
	var existing_case_id := String(normalized.get("active_main_case_id", ""))
	if not existing_case_id.is_empty() and existing_case_id != case_id:
		return {"ok": false, "reason": "different_main_case_already_active"}
	normalized["week_index"] = week_index
	normalized["active_main_case_id"] = case_id
	normalized["main_case_status"] = "DISPATCHABLE"
	normalized["dispatch_risk"] = _dispatch_risk_for_week(week_index)
	normalized["aftermath_available"] = false
	return {"ok": true, "state": normalized}


func resolve_main_case(state: Dictionary, result_ref: String = "") -> Dictionary:
	var normalized := normalize(state)
	var validation := validate(normalized)
	if not bool(validation.get("ok", false)):
		return validation
	if String(normalized.get("main_case_status", "")) not in ["DISPATCHABLE", "ACTIVE"]:
		return {"ok": false, "reason": "main_case_not_resolvable"}
	normalized["resolved_this_month"] = true
	normalized["aftermath_available"] = true
	normalized["main_case_status"] = "AFTERMATH"
	normalized["last_month_result_ref"] = result_ref
	normalized["dispatch_risk"] = 0
	return {"ok": true, "state": normalized}


func advance_week(state: Dictionary) -> Dictionary:
	var normalized := normalize(state)
	var validation := validate(normalized)
	if not bool(validation.get("ok", false)):
		return validation
	var week_index := int(normalized.get("week_index", 1))
	if week_index >= 4:
		return {"ok": false, "reason": "month_end_reached"}
	normalized["week_index"] = week_index + 1
	if bool(normalized.get("resolved_this_month", false)):
		normalized["main_case_status"] = "AFTERMATH"
		normalized["aftermath_available"] = true
		normalized["dispatch_risk"] = 0
	elif String(normalized.get("main_case_status", "")) in ["DISPATCHABLE", "ACTIVE"]:
		normalized["dispatch_risk"] = _dispatch_risk_for_week(int(normalized["week_index"]))
	return {"ok": true, "state": normalized}


func _dispatch_risk_for_week(week_index: int) -> int:
	match week_index:
		2:
			return 0
		3:
			return 15
		4:
			return 30
		_:
			return 0
