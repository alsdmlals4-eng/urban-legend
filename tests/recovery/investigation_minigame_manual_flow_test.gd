extends SceneTree

var failures: Array[String] = []
func _init() -> void:
	call_deferred("run")
func check(value: bool, message: String) -> void:
	if not value:
		failures.append(message)
func labels(node: Node) -> String:
	var text: String = node.text + "\n" if node is Label else ""
	for child in node.get_children():
		text += labels(child)
	return text
func run() -> void:
	var orphan_baseline := int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))
	var state := root.get_node("GameState")
	var guard = load("res://tests/test_save_guard.gd").new()
	if not guard.prepare(state.get_save_file_path()).is_empty():
		quit(1)
		return
	state.reset_run_state()
	state.start_episode_from_preparation("res://data/episodes/episode_002_red_umbrella_alley.json")
	change_scene_to_file("res://scenes/investigation_scene.tscn")
	for i in range(6):
		await process_frame
	var episode: Dictionary = state.get_current_episode()
	# Controlled random seeds, but real scene method-choice signals and real effects.
	# No collect_clue, success effects, or unlock flags are injected.
	for index in [0, 1]:
		var point: Dictionary = episode.investigation_points[index]
		var clue_id: String = "clue_red_umbrella_fabric" if index == 0 else "clue_repeating_alley_sign"
		for attempt in range(8):
			if state.has_collected_clue(clue_id):
				break
			current_scene.call("_inspect_point", point)
			await process_frame
			await process_frame
			var choices: Node = current_scene.get("_method_button_box")
			check(choices.get_child_count() > 0, "real inspection exposes method choices")
			if choices.get_child_count() == 0:
				break
			seed(100 + attempt)
			choices.get_child(0).emit_signal("action_requested", String(point.method_options[0].id))
		check(state.has_collected_clue(clue_id), "method action obtains the existing source record")
	var manual: Dictionary = episode.investigation_manual
	var page: Dictionary = manual.pages[0]
	var slot := ""
	for segment in page.deduction_segments:
		if segment.get("kind") == "slot":
			slot = segment.slot_id
			break
	var toggle := current_scene.find_child("ManualToggleButton", true, false) as Button
	check(toggle != null, "investigation exposes the manual entry")
	if toggle != null:
		toggle.pressed.emit()
	for i in range(3):
		await process_frame
	var workbench := current_scene.find_child("ManualDeductionWorkbench", true, false) as Control
	check(workbench != null and workbench.visible, "manual entry opens the actual deduction workbench")
	if workbench != null:
		var slot_button := workbench.find_child("Slot_%s" % slot, true, false) as Button
		var candidate := workbench.find_child("Candidate_kw_m04_rain_sign_actual_exit", true, false) as Button
		check(slot_button != null and candidate != null, "earned records expose both the slot and alternative keyword")
		if slot_button != null and candidate != null:
			slot_button.pressed.emit()
			candidate.pressed.emit()
			await process_frame
		check(state.get_manual_draft_slots(manual).get(slot, "") == "kw_m04_rain_sign_actual_exit", "workbench inputs persist the chosen hypothesis")
		workbench.call("dismiss")
	current_scene.call("_inspect_point", episode.investigation_points[3])
	for i in range(8):
		await process_frame
	check(current_scene.scene_file_path == "res://scenes/minigame_scene.tscn", "earned investigation unlocks the real minigame transition")
	if current_scene.scene_file_path == "res://scenes/minigame_scene.tscn":
		var game: Control = current_scene.get("_game_control")
		var drawer: Control = current_scene.get("_manual_drawer")
		Input.action_press("ui_right")
		await create_timer(0.12).timeout
		Input.action_release("ui_right")
		check(float(game.get("_elapsed")) > 0, "direction input starts the real simulation")
		game.grab_focus()
		drawer.call("open_drawer")
		drawer.call("open_drawer")
		check(labels(drawer).contains("실제 출구 방향을 표시함"), "minigame manual preserves the actual chosen interpretation")
		check(not labels(drawer).contains("실제 출구가 아니라"), "sentence scaffold must not reject the chosen exit interpretation before field verification")
		check(labels(drawer).contains("미검증"), "reading a draft does not grade it")
		var elapsed: float = game.get("_elapsed")
		var position: Vector2 = game.get("_player_position")
		Input.action_press("ui_left")
		await create_timer(0.18).timeout
		Input.action_release("ui_left")
		check(is_equal_approx(float(game.get("_elapsed")), elapsed), "manual reading neither wins by waiting nor advances hazards")
		check(game.get("_player_position") == position, "navigation input cannot move the umbrella behind the drawer")
		drawer.call("close_drawer")
		check(root.gui_get_focus_owner() == game, "duplicate open cannot replace the original gameplay focus with a hidden close button")
		await create_timer(0.1).timeout
		check(float(game.get("_elapsed")) > elapsed, "closing the manual resumes from the same simulation state")
		game.call("_complete", false)
		drawer.call("open_drawer")
		drawer.call("close_drawer")
		check(not game.is_processing(), "closing a result-time drawer must not restart a finished minigame")
		var return_button: Button = current_scene.get("_return_button")
		check(return_button.visible, "finished verification exposes return to investigation")
		return_button.pressed.emit()
		for i in range(6):
			await process_frame
		check(current_scene.scene_file_path == "res://scenes/investigation_scene.tscn", "return input restores the real investigation scene")
		check(state.get_manual_draft_slots(manual).get(slot, "") == "kw_m04_rain_sign_actual_exit", "returning from failure preserves the player's interpretation without grading it")
	current_scene.queue_free()
	for i in range(4):
		await process_frame
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)) <= orphan_baseline, "investigation and minigame exit cannot leave orphan scene nodes")
	check(guard.restore().is_empty(), "restore the isolated test save")
	for failure in failures:
		push_error(failure)
	print("Investigation to minigame manual: ", failures.size(), " failures")
	quit(0 if failures.is_empty() else 1)
