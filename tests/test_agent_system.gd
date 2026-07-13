# Ver 3.2 agent system headless validation test.
extends Node

const TestSaveGuard = preload("res://tests/test_save_guard.gd")
const EpisodeLoaderScript = preload("res://scripts/data/episode_loader.gd")

const ABILITY_KEYS := ["suppression", "analysis", "protection", "treatment", "rapport"]
const ABILITY_LABELS := {
	"suppression": "제압",
	"analysis": "분석",
	"protection": "방호",
	"treatment": "치료",
	"rapport": "교감"
}
const EXPECTED_MAX_HP := {"agent_kang_ijun": 120, "agent_kwon_narae": 85, "agent_oh_hyun": 100}
const EXPECTED_MAX_MENTAL := {"agent_kang_ijun": 80, "agent_kwon_narae": 120, "agent_oh_hyun": 100}
const EXPECTED_ABILITIES := {
	"agent_kang_ijun": [5, 3, 3, 1, 2],
	"agent_kwon_narae": [1, 5, 4, 3, 4],
	"agent_oh_hyun": [3, 4, 2, 4, 5]
}
const EPISODE_001 := "res://data/episodes/episode_001_afterlife_station.json"
const EPISODE_002 := "res://data/episodes/episode_002_red_umbrella_alley.json"

var _guard := TestSaveGuard.new()
var _all_passed := true
var _test_count := 0
var _fail_count := 0


func _ready() -> void:
	var prepare_error := _guard.prepare(GameState.SAVE_FILE_PATH)
	if not prepare_error.is_empty():
		push_error("test aborted: %s" % prepare_error)
		get_tree().quit(1)
		return

	_run_all_tests()

	var restore_error := _guard.restore()
	if not restore_error.is_empty():
		push_error("test save guard restore failed: %s" % restore_error)

	if _all_passed:
		print("ALL %d TESTS PASSED" % _test_count)
	else:
		push_error("%d/%d TESTS FAILED" % [_fail_count, _test_count])

	get_tree().quit(0 if _all_passed else 1)


func _run_all_tests() -> void:
	_test_profile_schema(EPISODE_001)
	_test_profile_schema(EPISODE_002)
	_test_ability_bounds()
	_test_default_hp_mental()
	_test_hp_mental_clamping()
	_test_incapacitated_rules()
	_test_panic_rules()
	_test_protection_consumption()
	_test_best_agent_for_ability()
	_test_aspect_modifier()
	_test_contextual_approach_mapping()
	_test_recovery_action_resolution()
	_test_save_round_trip()
	_test_migration_from_old_save()
	_test_game_state_apis()


func _test_profile_schema(episode_path: String) -> void:
	var loader: EpisodeLoader = EpisodeLoaderScript.new()
	var data: Dictionary = loader.load_episode(episode_path)

	var episode_id := String(data.get("episode", {}).get("id", ""))
	_test("profile schema in %s" % episode_id, func() -> bool:
		var agents: Array = data.get("agents", [])
		if agents.is_empty():
			return false

		for agent in agents:
			if typeof(agent) != TYPE_DICTIONARY:
				return false

			var agent_id := String(agent.get("id", ""))
			if agent_id.is_empty():
				return false

			var abilities := _to_dictionary(agent.get("abilities", {}))
			for key in ABILITY_KEYS:
				var val := int(abilities.get(key, 0))
				if val < 1 or val > 5:
					print("  FAIL: %s ability %s = %d, expected 1..5" % [agent_id, key, val])
					return false

			var hp_max := int(agent.get("max_health", 0))
			if hp_max != int(EXPECTED_MAX_HP.get(agent_id, 0)):
				print("  FAIL: %s hp_max = %d, expected %d" % [agent_id, hp_max, int(EXPECTED_MAX_HP.get(agent_id, 0))])
				return false

			var mental_max := int(agent.get("max_mental", 0))
			if mental_max != int(EXPECTED_MAX_MENTAL.get(agent_id, 0)):
				print("  FAIL: %s mental_max = %d, expected %d" % [agent_id, mental_max, int(EXPECTED_MAX_MENTAL.get(agent_id, 0))])
				return false

			var aspects: Array = agent.get("aspects", [])
			if aspects.size() < 2:
				print("  FAIL: %s has %d aspects, expected >= 2" % [agent_id, aspects.size()])
				return false
			if (agent.get("equipment", []) as Array).is_empty() or (agent.get("skills", []) as Array).size() < 2:
				print("  FAIL: %s needs fixed equipment and at least two skills" % agent_id)
				return false

			var backstory := String(agent.get("backstory", ""))
			if backstory.is_empty():
				print("  FAIL: %s has no backstory" % agent_id)
				return false

		return true
	)


func _test_ability_bounds() -> void:
	_test("ability bounds 1..5", func() -> bool:
		for agent in GameState.get_agents():
			var agent_id := String(agent.get("id", ""))
			for index in ABILITY_KEYS.size():
				var key: String = ABILITY_KEYS[index]
				var val := GameState.get_agent_ability(agent_id, key)
				if val < 1 or val > 5:
					print("  FAIL: %s.%s = %d" % [agent_id, key, val])
					return false
				if val != int((EXPECTED_ABILITIES.get(agent_id, []) as Array)[index]):
					print("  FAIL: %s.%s does not match the approved Ver 3.2 table" % [agent_id, key])
					return false
		return true
	)


func _test_default_hp_mental() -> void:
	_test("default HP/mental equals profile max", func() -> bool:
		GameState.reset_run_state()
		GameState.set_selected_agent_ids(["agent_kang_ijun", "agent_kwon_narae", "agent_oh_hyun"])

		for agent_id in EXPECTED_MAX_HP:
			if not GameState.is_agent_selected(agent_id):
				continue
			var hp := GameState.get_agent_current_hp(agent_id)
			var expected := int(EXPECTED_MAX_HP.get(agent_id, 0))
			if hp != expected:
				print("  FAIL: %s default HP = %d, expected %d" % [agent_id, hp, expected])
				return false

			var mental := GameState.get_agent_current_mental(agent_id)
			var expected_m := int(EXPECTED_MAX_MENTAL.get(agent_id, 0))
			if mental != expected_m:
				print("  FAIL: %s default mental = %d, expected %d" % [agent_id, mental, expected_m])
				return false
		return true
	)


func _test_hp_mental_clamping() -> void:
	_test("HP/mental clamping to 0..max", func() -> bool:
		GameState.reset_run_state()
		GameState.set_selected_agent_ids(["agent_kang_ijun"])

		var agent_id := "agent_kang_ijun"
		var max_hp := GameState.get_agent_max_hp(agent_id)

		GameState.change_agent_hp(agent_id, -999)
		var hp := GameState.get_agent_current_hp(agent_id)
		if hp != 0:
			print("  FAIL: clamped HP = %d, expected 0" % hp)
			return false

		GameState.change_agent_hp(agent_id, 99)
		hp = GameState.get_agent_current_hp(agent_id)
		if hp > max_hp:
			print("  FAIL: HP = %d exceeds max %d" % [hp, max_hp])
			return false

		GameState.change_agent_mental(agent_id, -999)
		var mental := GameState.get_agent_current_mental(agent_id)
		if mental != 0:
			print("  FAIL: clamped mental = %d, expected 0" % mental)
			return false

		return true
	)


func _test_incapacitated_rules() -> void:
	_test("incapacitated agents cannot act", func() -> bool:
		GameState.reset_run_state()
		GameState.set_selected_agent_ids(["agent_kang_ijun", "agent_kwon_narae"])

		GameState.change_agent_hp("agent_kang_ijun", -999)
		if GameState.is_agent_active("agent_kang_ijun"):
			print("  FAIL: agent_kang_ijun should be incapacitated at HP 0")
			return false

		if not GameState.is_agent_active("agent_kwon_narae"):
			print("  FAIL: agent_kwon_narae should be active")
			return false

		return true
	)


func _test_panic_rules() -> void:
	_test("panic agents cannot act", func() -> bool:
		GameState.reset_run_state()
		GameState.set_selected_agent_ids(["agent_kang_ijun"])

		GameState.change_agent_mental("agent_kang_ijun", -999)
		if GameState.is_agent_active("agent_kang_ijun"):
			print("  FAIL: agent_kang_ijun should be panicked at mental 0")
			return false

		return true
	)


func _test_protection_consumption() -> void:
	_test("protection absorbs its shield amount", func() -> bool:
		GameState.reset_run_state()
		GameState.set_selected_agent_ids(["agent_kwon_narae"])

		GameState.activate_protection("agent_kwon_narae", 12)
		if not GameState.has_protection("agent_kwon_narae"):
			print("  FAIL: protection not activated")
			return false

		var remaining := GameState.consume_protection("agent_kwon_narae", 10)
		if remaining != 0:
			print("  FAIL: protection should absorb the first 10 damage")
			return false

		if not GameState.has_protection("agent_kwon_narae"):
			print("  FAIL: 2 shield points should remain")
			return false

		remaining = GameState.consume_protection("agent_kwon_narae", 5)
		if remaining != 3 or GameState.has_protection("agent_kwon_narae"):
			print("  FAIL: remaining damage should be 3 after shield is consumed")
			return false

		return true
	)


func _test_best_agent_for_ability() -> void:
	_test("best agent for a given ability", func() -> bool:
		GameState.reset_run_state()
		GameState.set_selected_agent_ids(["agent_kang_ijun", "agent_kwon_narae", "agent_oh_hyun"])

		var best := GameState.find_best_agent_for_ability("suppression")
		if best.is_empty():
			print("  FAIL: no best agent for suppression")
			return false
		# Kang has suppression 4, Oh has 3, Kwon has 1
		var best_id := String(best.get("id", ""))
		if best_id != "agent_kang_ijun":
			print("  FAIL: best suppression agent is %s, expected agent_kang_ijun" % best_id)
			return false

		best = GameState.find_best_agent_for_ability("protection")
		best_id = String(best.get("id", ""))
		if best_id != "agent_kwon_narae":
			print("  FAIL: best protection agent is %s, expected agent_kwon_narae" % best_id)
			return false

		return true
	)


func _test_aspect_modifier() -> void:
	_test("aspect modifier text and value", func() -> bool:
		GameState.reset_run_state()

		var modifier := GameState.get_aspect_modifier("agent_kang_ijun", "suppression", ["anomaly_alert"])
		# Aspects are "현장 돌파" and "직감적 대응" — both should give bonus for suppression
		if modifier.value <= 0:
			print("  FAIL: aspect modifier should be positive for matching tags")
			return false

		modifier = GameState.get_aspect_modifier("agent_kang_ijun", "treatment", [])
		if modifier.value != 0:
			print("  FAIL: aspect modifier should be 0 for unmatched ability without tags")
			return false

		return true
	)


func _test_contextual_approach_mapping() -> void:
	_test("approach_type and tags in investigation points", func() -> bool:
		var loader: EpisodeLoader = EpisodeLoaderScript.new()
		for episode_path in [EPISODE_001, EPISODE_002]:
			var data := loader.load_episode(episode_path)
			var points: Array = data.get("investigation_points", [])

			for point in points:
				if typeof(point) != TYPE_DICTIONARY:
					continue

				var method_options: Array = point.get("method_options", [])
				if method_options.is_empty():
					continue

				for method in method_options:
					if typeof(method) != TYPE_DICTIONARY:
						continue
					var atype := String(method.get("approach_type", ""))
					if atype.is_empty():
						print("  FAIL: method %s has no approach_type" % String(method.get("id", "")))
						return false
					if not ABILITY_KEYS.has(atype):
						print("  FAIL: unknown approach_type %s" % atype)
						return false
		return true
	)


func _test_recovery_action_resolution() -> void:
	_test("recovery action resolution returns correct effect values", func() -> bool:
		GameState.reset_run_state()
		GameState.set_selected_agent_ids(["agent_kang_ijun", "agent_kwon_narae", "agent_oh_hyun"])

		var result := GameState.resolve_recovery_action("suppression", "agent_kang_ijun")
		if result.has("error"):
			print("  FAIL: suppression resolution error: %s" % result.get("error"))
			return false
		# suppression: 4 + 5*2 + equipment 1 + skill 2 = 17
		var expected_effect := 17
		if int(result.get("effect_value", 0)) != expected_effect:
			print("  FAIL: suppression effect = %d, expected %d" % [int(result.get("effect_value", 0)), expected_effect])
			return false

		result = GameState.resolve_recovery_action("protection", "agent_kwon_narae")
		# protection: 5 + 5*3 = 20
		if int(result.get("effect_value", 0)) != 20:
			print("  FAIL: protection effect = %d, expected 20" % int(result.get("effect_value", 0)))
			return false

		result = GameState.resolve_recovery_action("treatment", "agent_oh_hyun")
		# treatment: 6 + 4*4 + skill 2 = 24
		if int(result.get("effect_value", 0)) != 24:
			print("  FAIL: treatment effect = %d, expected 24" % int(result.get("effect_value", 0)))
			return false

		return true
	)


func _test_save_round_trip() -> void:
	_test("save round trip preserves agent case states", func() -> bool:
		GameState.reset_run_state()
		GameState.set_selected_agent_ids(["agent_kang_ijun", "agent_kwon_narae"])

		GameState.change_agent_hp("agent_kang_ijun", -30)
		GameState.change_agent_mental("agent_kwon_narae", -20)
		GameState.activate_protection("agent_kwon_narae")

		if not GameState.save_game():
			print("  FAIL: save_game returned false")
			return false

		GameState.change_agent_hp("agent_kang_ijun", -50)
		if not GameState.load_game():
			print("  FAIL: load_game returned false")
			return false

		var hp := GameState.get_agent_current_hp("agent_kang_ijun")
		if hp != int(EXPECTED_MAX_HP.get("agent_kang_ijun", 120)) - 30:
			print("  FAIL: loaded HP = %d, expected %d" % [hp, int(EXPECTED_MAX_HP.get("agent_kang_ijun", 120)) - 30])
			return false

		var mental := GameState.get_agent_current_mental("agent_kwon_narae")
		if mental != int(EXPECTED_MAX_MENTAL.get("agent_kwon_narae", 120)) - 20:
			print("  FAIL: loaded mental = %d, expected %d" % [mental, int(EXPECTED_MAX_MENTAL.get("agent_kwon_narae", 120)) - 20])
			return false

		if not GameState.has_protection("agent_kwon_narae"):
			print("  FAIL: protection state not preserved after load")
			return false

		return true
	)


func _test_migration_from_old_save() -> void:
	_test("old save without agent fields migrates safely", func() -> bool:
		GameState.clear_save_file()
		GameState.reset_run_state()
		GameState.set_selected_agent_ids(["agent_kang_ijun"])

		var old_data := {
			"save_version": "mvp-018",
			"episode_id": "episode_001_afterlife_station",
			"episode_path": EPISODE_001,
			"current_scene_path": "res://scenes/dialogue_scene.tscn",
			"selected_agent_ids": ["agent_kang_ijun", "agent_kwon_narae"],
			"flags": [],
			"collected_clue_ids": []
		}

		var file := FileAccess.open(GameState.SAVE_FILE_PATH, FileAccess.WRITE)
		if file == null:
			print("  FAIL: could not write old-format save")
			return false
		file.store_string(JSON.stringify(old_data, "\t"))
		file.close()

		if not GameState.load_game():
			print("  FAIL: load_game returned false for old save")
			return false

		# Old saves should default HP/mental to profile maxima
		for agent_id in ["agent_kang_ijun", "agent_kwon_narae"]:
			var hp := GameState.get_agent_current_hp(agent_id)
			var expected_hp := int(EXPECTED_MAX_HP.get(agent_id, 0))
			if hp != expected_hp:
				print("  FAIL: migrated HP for %s = %d, expected %d" % [agent_id, hp, expected_hp])
				return false

		return true
	)


func _test_game_state_apis() -> void:
	_test("GameState exposes required Ver 3.2 APIs", func() -> bool:
		var apis := [
			"get_agent_ability",
			"get_agent_max_hp",
			"get_agent_max_mental",
			"get_agent_current_hp",
			"get_agent_current_mental",
			"change_agent_hp",
			"change_agent_mental",
			"is_agent_active",
			"activate_protection",
			"has_protection",
			"consume_protection",
			"find_best_agent_for_ability",
			"get_aspect_modifier",
			"resolve_recovery_action",
			"clear_agent_case_states",
			"get_agent_case_state",
		]
		for api_name in apis:
			if not GameState.has_method(api_name):
				print("  FAIL: GameState missing method %s" % api_name)
				return false
		return true
	)


func _test(name: String, check: Callable) -> void:
	_test_count += 1
	var held_passed := _all_passed
	if held_passed:
		var result: Variant = check.call()
		var passed := false
		if typeof(result) == TYPE_BOOL:
			passed = result
		elif typeof(result) == TYPE_STRING and not result.is_empty():
			passed = false
		else:
			passed = not (result is String and not (result as String).is_empty())

		if not passed:
			print("  FAIL: %s" % name)
			_fail_count += 1
			_all_passed = false
	else:
		print("  SKIP (dependency): %s" % name)


func _to_dictionary(value: Variant) -> Dictionary:
	if typeof(value) == TYPE_DICTIONARY:
		return value
	return {}
