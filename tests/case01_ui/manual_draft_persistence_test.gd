extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")

const EPISODE_ID := "episode_001_afterlife_station"

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
	var guard_error := _guard.prepare(String(game_state.get_save_file_path()))
	_expect(guard_error.is_empty(), "could not protect player save: %s" % guard_error)
	if not guard_error.is_empty():
		_finish()
		return
	_prepared = true
	game_state.reset_run_state()
	_expect(game_state.has_method("get_manual_draft_slots"), "GameState has no manual draft reader")
	_expect(game_state.has_method("set_manual_draft_slot"), "GameState has no manual draft writer")
	if game_state.has_method("get_manual_draft_slots") and game_state.has_method("set_manual_draft_slot"):
		_test_draft_persistence(game_state)
	_finish()


func _test_draft_persistence(game_state: Node) -> void:
	var manual := _manual_fixture()
	var empty_drafts: Dictionary = game_state.call("get_manual_draft_slots", manual, EPISODE_ID)
	_expect(empty_drafts.is_empty(), "old manual record should default to empty drafts")
	var rejected: Dictionary = game_state.call(
		"set_manual_draft_slot",
		manual,
		"page_a",
		"slot_a",
		"candidate_a",
		[],
		EPISODE_ID
	)
	_expect(not bool(rejected.get("ok", true)), "unearned candidate placement was persisted")
	_expect(game_state.call("get_manual_draft_slots", manual, EPISODE_ID).is_empty(), "rejected placement changed drafts")
	var placed: Dictionary = game_state.call(
		"set_manual_draft_slot",
		manual,
		"page_a",
		"slot_a",
		"candidate_a",
		["record_a"],
		EPISODE_ID
	)
	_expect(bool(placed.get("ok", false)), "earned candidate placement failed")
	_expect(String(game_state.call("get_manual_draft_slots", manual, EPISODE_ID).get("slot_a", "")) == "candidate_a", "placed draft is not readable")
	_expect(game_state.has_save_file(), "placing a draft did not save the existing game-state record")
	var saved := _read_json(String(game_state.get_save_file_path()))
	_expect(String(saved.get("save_version", "")) == "mvp-040", "draft write changed the current save version")
	_expect(not saved.has("draft_slots"), "drafts escaped the existing anomaly manual record branch")
	var saved_record: Dictionary = (saved.get("anomaly_manual_records", {}) as Dictionary).get(EPISODE_ID, {}) as Dictionary
	_expect(String((saved_record.get("draft_slots", {}) as Dictionary).get("slot_a", "")) == "candidate_a", "saved manual record lost draft slot")
	game_state.reset_run_state()
	_expect(game_state.load_game(), "saved draft did not reload")
	var restored: Dictionary = game_state.call("get_manual_draft_slots", manual, EPISODE_ID)
	_expect(String(restored.get("slot_a", "")) == "candidate_a", "draft did not survive real save/load")
	var afterlife_manual: Dictionary = game_state.get_afterlife_manual_state()
	_expect((afterlife_manual.get("filled_slots", {}) as Dictionary).is_empty(), "draft persistence wrote protected Canon migration slots")


func _manual_fixture() -> Dictionary:
	return {
		"pages": [{"id": "page_a", "slot_ids": ["slot_a"]}],
		"slots": [{"id": "slot_a", "page_id": "page_a"}],
		"evidence_records": [{"id": "record_a"}],
		"candidate_keywords": [{"id": "candidate_a", "page_id": "page_a", "source_record_id": "record_a"}]
	}


func _read_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	return parsed as Dictionary if typeof(parsed) == TYPE_DICTIONARY else {}


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
		print("MANUAL DRAFT PERSISTENCE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
