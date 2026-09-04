class_name RescueRecoveryHandoffPolicy
extends RefCounted

const REQUIRED_SNAPSHOT_KEYS := [
	"snapshot_id",
	"survival_state",
	"separation_state",
	"aftereffects",
	"observed_failure_reasons",
	"irreversible_results",
	"provenance"
]

const VALID_SURVIVAL_STATES := [
	"alive_stable",
	"alive_critical",
	"lost",
	"dead",
	"missing_unknown"
]

const VALID_SEPARATION_STATES := [
	"complete",
	"partial",
	"failed",
	"irreversible"
]


func validate_snapshot(snapshot: Dictionary) -> Dictionary:
	for key_value in REQUIRED_SNAPSHOT_KEYS:
		var key := String(key_value)
		if not snapshot.has(key):
			return {
				"ok": false,
				"error": "handoff_validation_failed",
				"reason": "missing_required_field",
				"missing_key": key
			}
	if String(snapshot.get("snapshot_id", "")).is_empty():
		return {"ok": false, "error": "handoff_validation_failed", "reason": "empty_snapshot_id"}
	if String(snapshot.get("survival_state", "")) not in VALID_SURVIVAL_STATES:
		return {"ok": false, "error": "handoff_validation_failed", "reason": "invalid_survival_state"}
	if String(snapshot.get("separation_state", "")) not in VALID_SEPARATION_STATES:
		return {"ok": false, "error": "handoff_validation_failed", "reason": "invalid_separation_state"}
	for array_key in ["aftereffects", "observed_failure_reasons", "irreversible_results"]:
		if typeof(snapshot.get(array_key)) != TYPE_ARRAY:
			return {
				"ok": false,
				"error": "handoff_validation_failed",
				"reason": "invalid_array_field",
				"field": array_key
			}
	if typeof(snapshot.get("provenance")) != TYPE_DICTIONARY:
		return {"ok": false, "error": "handoff_validation_failed", "reason": "invalid_provenance"}
	return {"ok": true}


func derive_handoff(snapshot: Dictionary, adapter: Dictionary = {}) -> Dictionary:
	var validation := validate_snapshot(snapshot)
	if not bool(validation.get("ok", false)):
		return validation

	var snapshot_id := String(snapshot.get("snapshot_id", ""))
	var target := String(adapter.get("protected_subject_id", "victim_unknown"))
	var survival_state := String(snapshot.get("survival_state", ""))
	var separation_state := String(snapshot.get("separation_state", ""))
	var obligations: Array = []

	match survival_state:
		"alive_critical":
			obligations.append(_make_obligation(
				snapshot_id,
				target,
				"treatment",
				"victim_alive_critical",
				"critical",
				"피해자 상태가 위중합니다.",
				["attack", "suppress", "seal", "withdraw"],
				"의료 인계 또는 상태 안정화",
				"치료 지연으로 상태가 악화될 수 있습니다.",
				0
			))
		"alive_stable":
			if _contains_any(snapshot.get("aftereffects", []), ["injury", "contamination", "memory_damage"]):
				obligations.append(_make_obligation(
					snapshot_id,
					target,
					"protection",
					"victim_aftereffects_present",
					"urgent",
					"구출 뒤 후유증 보호가 필요합니다.",
					["withdraw", "seal"],
					"안전 구역 인계",
					"후유증과 2차 노출이 악화될 수 있습니다.",
					0
				))
		"dead", "lost":
			obligations.append(_make_obligation(
				snapshot_id,
				target,
				"identity_record_preservation",
				"victim_lost_or_dead",
				"urgent",
				"신원·기록·오염 책임이 남아 있습니다.",
				["withdraw", "seal"],
				"신원·기록·오염 상태 보존",
				"기록 손실 또는 2차 오염이 발생할 수 있습니다.",
				0
			))
		"missing_unknown":
			obligations.append(_make_obligation(
				snapshot_id,
				target,
				"accounting_and_search",
				"victim_missing_unknown",
				"critical",
				"보호 대상의 소재가 확인되지 않았습니다.",
				["withdraw", "seal"],
				"소재 확인 또는 책임 있는 추적 인계",
				"승인 철수 책임 조건이 성립하지 않을 수 있습니다.",
				0
			))

	match separation_state:
		"partial":
			obligations.append(_make_obligation(
				snapshot_id,
				target,
				"tether_monitoring",
				"partial_separation",
				"critical",
				"피해자와 현상 사이 잔여 연결이 남아 있습니다.",
				["attack", "suppress", "seal", "withdraw"],
				"잔여 연결 감시 또는 안전한 분리",
				"피해 전이·재연결·오염 위험이 증가할 수 있습니다.",
				1
			))
		"failed":
			obligations.append(_make_obligation(
				snapshot_id,
				target,
				"emergency_protection",
				"separation_failed",
				"critical",
				"현상 분리가 실패해 긴급 보호가 필요합니다.",
				["attack", "suppress", "seal", "withdraw"],
				"긴급 보호·봉쇄·책임 있는 철수 판단",
				"직접 피해 또는 통제 붕괴가 발생할 수 있습니다.",
				1
			))
		"irreversible":
			obligations.append(_make_obligation(
				snapshot_id,
				target,
				"harm_minimization",
				"irreversible_connection",
				"critical",
				"연결이 비가역적이므로 추가 피해 최소화가 필요합니다.",
				["attack", "suppress", "seal", "withdraw"],
				"피해 최소화·오염 차단·후속 책임 확정",
				"추가 피해와 확산 위험이 증가할 수 있습니다.",
				1
			))

	obligations = _deduplicate_obligations(obligations)
	var protected_subjects: Array = []
	if survival_state in ["alive_stable", "alive_critical", "missing_unknown"]:
		protected_subjects.append(target)

	return {
		"ok": true,
		"rescue_outcome_snapshot": snapshot.duplicate(true),
		"recovery_handoff_state": {
			"handoff_id": "handoff:%s" % snapshot_id,
			"case_id": String(adapter.get("case_id", "")),
			"active_protected_subjects": protected_subjects,
			"survival_state": survival_state,
			"separation_state": separation_state,
			"residual_tether": separation_state in ["partial", "failed", "irreversible"],
			"treatment_required": survival_state == "alive_critical",
			"safe_withdrawal_route": bool(adapter.get("safe_withdrawal_route", false)),
			"public_exposure": String(adapter.get("public_exposure", "unknown")),
			"derived_once": true,
			"source_snapshot_id": snapshot_id
		},
		"active_protection_obligations": obligations,
		"protection_history": []
	}


func preview_action(action_id: String, handoff: Dictionary, obligations: Array) -> Dictionary:
	var confirmed_rule_violation := bool(handoff.get("confirmed_rule_violation", false))
	var physically_impossible := bool(handoff.get("physically_impossible", false))
	if confirmed_rule_violation or physically_impossible:
		return {
			"action_id": action_id,
			"allowed": false,
			"hard_lock_reason": "confirmed_rule_violation" if confirmed_rule_violation else "physically_impossible",
			"requires_confirmation": false,
			"expected_consequences": [],
			"alternatives": _default_alternatives(obligations)
		}
	var consequences: Array = []
	for obligation_value in obligations:
		if typeof(obligation_value) != TYPE_DICTIONARY:
			continue
		var obligation := obligation_value as Dictionary
		if action_id in _string_array(obligation.get("affected_actions", [])):
			consequences.append({
				"obligation_id": String(obligation.get("obligation_id", "")),
				"target": String(obligation.get("target", "")),
				"reason": String(obligation.get("source_reason", "")),
				"breach_consequence": String(obligation.get("breach_consequence", ""))
			})
	return {
		"action_id": action_id,
		"allowed": true,
		"requires_confirmation": not consequences.is_empty(),
		"expected_consequences": consequences,
		"alternatives": _default_alternatives(obligations)
	}


func _make_obligation(
	snapshot_id: String,
	target: String,
	responsibility_type: String,
	source_reason: String,
	priority_class: String,
	priority_reason: String,
	affected_actions: Array,
	completion_condition: String,
	breach_consequence: String,
	created_order: int
) -> Dictionary:
	return {
		"obligation_id": "ob:%s:%s:%s:%s" % [snapshot_id, target, responsibility_type, source_reason],
		"target": target,
		"responsibility_type": responsibility_type,
		"source_reason": source_reason,
		"priority_class": priority_class,
		"priority_reason": priority_reason,
		"affected_actions": affected_actions.duplicate(true),
		"completion_condition": completion_condition,
		"breach_consequence": breach_consequence,
		"status": "unresolved",
		"created_order": created_order
	}


func _deduplicate_obligations(obligations: Array) -> Array:
	var seen: Dictionary = {}
	var result: Array = []
	for obligation_value in obligations:
		if typeof(obligation_value) != TYPE_DICTIONARY:
			continue
		var obligation := obligation_value as Dictionary
		var obligation_id := String(obligation.get("obligation_id", ""))
		if obligation_id.is_empty() or seen.has(obligation_id):
			continue
		seen[obligation_id] = true
		result.append(obligation.duplicate(true))
	return result


func _contains_any(values: Variant, candidates: Array) -> bool:
	for value in _string_array(values):
		if value in candidates:
			return true
	return false


func _string_array(value: Variant) -> Array[String]:
	var result: Array[String] = []
	if typeof(value) != TYPE_ARRAY:
		return result
	for item in value as Array:
		result.append(String(item))
	return result


func _default_alternatives(obligations: Array) -> Array:
	if obligations.is_empty():
		return ["observe", "open_manual"]
	return ["protect", "use_support", "transfer_responsibility", "evaluate_withdrawal", "observe", "open_manual"]
