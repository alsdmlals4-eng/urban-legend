extends "res://scripts/core/validation_game_state.gd"


const AfterlifeInspectorScript := preload("res://scripts/core/afterlife_legacy_save_inspector.gd")
const AfterlifeRegistryScript := preload("res://scripts/data/afterlife_id_migration_registry.gd")
const AfterlifeMainMigratorScript := preload("res://scripts/core/afterlife_main_save_migrator.gd")
const AfterlifeTransactionScript := preload("res://scripts/core/afterlife_migration_transaction.gd")
const AfterlifeEpisodeLoaderScript := preload("res://scripts/data/episode_loader.gd")
const RescueRecoveryHandoffPolicyScript := preload("res://scripts/core/rescue_recovery_handoff_policy.gd")
const ProtectionObligationPolicyScript := preload("res://scripts/core/protection_obligation_policy.gd")
const RecoveryOutcomePolicyScript := preload("res://scripts/core/recovery_outcome_policy.gd")
const ProtectionFollowUpPolicyScript := preload("res://scripts/core/protection_follow_up_policy.gd")
const MonthlyStatePolicyScript := preload("res://scripts/core/monthly_state_policy.gd")
const M01FirstSessionOrchestratorScript := preload("res://scripts/core/m01_first_session_orchestrator.gd")
const AFTERLIFE_REGISTRY_PATH := "res://data/migrations/afterlife_station_canon_v2_id_migration.json"
const AFTERLIFE_EPISODE_ID := "episode_001_afterlife_station"
const AFTERLIFE_CONTRACT_ID := "afterlife-station-canon-v2"
const MAIN_TARGET_VERSION := "mvp-040"
const CANON_V2_RUNTIME_SCHEMA_VERSION := 1

var _afterlife_content_contract_id := ""
var _afterlife_v2_state: Dictionary = {}
var _afterlife_migration_history: Array = []
var _afterlife_orphan_legacy_ids: Array = []
var _afterlife_legacy_migration_notes: Array = []
var _afterlife_legacy_resolution_snapshot: Dictionary = {}
var _afterlife_first_v2_investigation: Dictionary = {}
var _afterlife_applied_migration_effect_ids: Dictionary = {}
var _canon_v2_runtime_state: Dictionary = {}
var _canon_v2_pending_action_previews: Dictionary = {}
var _canon_v2_preview_sequence := 0
var _monthly_state: Dictionary = {}
var _m01_first_session_state: Dictionary = {}
var _last_migration_result: Dictionary = {}
var _inject_runtime_failure := false


func configure_migration_runtime_failure_for_test(enabled: bool) -> void:
	_inject_runtime_failure = enabled


func activate_afterlife_content_contract_for_migration(contract_id: String) -> bool:
	if contract_id != AFTERLIFE_CONTRACT_ID:
		return false
	_afterlife_content_contract_id = contract_id
	return true


func get_last_migration_result() -> Dictionary:
	return _last_migration_result.duplicate(true)


func get_afterlife_content_contract_id() -> String:
	return _afterlife_content_contract_id


func get_afterlife_manual_state() -> Dictionary:
	var manual_value: Variant = _afterlife_v2_state.get("manual")
	return (manual_value as Dictionary).duplicate(true) if typeof(manual_value) == TYPE_DICTIONARY else {}


func get_monthly_state() -> Dictionary:
	_ensure_monthly_state()
	return _monthly_state.duplicate(true)


func apply_monthly_state(candidate: Dictionary) -> Dictionary:
	var policy = MonthlyStatePolicyScript.new()
	var candidate_validation: Dictionary = policy.validate(candidate)
	if not bool(candidate_validation.get("ok", false)):
		return candidate_validation
	var normalized: Dictionary = policy.normalize(candidate)
	var validation: Dictionary = policy.validate(normalized)
	if not bool(validation.get("ok", false)):
		return validation
	var previous := _monthly_state.duplicate(true)
	_monthly_state = normalized.duplicate(true)
	if not _persist_monthly_state_if_possible():
		_monthly_state = previous
		return {"ok": false, "code": "MONTHLY_STATE_PERSISTENCE_FAILED", "reason": "monthly_state_persistence_failed"}
	return {"ok": true, "code": "STATE_APPLIED", "state": get_monthly_state()}


func transition_monthly_state(event: String, payload: Dictionary = {}) -> Dictionary:
	_ensure_monthly_state()
	var policy = MonthlyStatePolicyScript.new()
	var transition: Dictionary = policy.transition(_monthly_state, event, payload)
	if not bool(transition.get("ok", false)):
		return transition
	var previous := _monthly_state.duplicate(true)
	_monthly_state = (transition.get("state", {}) as Dictionary).duplicate(true)
	if not _persist_monthly_state_if_possible():
		_monthly_state = previous
		return {"ok": false, "code": "MONTHLY_STATE_PERSISTENCE_FAILED", "reason": "monthly_state_persistence_failed"}
	transition["state"] = get_monthly_state()
	return transition


func get_m01_first_session_state() -> Dictionary:
	_ensure_m01_first_session_state()
	return _m01_first_session_state.duplicate(true)


func get_m01_first_session_available_actions() -> Array:
	_ensure_m01_first_session_state()
	return M01FirstSessionOrchestratorScript.new().available_actions(
		_m01_first_session_state,
		_build_m01_runtime_snapshot()
	)


func apply_m01_first_session_event(event: String) -> Dictionary:
	_ensure_m01_first_session_state()
	var orchestrator = M01FirstSessionOrchestratorScript.new()
	var result: Dictionary = orchestrator.apply_event(
		_m01_first_session_state,
		event,
		_build_m01_runtime_snapshot()
	)
	if not bool(result.get("ok", false)):
		return result
	var previous := _m01_first_session_state.duplicate(true)
	_m01_first_session_state = (result.get("state", {}) as Dictionary).duplicate(true)
	if not _persist_m01_first_session_state_if_possible():
		_m01_first_session_state = previous
		return {"ok": false, "code": "M01_FIRST_SESSION_PERSISTENCE_FAILED", "reason": "m01_first_session_persistence_failed"}
	result["state"] = get_m01_first_session_state()
	return result


func apply_canon_v2_runtime_state(candidate: Dictionary) -> Dictionary:
	var normalized := _normalize_canon_v2_runtime_state(candidate)
	var validation := _validate_canon_v2_runtime_state(normalized)
	if not bool(validation.get("ok", false)):
		return validation
	_canon_v2_runtime_state = normalized.duplicate(true)
	_canon_v2_pending_action_previews.clear()
	_canon_v2_preview_sequence = 0
	return {"ok": true, "state": get_canon_v2_runtime_state()}


func get_canon_v2_runtime_state() -> Dictionary:
	_ensure_canon_v2_runtime_state()
	return _canon_v2_runtime_state.duplicate(true)


func finalize_canon_v2_rescue_outcome_snapshot(snapshot: Dictionary) -> Dictionary:
	_ensure_canon_v2_runtime_state()
	if not _dictionary_copy(_canon_v2_runtime_state.get("rescue_outcome_snapshot")).is_empty():
		return {"ok": false, "reason": "snapshot_already_finalized"}
	var validation := RescueRecoveryHandoffPolicyScript.new().validate_snapshot(snapshot)
	if not bool(validation.get("ok", false)):
		return validation
	var candidate := _canon_v2_runtime_state.duplicate(true)
	candidate["rescue_outcome_snapshot"] = snapshot.duplicate(true)
	candidate["recovery_handoff_state"] = {}
	candidate["active_protection_obligations"] = []
	candidate["protection_history"] = [{
		"event": "rescue_outcome_snapshot_finalized",
		"snapshot_id": String(snapshot.get("snapshot_id", ""))
	}]
	return _commit_canon_v2_runtime_candidate(candidate, "rescue_snapshot_finalized")


func ensure_canon_v2_recovery_handoff_initialized(adapter: Dictionary = {}) -> Dictionary:
	_ensure_canon_v2_runtime_state()
	var existing_handoff := _dictionary_copy(_canon_v2_runtime_state.get("recovery_handoff_state"))
	if not existing_handoff.is_empty():
		return {
			"ok": true,
			"reused_existing_handoff": true,
			"recovery_handoff_state": existing_handoff,
			"active_protection_obligations": get_active_protection_obligations()
		}
	var snapshot := _dictionary_copy(_canon_v2_runtime_state.get("rescue_outcome_snapshot"))
	if snapshot.is_empty():
		return {"ok": false, "error": "handoff_validation_failed", "reason": "rescue_snapshot_missing"}
	var derived: Dictionary = RescueRecoveryHandoffPolicyScript.new().derive_handoff(snapshot, adapter)
	if not bool(derived.get("ok", false)):
		return derived
	var candidate := _canon_v2_runtime_state.duplicate(true)
	candidate["recovery_handoff_state"] = _dictionary_copy(derived.get("recovery_handoff_state"))
	candidate["active_protection_obligations"] = _array_copy(derived.get("active_protection_obligations"))
	var history := _array_copy(candidate.get("protection_history"))
	history.append({
		"event": "recovery_handoff_initialized",
		"source_snapshot_id": String(snapshot.get("snapshot_id", "")),
		"obligation_count": (candidate["active_protection_obligations"] as Array).size()
	})
	candidate["protection_history"] = history
	var committed := _commit_canon_v2_runtime_candidate(candidate, "recovery_handoff_initialized")
	if not bool(committed.get("ok", false)):
		return committed
	return {
		"ok": true,
		"reused_existing_handoff": false,
		"recovery_handoff_state": _dictionary_copy(candidate.get("recovery_handoff_state")),
		"active_protection_obligations": _array_copy(candidate.get("active_protection_obligations"))
	}


func get_active_protection_obligations() -> Array:
	_ensure_canon_v2_runtime_state()
	return _array_copy(_canon_v2_runtime_state.get("active_protection_obligations"))


func get_protection_history() -> Array:
	_ensure_canon_v2_runtime_state()
	return _array_copy(_canon_v2_runtime_state.get("protection_history"))


func preview_canon_v2_recovery_action(action: Dictionary, context: Dictionary = {}) -> Dictionary:
	_ensure_canon_v2_runtime_state()
	var preview: Dictionary = ProtectionObligationPolicyScript.new().evaluate_action(
		get_active_protection_obligations(),
		action,
		context
	)
	_canon_v2_preview_sequence += 1
	var preview_id := "canon-v2-preview-%06d" % _canon_v2_preview_sequence
	preview["preview_id"] = preview_id
	preview["created_order"] = _canon_v2_preview_sequence
	_canon_v2_pending_action_previews[preview_id] = preview.duplicate(true)
	return preview


func commit_canon_v2_recovery_action(preview_id: String) -> Dictionary:
	_ensure_canon_v2_runtime_state()
	if preview_id.is_empty() or not _canon_v2_pending_action_previews.has(preview_id):
		return {"committed": false, "error": "preview_not_found_or_already_committed"}
	var preview := _dictionary_copy(_canon_v2_pending_action_previews.get(preview_id))
	var candidate := _canon_v2_runtime_state.duplicate(true)
	var applied_ids := _dictionary_copy(candidate.get("applied_cost_adjustment_ids"))
	for adjustment_value in _array_copy(preview.get("cost_adjustments")):
		if typeof(adjustment_value) != TYPE_DICTIONARY:
			continue
		var adjustment := adjustment_value as Dictionary
		var adjustment_id := String(adjustment.get("cost_adjustment_id", ""))
		if adjustment_id.is_empty():
			return {"committed": false, "error": "missing_cost_adjustment_id"}
		if applied_ids.has(adjustment_id):
			return {"committed": false, "error": "cost_adjustment_already_applied"}
		applied_ids[adjustment_id] = true
	candidate["applied_cost_adjustment_ids"] = applied_ids

	var history := _array_copy(candidate.get("protection_history"))
	history.append({
		"event": "recovery_action_committed",
		"preview_id": preview_id,
		"action_id": String(preview.get("action_id", "")),
		"base_cost": int(preview.get("base_cost", 0)),
		"additional_cost": int(preview.get("additional_cost", 0)),
		"risk_changes": _array_copy(preview.get("risk_changes", [])),
		"cost_adjustment_ids": _string_keys_from_adjustments(preview.get("cost_adjustments", []))
	})
	candidate["protection_history"] = history
	var committed := _commit_canon_v2_runtime_candidate(candidate, "recovery_action_committed")
	if not bool(committed.get("ok", false)):
		return {"committed": false, "error": String(committed.get("error", "runtime_state_commit_failed"))}
	_canon_v2_pending_action_previews.erase(preview_id)
	return {"committed": true, "preview": preview, "state": get_canon_v2_runtime_state()}


func evaluate_canon_v2_recovery_termination(candidate: String, context: Dictionary = {}) -> Dictionary:
	var merged_context := context.duplicate(true)
	merged_context["obligations"] = get_active_protection_obligations()
	var result: Dictionary = RecoveryOutcomePolicyScript.new().evaluate_termination_candidate(candidate, merged_context)
	_ensure_canon_v2_runtime_state()
	var runtime_candidate := _canon_v2_runtime_state.duplicate(true)
	runtime_candidate["termination_preview"] = result.duplicate(true)
	_commit_canon_v2_runtime_candidate(runtime_candidate, "termination_preview_updated")
	return result


func rebuild_canon_v2_follow_up_records(authoring_rules: Dictionary = {}) -> Dictionary:
	_ensure_canon_v2_runtime_state()
	var incident_packet := _dictionary_copy(_canon_v2_runtime_state.get("incident_end_packet"))
	if incident_packet.is_empty():
		incident_packet = {
			"case_canon_reference": "%s:incident_end" % AFTERLIFE_EPISODE_ID,
			"representative_outcome": String(_canon_v2_runtime_state.get("representative_outcome", "unknown")),
			"protection_status": _derive_protection_status(get_active_protection_obligations())
		}
	var built: Dictionary = ProtectionFollowUpPolicyScript.new().build_follow_up_records(
		AFTERLIFE_EPISODE_ID,
		"campaign_primary",
		get_active_protection_obligations(),
		incident_packet,
		authoring_rules
	)
	if not bool(built.get("ok", false)):
		return built
	var candidate := _canon_v2_runtime_state.duplicate(true)
	candidate["incident_end_packet"] = incident_packet.duplicate(true)
	candidate["follow_up_records"] = _array_copy(built.get("records"))
	candidate["evaluation_packet"] = ProtectionFollowUpPolicyScript.new().build_evaluation_packet(
		incident_packet,
		_array_copy(built.get("records")),
		_dictionary_copy(authoring_rules.get("mastery_rules"))
	)
	var committed := _commit_canon_v2_runtime_candidate(candidate, "follow_up_records_rebuilt")
	if not bool(committed.get("ok", false)):
		return committed
	return {
		"ok": true,
		"records": _array_copy(candidate.get("follow_up_records")),
		"evaluation_packet": _dictionary_copy(candidate.get("evaluation_packet"))
	}


func claim_canon_v2_follow_up_reward(follow_up_id: String, reward: Dictionary) -> Dictionary:
	_ensure_canon_v2_runtime_state()
	if follow_up_id.is_empty():
		return {"granted": false, "reason": "missing_follow_up_id"}
	if _reward_contains_campaign_power(reward):
		return {"granted": false, "reason": "campaign_power_reward_forbidden"}
	var candidate := _canon_v2_runtime_state.duplicate(true)
	var claims := _dictionary_copy(candidate.get("reward_claims"))
	if claims.has(follow_up_id):
		return {"granted": false, "reason": "already_claimed"}
	claims[follow_up_id] = reward.duplicate(true)
	candidate["reward_claims"] = claims
	var committed := _commit_canon_v2_runtime_candidate(candidate, "follow_up_reward_claimed")
	if not bool(committed.get("ok", false)):
		return {"granted": false, "reason": "runtime_state_commit_failed"}
	return {"granted": true, "reward": reward.duplicate(true)}


func load_episode(file_path: String = DEFAULT_EPISODE_PATH) -> bool:
	var loader = AfterlifeEpisodeLoaderScript.new()
	var loaded_data: Dictionary
	if file_path == DEFAULT_EPISODE_PATH and _afterlife_content_contract_id == AFTERLIFE_CONTRACT_ID:
		loaded_data = loader.load_episode_contract(file_path, AFTERLIFE_CONTRACT_ID)
	else:
		loaded_data = loader.load_episode(file_path)
	if loaded_data.is_empty():
		return false
	current_episode_path = file_path
	current_episode_data = CaseDataScript.refresh_resolution_progress(loaded_data)
	_clear_resolution_phase_selection()
	_clear_recovery_result()
	return true


func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		return false
	var recovery := AfterlifeTransactionScript.new().recover_pending(SAVE_FILE_PATH)
	if String(recovery.get("code", "")) == "MIGRATION_FATAL_RECOVERY_REQUIRED":
		_last_migration_result = recovery.duplicate(true)
		return false
	var source_payload := _read_dictionary(SAVE_FILE_PATH)
	if source_payload.is_empty():
		return false
	var source_version := String(source_payload.get("save_version", ""))
	var episode_id := String(source_payload.get("episode_id", ""))
	if source_version == MAIN_TARGET_VERSION:
		_hydrate_afterlife_fields(source_payload)
		var loaded_v2 := super.load_game()
		if not loaded_v2:
			return false
		return true
	if source_version not in ["mvp-038", "mvp-039"] or episode_id != AFTERLIFE_EPISODE_ID:
		return super.load_game()

	var source_bytes := FileAccess.get_file_as_bytes(SAVE_FILE_PATH)
	var inspector = AfterlifeInspectorScript.new()
	var inspected: Dictionary = inspector.inspect_main_bytes(source_bytes)
	if String(inspected.get("code", "")) != "MIGRATABLE_MAIN":
		_last_migration_result = inspected.duplicate(true)
		return false
	var registry = AfterlifeRegistryScript.new()
	var registry_result: Dictionary = registry.load_registry(AFTERLIFE_REGISTRY_PATH)
	if String(registry_result.get("code", "")) != "EXACT":
		_last_migration_result = registry_result.duplicate(true)
		return false
	var migrated: Dictionary = AfterlifeMainMigratorScript.new().migrate(inspected, registry)
	if not bool(migrated.get("ok", false)):
		_last_migration_result = migrated.duplicate(true)
		return false
	var target_payload := migrated.get("payload", {}) as Dictionary
	var transaction = AfterlifeTransactionScript.new()
	var prepared: Dictionary = transaction.prepare(
		SAVE_FILE_PATH,
		inspected,
		target_payload,
		Callable(self, "_validate_main_v2_payload")
	)
	if String(prepared.get("state", "")) != "PREPARED":
		_last_migration_result = prepared.duplicate(true)
		return false
	var committed: Dictionary = transaction.commit_prepared(prepared)
	if String(committed.get("state", "")) != "COMMITTED_PENDING_RUNTIME_APPLY":
		transaction.abort_prepared(committed if String(committed.get("state", "")) == "PREPARED" else prepared)
		_last_migration_result = committed.duplicate(true)
		return false
	if _inject_runtime_failure:
		var rolled_back := transaction.rollback_last_commit(committed)
		_last_migration_result = rolled_back.duplicate(true)
		return false

	_afterlife_content_contract_id = AFTERLIFE_CONTRACT_ID
	var applied := super.load_game()
	if not applied:
		_afterlife_content_contract_id = ""
		var rollback := transaction.rollback_last_commit(committed)
		_last_migration_result = rollback.duplicate(true)
		return false
	_hydrate_afterlife_fields(target_payload)
	var finalized := transaction.finalize(committed)
	_last_migration_result = finalized.duplicate(true)
	if String(finalized.get("state", "")) != "FINALIZED":
		return false
	return true


func save_game() -> bool:
	var session: Node = null
	if is_inside_tree():
		session = get_node_or_null("/root/ValidationSession")
	if session != null and session.has_method("requires_save_routing") and bool(session.requires_save_routing()):
		if not session.has_method("is_active_and_valid") or not bool(session.is_active_and_valid()):
			return false
		if not session.has_method("save"):
			return false
		var validation_result: Dictionary = session.save(self)
		return String(validation_result.get("code", "")) == "OK"
	if current_episode_data.is_empty() and not load_episode(DEFAULT_EPISODE_PATH):
		return false
	if get_current_episode_id() != AFTERLIFE_EPISODE_ID:
		return super.save_game()
	_ensure_canon_v2_runtime_state()
	_ensure_monthly_state()
	_ensure_m01_first_session_state()
	var payload := _make_save_data()
	payload["save_version"] = MAIN_TARGET_VERSION
	payload["content_contract_id"] = AFTERLIFE_CONTRACT_ID
	payload["afterlife_canon_v2"] = _afterlife_v2_state.duplicate(true)
	payload["migration_history"] = _afterlife_migration_history.duplicate(true)
	payload["orphan_legacy_ids"] = _afterlife_orphan_legacy_ids.duplicate(true)
	payload["legacy_migration_notes"] = _afterlife_legacy_migration_notes.duplicate(true)
	payload["legacy_resolution_snapshot"] = _afterlife_legacy_resolution_snapshot.duplicate(true)
	payload["first_v2_investigation"] = _afterlife_first_v2_investigation.duplicate(true)
	payload["applied_migration_effect_ids"] = _afterlife_applied_migration_effect_ids.duplicate(true)
	payload["canon_v2_runtime"] = _canon_v2_runtime_state.duplicate(true)
	payload["monthly_state"] = _monthly_state.duplicate(true)
	payload["m01_first_session"] = _m01_first_session_state.duplicate(true)
	return _write_current_main_payload(payload)


func _write_current_main_payload(payload: Dictionary) -> bool:
	if not _validate_main_v2_payload(payload):
		return false
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		return _write_new_primary(SAVE_FILE_PATH, payload)
	var bytes := FileAccess.get_file_as_bytes(SAVE_FILE_PATH)
	var inspected := {"source_checksum": _sha256(bytes)}
	var transaction = AfterlifeTransactionScript.new()
	var prepared: Dictionary = transaction.prepare(
		SAVE_FILE_PATH,
		inspected,
		payload,
		Callable(self, "_validate_main_v2_payload")
	)
	if String(prepared.get("state", "")) != "PREPARED":
		_last_migration_result = prepared.duplicate(true)
		return false
	var committed: Dictionary = transaction.commit_prepared(prepared)
	if String(committed.get("state", "")) != "COMMITTED_PENDING_RUNTIME_APPLY":
		transaction.abort_prepared(committed if String(committed.get("state", "")) == "PREPARED" else prepared)
		_last_migration_result = committed.duplicate(true)
		return false
	var finalized := transaction.finalize(committed)
	_last_migration_result = finalized.duplicate(true)
	return String(finalized.get("state", "")) == "FINALIZED"


func _write_new_primary(path: String, payload: Dictionary) -> bool:
	var temp_path := path + ".new.tmp"
	_remove_path(temp_path)
	var bytes := JSON.stringify(payload, "\t", false).to_utf8_buffer()
	var file := FileAccess.open(temp_path, FileAccess.WRITE)
	if file == null:
		return false
	file.store_buffer(bytes)
	file.flush()
	file.close()
	if _read_dictionary(temp_path).is_empty():
		_remove_path(temp_path)
		return false
	var rename_error := DirAccess.rename_absolute(
		ProjectSettings.globalize_path(temp_path),
		ProjectSettings.globalize_path(path)
	)
	if rename_error != OK:
		_remove_path(temp_path)
		return false
	return _validate_main_v2_payload(_read_dictionary(path))


func _hydrate_afterlife_fields(payload: Dictionary) -> void:
	_afterlife_content_contract_id = String(payload.get("content_contract_id", ""))
	_afterlife_v2_state = _dictionary_copy(payload.get("afterlife_canon_v2"))
	_afterlife_migration_history = _array_copy(payload.get("migration_history"))
	_afterlife_orphan_legacy_ids = _array_copy(payload.get("orphan_legacy_ids"))
	_afterlife_legacy_migration_notes = _array_copy(payload.get("legacy_migration_notes"))
	_afterlife_legacy_resolution_snapshot = _dictionary_copy(payload.get("legacy_resolution_snapshot"))
	_afterlife_first_v2_investigation = _dictionary_copy(payload.get("first_v2_investigation"))
	_afterlife_applied_migration_effect_ids = _dictionary_copy(payload.get("applied_migration_effect_ids"))
	_canon_v2_runtime_state = _normalize_canon_v2_runtime_state(_dictionary_copy(payload.get("canon_v2_runtime")))
	_monthly_state = MonthlyStatePolicyScript.new().normalize(_dictionary_copy(payload.get("monthly_state")), 1)
	_m01_first_session_state = M01FirstSessionOrchestratorScript.new().normalize(_dictionary_copy(payload.get("m01_first_session")))
	_canon_v2_pending_action_previews.clear()
	_canon_v2_preview_sequence = 0


func _validate_main_v2_payload(payload: Dictionary) -> bool:
	if String(payload.get("save_version", "")) != MAIN_TARGET_VERSION:
		return false
	if String(payload.get("episode_id", "")) != AFTERLIFE_EPISODE_ID:
		return false
	if String(payload.get("content_contract_id", "")) != AFTERLIFE_CONTRACT_ID:
		return false
	var v2 := _dictionary_copy(payload.get("afterlife_canon_v2"))
	var manual := _dictionary_copy(v2.get("manual"))
	if not _dictionary_copy(manual.get("filled_slots")).is_empty():
		return false
	for record_value in _array_copy(manual.get("evidence_records")):
		if typeof(record_value) != TYPE_DICTIONARY:
			return false
		if String((record_value as Dictionary).get("state", "")) != "migrated_unverified":
			return false
	if typeof(payload.get("migration_history")) != TYPE_ARRAY:
		return false
	if payload.has("canon_v2_runtime"):
		var runtime_validation := _validate_canon_v2_runtime_state(_normalize_canon_v2_runtime_state(_dictionary_copy(payload.get("canon_v2_runtime"))))
		if not bool(runtime_validation.get("ok", false)):
			return false
	if payload.has("monthly_state"):
		var monthly_value: Variant = payload.get("monthly_state")
		if typeof(monthly_value) != TYPE_DICTIONARY:
			return false
		var monthly_validation: Dictionary = MonthlyStatePolicyScript.new().validate(monthly_value as Dictionary)
		if not bool(monthly_validation.get("ok", false)):
			return false
	if payload.has("m01_first_session"):
		var m01_value: Variant = payload.get("m01_first_session")
		if typeof(m01_value) != TYPE_DICTIONARY:
			return false
		var m01_validation: Dictionary = M01FirstSessionOrchestratorScript.new().validate(m01_value as Dictionary)
		if not bool(m01_validation.get("ok", false)):
			return false
	return true


func _build_m01_runtime_snapshot() -> Dictionary:
	var manual := get_afterlife_manual_state()
	var episode_manual := _dictionary_copy(current_episode_data.get("investigation_manual"))
	if manual.is_empty():
		manual = episode_manual
	else:
		for key in ["pages", "active_rule_ids", "completed_page_ids", "candidate_keywords", "semantic_relations"]:
			if not manual.has(key) and episode_manual.has(key):
				var value: Variant = episode_manual.get(key)
				manual[key] = value.duplicate(true) if typeof(value) in [TYPE_DICTIONARY, TYPE_ARRAY] else value
	return {
		"monthly_state": get_monthly_state(),
		"manual_state": manual,
		"canon_v2_runtime": get_canon_v2_runtime_state()
	}


func _commit_canon_v2_runtime_candidate(candidate: Dictionary, event: String) -> Dictionary:
	var normalized := _normalize_canon_v2_runtime_state(candidate)
	var validation := _validate_canon_v2_runtime_state(normalized)
	if not bool(validation.get("ok", false)):
		return validation
	var previous := _canon_v2_runtime_state.duplicate(true)
	_canon_v2_runtime_state = normalized.duplicate(true)
	if not _persist_canon_v2_runtime_if_possible():
		_canon_v2_runtime_state = previous
		return {"ok": false, "error": "canon_v2_runtime_persistence_failed", "event": event}
	return {"ok": true, "event": event, "state": get_canon_v2_runtime_state()}


func _persist_canon_v2_runtime_if_possible() -> bool:
	if not is_inside_tree():
		return true
	if current_episode_data.is_empty():
		return true
	if get_current_episode_id() != AFTERLIFE_EPISODE_ID:
		return true
	return save_game()


func _persist_monthly_state_if_possible() -> bool:
	if not is_inside_tree():
		return true
	if current_episode_data.is_empty():
		return true
	if get_current_episode_id() != AFTERLIFE_EPISODE_ID:
		return true
	return save_game()


func _persist_m01_first_session_state_if_possible() -> bool:
	if not is_inside_tree():
		return true
	if current_episode_data.is_empty():
		return true
	if get_current_episode_id() != AFTERLIFE_EPISODE_ID:
		return true
	return save_game()


func _ensure_monthly_state() -> void:
	if _monthly_state.is_empty():
		_monthly_state = MonthlyStatePolicyScript.new().default_state(1)
	else:
		_monthly_state = MonthlyStatePolicyScript.new().normalize(_monthly_state, 1)


func _ensure_m01_first_session_state() -> void:
	if _m01_first_session_state.is_empty():
		_m01_first_session_state = M01FirstSessionOrchestratorScript.new().default_state()
	else:
		_m01_first_session_state = M01FirstSessionOrchestratorScript.new().normalize(_m01_first_session_state)


func _ensure_canon_v2_runtime_state() -> void:
	if _canon_v2_runtime_state.is_empty():
		_canon_v2_runtime_state = _default_canon_v2_runtime_state()
	else:
		_canon_v2_runtime_state = _normalize_canon_v2_runtime_state(_canon_v2_runtime_state)


func _default_canon_v2_runtime_state() -> Dictionary:
	return {
		"schema_version": CANON_V2_RUNTIME_SCHEMA_VERSION,
		"rescue_outcome_snapshot": {},
		"recovery_handoff_state": {},
		"active_protection_obligations": [],
		"protection_history": [],
		"applied_cost_adjustment_ids": {},
		"termination_preview": {},
		"incident_end_packet": {},
		"representative_outcome": "",
		"follow_up_records": [],
		"evaluation_packet": {},
		"reward_claims": {},
		"legacy_provenance": {}
	}


func _normalize_canon_v2_runtime_state(value: Dictionary) -> Dictionary:
	var normalized := _default_canon_v2_runtime_state()
	for key in normalized:
		if value.has(key):
			normalized[key] = value.get(key)
	normalized["schema_version"] = CANON_V2_RUNTIME_SCHEMA_VERSION
	for dictionary_key in [
		"rescue_outcome_snapshot",
		"recovery_handoff_state",
		"applied_cost_adjustment_ids",
		"termination_preview",
		"incident_end_packet",
		"evaluation_packet",
		"reward_claims",
		"legacy_provenance"
	]:
		normalized[dictionary_key] = _dictionary_copy(normalized.get(dictionary_key))
	for array_key in [
		"active_protection_obligations",
		"protection_history",
		"follow_up_records"
	]:
		normalized[array_key] = _array_copy(normalized.get(array_key))
	normalized["representative_outcome"] = String(normalized.get("representative_outcome", ""))
	return normalized


func _validate_canon_v2_runtime_state(state: Dictionary) -> Dictionary:
	if int(state.get("schema_version", 0)) != CANON_V2_RUNTIME_SCHEMA_VERSION:
		return {"ok": false, "error": "invalid_canon_v2_runtime_schema"}
	for dictionary_key in [
		"rescue_outcome_snapshot",
		"recovery_handoff_state",
		"applied_cost_adjustment_ids",
		"termination_preview",
		"incident_end_packet",
		"evaluation_packet",
		"reward_claims",
		"legacy_provenance"
	]:
		if typeof(state.get(dictionary_key)) != TYPE_DICTIONARY:
			return {"ok": false, "error": "invalid_runtime_dictionary", "field": dictionary_key}
	for array_key in ["active_protection_obligations", "protection_history", "follow_up_records"]:
		if typeof(state.get(array_key)) != TYPE_ARRAY:
			return {"ok": false, "error": "invalid_runtime_array", "field": array_key}

	var obligation_ids: Dictionary = {}
	for obligation_value in _array_copy(state.get("active_protection_obligations")):
		if typeof(obligation_value) != TYPE_DICTIONARY:
			return {"ok": false, "error": "invalid_obligation_record"}
		var obligation_id := String((obligation_value as Dictionary).get("obligation_id", ""))
		if obligation_id.is_empty() or obligation_ids.has(obligation_id):
			return {"ok": false, "error": "duplicate_or_missing_obligation_id", "obligation_id": obligation_id}
		obligation_ids[obligation_id] = true

	var follow_up_keys: Dictionary = {}
	for record_value in _array_copy(state.get("follow_up_records")):
		if typeof(record_value) != TYPE_DICTIONARY:
			return {"ok": false, "error": "invalid_follow_up_record"}
		var record := record_value as Dictionary
		var dedupe_key := String(record.get("dedupe_key", ""))
		if dedupe_key.is_empty() or follow_up_keys.has(dedupe_key):
			return {"ok": false, "error": "duplicate_or_missing_follow_up_dedupe_key", "dedupe_key": dedupe_key}
		follow_up_keys[dedupe_key] = true
	return {"ok": true}


func _derive_protection_status(obligations: Array) -> String:
	var has_unresolved := false
	var has_breached := false
	for obligation_value in obligations:
		if typeof(obligation_value) != TYPE_DICTIONARY:
			continue
		var status := String((obligation_value as Dictionary).get("status", "unresolved"))
		if status == "breached":
			has_breached = true
		elif status == "unresolved":
			has_unresolved = true
	if has_breached:
		return "breached"
	if has_unresolved:
		return "unresolved"
	return "accounted"


func _reward_contains_campaign_power(reward: Dictionary) -> bool:
	for forbidden_key in [
		"permanent_stat",
		"mandatory_skill",
		"best_campaign_equipment",
		"mandatory_companion",
		"core_ending",
		"accessibility_feature"
	]:
		if reward.has(forbidden_key):
			return true
	return false


func _string_keys_from_adjustments(adjustments_value: Variant) -> Array[String]:
	var result: Array[String] = []
	for adjustment_value in _array_copy(adjustments_value):
		if typeof(adjustment_value) == TYPE_DICTIONARY:
			result.append(String((adjustment_value as Dictionary).get("cost_adjustment_id", "")))
	return result


func _read_dictionary(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	return parsed as Dictionary if typeof(parsed) == TYPE_DICTIONARY else {}


func _dictionary_copy(value: Variant) -> Dictionary:
	return (value as Dictionary).duplicate(true) if typeof(value) == TYPE_DICTIONARY else {}


func _array_copy(value: Variant) -> Array:
	return (value as Array).duplicate(true) if typeof(value) == TYPE_ARRAY else []


func _sha256(bytes: PackedByteArray) -> String:
	var context := HashingContext.new()
	if context.start(HashingContext.HASH_SHA256) != OK:
		return ""
	if context.update(bytes) != OK:
		return ""
	return context.finish().hex_encode()


func _remove_path(path: String) -> void:
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
