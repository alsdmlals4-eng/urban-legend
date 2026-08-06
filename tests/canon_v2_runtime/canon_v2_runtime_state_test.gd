extends SceneTree

const RuntimeGameStateScript := preload("res://scripts/core/afterlife_migrating_game_state.gd")

var _failures: Array[String] = []


func _init() -> void:
	var state = RuntimeGameStateScript.new()
	var candidate := {
		"schema_version": 1,
		"rescue_outcome_snapshot": {
			"snapshot_id": "rescue_afterlife_attempt_01",
			"survival_state": "alive_critical",
			"separation_state": "partial",
			"aftereffects": ["injury", "residual_tether"],
			"observed_failure_reasons": [],
			"irreversible_results": [],
			"provenance": {"source": "test"}
		},
		"recovery_handoff_state": {},
		"active_protection_obligations": [],
		"protection_history": [],
		"follow_up_records": [],
		"evaluation_packet": {},
		"reward_claims": {}
	}
	var applied: Dictionary = state.apply_canon_v2_runtime_state(candidate)
	_expect(bool(applied.get("ok", false)), "runtime state apply failed")
	var stored: Dictionary = state.get_canon_v2_runtime_state()
	_expect(int(stored.get("schema_version", 0)) == 1, "runtime schema version missing")
	_expect(not (stored.get("rescue_outcome_snapshot", {}) as Dictionary).is_empty(), "rescue snapshot missing after state apply")

	var initialized: Dictionary = state.ensure_canon_v2_recovery_handoff_initialized({
		"case_id": "episode_001_afterlife_station",
		"protected_subject_id": "victim_afterlife_station_001"
	})
	_expect(bool(initialized.get("ok", false)), "runtime handoff initialization failed")
	_expect(not (state.get_active_protection_obligations() as Array).is_empty(), "runtime obligations were not persisted")
	var first_ids := _obligation_ids(state.get_active_protection_obligations())
	var initialized_again: Dictionary = state.ensure_canon_v2_recovery_handoff_initialized({
		"case_id": "episode_001_afterlife_station",
		"protected_subject_id": "victim_afterlife_station_001"
	})
	_expect(bool(initialized_again.get("reused_existing_handoff", false)), "handoff was reapplied instead of reused")
	_expect(first_ids == _obligation_ids(state.get_active_protection_obligations()), "obligations duplicated across repeated initialization")

	var preview: Dictionary = state.preview_canon_v2_recovery_action({"action_id": "attack", "base_cost": 1}, {"available_supports": ["shield"]})
	_expect(not String(preview.get("preview_id", "")).is_empty(), "action preview lacks stable preview id")
	var committed: Dictionary = state.commit_canon_v2_recovery_action(String(preview.get("preview_id", "")))
	_expect(bool(committed.get("committed", false)), "action preview did not commit")
	var duplicate_commit: Dictionary = state.commit_canon_v2_recovery_action(String(preview.get("preview_id", "")))
	_expect(not bool(duplicate_commit.get("committed", true)), "same preview committed twice")

	var follow_ups: Dictionary = state.rebuild_canon_v2_follow_up_records({"default_step_limit": 1})
	_expect(bool(follow_ups.get("ok", false)), "follow-up rebuild failed")
	_expect((state.get_canon_v2_runtime_state().get("protection_history", []) as Array).size() >= 1, "protection history did not record committed action")
	_finish()


func _obligation_ids(obligations: Array) -> Array[String]:
	var ids: Array[String] = []
	for obligation_value in obligations:
		if typeof(obligation_value) == TYPE_DICTIONARY:
			ids.append(String((obligation_value as Dictionary).get("obligation_id", "")))
	return ids


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("CANON V2 RUNTIME STATE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
