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
	if ui_state == "mvp043_point_picker":
		game_state.set_current_field_node_id("field_station_investigation")
	if ui_state.begins_with("mvp043_reasoning"):
		game_state.set_current_field_node_id("field_station_investigation")
	if ui_state.begins_with("mvp039_"):
		_prepare_mvp039_evidence(game_state)
		if ui_state == "mvp039_result":
			game_state.start_resolution_phase()
			game_state.save_recovery_result(true, "core_recovered", 100)
			game_state.record_current_case_report()
	if ui_state.begins_with("mvp042_"):
		game_state.reset_run_state()
		if ui_state == "mvp042_daily" or ui_state == "mvp042_daily_result":
			game_state.begin_daily_episode("daily_afterlife_sign_blanks")
		elif ui_state == "mvp042_database":
			game_state.begin_daily_episode("daily_afterlife_sign_blanks")
			game_state.resolve_daily_episode_choice("preserve_order")
	if ui_state.begins_with("mvp047_"):
		_prepare_mvp047_state(game_state, episode_path, ui_state)
	var error := change_scene_to_file(scene_path)
	if error != OK:
		push_error("failed to load scene: %s" % scene_path)
		_guard.restore()
		quit(error)
		return
	for _frame in range(5):
		await process_frame
	if (ui_state == "mvp042_daily" or ui_state == "mvp042_daily_result") and current_scene.find_child("DailyEpisodeChoices", true, false) == null:
		push_error("MVP-042 daily capture did not build daily episode choices")
		_guard.restore()
		quit(6)
		return
	if ui_state == "mvp042_daily_result" and current_scene.has_method("_resolve_choice"):
		current_scene.call("_resolve_choice", "preserve_order")
		for _frame in range(3):
			await process_frame
	if ui_state == "method_picker" and current_scene.has_method("_get_investigation_points"):
		var points: Array = current_scene.call("_get_investigation_points")
		for point in points:
			if typeof(point) == TYPE_DICTIONARY and not Array(point.get("method_options", [])).is_empty():
				current_scene.call("_show_method_options", point)
				for _frame in range(3):
					await process_frame
				break
	if ui_state.begins_with("mvp043_reasoning") and current_scene.has_method("_get_investigation_points"):
		var points: Array = current_scene.call("_get_investigation_points")
		for point in points:
			if typeof(point) == TYPE_DICTIONARY and String(point.get("id", "")) == "point_platform_speaker":
				current_scene.call("_show_method_options", point)
				for _frame in range(3):
					await process_frame
				break
		if ui_state == "mvp043_reasoning_cases":
			current_scene.call("_open_manual_case", "failure_c")
			current_scene.call("_open_manual_case", "failure_b")
			var case_dialog := current_scene.get("_case_dialog") as AcceptDialog
			if case_dialog != null:
				case_dialog.hide()
			for _frame in range(3):
				await process_frame
		if ui_state == "mvp043_reasoning_popup":
			current_scene.call("_open_manual_case", "failure_c")
			for _frame in range(3):
				await process_frame
		if ui_state == "mvp043_reasoning_risk":
			var reasoning: Dictionary = current_scene.get("_reasoning_definition")
			for choice in reasoning.get("choices", []):
				if typeof(choice) == TYPE_DICTIONARY and String(choice.get("kind", "")) == "risk":
					current_scene.call("_select_reasoning_choice", choice)
					break
			for _frame in range(3):
				await process_frame
	if ui_state == "recovery_evidence" and current_scene.has_method("_toggle_clue_drawer"):
		current_scene.call("_toggle_clue_drawer")
		for _frame in range(3):
			await process_frame
	if ui_state == "mvp043_team_status":
		var team_button := current_scene.find_child("TeamStatusButton", true, false) as Button
		if team_button != null:
			team_button.emit_signal("pressed")
			for _frame in range(3):
				await process_frame
	if ui_state == "mvp043_recovery_repeat" and current_scene.has_method("_select_pattern_response"):
		var pattern: Dictionary = current_scene.get("_current_pattern")
		var response := _find_wrong_response(pattern)
		if not response.is_empty():
			current_scene.call("_select_pattern_response", response)
			for _frame in range(3):
				await process_frame
	if ui_state == "mvp043_external_contacts":
		var tabs := current_scene.find_child("PreparationTabs", true, false) as TabContainer
		if tabs != null:
			tabs.current_tab = 3
			for _frame in range(3):
				await process_frame
			var contact_grid := current_scene.find_child("ExternalContactGrid", true, false) as Control
			var contact_scroll := _find_scroll_container(contact_grid)
			if contact_grid != null and contact_scroll != null:
				contact_scroll.ensure_control_visible(contact_grid)
				for _frame in range(3):
					await process_frame
				contact_scroll.scroll_vertical = maxi(0, contact_scroll.scroll_vertical - 60)
				for _frame in range(2):
					await process_frame
	if ui_state == "mvp047_research" or ui_state == "mvp047_craft":
		var research_tabs := current_scene.find_child("PreparationTabs", true, false) as TabContainer
		if research_tabs != null:
			research_tabs.current_tab = 2
			for _frame in range(3):
				await process_frame
	if ui_state == "mvp047_raymond":
		var contact_tabs := current_scene.find_child("PreparationTabs", true, false) as TabContainer
		if contact_tabs != null:
			contact_tabs.current_tab = 3
			for _frame in range(3):
				await process_frame
		var raymond_button := current_scene.find_child("RaymondContractButton", true, false) as Control
		var raymond_scroll := _find_scroll_container(raymond_button)
		if raymond_button != null and raymond_scroll != null:
			raymond_scroll.ensure_control_visible(raymond_button)
			for _frame in range(3):
				await process_frame
	if ui_state == "mvp047_recovery" and current_scene.has_method("_select_pattern_response"):
		var recovery_pattern: Dictionary = current_scene.get("_current_pattern")
		var recovery_response := _find_wrong_response(recovery_pattern)
		if not recovery_response.is_empty():
			current_scene.call("_select_pattern_response", recovery_response)
			for _frame in range(3):
				await process_frame
	if ui_state == "mvp043_route_final":
		var route_control := _find_script_control(current_scene, "route_restore_game.gd")
		if route_control != null:
			route_control.set("_tutorial_complete", true)
			route_control.call("_build_final_board")
			route_control.call("_emit_status")
			route_control.emit_signal(
				"stage_changed",
				"final",
				"현장 검증 2/2 · 결과 저장",
				{"grid_size": 4, "result_saved": true}
			)
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
	if ui_state == "mvp042_database" and current_scene.has_method("_show_section"):
		current_scene.call("_show_section", "daily_episode_records")
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
	await RenderingServer.frame_post_draw
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


func _find_script_control(node: Node, script_name: String) -> Control:
	if node == null:
		return null
	var node_script: Variant = node.get_script()
	if node is Control and node_script != null and String(node_script.resource_path).ends_with(script_name):
		return node as Control
	for child in node.get_children():
		var found := _find_script_control(child, script_name)
		if found != null:
			return found
	return null


func _prepare_mvp039_evidence(game_state: Node) -> void:
	for clue in game_state.get_clues():
		if typeof(clue) == TYPE_DICTIONARY:
			game_state.collect_clue(String(clue.get("id", "")))
	for hint in game_state.get_hints():
		if typeof(hint) == TYPE_DICTIONARY:
			game_state.mark_hint_seen(String(hint.get("id", "")))


func _prepare_mvp047_state(game_state: Node, episode_path: String, ui_state: String) -> void:
	game_state.reset_run_state()
	game_state.load_episode(episode_path)
	game_state.set_selected_agent_ids(["agent_kwon_narae", "agent_oh_hyun", "agent_kang_ijun"])
	game_state.research_points = 5
	if ui_state == "mvp047_research":
		game_state.grant_echo_reward("capture:mvp047-research", 5)
		return
	if ui_state == "mvp047_craft":
		game_state.grant_echo_reward("capture:mvp047-craft", 5)
		if not bool(game_state.complete_research_project("research_resonance_prism").get("successful", false)):
			push_error("MVP-047 capture setup could not complete the resonance prism")
		return
	if not bool(game_state.complete_research_project("research_contract_protocol").get("successful", false)):
		push_error("MVP-047 capture setup could not complete the Raymond protocol")
		return
	if ui_state == "mvp047_raymond":
		return
	if not game_state.grant_echo_reward("capture:mvp047-raymond", 5):
		push_error("MVP-047 capture setup could not grant Raymond contract fragments")
		return
	var contract_selection: Dictionary = game_state.select_mercenary_contract("contract_raymond_kane")
	if not bool(contract_selection.get("successful", false)):
		push_error("MVP-047 capture setup could not reserve Raymond contract")
		return
	if ui_state == "mvp047_recovery":
		game_state.set_campaign_planned_case("episode_001_afterlife_station")
		if not game_state.begin_campaign_operation("episode_001_afterlife_station"):
			push_error("MVP-047 capture setup could not begin the Raymond operation")
	elif ui_state == "mvp047_result":
		game_state.start_resolution_phase()
		game_state.save_recovery_result(true, "core_recovered", 100)
		game_state.record_current_case_report()


func _find_wrong_response(pattern: Dictionary) -> Dictionary:
	var correct_id := String(pattern.get("correct_response_id", ""))
	for response in pattern.get("responses", []):
		if typeof(response) == TYPE_DICTIONARY and String(response.get("id", "")) != correct_id:
			return response.duplicate(true)
	return {}
