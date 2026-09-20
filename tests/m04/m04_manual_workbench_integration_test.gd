extends SceneTree

const TestSaveGuard := preload("res://tests/test_save_guard.gd")
const M04_EPISODE_PATH := "res://data/episodes/episode_002_red_umbrella_alley.json"
const M04_EPISODE_ID := "episode_002_red_umbrella_alley"

var _guard := TestSaveGuard.new()
var _prepared := false
var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node_or_null("GameState")
	_expect(game_state != null, "GameState autoload missing")
	if game_state == null:
		_finish()
		return
	var guard_error := _guard.prepare(game_state.get_save_file_path())
	_expect(guard_error.is_empty(), guard_error)
	if not guard_error.is_empty():
		_finish()
		return
	_prepared = true
	game_state.reset_run_state()
	_expect(game_state.load_episode(M04_EPISODE_PATH), "M04 episode failed to load")
	_expect(game_state.get_current_episode_id() == M04_EPISODE_ID, "M04 episode identity missing")
	var manual_value: Variant = game_state.get_current_episode().get("investigation_manual", {})
	_expect(manual_value is Dictionary and not (manual_value as Dictionary).is_empty(), "M04 runtime manual missing")
	if not manual_value is Dictionary or (manual_value as Dictionary).is_empty():
		_finish()
		return
	var manual := manual_value as Dictionary
	var candidate := _first_candidate(manual)
	_expect(not candidate.is_empty(), "M04 manual has no candidate fixture")
	if candidate.is_empty():
		_finish()
		return
	var source_record_id := String(candidate.get("source_record_id", ""))
	_expect(game_state.collect_clue(source_record_id), "M04 candidate source record could not be earned")
	if change_scene_to_file(game_state.SCENE_INVESTIGATION) != OK:
		_expect(false, "M04 investigation scene failed to load")
		_finish()
		return
	for _frame in range(5):
		await process_frame
	var scene := current_scene
	_expect(scene.has_method("_get_player_authored_workbench_manual"), "InvestigationScene must expose the shared authored-manual entry")
	var toggle := scene.find_child("ManualToggleButton", true, false) as Button
	_expect(toggle != null and toggle.visible, "M04 investigation has no visible manual entry")
	if toggle != null:
		toggle.emit_signal("pressed")
	for _frame in range(3):
		await process_frame
	var workbench := scene.find_child("ManualDeductionWorkbench", true, false) as Control
	_expect(workbench != null and workbench.visible, "M04 manual entry did not open the player-authored workbench")
	if workbench == null:
		_finish()
		return
	_expect(game_state.get_manual_draft_slots(manual, M04_EPISODE_ID).is_empty(), "reading observations must not author a draft automatically")
	_expect(_visible_text_contains(workbench, scene.call("_player_authored_manual_case_label")), "header must reflect the current case model supplied after scene readiness")
	_expect(workbench.find_children("SourceObservation_%s" % source_record_id, "Label", true, false).size() == 1, "candidate alternatives must share one original observation, not duplicate it")
	var lume_portrait := workbench.find_child("LumePortrait", true, false) as TextureRect
	_expect(lume_portrait != null and not lume_portrait.visible, "M04 guide must not display the CASE-01 Lume portrait")
	_expect(_visible_text_contains(workbench, "루메"), "M04 guide must preserve Lume identity without using the station outfit")
	_expect(not _visible_text_contains(workbench, "기록관 아카"), "retired guide identity must not return")
	for clue_value in game_state.get_clues():
		var clue: Dictionary = clue_value
		var description := String(clue.get("description", ""))
		if description.is_empty():
			continue
		if String(clue.get("id", "")) == source_record_id:
			_expect(_visible_text_contains(workbench, description), "earned original observation must be readable beside deduction")
		else:
			_expect(not _visible_text_contains(workbench, description), "unearned original observation must not leak")
	for viewport_size in [Vector2i(1280, 720), Vector2i(1920, 1080)]:
		root.size = viewport_size
		for _frame in range(2):
			await process_frame
		var dossier := workbench.find_child("DossierFrame", true, false) as Control
		_expect(_inside_viewport(dossier, Rect2(Vector2.ZERO, Vector2(viewport_size))), "%s M04 dossier frame must remain inside the supported viewport" % viewport_size)
		for slot_control in workbench.find_children("Slot_*", "Button", true, false):
			_expect(slot_control.size.y <= 90.0, "%s deduction slot must not stretch into a tall column" % viewport_size)
		for flow in workbench.find_children("DeductionLine*", "HFlowContainer", true, false):
			for word in flow.get_children():
				if word is Label:
					_expect(word.size.y <= 50.0, "%s inline text must wrap by words, not narrow character columns" % viewport_size)
		if DisplayServer.get_name() != "headless":
			await RenderingServer.frame_post_draw
			var capture := root.get_texture().get_image()
			var capture_path := "res://.artifacts/daily-case-20260912/manual-wrap-%dx%d.png" % [capture.get_width(), capture.get_height()]
			_expect(capture.save_png(ProjectSettings.globalize_path(capture_path)) == OK, "save actual manual framebuffer")
	var page_id := String(candidate.get("page_id", ""))
	var slot_id := _first_slot_id_for_page(manual, page_id)
	var slot := workbench.find_child("Slot_%s" % slot_id, true, false) as Button
	var candidate_button := workbench.find_child("Candidate_%s" % String(candidate.get("id", "")), true, false) as Button
	_expect(slot != null, "M04 workbench did not render a writable deduction slot")
	_expect(candidate_button != null, "M04 workbench did not show the source-earned candidate")
	if slot != null and candidate_button != null:
		slot.emit_signal("pressed")
		candidate_button.emit_signal("pressed")
		await process_frame
		var drafts: Dictionary = game_state.get_manual_draft_slots(manual, M04_EPISODE_ID)
		_expect(String(drafts.get(slot_id, "")) == String(candidate.get("id", "")), "M04 manual candidate placement did not persist as a draft")
		for viewport_size in [Vector2i(1280, 720), Vector2i(1920, 1080)]:
			root.size = viewport_size
			for _frame in range(3):
				await process_frame
			var filled_slot := workbench.find_child("Slot_%s" % slot_id, true, false) as Button
			_expect(filled_slot != null and filled_slot.size.y <= 90.0, "%s filled keyword stays a readable inline slot" % viewport_size)
		_expect(workbench.find_child("SourceObservation_%s" % source_record_id, true, false) != null, "observation comparison must remain available after draft placement")
		_expect(not _visible_text_contains(workbench, "정답") and not _visible_text_contains(workbench, "오답"), "M04 manual exposed an answer verdict")
	_finish()


func _first_candidate(manual: Dictionary) -> Dictionary:
	for candidate_value in manual.get("candidate_keywords", []) as Array:
		if candidate_value is Dictionary:
			return (candidate_value as Dictionary).duplicate(true)
	return {}


func _first_slot_id_for_page(manual: Dictionary, page_id: String) -> String:
	for page_value in manual.get("pages", []) as Array:
		if not page_value is Dictionary:
			continue
		var page := page_value as Dictionary
		if String(page.get("id", "")) != page_id:
			continue
		for segment_value in page.get("deduction_segments", []) as Array:
			if segment_value is Dictionary and String((segment_value as Dictionary).get("kind", "")) == "slot":
				return String((segment_value as Dictionary).get("slot_id", ""))
	return ""


func _visible_text_contains(node: Node, needle: String) -> bool:
	for child in node.find_children("*", "Label", true, false) + node.find_children("*", "Button", true, false):
		if child is Control and (child as Control).is_visible_in_tree() and String(child.get("text")).contains(needle):
			return true
	return false


func _inside_viewport(control: Control, viewport_rect: Rect2) -> bool:
	if control == null or not control.is_visible_in_tree():
		return false
	var rect := control.get_global_rect()
	return rect.size.x > 0.0 and rect.size.y > 0.0 and viewport_rect.encloses(rect)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	call_deferred("_finish_clean")


func _finish_clean() -> void:
	var audio_probe := preload("res://tests/test_audio_lifecycle.gd").new()
	if current_scene != null:
		audio_probe.capture(current_scene)
		current_scene.queue_free()
	for frame in range(3):
		await process_frame
	var retained: Array[String] = await audio_probe.wait_for_release(self)
	_expect(retained.is_empty(), "M04 manual audio must retire before shutdown: %s" % str(retained))
	if _prepared:
		var restore_error := _guard.restore()
		if not restore_error.is_empty():
			_failures.append(restore_error)
		_prepared = false
	if _failures.is_empty():
		print("M04 MANUAL WORKBENCH INTEGRATION: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
