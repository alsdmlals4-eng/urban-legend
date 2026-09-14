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
	var audio_probe := preload("res://tests/test_audio_lifecycle.gd").new()
	audio_probe.capture(battle)
	battle.set_process(false)
	root.focus_entered.emit()
	battle.call("_set_field_paused", false)
	var supports: Array = state.get_selected_recovery_supports()
	check(not supports.is_empty(), "real roster provides casting action")
	if not supports.is_empty():
		var support: Dictionary = supports[0]
		battle.call("_play_telegraph_cue") # Test a live cue, not one expired during renderer startup.
		check(bool(battle.get("_telegraph_audio_player").playing), "casting fixture has audible cue to suspend")
		battle.call("_use_agent_recovery_support", support, null)
		var cut_in := battle.find_child("RecoveryCastingCutIn", true, false)
		check(cut_in != null and cut_in.is_visible_in_tree(), "actual support starts casting presentation")
		var after_effect: Dictionary = state.get_recovery_clock_state()
		var stability_after: int = battle.get("_anomaly_stability")
		check(bool(battle.call("_field_actions_blocked")), "casting prevents overlapping field action")
		check(battle.find_child("RecoveryPauseButton", true, false).text.contains("시전"), "field control explains why time is suspended")
		var pattern_before: Dictionary = battle.get("_current_pattern").duplicate(true)
		battle.call("_select_pattern_response", pattern_before.responses[0])
		check(battle.get("_current_pattern") == pattern_before and state.get_recovery_clock_state() == after_effect, "response handler cannot resolve a second action behind casting")
		check(bool(battle.get("_telegraph_audio_player").stream_paused), "casting suspends audible telegraph with field time")
		battle.call("_process", 0.25)
		check(state.get_recovery_clock_state() == after_effect, "forced casting time never charges danger clock")
		if cut_in != null:
			var caption := cut_in.find_child("CastCaption", true, false) as Label
			check(caption != null and caption.text.contains(String(support.agent_name)) and caption.text.contains(String(support.label)), "caption identifies actual caster and authored action")
			var image := cut_in.find_child("CastImage", true, false) as TextureRect
			check(image != null and image.texture == preload("res://scripts/ui/ui_asset_catalog.gd").new().get_agent_production_texture(support.agent_id, "recovery_support"), "image belongs to actual support actor")
			await frames()
			check(root.gui_get_focus_owner() == cut_in.find_child("SkipCastButton", true, false), "casting routes keyboard focus to skip, not blocked field actions")
			battle.call("request_manual_quick_open")
			await frames()
			check(bool(battle.call("_field_reference_open")), "manual remains available during casting")
			var reference_focus := root.gui_get_focus_owner()
			var cast_position := image.position
			battle.call("_focus_first_enabled_decision_card")
			await frames()
			battle.call("_process", 30.0)
			check(cut_in.is_visible_in_tree() and image.position == cast_position and state.get_recovery_clock_state() == after_effect, "manual reading freezes casting and field clocks together")
			check(root.gui_get_focus_owner() == reference_focus, "deferred casting focus cannot steal open manual input")
			battle.get_node("CanonV2OperationOverlay").call("_toggle_manual_detail")
			await frames()
			check(not bool(battle.call("_field_reference_open")), "manual can close during casting")
			battle.call("_set_field_paused", false)
			battle.call("_process", 0.0)
			check(root.get_visible_rect().encloses(cut_in.get_global_rect()), "casting stays inside viewport")
			check(not cut_in.get_global_rect().intersects(battle.get_node("%TeamStrip").get_global_rect()), "casting cannot occlude staff condition strip")
			if "--capture" in OS.get_cmdline_user_args():
				await RenderingServer.frame_post_draw
				var capture := root.get_texture().get_image()
				print("Casting framebuffer: ", capture.get_size(), " logical: ", root.get_visible_rect().size)
				if "--expect-1080" in OS.get_cmdline_user_args():
					check(capture.get_size() == Vector2i(1920, 1080), "1080 proof requires exact framebuffer, not desktop-clamped window")
				check(capture.save_png(ProjectSettings.globalize_path("res://.artifacts/daily-case-20260912/casting-%dx%d.png" % [capture.get_width(), capture.get_height()])) == OK, "capture actual casting framebuffer")
			battle.call("request_field_pause")
			var position_before: Vector2 = image.position
			battle.call("_process", 30.0)
			check(cut_in.is_visible_in_tree() and image.position == position_before, "reading pause freezes casting rather than expiring it")
			var skip := cut_in.find_child("SkipCastButton", true, false) as Button
			check(skip != null, "casting has reachable skip")
			check(skip != null and skip.size.x <= 200.0, "skip remains a secondary compact control")
			if skip != null:
				skip.pressed.emit()
				skip.pressed.emit()
			check(not cut_in.is_visible_in_tree(), "skip retires presentation")
			check(state.get_recovery_clock_state() == after_effect, "skip and duplicate skip never apply effects again")
			check(int(battle.get("_anomaly_stability")) == stability_after, "skipping cannot duplicate stabilization")
			check(bool(battle.get("_field_paused")), "skip never resumes a user paused field")
			battle.call("_set_field_paused", false)
			battle.call("_process", 0.0)
			battle.call("_use_agent_recovery_support", support, null)
			check(not cut_in.is_visible_in_tree(), "already consumed support cannot replay its cut-in")
			if supports.size() > 1:
				battle.call("_use_agent_recovery_support", supports[1], null)
				check(cut_in.is_visible_in_tree(), "next actor has independent casting presentation")
				check(not battle.call("request_field_support", support), "support selection cannot interrupt active cast")
				var second_effect: Dictionary = state.get_recovery_clock_state()
				await frames()
				var accept := InputEventKey.new()
				accept.keycode = KEY_ENTER
				accept.physical_keycode = KEY_ENTER
				accept.pressed = true
				root.push_input(accept)
				await process_frame
				accept = accept.duplicate()
				accept.pressed = false
				root.push_input(accept)
				await frames()
				check(not cut_in.is_visible_in_tree(), "Enter skips through real button input")
				cut_in.find_child("SkipCastButton", true, false).pressed.emit()
				battle.call("_process", 30.0)
				check(not cut_in.is_visible_in_tree() and state.get_recovery_clock_state() == second_effect, "unpaused skip consumes no catch-up field time")
				check(not bool(battle.get("_telegraph_audio_player").stream_paused), "skip restores active telegraph")
				battle.call("_process", 0.125)
				check(is_equal_approx(float(state.get_recovery_clock_state().active_seconds), float(second_effect.active_seconds) + 0.125), "normal field time resumes after skip frame")
			check(supports.size() > 2, "terminal casting fixture has third support")
			if supports.size() > 2:
				# A boundary fixture, not a claimed normal-input victory.
				var near_threshold := int(battle.get("_recovery_threshold")) - 1
				battle.set("_anomaly_stability", state.change_anomaly_stability(near_threshold - state.get_case_anomaly_stability()))
				battle.call("_use_agent_recovery_support", supports[2], null)
				check(bool(battle.call("_can_recover")), "third support achieves terminal stabilization in boundary fixture")
				battle.call("_complete_recovery_when_ready")
				await frames()
				check(current_scene == battle and cut_in.is_visible_in_tree(), "terminal success cannot cut off active casting")
				var terminal_clock: Dictionary = state.get_recovery_clock_state()
				battle.call("_process", 30.0)
				check(state.get_recovery_clock_state() == terminal_clock, "natural completion consumes no catch-up field time")
				await frames(8)
				check(current_scene.scene_file_path == "res://scenes/result_scene.tscn", "terminal success continues to result after casting")
	if current_scene != null:
		audio_probe.capture(current_scene)
		current_scene.queue_free()
	await frames()
	check((await audio_probe.wait_for_release(self)).is_empty(), "scene audio retires")
	check(guard.restore().is_empty(), "guard restores")
	for failure in failures:
		push_error(failure)
	print("Recovery casting cut-in: %d failures" % failures.size())
	quit(0 if failures.is_empty() else 1)
