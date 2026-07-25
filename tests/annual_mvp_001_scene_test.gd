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
		"QuarterSummaryPanel", "FeedbackLabel", "Footer", "BackButton",
		"ConfirmButton", "SaveButton", "LoadButton"
	]
	for node_name in required:
		_expect(_scene.find_child(node_name, true, false) != null, "missing node %s" % node_name)

	_expect(_scene.has_method("debug_snapshot"), "scene should expose debug_snapshot")
	_expect(_scene.has_method("debug_select_activity"), "scene should expose activity selection")
	_expect(_scene.has_method("debug_confirm"), "scene should expose confirm action")
	_expect(_scene.has_method("debug_visible_panel"), "scene should expose visible phase panel")
	_expect(_scene.has_method("debug_force_incident_phase"), "scene should expose test-only incident phase")
	if not _scene.has_method("debug_snapshot"):
		_finish()
		return

	var initial: Dictionary = _scene.call("debug_snapshot")
	_expect(initial.get("phase") == "WEEK_PLANNING", "scene should start in week planning")
	_expect(_scene.call("debug_visible_panel") == "WeekPlanningPanel", "only week planning panel should be visible")
	var week_label := _scene.find_child("WeekLabel", true, false) as Label
	_expect(week_label != null and week_label.text.contains("/ 4"), "week label should expose the four-week month")
	var before: Dictionary = initial.duplicate(true)
	_scene.call("debug_select_activity", "annual001_activity_rest")
	_scene.call("debug_select_activity", "annual001_activity_rest")
	_expect(_scene.call("debug_snapshot") == before, "selecting fewer than three activities must not mutate state")
	_scene.call("debug_select_activity", "annual001_activity_observation_drill")
	_expect(_scene.call("debug_snapshot") == before, "selecting three activities still waits for confirmation")
	_scene.call("debug_confirm")
	await process_frame
	var after: Dictionary = _scene.call("debug_snapshot")
	_expect(after.get("phase") == "WEEK_RESULT", "confirm should commit the three selected activities")
	_expect(_scene.call("debug_visible_panel") == "WeekResultPanel", "week result should be the only visible panel")

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
