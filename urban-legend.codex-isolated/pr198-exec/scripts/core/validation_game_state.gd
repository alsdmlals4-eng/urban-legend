extends "res://scripts/core/game_state.gd"

const VALIDATION_EPISODE_ID := "episode_001_afterlife_station"
const VALIDATION_REQUIRED_KEYS := [
	"episode_id",
	"episode_path",
	"scene_path",
	"dialogue_node_id",
	"field_node_id",
	"minigame_id",
	"selected_agent_ids",
	"flags",
	"collected_clue_ids",
	"seen_hint_ids",
	"method_results",
	"minigame_results",
	"resolution",
	"recovery",
	"agent_case_states",
	"victim_state"
]


func save_game() -> bool:
	var session = get_node_or_null("/root/ValidationSession")
	if session != null and session.has_method("requires_save_routing") and bool(session.requires_save_routing()):
		if not session.has_method("is_active_and_valid") or not bool(session.is_active_and_valid()):
			return false
		if not session.has_method("save"):
			return false
		var result: Dictionary = session.save(self)
		return String(result.get("code", "")) == "OK"
	return super.save_game()


func initialize_validation_runtime(episode_id: String, agent_ids: Array) -> Dictionary:
	if episode_id != VALIDATION_EPISODE_ID:
		return {"ok": false, "code": "INVALID_EPISODE"}
	if agent_ids.is_empty() or agent_ids.size() > 3:
		return {"ok": false, "code": "INVALID_AGENT_SELECTION"}
	for agent_id in agent_ids:
		if typeof(agent_id) != TYPE_STRING or String(agent_id).is_empty():
			return {"ok": false, "code": "INVALID_AGENT_SELECTION"}

	var hidden_before := snapshot_hidden_legacy_state_for_test()
	if not load_episode(DEFAULT_EPISODE_PATH):
		return {"ok": false, "code": "INCOMPATIBLE_CONTENT"}

	current_scene_path = SCENE_DIALOGUE
	current_dialogue_node_id = DEFAULT_DIALOGUE_NODE_ID
	current_field_node_id = DEFAULT_FIELD_NODE_ID
	current_minigame_id = DEFAULT_MINIGAME_ID
	selected_agent_ids = agent_ids.duplicate(true)
	flags.clear()
	_apply_collected_clue_ids([])
	seen_hint_ids.clear()
	method_results.clear()
	minigame_results.clear()
	selected_resolution_grade = ""
	selected_resolution_label = ""
	selected_resolution_rate = 0.0
	recovery_successful = false
	recovery_result_status = ""
	recovery_result_stability = 100
	current_recovery_pattern_id = ""
	last_recovery_pattern_id = ""
	confirmed_recovery_pattern_id = ""
	seen_recovery_pattern_ids.clear()
	recovery_pattern_learning.clear()
	agent_case_states.clear()
	victim_state.clear()

	if not _semantic_equal(hidden_before, snapshot_hidden_legacy_state_for_test()):
		return {"ok": false, "code": "HIDDEN_STATE_GUARD_VIOLATION"}
	return {"ok": true, "code": "OK"}


func export_validation_runtime_snapshot() -> Dictionary:
	return {
		"episode_id": get_current_episode_id(),
		"episode_path": current_episode_path,
		"scene_path": current_scene_path,
		"dialogue_node_id": current_dialogue_node_id,
		"field_node_id": current_field_node_id,
		"minigame_id": current_minigame_id,
		"selected_agent_ids": selected_agent_ids.duplicate(),
		"flags": flags.duplicate(),
		"collected_clue_ids": get_collected_clue_ids(),
		"seen_hint_ids": seen_hint_ids.duplicate(),
		"method_results": method_results.duplicate(true),
		"minigame_results": minigame_results.duplicate(true),
		"resolution": {
			"grade": selected_resolution_grade,
			"label": selected_resolution_label,
			"rate": selected_resolution_rate
		},
		"recovery": {
			"successful": recovery_successful,
			"result_status": recovery_result_status,
			"stability": recovery_result_stability,
			"current_pattern_id": current_recovery_pattern_id,
			"last_pattern_id": last_recovery_pattern_id,
			"confirmed_pattern_id": confirmed_recovery_pattern_id,
			"seen_pattern_ids": seen_recovery_pattern_ids.duplicate(),
			"pattern_learning": recovery_pattern_learning.duplicate(true)
		},
		"agent_case_states": agent_case_states.duplicate(true),
		"victim_state": victim_state.duplicate(true)
	}


func restore_validation_runtime_snapshot(snapshot: Dictionary) -> Dictionary:
	var validated := _validate_validation_snapshot(snapshot)
	if String(validated.get("code", "")) != "OK":
		return validated

	var selected_ids := (snapshot.get("selected_agent_ids") as Array).duplicate(true)
	var restored_flags := (snapshot.get("flags") as Array).duplicate(true)
	var clue_ids := (snapshot.get("collected_clue_ids") as Array).duplicate(true)
	var restored_hints := (snapshot.get("seen_hint_ids") as Array).duplicate(true)
	var restored_methods := (snapshot.get("method_results") as Dictionary).duplicate(true)
	var restored_minigames := (snapshot.get("minigame_results") as Dictionary).duplicate(true)
	var resolution := (snapshot.get("resolution") as Dictionary).duplicate(true)
	var recovery := (snapshot.get("recovery") as Dictionary).duplicate(true)
	var restored_agent_states := (snapshot.get("agent_case_states") as Dictionary).duplicate(true)
	var restored_victim_state := (snapshot.get("victim_state") as Dictionary).duplicate(true)

	if not load_episode(DEFAULT_EPISODE_PATH):
		return {"ok": false, "code": "INCOMPATIBLE_CONTENT"}

	current_scene_path = String(snapshot.get("scene_path", SCENE_DIALOGUE))
	current_dialogue_node_id = String(snapshot.get("dialogue_node_id", DEFAULT_DIALOGUE_NODE_ID))
	current_field_node_id = String(snapshot.get("field_node_id", DEFAULT_FIELD_NODE_ID))
	current_minigame_id = String(snapshot.get("minigame_id", DEFAULT_MINIGAME_ID))
	selected_agent_ids = selected_ids
	flags = restored_flags
	_apply_collected_clue_ids(clue_ids)
	seen_hint_ids = restored_hints
	method_results = restored_methods
	minigame_results = restored_minigames
	selected_resolution_grade = String(resolution.get("grade", ""))
	selected_resolution_label = String(resolution.get("label", ""))
	selected_resolution_rate = float(resolution.get("rate", 0.0))
	recovery_successful = bool(recovery.get("successful", false))
	recovery_result_status = String(recovery.get("result_status", ""))
	recovery_result_stability = clampi(int(recovery.get("stability", 100)), 0, 100)
	current_recovery_pattern_id = String(recovery.get("current_pattern_id", ""))
	last_recovery_pattern_id = String(recovery.get("last_pattern_id", ""))
	confirmed_recovery_pattern_id = String(recovery.get("confirmed_pattern_id", ""))
	seen_recovery_pattern_ids = (recovery.get("seen_pattern_ids") as Array).duplicate(true)
	recovery_pattern_learning = (recovery.get("pattern_learning") as Dictionary).duplicate(true)
	agent_case_states = restored_agent_states
	victim_state = restored_victim_state
	return {"ok": true, "code": "OK"}


func snapshot_hidden_legacy_state_for_test() -> Dictionary:
	return {
		"campaign_state": campaign_state.to_save_data(),
		"seen_log_tutorial_ids": seen_log_tutorial_ids.duplicate(),
		"agent_trust": agent_trust.duplicate(true),
		"agent_trust_changes": agent_trust_changes.duplicate(true),
		"triggered_agent_event_ids": triggered_agent_event_ids.duplicate(),
		"used_agent_supports": used_agent_supports.duplicate(),
		"unlocked_records": unlocked_records.duplicate(),
		"unlocked_equipment": unlocked_equipment.duplicate(),
		"unlocked_research_rewards": unlocked_research_rewards.duplicate(),
		"equipped_items": equipped_items.duplicate(),
		"used_equipment_effects": used_equipment_effects.duplicate(),
		"completed_case_reports": completed_case_reports.duplicate(true),
		"anomaly_manual_records": anomaly_manual_records.duplicate(true),
		"completed_daily_episode_records": completed_daily_episode_records.duplicate(true),
		"active_daily_episode": active_daily_episode.duplicate(true),
		"echo_fragments": echo_fragments,
		"granted_reward_ids": granted_reward_ids.duplicate(),
		"faction_relations": faction_relations.duplicate(true),
		"triggered_faction_event_ids": triggered_faction_event_ids.duplicate(),
		"completed_faction_request_ids": completed_faction_request_ids.duplicate(),
		"purchased_market_item_ids": purchased_market_item_ids.duplicate(),
		"consumable_inventory": consumable_inventory.duplicate(true),
		"consumable_loadout": consumable_loadout.duplicate(true),
		"active_consumable_effects": active_consumable_effects.duplicate(true),
		"rewarded_resolution_grades": rewarded_resolution_grades.duplicate(true)
	}


func _validate_validation_snapshot(snapshot: Dictionary) -> Dictionary:
	for key in VALIDATION_REQUIRED_KEYS:
		if not snapshot.has(key):
			return {"ok": false, "code": "INVALID_PAYLOAD", "field": key}
	for key in snapshot.keys():
		if not VALIDATION_REQUIRED_KEYS.has(String(key)):
			return {"ok": false, "code": "INVALID_PAYLOAD", "field": String(key)}

	if String(snapshot.get("episode_id", "")) != VALIDATION_EPISODE_ID:
		return {"ok": false, "code": "INVALID_EPISODE"}
	if String(snapshot.get("episode_path", "")) != DEFAULT_EPISODE_PATH:
		return {"ok": false, "code": "INCOMPATIBLE_CONTENT"}
	for key in ["scene_path", "dialogue_node_id", "field_node_id", "minigame_id"]:
		if typeof(snapshot.get(key)) != TYPE_STRING:
			return {"ok": false, "code": "INVALID_PAYLOAD", "field": key}
	for key in ["selected_agent_ids", "flags", "collected_clue_ids", "seen_hint_ids"]:
		if typeof(snapshot.get(key)) != TYPE_ARRAY:
			return {"ok": false, "code": "INVALID_PAYLOAD", "field": key}
	for key in ["method_results", "minigame_results", "resolution", "recovery", "agent_case_states", "victim_state"]:
		if typeof(snapshot.get(key)) != TYPE_DICTIONARY:
			return {"ok": false, "code": "INVALID_PAYLOAD", "field": key}

	var resolution := snapshot.get("resolution") as Dictionary
	if not resolution.has("grade") or not resolution.has("label") or not resolution.has("rate"):
		return {"ok": false, "code": "INVALID_PAYLOAD", "field": "resolution"}
	if typeof(resolution.get("grade")) != TYPE_STRING or typeof(resolution.get("label")) != TYPE_STRING or typeof(resolution.get("rate")) not in [TYPE_INT, TYPE_FLOAT]:
		return {"ok": false, "code": "INVALID_PAYLOAD", "field": "resolution"}

	var recovery := snapshot.get("recovery") as Dictionary
	for key in ["successful", "result_status", "stability", "current_pattern_id", "last_pattern_id", "confirmed_pattern_id", "seen_pattern_ids", "pattern_learning"]:
		if not recovery.has(key):
			return {"ok": false, "code": "INVALID_PAYLOAD", "field": "recovery.%s" % key}
	if typeof(recovery.get("successful")) != TYPE_BOOL or typeof(recovery.get("result_status")) != TYPE_STRING or typeof(recovery.get("stability")) not in [TYPE_INT, TYPE_FLOAT]:
		return {"ok": false, "code": "INVALID_PAYLOAD", "field": "recovery"}
	for key in ["current_pattern_id", "last_pattern_id", "confirmed_pattern_id"]:
		if typeof(recovery.get(key)) != TYPE_STRING:
			return {"ok": false, "code": "INVALID_PAYLOAD", "field": "recovery.%s" % key}
	if typeof(recovery.get("seen_pattern_ids")) != TYPE_ARRAY or typeof(recovery.get("pattern_learning")) != TYPE_DICTIONARY:
		return {"ok": false, "code": "INVALID_PAYLOAD", "field": "recovery"}
	return {"ok": true, "code": "OK"}


# Compatibility aliases retained for evidence readers from the approved design phase.
func capture_validation_hidden_state_guard() -> Dictionary:
	return snapshot_hidden_legacy_state_for_test()


func validation_hidden_state_matches(guard: Dictionary) -> bool:
	return _semantic_equal(snapshot_hidden_legacy_state_for_test(), guard)


func _semantic_equal(left: Variant, right: Variant) -> bool:
	var left_type := typeof(left)
	var right_type := typeof(right)
	if left_type in [TYPE_INT, TYPE_FLOAT] and right_type in [TYPE_INT, TYPE_FLOAT]:
		return is_equal_approx(float(left), float(right))
	if left_type == TYPE_DICTIONARY and right_type == TYPE_DICTIONARY:
		var left_dict := left as Dictionary
		var right_dict := right as Dictionary
		if left_dict.size() != right_dict.size():
			return false
		for key in left_dict.keys():
			if not right_dict.has(key) or not _semantic_equal(left_dict[key], right_dict[key]):
				return false
		return true
	if left_type == TYPE_ARRAY and right_type == TYPE_ARRAY:
		var left_array := left as Array
		var right_array := right as Array
		if left_array.size() != right_array.size():
			return false
		for index in range(left_array.size()):
			if not _semantic_equal(left_array[index], right_array[index]):
				return false
		return true
	return left == right
