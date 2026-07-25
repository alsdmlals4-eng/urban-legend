extends SceneTree

const Data = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_data.gd")
const Resolver = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_support_resolver.gd")

func _init() -> void:
	_test_event_cache()
	_test_readiness_guarantee()
	_test_signature_guarantee()
	_test_trigger_conditions_and_limits()
	_test_seed_reproducibility()
	print("ANNUAL MVP 001 SUPPORT: PASS")
	quit()


func _test_event_cache() -> void:
	var config: Dictionary = Data.load_config("res://data/poc/annual_mvp_001/spring_vertical_slice.json")
	var resolver := Resolver.new()
	assert(resolver.start([config["support_skills"][0]], 0, 1, 2001, [100])["ok"])
	var context := {"event": "omen_read", "success": false}
	var first: Array[Dictionary] = resolver.resolve("omen:1:poc001_pattern_false_terminal", context)
	var second: Array[Dictionary] = resolver.resolve("omen:1:poc001_pattern_false_terminal", context)
	assert(first == second)
	assert(first.size() == 1)
	assert(first[0]["eligible"])
	assert(not first[0]["triggered"])


func _test_readiness_guarantee() -> void:
	var fixture: Array[Dictionary] = [{
		"id": "annual001_skill_test_readiness",
		"name": "준비도 시험",
		"type": "public",
		"trigger": "omen_failed",
		"base_chance": 0,
		"readiness_gain": 50,
		"readiness_max": 100,
		"battle_limit": 3,
		"effect": {"risk_reduction": 1}
	}]
	var resolver := Resolver.new()
	assert(resolver.start(fixture, 0, 1, 2001, [100, 100, 100])["ok"])
	var context := {"event": "omen_read", "success": false}
	var first: Dictionary = resolver.resolve("omen:1:a", context)[0]
	var second: Dictionary = resolver.resolve("omen:2:a", context)[0]
	var third: Dictionary = resolver.resolve("omen:3:a", context)[0]
	assert(not first["triggered"])
	assert(first["readiness_after"] == 50)
	assert(not second["triggered"])
	assert(second["readiness_after"] == 100)
	assert(third["triggered"])
	assert(third["guaranteed"])
	assert(third["readiness_before"] == 100)
	assert(third["readiness_after"] == 0)


func _test_signature_guarantee() -> void:
	var fixture: Array[Dictionary] = [{
		"id": "annual001_skill_test_signature",
		"name": "대표 스킬 시험",
		"type": "unique",
		"trigger": "omen_failed",
		"base_chance": 0,
		"readiness_gain": 20,
		"readiness_max": 100,
		"battle_limit": 2,
		"effect": {"risk_reduction": 1}
	}]
	var resolver := Resolver.new()
	assert(resolver.start(fixture, 2, 1, 2001, [100])["ok"])
	var result: Dictionary = resolver.resolve(
		"omen:1:signature",
		{"event": "omen_read", "success": false}
	)[0]
	assert(result["triggered"])
	assert(result["guaranteed"])
	assert(resolver.get_snapshot()["signature_guarantee_used"])


func _test_trigger_conditions_and_limits() -> void:
	var fixture: Array[Dictionary] = [
		{
			"id": "annual001_skill_test_damage",
			"name": "피해 시험",
			"type": "public",
			"trigger": "damage_at_least_12",
			"base_chance": 100,
			"readiness_gain": 20,
			"readiness_max": 100,
			"battle_limit": 1,
			"effect": {"health_restore": 2}
		},
		{
			"id": "annual001_skill_test_hidden",
			"name": "미관측 시험",
			"type": "public",
			"trigger": "first_hidden_pattern_resolved",
			"base_chance": 100,
			"readiness_gain": 20,
			"readiness_max": 100,
			"battle_limit": 1,
			"effect": {"risk_reduction": 2}
		}
	]
	var resolver := Resolver.new()
	assert(resolver.start(fixture, 0, 2, 2001, [1, 1])["ok"])
	assert(resolver.resolve("action:1:a", {"event": "recovery_action_resolved", "damage": 11, "first_hidden": false}).is_empty())
	var damage_results: Array[Dictionary] = resolver.resolve("action:2:a", {"event": "recovery_action_resolved", "damage": 12, "first_hidden": false})
	assert(damage_results.size() == 1)
	assert(damage_results[0]["skill_id"] == "annual001_skill_test_damage")
	assert(damage_results[0]["triggered"])
	var hidden_results: Array[Dictionary] = resolver.resolve("action:3:a", {"event": "recovery_action_resolved", "damage": 0, "first_hidden": true})
	assert(hidden_results.size() == 1)
	assert(hidden_results[0]["skill_id"] == "annual001_skill_test_hidden")
	assert(hidden_results[0]["triggered"])
	assert(resolver.resolve("action:4:a", {"event": "recovery_action_resolved", "damage": 15, "first_hidden": false}).is_empty())


func _test_seed_reproducibility() -> void:
	var config: Dictionary = Data.load_config("res://data/poc/annual_mvp_001/spring_vertical_slice.json")
	var skills: Array[Dictionary] = [config["support_skills"][0], config["support_skills"][1]]
	var first := Resolver.new()
	var second := Resolver.new()
	assert(first.start(skills, 1, 2, 4444)["ok"])
	assert(second.start(skills, 1, 2, 4444)["ok"])
	var events: Array[Dictionary] = [
		{"key": "omen:1:a", "context": {"event": "omen_read", "success": false}},
		{"key": "action:1:a", "context": {"event": "recovery_action_resolved", "damage": 14, "first_hidden": false}},
		{"key": "omen:2:b", "context": {"event": "omen_read", "success": false}},
	]
	for event in events:
		assert(first.resolve(event["key"], event["context"]) == second.resolve(event["key"], event["context"]))
	assert(first.get_snapshot() == second.get_snapshot())
