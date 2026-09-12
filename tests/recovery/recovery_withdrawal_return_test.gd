extends SceneTree

var failures: Array[String] = []

func _init() -> void:
	call_deferred("run")

func check(value: bool, message: String) -> void:
	if not value:
		failures.append(message)

func capture(label: String) -> void:
	if not "--capture" in OS.get_cmdline_user_args():
		return
	await process_frame
	await RenderingServer.frame_post_draw
	var size := root.get_visible_rect().size
	var directory := "res://.artifacts/daily-case-20260912/withdrawal-visual"
	DirAccess.make_dir_recursive_absolute(directory)
	var path := "%s/%s-%dx%d.png" % [directory, label, size.x, size.y]
	check(root.get_texture().get_image().save_png(path) == OK, "runtime capture must save")
	await create_timer(0.05).timeout

func run() -> void:
	var state := root.get_node("GameState")
	var guard = load("res://tests/test_save_guard.gd").new()
	if not guard.prepare(state.get_save_file_path()).is_empty():
		quit(1)
		return
	for route_case in ["unsafe", "safe", "stale"]:
		var safe_route: bool = route_case != "unsafe"
		state.reset_run_state()
		state.start_episode_from_preparation("res://data/episodes/episode_002_red_umbrella_alley.json")
		state.begin_campaign_operation("episode_002_red_umbrella_alley")
		change_scene_to_file("res://scenes/battle_scene.tscn")
		await scene_changed
		for attempt in range(40):
			if current_scene.get_node_or_null("CanonV2OperationOverlay") != null:
				break
			await create_timer(0.05).timeout
		var button := current_scene.find_child("WithdrawButton", true, false) as Button
		check(button != null, "recovery must expose a direct retreat review button")
		if button == null:
			continue
		var runtime: Dictionary = state.get_canon_v2_runtime_state()
		runtime.recovery_handoff_state["safe_withdrawal_route"] = safe_route
		runtime["active_protection_obligations"] = []
		check(bool(state.apply_canon_v2_runtime_state(runtime).get("ok", false)), "diagnostic route fixture must validate")
		var rescue_before: String = state.get_current_victim_rescue_result()
		var board_before: Array = state.get_faction_request_board()
		var before: Dictionary = state.get_canon_v2_runtime_state()
		await capture("field-" + String(route_case))
		button.pressed.emit()
		await capture("withdrawal-" + String(route_case))
		var overlay := current_scene.get_node("CanonV2OperationOverlay")
		check(overlay.get_node("ConfirmationLayer").visible, "retreat must require confirmation")
		var preview_text: String = overlay.find_child("ConfirmationDetailLabel", true, false).text
		overlay.request_action_confirmation({"allowed": true, "preview_text": "replacement action"}, Callable(), Callable())
		check(overlay.find_child("ConfirmationDetailLabel", true, false).text == preview_text, "nested action gate must not overwrite a pending retreat")
		var cancel_button := overlay.find_child("CancelButton", true, false) as Button
		var confirm_button := overlay.find_child("ConfirmButton", true, false) as Button
		check(confirm_button.find_next_valid_focus() == cancel_button, "Tab must remain inside the confirmation")
		cancel_button.pressed.emit()
		check(not bool(current_scene.get("_turn_locked")), "cancel must restore field input")
		if bool(current_scene.get("_turn_locked")):
			continue
		check(state.get_canon_v2_runtime_state() == before, "cancel must not commit preview or change obligations")
		check(state.get_faction_request_board() == board_before, "cancel must not settle the case")
		button.pressed.emit()
		if route_case == "stale":
			runtime = state.get_canon_v2_runtime_state()
			runtime.recovery_handoff_state["safe_withdrawal_route"] = false
			state.apply_canon_v2_runtime_state(runtime)
			overlay.find_child("ConfirmButton", true, false).pressed.emit()
			check(overlay.get_node("ConfirmationLayer").visible, "changed route must require a fresh confirmation")
			check(state.get_recovery_result_status().is_empty(), "stale confirmation must not settle")
			safe_route = false
		overlay.find_child("ConfirmButton", true, false).pressed.emit()
		await scene_changed
		var expected := "approved_withdrawal" if safe_route else "control_failure"
		check(current_scene.scene_file_path == "res://scenes/result_scene.tscn", "confirmed retreat must reach results")
		check(state.get_recovery_result_status() == expected, "retreat must use current route evidence, never invented safety")
		check(not state.is_recovery_successful(), "withdrawal must not become recovered core")
		check(state.get_current_victim_rescue_result() == rescue_before, "rescue achievement must remain independent")
		check(state.get_completed_case_reports().is_empty(), "retreat must not award a success report")
		check(state.load_game(), "terminal state must load")
		check(state.get_recovery_result_status() == expected, "canonical outcome must survive reload")
		check(not String(state.get_canon_v2_runtime_state().get("termination_preview", {}).get("withdrawal_reason", "")).is_empty(), "acknowledged retreat reason must survive reload")
		var return_button := current_scene.find_child("ReturnToDailyButton", true, false) as Button
		check(return_button != null, "retreat must allow daily return")
		if return_button != null:
			return_button.pressed.emit()
			await scene_changed
			check(current_scene.scene_file_path == "res://scenes/preparation_scene.tscn", "retreat return must reach daily hub")
	check(guard.restore().is_empty(), "isolated save must restore")
	if current_scene != null:
		current_scene.queue_free()
	await process_frame
	for message in failures:
		push_error(message)
	print("Recovery withdrawal return: ", failures.size(), " failures")
	quit(0 if failures.is_empty() else 1)
