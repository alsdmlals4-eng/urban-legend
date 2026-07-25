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

	var required := [
		"AnnualMvp001Scene", "SafeFrame", "RootColumn", "Header", "PhaseLabel",
		"WeekLabel", "StatsLabel", "ResourceLabel", "PhaseHost", "WeekPlanningPanel",
		"WeekResultPanel", "DeploymentPanel", "PreparationPanel", "IncidentHost",
		"ResearchPanel", "QuarterSummaryPanel", "FeedbackLabel", "Footer",
		"BackButton", "ConfirmButton", "SaveButton", "LoadButton"
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
	var before := initial.duplicate(true)
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
		root.content_scale_size = size
		await process_frame
		var safe := _scene.find_child("SafeFrame", true, false) as Control
		var footer := _scene.find_child("Footer", true, false) as Control
		_expect(_inside_viewport(safe, size), "SafeFrame should fit %sx%s" % [size.x, size.y])
		_expect(_inside_viewport(footer, size), "Footer should fit %sx%s" % [size.x, size.y])

	_scene.call("debug_force_incident_phase")
	await process_frame
	_expect(_scene.call("debug_visible_panel") == "IncidentHost", "incident phase should show IncidentHost")
	var save_button := _scene.find_child("SaveButton", true, false) as Button
	_expect(save_button != null and save_button.disabled, "save should be disabled during incident")
	_finish()

func _inside_viewport(control: Control, size: Vector2i) -> bool:
	if control == null:
		return false
	var rect := control.get_global_rect()
	return rect.position.x >= -1.0 and rect.position.y >= -1.0 and rect.end.x <= size.x + 1.0 and rect.end.y <= size.y + 1.0

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
