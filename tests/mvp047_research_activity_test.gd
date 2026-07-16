extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")

var _guard := TestSaveGuard.new()
var _prepared := false
var _passed := 0
var _failed := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node("GameState")
	var guard_error := _guard.prepare(game_state.SAVE_FILE_PATH)
	if not guard_error.is_empty():
		_fail(guard_error)
		_finish()
		return
	_prepared = true
	game_state.reset_run_state()
	_expect(game_state.has_method("get_research_points"), "research point accessor is available")
	_expect(game_state.has_method("get_research_activity_preview"), "research preview is available")
	if not game_state.has_method("get_research_points") or not game_state.has_method("get_research_activity_preview"):
		_finish()
		return
	var protagonist_id: String = String(game_state.get_protagonist_agent_id())
	_expect(game_state.get_research_points() == 0, "new campaign starts with no research points")
	_expect(game_state.set_campaign_schedule(protagonist_id, "morning", "research"), "research is a valid protagonist half-day activity")
	var preview: Dictionary = game_state.get_research_activity_preview(protagonist_id)
	_expect(int(preview.get("minimum", 0)) == 1 and int(preview.get("maximum", 0)) == 3, "research preview exposes the 1 to 3 point formula")
	_expect(game_state.save_game() and game_state.load_game(), "planned research reloads through the normal save path")
	var restored_preview: Dictionary = game_state.get_research_activity_preview(protagonist_id)
	_expect(int(restored_preview.get("total", 0)) == int(preview.get("total", -1)), "planned research cannot reroll after saving and reloading")
	var result: Dictionary = game_state.resolve_non_investigation_campaign_slot([protagonist_id])
	_expect(not result.has("error"), "research activity resolves through the normal half-day flow")
	var awarded := int((result.get("results", [{}]) as Array)[0].get("research_points", 0))
	_expect(awarded >= 1 and awarded <= 3, "research awards only the approved 1 to 3 point range")
	_expect(game_state.get_research_points() == awarded, "research points persist after the half-day result")
	_expect(game_state.load_game(), "research result reloads through the normal save path")
	_expect(game_state.get_research_points() == awarded, "research points survive a save round-trip")
	var legacy_file := FileAccess.open(game_state.SAVE_FILE_PATH, FileAccess.WRITE)
	legacy_file.store_string(JSON.stringify({
		"save_version": "mvp-045",
		"episode_path": game_state.DEFAULT_EPISODE_PATH,
		"selected_agent_ids": ["agent_kwon_narae", "agent_oh_hyun", "agent_kang_ijun"]
	}))
	legacy_file.close()
	_expect(game_state.load_game(), "mvp-045 save migrates without a research field")
	_expect(game_state.get_research_points() == 0, "mvp-045 save receives zero research points")
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		_passed += 1
	else:
		_fail(message)


func _fail(message: String) -> void:
	_failed += 1
	push_error(message)


func _finish() -> void:
	if _prepared:
		var restore_error := _guard.restore()
		_prepared = false
		if not restore_error.is_empty():
			_fail(restore_error)
	if _failed == 0:
		print("MVP-047 research activity: %d passed, 0 failed" % _passed)
		quit(0)
	else:
		push_error("MVP-047 research activity: %d passed, %d failed" % [_passed, _failed])
		quit(1)
