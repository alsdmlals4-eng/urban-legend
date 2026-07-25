extends SceneTree

const AnnualData = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_data.gd")
const CaseData = preload("res://scripts/poc/core_mvp_001/core_mvp_001_case_data.gd")
const Adapter = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_incident_adapter.gd")

var _failures: Array[String] = []

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
	_expect(adapter.configure(config, annual_snapshot, 2001)["ok"], "adapter should configure")
	var override: Dictionary = adapter.build_case_override(base_case)
	_expect(override["case"]["starting_health"] == 85, "fatigue 70 should start at 85 health")
	_expect(override["case"]["starting_risk"] == 15, "deployment risk should carry into incident")
	_expect(override["understanding"]["omen_read_rates"]["clue"] == 45, "observation should raise clue omen rate")
	_expect(override["understanding"]["omen_read_rates"]["likely"] <= 90, "likely omen rate should be capped")
	_expect(override["annual_analysis_notes"].has("전광판 변동 기록과 방송 원본의 불일치 항목을 분리해 비교할 수 있다."), "analysis should add neutral comparison note")
	for field_test in override["field_tests"]:
		_expect(int(field_test.get("damage", 0)) >= 0, "field damage must not be negative")
	for pattern in override["recovery_patterns"]:
		if bool(pattern.get("first_use_hidden", false)):
			_expect(pattern["max_first_observation_damage"] == 12, "signal module should cap hidden first damage at 12")

	var fake := FakeCoreState.new()
	var before := {
		"turn": 1,
		"current_pattern_id": "poc001_pattern_false_terminal",
		"observed_pattern_ids": []
	}
	var omen_results: Array[Dictionary] = adapter.after_omen(fake, before, {"success": false})
	_expect(omen_results.size() >= 1, "failed omen should produce eligible support decisions")
	if not omen_results.is_empty():
		_expect(omen_results[0]["triggered"], "trust 2 should guarantee the unique support")
	_expect(fake.calls.size() == 1, "triggered support should apply once")
	if not fake.calls.is_empty():
		_expect(fake.calls[0]["event_key"] == "omen:1:poc001_pattern_false_terminal", "omen event key should be stable")
	var cached: Array[Dictionary] = adapter.after_omen(fake, before, {"success": false})
	_expect(cached == omen_results, "same event key should reuse cached result")
	_expect(fake.calls.size() == 1, "cached support should not apply twice")

	var lines: Array[String] = adapter.get_status_lines()
	_expect(lines.size() == 2, "unique and public skill status should both be visible")
	if not lines.is_empty():
		_expect(lines[0].contains("조건:"), "status should show trigger condition")
		_expect(lines[0].contains("확률"), "status should show chance")
		_expect(lines[0].contains("준비도"), "status should show readiness")
		_expect(lines[0].contains("남은"), "status should show remaining uses")
	_expect(adapter.get_support_log().size() == 1, "triggered support should be logged")

	var normal := adapter.build_annual_reward(
		{"recovery_quality": "normal_capture"},
		{"status": "verified", "danger_cases": []}
	)
	_expect(normal["residual_data_gain"] == 2, "normal capture should grant two residual data")
	_expect(normal["institution_support_delta"] == 1, "normal capture should grant institution support")
	var emergency := adapter.build_annual_reward(
		{"recovery_quality": "emergency_capture"},
		{"status": "candidate", "danger_cases": [{"id": "danger"}]}
	)
	_expect(emergency["residual_data_gain"] == 1, "emergency capture should grant one residual data")
	_expect(emergency["institution_support_delta"] == -1, "emergency capture should reduce institution support")
	_expect(emergency["danger_case_count"] == 1, "danger case count should be preserved")
	_finish()

func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)

func _finish() -> void:
	if _failures.is_empty():
		print("ANNUAL MVP 001 ADAPTER: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
