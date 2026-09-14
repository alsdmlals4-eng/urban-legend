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
	check(not current_scene.find_child("NarrativeLocationsButton", true, false).is_visible_in_tree(), "opening narrative cannot bypass authored choices through location shortcut")
	var intro_node: Dictionary = state.get_current_field_node().duplicate(true)
	current_scene.find_child("NarrativeLocationsButton", true, false).pressed.emit()
	check(not current_scene.get("_points_box").is_visible_in_tree() and state.get_current_field_node() == intro_node, "hidden location shortcut cannot bypass the authored introduction handler")
	current_scene.call("_present_support_lines", episode.field_nodes[0].opening_dialogue)
	var spoken_text := labels(current_scene.get("_agent_reaction_box"))
	check(spoken_text.contains("빗소리와 표지판 변화는 같은 시각 기준으로 기록하겠습니다."), "authored agent dialogue is visible rather than silently discarded")
	check(current_scene.get("_agent_reaction_box").is_visible_in_tree(), "authored reactions have a visible narrative consumer")
	var initial_picker_text := labels(current_scene.get("_points_box"))
	for point_value in episode.investigation_points:
		var locked_point: Dictionary = point_value
		if not current_scene.call("_is_point_unlocked", locked_point):
			check(initial_picker_text.contains(String(locked_point.get("locked_text", ""))), "locked point retains its prerequisite explanation")
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
			check(current_scene.get("_dialogue_dock").is_ancestor_of(choices), "method choices belong to the same narrative reading surface")
			check(not current_scene.get("_point_method_dock").is_visible_in_tree(), "method reading does not compete with a separate investigation panel")
			check(not current_scene.get("_agent_reaction_box").is_visible_in_tree(), "previous situation dialogue does not crowd the selected investigation method")
			for action in choices.find_children("ActionButton", "Button", true, false):
				check(not action.text.contains("능력치:") and not action.text.contains("observation"), "narrative choice title does not expose raw stat identifiers")
				check(choices.get_parent().get_global_rect().encloses(action.get_global_rect()), "standard three-choice method fits its available reading area")
			check(choices.get_child_count() > 0, "real inspection exposes method choices")
			if choices.get_child_count() == 0:
				break
			var first_action := choices.get_child(0).find_child("ActionButton", true, false) as Button
			check(choices.get_parent().get_global_rect().encloses(first_action.get_global_rect()), "first method choice is visible without scrolling")
			if index == 0 and attempt == 0 and "--capture" in OS.get_cmdline_user_args():
				await RenderingServer.frame_post_draw
				var capture := root.get_texture().get_image()
				print("Narrative framebuffer: ", capture.get_size())
				check(capture.save_png(ProjectSettings.globalize_path("res://.artifacts/daily-case-20260912/narrative-latest-%dx%d.png" % [capture.get_width(), capture.get_height()])) == OK, "capture latest narrative choice surface")
			seed(100 + attempt)
			choices.get_child(0).emit_signal("action_requested", String(point.method_options[0].id))
			await process_frame
			await process_frame
			var next_point := current_scene.find_child("ResultNextButton", true, false) as Button
			check(next_point.is_visible_in_tree(), "method result exposes the refresh-and-return action")
			check(root.get_visible_rect().encloses(next_point.get_global_rect()), "long investigation result keeps next investigation on screen")
			if next_point.is_visible_in_tree():
				next_point.pressed.emit()
			else:
				current_scene.find_child("ResultCloseButton", true, false).pressed.emit()
			await process_frame
		check(state.has_collected_clue(clue_id), "method action obtains the existing source record")
	var cctv_available := false
	for button in current_scene.get("_points_box").find_children("ActionButton", "Button", true, false):
		if button.text.contains("CCTV") and not button.text.contains("잠김"):
			cctv_available = true
	check(cctv_available, "earned records unlock CCTV visibly without re-entering the scene")
	var picker_text := labels(current_scene.get("_points_box"))
	for point_value in episode.investigation_points:
		var earned_point: Dictionary = point_value
		if current_scene.call("_is_point_unlocked", earned_point):
			var obsolete_lock_text := String(earned_point.get("locked_text", ""))
			if not obsolete_lock_text.is_empty():
				check(not picker_text.contains(obsolete_lock_text), "available investigation point must not display its unmet prerequisite text")
	var record_button := current_scene.find_child("RecordButton", true, false) as Button
	record_button.pressed.emit()
	check(current_scene.get("_record_drawer").visible, "M04 record button opens earned field records")
	if current_scene.get("_record_drawer").visible:
		record_button.pressed.emit()
	var recovery_entry := current_scene.find_child("ResolutionAttemptButton", true, false) as Button
	check(recovery_entry.is_visible_in_tree() and not recovery_entry.disabled, "earned evidence exposes the actual recovery entry")
	if recovery_entry.is_visible_in_tree() and not recovery_entry.disabled:
		recovery_entry.pressed.emit()
		check(current_scene.get("_resolution_confirm_panel").visible, "recovery entry opens its existing confirmation")
		current_scene.find_child("ContinueInvestigationButton", true, false).pressed.emit()
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
		check(root.get_visible_rect().encloses(game.get_global_rect()), "entire minigame playfield remains inside the logical viewport")
		var drawer: Control = current_scene.get("_manual_drawer")
		var field_toggle: Button = current_scene.get("_manual_toggle_button")
		check(root.get_visible_rect().encloses(field_toggle.get_global_rect()), "manual entry stays inside the visible viewport")
		var operation_strip := current_scene.find_child("RuleStripPanel", true, false) as Control
		check(operation_strip == null or not operation_strip.get_global_rect().intersects(field_toggle.get_global_rect()), "operation strip cannot cover the field manual entry")
		check(drawer.z_index > field_toggle.z_index, "opened manual draws above the underlying field controls")
		game.find_child("CaptureFrameButton", true, false).pressed.emit()
		await create_timer(0.12).timeout
		check(float(game.get("_elapsed")) > 0, "capture start action starts the real simulation")
		game.grab_focus()
		drawer.call("open_drawer")
		drawer.call("open_drawer")
		check(labels(drawer).contains("실제 출구 방향을 표시함"), "minigame manual preserves the actual chosen interpretation")
		check(not labels(drawer).contains("실제 출구가 아니라"), "sentence scaffold must not reject the chosen exit interpretation before field verification")
		check(labels(drawer).contains("미검증"), "reading a draft does not grade it")
		var elapsed: float = game.get("_elapsed")
		var attempts: int = game.get("_attempts").size()
		game.find_child("CaptureFrameButton", true, false).pressed.emit()
		Input.action_press("ui_left")
		await create_timer(0.18).timeout
		Input.action_release("ui_left")
		check(is_equal_approx(float(game.get("_elapsed")), elapsed), "manual reading neither wins by waiting nor advances hazards")
		check(game.get("_attempts").size() == attempts, "input cannot capture a frame behind the drawer")
		drawer.call("close_drawer")
		await create_timer(0.1).timeout
		check(is_equal_approx(float(game.get("_elapsed")), elapsed), "closing the manual cannot automatically resume danger")
		var resume_button := current_scene.find_child("ResumeFieldButton", true, false) as Button
		check(resume_button != null and resume_button.visible, "explicit field-resume action is available after reading")
		if resume_button != null:
			check(root.gui_get_focus_owner() == resume_button, "focus goes to the visible resume action, not the disabled playfield")
			check(root.get_visible_rect().encloses(resume_button.get_global_rect()), "resume action stays inside the logical viewport")
			if "--capture" in OS.get_cmdline_user_args():
				await RenderingServer.frame_post_draw
				check(root.get_texture().get_image().save_png(ProjectSettings.globalize_path("res://.artifacts/daily-case-20260912/minigame-explicit-resume.png")) == OK, "capture explicit resume state")
			Input.action_press("ui_right")
			resume_button.pressed.emit()
			await create_timer(0.1).timeout
			check(is_equal_approx(float(game.get("_elapsed")), elapsed) and game.get("_attempts").size() == attempts, "held input cannot leak through the resume action")
			Input.action_release("ui_right")
			await create_timer(0.1).timeout
			check(float(game.get("_elapsed")) > elapsed, "explicit resume starts from the preserved simulation")
			root.focus_exited.emit()
			elapsed = game.get("_elapsed")
			await create_timer(0.1).timeout
			check(is_equal_approx(float(game.get("_elapsed")), elapsed), "window focus loss pauses simulation")
			root.focus_entered.emit()
			await create_timer(0.1).timeout
			check(is_equal_approx(float(game.get("_elapsed")), elapsed), "window focus return requires explicit resume too")
			resume_button.pressed.emit()
			for i in range(3):
				await process_frame
		check(not bool(game.get("_input_locked")), "resume handshake releases capture input before the next action")
		game.call("_process", maxf(0.0, 3.2 - float(game.get("_elapsed"))))
		if "--capture" in OS.get_cmdline_user_args():
			await RenderingServer.frame_post_draw
			check(root.get_texture().get_image().save_png(ProjectSettings.globalize_path("res://.artifacts/daily-case-20260912/rain-frame-sync.png")) == OK, "capture actual CCTV rule execution")
		game.find_child("CaptureFrameButton", true, false).pressed.emit()
		check(bool(state.get_minigame_result("minigame_rain_sync").get("successful", false)), "after-third capture settles a real success without forcing completion")
		drawer.call("open_drawer")
		drawer.call("close_drawer")
		check(not game.is_processing(), "closing a result-time drawer must not restart a finished minigame")
		var return_button: Button = current_scene.get("_return_button")
		check(return_button.visible, "finished verification exposes return to investigation")
		return_button.pressed.emit()
		for i in range(6):
			await process_frame
		check(current_scene.scene_file_path == "res://scenes/investigation_scene.tscn", "return input restores the real investigation scene")
		check(state.get_manual_draft_slots(manual).get(slot, "") == "kw_m04_rain_sign_actual_exit", "physical success preserves the player's alternate interpretation without grading it")
	current_scene.queue_free()
	for i in range(4):
		await process_frame
	state.reset_run_state()
	state.load_episode("res://data/episodes/episode_001_afterlife_station.json")
	state.set_current_minigame_id("minigame_frequency_sync")
	change_scene_to_file("res://scenes/minigame_scene.tscn")
	for i in range(6):
		await process_frame
	var route_game: Control = current_scene.get("_game_control")
	var route_drawer: Control = current_scene.get("_manual_drawer")
	route_drawer.call("open_drawer")
	route_drawer.call("close_drawer")
	await process_frame
	check(bool(route_game.get("_input_locked")) and route_game.process_mode == Node.PROCESS_MODE_DISABLED, "M01 route controls remain locked until explicit resume")
	var route_resume := current_scene.find_child("ResumeFieldButton", true, false) as Button
	check(route_resume != null and route_resume.visible, "M01 header manual provides the same explicit resume route")
	if route_resume != null:
		route_resume.pressed.emit()
		for i in range(2):
			await process_frame
		check(not bool(route_game.get("_input_locked")) and route_game.process_mode == Node.PROCESS_MODE_INHERIT, "M01 restores both its input lock and original process mode")
	current_scene.queue_free()
	for i in range(4):
		await process_frame
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)) <= orphan_baseline, "investigation and minigame exit cannot leave orphan scene nodes")
	check(guard.restore().is_empty(), "restore the isolated test save")
	for failure in failures:
		push_error(failure)
	print("Investigation to minigame manual: ", failures.size(), " failures")
	quit(0 if failures.is_empty() else 1)
