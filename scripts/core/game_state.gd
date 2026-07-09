# 현재 사건 데이터 로딩과 단서 수집 상태를 관리한다.
extends Node

const DEFAULT_EPISODE_PATH := "res://data/episodes/episode_001_afterlife_station.json"
const EpisodeLoaderScript := preload("res://scripts/data/episode_loader.gd")
const CaseDataScript := preload("res://scripts/data/case_data.gd")

var current_episode_path := DEFAULT_EPISODE_PATH
var current_episode_data: Dictionary = {}


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
	return true


## Returns the active episode Dictionary.
func get_current_episode() -> Dictionary:
	return current_episode_data


## Marks one clue as collected and updates the resolution state.
func collect_clue(clue_id: String) -> bool:
	if current_episode_data.is_empty():
		return false

	var before_count := CaseDataScript.get_collected_clue_count(current_episode_data)
	current_episode_data = CaseDataScript.collect_clue(current_episode_data, clue_id)
	return CaseDataScript.get_collected_clue_count(current_episode_data) > before_count


## Sets one clue collected state for tests and simple UI prototypes.
func set_clue_collected(clue_id: String, collected: bool) -> bool:
	if current_episode_data.is_empty():
		return false

	current_episode_data = CaseDataScript.set_clue_collected(current_episode_data, clue_id, collected)
	return true


## Resets all clue collection states in the active episode.
func reset_clue_collection() -> void:
	if current_episode_data.is_empty():
		return

	current_episode_data = CaseDataScript.reset_clue_collection(current_episode_data)


## Returns active victim records.
func get_victims() -> Array:
	return CaseDataScript.get_victims(current_episode_data)


## Returns active hint records. Hints are separate from clues.
func get_hints() -> Array:
	return CaseDataScript.get_hints(current_episode_data)


## Returns active clue records.
func get_clues() -> Array:
	return CaseDataScript.get_clues(current_episode_data)


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


## Returns the research reward for the current resolution grade.
func get_current_research_reward() -> Dictionary:
	return CaseDataScript.get_research_reward_for_grade(current_episode_data, get_resolution_grade())
