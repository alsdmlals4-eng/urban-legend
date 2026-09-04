extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")

var _guard := TestSaveGuard.new()
var _prepared := false


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node("GameState")
	var error := _guard.prepare(game_state.SAVE_FILE_PATH)
	if not error.is_empty():
		_fail(error)
		return
	_prepared = true
	game_state.reset_run_state()
	game_state.set_selected_agent_ids(["agent_kang_ijun", "agent_kwon_narae"])
	for agent in game_state.get_agents():
		var agent_id := String(agent.get("id", ""))
		var activity := "investigation" if game_state.is_agent_selected(agent_id) else "rest"
		if not game_state.set_campaign_schedule(agent_id, "morning", activity):
			_fail("failed to arrange morning fixture")
			return
	if not game_state.set_campaign_planned_case("episode_001_afterlife_station") or not game_state.begin_campaign_operation("episode_001_afterlife_station"):
		_fail("failed to begin campaign operation fixture")
		return
	if change_scene_to_file(game_state.SCENE_INVESTIGATION) != OK:
		_fail("investigation scene failed to load")
		return
	for _frame in range(5):
		await process_frame
	current_scene.call("_return_to_hq")
	for _frame in range(5):
		await process_frame
	if current_scene.scene_file_path != game_state.SCENE_PREPARATION:
		_fail("HQ return did not open preparation")
		return
	var operation: Dictionary = game_state.get_active_campaign_operation()
	if String(operation.get("status", "")) != "suspended" or game_state.get_campaign_slot_phase() != "in_progress":
		_fail("HQ return did not preserve a suspended half-day operation")
		return
	var restore_error := _guard.restore()
	_prepared = false
	if not restore_error.is_empty():
		_fail(restore_error)
		return
	print("investigation_return_flow_test: PASS")
	quit(0)


func _fail(message: String) -> void:
	if _prepared:
		_guard.restore()
		_prepared = false
	push_error(message)
	quit(1)
