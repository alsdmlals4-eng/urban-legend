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

func accept_key() -> void:
	var event := InputEventKey.new()
	event.keycode = KEY_ENTER
	event.physical_keycode = KEY_ENTER
	event.pressed = true
	root.push_input(event)
	await process_frame
	event = event.duplicate()
	event.pressed = false
	root.push_input(event)
	await frames()

func run() -> void:
	var state := root.get_node("GameState")
	var guard := Guard.new()
	check(guard.prepare(state.get_save_file_path()).is_empty(), "guard prepares")
	for episode_path in ["res://data/episodes/episode_001_afterlife_station.json", "res://data/episodes/episode_002_red_umbrella_alley.json"]:
		state.reset_run_state()
		state.start_episode_from_preparation(episode_path)
		change_scene_to_file("res://scenes/investigation_scene.tscn")
		await frames(8)
		var scene := current_scene
		var intro: Dictionary = state.get_current_field_node().duplicate(true)
		var art := scene.find_child("Background", true, false) as Control
		check(not art.get_global_rect().intersects(scene.get("_dialogue_dock").get_global_rect()), "scene artwork and reading area do not overlap")
		check(scene.get("_field_next_button").is_visible_in_tree(), "opening narration is read before choices")
		for page in range(40):
			if not scene.get("_field_next_button").is_visible_in_tree():
				break
			check(state.get_current_field_node() == intro, "opening pages do not advance authored state")
			await accept_key()
		var shortcut := scene.find_child("NarrativeLocationsButton", true, false) as Button
		check(shortcut != null and not shortcut.is_visible_in_tree(), "introduction cannot offer a shortcut past authored choices: " + episode_path)
		shortcut.pressed.emit()
		check(not scene.get("_points_box").is_visible_in_tree() and state.get_current_field_node() == intro, "hidden shortcut signal cannot skip introduction")
		var choices: Node = scene.get("_field_choice_box")
		check(choices.get_child_count() > 0, "real introduction has an authored choice")
		if choices.get_child_count() > 0:
			var first_action := choices.get_child(0).find_child("ActionButton", true, false) as Button
			check(choices.get_parent().get_global_rect().encloses(first_action.get_global_rect()), "opening dialogue leaves first authored choice visible: " + episode_path)
			check(root.gui_get_focus_owner() == first_action, "opening choice receives keyboard focus: " + episode_path)
			await accept_key()
			check(scene.get("_field_next_button").is_visible_in_tree(), "authored choice preserves next-dialogue action")
			check(not shortcut.is_visible_in_tree(), "after-dialogue cannot be bypassed by location shortcut")
			check(root.gui_get_focus_owner() == scene.get("_field_next_button"), "dialogue transition retains keyboard continuation")
			for page in range(40):
				if String(state.get_current_field_node().id) != String(intro.id):
					break
				await accept_key()
			check(String(state.get_current_field_node().id) != String(intro.id), "normal next-dialogue input advances actual field node")
			for page in range(40):
				if not scene.get("_field_next_button").is_visible_in_tree():
					break
				await accept_key()
			check(scene.get("_points_box").is_visible_in_tree(), "authored transition reaches investigation points")
		# Long authored text must survive paging exactly, including spaces/newlines.
		var long_text := "긴 현장 기록입니다. 단어와 줄바꿈을 보존합니다.\n".repeat(12)
		var before_node: Dictionary = state.get_current_field_node().duplicate(true)
		scene.call("_begin_reading", [{"speaker": "권나래", "text": long_text}], false)
		await frames()
		var reconstructed := ""
		for page in range(40):
			if not scene.get("_field_next_button").is_visible_in_tree():
				break
			check(scene.get("_field_dialogue_label").text.length() <= 100, "one short narration chunk at a time")
			reconstructed += scene.get("_field_dialogue_label").text
			check(state.get_current_field_node() == before_node, "reading text cannot change case state")
			await accept_key()
		check(reconstructed == long_text, "paging neither drops nor duplicates authored characters")
		if "--capture" in OS.get_cmdline_user_args():
			scene.call("_begin_reading", [{"speaker": "권나래", "text": "현장의 기록을 한 줄씩 확인합니다."}], false)
			await frames()
			await RenderingServer.frame_post_draw
			var capture := root.get_texture().get_image()
			capture.save_png(ProjectSettings.globalize_path("res://.artifacts/daily-case-20260912/narrative-reading-%dx%d.png" % [capture.get_width(), capture.get_height()]))
		var audio_probe := preload("res://tests/test_audio_lifecycle.gd").new()
		audio_probe.capture(current_scene)
		current_scene.queue_free()
		await frames()
		check((await audio_probe.wait_for_release(self)).is_empty(), "introduction scene audio retires")
	check(guard.restore().is_empty(), "guard restores")
	for failure in failures:
		push_error(failure)
	print("Narrative introduction continuity: %d failures" % failures.size())
	quit(0 if failures.is_empty() else 1)
