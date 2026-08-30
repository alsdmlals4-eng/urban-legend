extends SceneTree

const WORKBENCH_SCENE_PATH := "res://scenes/ui/manual_deduction_workbench.tscn"

var _failures: Array[String] = []
var _placement: Dictionary = {}
var _cleared_slot_id := ""
var _dismissed := false


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_expect(FileAccess.file_exists(WORKBENCH_SCENE_PATH), "manual deduction workbench scene missing")
	if not FileAccess.file_exists(WORKBENCH_SCENE_PATH):
		_finish()
		return
	var packed_value: Variant = load(WORKBENCH_SCENE_PATH)
	_expect(packed_value is PackedScene, "manual deduction workbench did not load as a scene")
	if not packed_value is PackedScene:
		_finish()
		return
	var host := Control.new()
	host.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_child(host)
	var opener := Button.new()
	opener.name = "ManualOpener"
	host.add_child(opener)
	var workbench := (packed_value as PackedScene).instantiate()
	host.add_child(workbench)
	_expect(workbench.has_method("set_view_model"), "workbench cannot receive a presentation model")
	_expect(workbench.has_method("open_workbench"), "workbench has no open behavior")
	if workbench.has_method("set_view_model"):
		workbench.call("set_view_model", _view_model())
	if workbench.has_signal("draft_slot_requested"):
		workbench.connect("draft_slot_requested", _on_draft_slot_requested)
	if workbench.has_signal("draft_slot_clear_requested"):
		workbench.connect("draft_slot_clear_requested", _on_draft_slot_clear_requested)
	if workbench.has_signal("dismiss_requested"):
		workbench.connect("dismiss_requested", _on_dismiss_requested)
	opener.grab_focus()
	await process_frame
	if workbench.has_method("open_workbench"):
		workbench.call("open_workbench", opener)
	await process_frame
	await process_frame
	_test_native_dossier_hierarchy(workbench)
	_test_slot_and_candidate_intent(workbench)
	_test_cancel_and_focus_restore(workbench, opener)
	host.queue_free()
	_finish()


func _test_native_dossier_hierarchy(workbench: Control) -> void:
	_expect(workbench.visible, "workbench should be visible after opening")
	_expect(workbench.find_child("DossierFrame", true, false) is Control, "workbench has no dossier frame")
	_expect(workbench.find_child("ManualIndex", true, false) is Container, "workbench has no left manual index")
	_expect(workbench.find_child("DeductionScroll", true, false) is ScrollContainer, "workbench has no readable central deduction scroll")
	var grid := workbench.find_child("CandidateGrid", true, false) as GridContainer
	_expect(grid != null and grid.columns == 2, "workbench candidates must use an equal two-column grid")
	var lume_panel := workbench.find_child("LumeGuidePanel", true, false) as Control
	var lume_portrait := workbench.find_child("LumePortrait", true, false) as TextureRect
	_expect(lume_panel != null, "workbench has no Lume guide panel")
	_expect(lume_portrait != null and lume_portrait.texture != null, "workbench has no approved Lume portrait texture")
	var first_slot := workbench.find_child("Slot_slot_a", true, false) as Button
	_expect(first_slot != null and first_slot.focus_mode != Control.FOCUS_NONE, "first writable slot must be keyboard focusable")
	_expect(root.gui_get_focus_owner() == first_slot, "first writable slot should receive focus on open")


func _test_slot_and_candidate_intent(workbench: Control) -> void:
	var slot := workbench.find_child("Slot_slot_a", true, false) as Button
	var candidate := workbench.find_child("Candidate_candidate_a", true, false) as Button
	_expect(slot != null and candidate != null, "fixture slot or candidate button missing")
	if slot == null or candidate == null:
		return
	slot.emit_signal("pressed")
	candidate.emit_signal("pressed")
	_expect(String(_placement.get("slot_id", "")) == "slot_a", "workbench did not emit selected slot id")
	_expect(String(_placement.get("candidate_id", "")) == "candidate_a", "workbench did not emit selected candidate id")
	_placement.clear()
	slot.emit_signal("pressed")
	_expect(_cleared_slot_id == "slot_a", "filled slot should offer clear intent without semantic verdict")


func _test_cancel_and_focus_restore(workbench: Control, opener: Button) -> void:
	var cancel := InputEventKey.new()
	cancel.keycode = KEY_ESCAPE
	cancel.pressed = true
	workbench.call("_unhandled_input", cancel)
	_expect(_dismissed, "Escape should emit workbench dismiss intent")
	_expect(not workbench.visible, "Escape should close the workbench before broader scene input")
	await process_frame
	_expect(root.gui_get_focus_owner() == opener, "workbench should restore opening control focus after Escape")


func _view_model() -> Dictionary:
	return {
		"case_label": "CASE-01 저승역",
		"title": "괴이 매뉴얼",
		"selected_page_id": "page_a",
		"pages": [
			{
				"id": "page_a",
				"title": "발생 조건",
				"deduction_segments": [
					{"kind": "text", "text": "원본 기록에는 "},
					{"kind": "slot", "slot_id": "slot_a"},
					{"kind": "text", "text": "가 남아 있다."}
				]
			}
		],
		"draft_slots": {"slot_a": ""},
		"candidate_keywords": [
			{
				"id": "candidate_a",
				"page_id": "page_a",
				"display_label": "목적지 구간의 무음 공백",
				"source_label": "출처: 안내방송 원본"
			},
			{
				"id": "candidate_b",
				"page_id": "page_a",
				"display_label": "개인이 들은 귀환 장소",
				"source_label": "출처: 휴대전화 기록"
			}
		],
		"lume": {
			"name": "루메",
			"message": "출처 기록과 문장을 함께 비교해 보세요."
		}
	}


func _on_draft_slot_requested(slot_id: String, candidate_id: String) -> void:
	_placement = {"slot_id": slot_id, "candidate_id": candidate_id}


func _on_draft_slot_clear_requested(slot_id: String) -> void:
	_cleared_slot_id = slot_id


func _on_dismiss_requested() -> void:
	_dismissed = true


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("MANUAL DEDUCTION WORKBENCH: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
