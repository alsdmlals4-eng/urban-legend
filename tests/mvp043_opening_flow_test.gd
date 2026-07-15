# MVP-043 신규 캠페인이 공식 도입과 저승역 3인 고정 투입을 거치는지 검증한다.
extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")

var _guard := TestSaveGuard.new()
var _prepared := false
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
	_prepared = true
	_expect(game_state.restart_afterlife_station_flow(), "afterlife opening fixture should start")
	_expect(game_state.get_selected_agent_ids() == ["agent_kwon_narae", "agent_oh_hyun", "agent_kang_ijun"], "afterlife opening should force Kwon Narae as protagonist with the approved supports")
	if change_scene_to_file(game_state.SCENE_DIALOGUE) != OK:
		_failures.append("dialogue scene failed to load")
		_finish()
		return
	for _frame in range(4):
		await process_frame
	var scene := current_scene
	var dialogue_label := scene.get("_dialogue_label") as Label
	_expect(dialogue_label != null and dialogue_label.text.contains("마음과 기억"), "opening should explain that anomalies recur from mind and memory")
	for _index in range(3):
		scene.call("_advance_line")
	var choice_box := scene.get("_choice_box") as VBoxContainer
	_expect(choice_box != null and choice_box.get_child_count() == 1, "opening should have one explicit dispatch choice")
	if choice_box != null and choice_box.get_child_count() == 1:
		var dispatch_button := choice_box.get_child(0) as Button
		_expect(dispatch_button != null and dispatch_button.text.contains("저승역 긴급 조사"), "opening dispatch choice should identify the afterlife station")
		if dispatch_button != null:
			dispatch_button.emit_signal("pressed")
			scene.call("_advance_line")
			for _frame in range(4):
				await process_frame
			_expect(current_scene.scene_file_path == game_state.SCENE_INVESTIGATION, "opening dispatch should enter the investigation scene")
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _prepared:
		var restore_error := _guard.restore()
		if not restore_error.is_empty():
			_failures.append(restore_error)
		_prepared = false
	if _failures.is_empty():
		print("MVP043 OPENING FLOW: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
