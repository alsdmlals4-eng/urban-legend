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
	state.collect_clue("clue_repeating_alley_sign")
	var manual: Dictionary = state.get_current_episode().investigation_manual
	var page: Dictionary = manual.pages[0]
	var slot := ""
	for segment in page.deduction_segments:
		if segment.get("kind") == "slot":
			slot = segment.slot_id
			break
	var result: Dictionary = state.set_manual_draft_slot(manual, page.id, slot, "kw_m04_rain_sign_actual_exit", state.get_collected_clue_ids())
	check(result.get("ok", false), "persist the player's alternate interpretation")
	check(state.load_game(), "draft survives save reload")
	change_scene_to_file("res://scenes/battle_scene.tscn")
	for i in range(30):
		await create_timer(0.02).timeout
		if current_scene != null and current_scene.get_node_or_null("CanonV2OperationOverlay") != null:
			break
	var quick := current_scene.find_child("ManualQuickButton", true, false) as Button
	check(quick != null, "recovery exposes quick manual entry")
	if quick != null:
		quick.pressed.emit()
		await process_frame
		var label := current_scene.find_child("ManualText", true, false) as RichTextLabel
		check(label != null and label.is_visible_in_tree(), "manual opens during recovery")
		if label != null:
			var content := label.get_parsed_text()
			check(content.contains("실제 출구 방향을 표시함"), "show actual saved interpretation, not only the rule title")
			check(not content.contains("피해자가 지나간 순서를 거꾸로 표시함"), "do not substitute the unselected candidate")
			check(content.contains("미작성"), "retain incomplete slot uncertainty")
			check(content.contains("미검증"), "draft is not a verified rule")
	current_scene.queue_free()
	for i in range(3):
		await process_frame
	check(guard.restore().is_empty(), "restore guarded save")
	for message in failures:
		push_error(message)
	print("Authored manual recovery handoff: ", failures.size(), " failures")
	quit(0 if failures.is_empty() else 1)
