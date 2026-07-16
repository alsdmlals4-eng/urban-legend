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

	game_state.research_points = 8
	_expect(bool(game_state.complete_research_project("research_resonance_prism").get("successful", false)), "a completed research project is available for the outcome snapshot")
	_expect(bool(game_state.complete_research_project("research_contract_protocol").get("successful", false)), "the contract protocol is available for the outcome snapshot")
	_expect(game_state.grant_echo_reward("test:outcome-history", 5), "test setup supplies the contract fragments")
	_expect(bool(game_state.select_mercenary_contract("contract_raymond_kane").get("successful", false)), "Raymond can be reserved for the outcome snapshot")
	_expect(game_state.set_campaign_planned_case("episode_001_afterlife_station"), "the Afterlife case can be planned")
	_expect(game_state.begin_campaign_operation("episode_001_afterlife_station"), "the reserved contract becomes active on deployment")
	_expect(int(game_state.consume_active_mercenary_safety_line(10).get("reduction", 0)) == 5, "the report setup consumes Raymond's one-time safety line")

	game_state.save_recovery_result(true, "core_recovered", 100)
	_expect(game_state.record_current_case_report(), "a successful recovery records a completed-case report")
	var report := _afterlife_report(game_state.get_completed_case_reports())
	var project_ids := _entry_ids(report.get("completed_research_projects", []))
	_expect(project_ids.has("research_resonance_prism"), "completed research is copied into the completed-case report")
	_expect(project_ids.has("research_contract_protocol"), "contract protocol research is copied into the completed-case report")
	var contract: Dictionary = report.get("external_contract", {})
	_expect(String(contract.get("id", "")) == "contract_raymond_kane", "the active Raymond contract is copied into the completed-case report")
	_expect(bool(contract.get("safety_line_used", false)), "the completed-case report preserves whether Raymond's safety line was used")

	_expect(game_state.complete_campaign_slot({"kind": "investigation"}), "the completed case can enter acknowledgement")
	_expect(bool(game_state.acknowledge_campaign_slot_result().get("advanced", false)), "acknowledgement clears the live one-event contract")
	_expect(game_state.get_active_mercenary_contract().is_empty(), "the active contract is no longer available after acknowledgement")
	_expect(game_state.save_game() and game_state.load_game(), "the normal save path reloads the completed report")
	report = _afterlife_report(game_state.get_completed_case_reports())
	contract = report.get("external_contract", {})
	_expect(String(contract.get("id", "")) == "contract_raymond_kane", "the report keeps Raymond's contract after the live contract ends")
	_expect(bool(contract.get("safety_line_used", false)), "the saved report keeps the used safety-line state")
	_finish()


func _afterlife_report(reports: Array) -> Dictionary:
	for value in reports:
		if typeof(value) == TYPE_DICTIONARY and String((value as Dictionary).get("episode_id", "")) == "episode_001_afterlife_station":
			return (value as Dictionary).duplicate(true)
	return {}


func _entry_ids(entries: Array) -> Array:
	var ids: Array = []
	for value in entries:
		if typeof(value) == TYPE_DICTIONARY:
			ids.append(String((value as Dictionary).get("id", "")))
	return ids


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
		print("MVP-047 outcome history: %d passed, 0 failed" % _passed)
		quit(0)
	else:
		push_error("MVP-047 outcome history: %d passed, %d failed" % [_passed, _failed])
		quit(1)
