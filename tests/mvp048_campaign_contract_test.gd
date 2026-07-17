extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")

var _guard := TestSaveGuard.new()
var _prepared := false
var _passed := 0
var _failed := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state = root.get_node("GameState")
	var guard_error := _guard.prepare(game_state.SAVE_FILE_PATH)
	if not guard_error.is_empty():
		_fail(guard_error)
		_finish()
		return
	_prepared = true
	game_state.reset_run_state()
	_expect(game_state.load_episode("res://data/episodes/episode_004_unconfirmed_arrival.json"), "fourth episode JSON loads")
	_expect(game_state.get_current_episode_id() == "episode_004_unconfirmed_arrival", "fourth episode preserves its ID")
	_expect(game_state.get_investigation_points().size() == 3, "fourth episode exposes three investigation points")
	_expect(game_state.get_recovery_patterns().size() == 3, "fourth episode exposes three recovery patterns")

	var campaign = game_state.get_campaign_snapshot()
	for _index in range(7):
		game_state.advance_campaign_day(false)
	campaign = game_state.get_campaign_snapshot()
	var arrival: Dictionary = campaign.get("cases", {}).get("episode_004_unconfirmed_arrival", {})
	_expect(String(arrival.get("discovery_state", "unknown")) == "lead", "fourth episode becomes a Day 8 lead")
	_expect(_has_entry(game_state.get_preparation_episode_entries(), "episode_004_unconfirmed_arrival"), "Day 8 preparation lists the fourth episode")

	var contracts: Array = game_state.get_mercenary_contracts()
	_expect(_has_entry(contracts, "contract_camila_vargas"), "Camila external contract is catalogued")
	_expect(_has_entry(contracts, "contract_park_doyoon"), "Park external contract is catalogued")
	_expect(_has_entry(contracts, "contract_lee_serin"), "Lee external contract is catalogued")
	game_state.research_points = 4
	_expect(bool(game_state.complete_research_project("research_boundary_protocol").get("successful", false)), "boundary protocol consumes four research points")
	var reserved: Dictionary = game_state.select_mercenary_contract("contract_camila_vargas")
	_expect(bool(reserved.get("successful", false)), "Camila contract can be reserved after research")
	_expect(game_state.get_echo_fragments() == 30, "reservation does not charge fragments")
	_expect(game_state.set_campaign_planned_case("episode_004_unconfirmed_arrival"), "fourth episode can be planned")
	_expect(game_state.begin_campaign_operation("episode_004_unconfirmed_arrival"), "contract deploys to fourth episode")
	_expect(game_state.get_echo_fragments() == 0, "Camila contract charges exactly 30 fragments")
	_expect(int(game_state.consume_active_mercenary_safety_line(9).get("reduction", 0)) == 4, "Camila contract is one-time four-point mitigation")
	_expect(int(game_state.consume_active_mercenary_safety_line(9).get("reduction", 0)) == 0, "external contract cannot mitigate twice")
	_expect(game_state.save_game() and game_state.load_game(), "MVP-048 campaign and active contract survive save round-trip")
	_finish()


func _has_entry(entries: Array, id: String) -> bool:
	for value in entries:
		if typeof(value) == TYPE_DICTIONARY and String((value as Dictionary).get("id", "")) == id:
			return true
	return false


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
		print("MVP-048 campaign and contracts: %d passed, 0 failed" % _passed)
		quit(0)
	else:
		push_error("MVP-048 campaign and contracts: %d passed, %d failed" % [_passed, _failed])
		quit(1)
