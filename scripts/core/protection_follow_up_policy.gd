class_name ProtectionFollowUpPolicy
extends RefCounted

const TERMINAL_OBLIGATION_STATES := [
	"completed",
	"transferred",
	"deferred_with_owner",
	"breached",
	"unresolved"
]

const RESOLUTION_STATES := [
	"open",
	"completed",
	"mitigated",
	"transferred",
	"deferred_with_owner",
	"accepted_residual_risk",
	"closed_no_action",
	"escalated_once",
	"failed_with_record"
]


func build_follow_up_records(
	case_id: String,
	campaign_canon_id: String,
	obligations: Array,
	incident_end_packet: Dictionary,
	authoring_rules: Dictionary = {}
) -> Dictionary:
	var records: Array = []
	var errors: Array = []
	var seen: Dictionary = {}
	var default_step_limit := maxi(0, int(authoring_rules.get("default_step_limit", 1)))
	var canon_reference := String(incident_end_packet.get("case_canon_reference", "%s:incident_end" % case_id))

	for obligation_value in obligations:
		if typeof(obligation_value) != TYPE_DICTIONARY:
			errors.append("invalid_obligation_type")
			continue
		var obligation := obligation_value as Dictionary
		var obligation_id := String(obligation.get("obligation_id", ""))
		var source_status := String(obligation.get("status", "unresolved"))
		var source_reason := String(obligation.get("source_reason", ""))
		if obligation_id.is_empty() or source_reason.is_empty():
			errors.append("missing_follow_up_source")
			continue
		if source_status not in TERMINAL_OBLIGATION_STATES:
			errors.append("invalid_obligation_status:%s" % source_status)
			continue
		var dedupe_key := make_dedupe_key(case_id, obligation_id, source_reason, campaign_canon_id)
		if seen.has(dedupe_key):
			continue
		seen[dedupe_key] = true

		var rule := _dictionary_copy(authoring_rules.get(source_status))
		var record_result := _build_record_for_status(
			case_id,
			campaign_canon_id,
			obligation,
			canon_reference,
			dedupe_key,
			rule,
			default_step_limit,
			records.size()
		)
		if not bool(record_result.get("create", false)):
			continue
		records.append((record_result.get("record", {}) as Dictionary).duplicate(true))

	return {
		"ok": errors.is_empty(),
		"records": records,
		"errors": errors
	}


func evaluate_reentry(follow_up_record: Dictionary, current_context: Dictionary) -> Dictionary:
	var actionable := bool(current_context.get("actionable_reason", follow_up_record.get("actionable_reason", false)))
	var hazard_state := String(current_context.get("hazard_state", "unknown"))
	var route_state := String(current_context.get("route_state", "unknown"))
	var authority_state := String(current_context.get("authority_state", "unknown"))
	var capability_state := String(current_context.get("capability_state", "unknown"))
	var alternatives := _default_alternative_follow_up()

	if not actionable:
		return _reentry_result("not_actionable", false, ["actionable_reason_missing"], alternatives)
	if hazard_state in ["catastrophic", "unbounded"] or route_state == "closed":
		return _reentry_result("unsafe_hold", false, ["unsafe_or_closed_route"], alternatives)
	if authority_state in ["none", "denied"]:
		return _reentry_result("not_eligible_use_alternative", false, ["authority_missing"], alternatives)
	if capability_state in ["insufficient", "none"]:
		return _reentry_result("eligible_with_conditions", false, ["capability_missing"], alternatives)
	if route_state in ["conditional", "limited"]:
		return _reentry_result("eligible_with_conditions", false, ["route_conditions_required"], alternatives)
	return _reentry_result("eligible", true, [], alternatives)


func advance_follow_up(follow_up_record: Dictionary, action_result: Dictionary) -> Dictionary:
	var record := follow_up_record.duplicate(true)
	var current_resolution := String(record.get("resolution_state", "open"))
	if current_resolution != "open":
		return {"ok": false, "error": "follow_up_already_resolved", "record": record}

	var step_index := int(record.get("step_index", 0)) + 1
	var step_limit := maxi(0, int(record.get("step_limit", 0)))
	var outcome := String(action_result.get("outcome", "failed"))
	var history := _array_copy(record.get("causal_history"))
	history.append({
		"step_index": step_index,
		"action_id": String(action_result.get("action_id", "")),
		"outcome": outcome,
		"reason": String(action_result.get("reason", ""))
	})
	record["step_index"] = step_index
	record["causal_history"] = history

	match outcome:
		"completed":
			record["resolution_state"] = "completed"
			record["active"] = false
		"mitigated":
			record["resolution_state"] = "mitigated"
			record["active"] = false
		"transferred":
			if String(action_result.get("accountable_owner", "")).is_empty() or String(action_result.get("follow_up_condition", "")).is_empty():
				return {"ok": false, "error": "invalid_follow_up_transfer", "record": follow_up_record.duplicate(true)}
			record["resolution_state"] = "transferred"
			record["accountable_owner"] = String(action_result.get("accountable_owner", ""))
			record["trigger_condition"] = String(action_result.get("follow_up_condition", ""))
			record["active"] = false
		"deferred_with_owner":
			if String(action_result.get("accountable_owner", "")).is_empty() or String(action_result.get("follow_up_condition", "")).is_empty():
				return {"ok": false, "error": "invalid_follow_up_defer", "record": follow_up_record.duplicate(true)}
			record["resolution_state"] = "deferred_with_owner"
			record["accountable_owner"] = String(action_result.get("accountable_owner", ""))
			record["trigger_condition"] = String(action_result.get("follow_up_condition", ""))
			record["active"] = false
		_:
			if step_index >= step_limit:
				var fallback := String(action_result.get("bounded_resolution", "failed_with_record"))
				if fallback not in ["accepted_residual_risk", "failed_with_record", "transferred", "closed_no_action"]:
					fallback = "failed_with_record"
				record["resolution_state"] = fallback
				record["active"] = false

	return {"ok": true, "record": record}


func build_evaluation_packet(
	incident_end_packet: Dictionary,
	follow_up_records: Array,
	mastery_rules: Dictionary = {}
) -> Dictionary:
	var current_follow_up_state := "not_started"
	var active_count := 0
	var mitigated_count := 0
	for record_value in follow_up_records:
		if typeof(record_value) != TYPE_DICTIONARY:
			continue
		var record := record_value as Dictionary
		if bool(record.get("active", false)):
			active_count += 1
		if String(record.get("resolution_state", "")) == "mitigated":
			mitigated_count += 1
	if active_count > 0:
		current_follow_up_state = "active"
	elif mitigated_count > 0:
		current_follow_up_state = "mitigated"
	elif not follow_up_records.is_empty():
		current_follow_up_state = "resolved"

	var mastery_axis := {
		"ceiling_applied": false,
		"reason": "",
		"constraints": []
	}
	for rule_key in mastery_rules:
		var rule := _dictionary_copy(mastery_rules.get(rule_key))
		if bool(rule.get("avoidable", false)) and String(rule.get("severity", "")) == "severe" and bool(rule.get("pre_authored", false)):
			mastery_axis["ceiling_applied"] = true
			mastery_axis["reason"] = "avoidable_severe_breach"
			(mastery_axis["constraints"] as Array).append(rule.duplicate(true))

	return {
		"incident_end_snapshot": incident_end_packet.duplicate(true),
		"current_follow_up_state": current_follow_up_state,
		"control_axis": {
			"status": String(incident_end_packet.get("representative_outcome", "unknown")),
			"preserved_from_incident_end": true
		},
		"protection_responsibility_axis": {
			"incident_end": String(incident_end_packet.get("protection_status", "unknown")),
			"current": String(incident_end_packet.get("protection_status", "unknown")),
			"original_result_rewritten": false
		},
		"evidence_integrity_axis": _dictionary_copy(incident_end_packet.get("evidence_integrity_axis")),
		"follow_up_execution_axis": {
			"current": current_follow_up_state,
			"records": follow_up_records.duplicate(true)
		},
		"mastery_axis": mastery_axis
	}


func make_dedupe_key(case_id: String, obligation_id: String, source_reason: String, campaign_canon_id: String) -> String:
	return "%s|%s|%s|%s" % [case_id, obligation_id, source_reason, campaign_canon_id]


func _build_record_for_status(
	case_id: String,
	campaign_canon_id: String,
	obligation: Dictionary,
	canon_reference: String,
	dedupe_key: String,
	rule: Dictionary,
	default_step_limit: int,
	created_order: int
) -> Dictionary:
	var status := String(obligation.get("status", "unresolved"))
	var create_record := true
	var active := false
	var actionable_reason: Variant = rule.get("actionable", false)
	var trigger_condition: Variant = obligation.get("follow_up_condition", rule.get("trigger_condition", ""))
	var accountable_owner: Variant = obligation.get("accountable_owner", rule.get("accountable_owner", ""))

	match status:
		"completed":
			create_record = bool(rule.get("monitoring_required", false))
			active = create_record and bool(rule.get("activate_immediately", false))
		"transferred":
			create_record = not String(accountable_owner).is_empty()
			active = bool(rule.get("verify_transfer", true)) and create_record
		"deferred_with_owner":
			create_record = not String(accountable_owner).is_empty() and not String(trigger_condition).is_empty()
			active = bool(rule.get("trigger_met", false))
		"breached":
			create_record = bool(rule.get("actionable", true))
			active = create_record
			actionable_reason = rule.get("actionable_reason", obligation.get("source_reason", "breach_mitigation"))
		"unresolved":
			create_record = bool(rule.get("actionable", false))
			active = create_record
			actionable_reason = rule.get("actionable_reason", obligation.get("source_reason", "unresolved_follow_up"))

	if not create_record:
		return {"create": false}

	var follow_up_id := "follow_up:%s" % dedupe_key.sha256_text().substr(0, 16)
	return {
		"create": true,
		"record": {
			"follow_up_id": follow_up_id,
			"case_id": case_id,
			"campaign_canon_id": campaign_canon_id,
			"source_obligation_id": String(obligation.get("obligation_id", "")),
			"source_status": status,
			"source_reason": String(obligation.get("source_reason", "")),
			"case_canon_reference": canon_reference,
			"dedupe_key": dedupe_key,
			"accountable_owner": accountable_owner,
			"trigger_condition": trigger_condition,
			"actionable_reason": actionable_reason,
			"reentry_eligibility": {},
			"resolution_state": "open",
			"step_index": 0,
			"step_limit": maxi(0, int(rule.get("step_limit", default_step_limit))),
			"reward_claim_state": "unclaimed",
			"created_order": created_order,
			"active": active,
			"causal_history": [{
				"event": "follow_up_created",
				"source_status": status,
				"source_reason": String(obligation.get("source_reason", ""))
			}],
			"legacy_provenance": _dictionary_copy(obligation.get("legacy_provenance"))
		}
	}


func _reentry_result(status: String, eligible: bool, blocking_reasons: Array, alternatives: Array) -> Dictionary:
	return {
		"status": status,
		"eligible": eligible,
		"blocking_reasons": blocking_reasons,
		"alternative_follow_up": alternatives
	}


func _default_alternative_follow_up() -> Array:
	return [
		"remote_monitoring",
		"record_analysis",
		"medical_or_psychological_support",
		"owner_verification",
		"medium_tracking",
		"record_preservation"
	]


func _dictionary_copy(value: Variant) -> Dictionary:
	return (value as Dictionary).duplicate(true) if typeof(value) == TYPE_DICTIONARY else {}


func _array_copy(value: Variant) -> Array:
	return (value as Array).duplicate(true) if typeof(value) == TYPE_ARRAY else []
