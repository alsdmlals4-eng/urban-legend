extends SceneTree

## Reproducible MVP-041 campaign QA. It proves the third case is discovered
## through normal 10-day campaign risk, then uses the real investigation and
## recovery scene handlers. TestSaveGuard restores the player's save.

const TestSaveGuard = preload("res://tests/test_save_guard.gd")
const AFTERLIFE_ID := "episode_001_afterlife_station"
const AFTERLIFE_PATH := "res://data/episodes/episode_001_afterlife_station.json"
const RED_UMBRELLA_ID := "episode_002_red_umbrella_alley"
const RED_UMBRELLA_PATH := "res://data/episodes/episode_002_red_umbrella_alley.json"
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
	var guard_error := _guard.prepare("user://urban_legend_save.json")
	if not guard_error.is_empty():
		push_error(guard_error)
		quit(1)
		return

	_game_state.reset_run_state()
	_game_state.set_selected_agent_ids(TEAM)
	_check(_same_members(_game_state.get_selected_agent_ids(), TEAM), "temporary three-agent team including Oh Hyun is selectable")
	_check(_case_discovery_state(DEAD_FREQUENCY_ID) == "unknown", "dead frequency begins hidden without a test risk hook")

	await _run_afterlife_with_hq_return()
	await _run_red_umbrella_case()
	_run_faction_request()
	await _advance_to_natural_dead_frequency_discovery()
	await _run_dead_frequency_with_wrong_response()
	_run_remaining_half_days_to_demo_end()

	var restore_error := _guard.restore()
	if not restore_error.is_empty():
		push_error(restore_error)
		_failed += 1
	print("MVP-041 three-case campaign manual QA: %d passed, %d failed" % [_passed, _failed])
	quit(0 if _failed == 0 else 1)


func _run_afterlife_with_hq_return() -> void:
	_check(_assign_current_slot("investigation"), "day 1 morning schedules the full team for investigation")
	_check(_game_state.set_campaign_planned_case(AFTERLIFE_ID), "afterlife is planned")
	_check(_game_state.start_episode_from_preparation(AFTERLIFE_PATH), "afterlife loads from preparation")
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
	_check(_same_members(_game_state.get_selected_agent_ids(), TEAM), "team survives suspended-operation load")
	_check(_game_state.resume_campaign_operation(), "suspended operation resumes")
	_complete_current_case(AFTERLIFE_ID)
	_finish_morning_case(AFTERLIFE_ID, 1)
	_complete_rest_slot("afterlife afternoon")


func _run_red_umbrella_case() -> void:
	_check(int(_game_state.get_campaign_snapshot().get("day", 0)) == 2, "red umbrella starts on day 2 morning")
	_check(_assign_current_slot("investigation"), "day 2 morning schedules the full team for investigation")
	_check(_game_state.set_campaign_planned_case(RED_UMBRELLA_ID), "red umbrella is planned")
	_check(_game_state.start_episode_from_preparation(RED_UMBRELLA_PATH), "red umbrella loads from preparation")
	_check(_game_state.begin_campaign_operation(RED_UMBRELLA_ID), "red umbrella operation begins")
	_complete_current_case(RED_UMBRELLA_ID)
	_finish_morning_case(RED_UMBRELLA_ID, 2)
	_complete_rest_slot("red umbrella afternoon")


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


func _advance_to_natural_dead_frequency_discovery() -> void:
	while int(_game_state.get_campaign_snapshot().get("day", 0)) < 8:
		var snapshot: Dictionary = _game_state.get_campaign_snapshot()
		_complete_rest_slot("day %d %s before dead frequency discovery" % [int(snapshot.get("day", 0)), String(snapshot.get("time_slot", ""))])
		var after_slot: Dictionary = _game_state.get_campaign_snapshot()
		if int(after_slot.get("day", 0)) < 8:
			_check(_case_discovery_state(DEAD_FREQUENCY_ID) == "unknown", "dead frequency remains hidden before day 8")
	var discovered: Dictionary = _game_state.get_campaign_snapshot()
	_check(int(discovered.get("day", 0)) == 8 and String(discovered.get("time_slot", "")) == "morning", "normal half-day flow reaches day 8 morning")
	_check(_case_discovery_state(DEAD_FREQUENCY_ID) == "lead", "dead frequency reaches natural risk-60 discovery")
	_check(_has_preparation_entry(DEAD_FREQUENCY_ID), "naturally discovered dead frequency appears in preparation")
	_check(_game_state.save_game(), "natural discovery saves")
	_game_state.reset_run_state()
	_check(_game_state.load_game(), "natural discovery resumes")
	_check(_case_discovery_state(DEAD_FREQUENCY_ID) == "lead" and _has_preparation_entry(DEAD_FREQUENCY_ID), "saved discovery remains selectable")


func _run_dead_frequency_with_wrong_response() -> void:
	_check(_assign_current_slot("investigation"), "day 8 morning schedules the full team for investigation")
	_check(_game_state.set_campaign_planned_case(DEAD_FREQUENCY_ID), "dead frequency is planned after discovery")
	_check(_game_state.start_episode_from_preparation(DEAD_FREQUENCY_PATH), "dead frequency loads from preparation")
	_check(_game_state.begin_campaign_operation(DEAD_FREQUENCY_ID), "dead frequency operation begins")
	await _change_scene("res://scenes/investigation_scene.tscn")
	var investigation := current_scene
	var point := _first_method_point()
	_check(not point.is_empty(), "dead frequency has an investigation method")
	if not point.is_empty():
		var methods: Array = point.get("method_options", [])
		var method: Dictionary = methods[0].duplicate(true) if not methods.is_empty() else {}
		investigation.call("_show_method_options", point)
		investigation.call("_run_method_option", point, method)
		await process_frame
		var method_result: Dictionary = _game_state.get_method_results().get(String(point.get("id", "")), {})
		var investigation_text := String(investigation.call("_make_method_result_text", method_result))
		_check(_contains_all(investigation_text, ["현재 상황", "확보 근거", "추론 방향", "다음 판단"]), "investigation displays the current text-novel judgment")

	_prepare_complete_evidence()
	_check(_game_state.start_resolution_phase(), "dead frequency enters recovery with complete evidence")
	await _change_scene("res://scenes/battle_scene.tscn")
	var battle := current_scene
	var first_pattern: Dictionary = battle.get("_current_pattern")
	_check(not first_pattern.is_empty(), "dead frequency displays a recovery telegraph")
	var opening_evidence := String(battle.call("_make_recovery_evidence_text"))
	_check(_contains_all(opening_evidence, ["전조", "연결 단서", "오대응 학습", "다음 판단"]), "recovery distinguishes decision evidence")
	var wrong_response := _find_wrong_response(first_pattern)
	_check(not wrong_response.is_empty(), "dead frequency has an intentional wrong response")
	if not wrong_response.is_empty():
		battle.call("_select_pattern_response", wrong_response)
		await process_frame
		var learning: Dictionary = _game_state.get_recovery_pattern_learning().get(String(first_pattern.get("id", "")), {})
		_check(not learning.is_empty() and not bool(learning.get("correct", true)), "wrong response records its reason")
		var result_label := battle.get("_result_label") as Label
		_check(result_label != null and result_label.text.contains(String(first_pattern.get("failure_reason", ""))), "wrong response remains visible beside the automatically exposed next telegraph")
		_check(not Dictionary(battle.get("_current_pattern")).is_empty(), "the next recovery telegraph appears without another input")

	for turn in range(8):
		if bool(battle.call("_can_recover")):
			break
		var pattern: Dictionary = battle.get("_current_pattern")
		var correct_response := _find_correct_response(pattern)
		_check(not correct_response.is_empty(), "dead frequency has a supported correct response on turn %d" % [turn + 1])
		if correct_response.is_empty():
			break
		battle.call("_select_pattern_response", correct_response)
		await process_frame
		if not bool(battle.call("_can_recover")):
			battle.call("_begin_recovery_turn")
			await process_frame

	_check(bool(battle.call("_can_recover")), "dead frequency reaches recovery through evidence-supported responses")
	battle.call("_recover_anomaly_core")
	await process_frame
	await process_frame
	var result := current_scene
	_check(result.find_child("ReasoningSummary", true, false) != null, "result shows the reasoning summary")
	_check(_has_report(DEAD_FREQUENCY_ID), "dead frequency report appears in the database")
	var report := _report_for_episode(DEAD_FREQUENCY_ID)
	_check(not Array(report.get("selected_agents", [])).is_empty() and not Array(report.get("next_case_notes", [])).is_empty(), "report preserves agent contribution and next judgment")
	_check(_game_state.save_game(), "dead frequency result and database save")
	_game_state.reset_run_state()
	_check(_game_state.load_game(), "dead frequency result and database resume")
	_check(_has_report(DEAD_FREQUENCY_ID), "dead frequency report survives the result save")
	_finish_morning_case(DEAD_FREQUENCY_ID, 8)
	_complete_rest_slot("dead frequency afternoon")


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


func _finish_morning_case(case_id: String, day: int) -> void:
	_check(_game_state.finish_campaign_operation_day().get("advanced", false), "%s completes one morning slot" % case_id)
	var advance: Dictionary = _game_state.acknowledge_campaign_slot_result()
	_check(String(advance.get("time_slot", "")) == "afternoon" and int(advance.get("day", 0)) == day, "%s result advances to day %d afternoon" % [case_id, day])


func _run_remaining_half_days_to_demo_end() -> void:
	var safety := 0
	while not bool(_game_state.get_campaign_snapshot().get("demo_ended", false)) and safety < 8:
		safety += 1
		_complete_rest_slot("remaining campaign slot %d" % safety)
	var final_state: Dictionary = _game_state.get_campaign_snapshot()
	_check(safety <= 8, "campaign completion loop remains bounded")
	_check(int(final_state.get("day", 0)) == 10 and bool(final_state.get("demo_ended", false)), "day 10 completion ends the demo")
	for case_id in [AFTERLIFE_ID, RED_UMBRELLA_ID, DEAD_FREQUENCY_ID]:
		_check(String(final_state.get("cases", {}).get(case_id, {}).get("resolution_state", "")) == "resolved", "%s stays resolved through the campaign" % case_id)


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


func _case_discovery_state(case_id: String) -> String:
	return String(_game_state.get_campaign_snapshot().get("cases", {}).get(case_id, {}).get("discovery_state", ""))


func _has_preparation_entry(episode_id: String) -> bool:
	for entry in _game_state.get_preparation_episode_entries():
		if typeof(entry) == TYPE_DICTIONARY and String(entry.get("id", "")) == episode_id:
			return true
	return false


func _first_method_point() -> Dictionary:
	for point in _game_state.get_investigation_points():
		if typeof(point) == TYPE_DICTIONARY and not Array(point.get("method_options", [])).is_empty():
			return point.duplicate(true)
	return {}


func _find_wrong_response(pattern: Dictionary) -> Dictionary:
	var correct_id := String(pattern.get("correct_response_id", ""))
	for response in pattern.get("responses", []):
		if typeof(response) == TYPE_DICTIONARY and String(response.get("id", "")) != correct_id:
			return response.duplicate(true)
	return {}


func _find_correct_response(pattern: Dictionary) -> Dictionary:
	var correct_id := String(pattern.get("correct_response_id", ""))
	for response in pattern.get("responses", []):
		if typeof(response) == TYPE_DICTIONARY and String(response.get("id", "")) == correct_id:
			return response.duplicate(true)
	return {}


func _has_report(episode_id: String) -> bool:
	return not _report_for_episode(episode_id).is_empty()


func _report_for_episode(episode_id: String) -> Dictionary:
	for report in _game_state.get_completed_case_reports():
		if typeof(report) == TYPE_DICTIONARY and String(report.get("episode_id", "")) == episode_id:
			return report.duplicate(true)
	return {}


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


func _contains_all(text: String, required: Array) -> bool:
	for item in required:
		if not text.contains(String(item)):
			return false
	return true


func _check(condition: bool, label: String) -> void:
	if condition:
		_passed += 1
		print("  PASS: %s" % label)
	else:
		_failed += 1
		push_error("  FAIL: %s" % label)
