extends Node

const TestSaveGuard = preload("res://tests/test_save_guard.gd")
var _guard := TestSaveGuard.new()
var _passed := 0
var _failed := 0


func _ready() -> void:
	var error := _guard.prepare(GameState.SAVE_FILE_PATH)
	if not error.is_empty():
		push_error(error)
		get_tree().quit(1)
		return
	_run()
	_guard.restore()
	print("MVP-034: %d passed, %d failed" % [_passed, _failed])
	get_tree().quit(0 if _failed == 0 else 1)


func _run() -> void:
	GameState.reset_run_state()
	_check(GameState.get_echo_fragments() == 30, "starting support is 30")
	_check(GameState.grant_echo_reward("test:first_clue", 5), "first unique reward granted")
	_check(not GameState.grant_echo_reward("test:first_clue", 5), "duplicate reward rejected")
	_check(GameState.get_echo_fragments() == 35, "reward is idempotent")

	_check(GameState.get_faction_tier("rumor_market") == "neutral", "market starts neutral")
	GameState.change_faction_relation("rumor_market", 25, "test:friendly")
	_check(GameState.get_faction_tier("rumor_market") == "favorable", "favorable threshold")
	_check(GameState.get_market_price("consumable_mental_incense") == 23, "favorable ten percent discount rounded")
	GameState.change_faction_relation("rumor_market", 30, "test:trusted")
	_check(GameState.get_market_price("consumable_mental_incense") == 20, "trusted twenty percent discount")

	GameState.grant_echo_reward("test:funding", 500)
	_check(GameState.purchase_market_item("gear_resonance_prism").get("successful", false), "permanent equipment purchase")
	_check(GameState.has_unlocked_equipment("gear_resonance_prism"), "permanent equipment unlocked")
	_check(not GameState.purchase_market_item("gear_resonance_prism").get("successful", false), "permanent duplicate blocked")
	_check(GameState.equip_item("gear_resonance_prism"), "purchased permanent equipment equips")

	for _i in range(3):
		_check(GameState.purchase_market_item("consumable_prediction_film").get("successful", false), "consumable purchase")
	_check(not GameState.purchase_market_item("consumable_prediction_film").get("successful", false), "consumable cap three")
	_check(GameState.set_consumable_loadout("consumable_prediction_film", 2), "carry consumable")
	_check(GameState.get_consumable_loadout().get("consumable_prediction_film", 0) == 2, "loadout quantity")
	_check(GameState.purchase_market_item("consumable_mental_incense").get("successful", false), "second consumable type purchase")
	_check(GameState.purchase_market_item("consumable_first_aid").get("successful", false), "third consumable type purchase")
	_check(GameState.set_consumable_loadout("consumable_mental_incense", 1), "second loadout type")
	_check(not GameState.set_consumable_loadout("consumable_first_aid", 1), "third loadout type blocked")
	var before_use := int(GameState.get_consumable_inventory().get("consumable_prediction_film", 0))
	_check(GameState.use_loaded_consumable("consumable_prediction_film"), "loaded consumable use")
	_check(int(GameState.get_consumable_inventory().get("consumable_prediction_film", 0)) == before_use - 1, "use consumes inventory")
	_check(GameState.consume_active_consumable_effect("consumable_prediction_film"), "active effect consumed once")

	_check(GameState.complete_faction_request("request_test_mage", "mage_society"), "request completes once")
	_check(not GameState.complete_faction_request("request_test_mage", "mage_society"), "request duplicate blocked")
	_check(GameState.get_faction_relation("mage_society") == 10, "request relation reward")
	GameState.change_faction_relation("rumor_market", -155, "test:hostile")
	_check(GameState.get_faction_tier("rumor_market") == "hostile", "hostile threshold")
	_check(not GameState.purchase_market_item("consumable_shielding_cloth").get("successful", false), "hostile market lock")
	var reward_before := GameState.get_echo_fragments()
	_check(GameState.grant_resolution_echo_reward("episode_test", "temporary") == 30, "temporary resolution reward")
	_check(GameState.grant_resolution_echo_reward("episode_test", "standard") == 25, "standard upgrade grants difference")
	_check(GameState.grant_resolution_echo_reward("episode_test", "temporary") == 0, "lower replay grants nothing")
	_check(GameState.grant_resolution_echo_reward("episode_test", "complete") == 20, "complete upgrade grants difference")
	_check(GameState.get_echo_fragments() == reward_before + 75, "one episode grants at most complete total")

	GameState.save_game()
	var fragments := GameState.get_echo_fragments()
	GameState.reset_run_state()
	_check(GameState.load_game(), "load mvp034 save")
	_check(GameState.get_echo_fragments() == fragments, "currency round trip")
	_check(GameState.get_consumable_inventory().get("consumable_prediction_film", 0) == 2, "inventory round trip")
	_check(GameState.get_completed_faction_requests().has("request_test_mage"), "request round trip")
	_check(GameState.get_faction_relation("rumor_market") == -100, "faction relation round trip")
	_check(GameState.has_unlocked_equipment("gear_resonance_prism") and GameState.has_equipped_item("gear_resonance_prism"), "permanent purchase and equip round trip")
	_check(GameState.get_consumable_loadout().get("consumable_prediction_film", 0) == 1, "loadout round trip")
	_check(not GameState.grant_echo_reward("test:first_clue", 5), "reward id remains idempotent after reload")
	_check(GameState.grant_resolution_echo_reward("episode_test", "complete") == 0, "resolution best grade persists")
	var prediction := GameState.roll_anomaly_prediction()
	_check(float(prediction.get("rate", 0.0)) == 35.0, "equipped prism and carried film affect real prediction")
	GameState.reset_run_state()
	_check(GameState.load_game(), "reload immediately after prediction film use")
	_check(GameState.get_consumable_inventory().get("consumable_prediction_film", 0) == 1, "prediction film consumption persists")
	_check(not GameState.get_consumable_loadout().has("consumable_prediction_film"), "consumed film leaves loadout after reload")

	var legacy_file := FileAccess.open(GameState.SAVE_FILE_PATH, FileAccess.WRITE)
	legacy_file.store_string(JSON.stringify({
		"save_version": "mvp-033",
		"episode_path": GameState.DEFAULT_EPISODE_PATH,
		"stability_schema_version": 2,
		"anomaly_stability": 25
	}))
	legacy_file.close()
	_check(GameState.load_game(), "load actual mvp033-shaped save")
	_check(GameState.get_echo_fragments() == 30, "mvp033 save receives starting support")
	_check(GameState.get_faction_relation("rumor_market") == 0, "mvp033 save receives neutral factions")
	_check(GameState.get_consumable_inventory().is_empty(), "mvp033 save receives empty market inventory")


func _check(condition: bool, label: String) -> void:
	if condition:
		_passed += 1
	else:
		_failed += 1
		push_error("FAIL: %s" % label)
