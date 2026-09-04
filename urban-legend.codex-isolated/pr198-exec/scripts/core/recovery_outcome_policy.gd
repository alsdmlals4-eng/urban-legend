class_name RecoveryOutcomePolicy
extends RefCounted

const CONTROL_OUTCOMES := [
	"residue_recovered",
	"containment_complete",
	"stabilization_complete",
	"emergency_containment"
]


func evaluate_termination_candidate(candidate: String, context: Dictionary) -> Dictionary:
	var blocking_reasons: Array = []
	var non_blocking_consequences := _protection_consequences(context.get("obligations", []))
	var accountable_transfer: Array = []

	if candidate in CONTROL_OUTCOMES:
		blocking_reasons.append_array(_control_blockers(candidate, context))
	elif candidate == "approved_withdrawal":
		blocking_reasons.append_array(_withdrawal_blockers(context))
		accountable_transfer = _valid_transfers(context.get("obligations", []))
	elif candidate == "control_failure":
		pass
	else:
		blocking_reasons.append("unknown_termination_candidate")

	var eligible := blocking_reasons.is_empty()
	return {
		"termination_candidate": candidate,
		"eligible": eligible,
		"blocking_reasons": blocking_reasons,
		"non_blocking_consequences": non_blocking_consequences,
		"accountable_transfer": accountable_transfer,
		"retreat_selectable": true,
		"fallback_outcome": "control_failure" if candidate == "approved_withdrawal" and not eligible else ""
	}


func select_representative_outcome(context: Dictionary) -> Dictionary:
	for candidate in [
		"residue_recovered",
		"containment_complete",
		"stabilization_complete",
		"emergency_containment",
		"approved_withdrawal"
	]:
		var evaluation := evaluate_termination_candidate(candidate, context)
		if bool(evaluation.get("eligible", false)):
			return {
				"representative_outcome": candidate,
				"evaluation": evaluation
			}
	return {
		"representative_outcome": "control_failure",
		"evaluation": evaluate_termination_candidate("control_failure", context)
	}


func build_independent_result_packet(
	incident_end_snapshot: Dictionary,
	current_state: Dictionary,
	follow_up_records: Array = []
) -> Dictionary:
	return {
		"incident_end_snapshot": incident_end_snapshot.duplicate(true),
		"current_state": current_state.duplicate(true),
		"control_axis": _dictionary_copy(current_state.get("control_axis")),
		"protection_responsibility_axis": {
			"incident_end": String(incident_end_snapshot.get("protection_status", "unknown")),
			"current": String(current_state.get("protection_status", "unknown")),
			"reasons": _array_copy(current_state.get("protection_reasons"))
		},
		"evidence_integrity_axis": _dictionary_copy(current_state.get("evidence_integrity_axis")),
		"follow_up_execution_axis": {
			"records": follow_up_records.duplicate(true),
			"current": String(current_state.get("follow_up_status", "not_started"))
		},
		"mastery_axis": _dictionary_copy(current_state.get("mastery_axis"))
	}


func _control_blockers(candidate: String, context: Dictionary) -> Array:
	var evidence := _dictionary_copy(context.get("control_evidence"))
	var blockers: Array = []
	match candidate:
		"residue_recovered":
			if not bool(evidence.get("residue_secured", false)):
				blockers.append("residue_not_secured")
			if not bool(evidence.get("spread_controlled", false)):
				blockers.append("spread_not_controlled")
		"containment_complete":
			if not bool(evidence.get("sustainable_containment", false)):
				blockers.append("sustainable_containment_missing")
		"stabilization_complete":
			if not bool(evidence.get("manifestation_stopped", false)):
				blockers.append("manifestation_not_stopped")
		"emergency_containment":
			if not bool(evidence.get("catastrophe_prevented", false)):
				blockers.append("catastrophe_not_prevented")
	return blockers


func _withdrawal_blockers(context: Dictionary) -> Array:
	var blockers: Array = []
	if not bool(context.get("safe_route", false)):
		blockers.append("safe_route_missing")
	if not bool(context.get("withdrawal_reason_recorded", false)):
		blockers.append("withdrawal_reason_missing")
	if not bool(context.get("before_control_collapse", false)):
		blockers.append("withdrawal_not_before_control_collapse")

	for obligation_value in _array_copy(context.get("obligations")):
		if typeof(obligation_value) != TYPE_DICTIONARY:
			continue
		var obligation := obligation_value as Dictionary
		var status := String(obligation.get("status", "unresolved"))
		var priority := String(obligation.get("priority_class", "watch"))
		if status == "transferred":
			if String(obligation.get("accountable_owner", "")).is_empty() or String(obligation.get("follow_up_condition", "")).is_empty():
				blockers.append("invalid_transfer:%s" % String(obligation.get("obligation_id", "")))
			continue
		if status == "deferred_with_owner":
			if String(obligation.get("accountable_owner", "")).is_empty() or String(obligation.get("follow_up_condition", "")).is_empty():
				blockers.append("invalid_defer:%s" % String(obligation.get("obligation_id", "")))
			continue
		if status == "unresolved" and priority == "critical":
			blockers.append("critical_unresolved:%s" % String(obligation.get("obligation_id", "")))
	return blockers


func _protection_consequences(obligations_value: Variant) -> Array:
	var consequences: Array = []
	for obligation_value in _array_copy(obligations_value):
		if typeof(obligation_value) != TYPE_DICTIONARY:
			continue
		var obligation := obligation_value as Dictionary
		var status := String(obligation.get("status", "unresolved"))
		if status == "completed":
			continue
		consequences.append({
			"obligation_id": String(obligation.get("obligation_id", "")),
			"status": status,
			"priority_class": String(obligation.get("priority_class", "watch")),
			"source_reason": String(obligation.get("source_reason", "")),
			"target": String(obligation.get("target", ""))
		})
	return consequences


func _valid_transfers(obligations_value: Variant) -> Array:
	var transfers: Array = []
	for obligation_value in _array_copy(obligations_value):
		if typeof(obligation_value) != TYPE_DICTIONARY:
			continue
		var obligation := obligation_value as Dictionary
		if String(obligation.get("status", "")) not in ["transferred", "deferred_with_owner"]:
			continue
		var owner := String(obligation.get("accountable_owner", ""))
		var condition := String(obligation.get("follow_up_condition", ""))
		if owner.is_empty() or condition.is_empty():
			continue
		transfers.append({
			"obligation_id": String(obligation.get("obligation_id", "")),
			"accountable_owner": owner,
			"follow_up_condition": condition
		})
	return transfers


func _dictionary_copy(value: Variant) -> Dictionary:
	return (value as Dictionary).duplicate(true) if typeof(value) == TYPE_DICTIONARY else {}


func _array_copy(value: Variant) -> Array:
	return (value as Array).duplicate(true) if typeof(value) == TYPE_ARRAY else []
