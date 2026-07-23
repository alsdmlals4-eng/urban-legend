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
	change_scene_to_file("res://scenes/poc/core_mvp_001/core_mvp_001_scene.tscn")
	for _frame in range(6):
		await process_frame

	var scene := current_scene
	_expect(scene != null, "PoC scene should load")
	if scene == null:
		_finish()
		return

	for node_name in [
		"SafeFrame",
		"RootColumn",
		"PhaseLabel",
		"UnderstandingLabel",
		"HealthLabel",
		"RiskLabel",
		"InvestigationPanel",
		"HypothesisPanel",
		"RecoveryPanel",
		"ResultPanel",
		"ChoiceGrid",
		"ManualList",
		"FeedbackLabel",
		"BackButton",
		"ConfirmButton",
		"ExportLogButton"
	]:
		_expect(scene.find_child(node_name, true, false) != null, "%s should exist" % node_name)

	var choices := scene.find_child("ChoiceGrid", true, false)
	var manual := scene.find_child("ManualList", true, false)
	_expect(choices != null and choices.get_child_count() == 4, "initial investigation should show four choices")
	_expect(manual != null and manual.get_child_count() == 3, "initial investigation should show three related records")
	_expect(scene.find_child("InvestigationPanel", true, false).visible, "investigation panel should be active initially")
	_expect(not scene.find_child("HypothesisPanel", true, false).visible, "hypothesis panel should be hidden initially")
	_expect(not scene.find_child("RecoveryPanel", true, false).visible, "recovery panel should be hidden initially")

	var snapshot: Dictionary = scene.call("debug_snapshot")
	_expect(snapshot.get("phase") == "ELIMINATION", "scene should expose the state snapshot")
	var linked: Dictionary = scene.call(
		"debug_link_record_to_choice",
		"poc001_manual_early_movement_reset",
		"poc001_choice_move_before_end"
	)
	await process_frame
	_expect(linked.get("ok", false), "scene should connect manual evidence to a choice")
	_expect(scene.find_child("FeedbackLabel", true, false).text.contains("배제"), "valid elimination should show its reason")

	var focus_owner := scene.get_viewport().gui_get_focus_owner()
	_expect(focus_owner is Button, "scene should restore keyboard focus to a button")
	_expect(not FileAccess.file_exists(game_state.get_save_file_path()), "isolated PoC should not create the campaign save")
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
		print("CORE MVP 001 SCENE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
