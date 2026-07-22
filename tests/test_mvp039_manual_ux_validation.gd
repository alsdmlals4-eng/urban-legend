extends SceneTree

## Reproducible MVP-039 walkthrough for the two implemented cases.
## It uses the real scenes and response handlers, while TestSaveGuard restores
## the player's save after the validation run.

const TestSaveGuard = preload("res://tests/test_save_guard.gd")
const EPISODES := [
	{"id": "episode_001_afterlife_station", "label": "afterlife_station", "path": "res://data/episodes/episode_001_afterlife_station.json"},
	{"id": "episode_002_red_umbrella_alley", "label": "red_umbrella_alley", "path": "res://data/episodes/episode_002_red_umbrella_alley.json"}
]
const STANDARD_TEAM := ["agent_kang_ijun", "agent_kwon_narae", "agent_oh_hyun"]

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

	for episode in EPISODES:
		await _validate_route(episode, false)
		await _validate_route(episode, true)

	var restore_error := _guard.restore()
	if not restore_error.is_empty():
		push_error(restore_error)
		_failed += 1
	print("MVP-039 manual UX validation: %d passed, %d failed" % [_passed, _failed])
	quit(0 if _failed == 0 else 1)


func _validate_route(episode: Dictionary, include_wrong_response: bool) -> void:
	var case_id := String(episode.get("label", episode.get("id", "case")))
	var route_label := "%s / %s" % [case_id, "wrong-response then success" if include_wrong_response else "success"]
	_check(_game_state.start_episode_from_preparation(String(episode.get("path", ""))), "%s starts" % route_label)
	_game_state.set_selected_agent_ids(STANDARD_TEAM)

	await _change_scene("res://scenes/investigation_scene.tscn")
	var investigation := current_scene
	var point := _first_method_point()
	_check(not point.is_empty(), "%s has an investigation method" % route_label)
	if point.is_empty():
		return
	var methods: Array = point.get("method_options", [])
	var method: Dictionary = methods[0].duplicate(true) if not methods.is_empty() else {}
	investigation.call("_show_method_options", point)
	investigation.call("_run_method_option", point, method)
	await process_frame
	var method_result: Dictionary = _game_state.get_method_results().get(String(point.get("id", "")), {})
	var investigation_text := String(investigation.call("_make_method_result_text", method_result))
	_check(_contains_all(investigation_text, ["현재 상황", "확보 근거", "추론 방향", "다음 판단"]), "%s investigation explains the current judgment" % route_label)

	_prepare_complete_evidence()
	_check(_game_state.start_resolution_phase(), "%s enters recovery" % route_label)
	_check(_game_state.save_game(), "%s saves before recovery" % route_label)
	_game_state.reset_run_state()
	_check(_game_state.load_game(), "%s resumes before recovery" % route_label)
	_check(_game_state.get_current_episode_id() == String(episode.get("id", "")), "%s keeps episode after resume" % route_label)

	await _change_scene("res://scenes/battle_scene.tscn")
	var battle := current_scene
	var first_pattern: Dictionary = battle.get("_current_pattern")
	_check(not first_pattern.is_empty(), "%s displays a recovery telegraph" % route_label)
	var opening_evidence := String(battle.call("_make_recovery_evidence_text"))
	_check(_contains_all(opening_evidence, ["전조", "연결 단서", "오대응 학습", "다음 판단"]), "%s distinguishes recovery evidence" % route_label)

	if include_wrong_response:
		var wrong_response := _find_wrong_response(first_pattern)
		_check(not wrong_response.is_empty(), "%s has an intentional wrong response" % route_label)
		await _resolve_pattern_choice(battle, wrong_response, true)
		var learning: Dictionary = _game_state.get_recovery_pattern_learning().get(String(first_pattern.get("id", "")), {})
		_check(not learning.is_empty() and not bool(learning.get("correct", true)), "%s records the wrong-response reason" % route_label)
		var result_label := battle.get("_result_label") as Label
		_check(result_label != null and result_label.text.contains(String(first_pattern.get("failure_reason", ""))), "%s keeps the wrong-response reason beside the next telegraph" % route_label)
		_check(not Dictionary(battle.get("_current_pattern")).is_empty(), "%s automatically exposes the next telegraph" % route_label)

	for turn in range(8):
		if bool(battle.call("_can_recover")):
			break
		var pattern: Dictionary = battle.get("_current_pattern")
		var correct_response := _find_correct_response(pattern)
		_check(not correct_response.is_empty(), "%s has a supported correct response on turn %d" % [route_label, turn + 1])
		if correct_response.is_empty():
			break
		await _resolve_pattern_choice(battle, correct_response, false)

	_check(bool(battle.call("_can_recover")), "%s reaches recovery with evidence-supported responses" % route_label)
	battle.call("_recover_anomaly_core")
	await process_frame
	await process_frame
	var result := current_scene
	var reasoning_summary := result.find_child("ReasoningSummary", true, false)
	_check(reasoning_summary != null, "%s result shows the reasoning summary" % route_label)
	var reports: Array = _game_state.get_completed_case_reports()
	_check(_has_report(reports, String(episode.get("id", ""))), "%s records the completed report for the database" % route_label)
	var report := _report_for_episode(reports, String(episode.get("id", "")))
	_check(not Array(report.get("selected_agents", [])).is_empty() and not Array(report.get("next_case_notes", [])).is_empty(), "%s report includes agent contribution and next judgment" % route_label)

	_check(_game_state.save_game(), "%s saves result and database record" % route_label)
	_game_state.reset_run_state()
	_check(_game_state.load_game(), "%s resumes result and database record" % route_label)
	_check(_has_report(_game_state.get_completed_case_reports(), String(episode.get("id", ""))), "%s keeps report after result resume" % route_label)


func _change_scene(scene_path: String) -> void:
	var error := change_scene_to_file(scene_path)
	_check(error == OK, "loads %s" % scene_path)
	await process_frame
	await process_frame


func _first_method_point() -> Dictionary:
	for point in _game_state.get_investigation_points():
		if typeof(point) == TYPE_DICTIONARY and not Array(point.get("method_options", [])).is_empty():
			return point.duplicate(true)
	return {}


func _prepare_complete_evidence() -> void:
	for clue in _game_state.get_clues():
		if typeof(clue) == TYPE_DICTIONARY:
			_game_state.collect_clue(String(clue.get("id", "")))
	for hint in _game_state.get_hints():
		if typeof(hint) == TYPE_DICTIONARY:
			_game_state.mark_hint_seen(String(hint.get("id", "")))


func _resolve_pattern_choice(battle: Node, response: Dictionary, prefer_contradiction: bool) -> void:
	if bool(battle.call("_uses_guided_decision_flow")):
		battle.call("_select_hypothesis", response)
		await process_frame
		var evidence_key := "contradicted_clue_ids" if prefer_contradiction else "supporting_clue_ids"
		for clue_id_value in response.get(evidence_key, []):
			var clue_id := String(clue_id_value)
			if _game_state.has_collected_clue(clue_id):
				battle.call("_toggle_evidence", clue_id)
				await process_frame
				break
		battle.call("_confirm_evidence_step")
		await process_frame
	battle.call("_select_pattern_response", response)
	await process_frame


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


func _report_for_episode(reports: Array, episode_id: String) -> Dictionary:
	for report in reports:
		if typeof(report) == TYPE_DICTIONARY and String(report.get("episode_id", "")) == episode_id:
			return report.duplicate(true)
	return {}


func _has_report(reports: Array, episode_id: String) -> bool:
	return not _report_for_episode(reports, episode_id).is_empty()


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
