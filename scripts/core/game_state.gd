# 현재 사건 데이터, 플래그, 조건, 저장 상태를 관리한다.
extends Node

const DEFAULT_EPISODE_PATH := "res://data/episodes/episode_001_afterlife_station.json"
const SAVE_FILE_PATH := "user://urban_legend_save.json"
const SAVE_VERSION := "mvp-007"
const SCENE_MAIN_MENU := "res://scenes/main_menu.tscn"
const SCENE_DIALOGUE := "res://scenes/dialogue_scene.tscn"
const SCENE_INVESTIGATION := "res://scenes/investigation_scene.tscn"
const SCENE_BATTLE := "res://scenes/battle_scene.tscn"
const SCENE_RESULT := "res://scenes/result_scene.tscn"
const FLAG_CAPTURE_SUCCESS := "capture_success"
const EpisodeLoaderScript := preload("res://scripts/data/episode_loader.gd")
const CaseDataScript := preload("res://scripts/data/case_data.gd")

var current_episode_path := DEFAULT_EPISODE_PATH
var current_episode_data: Dictionary = {}
var current_scene_path := SCENE_MAIN_MENU
var flags: Array = []
var seen_hint_ids: Array = []
var selected_resolution_grade := ""
var selected_resolution_label := ""
var selected_resolution_rate := 0.0
var recovery_successful := false
var recovery_result_status := ""
var recovery_result_stability := 100


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
func restart_afterlife_station_flow() -> bool:
	reset_run_state()
	current_scene_path = SCENE_DIALOGUE
	return not current_episode_data.is_empty()


## Clears the current run state and reloads the default episode.
func reset_run_state() -> void:
	flags.clear()
	seen_hint_ids.clear()
	current_scene_path = SCENE_DIALOGUE
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


## Returns active hint records. Hints are separate from clues.
func get_hints() -> Array:
	return CaseDataScript.get_hints(current_episode_data)


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

	flags = _to_unique_string_array(save_data.get("flags", []))
	seen_hint_ids = _to_unique_string_array(save_data.get("seen_hint_ids", []))
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
		"flags": get_flags(),
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


func _clear_resolution_phase_selection() -> void:
	selected_resolution_grade = ""
	selected_resolution_label = ""
	selected_resolution_rate = 0.0


func _clear_recovery_result() -> void:
	recovery_successful = false
	recovery_result_status = ""
	recovery_result_stability = 100
	remove_flag(FLAG_CAPTURE_SUCCESS)


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
