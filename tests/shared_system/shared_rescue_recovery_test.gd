extends SceneTree

const HandoffPolicy := preload("res://scripts/core/rescue_recovery_handoff_policy.gd")
const OutcomePolicy := preload("res://scripts/core/recovery_outcome_policy.gd")
var _failures: Array[String] = []


func _init() -> void:
	_test_red_umbrella_partial_success_handoff()
	_test_attack_is_not_default_free_win()
	_finish()


func _test_red_umbrella_partial_success_handoff() -> void:
	var snapshot := {
		"snapshot_id": "m04:red_umbrella:partial",
		"survival_state": "alive_stable",
		"separation_state": "partial",
		"aftereffects": ["memory_damage"],
		"observed_failure_reasons": ["rain_sync_incomplete"],
		"irreversible_results": [],
		"provenance": {
			"case_id": "episode_002_red_umbrella_alley",
			"source_minigame_id": "minigame_rain_sync"
		}
	}
	var result: Dictionary = HandoffPolicy.new().derive_handoff(snapshot, {
		"case_id": "episode_002_red_umbrella_alley",
		"protected_subject_id": "victim_alley_witness",
		"safe_withdrawal_route": true,
		"public_exposure": "low"
	})
	_expect(bool(result.get("ok", false)), "M04 snapshot did not enter shared handoff")
	var handoff := result.get("recovery_handoff_state", {}) as Dictionary
	_expect(String(handoff.get("case_id", "")) == "episode_002_red_umbrella_alley", "M04 case identity lost")
	_expect(bool(handoff.get("residual_tether", false)), "partial separation must preserve residual tether")
	var obligations := result.get("active_protection_obligations", []) as Array
	_expect(obligations.size() >= 2, "partial M04 rescue should produce protection obligations")


func _test_attack_is_not_default_free_win() -> void:
	var policy = OutcomePolicy.new()
	var obligations := [{
		"obligation_id": "m04-protect-victim",
		"target": "victim_alley_witness",
		"status": "unresolved",
		"priority": "critical",
		"affected_actions": ["attack"],
		"source_reason": "partial_separation",
		"breach_consequence": "victim tether worsens"
	}]
	var context := {
		"obligations": obligations,
		"stable_control": false,
		"containment_ready": false,
		"residue_secured": false,
		"safe_withdrawal_route": true
	}
	var direct: Dictionary = policy.evaluate_termination_candidate("stabilize", context)
	_expect(not bool(direct.get("eligible", true)), "unresolved critical protection must block clean stabilization")
	var withdraw: Dictionary = policy.evaluate_termination_candidate("approved_withdrawal", context)
	_expect(typeof(withdraw) == TYPE_DICTIONARY, "shared recovery must return structured withdrawal decision")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("SHARED RESCUE RECOVERY: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
