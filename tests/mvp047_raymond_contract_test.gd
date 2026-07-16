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
	_expect(game_state.has_method("select_mercenary_contract"), "temporary contract selection API is available")
	_expect(game_state.has_method("get_active_mercenary_contract"), "active contract accessor is available")
	_expect(game_state.has_method("consume_active_mercenary_safety_line"), "temporary safety-line API is available")
	if not game_state.has_method("select_mercenary_contract") or not game_state.has_method("get_active_mercenary_contract") or not game_state.has_method("consume_active_mercenary_safety_line"):
		_finish()
		return

	var blocked: Dictionary = game_state.select_mercenary_contract("contract_raymond_kane")
	_expect(not bool(blocked.get("successful", false)), "Raymond contract requires the completed safety protocol")
	game_state.research_points = 5
	_expect(bool(game_state.complete_research_project("research_contract_protocol").get("successful", false)), "five research points complete the contract protocol")
	var selected: Dictionary = game_state.select_mercenary_contract("contract_raymond_kane")
	_expect(bool(selected.get("successful", false)), "completed protocol can reserve Raymond for the next event")
	_expect(game_state.get_echo_fragments() == 30, "reserving a contract does not charge fragments before deployment")

	_expect(game_state.set_campaign_planned_case("episode_001_afterlife_station"), "case can be planned before contract deployment")
	_expect(not game_state.begin_campaign_operation("episode_001_afterlife_station"), "deployment is blocked when the 35 fragment contract price is unavailable")
	_expect(game_state.get_active_mercenary_contract().is_empty(), "failed deployment does not activate the contract")
	_expect(game_state.grant_echo_reward("test:raymond-contract", 5), "test reward raises fragments to the contract price")
	_expect(game_state.begin_campaign_operation("episode_001_afterlife_station"), "deployment pays and activates the one-event contract")
	_expect(game_state.get_echo_fragments() == 0, "contract charges exactly 35 fragments at deployment")
	var active: Dictionary = game_state.get_active_mercenary_contract()
	_expect(String(active.get("id", "")) == "contract_raymond_kane", "Raymond contract is active for the deployed case")
	_expect(int(game_state.consume_active_mercenary_safety_line(10).get("reduction", 0)) == 5, "first risk result receives only the five point safety reduction")
	_expect(int(game_state.consume_active_mercenary_safety_line(10).get("reduction", 0)) == 0, "contract does not reduce a second risk result")

	_expect(game_state.save_game() and game_state.load_game(), "active contract uses the normal save path")
	_expect(String(game_state.get_active_mercenary_contract().get("id", "")) == "contract_raymond_kane", "active contract survives reload without a second charge")
	_expect(game_state.complete_campaign_slot({"kind": "investigation"}), "contracted operation can enter the normal result state")
	_expect(bool(game_state.acknowledge_campaign_slot_result().get("advanced", false)), "result acknowledgement advances the current half-day")
	_expect(game_state.get_active_mercenary_contract().is_empty(), "contract clears after its one event is acknowledged")
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
		print("MVP-047 Raymond contract: %d passed, 0 failed" % _passed)
		quit(0)
	else:
		push_error("MVP-047 Raymond contract: %d passed, %d failed" % [_passed, _failed])
		quit(1)
