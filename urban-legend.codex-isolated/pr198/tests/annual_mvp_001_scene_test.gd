extends SceneTree

const SCENE_PATH := "res://scenes/poc/annual_mvp_001/annual_mvp_001_scene.tscn"

var _failures: Array[String] = []
var _scene: Control

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var packed := load(SCENE_PATH) as PackedScene
	_expect(packed != null, "annual scene should load")
	if packed == null:
		_finish()
		return
	_scene = packed.instantiate() as Control
	root.add_child(_scene)
	for _frame in range(5):
		await process_frame

	_expect(_scene.name == "AnnualMvp001Scene", "annual scene root name should match contract")
	var required := [
		"SafeFrame", "RootColumn", "Header", "PhaseLabel", "WeekLabel", "StatsLabel",
		"ResourceLabel", "PhaseHost", "WeekPlanningPanel", "WeekResultPanel",
		"DeploymentPanel", "PreparationPanel", "IncidentHost", "ResearchPanel",
		"QuarterSummaryPanel", "FeedbackLabel", "PlanningSelectionLabel", "Footer", "BackButton",
		"ConfirmButton", "SaveButton", "LoadButton"
	]
	for node_name in required:
		_expect(_scene.find_child(node_name, true, false) != null, "missing node %s" % node_name)

	for method_name in [
		"debug_snapshot", "debug_select_activity", "debug_confirm", "debug_visible_panel",
		"debug_force_incident_phase", "debug_selected_days"
	]:
		_expect(_scene.has_method(method_name), "scene should expose %s" % method_name)
	if not _scene.has_method("debug_snapshot"):
		_finish()
		return

	var initial: Dictionary = _scene.call("debug_snapshot")
	_expect(initial.get("phase") == "WEEK_PLANNING", "scene should start in week planning")
	_expect(_scene.call("debug_visible_panel") == "WeekPlanningPanel", "only week planning panel should be visible")
	var week_label := _scene.find_child("WeekLabel", true, false) as Label
	_expect(week_label != null and week_label.text.contains("/ 4"), "week label should expose the four-week month")
	var selection_label := _scene.find_child("PlanningSelectionLabel", true, false) as Label
	_expect(selection_label != null and selection_label.text.contains("사용 0/7일"), "planning should expose the seven-day budget")
	var field_button := _scene.find_child("ActivityButton_annual001_activity_field_training", true, false) as Button
	_expect(field_button != null and field_button.text.contains("3일"), "activity button should expose day cost")

	var before: Dictionary = initial.duplicate(true)
	_scene.call("debug_select_activity", "annual001_activity_field_training")
	_scene.call("debug_select_activity", "annual001_activity_field_training")
	_expect(_scene.call("debug_snapshot") == before, "planning selections must not mutate state")
	_expect(int(_scene.call("debug_selected_days")) == 6, "two field trainings should use six days")
	await process_frame
	_expect(field_button != null and field_button.disabled, "three-day activity should be disabled when one day remains")
	var rest_button := _scene.find_child("ActivityButton_annual001_activity_rest", true, false) as Button
	_expect(rest_button != null and not rest_button.disabled, "one-day direct rest should remain selectable")

	_scene.call("debug_confirm")
	await process_frame
	var warned: Dictionary = _scene.call("debug_snapshot")
	_expect(warned.get("phase") == "WEEK_PLANNING", "first underfilled confirmation should stay in planning")
	var feedback := _scene.find_child("FeedbackLabel", true, false) as Label
	_expect(feedback != null and feedback.text.contains("자동 휴식"), "first confirmation should warn about automatic rest")
	_expect(int(_scene.call("debug_selected_days")) == 6, "warning should preserve the selected plan")
	var confirm := _scene.find_child("ConfirmButton", true, false) as Button
	_expect(confirm != null and confirm.text == "자동 휴식 후 확정", "warning should change the confirm action")

	_scene.call("debug_confirm")
	await process_frame
	var after: Dictionary = _scene.call("debug_snapshot")
	_expect(after.get("phase") == "WEEK_RESULT", "second confirmation should commit with automatic rest")
	_expect(int((after.get("last_week_result", {}) as Dictionary).get("auto_rest_days", 0)) == 1, "one unused day should become automatic rest")
	_expect(_scene.call("debug_visible_panel") == "WeekResultPanel", "week result should be the only visible panel")
	var result_label := _scene.find_child("WeekResultLabel", true, false) as Label
	_expect(result_label != null and result_label.text.contains("자동 휴식 1일"), "week result should distinguish automatic rest")

	for size in [Vector2i(1280, 720), Vector2i(1920, 1080)]:
		root.size = size
		for _frame in range(3):
			await process_frame
		var viewport_rect := Rect2(Vector2.ZERO, Vector2(size))
		for node_name in ["SafeFrame", "RootColumn", "PhaseHost", "Footer", "BackButton", "ConfirmButton", "SaveButton", "LoadButton"]:
			var control := _scene.find_child(node_name, true, false) as Control
			_expect(control != null, "%s should exist at %s" % [node_name, size])
			if control == null:
				continue
			var rect := control.get_global_rect()
			_expect(rect.size.x > 0.0 and rect.size.y > 0.0, "%s should have positive size at %s" % [node_name, size])
			_expect(viewport_rect.encloses(rect), "%s should fit %s" % [node_name, size])

	_scene.call("debug_force_incident_phase")
	await process_frame
	_expect(_scene.call("debug_visible_panel") == "IncidentHost", "incident phase should show IncidentHost")
	var save_button := _scene.find_child("SaveButton", true, false) as Button
	_expect(save_button != null and save_button.disabled, "save should be disabled during incident")
	_finish()

func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)

func _finish() -> void:
	if _scene != null:
		_scene.queue_free()
	if _failures.is_empty():
		print("ANNUAL MVP 001 SCENE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
