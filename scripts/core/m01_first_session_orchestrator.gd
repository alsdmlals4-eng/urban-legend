class_name M01FirstSessionOrchestrator
extends RefCounted

const SCHEMA_VERSION := 1
const M01_CASE_ID := "episode_001_afterlife_station"
const MIN_EARNED_RECORDS := 2
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
const FORBIDDEN_HIDDEN_TRUTH_KEYS := [
	"answer_id",
	"true_answer_id",
	"correct_response_id",
	"true_hypothesis_id",
	"correct_hypothesis_id",
	"required_hidden_answer_id"
]


func default_state() -> Dictionary:
	return {
		"schema_version": SCHEMA_VERSION,
		"phase": "OPENING_RECORD"
	}


func normalize(candidate: Dictionary) -> Dictionary:
	if candidate.is_empty():
		return default_state()
	return {
		"schema_version": SCHEMA_VERSION,
		"phase": String(candidate.get("phase", "OPENING_RECORD"))
	}


func validate(state: Dictionary) -> Dictionary:
	if _contains_hidden_truth_key(state):
		return _failure("ORCHESTRATOR_TRUTH_OWNERSHIP_FORBIDDEN")
	if int(state.get("schema_version", 0)) != SCHEMA_VERSION:
		return _failure("INVALID_SCHEMA_VERSION")
	var phase := String(state.get("phase", ""))
	if phase not in PHASES:
		return _failure("INVALID_PHASE")
	return {"ok": true, "code": "VALID"}


func available_actions(state: Dictionary, runtime_snapshot: Dictionary) -> Array:
	var state_validation := validate(state)
	if not bool(state_validation.get("ok", false)):
		return []
	if _contains_hidden_truth_key(runtime_snapshot):
		return []
	var normalized := normalize(state)
	var phase := String(normalized.get("phase", ""))
	var phase_index := PHASES.find(phase)
	if phase_index < 0 or phase_index >= PHASES.size() - 1:
		return []
	var target_phase := String(PHASES[phase_index + 1])
	var gate := _gate_transition(phase, target_phase, runtime_snapshot)
	return [target_phase] if bool(gate.get("ok", false)) else []


func apply_event(state: Dictionary, event: String, runtime_snapshot: Dictionary = {}) -> Dictionary:
	var state_validation := validate(state)
	if not bool(state_validation.get("ok", false)):
		return state_validation
	if _contains_hidden_truth_key(runtime_snapshot):
		return _failure("SERIAL_EXAM_FATIGUE_GUARD_BLOCKED")
	var normalized := normalize(state)
	var phase := String(normalized.get("phase", ""))
	var phase_index := PHASES.find(phase)
	if phase_index < 0 or phase_index >= PHASES.size() - 1:
		return _failure("FIRST_SESSION_ALREADY_COMPLETE")
	var expected_target := String(PHASES[phase_index + 1])
	if event != expected_target:
		return _failure("EVENT_NOT_AVAILABLE")
	var gate := _gate_transition(phase, event, runtime_snapshot)
	if not bool(gate.get("ok", false)):
		return gate
	var next_state := normalized.duplicate(true)
	next_state["phase"] = event
	return {
		"ok": true,
		"code": "PHASE_ADVANCED",
		"event": event,
		"state": next_state
	}


func _gate_transition(current_phase: String, target_phase: String, runtime_snapshot: Dictionary) -> Dictionary:
	match target_phase:
		"BUREAU_FIRST_TASK", "RESTRICTED_SCHEDULE":
			return {"ok": true, "code": "READY"}
		"M01_DISPATCHABLE":
			return _gate_m01_dispatchable(runtime_snapshot)
		"M01_INVESTIGATION":
			return {"ok": true, "code": "READY"}
		"M01_DEDUCTION":
			if _earned_record_ids(runtime_snapshot).size() < MIN_EARNED_RECORDS:
				return _failure("INVESTIGATION_EVIDENCE_REQUIRED")
			return {"ok": true, "code": "READY"}
		"M01_RESCUE":
			if not _earned_context_ready(runtime_snapshot):
				return _failure("EARNED_CONTEXT_REQUIRED")
			return {"ok": true, "code": "READY"}
		"M01_RECOVERY":
			if not _earned_context_ready(runtime_snapshot):
				return _failure("EARNED_CONTEXT_REQUIRED")
			var canon_runtime := _dictionary_copy(runtime_snapshot.get("canon_v2_runtime"))
			if _dictionary_copy(canon_runtime.get("rescue_outcome_snapshot")).is_empty():
				return _failure("RESCUE_OUTCOME_REQUIRED")
			return {"ok": true, "code": "READY"}
		"M01_COMPOSITE_RESULT":
			if not _earned_context_ready(runtime_snapshot):
				return _failure("EARNED_CONTEXT_REQUIRED")
			var canon_runtime := _dictionary_copy(runtime_snapshot.get("canon_v2_runtime"))
			var incident_packet := _dictionary_copy(canon_runtime.get("incident_end_packet"))
			var representative_outcome := String(canon_runtime.get("representative_outcome", ""))
			if incident_packet.is_empty() or representative_outcome.is_empty():
				return _failure("COMPOSITE_RESULT_REQUIRED")
			return {"ok": true, "code": "READY"}
		"MONTHLY_AFTERMATH":
			var monthly := _dictionary_copy(runtime_snapshot.get("monthly_state"))
			if not bool(monthly.get("resolved_this_month", false)):
				return _failure("MONTHLY_RESOLUTION_REQUIRED")
			if not bool(monthly.get("aftermath_available", false)):
				return _failure("MONTHLY_AFTERMATH_REQUIRED")
			if String(monthly.get("main_case_status", "")) != "AFTERMATH":
				return _failure("MONTHLY_AFTERMATH_REQUIRED")
			return {"ok": true, "code": "READY"}
	return _failure("UNSUPPORTED_PHASE_TRANSITION", current_phase)


func _gate_m01_dispatchable(runtime_snapshot: Dictionary) -> Dictionary:
	var monthly := _dictionary_copy(runtime_snapshot.get("monthly_state"))
	if String(monthly.get("active_main_case_id", "")) != M01_CASE_ID:
		return _failure("M01_MAIN_CASE_NOT_ACTIVE")
	if String(monthly.get("main_case_status", "")) != "DISPATCHABLE":
		return _failure("M01_NOT_DISPATCHABLE")
	if bool(monthly.get("resolved_this_month", false)):
		return _failure("M01_ALREADY_RESOLVED")
	return {"ok": true, "code": "READY"}


func _earned_context_ready(runtime_snapshot: Dictionary) -> bool:
	return _earned_record_ids(runtime_snapshot).size() >= MIN_EARNED_RECORDS \
		and not _earned_manual_rule_ids(runtime_snapshot).is_empty()


func _earned_record_ids(runtime_snapshot: Dictionary) -> Array[String]:
	var manual := _dictionary_copy(runtime_snapshot.get("manual_state"))
	var result: Array[String] = []
	for record_value in _array_copy(manual.get("evidence_records")):
		if typeof(record_value) != TYPE_DICTIONARY:
			continue
		var record := record_value as Dictionary
		var record_id := String(record.get("id", ""))
		var state := String(record.get("state", ""))
		if record_id.is_empty():
			continue
		if state in ["", "unverified", "migrated_unverified", "locked"]:
			continue
		if record_id not in result:
			result.append(record_id)
	return result


func _earned_manual_rule_ids(runtime_snapshot: Dictionary) -> Array[String]:
	var manual := _dictionary_copy(runtime_snapshot.get("manual_state"))
	var active_rule_ids := _string_array(manual.get("active_rule_ids"))
	if not active_rule_ids.is_empty():
		return active_rule_ids
	var completed_page_ids := _string_array(manual.get("completed_page_ids"))
	if not completed_page_ids.is_empty():
		return completed_page_ids
	var filled_slots := _dictionary_copy(manual.get("filled_slots"))
	if filled_slots.is_empty():
		return []
	var result: Array[String] = []
	for page_value in _array_copy(manual.get("pages")):
		if typeof(page_value) != TYPE_DICTIONARY:
			continue
		var page := page_value as Dictionary
		var page_id := String(page.get("id", ""))
		var required_slots := _string_array(page.get("slot_ids"))
		if page_id.is_empty() or required_slots.is_empty():
			continue
		var complete := true
		for slot_id in required_slots:
			if not filled_slots.has(slot_id):
				complete = false
				break
		if complete:
			result.append(page_id)
	return result


func _contains_hidden_truth_key(value: Variant) -> bool:
	match typeof(value):
		TYPE_DICTIONARY:
			var dictionary := value as Dictionary
			for key in dictionary.keys():
				var key_string := String(key)
				if key_string in FORBIDDEN_HIDDEN_TRUTH_KEYS:
					return true
				if _contains_hidden_truth_key(dictionary.get(key)):
					return true
		TYPE_ARRAY:
			for child in value as Array:
				if _contains_hidden_truth_key(child):
					return true
	return false


func _failure(code: String, detail: String = "") -> Dictionary:
	var result := {
		"ok": false,
		"code": code,
		"reason": code.to_lower()
	}
	if not detail.is_empty():
		result["detail"] = detail
	return result


func _dictionary_copy(value: Variant) -> Dictionary:
	return (value as Dictionary).duplicate(true) if typeof(value) == TYPE_DICTIONARY else {}


func _array_copy(value: Variant) -> Array:
	return (value as Array).duplicate(true) if typeof(value) == TYPE_ARRAY else []


func _string_array(value: Variant) -> Array[String]:
	var result: Array[String] = []
	if typeof(value) != TYPE_ARRAY:
		return result
	for item in value as Array:
		var item_string := String(item)
		if not item_string.is_empty() and item_string not in result:
			result.append(item_string)
	return result
