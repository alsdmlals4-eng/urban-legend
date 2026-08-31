extends SceneTree

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(1280, 720)
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
	var summary := menu.find_child("CurrentCaseSummary", true, false) as Control
	_expect(preview != null, "main menu must provide the current-case preview")
	_expect(summary != null, "main menu must provide the current-case summary")
	_expect(preview != null and not preview.visible, "1280x720 must hide the current-case preview")
	_expect(summary != null and not summary.visible, "1280x720 must hide the current-case summary")
	_expect(menu.has_method("_is_compact_for_sizes"), "main menu must expose a physical-window breakpoint helper")
	if menu.has_method("_is_compact_for_sizes"):
		_expect(
			bool(menu.call("_is_compact_for_sizes", Vector2(1280.0, 720.0), Vector2(1280.0, 720.0))),
			"1280x720 logical and physical sizes must use the compact layout"
		)
		_expect(
			not bool(menu.call("_is_compact_for_sizes", Vector2(1280.0, 720.0), Vector2(1920.0, 1080.0))),
			"1920x1080 physical window must override the 1280x720 canvas baseline"
		)
	for node_name in ["M04CampaignEntryButton", "DatabaseButton", "SettingsButton", "ExitButton"]:
		var action := menu.find_child(node_name, true, false) as Control
		_expect(action != null and _inside_viewport(action), "%s must remain reachable inside 1280x720 compact layout" % node_name)
	menu.queue_free()
	for _frame in range(3):
		await process_frame
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _inside_viewport(control: Control) -> bool:
	if control == null or not control.is_visible_in_tree():
		return false
	return Rect2(Vector2.ZERO, Vector2(root.size)).encloses(control.get_global_rect())


func _finish() -> void:
	if _failures.is_empty():
		print("MAIN MENU WINDOW BREAKPOINT: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
