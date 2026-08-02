extends "res://scripts/core/game_state.gd"

const VALIDATION_RUNTIME_KEYS := [
	"episode_path",
	"current_scene_path",
	"current_dialogue_node_id",
	"current_field_node_id",
	"current_minigame_id",
	"selected_agent_ids",
	"flags",
	"seen_hint_ids",
	"seen_log_tutorial_ids",
	"minigame_results",
	"method_results",
	"investigation_risk",
	"case_understanding",
	"victim_understanding",
	"case_anomaly_stability",
	"mental_stamina",
	"prediction_success_streak",
	"prediction_failure_streak",
	"current_recovery_pattern_id",
	"last_recovery_pattern_id",
	"confirmed_recovery_pattern_id",
	"seen_recovery_pattern_ids",
	"recovery_pattern_learning",
	"last_random_event_id",
	"last_random_event_result",
	"forced_recovery_phase",
	"collected_clue_ids",
	"selected_resolution_grade",
	"selected_resolution_label",
	"selected_resolution_rate",
	"recovery_successful",
	"recovery_result_status",
	"recovery_result_stability",
	"agent_case_states",
	"victim_state"
]


func save_game() -> bool:
	var session = get_node_or_null("/root/ValidationSession")
	if session != null and session.has_method("is_routing_to_validation") and bool(session.is_routing_to_validation()):
		if not session.has_method("is_active_contract_valid") or not bool(session.is_active_contract_valid()):
			return false
		if not session.has_method("save_active_session"):
			return false
		var result: Dictionary = session.save_active_session(self)
		return bool(result.get("ok", false))
	return super.save_game()


func export_validation_runtime_snapshot() -> Dictionary:
	return {
		"episode_path": current_episode_path,
		"current_scene_path": current_scene_path,
		"current_dialogue_node_id": current_dialogue_node_id,
		"current_field_node_id": current_field_node_id,
		"current_minigame_id": current_minigame_id,
		"selected_agent_ids": selected_agent_ids.duplicate(),
		"flags": flags.duplicate(),
		"seen_hint_ids": seen_hint_ids.duplicate(),
		"seen_log_tutorial_ids": seen_log_tutorial_ids.duplicate(),
		"minigame_results": minigame_results.duplicate(true),
		"method_results": method_results.duplicate(true),
		"investigation_risk": investigation_risk,
		"case_understanding": case_understanding,
		"victim_understanding": victim_understanding,
		"case_anomaly_stability": case_anomaly_stability,
		"mental_stamina": mental_stamina,
		"prediction_success_streak": prediction_success_streak,
		"prediction_failure_streak": prediction_failure_streak,
		"current_recovery_pattern_id": current_recovery_pattern_id,
		"last_recovery_pattern_id": last_recovery_pattern_id,
		"confirmed_recovery_pattern_id": confirmed_recovery_pattern_id,
		"seen_recovery_pattern_ids": seen_recovery_pattern_ids.duplicate(),
		"recovery_pattern_learning": recovery_pattern_learning.duplicate(true),
		"last_random_event_id": last_random_event_id,
		"last_random_event_result": last_random_event_result.duplicate(true),
		"forced_recovery_phase": forced_recovery_phase,
		"collected_clue_ids": get_collected_clue_ids(),
		"selected_resolution_grade": selected_resolution_grade,
		"selected_resolution_label": selected_resolution_label,
		"selected_resolution_rate": selected_resolution_rate,
		"recovery_successful": recovery_successful,
		"recovery_result_status": recovery_result_status,
		"recovery_result_stability": recovery_result_stability,
		"agent_case_states": agent_case_states.duplicate(true),
		"victim_state": victim_state.duplicate(true)
	}


func restore_validation_runtime_snapshot(snapshot: Dictionary) -> Dictionary:
	var validation := _validate_validation_snapshot(snapshot)
	if not bool(validation.get("ok", false)):
		return validation

	var episode_path := String(snapshot.get("episode_path", current_episode_path))
	if episode_path != current_episode_path and not episode_path.is_empty():
		if not load_episode(episode_path):
			return {"ok": false, "code": "EPISODE_LOAD_FAILED"}

	current_scene_path = String(snapshot.get("current_scene_path", current_scene_path))
	current_dialogue_node_id = String(snapshot.get("current_dialogue_node_id", current_dialogue_node_id))
	current_field_node_id = String(snapshot.get("current_field_node_id", current_field_node_id))
	current_minigame_id = String(snapshot.get("current_minigame_id", current_minigame_id))
	selected_agent_ids = _validation_array(snapshot.get("selected_agent_ids", selected_agent_ids))
	flags = _validation_array(snapshot.get("flags", flags))
	seen_hint_ids = _validation_array(snapshot.get("seen_hint_ids", seen_hint_ids))
	seen_log_tutorial_ids = _validation_array(snapshot.get("seen_log_tutorial_ids", seen_log_tutorial_ids))
	minigame_results = _validation_dictionary(snapshot.get("minigame_results", minigame_results))
	method_results = _validation_dictionary(snapshot.get("method_results", method_results))
	investigation_risk = clampi(int(snapshot.get("investigation_risk", investigation_risk)), 0, 100)
	case_understanding = clampi(int(snapshot.get("case_understanding", case_understanding)), 0, 100)
	victim_understanding = clampi(int(snapshot.get("victim_understanding", victim_understanding)), 0, 100)
	case_anomaly_stability = clampi(int(snapshot.get("case_anomaly_stability", case_anomaly_stability)), 0, 100)
	mental_stamina = clampi(int(snapshot.get("mental_stamina", mental_stamina)), 0, 100)
	prediction_success_streak = maxi(0, int(snapshot.get("prediction_success_streak", prediction_success_streak)))
	prediction_failure_streak = maxi(0, int(snapshot.get("prediction_failure_streak", prediction_failure_streak)))
	current_recovery_pattern_id = String(snapshot.get("current_recovery_pattern_id", current_recovery_pattern_id))
	last_recovery_pattern_id = String(snapshot.get("last_recovery_pattern_id", last_recovery_pattern_id))
	confirmed_recovery_pattern_id = String(snapshot.get("confirmed_recovery_pattern_id", confirmed_recovery_pattern_id))
	seen_recovery_pattern_ids = _validation_array(snapshot.get("seen_recovery_pattern_ids", seen_recovery_pattern_ids))
	recovery_pattern_learning = _validation_dictionary(snapshot.get("recovery_pattern_learning", recovery_pattern_learning))
	last_random_event_id = String(snapshot.get("last_random_event_id", last_random_event_id))
	last_random_event_result = _validation_dictionary(snapshot.get("last_random_event_result", last_random_event_result))
	forced_recovery_phase = bool(snapshot.get("forced_recovery_phase", forced_recovery_phase))
	_apply_collected_clue_ids(_validation_array(snapshot.get("collected_clue_ids", get_collected_clue_ids())))
	selected_resolution_grade = String(snapshot.get("selected_resolution_grade", selected_resolution_grade))
	selected_resolution_label = String(snapshot.get("selected_resolution_label", selected_resolution_label))
	selected_resolution_rate = float(snapshot.get("selected_resolution_rate", selected_resolution_rate))
	recovery_successful = bool(snapshot.get("recovery_successful", recovery_successful))
	recovery_result_status = String(snapshot.get("recovery_result_status", recovery_result_status))
	recovery_result_stability = clampi(int(snapshot.get("recovery_result_stability", recovery_result_stability)), 0, 100)
	agent_case_states = _validation_dictionary(snapshot.get("agent_case_states", agent_case_states))
	victim_state = _validation_dictionary(snapshot.get("victim_state", victim_state))
	return {"ok": true, "code": "OK"}


func capture_validation_hidden_state_guard() -> Dictionary:
	return {
		"campaign_state": campaign_state.to_save_data(),
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


func validation_hidden_state_matches(guard: Dictionary) -> bool:
	return _validation_semantic_equal(capture_validation_hidden_state_guard(), guard)


func _validate_validation_snapshot(snapshot: Dictionary) -> Dictionary:
	for key in snapshot.keys():
		if not VALIDATION_RUNTIME_KEYS.has(String(key)):
			return {"ok": false, "code": "UNSUPPORTED_SNAPSHOT_KEY", "key": String(key)}
	for key in ["selected_agent_ids", "flags", "seen_hint_ids", "seen_log_tutorial_ids", "seen_recovery_pattern_ids", "collected_clue_ids"]:
		if snapshot.has(key) and typeof(snapshot[key]) != TYPE_ARRAY:
			return {"ok": false, "code": "INVALID_ARRAY_FIELD", "key": key}
	for key in ["minigame_results", "method_results", "recovery_pattern_learning", "last_random_event_result", "agent_case_states", "victim_state"]:
		if snapshot.has(key) and typeof(snapshot[key]) != TYPE_DICTIONARY:
			return {"ok": false, "code": "INVALID_DICTIONARY_FIELD", "key": key}
	return {"ok": true, "code": "OK"}


func _validation_array(value: Variant) -> Array:
	return (value as Array).duplicate(true) if typeof(value) == TYPE_ARRAY else []


func _validation_dictionary(value: Variant) -> Dictionary:
	return (value as Dictionary).duplicate(true) if typeof(value) == TYPE_DICTIONARY else {}


func _validation_semantic_equal(left: Variant, right: Variant) -> bool:
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
			if not right_dict.has(key) or not _validation_semantic_equal(left_dict[key], right_dict[key]):
				return false
		return true
	if left_type == TYPE_ARRAY and right_type == TYPE_ARRAY:
		var left_array := left as Array
		var right_array := right as Array
		if left_array.size() != right_array.size():
			return false
		for index in range(left_array.size()):
			if not _validation_semantic_equal(left_array[index], right_array[index]):
				return false
		return true
	return left == right
