extends SceneTree

const HandoffPolicyScript := preload("res://scripts/core/rescue_recovery_handoff_policy.gd")
const ObligationPolicyScript := preload("res://scripts/core/protection_obligation_policy.gd")
const OutcomePolicyScript := preload("res://scripts/core/recovery_outcome_policy.gd")
const FollowUpPolicyScript := preload("res://scripts/core/protection_follow_up_policy.gd")

var _failures: Array[String] = []


func _init() -> void:
	_test_rescue_handoff_and_obligation_preview()
	_test_unapproved_numbers_are_not_invented()
	_test_recovery_outcome_independence()
	_test_follow_up_dedupe_and_breach_preservation()
	_finish()


func _test_rescue_handoff_and_obligation_preview() -> void:
	var snapshot := {
		"snapshot_id": "rescue_afterlife_attempt_01",
		"survival_state": "alive_critical",
		"separation_state": "partial",
		"aftereffects": ["injury", "residual_tether"],
		"observed_failure_reasons": ["carrier_not_fully_isolated"],
		"irreversible_results": [],
		"provenance": {"source": "rescue_afterlife_stage_04_joint_disembarkation"}
	}
	var handoff: Dictionary = HandoffPolicyScript.new().derive_handoff(snapshot, {
		"case_id": "episode_001_afterlife_station",
		"protected_subject_id": "victim_afterlife_station_001"
	})
	_expect(bool(handoff.get("ok", false)), "handoff derivation failed")
	var obligations := handoff.get("active_protection_obligations", []) as Array
	_expect(not obligations.is_empty(), "critical partial-separation handoff produced no obligations")
	_expect(_has_responsibility(obligations, "treatment"), "treatment obligation missing")
	_expect(_has_responsibility(obligations, "tether_monitoring"), "tether monitoring obligation missing")

	var obligation_policy = ObligationPolicyScript.new()
	var attack_preview: Dictionary = obligation_policy.evaluate_action(
		obligations,
		{"action_id": "attack", "base_cost": 1},
		{"available_supports": ["shield"], "safe_route": true}
	)
	_expect(bool(attack_preview.get("allowed", false)), "related attack must remain selectable")
	_expect(not (attack_preview.get("risk_changes", []) as Array).is_empty(), "related attack lacks visible consequence")
	_expect(not (attack_preview.get("alternatives", []) as Array).is_empty(), "related attack lacks fail-forward alternative")

	var observe_preview: Dictionary = obligation_policy.evaluate_action(
		obligations,
		{"action_id": "observe", "base_cost": 0},
		{}
	)
	_expect(bool(observe_preview.get("allowed", false)), "observation must remain available")
	_expect(int(observe_preview.get("additional_cost", -1)) == 0, "observation must remain free")


func _test_unapproved_numbers_are_not_invented() -> void:
	var obligation := {
		"obligation_id": "ob_semantic_only",
		"target": "victim_001",
		"responsibility_type": "protection",
		"source_reason": "partial_separation",
		"priority_class": "critical",
		"priority_reason": "잔여 연결 위험이 있습니다.",
		"affected_actions": ["attack"],
		"breach_consequence": "피해 전이 위험이 증가합니다.",
		"status": "unresolved",
		"created_order": 0
	}
	var policy = ObligationPolicyScript.new()
	var semantic_preview: Dictionary = policy.evaluate_action([obligation], {"action_id": "attack", "base_cost": 1}, {})
	_expect(int(semantic_preview.get("additional_cost", -1)) == 0, "policy invented an unapproved numeric cost")
	_expect((semantic_preview.get("cost_adjustments", []) as Array).is_empty(), "semantic-only obligation created a numeric adjustment")
	_expect(not (semantic_preview.get("risk_changes", []) as Array).is_empty(), "semantic-only obligation lost its visible risk")

	var authored := obligation.duplicate(true)
	authored["cost_rules"] = {
		"attack": {
			"cost_channel": "action_opportunity",
			"additional_cost": 1,
			"preview_text": "저작된 보호 행동 기회 1회가 필요합니다."
		}
	}
	var authored_preview: Dictionary = policy.evaluate_action([authored], {"action_id": "attack", "base_cost": 1}, {})
	_expect(int(authored_preview.get("additional_cost", 0)) == 1, "authored numeric cost was not applied")
	_expect((authored_preview.get("cost_adjustments", []) as Array).size() == 1, "authored cost adjustment missing")


func _test_recovery_outcome_independence() -> void:
	var policy = OutcomePolicyScript.new()
	var residue_result: Dictionary = policy.evaluate_termination_candidate("residue_recovered", {
		"control_evidence": {"residue_secured": true, "spread_controlled": true},
		"obligations": [{
			"obligation_id": "ob_records_watch",
			"status": "unresolved",
			"priority_class": "watch"
		}]
	})
	_expect(bool(residue_result.get("eligible", false)), "watch obligation incorrectly downgraded control result")
	_expect((residue_result.get("blocking_reasons", []) as Array).is_empty(), "watch obligation became a blocking control reason")
	_expect(not (residue_result.get("non_blocking_consequences", []) as Array).is_empty(), "watch obligation disappeared from independent protection reporting")

	var withdrawal_result: Dictionary = policy.evaluate_termination_candidate("approved_withdrawal", {
		"safe_route": true,
		"withdrawal_reason_recorded": true,
		"before_control_collapse": true,
		"obligations": [{
			"obligation_id": "ob_evacuation",
			"status": "unresolved",
			"priority_class": "critical"
		}]
	})
	_expect(not bool(withdrawal_result.get("eligible", true)), "unaccounted critical obligation allowed approved withdrawal")
	_expect(bool(withdrawal_result.get("retreat_selectable", false)), "retreat was hard-locked")
	_expect(String(withdrawal_result.get("fallback_outcome", "")) == "control_failure", "withdrawal fallback outcome missing")


func _test_follow_up_dedupe_and_breach_preservation() -> void:
	var policy = FollowUpPolicyScript.new()
	var incident_packet := {
		"case_canon_reference": "episode_001_afterlife_station:incident_end",
		"representative_outcome": "containment_complete",
		"protection_status": "breached"
	}
	var obligations := [
		{
			"obligation_id": "ob_public_exposure",
			"status": "breached",
			"source_reason": "public_exposure",
			"target": "station_platform"
		},
		{
			"obligation_id": "ob_public_exposure",
			"status": "breached",
			"source_reason": "public_exposure",
			"target": "station_platform"
		}
	]
	var built: Dictionary = policy.build_follow_up_records(
		"episode_001_afterlife_station",
		"campaign_primary",
		obligations,
		incident_packet,
		{"default_step_limit": 1, "breached": {"actionable": true}}
	)
	_expect(bool(built.get("ok", false)), "follow-up construction failed")
	var records := built.get("records", []) as Array
	_expect(records.size() == 1, "same follow-up cause created duplicate active roots")
	if not records.is_empty():
		var record := records[0] as Dictionary
		_expect(String(record.get("source_status", "")) == "breached", "original breach status was rewritten")
		_expect(String(record.get("case_canon_reference", "")) == "episode_001_afterlife_station:incident_end", "incident-end canon reference missing")
		_expect(int(record.get("step_limit", 0)) == 1, "authored step limit missing")


func _has_responsibility(obligations: Array, responsibility_type: String) -> bool:
	for obligation_value in obligations:
		if typeof(obligation_value) != TYPE_DICTIONARY:
			continue
		if String((obligation_value as Dictionary).get("responsibility_type", "")) == responsibility_type:
			return true
	return false


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("CANON V2 POLICY RUNTIME: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
