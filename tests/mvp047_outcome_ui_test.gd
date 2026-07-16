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
	_prepare_completed_contract_report(game_state)

	var result_script = load("res://scripts/scenes/result_scene.gd")
	_expect(result_script != null, "result scene script loads for outcome visibility")
	if result_script != null:
		var result: Node = result_script.new()
		root.add_child(result)
		await process_frame
		_expect(result.find_child("CompletedResearchOutcome", true, false) != null, "result screen has a dedicated completed-research outcome section")
		_expect(result.find_child("ExternalContractOutcome", true, false) != null, "result screen has a dedicated external-contract outcome section")
		result.queue_free()
		await process_frame

	var database_script = load("res://scripts/ui/database_view.gd")
	_expect(database_script != null, "database view script loads for report visibility")
	if database_script != null:
		var database: Node = database_script.new()
		root.add_child(database)
		await process_frame
		database.call("_show_completed_case_reports")
		await process_frame
		_expect(database.find_child("CompletedResearchReport", true, false) != null, "completed-case database report includes completed research")
		_expect(database.find_child("ExternalContractReport", true, false) != null, "completed-case database report includes the external safety-line outcome")
		database.queue_free()
		await process_frame
	_finish()


func _prepare_completed_contract_report(game_state: Node) -> void:
	game_state.reset_run_state()
	game_state.research_points = 8
	game_state.complete_research_project("research_resonance_prism")
	game_state.complete_research_project("research_contract_protocol")
	game_state.grant_echo_reward("test:outcome-ui", 5)
	game_state.select_mercenary_contract("contract_raymond_kane")
	game_state.set_campaign_planned_case("episode_001_afterlife_station")
	game_state.begin_campaign_operation("episode_001_afterlife_station")
	game_state.consume_active_mercenary_safety_line(10)
	game_state.save_recovery_result(true, "core_recovered", 100)
	game_state.record_current_case_report()


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
		print("MVP-047 outcome UI: %d passed, 0 failed" % _passed)
		quit(0)
	else:
		push_error("MVP-047 outcome UI: %d passed, %d failed" % [_passed, _failed])
		quit(1)
