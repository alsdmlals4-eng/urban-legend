extends SceneTree


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() < 2:
		push_error("usage: -- <scene_path> <output_path> [episode_id]")
		quit(2)
		return
	var scene_path := String(args[0])
	var output_path := String(args[1])
	var episode_id := String(args[2]) if args.size() > 2 else "episode_001_afterlife_station"
	var episode_path := "res://data/episodes/episode_002_red_umbrella_alley.json" if episode_id == "episode_002_red_umbrella_alley" else "res://data/episodes/episode_001_afterlife_station.json"
	var game_state := root.get_node("GameState")
	game_state.load_episode(episode_path)
	game_state.set_selected_agent_ids(["agent_kang_ijun", "agent_kwon_narae", "agent_oh_hyun"])
	var error := change_scene_to_file(scene_path)
	if error != OK:
		push_error("failed to load scene: %s" % scene_path)
		quit(error)
		return
	for _frame in range(5):
		await process_frame
	if args.size() > 3 and String(args[3]) == "editor":
		var f2 := InputEventKey.new()
		f2.keycode = KEY_F2
		f2.pressed = true
		Input.parse_input_event(f2)
		for _frame in range(3):
			await process_frame
	var image := root.get_viewport().get_texture().get_image()
	if image == null or image.is_empty():
		push_error("captured image is empty")
		quit(3)
		return
	var save_error := image.save_png(output_path)
	if save_error != OK:
		push_error("failed to save capture: %s" % output_path)
		quit(save_error)
		return
	print("UI CAPTURE: %s %dx%d" % [output_path, image.get_width(), image.get_height()])
	quit(0)
