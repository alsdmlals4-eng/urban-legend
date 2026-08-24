extends SceneTree

const GAME_STATE_PATH := "res://scripts/core/afterlife_migrating_game_state.gd"
const M04_PATH := "res://data/episodes/episode_002_red_umbrella_alley.json"
const M04_CASE_ID := "episode_002_red_umbrella_alley"
const SAVE_PATH := "user://urban_legend_save.json"

var _failures: Array[String] = []


func _init() -> void:
	_remove_save()
	_expect(FileAccess.file_exists(GAME_STATE_PATH), "active GameState missing")
	if FileAccess.file_exists(GAME_STATE_PATH):
		var script_value: Variant = load(GAME_STATE_PATH)
		_expect(script_value is Script, "active GameState failed to load")
		if script_value is Script:
			_test_m04_round_trip(script_value as Script)
	_remove_save()
	_finish()


func _test_m04_round_trip(state_script: Script) -> void:
	var state = state_script.new()
	_expect(state.load_episode(M04_PATH), "M04 episode failed to load")
	if state.get_current_episode_id() != M04_CASE_ID:
		_expect(false, "M04 case identity did not activate")
		return
	var applied := state.apply_monthly_state({
		"schema_version": 1,
		"month_index": 4,
		"week_index": 2,
		"active_main_case_id": M04_CASE_ID,
		"main_case_status": "DISPATCHABLE",
		"dispatch_risk": 0,
		"resolved_this_month": false,
		"aftermath_available": false,
		"last_month_result_ref": "result:m03:previous"
	}) as Dictionary
	_expect(bool(applied.get("ok", false)), "M04 monthly state setup failed")
	_expect(state.save_game(), "M04 save failed")
	_expect(FileAccess.file_exists(SAVE_PATH), "M04 save file missing")
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(SAVE_PATH))
	_expect(typeof(parsed) == TYPE_DICTIONARY, "M04 save is not JSON object")
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	var payload := parsed as Dictionary
	_expect(payload.has("monthly_state"), "M04 save dropped monthly_state")
	var saved_monthly := payload.get("monthly_state", {}) as Dictionary
	_expect(int(saved_monthly.get("month_index", 0)) == 4, "M04 save changed month index")
	_expect(String(saved_monthly.get("active_main_case_id", "")) == M04_CASE_ID, "M04 save changed monthly case id")
	_expect(payload.has("m01_first_session"), "cross-case save dropped M01 first-session progress block")

	var restored = state_script.new()
	_expect(restored.load_game(), "M04 save failed to reload")
	_expect(restored.get_current_episode_id() == M04_CASE_ID, "M04 episode identity failed to restore")
	var restored_monthly := restored.get_monthly_state() as Dictionary
	_expect(int(restored_monthly.get("month_index", 0)) == 4, "M04 reload lost month index")
	_expect(int(restored_monthly.get("week_index", 0)) == 2, "M04 reload lost week index")
	_expect(String(restored_monthly.get("active_main_case_id", "")) == M04_CASE_ID, "M04 reload lost active monthly case")
	_expect(String(restored_monthly.get("main_case_status", "")) == "DISPATCHABLE", "M04 reload lost monthly case status")


func _remove_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("MONTHLY STATE CROSS CASE PERSISTENCE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
