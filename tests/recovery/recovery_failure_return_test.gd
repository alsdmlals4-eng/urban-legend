extends SceneTree

var failures: Array[String] = []

func _init() -> void:
	call_deferred("run")

func check(value: bool, message: String) -> void:
	if not value:
		failures.append(message)

func run() -> void:
	var state := root.get_node("GameState")
	var guard = load("res://tests/test_save_guard.gd").new()
	var error: String = guard.prepare(state.get_save_file_path())
	if not error.is_empty():
		push_error(error)
		quit(1)
		return
	state.reset_run_state()
	state.start_episode_from_preparation("res://data/episodes/episode_002_red_umbrella_alley.json")
	state.begin_campaign_operation("episode_002_red_umbrella_alley")
	change_scene_to_file("res://scenes/battle_scene.tscn")
	await scene_changed
	var audio_probe := preload("res://tests/test_audio_lifecycle.gd").new()
	audio_probe.capture(current_scene)
	var rescue_before: String = state.get_current_victim_rescue_result()
	for id in state.get_selected_agent_ids():
		state.change_agent_hp(id, -10000)
	check(state.are_all_agents_inactive(), "fixture must exhaust the selected team")
	current_scene.call("_update_battle_view", "exhausted team")
	current_scene.call("_update_battle_view", "duplicate update")
	for frame in range(6):
		await process_frame
	check(current_scene.scene_file_path == "res://scenes/result_scene.tscn", "exhaustion must reach results, not silently restart investigation")
	check(state.get_recovery_result_status() == "control_failure", "failure must persist as canonical control failure")
	check(not state.is_recovery_successful(), "failure must not become success")
	check(state.get_completed_case_reports().is_empty(), "failure must not award a success report")
	check(state.get_current_victim_rescue_result() == rescue_before, "failure must preserve the separate rescue outcome")
	check(state.load_game(), "terminal result must be saved")
	audio_probe.capture(current_scene)
	check(state.get_recovery_result_status() == "control_failure", "saved failure must survive reload")
	var return_button := current_scene.find_child("ReturnToDailyButton", true, false) as Button
	check(return_button != null, "failure result must provide return to daily")
	if return_button != null:
		return_button.pressed.emit()
		await scene_changed
		audio_probe.capture(current_scene)
		check(current_scene.scene_file_path == "res://scenes/preparation_scene.tscn", "return button must reach daily hub")
		check(state.get_recovery_result_status() == "control_failure", "returning to daily must not erase the failure")
		var acknowledge := current_scene.get("_start_button") as Button
		check(acknowledge != null, "daily hub must expose result acknowledgement")
		if acknowledge != null:
			acknowledge.pressed.emit()
			await scene_changed
			audio_probe.capture(current_scene)
			check(state.get_campaign_slot_phase() == "planning", "acknowledgement must unlock daily activities")
	check(guard.restore().is_empty(), "test save must be restored")
	if current_scene != null:
		current_scene.queue_free()
	await process_frame
	check((await audio_probe.wait_for_release(self)).is_empty(), "failure return scene audio must retire before fixture exit")
	for message in failures:
		push_error(message)
	print("Recovery failure return: ", failures.size(), " failures")
	quit(0 if failures.is_empty() else 1)
