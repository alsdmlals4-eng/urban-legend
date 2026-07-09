# 피해자, 힌트, 단서와 해결 단계 계산을 담당한다.
class_name CaseData
extends RefCounted

const GRADE_UNAVAILABLE := "unavailable"
const GRADE_TEMPORARY := "temporary"
const GRADE_STANDARD := "standard"
const GRADE_COMPLETE := "complete"

const GRADE_LABELS := {
	GRADE_UNAVAILABLE: "해결 불가",
	GRADE_TEMPORARY: "임시 해결 가능",
	GRADE_STANDARD: "정식 해결 가능",
	GRADE_COMPLETE: "완전 해결 가능"
}


## Returns victim records without mixing them with clues or hints.
static func get_victims(episode_data: Dictionary) -> Array:
	return _get_array(episode_data, "victims")


## Returns hint records. Hints do not affect clue collection rate.
static func get_hints(episode_data: Dictionary) -> Array:
	return _get_array(episode_data, "hints")


## Returns agent records for mission formation.
static func get_agents(episode_data: Dictionary) -> Array:
	return _get_array(episode_data, "agents")


## Finds one agent by id.
static func get_agent_by_id(episode_data: Dictionary, agent_id: String) -> Dictionary:
	for agent in get_agents(episode_data):
		if typeof(agent) == TYPE_DICTIONARY and agent.get("id", "") == agent_id:
			return agent
	return {}


## Returns dialogue reactions attached to recruitable agents.
static func get_agent_reactions(episode_data: Dictionary) -> Array:
	return _get_array(episode_data, "agent_reactions")


## Returns clue records. Only this list is counted for clue collection rate.
static func get_clues(episode_data: Dictionary) -> Array:
	return _get_array(episode_data, "clues")


## Returns dialogue node records for data-driven visual novel scenes.
static func get_dialogue_nodes(episode_data: Dictionary) -> Array:
	return _get_array(episode_data, "dialogue_nodes")


## Finds one dialogue node by id.
static func get_dialogue_node_by_id(episode_data: Dictionary, dialogue_node_id: String) -> Dictionary:
	for node in get_dialogue_nodes(episode_data):
		if typeof(node) == TYPE_DICTIONARY and node.get("id", "") == dialogue_node_id:
			return node
	return {}


## Returns investigation point records for data-driven investigation scenes.
static func get_investigation_points(episode_data: Dictionary) -> Array:
	return _get_array(episode_data, "investigation_points")


## Returns minigame records for data-driven event checks.
static func get_minigames(episode_data: Dictionary) -> Array:
	return _get_array(episode_data, "minigames")


## Finds one minigame by id.
static func get_minigame_by_id(episode_data: Dictionary, minigame_id: String) -> Dictionary:
	for minigame in get_minigames(episode_data):
		if typeof(minigame) == TYPE_DICTIONARY and minigame.get("id", "") == minigame_id:
			return minigame
	return {}


## Finds one hint by id.
static func get_hint_by_id(episode_data: Dictionary, hint_id: String) -> Dictionary:
	for hint in get_hints(episode_data):
		if typeof(hint) == TYPE_DICTIONARY and hint.get("id", "") == hint_id:
			return hint
	return {}


## Counts every clue in the active episode data.
static func get_total_clue_count(episode_data: Dictionary) -> int:
	return get_clues(episode_data).size()


## Counts only clues marked as collected.
static func get_collected_clue_count(episode_data: Dictionary) -> int:
	var collected_count := 0
	for clue in get_clues(episode_data):
		if typeof(clue) == TYPE_DICTIONARY and clue.get("collected", false):
			collected_count += 1
	return collected_count


## Calculates collection rate from current collected clues and total clues.
static func get_collection_rate(episode_data: Dictionary) -> float:
	var total_count := get_total_clue_count(episode_data)
	if total_count <= 0:
		return 0.0
	return float(get_collected_clue_count(episode_data)) / float(total_count) * 100.0


## Returns the current resolution grade based on collection rate thresholds.
static func get_resolution_grade(episode_data: Dictionary) -> String:
	return get_resolution_grade_for_rate(episode_data, get_collection_rate(episode_data))


## Returns the Korean display label for the current resolution grade.
static func get_resolution_label(episode_data: Dictionary) -> String:
	return GRADE_LABELS.get(get_resolution_grade(episode_data), "해결 불가")


## Returns the grade for a supplied rate using the episode resolution thresholds.
static func get_resolution_grade_for_rate(episode_data: Dictionary, collection_rate: float) -> String:
	var resolution := _get_resolution(episode_data)
	var temporary_threshold := float(resolution.get("temporary_threshold", 40.0))
	var standard_threshold := float(resolution.get("standard_threshold", 70.0))
	var complete_threshold := float(resolution.get("complete_threshold", 100.0))

	if collection_rate >= complete_threshold:
		return GRADE_COMPLETE
	if collection_rate >= standard_threshold:
		return GRADE_STANDARD
	if collection_rate >= temporary_threshold:
		return GRADE_TEMPORARY
	return GRADE_UNAVAILABLE


## Marks one clue as collected and refreshes resolution progress fields.
static func collect_clue(episode_data: Dictionary, clue_id: String) -> Dictionary:
	return set_clue_collected(episode_data, clue_id, true)


## Changes one clue collected state and refreshes resolution progress fields.
static func set_clue_collected(episode_data: Dictionary, clue_id: String, collected: bool) -> Dictionary:
	var next_data := episode_data.duplicate(true)
	var clues := get_clues(next_data)
	for index in range(clues.size()):
		var clue = clues[index]
		if typeof(clue) == TYPE_DICTIONARY and clue.get("id", "") == clue_id:
			clue["collected"] = collected
			clues[index] = clue
			break

	next_data["clues"] = clues
	return refresh_resolution_progress(next_data)


## Clears all clue collected states and refreshes resolution progress fields.
static func reset_clue_collection(episode_data: Dictionary) -> Dictionary:
	var next_data := episode_data.duplicate(true)
	var clues := get_clues(next_data)
	for index in range(clues.size()):
		var clue = clues[index]
		if typeof(clue) == TYPE_DICTIONARY:
			clue["collected"] = false
			clues[index] = clue

	next_data["clues"] = clues
	return refresh_resolution_progress(next_data)


## Updates resolution progress fields from the current clue list.
static func refresh_resolution_progress(episode_data: Dictionary) -> Dictionary:
	var next_data := episode_data.duplicate(true)
	var resolution := _get_resolution(next_data)
	var total_count := get_total_clue_count(next_data)
	var collected_count := get_collected_clue_count(next_data)
	var collection_rate := get_collection_rate(next_data)

	resolution["total_clues"] = total_count
	resolution["collected_clues"] = collected_count
	resolution["collection_rate"] = collection_rate
	resolution["phase_state"] = get_resolution_grade_for_rate(next_data, collection_rate)
	next_data["resolution"] = resolution
	return next_data


## Finds the battle auto-effect linked to one clue.
static func get_battle_effect_for_clue(episode_data: Dictionary, clue_id: String) -> Dictionary:
	for effect in _get_array(episode_data, "battle_clue_effects"):
		if typeof(effect) == TYPE_DICTIONARY and effect.get("clue_id", "") == clue_id:
			return effect
	return {}


## Finds the research reward for one resolution grade.
static func get_research_reward_for_grade(episode_data: Dictionary, resolution_grade: String) -> Dictionary:
	for reward in _get_array(episode_data, "research_rewards"):
		if typeof(reward) == TYPE_DICTIONARY and reward.get("resolution_grade", "") == resolution_grade:
			return reward
	return {}


## Finds the recovery result for one resolution grade.
static func get_recovery_result_for_grade(episode_data: Dictionary, resolution_grade: String) -> Dictionary:
	for result in _get_array(episode_data, "recovery_results"):
		if typeof(result) == TYPE_DICTIONARY and result.get("resolution_grade", "") == resolution_grade:
			return result
	return {}


static func _get_resolution(episode_data: Dictionary) -> Dictionary:
	var value: Variant = episode_data.get("resolution", {})
	if typeof(value) == TYPE_DICTIONARY:
		return value
	return {}


static func _get_array(episode_data: Dictionary, key: String) -> Array:
	var value: Variant = episode_data.get(key, [])
	if typeof(value) == TYPE_ARRAY:
		return value
	return []
