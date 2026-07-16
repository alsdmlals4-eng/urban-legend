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
	game_state.research_points = 5
	if not bool(game_state.complete_research_project("research_contract_protocol").get("successful", false)):
		_fail("contract protocol setup failed")
		_finish()
		return
	game_state.grant_echo_reward("test:raymond-recovery", 5)
	game_state.select_mercenary_contract("contract_raymond_kane")
	game_state.set_campaign_planned_case("episode_001_afterlife_station")
	if not game_state.begin_campaign_operation("episode_001_afterlife_station"):
		_fail("contract deployment setup failed")
		_finish()
		return

	var battle_scene := load("res://scenes/battle_scene.tscn") as PackedScene
	_expect(battle_scene != null, "battle scene loads after the GameState autoload is ready")
	if battle_scene == null:
		_finish()
		return
	var battle: Node = battle_scene.instantiate()
	root.add_child(battle)
	await process_frame
	await process_frame
	battle.set("_turn_auto_success_agents", {"agent_kwon_narae": true, "agent_oh_hyun": true, "agent_kang_ijun": true})
	var pattern: Dictionary = battle.get("_current_pattern")
	var wrong_response: Dictionary = {}
	for response_value in pattern.get("responses", []):
		if typeof(response_value) == TYPE_DICTIONARY and String((response_value as Dictionary).get("id", "")) != String(pattern.get("correct_response_id", "")):
			wrong_response = (response_value as Dictionary).duplicate(true)
			break
	_expect(not wrong_response.is_empty(), "recovery pattern exposes a wrong response for the risk contract check")
	var representative: Dictionary = battle.call("_get_representative_agent")
	var representative_id := String(representative.get("id", ""))
	var before_mental: int = game_state.get_agent_current_mental(representative_id)
	if not wrong_response.is_empty():
		battle.call("_select_pattern_response", wrong_response)
		await process_frame
		await process_frame
	_expect(before_mental - game_state.get_agent_current_mental(representative_id) == 5, "Raymond safety line reduces the first recovery risk loss from 10 to 5")
	_expect(bool(game_state.get_active_mercenary_contract().get("safety_line_used", false)), "recovery risk consumes the one-event safety line")
	battle.queue_free()
	await process_frame
	await process_frame
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
		print("MVP-047 Raymond recovery: %d passed, 0 failed" % _passed)
		quit(0)
	else:
		push_error("MVP-047 Raymond recovery: %d passed, %d failed" % [_passed, _failed])
		quit(1)
