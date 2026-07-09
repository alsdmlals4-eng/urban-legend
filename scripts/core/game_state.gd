# 현재 사건 데이터, 플래그, 조건, 저장 상태를 관리한다.
extends Node

const DEFAULT_EPISODE_PATH := "res://data/episodes/episode_001_afterlife_station.json"
const SAVE_FILE_PATH := "user://urban_legend_save.json"
const SAVE_VERSION := "mvp-011"
const DEFAULT_DIALOGUE_NODE_ID := "dialogue_intro"
const DEFAULT_MINIGAME_ID := "minigame_frequency_sync"
const SCENE_MAIN_MENU := "res://scenes/main_menu.tscn"
const SCENE_DIALOGUE := "res://scenes/dialogue_scene.tscn"
const SCENE_INVESTIGATION := "res://scenes/investigation_scene.tscn"
const SCENE_BATTLE := "res://scenes/battle_scene.tscn"
const SCENE_RESULT := "res://scenes/result_scene.tscn"
const FLAG_CAPTURE_SUCCESS := "capture_success"
const MIN_SELECTED_AGENTS := 2
const MAX_SELECTED_AGENTS := 3
const ALLOWED_AGENT_TEMPERAMENTS := ["analytical", "empathetic", "breakthrough"]
const INVESTIGATION_METHOD_KEYS := ["destruction", "observation", "analysis"]
const EpisodeLoaderScript := preload("res://scripts/data/episode_loader.gd")
const CaseDataScript := preload("res://scripts/data/case_data.gd")

var current_episode_path := DEFAULT_EPISODE_PATH
var current_episode_data: Dictionary = {}
var current_scene_path := SCENE_MAIN_MENU
var current_dialogue_node_id := DEFAULT_DIALOGUE_NODE_ID
var current_minigame_id := DEFAULT_MINIGAME_ID
var minigame_results: Dictionary = {}
var selected_agent_ids: Array = []
var flags: Array = []
var seen_hint_ids: Array = []
var selected_resolution_grade := ""
var selected_resolution_label := ""
var selected_resolution_rate := 0.0
var recovery_successful := false
var recovery_result_status := ""
var recovery_result_stability := 100
var investigation_risk := 0
var case_understanding := 0
var victim_understanding := 0
var case_anomaly_stability := 100
var method_results: Dictionary = {}
var agent_trust_changes: Dictionary = {}
var used_agent_supports: Array = []


func _ready() -> void:
	load_episode(DEFAULT_EPISODE_PATH)


## Loads an episode JSON file as the active case.
func load_episode(file_path: String = DEFAULT_EPISODE_PATH) -> bool:
	var loader = EpisodeLoaderScript.new()
	var loaded_data: Dictionary = loader.load_episode(file_path)
	if loaded_data.is_empty():
		return false

	current_episode_path = file_path
	current_episode_data = CaseDataScript.refresh_resolution_progress(loaded_data)
	_clear_resolution_phase_selection()
	_clear_recovery_result()
	return true


## Returns the active episode Dictionary.
func get_current_episode() -> Dictionary:
	return current_episode_data


## Restarts the afterlife station MVP from the beginning.
func restart_afterlife_station_flow(agent_ids: Array = []) -> bool:
	reset_run_state()
	set_selected_agent_ids(agent_ids)
	current_scene_path = SCENE_DIALOGUE
	return not current_episode_data.is_empty()


## Clears the current run state and reloads the default episode.
func reset_run_state() -> void:
	flags.clear()
	seen_hint_ids.clear()
	minigame_results.clear()
	selected_agent_ids.clear()
	_clear_investigation_method_state()
	current_scene_path = SCENE_DIALOGUE
	current_dialogue_node_id = DEFAULT_DIALOGUE_NODE_ID
	current_minigame_id = DEFAULT_MINIGAME_ID
	load_episode(DEFAULT_EPISODE_PATH)


## Returns the active episode title.
func get_current_episode_title() -> String:
	var episode: Dictionary = current_episode_data.get("episode", {})
	return String(episode.get("title", "저승역"))


## Returns the active episode id.
func get_current_episode_id() -> String:
	var episode: Dictionary = current_episode_data.get("episode", {})
	return String(episode.get("id", ""))


## Stores the scene path that should be used by Continue.
func set_current_scene_path(scene_path: String) -> void:
	if scene_path.strip_edges().is_empty():
		return

	current_scene_path = scene_path


## Returns the saved or current scene path.
func get_current_scene_path() -> String:
	if current_scene_path.strip_edges().is_empty():
		return SCENE_DIALOGUE
	return current_scene_path


## Stores the current dialogue node for Continue and save data.
func set_current_dialogue_node_id(dialogue_node_id: String) -> void:
	var clean_id := dialogue_node_id.strip_edges()
	if clean_id.is_empty():
		return

	current_dialogue_node_id = clean_id


## Returns the current dialogue node id.
func get_current_dialogue_node_id() -> String:
	if current_dialogue_node_id.strip_edges().is_empty():
		return DEFAULT_DIALOGUE_NODE_ID
	return current_dialogue_node_id


## Stores the current minigame id for minigame scene loading.
func set_current_minigame_id(minigame_id: String) -> void:
	var clean_id := minigame_id.strip_edges()
	if clean_id.is_empty():
		return

	current_minigame_id = clean_id


## Returns the current minigame id.
func get_current_minigame_id() -> String:
	if current_minigame_id.strip_edges().is_empty():
		return DEFAULT_MINIGAME_ID
	return current_minigame_id


## Adds one run flag if it is not already present.
func add_flag(flag_id: String) -> void:
	var clean_flag := flag_id.strip_edges()
	if clean_flag.is_empty() or flags.has(clean_flag):
		return

	flags.append(clean_flag)


## Removes one run flag.
func remove_flag(flag_id: String) -> void:
	flags.erase(flag_id)


## Returns true when one flag is present.
func has_flag(flag_id: String) -> bool:
	return flags.has(flag_id)


## Returns true when every supplied flag is present.
func has_all_flags(flag_ids: Array) -> bool:
	for flag_id in flag_ids:
		if not has_flag(String(flag_id)):
			return false
	return true


## Returns true when at least one supplied flag is present.
func has_any_flag(flag_ids: Array) -> bool:
	for flag_id in flag_ids:
		if has_flag(String(flag_id)):
			return true
	return false


## Returns a copy of current flags.
func get_flags() -> Array:
	return flags.duplicate()


## Clears every run flag.
func clear_flags() -> void:
	flags.clear()


## Marks one hint as seen for save data.
func mark_hint_seen(hint_id: String) -> void:
	var clean_hint_id := hint_id.strip_edges()
	if clean_hint_id.is_empty() or seen_hint_ids.has(clean_hint_id):
		return

	seen_hint_ids.append(clean_hint_id)
	save_game()


## Returns true when a hint has been seen.
func has_seen_hint(hint_id: String) -> bool:
	return seen_hint_ids.has(hint_id)


## Returns a copy of seen hint ids.
func get_seen_hint_ids() -> Array:
	return seen_hint_ids.duplicate()


## Clears every seen hint id.
func clear_seen_hint_ids() -> void:
	seen_hint_ids.clear()


## Checks simple flag, clue, resolution, and capture conditions.
func check_conditions(conditions: Dictionary) -> bool:
	if conditions.is_empty():
		return true

	if not has_all_flags(_to_string_array(conditions.get("required_flags", []))):
		return false

	if has_any_flag(_to_string_array(conditions.get("blocked_flags", []))):
		return false

	for clue_id in _to_string_array(conditions.get("required_clues", [])):
		if not has_collected_clue(clue_id):
			return false

	if conditions.has("min_clue_collection_rate"):
		if get_clue_collection_rate() < float(conditions.get("min_clue_collection_rate", 0.0)):
			return false

	if conditions.has("required_resolution_grade"):
		var required_grade := String(conditions.get("required_resolution_grade", ""))
		if _get_resolution_rank(get_result_resolution_grade()) < _get_resolution_rank(required_grade):
			return false

	if conditions.has("capture_success"):
		if recovery_successful != bool(conditions.get("capture_success", false)):
			return false

	return true


## Applies branch result data from dialogue choices or investigation points.
func apply_story_effects(result_data: Dictionary) -> void:
	for flag_id in _to_string_array(result_data.get("add_flags", [])):
		add_flag(flag_id)

	for flag_id in _to_string_array(result_data.get("remove_flags", [])):
		remove_flag(flag_id)

	var clue_ids := _to_string_array(result_data.get("collect_clues", []))
	var direct_clue_id := String(result_data.get("clue_id", "")).strip_edges()
	if not direct_clue_id.is_empty() and not clue_ids.has(direct_clue_id):
		clue_ids.append(direct_clue_id)

	for clue_id in clue_ids:
		collect_clue(clue_id)

	for hint_id in _to_string_array(result_data.get("show_hint_ids", [])):
		mark_hint_seen(hint_id)

	var minigame_id := String(result_data.get("start_minigame_id", result_data.get("minigame_id", ""))).strip_edges()
	if not minigame_id.is_empty():
		set_current_minigame_id(minigame_id)

	save_game()


## Applies a minigame success or failure result and stores it for save/load.
func save_minigame_result(minigame_id: String, successful: bool) -> void:
	var minigame := get_minigame(minigame_id)
	if minigame.is_empty():
		return

	var result_state := "success" if successful else "failure"
	var result_text_key := "success_result_text" if successful else "failure_result_text"
	var result_text := String(minigame.get(result_text_key, ""))
	var opposite_flags: Variant = minigame.get("failure_flags", []) if successful else minigame.get("success_flags", [])
	for flag_id in _to_string_array(opposite_flags):
		remove_flag(flag_id)

	minigame_results[minigame_id] = {
		"successful": successful,
		"result_state": result_state,
		"result_text": result_text,
		"last_updated_at": Time.get_datetime_string_from_system(false, true)
	}

	apply_story_effects(_make_minigame_effect_data(minigame, successful))
	save_game()


## Returns true when a minigame was completed successfully.
func has_minigame_success(minigame_id: String) -> bool:
	var result: Dictionary = minigame_results.get(minigame_id, {})
	return bool(result.get("successful", false))


## Returns true when a minigame was completed with failure.
func has_minigame_failure(minigame_id: String) -> bool:
	var result: Dictionary = minigame_results.get(minigame_id, {})
	return not result.is_empty() and not bool(result.get("successful", false))


## Returns the saved result for one minigame.
func get_minigame_result(minigame_id: String) -> Dictionary:
	var result: Variant = minigame_results.get(minigame_id, {})
	if typeof(result) == TYPE_DICTIONARY:
		return result
	return {}


## Returns all saved minigame results.
func get_minigame_results() -> Dictionary:
	return minigame_results.duplicate(true)


## Returns display text for hint ids stored in branch result data.
func get_hint_texts_by_ids(hint_ids: Array) -> Array:
	var texts: Array = []
	for hint_id in _to_string_array(hint_ids):
		var hint := get_hint_by_id(hint_id)
		if hint.is_empty():
			continue

		texts.append("%s: %s" % [
			String(hint.get("target_clue_id", "")),
			String(hint.get("text", ""))
		])
	return texts


## Marks one clue as collected and updates the resolution state.
func collect_clue(clue_id: String) -> bool:
	if current_episode_data.is_empty():
		return false

	var before_count := CaseDataScript.get_collected_clue_count(current_episode_data)
	_set_clue_collected_without_save(clue_id, true)
	var collected_now := CaseDataScript.get_collected_clue_count(current_episode_data) > before_count
	if collected_now:
		save_game()
	return collected_now


## Sets one clue collected state for tests and simple UI prototypes.
func set_clue_collected(clue_id: String, collected: bool) -> bool:
	if current_episode_data.is_empty():
		return false

	_set_clue_collected_without_save(clue_id, collected)
	save_game()
	return true


## Resets all clue collection states in the active episode.
func reset_clue_collection() -> void:
	if current_episode_data.is_empty():
		return

	current_episode_data = CaseDataScript.reset_clue_collection(current_episode_data)
	_clear_resolution_phase_selection()
	_clear_recovery_result()
	save_game()


## Returns active victim records.
func get_victims() -> Array:
	return CaseDataScript.get_victims(current_episode_data)


## Returns recruitable agent records.
func get_agents() -> Array:
	return CaseDataScript.get_agents(current_episode_data)


## Returns one recruitable agent by id.
func get_agent_by_id(agent_id: String) -> Dictionary:
	return CaseDataScript.get_agent_by_id(current_episode_data, agent_id)


## Returns the player's base investigation stats.
func get_player_investigation_stats() -> Dictionary:
	var stats: Variant = current_episode_data.get("player_investigation_stats", {})
	if typeof(stats) == TYPE_DICTIONARY:
		return stats.duplicate(true)
	return {
		"destruction": 2,
		"observation": 2,
		"analysis": 2
	}


## Returns one agent's investigation stat value.
func get_agent_investigation_stat(agent_id: String, stat_key: String) -> int:
	var agent := get_agent_by_id(agent_id)
	if agent.is_empty():
		return 0

	var stats := _to_dictionary(agent.get("investigation_stats", {}))
	return int(stats.get(stat_key, 0))


## Selects one agent for the current mission formation.
func select_agent(agent_id: String) -> bool:
	var clean_agent_id := agent_id.strip_edges()
	if clean_agent_id.is_empty():
		return false
	if selected_agent_ids.has(clean_agent_id):
		return true
	if selected_agent_ids.size() >= MAX_SELECTED_AGENTS:
		return false

	var agent := get_agent_by_id(clean_agent_id)
	if agent.is_empty() or not _is_allowed_agent_temperament(agent):
		return false

	selected_agent_ids.append(clean_agent_id)
	return true


## Removes one agent from the current mission formation.
func deselect_agent(agent_id: String) -> void:
	selected_agent_ids.erase(agent_id)


## Replaces the current formation with valid agent ids.
func set_selected_agent_ids(agent_ids: Array) -> void:
	selected_agent_ids.clear()
	for agent_id in _to_string_array(agent_ids):
		if selected_agent_ids.size() >= MAX_SELECTED_AGENTS:
			break
		select_agent(agent_id)


## Clears the current mission formation.
func clear_selected_agents() -> void:
	selected_agent_ids.clear()


## Returns true when the agent is currently selected.
func is_agent_selected(agent_id: String) -> bool:
	return selected_agent_ids.has(agent_id)


## Returns selected agent ids for save data.
func get_selected_agent_ids() -> Array:
	return selected_agent_ids.duplicate()


## Returns selected agent records only.
func get_selected_agents() -> Array:
	var selected_agents: Array = []
	for agent_id in selected_agent_ids:
		var agent := get_agent_by_id(String(agent_id))
		if not agent.is_empty():
			selected_agents.append(agent)
	return selected_agents


## Returns true when the current formation can start a mission.
func can_start_mission_with_agents() -> bool:
	return selected_agent_ids.size() >= MIN_SELECTED_AGENTS and selected_agent_ids.size() <= MAX_SELECTED_AGENTS


## Returns a short Korean status text for the current formation.
func get_agent_selection_status_text() -> String:
	var count := selected_agent_ids.size()
	if count < MIN_SELECTED_AGENTS:
		return "요원 %d명을 더 선택해야 임무를 시작할 수 있습니다." % (MIN_SELECTED_AGENTS - count)
	if count > MAX_SELECTED_AGENTS:
		return "요원은 최대 %d명까지만 편성할 수 있습니다." % MAX_SELECTED_AGENTS
	return "임무 시작 가능: 요원 %d명 편성됨" % count


## Returns readable selected agent names and temperaments.
func get_selected_agent_summary() -> String:
	var names: Array = []
	for agent in get_selected_agents():
		names.append("%s(%s)" % [
			String(agent.get("name", "")),
			String(agent.get("temperament_label", ""))
		])
	if names.is_empty():
		return "선택 요원 없음"
	return ", ".join(names)


## Returns selected agents' dialogue reactions whose conditions are met.
func get_selected_agent_reactions() -> Array:
	var visible_reactions: Array = []
	for reaction in CaseDataScript.get_agent_reactions(current_episode_data):
		if typeof(reaction) != TYPE_DICTIONARY:
			continue

		var agent_id := String(reaction.get("agent_id", ""))
		if not selected_agent_ids.has(agent_id):
			continue

		var conditions := _to_dictionary(reaction.get("conditions", {}))
		if not check_conditions(conditions):
			continue

		var agent := get_agent_by_id(agent_id)
		if agent.is_empty():
			continue

		var entry: Dictionary = reaction.duplicate(true)
		entry["agent_name"] = String(agent.get("name", agent_id))
		entry["temperament_label"] = String(agent.get("temperament_label", ""))
		visible_reactions.append(entry)
	return visible_reactions


## Returns recovery support records for selected agents only.
func get_selected_recovery_supports() -> Array:
	var supports: Array = []
	for agent in get_selected_agents():
		var support := _to_dictionary(agent.get("recovery_support", {}))
		if support.is_empty():
			continue

		var support_id := String(support.get("id", "support_%s" % String(agent.get("id", "")))).strip_edges()
		if support_id.is_empty():
			continue

		var entry := support.duplicate(true)
		entry["id"] = support_id
		entry["agent_id"] = String(agent.get("id", ""))
		entry["agent_name"] = String(agent.get("name", ""))
		entry["temperament"] = String(agent.get("temperament", ""))
		entry["temperament_label"] = String(agent.get("temperament_label", ""))
		supports.append(entry)
	return supports


## Returns true when an agent recovery support has already been used.
func has_used_agent_support(support_id: String) -> bool:
	return used_agent_supports.has(support_id)


## Marks an agent recovery support as used once.
func mark_agent_support_used(support_id: String) -> void:
	var clean_support_id := support_id.strip_edges()
	if clean_support_id.is_empty() or used_agent_supports.has(clean_support_id):
		return

	used_agent_supports.append(clean_support_id)
	save_game()


## Returns used recovery support ids for save data.
func get_used_agent_supports() -> Array:
	return used_agent_supports.duplicate()


## Returns the current investigation partner trust delta for one agent.
func get_agent_trust_delta(agent_id: String) -> int:
	return int(agent_trust_changes.get(agent_id, 0))


## Returns all investigation partner trust deltas.
func get_agent_trust_changes() -> Dictionary:
	return agent_trust_changes.duplicate(true)


## Returns active hint records. Hints are separate from clues.
func get_hints() -> Array:
	return CaseDataScript.get_hints(current_episode_data)


## Returns one hint by id.
func get_hint_by_id(hint_id: String) -> Dictionary:
	return CaseDataScript.get_hint_by_id(current_episode_data, hint_id)


## Returns hints whose condition flags are currently satisfied.
func get_available_hints() -> Array:
	var available_hints: Array = []
	for hint in get_hints():
		if typeof(hint) != TYPE_DICTIONARY:
			continue

		var condition_flags := _to_string_array(hint.get("condition_flags", []))
		if check_conditions({"required_flags": condition_flags}):
			available_hints.append(hint)
	return available_hints


## Returns dialogue nodes defined in the active episode data.
func get_dialogue_nodes() -> Array:
	return CaseDataScript.get_dialogue_nodes(current_episode_data)


## Returns one dialogue node by id.
func get_dialogue_node(dialogue_node_id: String) -> Dictionary:
	return CaseDataScript.get_dialogue_node_by_id(current_episode_data, dialogue_node_id)


## Returns the current dialogue node, falling back to the first node.
func get_current_dialogue_node() -> Dictionary:
	var node := get_dialogue_node(get_current_dialogue_node_id())
	if not node.is_empty():
		return node

	var nodes := get_dialogue_nodes()
	if nodes.is_empty() or typeof(nodes[0]) != TYPE_DICTIONARY:
		return {}

	var first_node: Dictionary = nodes[0]
	set_current_dialogue_node_id(String(first_node.get("id", DEFAULT_DIALOGUE_NODE_ID)))
	return first_node


## Returns investigation points defined in the active episode data.
func get_investigation_points() -> Array:
	return CaseDataScript.get_investigation_points(current_episode_data)


## Returns one investigation point by id.
func get_investigation_point_by_id(point_id: String) -> Dictionary:
	return CaseDataScript.get_investigation_point_by_id(current_episode_data, point_id)


## Resolves one investigation method with player stat, selected helper stat, and 1d6.
func resolve_investigation_method(point_id: String, method: Dictionary) -> Dictionary:
	var stat_key := String(method.get("stat_key", method.get("method_type", ""))).strip_edges()
	if not INVESTIGATION_METHOD_KEYS.has(stat_key):
		return {
			"successful": false,
			"error": "지원하지 않는 조사 방법입니다: %s" % stat_key
		}

	var player_stats := get_player_investigation_stats()
	var player_stat := int(player_stats.get(stat_key, 0))
	var helper_agent := _find_best_selected_agent_for_stat(stat_key)
	var helper_agent_id := String(helper_agent.get("id", ""))
	var helper_stat := get_agent_investigation_stat(helper_agent_id, stat_key) if not helper_agent_id.is_empty() else 0
	var dice := randi_range(1, 6)
	var total := player_stat + helper_stat + dice
	var difficulty := int(method.get("difficulty", 0))
	var successful := total >= difficulty
	var effects := _to_dictionary(method.get("success_effects", {})) if successful else _to_dictionary(method.get("failure_effects", {}))
	var before_clue_ids := get_collected_clue_ids()

	apply_story_effects(effects)
	_apply_method_status_deltas(effects)
	var trust_changes := _apply_method_trust_rules(method, successful, helper_agent_id)
	var new_clue_ids := _get_new_string_ids(before_clue_ids, get_collected_clue_ids())
	var method_result := {
		"point_id": point_id,
		"method_id": String(method.get("id", "")),
		"method_label": String(method.get("label", "조사 방법")),
		"method_type": String(method.get("method_type", stat_key)),
		"stat_key": stat_key,
		"difficulty": difficulty,
		"player_stat": player_stat,
		"helper_agent_id": helper_agent_id,
		"helper_agent_name": String(helper_agent.get("name", "도우미 없음")),
		"helper_temperament_label": String(helper_agent.get("temperament_label", "")),
		"helper_stat": helper_stat,
		"dice": dice,
		"total": total,
		"successful": successful,
		"result_text": String(method.get("success_text", "")) if successful else String(method.get("failure_text", "")),
		"effect_data": effects,
		"new_clue_ids": new_clue_ids,
		"requested_clue_ids": _to_string_array(effects.get("collect_clues", [])),
		"hint_texts": get_hint_texts_by_ids(effects.get("show_hint_ids", [])),
		"trust_changes": trust_changes,
		"case_status": get_case_status_summary(),
		"last_updated_at": Time.get_datetime_string_from_system(false, true)
	}

	method_results[point_id] = method_result
	save_game()
	return method_result


## Returns saved investigation method results.
func get_method_results() -> Dictionary:
	return method_results.duplicate(true)


## Returns one saved method result by investigation point id.
func get_method_result(point_id: String) -> Dictionary:
	var result: Variant = method_results.get(point_id, {})
	if typeof(result) == TYPE_DICTIONARY:
		return result.duplicate(true)
	return {}


## Returns current investigation risk.
func get_investigation_risk() -> int:
	return investigation_risk


## Returns current case understanding.
func get_case_understanding() -> int:
	return case_understanding


## Returns current victim understanding.
func get_victim_understanding() -> int:
	return victim_understanding


## Returns current anomaly stability carried from investigation.
func get_case_anomaly_stability() -> int:
	return case_anomaly_stability


## Returns a compact summary of investigation status values.
func get_case_status_summary() -> Dictionary:
	return {
		"investigation_risk": investigation_risk,
		"case_understanding": case_understanding,
		"victim_understanding": victim_understanding,
		"anomaly_stability": case_anomaly_stability
	}


## Returns minigames defined in the active episode data.
func get_minigames() -> Array:
	return CaseDataScript.get_minigames(current_episode_data)


## Returns one minigame by id.
func get_minigame(minigame_id: String) -> Dictionary:
	return CaseDataScript.get_minigame_by_id(current_episode_data, minigame_id)


## Returns the current minigame, falling back to the first minigame.
func get_current_minigame() -> Dictionary:
	var minigame := get_minigame(get_current_minigame_id())
	if not minigame.is_empty():
		return minigame

	var minigames := get_minigames()
	if minigames.is_empty() or typeof(minigames[0]) != TYPE_DICTIONARY:
		return {}

	var first_minigame: Dictionary = minigames[0]
	set_current_minigame_id(String(first_minigame.get("id", DEFAULT_MINIGAME_ID)))
	return first_minigame


## Returns active clue records.
func get_clues() -> Array:
	return CaseDataScript.get_clues(current_episode_data)


## Returns only collected clues. Hints are intentionally excluded.
func get_collected_clues() -> Array:
	var collected_clues: Array = []
	for clue in get_clues():
		if typeof(clue) == TYPE_DICTIONARY and bool(clue.get("collected", false)):
			collected_clues.append(clue)
	return collected_clues


## Returns collected clue ids for save data and condition checks.
func get_collected_clue_ids() -> Array:
	var clue_ids: Array = []
	for clue in get_collected_clues():
		clue_ids.append(String(clue.get("id", "")))
	return clue_ids


## Returns true when one clue has been collected.
func has_collected_clue(clue_id: String) -> bool:
	return get_collected_clue_ids().has(clue_id)


## Returns collected clue count for the active episode.
func get_collected_clue_count() -> int:
	return CaseDataScript.get_collected_clue_count(current_episode_data)


## Returns total clue count for the active episode.
func get_total_clue_count() -> int:
	return CaseDataScript.get_total_clue_count(current_episode_data)


## Returns current clue collection rate as a 0 to 100 percentage.
func get_clue_collection_rate() -> float:
	return CaseDataScript.get_collection_rate(current_episode_data)


## Returns current resolution grade key.
func get_resolution_grade() -> String:
	return CaseDataScript.get_resolution_grade(current_episode_data)


## Returns current resolution grade display label.
func get_resolution_label() -> String:
	return CaseDataScript.get_resolution_label(current_episode_data)


## Returns the battle auto-effect linked to one clue.
func get_battle_effect_for_clue(clue_id: String) -> Dictionary:
	return CaseDataScript.get_battle_effect_for_clue(current_episode_data, clue_id)


## Returns battle effects for collected clues only. Hints and uncollected clues are excluded.
func get_collected_battle_effects() -> Array:
	var effects: Array = []
	for clue in get_collected_clues():
		var clue_id := String(clue.get("id", ""))
		var effect := get_battle_effect_for_clue(clue_id)
		if effect.is_empty():
			continue

		var effect_entry := effect.duplicate(true)
		effect_entry["clue_title"] = String(clue.get("title", ""))
		effects.append(effect_entry)
	return effects


## Returns the research reward for the current resolution grade.
func get_current_research_reward() -> Dictionary:
	return CaseDataScript.get_research_reward_for_grade(current_episode_data, get_resolution_grade())


## Returns true when the current clue rate allows entering the resolution phase.
func can_enter_resolution_phase() -> bool:
	return get_resolution_grade() != "unavailable"


## Returns a warning message for the current resolution grade.
func get_resolution_phase_warning() -> String:
	var grade := get_resolution_grade()
	match grade:
		"temporary":
			return "단서가 부족해 피해자에게 후유증이 남을 수 있고, 회수 난이도가 높습니다."
		"standard":
			return "충분한 단서를 확보했습니다. 피해자 구조와 괴이 회수를 안정적으로 시도할 수 있습니다."
		"complete":
			return "모든 핵심 단서를 확보했습니다. 피해자 구조, 진상 기록, 특수 연구 보상을 노릴 수 있습니다."
		_:
			return "아직 괴이의 핵에 접근할 근거가 부족합니다. 단서를 더 수집해야 합니다."


## Stores the current resolution grade before moving to the battle scene.
func start_resolution_phase() -> bool:
	if not can_enter_resolution_phase():
		return false

	selected_resolution_grade = get_resolution_grade()
	selected_resolution_label = get_resolution_label()
	selected_resolution_rate = get_clue_collection_rate()
	_clear_recovery_result()
	add_flag("resolution_phase_started")
	save_game()
	return true


## Returns the saved resolution grade key from the latest resolution attempt.
func get_selected_resolution_grade() -> String:
	return selected_resolution_grade


## Returns the saved resolution grade label from the latest resolution attempt.
func get_selected_resolution_label() -> String:
	return selected_resolution_label


## Returns the clue collection rate saved when the resolution attempt started.
func get_selected_resolution_rate() -> float:
	return selected_resolution_rate


## Returns the selected resolution grade, falling back to the current grade for scene tests.
func get_result_resolution_grade() -> String:
	if selected_resolution_grade.is_empty():
		return get_resolution_grade()
	return selected_resolution_grade


## Returns the selected resolution label, falling back to the current label for scene tests.
func get_result_resolution_label() -> String:
	if selected_resolution_label.is_empty():
		return get_resolution_label()
	return selected_resolution_label


## Returns the recovery result that matches the selected resolution grade.
func get_current_recovery_result() -> Dictionary:
	return CaseDataScript.get_recovery_result_for_grade(current_episode_data, get_result_resolution_grade())


## Returns the victim rescue result text for the selected resolution grade.
func get_current_victim_rescue_result() -> String:
	var result := get_current_recovery_result()
	return String(result.get("description", "피해자 구조 결과가 아직 기록되지 않았습니다."))


## Returns the victim after-story for the selected resolution grade.
func get_current_victim_after_story() -> String:
	var result := get_current_recovery_result()
	return String(result.get("after_story", "피해자 후일담이 아직 기록되지 않았습니다."))


## Returns the research result text for the selected resolution grade.
func get_current_research_result() -> String:
	var result := get_current_recovery_result()
	return String(result.get("research_result", "연구 결과가 아직 기록되지 않았습니다."))


## Returns the research reward that matches the selected resolution grade.
func get_current_result_research_reward() -> Dictionary:
	return CaseDataScript.get_research_reward_for_grade(current_episode_data, get_result_resolution_grade())


## Saves the recovery result after the anomaly core is stabilized.
func save_recovery_result(successful: bool, result_status: String, anomaly_stability: int) -> void:
	recovery_successful = successful
	recovery_result_status = result_status
	recovery_result_stability = anomaly_stability
	if successful:
		add_flag(FLAG_CAPTURE_SUCCESS)
		add_flag("capture_result_%s" % result_status)
	save_game()


## Returns true after a successful anomaly core recovery.
func is_recovery_successful() -> bool:
	return recovery_successful


## Returns the saved recovery result status key.
func get_recovery_result_status() -> String:
	return recovery_result_status


## Returns the anomaly stability value saved at recovery.
func get_recovery_result_stability() -> int:
	return recovery_result_stability


## Saves the current MVP run to user://urban_legend_save.json.
func save_game() -> bool:
	if current_episode_data.is_empty() and not load_episode(DEFAULT_EPISODE_PATH):
		return false

	var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Save file cannot be opened: %s" % SAVE_FILE_PATH)
		return false

	file.store_string(JSON.stringify(_make_save_data(), "\t"))
	return true


## Loads the current MVP run from user://urban_legend_save.json.
func load_game() -> bool:
	if not has_save_file():
		return false

	var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if file == null:
		push_error("Save file cannot be opened: %s" % SAVE_FILE_PATH)
		return false

	var parsed_data: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed_data) != TYPE_DICTIONARY:
		push_error("Save file root must be a Dictionary: %s" % SAVE_FILE_PATH)
		return false

	var save_data: Dictionary = parsed_data
	var episode_path := String(save_data.get("episode_path", DEFAULT_EPISODE_PATH))
	if episode_path.is_empty():
		episode_path = DEFAULT_EPISODE_PATH
	if not load_episode(episode_path):
		return false

	set_selected_agent_ids(_to_string_array(save_data.get("selected_agent_ids", [])))
	flags = _to_unique_string_array(save_data.get("flags", []))
	seen_hint_ids = _to_unique_string_array(save_data.get("seen_hint_ids", []))
	minigame_results = _to_dictionary(save_data.get("minigame_results", {}))
	method_results = _to_dictionary(save_data.get("method_results", {}))
	agent_trust_changes = _to_dictionary(save_data.get("agent_trust_changes", {}))
	used_agent_supports = _to_unique_string_array(save_data.get("used_agent_supports", []))
	investigation_risk = clampi(int(save_data.get("investigation_risk", 0)), 0, 100)
	case_understanding = clampi(int(save_data.get("case_understanding", 0)), 0, 100)
	victim_understanding = clampi(int(save_data.get("victim_understanding", 0)), 0, 100)
	case_anomaly_stability = clampi(int(save_data.get("anomaly_stability", 100)), 0, 100)
	_apply_collected_clue_ids(_to_string_array(save_data.get("collected_clue_ids", [])))

	selected_resolution_grade = String(save_data.get("selected_resolution_grade", ""))
	selected_resolution_label = String(save_data.get("selected_resolution_label", ""))
	if selected_resolution_label.is_empty() and not selected_resolution_grade.is_empty():
		selected_resolution_label = _get_resolution_label_for_grade(selected_resolution_grade)
	selected_resolution_rate = float(save_data.get("selected_resolution_rate", get_clue_collection_rate()))

	recovery_successful = bool(save_data.get("capture_success", false))
	recovery_result_status = String(save_data.get("capture_result_state", ""))
	recovery_result_stability = int(save_data.get("capture_result_stability", 100))
	if recovery_successful:
		add_flag(FLAG_CAPTURE_SUCCESS)

	current_scene_path = String(save_data.get("current_scene_path", SCENE_DIALOGUE))
	if current_scene_path.is_empty():
		current_scene_path = SCENE_DIALOGUE

	current_dialogue_node_id = String(save_data.get("current_dialogue_node_id", DEFAULT_DIALOGUE_NODE_ID))
	if current_dialogue_node_id.is_empty():
		current_dialogue_node_id = DEFAULT_DIALOGUE_NODE_ID

	current_minigame_id = String(save_data.get("current_minigame_id", DEFAULT_MINIGAME_ID))
	if current_minigame_id.is_empty():
		current_minigame_id = DEFAULT_MINIGAME_ID
	return true


## Returns true when the save file exists.
func has_save_file() -> bool:
	return FileAccess.file_exists(SAVE_FILE_PATH)


## Deletes the save file if it exists.
func clear_save_file() -> bool:
	if not has_save_file():
		return true

	var error := DirAccess.remove_absolute(SAVE_FILE_PATH)
	return error == OK


## Returns the user:// save file path.
func get_save_file_path() -> String:
	return SAVE_FILE_PATH


func _make_save_data() -> Dictionary:
	return {
		"save_version": SAVE_VERSION,
		"last_updated_at": Time.get_datetime_string_from_system(false, true),
		"episode_id": get_current_episode_id(),
		"episode_path": current_episode_path,
		"current_scene_path": get_current_scene_path(),
		"current_dialogue_node_id": get_current_dialogue_node_id(),
		"current_minigame_id": get_current_minigame_id(),
		"selected_agent_ids": get_selected_agent_ids(),
		"flags": get_flags(),
		"minigame_results": get_minigame_results(),
		"method_results": get_method_results(),
		"agent_trust_changes": get_agent_trust_changes(),
		"used_agent_supports": get_used_agent_supports(),
		"investigation_risk": investigation_risk,
		"case_understanding": case_understanding,
		"victim_understanding": victim_understanding,
		"anomaly_stability": case_anomaly_stability,
		"collected_clue_ids": get_collected_clue_ids(),
		"seen_hint_ids": get_seen_hint_ids(),
		"selected_resolution_grade": selected_resolution_grade,
		"selected_resolution_label": selected_resolution_label,
		"selected_resolution_rate": selected_resolution_rate,
		"capture_success": recovery_successful,
		"capture_result_state": recovery_result_status,
		"capture_result_stability": recovery_result_stability
	}


func _set_clue_collected_without_save(clue_id: String, collected: bool) -> void:
	current_episode_data = CaseDataScript.set_clue_collected(current_episode_data, clue_id, collected)


func _apply_collected_clue_ids(clue_ids: Array) -> void:
	current_episode_data = CaseDataScript.reset_clue_collection(current_episode_data)
	for clue_id in clue_ids:
		_set_clue_collected_without_save(String(clue_id), true)


func _make_minigame_effect_data(minigame: Dictionary, successful: bool) -> Dictionary:
	if successful:
		return {
			"add_flags": minigame.get("success_flags", []),
			"collect_clues": minigame.get("success_collect_clues", []),
			"show_hint_ids": minigame.get("success_show_hint_ids", [])
		}

	return {
		"add_flags": minigame.get("failure_flags", []),
		"collect_clues": minigame.get("failure_collect_clues", []),
		"show_hint_ids": minigame.get("failure_show_hint_ids", [])
	}


func _clear_resolution_phase_selection() -> void:
	selected_resolution_grade = ""
	selected_resolution_label = ""
	selected_resolution_rate = 0.0


func _clear_recovery_result() -> void:
	recovery_successful = false
	recovery_result_status = ""
	recovery_result_stability = 100
	remove_flag(FLAG_CAPTURE_SUCCESS)


func _is_allowed_agent_temperament(agent: Dictionary) -> bool:
	return ALLOWED_AGENT_TEMPERAMENTS.has(String(agent.get("temperament", "")))


func _find_best_selected_agent_for_stat(stat_key: String) -> Dictionary:
	var best_agent: Dictionary = {}
	var best_value := -1
	for agent in get_selected_agents():
		var agent_id := String(agent.get("id", ""))
		var value := get_agent_investigation_stat(agent_id, stat_key)
		if value > best_value:
			best_value = value
			best_agent = agent
	return best_agent


func _apply_method_status_deltas(effect_data: Dictionary) -> void:
	investigation_risk = clampi(
		investigation_risk + int(effect_data.get("investigation_risk_delta", 0)),
		0,
		100
	)
	case_understanding = clampi(
		case_understanding + int(effect_data.get("case_understanding_delta", 0)),
		0,
		100
	)
	victim_understanding = clampi(
		victim_understanding + int(effect_data.get("victim_understanding_delta", 0)),
		0,
		100
	)
	case_anomaly_stability = clampi(
		case_anomaly_stability + int(effect_data.get("anomaly_stability_delta", 0)),
		0,
		100
	)


func _apply_method_trust_rules(method: Dictionary, successful: bool, helper_agent_id: String) -> Array:
	var changes: Array = []
	var rules: Array = method.get("trust_rules", [])
	for agent in get_selected_agents():
		var agent_id := String(agent.get("id", ""))
		var temperament := String(agent.get("temperament", ""))
		var rule := _find_trust_rule_for_temperament(rules, temperament)
		if rule.is_empty():
			continue

		var delta_key := "success_delta" if successful else "failure_delta"
		var text_key := "success_text" if successful else "failure_text"
		var delta := int(rule.get(delta_key, 0))
		var reaction_text := String(rule.get(text_key, ""))
		if delta != 0:
			_add_agent_trust_delta(agent_id, delta)

		if delta != 0 or not reaction_text.is_empty():
			changes.append({
				"agent_id": agent_id,
				"agent_name": String(agent.get("name", "")),
				"temperament": temperament,
				"temperament_label": String(agent.get("temperament_label", "")),
				"is_helper": agent_id == helper_agent_id,
				"delta": delta,
				"total": get_agent_trust_delta(agent_id),
				"text": reaction_text
			})
	return changes


func _find_trust_rule_for_temperament(rules: Array, temperament: String) -> Dictionary:
	for rule in rules:
		if typeof(rule) == TYPE_DICTIONARY and String(rule.get("temperament", "")) == temperament:
			return rule
	return {}


func _add_agent_trust_delta(agent_id: String, delta: int) -> void:
	if agent_id.strip_edges().is_empty():
		return

	agent_trust_changes[agent_id] = int(agent_trust_changes.get(agent_id, 0)) + delta


func _get_new_string_ids(before_ids: Array, after_ids: Array) -> Array:
	var new_ids: Array = []
	for after_id in _to_string_array(after_ids):
		if not before_ids.has(after_id):
			new_ids.append(after_id)
	return new_ids


func _clear_investigation_method_state() -> void:
	investigation_risk = 0
	case_understanding = 0
	victim_understanding = 0
	case_anomaly_stability = 100
	method_results.clear()
	agent_trust_changes.clear()
	used_agent_supports.clear()


func _to_unique_string_array(value: Variant) -> Array:
	var result: Array = []
	for item in _to_string_array(value):
		if not result.has(item):
			result.append(item)
	return result


func _to_string_array(value: Variant) -> Array:
	var result: Array = []
	if typeof(value) != TYPE_ARRAY:
		return result

	for item in value:
		var text := String(item).strip_edges()
		if not text.is_empty():
			result.append(text)
	return result


func _to_dictionary(value: Variant) -> Dictionary:
	if typeof(value) == TYPE_DICTIONARY:
		return value.duplicate(true)
	return {}


func _get_resolution_rank(grade: String) -> int:
	match grade:
		"temporary":
			return 1
		"standard":
			return 2
		"complete":
			return 3
		_:
			return 0


func _get_resolution_label_for_grade(grade: String) -> String:
	match grade:
		"temporary":
			return "임시 해결 가능"
		"standard":
			return "정식 해결 가능"
		"complete":
			return "완전 해결 가능"
		_:
			return "해결 불가"
