class_name AfterlifeRescueResultAdapter
extends RefCounted

const ADAPTER_ID := "AUTHORED_AFTERLIFE_ROUTE_RESTORE_ADAPTER_V1"
const ROUTE_RESTORE_MINIGAME_ID := "minigame_frequency_sync"


func bootstrap(game_state: Node, minigame_id: String = ROUTE_RESTORE_MINIGAME_ID) -> Dictionary:
	if game_state == null:
		return {"ok": false, "error": "game_state_missing"}
	if not game_state.has_method("get_canon_v2_runtime_state") or not game_state.has_method("finalize_canon_v2_rescue_outcome_snapshot"):
		return {"ok": false, "error": "canon_v2_runtime_api_missing"}
	var runtime: Dictionary = game_state.get_canon_v2_runtime_state()
	var existing_snapshot := _dictionary_copy(runtime.get("rescue_outcome_snapshot"))
	if not existing_snapshot.is_empty():
		return {
			"ok": true,
			"reused_existing_snapshot": true,
			"snapshot": existing_snapshot
		}
	var built := build_snapshot(game_state, minigame_id)
	if not bool(built.get("ok", false)):
		return built
	var snapshot := _dictionary_copy(built.get("snapshot"))
	var finalized: Dictionary = game_state.finalize_canon_v2_rescue_outcome_snapshot(snapshot)
	if not bool(finalized.get("ok", false)):
		return finalized
	return {
		"ok": true,
		"reused_existing_snapshot": false,
		"snapshot": snapshot,
		"adapter_id": ADAPTER_ID
	}


func build_snapshot(game_state: Node, minigame_id: String = ROUTE_RESTORE_MINIGAME_ID) -> Dictionary:
	if game_state == null or not game_state.has_method("get_minigame_result"):
		return {"ok": false, "error": "minigame_result_api_missing"}
	if minigame_id != ROUTE_RESTORE_MINIGAME_ID:
		return {"ok": false, "error": "unsupported_rescue_result_adapter", "minigame_id": minigame_id}
	var result: Dictionary = game_state.get_minigame_result(minigame_id)
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
	var aftereffects := _array_copy(result.get("aftereffects"))
	if aftereffects.is_empty():
		aftereffects = ["route_restore_requires_recovery_handoff"]
	var source_timestamp := String(result.get("last_updated_at", "verified_result"))
	return {
		"ok": true,
		"snapshot": {
			"snapshot_id": "rescue:%s:%s" % [minigame_id, source_timestamp.sha256_text().substr(0, 12)],
			"survival_state": survival_state,
			"separation_state": separation_state,
			"aftereffects": aftereffects,
			"observed_failure_reasons": _array_copy(result.get("observed_failure_reasons")),
			"irreversible_results": _array_copy(result.get("irreversible_results")),
			"provenance": {
				"source": "minigame_result",
				"source_minigame_id": minigame_id,
				"source_result_state": String(result.get("result_state", "success")),
				"source_last_updated_at": source_timestamp,
				"adapter_id": ADAPTER_ID,
				"mapping_boundary": "SUCCESS_MEANS_ROUTE_VERIFIED_NOT_COMPLETE_SEPARATION"
			}
		}
	}


func _dictionary_copy(value: Variant) -> Dictionary:
	return (value as Dictionary).duplicate(true) if typeof(value) == TYPE_DICTIONARY else {}


func _array_copy(value: Variant) -> Array:
	return (value as Array).duplicate(true) if typeof(value) == TYPE_ARRAY else []
