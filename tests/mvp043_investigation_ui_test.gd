# MVP-043 저승역 조사 지점 선택 UI가 빈 화면으로 교착되지 않는지 검증한다.
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
	game_state.reset_run_state()
	game_state.set_current_field_node_id("field_station_investigation")
	if change_scene_to_file(game_state.SCENE_INVESTIGATION) != OK:
		_failures.append("investigation scene failed to load")
		_finish()
		return
	for _frame in range(4):
		await process_frame

	var scene := current_scene
	var point_dock := scene.find_child("PointMethodDock", true, false) as Control
	var dialogue_dock := scene.find_child("DialogueDock", true, false) as Control
	var points_box := scene.find_child("PointsBox", true, false) as Container
	var return_field_button := scene.find_child("ReturnFieldButton", true, false) as Button
	_expect(point_dock != null and point_dock.visible, "POINT_PICKER should show the point method dock")
	_expect(dialogue_dock != null and not dialogue_dock.visible, "POINT_PICKER should hide the dialogue dock")
	_expect(points_box != null and points_box.get_child_count() > 0, "POINT_PICKER should render available investigation cards")
	if points_box != null and points_box.get_child_count() > 0:
		var first_card := points_box.get_child(0)
		var action_button := first_card.find_child("ActionButton", true, false) as Button
		_expect(action_button != null and not action_button.disabled, "the first investigation card should be selectable")
		_expect(action_button != null and action_button.focus_mode != Control.FOCUS_NONE, "investigation cards should support keyboard focus")
	_expect(return_field_button != null and return_field_button.visible, "afterlife point picker should offer a return path")
	if return_field_button != null:
		return_field_button.emit_signal("pressed")
		_expect(game_state.get_current_field_node_id() == "dialogue_intro", "returning should reopen the first investigation choice")
		_expect(game_state.get_collected_clue_count() == 0, "returning should not invent or discard investigation evidence")
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
		print("MVP043 INVESTIGATION UI: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
