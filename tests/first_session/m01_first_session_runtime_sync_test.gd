extends SceneTree

const GAME_STATE_PATH := "res://scripts/core/afterlife_migrating_game_state.gd"
const SYNC_PATH := "res://scripts/core/m01_first_session_runtime_sync.gd"
const M01_CASE_ID := "episode_001_afterlife_station"
const M01_CONTRACT_ID := "afterlife-station-canon-v2"
const M04_PATH := "res://data/episodes/episode_002_red_umbrella_alley.json"

var _failures: Array[String] = []


func _init() -> void:
	_expect(FileAccess.file_exists(GAME_STATE_PATH), "active GameState missing")
	_expect(FileAccess.file_exists(SYNC_PATH), "M01 runtime sync coordinator missing")
	if FileAccess.file_exists(GAME_STATE_PATH) and FileAccess.file_exists(SYNC_PATH):
		var state_script: Variant = load(GAME_STATE_PATH)
		var sync_script: Variant = load(SYNC_PATH)
		_expect(state_script is Script, "active GameState failed to load")
		_expect(sync_script is Script, "M01 runtime sync coordinator failed to load")
		if state_script is Script and sync_script is Script:
			_test_new_campaign_activates_canon_v2(state_script as Script)
			_test_investigation_sync(state_script as Script, sync_script as Script)
			_test_non_m01_noop(state_script as Script, sync_script as Script)
	_finish()


func _test_new_campaign_activates_canon_v2(state_script: Script) -> void:
	var state = state_script.new()
	_expect(state.restart_afterlife_station_flow(), "M01 new campaign restart failed")
	_expect(state.get_afterlife_content_contract_id() == M01_CONTRACT_ID, "M01 new campaign did not activate Canon v2 contract")
	var episode := state.get_current_episode() as Dictionary
	_expect(String(episode.get("content_contract_id", "")) == M01_CONTRACT_ID, "M01 new campaign loaded legacy episode instead of Canon v2")
	_expect(String(episode.get("recovery_pattern_source", "")) == "canonical_v2_projection", "M01 new campaign lacks Canon v2 recovery projection")
	var manual_value: Variant = episode.get("investigation_manual")
	_expect(typeof(manual_value) == TYPE_DICTIONARY, "M01 new campaign lacks Canon v2 investigation manual")
	if typeof(manual_value) == TYPE_DICTIONARY:
		var manual := manual_value as Dictionary
		_expect((manual.get("pages", []) as Array).size() >= 3, "M01 Canon v2 manual pages missing on new campaign")
	state.free()


func _test_investigation_sync(state_script: Script, sync_script: Script) -> void:
	var state = state_script.new()
	_expect(state.restart_afterlife_station_flow(), "M01 episode failed to initialize")
	_expect(state.get_current_episode_id() == M01_CASE_ID, "M01 episode identity mismatch")
	var coordinator = sync_script.new()
	var first: Dictionary = coordinator.sync_scene_mode(state, "investigation")
	_expect(bool(first.get("ok", false)), "M01 investigation runtime sync failed")
	_expect(String(first.get("code", "")) == "M01_RUNTIME_SYNCED", "M01 runtime sync success code mismatch")
	var monthly := state.get_monthly_state() as Dictionary
	_expect(String(monthly.get("active_main_case_id", "")) == M01_CASE_ID, "M01 runtime sync did not select monthly main case")
	_expect(int(monthly.get("week_index", 0)) == 2, "M01 runtime sync did not use first dispatch week")
	_expect(String(monthly.get("main_case_status", "")) == "ACTIVE", "M01 runtime sync did not activate monthly case")
	var first_session := state.get_m01_first_session_state() as Dictionary
	_expect(String(first_session.get("phase", "")) == "M01_INVESTIGATION", "M01 investigation scene did not advance First Session")

	var second: Dictionary = coordinator.sync_scene_mode(state, "investigation")
	_expect(bool(second.get("ok", false)), "repeated M01 investigation sync failed")
	var repeated_monthly := state.get_monthly_state() as Dictionary
	var repeated_first_session := state.get_m01_first_session_state() as Dictionary
	_expect(repeated_monthly == monthly, "repeated investigation sync mutated monthly state")
	_expect(repeated_first_session == first_session, "repeated investigation sync advanced without earned evidence")
	state.free()


func _test_non_m01_noop(state_script: Script, sync_script: Script) -> void:
	var state = state_script.new()
	_expect(state.load_episode(M04_PATH), "M04 episode failed to load")
	var monthly_before := state.get_monthly_state() as Dictionary
	var session_before := state.get_m01_first_session_state() as Dictionary
	var coordinator = sync_script.new()
	var result: Dictionary = coordinator.sync_scene_mode(state, "investigation")
	_expect(bool(result.get("ok", false)), "non-M01 sync should be a successful no-op")
	_expect(String(result.get("code", "")) == "NOT_APPLICABLE", "non-M01 sync classification mismatch")
	_expect(state.get_monthly_state() == monthly_before, "M04 sync mutated monthly orchestration")
	_expect(state.get_m01_first_session_state() == session_before, "M04 sync mutated M01 First Session state")
	state.free()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("M01 FIRST SESSION RUNTIME SYNC: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
