extends "res://scripts/core/afterlife_migrating_game_state.gd"

const AFTERLIFE_ROUTE_RESTORE_ADAPTER_ID := "AUTHORED_AFTERLIFE_ROUTE_RESTORE_ADAPTER_V1"
const AFTERLIFE_ROUTE_RESTORE_MINIGAME_ID := "minigame_frequency_sync"


func bootstrap_canon_v2_rescue_snapshot_from_minigame(minigame_id: String = AFTERLIFE_ROUTE_RESTORE_MINIGAME_ID) -> Dictionary:
	var runtime := get_canon_v2_runtime_state()
	var existing_snapshot := runtime.get("rescue_outcome_snapshot", {}) as Dictionary
	if not existing_snapshot.is_empty():
		return {
			"ok": true,
			"reused_existing_snapshot": true,
			"snapshot": existing_snapshot.duplicate(true)
		}
	if minigame_id != AFTERLIFE_ROUTE_RESTORE_MINIGAME_ID:
		return {"ok": false, "error": "unsupported_rescue_result_adapter", "minigame_id": minigame_id}
	var result := get_minigame_result(minigame_id)
	if result.is_empty():
		return {"ok": false, "error": "rescue_result_missing", "minigame_id": minigame_id}
	if not bool(result.get("successful", false)):
		return {
			"ok": false,
			"error": "rescue_not_finalized",
			"reason": "route_restore_retry_remains_available"
		}

	var survival_state := String(result.get("victim_survival_state", "alive_stable"))
	if survival_state not in ["alive_stable", "alive_critical", "lost", "dead", "missing_unknown"]:
		survival_state = "alive_stable"
	var separation_state := String(result.get("victim_separation_state", "partial"))
	if separation_state not in ["complete", "partial", "failed", "irreversible"]:
		separation_state = "partial"
	var aftereffects := _runtime_array_copy(result.get("aftereffects"))
	if aftereffects.is_empty():
		aftereffects = ["route_restore_requires_recovery_handoff"]
	var observed_failure_reasons := _runtime_array_copy(result.get("observed_failure_reasons"))
	var irreversible_results := _runtime_array_copy(result.get("irreversible_results"))
	var source_timestamp := String(result.get("last_updated_at", "verified_result"))
	var snapshot := {
		"snapshot_id": "rescue:%s:%s" % [minigame_id, source_timestamp.sha256_text().substr(0, 12)],
		"survival_state": survival_state,
		"separation_state": separation_state,
		"aftereffects": aftereffects,
		"observed_failure_reasons": observed_failure_reasons,
		"irreversible_results": irreversible_results,
		"provenance": {
			"source": "minigame_result",
			"source_minigame_id": minigame_id,
			"source_result_state": String(result.get("result_state", "success")),
			"source_last_updated_at": source_timestamp,
			"adapter_id": AFTERLIFE_ROUTE_RESTORE_ADAPTER_ID,
			"mapping_boundary": "SUCCESS_MEANS_ROUTE_VERIFIED_NOT_COMPLETE_SEPARATION"
		}
	}
	var finalized := finalize_canon_v2_rescue_outcome_snapshot(snapshot)
	if not bool(finalized.get("ok", false)):
		return finalized
	return {
		"ok": true,
		"reused_existing_snapshot": false,
		"snapshot": snapshot.duplicate(true),
		"adapter_id": AFTERLIFE_ROUTE_RESTORE_ADAPTER_ID
	}


func _runtime_array_copy(value: Variant) -> Array:
	return (value as Array).duplicate(true) if typeof(value) == TYPE_ARRAY else []
