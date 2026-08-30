extends SceneTree

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(1920, 1080)
	var packed := load("res://scenes/main_menu.tscn") as PackedScene
	_expect(packed != null, "main menu scene must load")
	if packed == null:
		_finish()
		return
	var menu := packed.instantiate() as Control
	_expect(menu != null, "main menu must instantiate as a Control")
	if menu == null:
		_finish()
		return
	root.add_child(menu)
	for _frame in range(4):
		await process_frame
	var preview := menu.find_child("CurrentCasePreview", true, false) as Control
	_expect(preview != null, "main menu must provide the current-case preview")
	_expect(preview != null and preview.visible, "1920x1080 window must show the current-case preview even with a 1280x720 canvas baseline")
	menu.queue_free()
	for _frame in range(3):
		await process_frame
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("MAIN MENU WINDOW BREAKPOINT: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
