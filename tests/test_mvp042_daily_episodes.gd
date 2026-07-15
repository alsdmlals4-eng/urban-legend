extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")
const AFTERLIFE := "episode_001_afterlife_station"
const RED_UMBRELLA := "episode_002_red_umbrella_alley"
const DEAD_FREQUENCY := "episode_003_dead_frequency_station"

var _guard := TestSaveGuard.new()
var _guard_prepared := false
var _passed := 0
var _failed := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node("GameState")
	var guard_error := _guard.prepare(game_state.SAVE_FILE_PATH)
	if not guard_error.is_empty():
		_fail(guard_error)
		return
	_guard_prepared = true

	_test_catalog_and_hq_availability(game_state)
	_test_active_save_resume_and_invariants(game_state)
	_test_day_eight_dead_frequency_unlock(game_state)
	_test_mvp038_migration(game_state)

	var restore_error := _guard.restore()
	_guard_prepared = false
	if not restore_error.is_empty():
		_fail(restore_error)
	if _failed == 0:
		print("MVP-042 daily episodes: %d passed, 0 failed" % _passed)
		quit(0)
	else:
		push_error("MVP-042 daily episodes: %d passed, %d failed" % [_passed, _failed])
		quit(1)


func _test_catalog_and_hq_availability(game_state: Node) -> void:
	game_state.reset_run_state()
	_expect(game_state.SAVE_VERSION == "mvp-045", "daily episode state migrates through the mvp-045 relationship-record version")
	var afterlife: Dictionary = game_state.get_daily_episode("daily_afterlife_sign_blanks")
	var umbrella: Dictionary = game_state.get_daily_episode("daily_red_umbrella_locker")
	var frequency: Dictionary = game_state.get_daily_episode("daily_dead_frequency_edit_room")
	_expect(afterlife.get("case_id", "") == AFTERLIFE and (afterlife.get("choices", []) as Array).size() == 2, "afterlife daily card has two recorded choices")
	_expect(umbrella.get("case_id", "") == RED_UMBRELLA and (umbrella.get("choices", []) as Array).size() == 2, "red umbrella daily card has two recorded choices")
	_expect(frequency.get("case_id", "") == DEAD_FREQUENCY and (frequency.get("choices", []) as Array).size() == 2, "dead frequency daily card has two recorded choices")
	var available_ids := _episode_ids(game_state.get_available_daily_episodes())
	_expect(available_ids.has("daily_afterlife_sign_blanks") and available_ids.has("daily_red_umbrella_locker"), "lead cases expose their optional HQ cards")
	_expect(not available_ids.has("daily_dead_frequency_edit_room"), "hidden dead frequency card is not exposed before day 8")


func _test_active_save_resume_and_invariants(game_state: Node) -> void:
	game_state.reset_run_state()
	var before := _campaign_invariants(game_state.get_campaign_snapshot())
	var started: Dictionary = game_state.begin_daily_episode("daily_afterlife_sign_blanks")
	_expect(bool(started.get("successful", false)), "HQ starts a discovered daily episode")
	_expect(String(game_state.get_active_daily_episode().get("episode_id", "")) == "daily_afterlife_sign_blanks", "active daily episode is stored before a choice")
	_expect(String(game_state.get_current_scene_path()) == game_state.SCENE_DAILY_EPISODE, "active daily episode routes Continue to the daily scene")
	_expect(game_state.save_game(), "active daily episode saves")
	game_state.reset_run_state()
	_expect(game_state.load_game(), "mvp-039 active daily episode reloads")
	_expect(String(game_state.get_active_daily_episode().get("episode_id", "")) == "daily_afterlife_sign_blanks", "active daily episode survives save round trip")
	var resolved: Dictionary = game_state.resolve_daily_episode_choice("preserve_order")
	_expect(bool(resolved.get("successful", false)), "daily choice resolves")
	_expect(game_state.get_active_daily_episode().is_empty(), "daily episode clears after its choice")
	_expect(String(game_state.get_current_scene_path()) == game_state.SCENE_PREPARATION, "daily choice returns Continue to HQ preparation")
	var records: Array = game_state.get_completed_daily_episode_records()
	_expect(records.size() == 1 and String(records[0].get("choice_id", "")) == "preserve_order", "choice and record summary persist")
	var after := _campaign_invariants(game_state.get_campaign_snapshot())
	_expect(before == after, "daily episode does not change day, slot, phase, risk, schedule, requests, or field assignment")
	var afterlife_state: Dictionary = game_state.get_campaign_snapshot().get("cases", {}).get(AFTERLIFE, {})
	_expect(int(afterlife_state.get("daily_understanding", 0)) == 2, "first daily card grants the capped +2 optional understanding reward")
	_expect(not _episode_ids(game_state.get_available_daily_episodes()).has("daily_afterlife_sign_blanks"), "completed daily card cannot be opened again")
	_expect(not bool(game_state.resolve_daily_episode_choice("preserve_order").get("successful", true)), "daily choice cannot resolve twice")


func _test_day_eight_dead_frequency_unlock(game_state: Node) -> void:
	game_state.reset_run_state()
	_expect(game_state.resolve_campaign_case(AFTERLIFE, "standard"), "resolved afterlife leaves the hidden case in natural risk rotation")
	_expect(game_state.resolve_campaign_case(RED_UMBRELLA, "standard"), "resolved red umbrella leaves the hidden case in natural risk rotation")
	for _index in range(7):
		game_state.advance_campaign_day(false)
	var campaign: Dictionary = game_state.get_campaign_snapshot()
	_expect(int(campaign.get("day", 0)) == 8, "natural campaign advancement reaches day 8")
	_expect(String(campaign.get("cases", {}).get(DEAD_FREQUENCY, {}).get("discovery_state", "")) == "lead", "natural risk rotation discovers dead frequency on day 8")
	_expect(_episode_ids(game_state.get_available_daily_episodes()).has("daily_dead_frequency_edit_room"), "dead frequency daily card opens only after natural discovery")


func _test_mvp038_migration(game_state: Node) -> void:
	game_state.reset_run_state()
	_expect(game_state.save_game(), "baseline mvp-039 save writes before migration test")
	var file := FileAccess.open(game_state.SAVE_FILE_PATH, FileAccess.READ)
	var legacy: Dictionary = JSON.parse_string(file.get_as_text())
	file.close()
	legacy["save_version"] = "mvp-038"
	legacy.erase("completed_daily_episode_records")
	legacy.erase("active_daily_episode")
	var legacy_file := FileAccess.open(game_state.SAVE_FILE_PATH, FileAccess.WRITE)
	legacy_file.store_string(JSON.stringify(legacy))
	legacy_file.close()
	game_state.reset_run_state()
	_expect(game_state.load_game(), "mvp-038 save migrates into mvp-039")
	_expect(game_state.get_completed_daily_episode_records().is_empty() and game_state.get_active_daily_episode().is_empty(), "mvp-038 migration defaults daily record state to empty")


func _campaign_invariants(campaign: Dictionary) -> Dictionary:
	var cases: Dictionary = campaign.get("cases", {})
	var risks := {}
	for case_id in [AFTERLIFE, RED_UMBRELLA, DEAD_FREQUENCY]:
		risks[case_id] = int(cases.get(case_id, {}).get("risk", 0))
	return {
		"day": int(campaign.get("day", 0)),
		"time_slot": String(campaign.get("time_slot", "")),
		"slot_phase": String(campaign.get("slot_phase", "")),
		"planned_case_id": String(campaign.get("planned_case_id", "")),
		"active_operation": campaign.get("active_operation", {}),
		"schedules": campaign.get("schedules", {}),
		"request_board": campaign.get("request_board", []),
		"risks": risks
	}


func _episode_ids(episodes: Array) -> Array:
	var ids: Array = []
	for value in episodes:
		if typeof(value) == TYPE_DICTIONARY:
			ids.append(String((value as Dictionary).get("id", "")))
	return ids


func _expect(condition: bool, message: String) -> void:
	if condition:
		_passed += 1
	else:
		_fail(message)


func _fail(message: String) -> void:
	_failed += 1
	push_error(message)
