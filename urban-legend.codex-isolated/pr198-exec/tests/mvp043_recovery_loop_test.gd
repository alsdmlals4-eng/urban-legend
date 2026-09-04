extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")

var _guard := TestSaveGuard.new()
var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node("GameState")
	var error := _guard.prepare(game_state.get_save_file_path())
	if not error.is_empty():
		_failures.append(error)
		_finish()
		return
	game_state.reset_run_state()
	game_state.load_episode("res://data/episodes/episode_001_afterlife_station.json")
	game_state.set_selected_agent_ids(["agent_kwon_narae", "agent_oh_hyun", "agent_kang_ijun"])
	if change_scene_to_file(game_state.SCENE_BATTLE) != OK:
		_failures.append("recovery scene failed to load")
		_finish()
		return
	for _frame in range(5):
		await process_frame
	var response_scroll := current_scene.find_child("ResponseScroll", true, false)
	var response_grid := current_scene.find_child("ResponseGrid", true, false) as GridContainer
	var consumables := current_scene.find_child("ConsumableRow", true, false) as HBoxContainer
	_expect(response_scroll == null, "recovery action choices should not use the old response scroll")
	_expect(response_grid != null and response_grid.columns == 3, "recovery choices should use one horizontal three-card row")
	_expect(consumables != null, "consumables should have a separate auxiliary row")
	var initial_pattern: Dictionary = current_scene.get("_current_pattern")
	var responses: Array = initial_pattern.get("responses", [])
	_expect(not responses.is_empty(), "automatic telegraph should expose authored hypotheses")
	_expect(bool(current_scene.call("_uses_guided_decision_flow")), "afterlife recovery should use the guided hypothesis-evidence-response flow")
	_expect(int(current_scene.get("_decision_step")) == 1, "guided recovery should start at the hypothesis step")
	if not responses.is_empty():
		var correct_response := _find_correct_response(initial_pattern)
		current_scene.call("_select_hypothesis", correct_response)
		await process_frame
		current_scene.call("_confirm_evidence_step")
		await process_frame
		_expect(int(current_scene.get("_decision_step")) == 3, "no-evidence route should still reach the response step with an explicit warning")
		current_scene.call("_select_pattern_response", correct_response)
		await process_frame
		var result_label := current_scene.find_child("ResultLabel", true, false) as Label
		var telegraph_label := current_scene.find_child("TelegraphLabel", true, false) as Label
		_expect(result_label != null and result_label.text.contains("직전 결과"), "the previous action result should remain visible")
		_expect(telegraph_label != null and (telegraph_label.text.contains("괴이의 전조") or telegraph_label.text.contains("회수 실행 가능")), "the next telegraph or recovery-ready state should appear automatically")
		_expect(not _visible_button_text(current_scene, "다음 전조 관측"), "manual next-telegraph button must be removed")
	_finish()


func _find_correct_response(pattern: Dictionary) -> Dictionary:
	var correct_id := String(pattern.get("correct_response_id", ""))
	for response in pattern.get("responses", []):
		if typeof(response) == TYPE_DICTIONARY and String(response.get("id", "")) == correct_id:
			return response.duplicate(true)
	return {}


func _visible_button_text(node: Node, text: String) -> bool:
	for button in node.find_children("*", "Button", true, false):
		if String(button.text) == text and button.is_visible_in_tree():
			return true
	return false


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	var restore_error := _guard.restore()
	if not restore_error.is_empty():
		_failures.append(restore_error)
	if _failures.is_empty():
		print("MVP043 RECOVERY LOOP: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
