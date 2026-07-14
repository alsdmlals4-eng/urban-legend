extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")
var _guard := TestSaveGuard.new()


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() < 2:
		push_error("usage: -- <scene_path> <output_path> [episode_id] [editor] [focus_node_name] [ui_state]")
		quit(2)
		return
	var scene_path := String(args[0])
	var output_path := String(args[1])
	var episode_id := String(args[2]) if args.size() > 2 else "episode_001_afterlife_station"
	var episode_paths := {
		"episode_001_afterlife_station": "res://data/episodes/episode_001_afterlife_station.json",
		"episode_002_red_umbrella_alley": "res://data/episodes/episode_002_red_umbrella_alley.json",
		"episode_003_dead_frequency_station": "res://data/episodes/episode_003_dead_frequency_station.json"
	}
	var episode_path := String(episode_paths.get(episode_id, episode_paths["episode_001_afterlife_station"]))
	var game_state := root.get_node("GameState")
	var guard_error := _guard.prepare(game_state.SAVE_FILE_PATH)
	if not guard_error.is_empty():
		push_error("visual capture save guard failed: %s" % guard_error)
		quit(4)
		return
	game_state.load_episode(episode_path)
	game_state.set_selected_agent_ids(["agent_kang_ijun", "agent_kwon_narae", "agent_oh_hyun"])
	var ui_state := String(args[5]) if args.size() > 5 else ""
	if ui_state == "risk_d":
		game_state.investigation_risk = 85
	if ui_state.begins_with("mvp039_"):
		_prepare_mvp039_evidence(game_state)
		if ui_state == "mvp039_result":
			game_state.start_resolution_phase()
			game_state.save_recovery_result(true, "core_recovered", 100)
			game_state.record_current_case_report()
	var error := change_scene_to_file(scene_path)
	if error != OK:
		push_error("failed to load scene: %s" % scene_path)
		_guard.restore()
		quit(error)
		return
	for _frame in range(5):
		await process_frame
	if ui_state == "method_picker" and current_scene.has_method("_get_investigation_points"):
		var points: Array = current_scene.call("_get_investigation_points")
		for point in points:
			if typeof(point) == TYPE_DICTIONARY and not Array(point.get("method_options", [])).is_empty():
				current_scene.call("_show_method_options", point)
				for _frame in range(3):
					await process_frame
				break
	if ui_state == "recovery_evidence" and current_scene.has_method("_toggle_clue_drawer"):
		current_scene.call("_toggle_clue_drawer")
		for _frame in range(3):
			await process_frame
	if ui_state == "mvp039_investigation" and current_scene.has_method("_get_investigation_points"):
		var points: Array = current_scene.call("_get_investigation_points")
		for point in points:
			if typeof(point) == TYPE_DICTIONARY and not Array(point.get("method_options", [])).is_empty():
				var methods: Array = point.get("method_options", [])
				current_scene.call("_show_method_options", point)
				current_scene.call("_run_method_option", point, methods[0])
				for _frame in range(3):
					await process_frame
				break
	if ui_state == "mvp039_recovery" and current_scene.has_method("_select_pattern_response"):
		var pattern: Dictionary = current_scene.get("_current_pattern")
		var wrong_response := _find_wrong_response(pattern)
		if not wrong_response.is_empty():
			current_scene.call("_select_pattern_response", wrong_response)
			for _frame in range(3):
				await process_frame
		current_scene.call("_toggle_clue_drawer")
		for _frame in range(3):
			await process_frame
	if args.size() > 3 and String(args[3]) == "editor":
		var f2 := InputEventKey.new()
		f2.keycode = KEY_F2
		f2.pressed = true
		Input.parse_input_event(f2)
		for _frame in range(3):
			await process_frame
	if args.size() > 4:
		var focus_control := current_scene.find_child(String(args[4]), true, false) as Control
		var scroll := _find_scroll_container(focus_control)
		if focus_control != null and scroll != null:
			scroll.ensure_control_visible(focus_control)
			for _frame in range(3):
				await process_frame
	var image := root.get_viewport().get_texture().get_image()
	if image == null or image.is_empty():
		push_error("captured image is empty")
		_guard.restore()
		quit(3)
		return
	var save_error := image.save_png(output_path)
	if save_error != OK:
		push_error("failed to save capture: %s" % output_path)
		_guard.restore()
		quit(save_error)
		return
	print("UI CAPTURE: %s %dx%d" % [output_path, image.get_width(), image.get_height()])
	var restore_error := _guard.restore()
	if not restore_error.is_empty():
		push_error("visual capture save restore failed: %s" % restore_error)
		quit(5)
		return
	quit(0)


func _find_scroll_container(control: Control) -> ScrollContainer:
	var current: Node = control
	while current != null:
		if current is ScrollContainer:
			return current as ScrollContainer
		current = current.get_parent()
	return null


func _prepare_mvp039_evidence(game_state: Node) -> void:
	for clue in game_state.get_clues():
		if typeof(clue) == TYPE_DICTIONARY:
			game_state.collect_clue(String(clue.get("id", "")))
	for hint in game_state.get_hints():
		if typeof(hint) == TYPE_DICTIONARY:
			game_state.mark_hint_seen(String(hint.get("id", "")))


func _find_wrong_response(pattern: Dictionary) -> Dictionary:
	var correct_id := String(pattern.get("correct_response_id", ""))
	for response in pattern.get("responses", []):
		if typeof(response) == TYPE_DICTIONARY and String(response.get("id", "")) != correct_id:
			return response.duplicate(true)
	return {}
