extends SceneTree

var failures: Array[String] = []

func _init() -> void:
	call_deferred("run")

func check(value: bool, message: String) -> void:
	if not value:
		failures.append(message)

func frames() -> void:
	for i in range(12):
		await process_frame

func run() -> void:
	if "--capture" in OS.get_cmdline_user_args():
		root.gui_embed_subwindows = true
	var state := root.get_node("GameState")
	var session := root.get_node("ValidationSession")
	var guard = load("res://tests/test_save_guard.gd").new()
	var error: String = guard.prepare(state.get_save_file_path())
	if not error.is_empty():
		push_error(error)
		quit(1)
		return
	for status in ["control_failure", "approved_withdrawal", "core_recovered"]:
		state.reset_run_state()
		state.start_episode_from_preparation("res://data/episodes/episode_002_red_umbrella_alley.json")
		state.begin_campaign_operation("episode_002_red_umbrella_alley")
		change_scene_to_file("res://scenes/battle_scene.tscn")
		await frames()
		check(state.save_game(), "baseline save must succeed")
		var bytes := FileAccess.get_file_as_bytes(state.get_save_file_path())
		var rescue: String = state.get_current_victim_rescue_result()
		# Exercise the real save router's refusal; never touch the user's disk permissions.
		var mode: String = session.get("_mode")
		session.set("_mode", "validation")
		current_scene.call("_finish_recovery", status == "core_recovered", status)
		await frames()
		check(current_scene.scene_file_path == "res://scenes/battle_scene.tscn", status + ": failed save must stay in recovery")
		check(FileAccess.get_file_as_bytes(state.get_save_file_path()) == bytes, "refused save must preserve prior bytes")
		var dialog := current_scene.find_child("RecoverySaveRetryDialog", true, false) as AcceptDialog
		check(dialog != null and dialog.visible, "failed save must expose a retry dialog")
		if dialog != null:
			var snapshot: Dictionary = state.call("_make_save_data").duplicate(true)
			check(not current_scene.can_process(), "unsaved terminal state must freeze field processing")
			check(dialog.can_process(), "retry action must remain usable while field is frozen")
			if "--capture" in OS.get_cmdline_user_args() and status == "control_failure":
				await RenderingServer.frame_post_draw
				var image := root.get_texture().get_image()
				check(image.save_png("res://.artifacts/daily-case-20260912/recovery-save-retry.png") == OK, "capture retry screen")
			dialog.confirmed.emit()
			await frames()
			check(dialog.visible, "another failed retry must keep recovery available")
			var retry_state: Dictionary = state.call("_make_save_data")
			for key in ["echo_fragments", "granted_reward_ids", "rewarded_resolution_grades"]:
				check(retry_state.get(key) == snapshot.get(key), "failed retry must not repeat " + key)
			check(retry_state.campaign_state.request_board == snapshot.campaign_state.request_board, "failed retry must preserve request board")
			dialog.canceled.emit()
			await frames()
			check(dialog.visible, "Escape must not dismiss the only recovery action")
			session.set("_mode", mode)
			dialog.confirmed.emit()
			await frames()
			check(current_scene.scene_file_path == "res://scenes/result_scene.tscn", "successful retry must reach result")
			check(state.load_game(), "retry save must reload")
			check(state.get_recovery_result_status() == status, "retry must preserve the original terminal status")
			check(state.get_current_victim_rescue_result() == rescue, "retry must preserve rescue independently")
			var restored: Dictionary = state.call("_make_save_data")
			for key in ["echo_fragments", "granted_reward_ids", "rewarded_resolution_grades"]:
				check(restored.get(key) == snapshot.get(key), "successful retry must not duplicate " + key)
			check(restored.campaign_state.request_board == snapshot.campaign_state.request_board, "successful retry must not refresh request board twice")
			check(restored.campaign_state.cases.episode_002_red_umbrella_alley.first_terminal_outcome == snapshot.campaign_state.cases.episode_002_red_umbrella_alley.first_terminal_outcome, "retry must preserve first settlement")
		else:
			session.set("_mode", mode)
	if current_scene != null:
		current_scene.queue_free()
	await frames()
	check(guard.restore().is_empty(), "restore test save")
	for message in failures:
		push_error(message)
	print("Recovery save retry: ", failures.size(), " failures")
	quit(0 if failures.is_empty() else 1)
