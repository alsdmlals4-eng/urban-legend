extends SceneTree

const SCENE_PATH := "res://scenes/poc/annual_mvp_001/annual_mvp_001_scene.tscn"

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed := load(SCENE_PATH) as PackedScene
	_expect(packed != null, "annual scene should load")
	if packed == null:
		_finish()
		return
	var scene := packed.instantiate() as Control
	root.add_child(scene)
	for _frame in range(8):
		await process_frame

	var initial_focus := root.gui_get_focus_owner()
	_expect(initial_focus is BaseButton, "initial keyboard focus should target an enabled button")
	if initial_focus is BaseButton:
		_expect((initial_focus as BaseButton).is_visible_in_tree(), "initial focus button should be visible")
		_expect(not (initial_focus as BaseButton).disabled, "initial focus button should be enabled")

	var accept := InputEventAction.new()
	accept.action = "ui_accept"
	accept.pressed = true
	Input.parse_input_event(accept)
	await process_frame
	accept.pressed = false
	Input.parse_input_event(accept)
	await process_frame
	var selected_after_accept := scene.get("_selected_activity_ids") as Array
	_expect(selected_after_accept.size() == 1, "ui_accept should activate the focused activity button")

	var cancel := InputEventAction.new()
	cancel.action = "ui_cancel"
	cancel.pressed = true
	Input.parse_input_event(cancel)
	await process_frame
	cancel.pressed = false
	Input.parse_input_event(cancel)
	await process_frame
	var selected_after_cancel := scene.get("_selected_activity_ids") as Array
	_expect(selected_after_cancel.is_empty(), "Esc should remove the latest planning selection")

	scene.queue_free()
	await process_frame
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("ANNUAL MVP 001 INPUT QA: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
