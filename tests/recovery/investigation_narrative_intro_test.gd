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
	for episode_path in ["res://data/episodes/episode_001_afterlife_station.json", "res://data/episodes/episode_002_red_umbrella_alley.json"]:
		state.reset_run_state()
		state.start_episode_from_preparation(episode_path)
		change_scene_to_file("res://scenes/investigation_scene.tscn")
		await frames(8)
		var scene := current_scene
		var intro: Dictionary = state.get_current_field_node().duplicate(true)
		var shortcut := scene.find_child("NarrativeLocationsButton", true, false) as Button
		check(shortcut != null and not shortcut.is_visible_in_tree(), "introduction cannot offer a shortcut past authored choices: " + episode_path)
		shortcut.pressed.emit()
		check(not scene.get("_points_box").is_visible_in_tree() and state.get_current_field_node() == intro, "hidden shortcut signal cannot skip introduction")
		var choices: Node = scene.get("_field_choice_box")
		check(choices.get_child_count() > 0, "real introduction has an authored choice")
		if choices.get_child_count() > 0:
			var first_action := choices.get_child(0).find_child("ActionButton", true, false) as Button
			check(choices.get_parent().get_global_rect().encloses(first_action.get_global_rect()), "opening dialogue leaves first authored choice visible: " + episode_path)
			choices.get_child(0).emit_signal("action_requested", String(intro.choices[0].id))
			await frames()
			check(scene.get("_field_next_button").is_visible_in_tree(), "authored choice preserves next-dialogue action")
			check(not shortcut.is_visible_in_tree(), "after-dialogue cannot be bypassed by location shortcut")
			scene.get("_field_next_button").pressed.emit()
			await frames()
			check(String(state.get_current_field_node().id) != String(intro.id), "normal next-dialogue input advances actual field node")
			check(scene.get("_points_box").is_visible_in_tree(), "authored transition reaches investigation points")
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
