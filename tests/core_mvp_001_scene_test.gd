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
		"Footer",
		"BackButton",
		"ConfirmButton",
		"ExportLogButton"
	]:
		_expect(scene.find_child(node_name, true, false) != null, "%s should exist" % node_name)

	await _expect_layout_at(scene, Vector2i(1280, 720))
	await _expect_layout_at(scene, Vector2i(1920, 1080))

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
	await _expect_layout_at(scene, Vector2i(1280, 720))
	await _expect_layout_at(scene, Vector2i(1920, 1080))

	var escape := InputEventAction.new()
	escape.action = "ui_cancel"
	escape.pressed = true
	scene.call("_unhandled_input", escape)
	await process_frame
	_expect(_visible_phase_panels(scene) == ["InvestigationPanel"], "Esc should show the previous panel without changing state")
	_expect(scene.call("debug_snapshot").get("phase") == "HYPOTHESIS_AUTHORING", "Esc review should not rewind the state machine")
	_expect(scene.call("debug_snapshot").get("eliminated_choice_ids", []).size() == 2, "Esc review should preserve eliminated choices")
	_expect(_review_controls_are_read_only(scene), "reviewed investigation controls should be read-only")

	scene.call("debug_return_to_current_panel")
	await process_frame
	_expect(_visible_phase_panels(scene) == ["HypothesisPanel"], "return should restore the current state panel")

	var focus_owner := scene.get_viewport().gui_get_focus_owner()
	_expect(focus_owner is Button, "scene should restore keyboard focus to a button")
	_expect(not FileAccess.file_exists(game_state.get_save_file_path()), "isolated PoC should not create the campaign save")
	_finish()


func _expect_layout_at(scene: Control, viewport_size: Vector2i) -> void:
	root.size = viewport_size
	for _frame in range(3):
		await process_frame
	var viewport_rect := Rect2(Vector2.ZERO, Vector2(viewport_size))
	for node_name in ["SafeFrame", "RootColumn", "PhaseHost", "Footer", "BackButton", "ConfirmButton", "ExportLogButton"]:
		var control := scene.find_child(node_name, true, false) as Control
		_expect(control != null, "%s should exist at %s" % [node_name, viewport_size])
		if control == null:
			continue
		var rect := control.get_global_rect()
		_expect(rect.size.x > 0.0 and rect.size.y > 0.0, "%s should have positive size at %s" % [node_name, viewport_size])
		_expect(viewport_rect.encloses(rect), "%s should remain inside %s" % [node_name, viewport_size])
	var visible_panels := _visible_phase_panels(scene)
	_expect(visible_panels.size() == 1, "exactly one phase panel should be visible at %s" % viewport_size)
	if visible_panels.size() == 1:
		var panel := scene.find_child(visible_panels[0], true, false) as Control
		_expect(panel != null and viewport_rect.encloses(panel.get_global_rect()), "visible phase panel should remain inside %s" % viewport_size)


func _review_controls_are_read_only(scene: Node) -> bool:
	var choice_grid := scene.find_child("ChoiceGrid", true, false)
	var manual_list := scene.find_child("ManualList", true, false)
	if choice_grid == null or manual_list == null:
		return false
	for child in choice_grid.get_children():
		if child is Button and not (child as Button).disabled:
			return false
	for child in manual_list.get_children():
		if child is Button and not (child as Button).disabled:
			return false
	return true


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
