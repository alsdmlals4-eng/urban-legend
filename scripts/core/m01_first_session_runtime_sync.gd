class_name M01FirstSessionRuntimeSync
extends RefCounted

const M01_CASE_ID := "episode_001_afterlife_station"
const FIRST_DISPATCH_WEEK := 2
const SUPPORTED_MODES := ["investigation", "rescue", "recovery", "result"]
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
const MODE_TARGETS := {
	"investigation": "M01_DEDUCTION",
	"rescue": "M01_RESCUE",
	"recovery": "M01_RECOVERY",
	"result": "M01_COMPOSITE_RESULT"
}


func sync_scene_mode(game_state: Node, mode: String) -> Dictionary:
	if game_state == null:
		return _failure("GAME_STATE_MISSING")
	if mode not in SUPPORTED_MODES:
		return {"ok": true, "code": "NOT_APPLICABLE", "mode": mode}
	for method_name in [
		"get_current_episode_id",
		"get_monthly_state",
		"transition_monthly_state",
		"get_m01_first_session_state",
		"get_m01_first_session_available_actions",
		"apply_m01_first_session_event"
	]:
		if not game_state.has_method(method_name):
			return _failure("ORCHESTRATION_API_MISSING", method_name)
	if String(game_state.call("get_current_episode_id")) != M01_CASE_ID:
		return {"ok": true, "code": "NOT_APPLICABLE", "mode": mode}

	var monthly_result := _ensure_dispatchable_month(game_state)
	if not bool(monthly_result.get("ok", false)):
		return monthly_result

	var preliminary := _advance_until(game_state, "M01_DISPATCHABLE")
	if not bool(preliminary.get("ok", false)):
		return preliminary
	if String(preliminary.get("phase", "")) != "M01_DISPATCHABLE" and _phase_index(String(preliminary.get("phase", ""))) < _phase_index("M01_DISPATCHABLE"):
		return _synced(mode, preliminary, "SYNC_PAUSED")

	var activation := _ensure_active_month(game_state)
	if not bool(activation.get("ok", false)):
		return activation

	var target_phase := String(MODE_TARGETS.get(mode, "M01_INVESTIGATION"))
	var progressed := _advance_until(game_state, target_phase)
	if not bool(progressed.get("ok", false)):
		return progressed

	if mode == "result":
		var result_sync := _sync_result_aftermath(game_state)
		if not bool(result_sync.get("ok", false)):
			return result_sync
		progressed = result_sync

	return _synced(mode, progressed, "M01_RUNTIME_SYNCED")


func _ensure_dispatchable_month(game_state: Node) -> Dictionary:
	var monthly := game_state.call("get_monthly_state") as Dictionary
	if bool(monthly.get("resolved_this_month", false)):
		return {"ok": true, "code": "MONTH_ALREADY_RESOLVED", "state": monthly}
	var active_case_id := String(monthly.get("active_main_case_id", ""))
	var status := String(monthly.get("main_case_status", ""))
	if active_case_id.is_empty() and status == "DORMANT":
		return game_state.call(
			"transition_monthly_state",
			"MAKE_DISPATCHABLE",
			{"case_id": M01_CASE_ID, "week_index": FIRST_DISPATCH_WEEK}
		) as Dictionary
	if active_case_id != M01_CASE_ID:
		return _failure("OTHER_MONTHLY_MAIN_CASE_ACTIVE", active_case_id)
	if status not in ["DISPATCHABLE", "ACTIVE", "AFTERMATH"]:
		return _failure("M01_MONTHLY_STATE_INCOMPATIBLE", status)
	return {"ok": true, "code": "MONTH_READY", "state": monthly}


func _ensure_active_month(game_state: Node) -> Dictionary:
	var monthly := game_state.call("get_monthly_state") as Dictionary
	if bool(monthly.get("resolved_this_month", false)):
		return {"ok": true, "code": "MONTH_ALREADY_RESOLVED", "state": monthly}
	var status := String(monthly.get("main_case_status", ""))
	if status == "ACTIVE":
		return {"ok": true, "code": "MAIN_CASE_ALREADY_ACTIVE", "state": monthly}
	if status != "DISPATCHABLE":
		return _failure("M01_NOT_DISPATCHABLE_FOR_START", status)
	return game_state.call(
		"transition_monthly_state",
		"START_MAIN_CASE",
		{"case_id": M01_CASE_ID}
	) as Dictionary


func _advance_until(game_state: Node, target_phase: String) -> Dictionary:
	var target_index := _phase_index(target_phase)
	if target_index < 0:
		return _failure("UNKNOWN_TARGET_PHASE", target_phase)
	for _step in range(PHASES.size() + 1):
		var state := game_state.call("get_m01_first_session_state") as Dictionary
		var phase := String(state.get("phase", ""))
		var phase_index := _phase_index(phase)
		if phase_index < 0:
			return _failure("INVALID_FIRST_SESSION_PHASE", phase)
		if phase_index >= target_index:
			return {"ok": true, "code": "TARGET_REACHED", "phase": phase, "state": state}
		var available := game_state.call("get_m01_first_session_available_actions") as Array
		if available.is_empty():
			return {"ok": true, "code": "SYNC_PAUSED", "phase": phase, "state": state}
		var next_phase := String(available[0])
		if _phase_index(next_phase) > target_index:
			return {"ok": true, "code": "TARGET_LIMIT_REACHED", "phase": phase, "state": state}
		var applied := game_state.call("apply_m01_first_session_event", next_phase) as Dictionary
		if not bool(applied.get("ok", false)):
			return applied
	return _failure("FIRST_SESSION_SYNC_LOOP_GUARD")


func _sync_result_aftermath(game_state: Node) -> Dictionary:
	var state := game_state.call("get_m01_first_session_state") as Dictionary
	var phase := String(state.get("phase", ""))
	if _phase_index(phase) < _phase_index("M01_COMPOSITE_RESULT"):
		return {"ok": true, "code": "SYNC_PAUSED", "phase": phase, "state": state}

	var monthly := game_state.call("get_monthly_state") as Dictionary
	if not bool(monthly.get("resolved_this_month", false)):
		if not game_state.has_method("get_canon_v2_runtime_state"):
			return _failure("CANON_RUNTIME_API_MISSING")
		var runtime := game_state.call("get_canon_v2_runtime_state") as Dictionary
		var incident_packet_value: Variant = runtime.get("incident_end_packet")
		var incident_packet := incident_packet_value as Dictionary if typeof(incident_packet_value) == TYPE_DICTIONARY else {}
		var result_ref := String(incident_packet.get("case_canon_reference", ""))
		if result_ref.is_empty():
			return {"ok": true, "code": "SYNC_PAUSED", "phase": phase, "state": state}
		var resolved := game_state.call(
			"transition_monthly_state",
			"RESOLVE_MAIN_CASE",
			{"result_ref": result_ref}
		) as Dictionary
		if not bool(resolved.get("ok", false)):
			return resolved

	return _advance_until(game_state, "MONTHLY_AFTERMATH")


func _synced(mode: String, detail: Dictionary, code: String) -> Dictionary:
	return {
		"ok": true,
		"code": code,
		"mode": mode,
		"phase": String(detail.get("phase", "")),
		"detail_code": String(detail.get("code", ""))
	}


func _phase_index(phase: String) -> int:
	return PHASES.find(phase)


func _failure(code: String, detail: String = "") -> Dictionary:
	var result := {
		"ok": false,
		"code": code,
		"reason": code.to_lower()
	}
	if not detail.is_empty():
		result["detail"] = detail
	return result
