extends SceneTree

const Data = preload("res://scripts/poc/annual_mvp_002/annual_mvp_002_data.gd")
const Resolver = preload("res://scripts/poc/annual_mvp_002/annual_mvp_002_support_resolver.gd")

var _config: Dictionary = {}


func _init() -> void:
	_config = Data.load_config("res://data/poc/annual_mvp_002/companion_equipment_research.json")
	_test_unique_skill_is_deterministic_and_once_per_incident()
	_test_public_chance_excludes_readiness()
	_test_failure_builds_readiness_and_research_bonus()
	_test_readiness_guarantees_next_eligible_trigger()
	_test_seed_reproducibility_and_event_idempotency()
	_test_preview_exposes_fairness_fields()
	print("ANNUAL MVP 002 SUPPORT RESOLVER: PASS")
	quit()


func _skill(skill_id: String, owner_id: String, kind: String) -> Dictionary:
	var group := "unique_skills" if kind == "unique" else "support_skills"
	for value in _config[group] as Array:
		var entry := value as Dictionary
		if String(entry.get("id", "")) == skill_id:
			var copy := entry.duplicate(true)
			copy["owner_companion_id"] = owner_id
			copy["skill_kind"] = kind
			return copy
	return {}


func _entries(values: Array) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for value in values:
		result.append((value as Dictionary).duplicate(true))
	return result


func _new_resolver(
	skills: Array[Dictionary],
	companion_states: Dictionary,
	preparation_tags: Array[String] = [],
	readiness: Dictionary = {},
	seed: int = 3001,
	test_rolls: Array[int] = []
) -> RefCounted:
	var resolver: RefCounted = Resolver.new()
	var started: Dictionary = resolver.start(skills, companion_states, preparation_tags, readiness, seed, test_rolls)
	assert(started.get("ok", false))
	return resolver


func _test_unique_skill_is_deterministic_and_once_per_incident() -> void:
	var skill := _skill("annual002_unique_ohyun_field_anchor", "annual002_companion_ohyun", "unique")
	var resolver := _new_resolver(_entries([skill]), {
		"annual002_companion_ohyun": {"work_trust": 20},
	})
	var first: Array = resolver.resolve("damage-1", {"first_damage_before": true})
	assert(first.size() == 1)
	assert((first[0] as Dictionary)["triggered"])
	assert((first[0] as Dictionary)["chance"] == 100)
	var second: Array = resolver.resolve("damage-2", {"first_damage_before": true})
	assert(second.size() == 1)
	assert(not (second[0] as Dictionary)["triggered"])
	assert(String((second[0] as Dictionary)["ineligible_reason"]).contains("1회"))


func _test_public_chance_excludes_readiness() -> void:
	var skill := _skill("annual002_support_damage_buffer", "annual002_companion_ohyun", "support")
	var resolver := _new_resolver(
		_entries([skill]),
		{"annual002_companion_ohyun": {"work_trust": 40}},
		["annual001_activity_field_training"],
		{"annual002_support_damage_buffer": 80},
		3002,
		[99]
	)
	var preview: Dictionary = (resolver.preview({"damage": 8}) as Array)[0] as Dictionary
	assert(preview["eligible"])
	assert(preview["chance"] == 50)
	assert(preview["readiness"] == 80)
	assert(preview["guaranteed_next"] == false)
	var result: Dictionary = (resolver.resolve("damage-1", {"damage": 8}) as Array)[0] as Dictionary
	assert(not result["triggered"])
	assert(result["readiness_after"] == 100)


func _test_failure_builds_readiness_and_research_bonus() -> void:
	var skill := _skill("annual002_support_second_read", "annual002_companion_han_serin", "support")
	var ordinary := _new_resolver(
		_entries([skill]),
		{"annual002_companion_han_serin": {"work_trust": 0}},
		[], {}, 3003, [100]
	)
	var ordinary_result: Dictionary = (ordinary.resolve("record-1", {"after_clue_recorded": true}) as Array)[0] as Dictionary
	assert(not ordinary_result["triggered"])
	assert(ordinary_result["readiness_after"] == 20)

	var learned := _new_resolver(
		_entries([skill]),
		{"annual002_companion_han_serin": {"work_trust": 0}},
		["annual002_research_failure_learning"], {}, 3004, [100]
	)
	var learned_result: Dictionary = (learned.resolve("record-2", {"after_clue_recorded": true}) as Array)[0] as Dictionary
	assert(not learned_result["triggered"])
	assert(learned_result["readiness_after"] == 25)


func _test_readiness_guarantees_next_eligible_trigger() -> void:
	var skill := _skill("annual002_support_containment_window", "annual002_companion_park_doyun", "support")
	var resolver := _new_resolver(
		_entries([skill]),
		{"annual002_companion_park_doyun": {"work_trust": 0}},
		[], {"annual002_support_containment_window": 100}, 3005, [100]
	)
	var preview: Dictionary = (resolver.preview({"capture_window_open": true}) as Array)[0] as Dictionary
	assert(preview["guaranteed_next"])
	var result: Dictionary = (resolver.resolve("capture-1", {"capture_window_open": true}) as Array)[0] as Dictionary
	assert(result["triggered"])
	assert(result["guaranteed"])
	assert(result["readiness_after"] == 0)


func _test_seed_reproducibility_and_event_idempotency() -> void:
	var skill := _skill("annual002_support_risk_dampening", "annual002_companion_ohyun", "support")
	var states := {"annual002_companion_ohyun": {"work_trust": 70}}
	var first := _new_resolver(_entries([skill]), states, [], {}, 3010)
	var second := _new_resolver(_entries([skill]), states, [], {}, 3010)
	var first_result: Array = first.resolve("risk-event", {"risk_increase_before": true})
	var second_result: Array = second.resolve("risk-event", {"risk_increase_before": true})
	assert(first_result == second_result)
	var before: Dictionary = first.get_snapshot()
	var repeated: Array = first.resolve("risk-event", {"risk_increase_before": true})
	assert(repeated == first_result)
	assert(first.get_snapshot() == before)


func _test_preview_exposes_fairness_fields() -> void:
	var skill := _skill("annual002_support_signal_recheck", "annual002_companion_ohyun", "support")
	var resolver := _new_resolver(_entries([skill]), {
		"annual002_companion_ohyun": {"work_trust": 15},
	})
	var item: Dictionary = (resolver.preview({"observed_pattern_reappears": false}) as Array)[0] as Dictionary
	for key in (
		["skill_id", "owner_companion_id", "eligible", "ineligible_reason", "chance", "readiness", "guaranteed_next", "guarantee_distance", "effect_category", "forbidden_outputs"]
	):
		assert(item.has(key))
	assert(not item["eligible"])
	assert((item["forbidden_outputs"] as Array).has("answer_hypothesis"))
	assert((item["forbidden_outputs"] as Array).has("unobserved_pattern"))
