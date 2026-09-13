extends SceneTree

const Guard = preload("res://tests/test_save_guard.gd")
var failures: Array[String] = []

func _initialize() -> void:
	call_deferred("run")

func check(ok: bool, message: String) -> void:
	if not ok:
		failures.append(message)

func frames(count: int = 4) -> void:
	for i in range(count):
		await process_frame

func run() -> void:
	var state := root.get_node("GameState")
	var guard := Guard.new()
	check(guard.prepare(state.get_save_file_path()).is_empty(), "guard prepares")
	state.reset_run_state()
	state.start_episode_from_preparation("res://data/episodes/episode_002_red_umbrella_alley.json")
	change_scene_to_file("res://scenes/battle_scene.tscn")
	await frames(8)
	var battle := current_scene
	var pause_button := battle.find_child("RecoveryPauseButton", true, false) as Button
	check(pause_button != null, "recovery must expose explicit pause/resume action")
	if pause_button != null:
		battle.set_process(false) # Deterministic simulation delta, actual scene and handlers.
		root.focus_entered.emit()
		if bool(battle.get("_field_paused")):
			pause_button.pressed.emit()
			battle.call("_process", 0.0)
		state.reset_recovery_clock_state()
		battle.call("_process", 11.0)
		check(state.get_recovery_clock_state().danger == 0, "before interval danger unchanged")
		battle.call("_process", 1.0)
		check(state.get_recovery_clock_state().danger == 1, "active field advances one danger segment")
		battle.call("_play_telegraph_cue") # Ensure a live cue, not one finished during renderer startup.
		check(bool(battle.get("_telegraph_audio_player").playing), "pause fixture has a currently playing telegraph")
		battle.call("_show_representative_cut_in", false)
		battle.get_node("%ManualQuickButton").pressed.emit()
		battle.call("_process", 30.0)
		var snapshot: Dictionary = state.get_recovery_clock_state()
		check(snapshot.danger == 1, "reading manual cannot advance clock")
		check(bool(battle.get("_telegraph_audio_player").stream_paused), "reading pauses telegraph audio")
		check(is_equal_approx(float(battle.get("_cut_in_remaining")), 0.9), "field cut-in lifetime is preserved while reading")
		var pattern: Dictionary = battle.get("_current_pattern")
		battle.call("_select_pattern_response", pattern.responses[0])
		check(state.get_recovery_clock_state() == snapshot and battle.get("_current_pattern") == pattern, "action signals cannot run behind manual")
		var overlay := battle.get_node("CanonV2OperationOverlay")
		overlay.find_child("ManualCloseButton", true, false).pressed.emit()
		battle.call("_process", 30.0)
		check(state.get_recovery_clock_state() == snapshot, "closing manual requires explicit resume")
		Input.action_press("ui_accept")
		pause_button.pressed.emit()
		battle.call("_process", 30.0)
		check(state.get_recovery_clock_state() == snapshot, "held resume input cannot leak into field time")
		Input.action_release("ui_accept")
		battle.call("_process", 0.0)
		battle.call("_process", 12.0)
		check(state.get_recovery_clock_state().danger == 2, "resume restores previous fractional time")
		root.focus_exited.emit()
		battle.call("_process", 12.0)
		root.focus_entered.emit()
		battle.call("_process", 12.0)
		check(state.get_recovery_clock_state().danger == 2, "focus return never automatically resumes")
		pause_button.pressed.emit()
		battle.call("_process", 0.0)
		state.reset_recovery_clock_state()
		state.change_recovery_clock_danger(5)
		battle.call("_process", 0.0)
		check(bool(battle.call("get_recovery_clock_presentation").danger_urgent) and pause_button.text.contains("폭주"), "last segment warns before escalation rather than after fallback")
		var target: Dictionary = battle.call("_get_representative_agent")
		var mental_before: int = state.get_agent_current_mental(target.id)
		battle.call("_process", 12.0)
		check(state.get_agent_current_mental(target.id) == mental_before - 8 and state.get_recovery_clock_state().danger == 3, "elapsed surge applies existing damage once and falls back")
		overlay.call("_toggle_detail_stack")
		check(bool(battle.get("_field_paused")), "operation panel pauses before another frame or input can run")
		var before_operation: Dictionary = state.get_recovery_clock_state()
		battle.call("_process", 30.0)
		overlay.call("_toggle_detail_stack")
		battle.call("_process", 30.0)
		check(state.get_recovery_clock_state() == before_operation, "operation panel close preserves explicit-resume boundary")
		overlay.call("_toggle_detail_stack")
		var supports: Array = state.get_selected_recovery_supports()
		var tested_support := false
		for support in supports:
			if not bool(support.get("available", true)):
				continue
			var support_id := String(support.id)
			var support_button := overlay.find_child("RecoverySupportButton_%s" % support_id, true, false) as Button
			if support_button == null or support_button.disabled:
				continue
			support_button.pressed.emit()
			check(not state.has_used_agent_support(support_id), "support selection while reading cannot apply an outcome")
			check(not overlay.call("has_open_field_reference") and pause_button.text.contains("지원 실행"), "selected support returns to explicit execution control")
			overlay.call("_toggle_detail_stack")
			support_button.pressed.emit()
			check(not pause_button.text.contains("지원 실행") and not state.has_used_agent_support(support_id), "reselecting pending support cancels without consuming it")
			overlay.call("_toggle_detail_stack")
			support_button.pressed.emit()
			pause_button.pressed.emit()
			battle.call("_process", 0.0)
			check(state.has_used_agent_support(support_id), "selected support remains reachable through explicit resume")
			battle.call("request_field_pause")
			tested_support = true
			break
		check(tested_support, "actual selected roster offers an available support fixture")
		await frames()
		check(root.get_visible_rect().encloses(pause_button.get_global_rect()), "pause/resume control stays inside viewport")
		if "--capture" in OS.get_cmdline_user_args():
			await RenderingServer.frame_post_draw
			var capture := root.get_texture().get_image()
			print("Recovery framebuffer: ", capture.get_size(), " logical: ", root.get_visible_rect().size)
			check(capture.save_png(ProjectSettings.globalize_path("res://.artifacts/daily-case-20260912/recovery-active-pause-%dx%d.png" % [capture.get_width(), capture.get_height()])) == OK, "capture actual recovery pause")
	var audio_probe := preload("res://tests/test_audio_lifecycle.gd").new()
	audio_probe.capture(battle)
	battle.queue_free()
	await frames()
	var retained: Array[String] = await audio_probe.wait_for_release(self)
	check(retained.is_empty(), "scene audio must retire before test shutdown: %s" % str(retained))
	check(guard.restore().is_empty(), "guard restores")
	for failure in failures:
		push_error(failure)
	print("Recovery active scene: %d failures" % failures.size())
	quit(0 if failures.is_empty() else 1)
