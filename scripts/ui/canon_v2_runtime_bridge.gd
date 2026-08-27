extends Node

const OperationOverlayScript := preload("res://scripts/ui/canon_v2_operation_overlay.gd")
const AfterlifeRescueResultAdapterScript := preload("res://scripts/data/afterlife_rescue_result_adapter.gd")
const M01FirstSessionRuntimeSyncScript := preload("res://scripts/core/m01_first_session_runtime_sync.gd")

const SYNC_INTERVAL_SECONDS := 0.25
const FREE_INFORMATION_CHANNELS := ["observe", "open_manual", "preview_result"]
const DEFAULT_RULE_STRIP_TOP_INSET := 14
const INVESTIGATION_RULE_STRIP_TOP_INSET := 72

var _elapsed := 0.0
var _mounted_scene_instance_id := 0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process(true)
	call_deferred("_sync_current_scene")


func _process(delta: float) -> void:
	_elapsed += delta
	if _elapsed < SYNC_INTERVAL_SECONDS:
		return
	_elapsed = 0.0
	_sync_current_scene()


func classify_scene_path(scene_path: String) -> String:
	var normalized := scene_path.to_lower()
	if normalized.contains("minigame") or normalized.contains("rescue"):
		return "rescue"
	if normalized.contains("battle") or normalized.contains("recovery"):
		return "recovery"
	if normalized.contains("result"):
		return "result"
	if normalized.contains("investigation") or normalized.contains("report"):
		return "investigation"
	return ""


func classify_recovery_action_id(action_id: String) -> String:
	var normalized := action_id.to_lower()
	match normalized:
		"response_afterlife_present_official_ticket", "response_afterlife_insert_official_identifier":
			return "seal"
		"response_afterlife_anchor_persistent_trace":
			return "observe"
	if normalized.contains("observe") or normalized.contains("trace") or normalized.contains("evidence"):
		return "observe"
	if normalized.contains("manual"):
		return "open_manual"
	if normalized.contains("protect") or normalized.contains("guard") or normalized.contains("shield"):
		return "protect"
	if normalized.contains("seal") or normalized.contains("contain") or normalized.contains("official_ticket") or normalized.contains("official_identifier"):
		return "seal"
	if normalized.contains("attack") or normalized.contains("suppress") or normalized.contains("strike"):
		return "attack"
	if normalized.contains("withdraw") or normalized.contains("retreat"):
		return "withdraw"
	return ""


func request_action_gate(action_id: String, continuation: Callable) -> bool:
	var scene_tree := get_tree()
	if scene_tree == null or scene_tree.current_scene == null:
		return false
	if classify_scene_path(scene_tree.current_scene.scene_file_path) != "recovery":
		return false
	var overlay := scene_tree.current_scene.get_node_or_null("CanonV2OperationOverlay")
	var game_state := get_node_or_null("/root/GameState")
	return _request_action_gate(action_id, continuation, overlay, game_state)


func request_action_gate_for_test(
	action_id: String,
	continuation: Callable,
	overlay: Node,
	game_state: Node
) -> bool:
	return _request_action_gate(action_id, continuation, overlay, game_state)


func sync_recovery_termination_preview_for_test(host: Node, game_state: Node) -> Dictionary:
	return _sync_recovery_termination_preview(host, game_state)


func finalize_legacy_recovery_for_test(game_state: Node) -> Dictionary:
	return _finalize_legacy_recovery(game_state)


func sync_m01_first_session_for_test(mode: String, game_state: Node) -> Dictionary:
	return _sync_m01_first_session(mode, game_state)


func mount_overlay_for_test(host: Node, runtime_state: Dictionary, mode: String) -> Node:
	return _mount_overlay(host, runtime_state, mode)


func _request_action_gate(
	action_id: String,
	continuation: Callable,
	overlay: Node,
	game_state: Node
) -> bool:
	var semantic_channel := classify_recovery_action_id(action_id)
	if semantic_channel.is_empty() or semantic_channel in FREE_INFORMATION_CHANNELS:
		return false
	if overlay == null or not overlay.has_method("request_action_confirmation"):
		return false
	if game_state == null or not game_state.has_method("preview_canon_v2_recovery_action"):
		return false
	var preview: Dictionary = game_state.preview_canon_v2_recovery_action({
		"action_id": semantic_channel,
		"source_action_id": action_id,
		"base_cost": _base_cost_for_channel(semantic_channel)
	}, {
		"safe_route": true,
		"available_supports": []
	})
	if not bool(preview.get("allowed", true)):
		overlay.request_action_confirmation(preview, Callable(), Callable())
		return true
	var requires_gate := not _array_copy(preview.get("risk_changes")).is_empty()
	requires_gate = requires_gate or not _array_copy(preview.get("cost_adjustments")).is_empty()
	requires_gate = requires_gate or not _array_copy(preview.get("validation_errors")).is_empty()
	if not requires_gate:
		return false
	var preview_id := String(preview.get("preview_id", ""))
	var confirm_callback := Callable(self, "_confirm_gated_action").bind(
		game_state,
		preview_id,
		continuation
	)
	overlay.request_action_confirmation(preview, confirm_callback, Callable())
	return true


func _confirm_gated_action(game_state: Node, preview_id: String, continuation: Callable) -> void:
	if game_state == null or not game_state.has_method("commit_canon_v2_recovery_action"):
		return
	var committed: Dictionary = game_state.commit_canon_v2_recovery_action(preview_id)
	if not bool(committed.get("committed", false)):
		return
	if continuation.is_valid():
		continuation.call()


func _base_cost_for_channel(channel: String) -> int:
	if channel in FREE_INFORMATION_CHANNELS:
		return 0
	return 1


func _sync_current_scene() -> void:
	var scene_tree := get_tree()
	if scene_tree == null:
		return
	var current_scene := scene_tree.current_scene
	if current_scene == null:
		return
	var scene_path := current_scene.scene_file_path
	var mode := classify_scene_path(scene_path)
	if mode.is_empty():
		return
	var game_state := get_node_or_null("/root/GameState")
	if mode == "recovery":
		_sync_recovery_termination_preview(current_scene, game_state)
	elif mode == "result":
		_finalize_legacy_recovery(game_state)
	var state := _build_overlay_state(mode)
	_sync_m01_first_session(mode, game_state)
	_mount_overlay(current_scene, state, mode)
	_mounted_scene_instance_id = current_scene.get_instance_id()


func _sync_m01_first_session(mode: String, game_state: Node) -> Dictionary:
	if game_state == null:
		return {"ok": false, "code": "GAME_STATE_MISSING"}
	return M01FirstSessionRuntimeSyncScript.new().sync_scene_mode(game_state, mode)


func _sync_recovery_termination_preview(host: Node, game_state: Node) -> Dictionary:
	if host == null or game_state == null:
		return {}
	if not game_state.has_method("evaluate_canon_v2_recovery_termination"):
		return {}
	var recover_button := host.find_child("RecoverButton", true, false) as Button
	if recover_button == null or recover_button.disabled:
		return {}
	if game_state.has_method("get_canon_v2_runtime_state"):
		var runtime: Dictionary = game_state.get_canon_v2_runtime_state()
		var existing := _dictionary_copy(runtime.get("termination_preview"))
		if String(existing.get("termination_candidate", "")) == "residue_recovered":
			return existing
	var obligations: Array = []
	if game_state.has_method("get_active_protection_obligations"):
		obligations = game_state.get_active_protection_obligations()
	return game_state.evaluate_canon_v2_recovery_termination("residue_recovered", {
		"control_evidence": {
			"residue_secured": true,
			"spread_controlled": true
		},
		"obligations": obligations
	})


func _finalize_legacy_recovery(game_state: Node) -> Dictionary:
	if game_state == null:
		return {"ok": false, "error": "game_state_missing"}
	if not game_state.has_method("get_canon_v2_runtime_state") or not game_state.has_method("apply_canon_v2_runtime_state"):
		return {"ok": false, "error": "canon_v2_runtime_api_missing"}
	var runtime: Dictionary = game_state.get_canon_v2_runtime_state()
	var existing_packet := _dictionary_copy(runtime.get("incident_end_packet"))
	if not existing_packet.is_empty():
		return {"ok": true, "reused_existing_packet": true, "incident_end_packet": existing_packet}
	var successful := false
	var legacy_status := ""
	var legacy_stability := 0
	if game_state.has_method("is_recovery_successful"):
		successful = bool(game_state.is_recovery_successful())
	if game_state.has_method("get_recovery_result_status"):
		legacy_status = String(game_state.get_recovery_result_status())
	if game_state.has_method("get_recovery_result_stability"):
		legacy_stability = int(game_state.get_recovery_result_stability())
	if legacy_status.is_empty() and not successful:
		return {"ok": false, "error": "legacy_recovery_result_missing"}
	var representative_outcome := _map_legacy_recovery_outcome(legacy_status, successful)
	var obligations := _array_copy(runtime.get("active_protection_obligations"))
	var packet := {
		"case_canon_reference": "episode_001_afterlife_station:incident_end",
		"representative_outcome": representative_outcome,
		"protection_status": _derive_protection_status(obligations),
		"legacy_recovery_successful": successful,
		"legacy_recovery_status": legacy_status,
		"legacy_recovery_stability": legacy_stability,
		"legacy_provenance": {
			"classification": "LEGACY_SINGLE_OUTCOME" if legacy_status == "core_recovered" else "LEGACY_COMPAT_ONLY",
			"mapping_boundary": "STATUS_FIRST_NO_INVENTED_FULL_SUCCESS"
		}
	}
	runtime["representative_outcome"] = representative_outcome
	runtime["incident_end_packet"] = packet
	var applied: Dictionary = game_state.apply_canon_v2_runtime_state(runtime)
	if not bool(applied.get("ok", false)):
		return applied
	return {"ok": true, "reused_existing_packet": false, "incident_end_packet": packet}


func _map_legacy_recovery_outcome(status: String, successful: bool) -> String:
	match status:
		"core_recovered", "residue_recovered":
			return "residue_recovered"
		"containment_complete":
			return "containment_complete"
		"stabilization_complete":
			return "stabilization_complete"
		"emergency_containment":
			return "emergency_containment"
		"approved_withdrawal":
			return "approved_withdrawal"
		"control_failure":
			return "control_failure"
	return "legacy_success_unclassified" if successful else "legacy_failure_unclassified"


func _derive_protection_status(obligations: Array) -> String:
	var has_unresolved := false
	for obligation_value in obligations:
		if typeof(obligation_value) != TYPE_DICTIONARY:
			continue
		var status := String((obligation_value as Dictionary).get("status", "unresolved"))
		if status == "breached":
			return "breached"
		if status == "unresolved":
			has_unresolved = true
	return "unresolved" if has_unresolved else "accounted"


func _mount_overlay(host: Node, runtime_state: Dictionary, mode: String) -> Node:
	if host == null:
		return null
	if mode == "recovery":
		_hide_legacy_recovery_hud(host)
	elif mode == "investigation":
		_hide_legacy_investigation_log_bar(host)
	var existing := host.get_node_or_null("CanonV2OperationOverlay")
	if existing != null:
		if existing.has_method("configure"):
			existing.configure(runtime_state, mode)
		_apply_overlay_host_layout(existing, mode)
		return existing
	var overlay = OperationOverlayScript.new()
	overlay.name = "CanonV2OperationOverlay"
	host.add_child(overlay)
	overlay.configure(runtime_state, mode)
	_apply_overlay_host_layout(overlay, mode)
	return overlay


func _hide_legacy_recovery_hud(host: Node) -> void:
	var legacy_hud := host.get_node_or_null("RecoveryHud") as Control
	if legacy_hud != null:
		legacy_hud.visible = false


func _hide_legacy_investigation_log_bar(host: Node) -> void:
	var legacy_log_bar := host.get_node_or_null("SafeFrame/MainColumn/LogBar") as Control
	if legacy_log_bar != null:
		legacy_log_bar.visible = false


func _apply_overlay_host_layout(overlay: Node, mode: String) -> void:
	if overlay == null or not overlay.has_method("set_rule_strip_top_inset"):
		return
	var top_inset := INVESTIGATION_RULE_STRIP_TOP_INSET if mode == "investigation" else DEFAULT_RULE_STRIP_TOP_INSET
	overlay.call("set_rule_strip_top_inset", top_inset)


func _build_overlay_state(mode: String) -> Dictionary:
	var state := {
		"manual_state": _get_player_manual_state(),
		"active_protection_obligations": [],
		"termination_preview": {},
		"follow_up_records": [],
		"evaluation_packet": {}
	}
	var game_state := get_node_or_null("/root/GameState")
	if game_state == null:
		return state

	if mode in ["recovery", "result"]:
		_bootstrap_and_initialize_handoff(game_state)
	if mode == "result" and game_state.has_method("rebuild_canon_v2_follow_up_records"):
		_finalize_legacy_recovery(game_state)
		var runtime_before_follow_up: Dictionary = {}
		if game_state.has_method("get_canon_v2_runtime_state"):
			runtime_before_follow_up = game_state.get_canon_v2_runtime_state()
		if (runtime_before_follow_up.get("follow_up_records", []) as Array).is_empty():
			game_state.rebuild_canon_v2_follow_up_records({
				"default_step_limit": 1,
				"unresolved": {"actionable": true, "actionable_reason": "미해결 보호 책임을 확인해야 합니다."},
				"breached": {"actionable": true, "actionable_reason": "추가 피해 완화와 책임 이행이 필요합니다."}
			})

	if game_state.has_method("get_canon_v2_runtime_state"):
		var runtime: Dictionary = game_state.get_canon_v2_runtime_state()
		state["active_protection_obligations"] = _array_copy(runtime.get("active_protection_obligations"))
		state["termination_preview"] = _dictionary_copy(runtime.get("termination_preview"))
		state["follow_up_records"] = _array_copy(runtime.get("follow_up_records"))
		state["evaluation_packet"] = _dictionary_copy(runtime.get("evaluation_packet"))
	return state


func _bootstrap_and_initialize_handoff(game_state: Node) -> void:
	if not game_state.has_method("get_canon_v2_runtime_state"):
		return
	var runtime: Dictionary = game_state.get_canon_v2_runtime_state()
	if _dictionary_copy(runtime.get("rescue_outcome_snapshot")).is_empty():
		AfterlifeRescueResultAdapterScript.new().bootstrap(game_state, "minigame_frequency_sync")
		runtime = game_state.get_canon_v2_runtime_state()
	if _dictionary_copy(runtime.get("rescue_outcome_snapshot")).is_empty():
		return
	if game_state.has_method("ensure_canon_v2_recovery_handoff_initialized"):
		game_state.ensure_canon_v2_recovery_handoff_initialized({
			"case_id": "episode_001_afterlife_station",
			"protected_subject_id": "victim_afterlife_station_001"
		})


func _get_player_manual_state() -> Dictionary:
	var game_state := get_node_or_null("/root/GameState")
	if game_state == null:
		return {"pages": [], "active_rule_ids": []}
	var manual: Dictionary = {}
	if game_state.has_method("get_afterlife_manual_state"):
		manual = game_state.get_afterlife_manual_state()
	if manual.is_empty() and game_state.has_method("get_current_episode"):
		var episode: Dictionary = game_state.get_current_episode()
		manual = _dictionary_copy(episode.get("investigation_manual"))

	var pages := _array_copy(manual.get("pages"))
	var active_rule_ids := _string_array(manual.get("active_rule_ids"))
	if active_rule_ids.is_empty():
		active_rule_ids = _string_array(manual.get("completed_page_ids"))
	if active_rule_ids.is_empty():
		active_rule_ids = _derive_active_pages_from_filled_slots(pages, manual)
	return {
		"pages": pages,
		"active_rule_ids": active_rule_ids,
		"evidence_records": _array_copy(manual.get("evidence_records")),
		"candidate_keywords": _array_copy(manual.get("candidate_keywords")),
		"semantic_relations": _array_copy(manual.get("semantic_relations"))
	}


func _derive_active_pages_from_filled_slots(pages: Array, manual: Dictionary) -> Array[String]:
	var filled_slots := _dictionary_copy(manual.get("filled_slots"))
	if filled_slots.is_empty():
		return []
	var result: Array[String] = []
	for page_value in pages:
		if typeof(page_value) != TYPE_DICTIONARY:
			continue
		var page := page_value as Dictionary
		var required_slots := _string_array(page.get("slot_ids"))
		if required_slots.is_empty():
			continue
		var complete := true
		for slot_id in required_slots:
			if not filled_slots.has(slot_id):
				complete = false
				break
		if complete:
			result.append(String(page.get("id", "")))
	return result


func _dictionary_copy(value: Variant) -> Dictionary:
	return (value as Dictionary).duplicate(true) if typeof(value) == TYPE_DICTIONARY else {}


func _array_copy(value: Variant) -> Array:
	return (value as Array).duplicate(true) if typeof(value) == TYPE_ARRAY else []


func _string_array(value: Variant) -> Array[String]:
	var result: Array[String] = []
	if typeof(value) != TYPE_ARRAY:
		return result
	for item in value as Array:
		result.append(String(item))
	return result
