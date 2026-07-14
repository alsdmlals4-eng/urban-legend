extends SceneTree

## Verifies the third case can enter the existing campaign, recovery, report,
## database, and save contracts without adding a new state schema.

const TestSaveGuard = preload("res://tests/test_save_guard.gd")
const DEAD_FREQUENCY_ID := "episode_003_dead_frequency_station"
const DEAD_FREQUENCY_PATH := "res://data/episodes/episode_003_dead_frequency_station.json"
const TEAM := ["agent_kang_ijun", "agent_kwon_narae", "agent_oh_hyun"]

var _guard := TestSaveGuard.new()
var _game_state: Node
var _passed := 0
var _failed := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_game_state = root.get_node_or_null("GameState")
	if _game_state == null:
		push_error("GameState autoload is unavailable")
		quit(1)
		return
	if not _guard.prepare("user://urban_legend_save.json").is_empty():
		push_error("Unable to protect the player save for MVP-040 test")
		quit(1)
		return
	_game_state.reset_run_state()
	_game_state.set_selected_agent_ids(TEAM)
	_check(String(_game_state.get_campaign_snapshot().get("cases", {}).get(DEAD_FREQUENCY_ID, {}).get("discovery_state", "")) == "unknown", "dead frequency starts hidden")
	_game_state.apply_campaign_case_risk(DEAD_FREQUENCY_ID, 60)
	_check(_has_preparation_entry(DEAD_FREQUENCY_ID), "discovered dead frequency appears in preparation")
	_check(_game_state.start_episode_from_preparation(DEAD_FREQUENCY_PATH), "dead frequency episode loads from preparation")
	_check(_game_state.get_current_episode_id() == DEAD_FREQUENCY_ID, "active episode id is dead frequency")
	await _change_scene("res://scenes/investigation_scene.tscn")
	_check(current_scene.scene_file_path == "res://scenes/investigation_scene.tscn", "dead frequency loads the existing investigation scene")
	_check(_game_state.get_clues().size() == 3, "dead frequency provides three authored clues")
	_check(_game_state.get_recovery_patterns().size() == 3, "dead frequency provides three recovery patterns")
	_check(_patterns_have_fair_response_data(), "each recovery pattern exposes telegraph, related clue, correct response, and failure reason")
	var minigame: Dictionary = _game_state.get_minigame("minigame_dead_air_sync")
	_check(String(minigame.get("type", "")) == "rhythm_timing", "dead frequency reuses the existing timing judgment")
	_check(not minigame.get("success_show_hint_ids", []).is_empty(), "judgment success records a next recovery hint")
	for clue in _game_state.get_clues():
		if typeof(clue) == TYPE_DICTIONARY:
			_game_state.collect_clue(String(clue.get("id", "")))
	for hint in _game_state.get_hints():
		if typeof(hint) == TYPE_DICTIONARY:
			_game_state.mark_hint_seen(String(hint.get("id", "")))
	_check(_game_state.start_resolution_phase(), "complete evidence enters recovery")
	await _change_scene("res://scenes/battle_scene.tscn")
	_check(current_scene.scene_file_path == "res://scenes/battle_scene.tscn", "dead frequency loads the existing recovery scene")
	_game_state.save_recovery_result(true, "core_recovered", 100)
	_check(_game_state.record_current_case_report(), "dead frequency writes a completed report")
	_check(_has_completed_report(DEAD_FREQUENCY_ID), "dead frequency report appears in the database")
	_check(_game_state.save_game(), "dead frequency report saves")
	_game_state.reset_run_state()
	_check(_game_state.load_game(), "dead frequency report loads")
	_check(_game_state.get_current_episode_id() == DEAD_FREQUENCY_ID, "saved active episode restores dead frequency")
	_check(_has_completed_report(DEAD_FREQUENCY_ID), "saved database retains dead frequency report")
	var restore_error := _guard.restore()
	if not restore_error.is_empty():
		push_error(restore_error)
		_failed += 1
	print("MVP-040 dead frequency slice: %d passed, %d failed" % [_passed, _failed])
	quit(0 if _failed == 0 else 1)


func _has_preparation_entry(episode_id: String) -> bool:
	for entry in _game_state.get_preparation_episode_entries():
		if typeof(entry) == TYPE_DICTIONARY and String(entry.get("id", "")) == episode_id:
			return true
	return false


func _change_scene(scene_path: String) -> void:
	var error := change_scene_to_file(scene_path)
	_check(error == OK, "loads %s" % scene_path)
	await process_frame
	await process_frame


func _patterns_have_fair_response_data() -> bool:
	for pattern in _game_state.get_recovery_patterns():
		if typeof(pattern) != TYPE_DICTIONARY:
			return false
		var response_id := String(pattern.get("correct_response_id", ""))
		var has_response := false
		for response in pattern.get("responses", []):
			if typeof(response) == TYPE_DICTIONARY and String(response.get("id", "")) == response_id:
				has_response = true
				break
		if String(pattern.get("telegraph", "")).is_empty() or String(pattern.get("failure_reason", "")).is_empty() or pattern.get("related_clue_ids", []).is_empty() or not has_response:
			return false
	return true


func _has_completed_report(episode_id: String) -> bool:
	for report in _game_state.get_completed_case_reports():
		if typeof(report) == TYPE_DICTIONARY and String(report.get("episode_id", "")) == episode_id:
			return true
	return false


func _check(condition: bool, label: String) -> void:
	if condition:
		_passed += 1
		print("  PASS: %s" % label)
	else:
		_failed += 1
		push_error("  FAIL: %s" % label)
