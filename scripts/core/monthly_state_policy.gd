extends RefCounted

const SCHEMA_VERSION := 1
const VALID_STATUSES := ["DORMANT", "DISPATCHABLE", "ACTIVE", "RESOLVED", "AFTERMATH"]
const FORBIDDEN_CASE_TRUTH_FIELDS := [
	"answer_id",
	"true_answer_id",
	"correct_response_id",
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
			return _failure("CASE_TRUTH_FIELD_FORBIDDEN", forbidden_key)
	if int(state.get("schema_version", 0)) != SCHEMA_VERSION:
		return _failure("INVALID_SCHEMA_VERSION")
	if int(state.get("month_index", 0)) < 1:
		return _failure("INVALID_MONTH_INDEX")
	var week_index := int(state.get("week_index", 0))
	if week_index < 1 or week_index > 4:
		return _failure("INVALID_WEEK_INDEX")
	var status := String(state.get("main_case_status", ""))
	if status not in VALID_STATUSES:
		return _failure("INVALID_MAIN_CASE_STATUS")
	var dispatch_risk := int(state.get("dispatch_risk", -1))
	if dispatch_risk not in [0, 15, 30]:
		return _failure("INVALID_DISPATCH_RISK")
	if typeof(state.get("resolved_this_month")) != TYPE_BOOL:
		return _failure("INVALID_RESOLVED_FLAG")
	if typeof(state.get("aftermath_available")) != TYPE_BOOL:
		return _failure("INVALID_AFTERMATH_FLAG")
	var active_case_id := String(state.get("active_main_case_id", ""))
	var resolved := bool(state.get("resolved_this_month", false))
	var aftermath := bool(state.get("aftermath_available", false))
	if status == "DORMANT" and not active_case_id.is_empty():
		return _failure("DORMANT_STATE_HAS_ACTIVE_CASE")
	if status in ["DISPATCHABLE", "ACTIVE", "RESOLVED", "AFTERMATH"] and active_case_id.is_empty():
		return _failure("ACTIVE_STATUS_MISSING_CASE")
	if status in ["RESOLVED", "AFTERMATH"] and not resolved:
		return _failure("RESOLVED_STATUS_MISSING_FLAG")
	if aftermath and status != "AFTERMATH":
		return _failure("AFTERMATH_FLAG_STATUS_MISMATCH")
	if status == "AFTERMATH" and not aftermath:
		return _failure("AFTERMATH_STATUS_MISSING_FLAG")
	return {"ok": true, "code": "VALID"}


func transition(state: Dictionary, event: String, payload: Dictionary = {}) -> Dictionary:
	var result: Dictionary
	match event:
		"MAKE_DISPATCHABLE":
			result = make_dispatchable(
				state,
				String(payload.get("case_id", "")),
				int(payload.get("week_index", 0))
			)
		"START_MAIN_CASE":
			result = start_main_case(state, String(payload.get("case_id", "")))
		"RESOLVE_MAIN_CASE":
			result = resolve_main_case(state, String(payload.get("result_ref", "")))
		"ADVANCE_WEEK":
			result = advance_week(state)
		_:
			return _failure("UNKNOWN_EVENT")
	if not bool(result.get("ok", false)):
		return result
	return {
		"ok": true,
		"code": "TRANSITION_APPLIED",
		"event": event,
		"state": (result.get("state", {}) as Dictionary).duplicate(true)
	}


func make_dispatchable(state: Dictionary, case_id: String, week_index: int) -> Dictionary:
	var normalized := normalize(state)
	var validation := validate(normalized)
	if not bool(validation.get("ok", false)):
		return validation
	if bool(normalized.get("resolved_this_month", false)):
		return _failure("MAIN_CASE_ALREADY_RESOLVED_THIS_MONTH")
	if case_id.is_empty():
		return _failure("MAIN_CASE_ID_REQUIRED")
	if week_index < 2 or week_index > 4:
		return _failure("DISPATCH_WEEK_OUT_OF_RANGE")
	var existing_case_id := String(normalized.get("active_main_case_id", ""))
	if not existing_case_id.is_empty() and existing_case_id != case_id:
		return _failure("DIFFERENT_MAIN_CASE_ALREADY_ACTIVE")
	normalized["week_index"] = week_index
	normalized["active_main_case_id"] = case_id
	normalized["main_case_status"] = "DISPATCHABLE"
	normalized["dispatch_risk"] = _dispatch_risk_for_week(week_index)
	normalized["aftermath_available"] = false
	return {"ok": true, "code": "DISPATCHABLE", "state": normalized}


func start_main_case(state: Dictionary, case_id: String) -> Dictionary:
	var normalized := normalize(state)
	var validation := validate(normalized)
	if not bool(validation.get("ok", false)):
		return validation
	if bool(normalized.get("resolved_this_month", false)):
		return _failure("MAIN_CASE_ALREADY_RESOLVED_THIS_MONTH")
	if case_id.is_empty():
		return _failure("MAIN_CASE_ID_REQUIRED")
	var active_case_id := String(normalized.get("active_main_case_id", ""))
	if active_case_id != case_id:
		return _failure("DIFFERENT_MAIN_CASE_ALREADY_ACTIVE")
	var status := String(normalized.get("main_case_status", ""))
	if status == "ACTIVE":
		return {"ok": true, "code": "MAIN_CASE_ALREADY_ACTIVE", "state": normalized}
	if status != "DISPATCHABLE":
		return _failure("MAIN_CASE_NOT_DISPATCHABLE")
	normalized["main_case_status"] = "ACTIVE"
	return {"ok": true, "code": "MAIN_CASE_STARTED", "state": normalized}


func resolve_main_case(state: Dictionary, result_ref: String = "") -> Dictionary:
	var normalized := normalize(state)
	var validation := validate(normalized)
	if not bool(validation.get("ok", false)):
		return validation
	if String(normalized.get("main_case_status", "")) not in ["DISPATCHABLE", "ACTIVE"]:
		return _failure("MAIN_CASE_NOT_RESOLVABLE")
	normalized["resolved_this_month"] = true
	normalized["aftermath_available"] = true
	normalized["main_case_status"] = "AFTERMATH"
	normalized["last_month_result_ref"] = result_ref
	normalized["dispatch_risk"] = 0
	return {"ok": true, "code": "MAIN_CASE_RESOLVED", "state": normalized}


func advance_week(state: Dictionary) -> Dictionary:
	var normalized := normalize(state)
	var validation := validate(normalized)
	if not bool(validation.get("ok", false)):
		return validation
	var week_index := int(normalized.get("week_index", 1))
	if week_index >= 4:
		return _failure("MONTH_END_REACHED")
	normalized["week_index"] = week_index + 1
	if bool(normalized.get("resolved_this_month", false)):
		normalized["main_case_status"] = "AFTERMATH"
		normalized["aftermath_available"] = true
		normalized["dispatch_risk"] = 0
	elif String(normalized.get("main_case_status", "")) in ["DISPATCHABLE", "ACTIVE"]:
		normalized["dispatch_risk"] = _dispatch_risk_for_week(int(normalized["week_index"]))
	return {"ok": true, "code": "WEEK_ADVANCED", "state": normalized}


func _failure(code: String, field: String = "") -> Dictionary:
	var result := {
		"ok": false,
		"code": code,
		"reason": code.to_lower()
	}
	if not field.is_empty():
		result["field"] = field
	return result


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
