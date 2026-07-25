extends SceneTree

const AnnualData = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_data.gd")
const CaseData = preload("res://scripts/poc/core_mvp_001/core_mvp_001_case_data.gd")
const Adapter = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_incident_adapter.gd")

class FakeCoreState:
	extends RefCounted
	var calls: Array[Dictionary] = []
	func apply_external_support(source_id: String, event_key: String, effect: Dictionary) -> Dictionary:
		calls.append({"source_id": source_id, "event_key": event_key, "effect": effect.duplicate(true)})
		return {"ok": true, "state_changed": true, "events": [], "snapshot": {}}

func _init() -> void:
	var config: Dictionary = AnnualData.load_config("res://data/poc/annual_mvp_001/spring_vertical_slice.json")
	var base_case: Dictionary = CaseData.load_case("res://data/poc/core_mvp_001/afterlife_station_poc.json")
	var annual_snapshot := {
		"competencies": {
			"observation": 2,
			"analysis": 2,
			"field_response": 2,
			"interpersonal": 2
		},
		"fatigue": 70,
		"deployment_risk": 15,
		"companion_trust": {"annual001_companion_oh_hyun": 2},
		"selected_companion_id": "annual001_companion_oh_hyun",
		"selected_public_skill_id": "annual001_skill_emergency_cover",
		"equipped_module_ids": ["annual001_module_signal_buffer"]
	}
	var adapter := Adapter.new()
	assert(adapter.configure(config, annual_snapshot, 2001)["ok"])
	var override: Dictionary = adapter.build_case_override(base_case)
	assert(override["case"]["starting_health"] == 85)
	assert(override["case"]["starting_risk"] == 15)
	assert(override["understanding"]["omen_read_rates"]["clue"] == 45)
	assert(override["understanding"]["omen_read_rates"]["likely"] <= 90)
	assert(override["annual_analysis_notes"].has("전광판 변동 기록과 방송 원본의 불일치 항목을 분리해 비교할 수 있다."))
	for field_test in override["field_tests"]:
		assert(int(field_test.get("damage", 0)) >= 0)
	for pattern in override["recovery_patterns"]:
		if bool(pattern.get("first_use_hidden", false)):
			assert(pattern["max_first_observation_damage"] == 12)

	var fake := FakeCoreState.new()
	var before := {
		"turn": 1,
		"current_pattern_id": "poc001_pattern_false_terminal",
		"observed_pattern_ids": []
	}
	var omen_results: Array[Dictionary] = adapter.after_omen(fake, before, {"success": false})
	assert(omen_results.size() >= 1)
	assert(omen_results[0]["triggered"])
	assert(fake.calls.size() == 1)
	assert(fake.calls[0]["event_key"] == "omen:1:poc001_pattern_false_terminal")
	var cached: Array[Dictionary] = adapter.after_omen(fake, before, {"success": false})
	assert(cached == omen_results)
	assert(fake.calls.size() == 1)

	var lines: Array[String] = adapter.get_status_lines()
	assert(lines.size() == 2)
	assert(lines[0].contains("조건:"))
	assert(lines[0].contains("확률"))
	assert(lines[0].contains("준비도"))
	assert(lines[0].contains("남은"))
	assert(adapter.get_support_log().size() == 1)

	var normal := adapter.build_annual_reward(
		{"recovery_quality": "normal_capture"},
		{"status": "verified", "danger_cases": []}
	)
	assert(normal["residual_data_gain"] == 2)
	assert(normal["institution_support_delta"] == 1)
	var emergency := adapter.build_annual_reward(
		{"recovery_quality": "emergency_capture"},
		{"status": "candidate", "danger_cases": [{"id": "danger"}]}
	)
	assert(emergency["residual_data_gain"] == 1)
	assert(emergency["institution_support_delta"] == -1)
	assert(emergency["danger_case_count"] == 1)
	print("ANNUAL MVP 001 ADAPTER: PASS")
	quit()
