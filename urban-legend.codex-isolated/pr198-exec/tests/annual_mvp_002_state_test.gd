extends SceneTree

const BaseData = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_data.gd")
const State = preload("res://scripts/poc/annual_mvp_002/annual_mvp_002_state.gd")

var _base_config: Dictionary = {}


func _init() -> void:
	_base_config = BaseData.load_config("res://data/poc/annual_mvp_001/spring_vertical_slice.json")
	_test_start_defaults()
	_test_companion_limit_and_role_overlap()
	_test_support_and_equipment_validation()
	_test_research_reservation_cancel_and_limit()
	_test_save_round_trip_and_old_save_fallback()
	_test_orphaned_ids_are_preserved_but_inert()
	print("ANNUAL MVP 002 STATE: PASS")
	quit()


func _strings(values: Array) -> Array[String]:
	var result: Array[String] = []
	for value in values:
		result.append(String(value))
	return result


func _new_state(seed: int = 2201) -> RefCounted:
	var state: RefCounted = State.new()
	var started: Dictionary = state.start(_base_config.duplicate(true), seed)
	assert(started.get("ok", false))
	return state


func _extension(state: RefCounted) -> Dictionary:
	return (state.get_snapshot().get("annual_mvp_002", {}) as Dictionary)


func _test_start_defaults() -> void:
	var state: RefCounted = _new_state()
	var extension: Dictionary = _extension(state)
	assert(extension.get("enabled", false))
	assert((extension["companion_states"] as Dictionary).size() == 3)
	assert((extension["research_resources"] as Dictionary).size() == 4)
	for value in (extension["research_resources"] as Dictionary).values():
		assert(int(value) == 0)
	assert((extension["schedule_templates"] as Array).size() == 3)
	assert((extension["selected_companion_ids"] as Array).is_empty())


func _test_companion_limit_and_role_overlap() -> void:
	var state: RefCounted = _new_state()
	assert(state.configure_loadout_v2(_strings([]), {}, "", _strings([]))["ok"])
	assert(state.configure_loadout_v2(
		_strings(["annual002_companion_ohyun"]),
		{"annual002_companion_ohyun": "annual002_support_damage_buffer"},
		"",
		_strings([])
	)["ok"])
	assert(state.configure_loadout_v2(
		_strings(["annual002_companion_ohyun", "annual002_companion_park_doyun"]),
		{"annual002_companion_ohyun": "annual002_support_damage_buffer"},
		"",
		_strings([])
	)["ok"])
	var extension: Dictionary = _extension(state)
	assert(extension["role_overlap_efficiency"] == 70)
	var before: Dictionary = state.get_snapshot()
	var rejected: Dictionary = state.configure_loadout_v2(
		_strings([
			"annual002_companion_ohyun",
			"annual002_companion_han_serin",
			"annual002_companion_park_doyun",
		]),
		{},
		"",
		_strings([])
	)
	assert(not rejected["ok"])
	assert(state.get_snapshot() == before)


func _test_support_and_equipment_validation() -> void:
	var state: RefCounted = _new_state()
	var wrong_owner: Dictionary = state.configure_loadout_v2(
		_strings(["annual002_companion_ohyun"]),
		{"annual002_companion_ohyun": "annual002_support_second_read"},
		"",
		_strings([])
	)
	assert(not wrong_owner["ok"])
	var disabled_skill: Dictionary = state.configure_loadout_v2(
		_strings(["annual002_companion_han_serin"]),
		{"annual002_companion_han_serin": "annual002_support_second_read"},
		"",
		_strings([])
	)
	assert(not disabled_skill["ok"])
	assert(String(disabled_skill.get("error", "")).contains("후속 CORE hook"))
	assert(state.configure_loadout_v2(
		_strings(["annual002_companion_ohyun"]),
		{"annual002_companion_ohyun": "annual002_support_risk_dampening"},
		"annual002_equipment_echo_recorder",
		_strings(["annual002_module_noise_filter"])
	)["ok"])
	var mismatch: Dictionary = state.configure_loadout_v2(
		_strings(["annual002_companion_ohyun"]),
		{"annual002_companion_ohyun": "annual002_support_risk_dampening"},
		"annual002_equipment_echo_recorder",
		_strings(["annual002_module_impact_gel"])
	)
	assert(not mismatch["ok"])
	var duplicate: Dictionary = state.configure_loadout_v2(
		_strings(["annual002_companion_ohyun"]),
		{"annual002_companion_ohyun": "annual002_support_risk_dampening"},
		"annual002_equipment_echo_recorder",
		_strings(["annual002_module_noise_filter", "annual002_module_noise_filter"])
	)
	assert(not duplicate["ok"])


func _test_research_reservation_cancel_and_limit() -> void:
	var state: RefCounted = _new_state()
	assert(state.apply_research_resource_reward({
		"annual002_resource_records": 10,
		"annual002_resource_residue": 10,
		"annual002_resource_risk_cases": 10,
		"annual002_resource_institution": 10,
	})["ok"])
	assert(state.start_research("annual002_research_field_records")["ok"])
	assert(state.start_research("annual002_research_damage_protocol")["ok"])
	var before_third: Dictionary = state.get_snapshot()
	assert(not state.start_research("annual002_research_readiness_training")["ok"])
	assert(state.get_snapshot() == before_third)
	assert(state.advance_research("annual002_research_field_records", 2)["ok"])
	var extension: Dictionary = _extension(state)
	assert((extension["completed_research_ids"] as Array).has("annual002_research_field_records"))
	assert(state.cancel_research("annual002_research_damage_protocol")["ok"])
	extension = _extension(state)
	assert((extension["active_research"] as Dictionary).is_empty())
	assert((extension["research_resources"] as Dictionary)["annual002_resource_risk_cases"] == 9)


func _test_save_round_trip_and_old_save_fallback() -> void:
	var state: RefCounted = _new_state(2202)
	assert(state.configure_loadout_v2(
		_strings(["annual002_companion_ohyun"]),
		{"annual002_companion_ohyun": "annual002_support_damage_buffer"},
		"annual002_equipment_field_coat",
		_strings(["annual002_module_impact_gel"])
	)["ok"])
	assert(state.save_schedule_template(1, _strings([
		"annual001_activity_observation_drill",
		"annual001_activity_rest",
	]))["ok"])
	assert(state.set_support_readiness("annual002_support_damage_buffer", 60)["ok"])
	var payload: Dictionary = state.build_save_payload()
	assert(payload["save_version"] == "annual-mvp-001-save-v1")
	assert((payload["state"] as Dictionary).has("annual_mvp_002"))
	var restored: RefCounted = _new_state(9999)
	assert(restored.restore(_base_config.duplicate(true), payload)["ok"])
	assert(_extension(restored) == _extension(state))

	var old_payload: Dictionary = payload.duplicate(true)
	(old_payload["state"] as Dictionary).erase("annual_mvp_002")
	var old_restored: RefCounted = _new_state(2203)
	assert(old_restored.restore(_base_config.duplicate(true), old_payload)["ok"])
	var old_extension: Dictionary = _extension(old_restored)
	assert(old_extension["enabled"])
	assert((old_extension["selected_companion_ids"] as Array).is_empty())
	assert((old_extension["schedule_templates"] as Array).size() == 3)


func _test_orphaned_ids_are_preserved_but_inert() -> void:
	var state: RefCounted = _new_state(2204)
	var payload: Dictionary = state.build_save_payload()
	var extension: Dictionary = (payload["state"] as Dictionary)["annual_mvp_002"] as Dictionary
	extension["selected_companion_ids"] = ["annual002_companion_removed"]
	extension["owned_equipment_ids"] = ["annual002_equipment_removed"]
	extension["orphaned_ids"] = ["annual002_old_flag"]
	var restored: RefCounted = _new_state(2205)
	assert(restored.restore(_base_config.duplicate(true), payload)["ok"])
	var restored_extension: Dictionary = _extension(restored)
	assert((restored_extension["selected_companion_ids"] as Array).is_empty())
	assert((restored_extension["orphaned_ids"] as Array).has("annual002_companion_removed"))
	assert((restored_extension["orphaned_ids"] as Array).has("annual002_equipment_removed"))
	assert((restored_extension["orphaned_ids"] as Array).has("annual002_old_flag"))
	var next_payload: Dictionary = restored.build_save_payload()
	var next_extension: Dictionary = (next_payload["state"] as Dictionary)["annual_mvp_002"] as Dictionary
	assert((next_extension["orphaned_ids"] as Array).has("annual002_companion_removed"))
