extends SceneTree

const BaseData = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_data.gd")
const CaseData = preload("res://scripts/poc/core_mvp_001/core_mvp_001_case_data.gd")
const Adapter = preload("res://scripts/poc/annual_mvp_002/annual_mvp_002_incident_adapter.gd")

var _failures: Array[String] = []


class FakeCoreState:
	extends RefCounted
	var calls: Array[Dictionary] = []
	func apply_external_support(source_id: String, event_key: String, effect: Dictionary) -> Dictionary:
		calls.append({
			"source_id": source_id,
			"event_key": event_key,
			"effect": effect.duplicate(true),
		})
		return {"ok": true, "state_changed": true, "events": [], "snapshot": {}}


func _init() -> void:
	_test_expansion_configures_and_exposes_status()
	_test_support_hooks_apply_once_and_scale_overlap()
	_test_case_override_only_contains_allowed_modifiers()
	_test_research_reward_mapping()
	_test_missing_extension_uses_safe_fallback()
	_finish()


func _base_snapshot() -> Dictionary:
	return {
		"competencies": {
			"observation": 2,
			"analysis": 2,
			"field_response": 2,
			"interpersonal": 2,
		},
		"fatigue": 55,
		"deployment_risk": 15,
		"companion_trust": {"annual001_companion_oh_hyun": 2},
		"annual_mvp_002": {
			"enabled": true,
			"selected_companion_ids": [
				"annual002_companion_ohyun",
				"annual002_companion_park_doyun",
			],
			"companion_states": {
				"annual002_companion_ohyun": {"work_trust": 40},
				"annual002_companion_park_doyun": {"work_trust": 10},
			},
			"equipped_support_skills": {
				"annual002_companion_ohyun": "annual002_support_damage_buffer",
				"annual002_companion_park_doyun": "annual002_support_containment_window",
			},
			"readiness_by_skill": {
				"annual002_support_damage_buffer": 100,
				"annual002_support_containment_window": 100,
			},
			"selected_equipment_id": "annual002_equipment_field_coat",
			"installed_module_ids": ["annual002_module_impact_gel"],
			"completed_research_ids": ["annual002_research_failure_learning"],
			"role_overlap_efficiency": 70,
		}
	}


func _new_adapter(snapshot: Dictionary = {}) -> RefCounted:
	var config: Dictionary = BaseData.load_config("res://data/poc/annual_mvp_001/spring_vertical_slice.json")
	var adapter: RefCounted = Adapter.new()
	var actual_snapshot := _base_snapshot() if snapshot.is_empty() else snapshot
	var result: Dictionary = adapter.configure(config, actual_snapshot, 4101)
	_expect(result.get("ok", false), "adapter should configure")
	return adapter


func _test_expansion_configures_and_exposes_status() -> void:
	var adapter: RefCounted = _new_adapter()
	_expect(not adapter.is_fallback_active(), "valid extension must not use fallback")
	var lines: Array[String] = adapter.get_status_lines()
	_expect(lines.size() == 4, "two companions should expose two unique and two public skills")
	for line in lines:
		_expect(line.contains("적격") or line.contains("비적격"), "status must show eligibility")
		_expect(line.contains("확률"), "status must show probability")
		_expect(line.contains("준비도"), "status must show readiness")
		_expect(line.contains("보장"), "status must show guarantee distance")
	_expect(adapter.get_fairness_notice().contains("정답 가설"), "fairness notice must state answer boundary")


func _test_support_hooks_apply_once_and_scale_overlap() -> void:
	var adapter: RefCounted = _new_adapter()
	var fake := FakeCoreState.new()
	var before := {
		"turn": 2,
		"current_pattern_id": "poc001_pattern_false_terminal",
		"observed_pattern_ids": ["poc001_pattern_false_terminal"],
	}
	var damage_results: Array[Dictionary] = adapter.after_recovery_action(fake, before, "probe", {
		"damage": 8,
		"snapshot": before,
	})
	var triggered_damage := damage_results.filter(func(value: Dictionary) -> bool: return bool(value.get("triggered", false)))
	_expect(triggered_damage.size() >= 2, "O Hyun unique and guaranteed damage support should trigger")
	var calls_after_first := fake.calls.size()
	adapter.after_recovery_action(fake, before, "probe", {"damage": 8, "snapshot": before})
	_expect(fake.calls.size() == calls_after_first, "same event must not apply support twice")

	var capture_results: Array[Dictionary] = adapter.after_capture_window(fake, {
		"turn": 3,
		"current_pattern_id": "poc001_pattern_false_terminal",
	}, {"capture_window_open": true})
	var found_scaled := false
	for decision in capture_results:
		if String(decision.get("owner_companion_id", "")) == "annual002_companion_park_doyun" and bool(decision.get("triggered", false)):
			found_scaled = int((decision.get("effect", {}) as Dictionary).get("capture_window_percent", 0)) == 7
	_expect(found_scaled, "second overlapping field role effect should scale to 70 percent")


func _test_case_override_only_contains_allowed_modifiers() -> void:
	var adapter: RefCounted = _new_adapter()
	var base_case: Dictionary = CaseData.load_case("res://data/poc/core_mvp_001/afterlife_station_poc.json")
	var override: Dictionary = adapter.build_case_override(base_case)
	_expect((override.get("case", {}) as Dictionary).get("starting_risk", 0) == 15, "deployment risk should carry")
	for field_value in override.get("field_tests", []) as Array:
		_expect(int((field_value as Dictionary).get("damage", 0)) >= 0, "equipment cannot make damage negative")
	_expect(not _contains_forbidden_key(override), "case override cannot contain answer fields")
	var modifiers := override.get("annual_mvp_002_modifiers", {}) as Dictionary
	_expect(modifiers.has("selected_equipment_id"), "override should disclose applied equipment")
	_expect(not modifiers.has("clue_id"), "modifier summary cannot add a clue")


func _test_research_reward_mapping() -> void:
	var adapter: RefCounted = _new_adapter()
	var normal: Dictionary = adapter.build_research_reward(
		{"recovery_quality": "normal_capture"},
		{"status": "verified", "danger_cases": []}
	)
	var normal_resources := normal["resource_delta"] as Dictionary
	_expect(normal_resources["annual002_resource_records"] == 2, "verified normal capture should grant two records")
	_expect(normal_resources["annual002_resource_residue"] == 2, "normal capture should grant two residue")
	_expect(normal_resources["annual002_resource_institution"] == 2, "verified normal capture should grant two institution points")
	var costly: Dictionary = adapter.build_research_reward(
		{"recovery_quality": "costly_capture"},
		{"status": "candidate", "danger_cases": [{"id": "danger"}]}
	)
	var costly_resources := costly["resource_delta"] as Dictionary
	_expect(costly_resources["annual002_resource_risk_cases"] == 1, "costly capture should create a risk case")


func _test_missing_extension_uses_safe_fallback() -> void:
	var snapshot := _base_snapshot()
	snapshot.erase("annual_mvp_002")
	var adapter: RefCounted = _new_adapter(snapshot)
	_expect(adapter.is_fallback_active(), "missing extension should use fallback")
	_expect(adapter.get_fallback_warning().contains("기본"), "fallback warning should be visible")
	var base_case: Dictionary = CaseData.load_case("res://data/poc/core_mvp_001/afterlife_station_poc.json")
	var override: Dictionary = adapter.build_case_override(base_case)
	_expect(not override.has("annual_mvp_002_modifiers"), "fallback must not add expansion modifiers")


func _contains_forbidden_key(value: Variant) -> bool:
	var forbidden := ["clue_id", "hypothesis_id", "pattern_id", "capture_condition", "answer_hypothesis", "unobserved_pattern"]
	if typeof(value) == TYPE_DICTIONARY:
		for key_value in (value as Dictionary).keys():
			if forbidden.has(String(key_value)):
				return true
			if _contains_forbidden_key((value as Dictionary)[key_value]):
				return true
	elif typeof(value) == TYPE_ARRAY:
		for item in value as Array:
			if _contains_forbidden_key(item):
				return true
	return false


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("ANNUAL MVP 002 ADAPTER: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
