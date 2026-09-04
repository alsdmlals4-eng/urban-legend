extends SceneTree

const RuntimeEditor = preload("res://scripts/ui/runtime_ui_editor.gd")


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node("GameState")
	game_state.load_episode("res://data/episodes/episode_001_afterlife_station.json")
	game_state.set_selected_agent_ids(["agent_kang_ijun", "agent_kwon_narae"])
	if change_scene_to_file("res://scenes/dialogue_scene.tscn") != OK:
		_fail("dialogue scene failed to load")
		return
	for _frame in range(6):
		await process_frame
	var editor: RuntimeUiEditor
	for child in current_scene.get_children():
		if child.get_script() == RuntimeEditor:
			editor = child
			break
	if editor == null:
		_fail("runtime editor node was not created")
		return
	var f2 := InputEventKey.new()
	f2.keycode = KEY_F2
	f2.pressed = true
	Input.parse_input_event(f2)
	await process_frame
	if not editor.is_edit_mode():
		_fail("F2 input did not enable edit mode")
		return

	var before := editor.get_element_rect("cinematic_dialogue_dock")
	if before.size == Vector2.ZERO:
		print("runtime_ui_editor_scene_test: PASS (structural dialogue dock excluded)")
		quit()
		return
	if before.size.x < 720.0 or before.size.y < 220.0:
		_fail("cinematic dialogue dock has an invalid editable rect: %s" % before)
		return
	var press := InputEventMouseButton.new()
	press.button_index = MOUSE_BUTTON_LEFT
	press.pressed = true
	press.position = before.get_center()
	editor.handle_surface_input(press)
	var motion := InputEventMouseMotion.new()
	motion.position = before.get_center() + Vector2(24, 16)
	editor.handle_surface_input(motion)
	var release := InputEventMouseButton.new()
	release.button_index = MOUSE_BUTTON_LEFT
	release.position = motion.position
	editor.handle_surface_input(release)
	var after := editor.get_element_rect("cinematic_dialogue_dock")
	if after.position == before.position or fmod(after.position.x, 8.0) != 0.0 or fmod(after.position.y, 8.0) != 0.0:
		_fail("drag did not persist: before=%s after=%s" % [before, after])
		return
	print("runtime_ui_editor_scene_test: PASS")
	quit()


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
