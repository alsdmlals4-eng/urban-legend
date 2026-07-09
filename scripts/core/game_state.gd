# 현재 사건 데이터 로딩과 단서 수집 상태를 관리한다.
extends Node

const DEFAULT_EPISODE_PATH := "res://data/episodes/episode_001_afterlife_station.json"
const EpisodeLoaderScript := preload("res://scripts/data/episode_loader.gd")
const CaseDataScript := preload("res://scripts/data/case_data.gd")

var current_episode_path := DEFAULT_EPISODE_PATH
var current_episode_data: Dictionary = {}
var selected_resolution_grade := ""
var selected_resolution_label := ""
var selected_resolution_rate := 0.0


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
	_clear_resolution_phase_selection()


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


func _clear_resolution_phase_selection() -> void:
	selected_resolution_grade = ""
	selected_resolution_label = ""
	selected_resolution_rate = 0.0
