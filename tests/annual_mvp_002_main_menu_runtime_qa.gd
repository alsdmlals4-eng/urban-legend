extends Node

const TARGET_SCENE := "res://scenes/poc/annual_mvp_002/annual_mvp_002_scene.tscn"


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	for _frame in range(10):
		await get_tree().process_frame
	var menu := get_tree().current_scene
	if menu == null or String(menu.scene_file_path) != "res://scenes/main_menu.tscn":
		_fail("normal project launch did not reach the actual main menu")
		return
	var key := InputEventKey.new()
	key.keycode = KEY_F1
	key.pressed = true
	menu.call("_input", key)
	for _frame in range(4):
		await get_tree().process_frame
	var button := menu.find_child("AnnualMvp002Button", true, false) as Button
	if button == null:
		_fail("actual F1 developer panel is missing AnnualMvp002Button")
		return
	if not button.is_visible_in_tree() or button.disabled:
		_fail("AnnualMvp002Button is not visible and enabled after F1")
		return
	button.emit_signal("pressed")
	for _frame in range(12):
		await get_tree().process_frame
	var current := get_tree().current_scene
	if current == null or String(current.scene_file_path) != TARGET_SCENE:
		_fail("AnnualMvp002Button did not enter the isolated ANNUAL-MVP-002 scene")
		return
	print("ANNUAL MVP 002 MAIN MENU RUNTIME ROUTE: PASS")
	get_tree().quit(0)


func _fail(message: String) -> void:
	push_error(message)
	get_tree().quit(1)
