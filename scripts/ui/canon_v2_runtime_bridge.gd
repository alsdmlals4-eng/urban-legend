extends Node

const OperationOverlayScript := preload("res://scripts/ui/canon_v2_operation_overlay.gd")
const AfterlifeRescueResultAdapterScript := preload("res://scripts/data/afterlife_rescue_result_adapter.gd")

const SYNC_INTERVAL_SECONDS := 0.25
const FREE_INFORMATION_CHANNELS := ["observe", "open_manual", "preview_result"]

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
	var state := _build_overlay_state(mode)
	_mount_overlay(current_scene, state, mode)
	_mounted_scene_instance_id = current_scene.get_instance_id()


func _mount_overlay(host: Node, runtime_state: Dictionary, mode: String) -> Node:
	if host == null:
		return null
	var existing := host.get_node_or_null("CanonV2OperationOverlay")
	if existing != null:
		if existing.has_method("configure"):
			existing.configure(runtime_state, mode)
		return existing
	var overlay = OperationOverlayScript.new()
	overlay.name = "CanonV2OperationOverlay"
	host.add_child(overlay)
	overlay.configure(runtime_state, mode)
	return overlay


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
		var runtime_before_follow_up: Dictionary = {}
		if game_state.has_method("get_canon_v2_runtime_state"):
			runtime_before_follow_up = game_state.get_canon_v2_runtime_state()
		if (runtime_before_follow_up.get("follow_up_records", []) as Array).is_empty() and not (runtime_before_follow_up.get("active_protection_obligations", []) as Array).is_empty():
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
