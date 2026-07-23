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
		"PhaseHost",
		"InvestigationPanel",
		"InvestigationScroll",
		"HypothesisPanel",
		"HypothesisScroll",
		"FieldTestPanel",
		"FieldTestScroll",
		"RecoveryPanel",
		"RecoveryScroll",
		"ResultPanel",
		"ResultScroll",
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
	_expect(_visible_phase_panels(scene) == ["InvestigationPanel"], "only investigation panel should be active initially")

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

	scene.call(
		"debug_link_record_to_choice",
		"poc001_manual_personal_destination",
		"poc001_choice_follow_passenger_count"
	)
	scene.call("debug_confirm_current_step")
	await process_frame
	_expect(scene.call("debug_snapshot").get("phase") == "HYPOTHESIS_AUTHORING", "two eliminations should advance to hypothesis authoring")
	_expect(_visible_phase_panels(scene) == ["HypothesisPanel"], "hypothesis step should show one panel")

	scene.call("debug_review_previous_panel")
	await process_frame
	_expect(_visible_phase_panels(scene) == ["InvestigationPanel"], "back should show the previous panel without changing state")
	_expect(scene.call("debug_snapshot").get("eliminated_choice_ids", []).size() == 2, "reviewing a previous panel should preserve selections")
	scene.call("debug_return_to_current_panel")
	await process_frame
	_expect(_visible_phase_panels(scene) == ["HypothesisPanel"], "return should restore the current state panel")

	var focus_owner := scene.get_viewport().gui_get_focus_owner()
	_expect(focus_owner is Button, "scene should restore keyboard focus to a button")
	_expect(not FileAccess.file_exists(game_state.get_save_file_path()), "isolated PoC should not create the campaign save")
	_finish()


func _visible_phase_panels(scene: Node) -> Array[String]:
	var visible: Array[String] = []
	for node_name in ["InvestigationPanel", "HypothesisPanel", "FieldTestPanel", "RecoveryPanel", "ResultPanel"]:
		var panel := scene.find_child(node_name, true, false) as Control
		if panel != null and panel.visible:
			visible.append(node_name)
	return visible


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
