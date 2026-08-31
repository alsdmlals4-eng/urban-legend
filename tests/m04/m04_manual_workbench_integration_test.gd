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
	var lume_portrait := workbench.find_child("LumePortrait", true, false) as TextureRect
	_expect(lume_portrait != null and lume_portrait.visible, "M04 manual must show its scenario-specific Lume portrait")
	if lume_portrait != null:
		_expect(lume_portrait.texture != null and lume_portrait.texture.resource_path == "res://assets/ui/guides/lume_red_umbrella_alley.png", "M04 manual must not reuse the CASE-01 station costume")
	_expect(_visible_text_contains(workbench, "루메"), "M04 guide identity must be Lume")
	_expect(not _visible_text_contains(workbench, "기록관 아카"), "M04 workbench must not expose the superseded Aka identity")
	for viewport_size in [Vector2i(1280, 720), Vector2i(1920, 1080)]:
		root.size = viewport_size
		for _frame in range(2):
			await process_frame
		var dossier := workbench.find_child("DossierFrame", true, false) as Control
		_expect(_inside_viewport(dossier, Rect2(Vector2.ZERO, Vector2(viewport_size))), "%s M04 dossier frame must remain inside the supported viewport" % viewport_size)
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
