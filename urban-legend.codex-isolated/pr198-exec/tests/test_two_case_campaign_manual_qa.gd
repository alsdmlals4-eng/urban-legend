extends SceneTree

## Reproducible full-campaign QA for the two implemented cases.
## The run uses the same campaign state, scene transition, save, report, and
## request APIs as play, while TestSaveGuard restores the player's save.

const TestSaveGuard = preload("res://tests/test_save_guard.gd")
const AFTERLIFE_PATH := "res://data/episodes/episode_001_afterlife_station.json"
const RED_UMBRELLA_PATH := "res://data/episodes/episode_002_red_umbrella_alley.json"
const AFTERLIFE_ID := "episode_001_afterlife_station"
const RED_UMBRELLA_ID := "episode_002_red_umbrella_alley"
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
	var guard_error := _guard.prepare("user://urban_legend_save.json")
	if not guard_error.is_empty():
		push_error(guard_error)
		quit(1)
		return

	_game_state.reset_run_state()
	_game_state.set_selected_agent_ids(TEAM)
	_check(_same_members(_game_state.get_selected_agent_ids(), TEAM), "temporary three-agent team including Oh Hyun is selectable")

	await _run_afterlife_with_hq_return()
	await _run_red_umbrella_case()
	_run_faction_request()
	_run_remaining_half_days_to_demo_end()

	var restore_error := _guard.restore()
	if not restore_error.is_empty():
		push_error(restore_error)
		_failed += 1
	print("Two-case campaign manual QA: %d passed, %d failed" % [_passed, _failed])
	quit(0 if _failed == 0 else 1)


func _run_afterlife_with_hq_return() -> void:
	_check(_assign_current_slot("investigation"), "day 1 morning schedules the full team for investigation")
	_check(_game_state.set_campaign_planned_case(AFTERLIFE_ID), "afterlife is planned")
	_check(_game_state.begin_campaign_operation(AFTERLIFE_ID), "afterlife operation begins")
	await _change_scene("res://scenes/investigation_scene.tscn")
	current_scene.call("_return_to_hq")
	await process_frame
	await process_frame
	_check(current_scene.scene_file_path == "res://scenes/preparation_scene.tscn", "HQ return opens preparation")
	_check(String(_game_state.get_active_campaign_operation().get("status", "")) == "suspended", "HQ return suspends the morning operation")
	_check(_game_state.save_game(), "suspended operation saves")
	_game_state.reset_run_state()
	_check(_game_state.load_game(), "suspended operation resumes from save")
	_check(_same_members(_game_state.get_selected_agent_ids(), TEAM), "three-agent team survives suspended-operation load")
	_check(String(_game_state.get_active_campaign_operation().get("status", "")) == "suspended", "operation remains suspended after load")
	_check(_game_state.resume_campaign_operation(), "suspended operation resumes")
	_complete_current_case(AFTERLIFE_ID)
	_check(_game_state.finish_campaign_operation_day().get("advanced", false), "afterlife completes one morning slot")
	var advance: Dictionary = _game_state.acknowledge_campaign_slot_result()
	_check(String(advance.get("time_slot", "")) == "afternoon" and int(advance.get("day", 0)) == 1, "afterlife result advances to day 1 afternoon")
	_complete_rest_slot("afterlife afternoon")


func _run_red_umbrella_case() -> void:
	_check(int(_game_state.get_campaign_snapshot().get("day", 0)) == 2, "red umbrella starts on day 2 morning")
	_check(_game_state.load_episode(RED_UMBRELLA_PATH), "red umbrella episode loads without resetting campaign")
	_check(_assign_current_slot("investigation"), "day 2 morning schedules the full team for investigation")
	_check(_game_state.set_campaign_planned_case(RED_UMBRELLA_ID), "red umbrella is planned")
	_check(_game_state.begin_campaign_operation(RED_UMBRELLA_ID), "red umbrella operation begins")
	_complete_current_case(RED_UMBRELLA_ID)
	_check(_game_state.finish_campaign_operation_day().get("advanced", false), "red umbrella completes one morning slot")
	var advance: Dictionary = _game_state.acknowledge_campaign_slot_result()
	_check(String(advance.get("time_slot", "")) == "afternoon" and int(advance.get("day", 0)) == 2, "red umbrella result advances to day 2 afternoon")
	_complete_rest_slot("red umbrella afternoon")


func _complete_current_case(expected_episode_id: String) -> void:
	_prepare_complete_evidence()
	_check(_game_state.start_resolution_phase(), "%s enters recovery" % expected_episode_id)
	_game_state.save_recovery_result(true, "core_recovered", 100)
	_check(_game_state.record_current_case_report(), "%s writes a case report" % expected_episode_id)
	_check(_has_report(expected_episode_id), "%s appears in the database" % expected_episode_id)
	_check(_game_state.save_game(), "%s report saves" % expected_episode_id)
	_game_state.reset_run_state()
	_check(_game_state.load_game(), "%s report resumes" % expected_episode_id)
	_check(_has_report(expected_episode_id), "%s database report survives load" % expected_episode_id)


func _run_faction_request() -> void:
	var board: Array = _game_state.get_faction_request_board()
	_check(board.size() == 3, "request board keeps three slots after two cases")
	var request := _first_offered_request(board)
	_check(not request.is_empty(), "an offered faction request is available")
	if request.is_empty():
		return
	var instance_id := String(request.get("instance_id", ""))
	_check(_game_state.accept_faction_request(instance_id), "faction request is accepted")
	var result: Dictionary = _game_state.resolve_faction_request(instance_id, "agent_oh_hyun", 1)
	_check(not result.has("error"), "Oh Hyun can complete a temporary faction request")
	_check(_game_state.get_completed_faction_requests().has(instance_id), "faction request completion is recorded")


func _run_remaining_half_days_to_demo_end() -> void:
	var safety := 0
	while not bool(_game_state.get_campaign_snapshot().get("demo_ended", false)) and safety < 20:
		safety += 1
		_complete_rest_slot("remaining campaign slot %d" % safety)
	var final_state: Dictionary = _game_state.get_campaign_snapshot()
	_check(safety <= 20, "campaign completion loop remains bounded")
	_check(int(final_state.get("day", 0)) == 10 and bool(final_state.get("demo_ended", false)), "day 10 completion ends the demo")
	var cases: Dictionary = final_state.get("cases", {})
	_check(String(cases.get(AFTERLIFE_ID, {}).get("resolution_state", "")) == "resolved", "afterlife stays resolved through the campaign")
	_check(String(cases.get(RED_UMBRELLA_ID, {}).get("resolution_state", "")) == "resolved", "red umbrella stays resolved through the campaign")


func _complete_rest_slot(label: String) -> void:
	_check(_assign_current_slot("rest"), "%s schedules the full team" % label)
	var result: Dictionary = _game_state.resolve_non_investigation_campaign_slot(TEAM)
	_check(not result.has("error"), "%s completes" % label)
	var advance: Dictionary = _game_state.acknowledge_campaign_slot_result()
	_check(bool(advance.get("advanced", false)) or bool(advance.get("demo_ended", false)), "%s is acknowledged" % label)


func _assign_current_slot(activity_id: String) -> bool:
	var slot := String(_game_state.get_campaign_snapshot().get("time_slot", ""))
	var all_assigned := not slot.is_empty()
	for agent_id in TEAM:
		all_assigned = bool(_game_state.set_campaign_schedule(agent_id, slot, activity_id)) and all_assigned
	return all_assigned


func _prepare_complete_evidence() -> void:
	for clue in _game_state.get_clues():
		if typeof(clue) == TYPE_DICTIONARY:
			_game_state.collect_clue(String(clue.get("id", "")))
	for hint in _game_state.get_hints():
		if typeof(hint) == TYPE_DICTIONARY:
			_game_state.mark_hint_seen(String(hint.get("id", "")))


func _has_report(episode_id: String) -> bool:
	for report in _game_state.get_completed_case_reports():
		if typeof(report) == TYPE_DICTIONARY and String(report.get("episode_id", "")) == episode_id:
			return true
	return false


func _first_offered_request(board: Array) -> Dictionary:
	for request in board:
		if typeof(request) == TYPE_DICTIONARY and String(request.get("status", "")) == "offered":
			return request.duplicate(true)
	return {}


func _change_scene(scene_path: String) -> void:
	var error := change_scene_to_file(scene_path)
	_check(error == OK, "loads %s" % scene_path)
	await process_frame
	await process_frame


func _same_members(actual: Array, expected: Array) -> bool:
	if actual.size() != expected.size():
		return false
	for agent_id in expected:
		if not actual.has(agent_id):
			return false
	return true


func _check(condition: bool, label: String) -> void:
	if condition:
		_passed += 1
		print("  PASS: %s" % label)
	else:
		_failed += 1
		push_error("  FAIL: %s" % label)
