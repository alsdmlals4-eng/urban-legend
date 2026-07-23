extends SceneTree

const CaseData = preload("res://scripts/poc/core_mvp_001/core_mvp_001_case_data.gd")
const CoreState = preload("res://scripts/poc/core_mvp_001/core_mvp_001_state.gd")

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var data := CaseData.load_case("res://data/poc/core_mvp_001/afterlife_station_poc.json")
	var state := CoreState.new()
	var started := state.start(data, 1001)
	_expect(started.get("ok", false), "state should start with valid case data")
	var snapshot := state.get_snapshot()
	_expect(snapshot.get("phase") == "ELIMINATION", "state should start in elimination")
	_expect(snapshot.get("health") == 100, "state should start with 100 health")
	_expect(snapshot.get("risk") == 0, "state should start with zero risk")
	_expect(snapshot.get("available_choice_ids", []).size() == 4, "four choices should be available")

	var invalid := state.link_record_to_choice("poc001_manual_official_signal", "poc001_choice_move_before_end")
	_expect(not invalid.get("ok", true), "invalid record-choice link should fail")
	_expect(not invalid.get("state_changed", true), "invalid link should not change state")
	_expect(state.get_snapshot().get("health") == 100, "invalid link should not cost health")
	_expect(state.get_snapshot().get("risk") == 0, "invalid link should not add risk")

	_expect(state.link_record_to_choice("poc001_manual_early_movement_reset", "poc001_choice_move_before_end").get("ok", false), "first valid elimination should pass")
	_expect(state.link_record_to_choice("poc001_manual_passenger_count_unreliable", "poc001_choice_follow_passenger_count").get("ok", false), "second valid elimination should pass")
	_expect(state.get_snapshot().get("eliminated_choice_ids", []).size() == 2, "exactly two choices should be eliminated")
	_expect(state.advance_to_hypothesis().get("ok", false), "two eliminations should unlock hypothesis authoring")

	var submitted := state.submit_hypothesis(
		"poc001_hypothesis_broadcast_blank",
		[
			"poc001_clue_broadcast_blank",
			"poc001_clue_reset_timing",
			"poc001_clue_official_identifier"
		],
		[
			"poc001_clue_display_mismatch",
			"poc001_clue_passenger_count"
		],
		["poc001_question_ticket_trigger"]
	)
	_expect(submitted.get("ok", false), "supported hypothesis should be accepted")
	_expect(state.get_snapshot().get("understanding") == "likely", "authored supported hypothesis should reach likely")
	_expect(state.resolve_field_test("poc001_test_wait_official_signal").get("ok", false), "correct field test should resolve")
	_expect(state.get_snapshot().get("understanding") == "understood", "decisive field test should reach understood")
	_expect(state.get_snapshot().get("phase") == "RECOVERY_READY", "correct field test should unlock recovery")

	_expect(state.begin_recovery_turn().get("ok", false), "recovery turn one should begin")
	_expect(state.read_current_omen(100).get("success", false), "understood observed pattern should always read")
	_expect(state.resolve_recovery_action("poc001_action_hold_position").get("valid", false), "turn one rule response should be valid")

	state.begin_recovery_turn()
	state.read_current_omen(100)
	_expect(state.resolve_recovery_action("poc001_action_anchor_boundary").get("valid", false), "turn two rule response should be valid")

	state.begin_recovery_turn()
	var hidden_read := state.read_current_omen(1)
	_expect(not hidden_read.get("success", true), "first hidden pattern should not be identified")
	_expect(hidden_read.get("text") == "놈은 무언가 하려 한다.", "hidden pattern should use the unknown omen text")
	var mitigated := state.resolve_recovery_action("poc001_action_guard")
	_expect(mitigated.get("valid", false), "generic defense should mitigate first hidden pattern")
	_expect(int(mitigated.get("damage", 99)) <= 18, "first hidden pattern damage should respect the cap")

	state.begin_recovery_turn()
	state.read_current_omen(100)
	state.resolve_recovery_action("poc001_action_hold_position")

	state.begin_recovery_turn()
	_expect(state.read_current_omen(100).get("success", false), "observed hidden pattern should be readable at understood")
	var last_response := state.resolve_recovery_action("poc001_action_isolate_ticket")
	_expect(last_response.get("valid", false), "observed ticket pattern should accept its rule response")
	_expect(state.get_snapshot().get("phase") == "CAPTURE_WINDOW", "three marks on turn five should open capture")
	_expect(state.get_snapshot().get("capture_marks", []).size() == 3, "capture marks should not duplicate")

	_expect(state.execute_capture().get("ok", false), "capture should execute from capture window")
	var delta := state.build_manual_delta()
	_expect(delta.get("status") == "verified", "complete evidence should create a verified rule")
	var result := state.build_result()
	_expect(result.get("outcome_id") == "poc001_outcome_normal_capture", "low damage complete capture should be normal")
	_expect(state.confirm_manual_promotion().get("ok", false), "manual confirmation should complete the PoC")
	_expect(state.get_snapshot().get("phase") == "COMPLETE", "manual confirmation should complete state")

	_test_wrong_hypothesis(data)
	_finish()


func _test_wrong_hypothesis(data: Dictionary) -> void:
	var state := CoreState.new()
	state.start(data, 1001)
	state.link_record_to_choice("poc001_manual_early_movement_reset", "poc001_choice_move_before_end")
	state.link_record_to_choice("poc001_manual_passenger_count_unreliable", "poc001_choice_follow_passenger_count")
	state.advance_to_hypothesis()
	state.submit_hypothesis(
		"poc001_hypothesis_display_route",
		["poc001_clue_broadcast_blank"],
		["poc001_clue_display_mismatch"],
		["poc001_question_ticket_trigger"]
	)
	var failed := state.resolve_field_test("poc001_test_follow_display")
	_expect(failed.get("ok", false), "wrong field test should resolve as information-bearing failure")
	var snapshot := state.get_snapshot()
	_expect(snapshot.get("phase") == "HYPOTHESIS_REFRESH", "wrong test should refresh hypotheses")
	_expect(int(snapshot.get("health", 100)) < 100, "wrong test should cost health")
	_expect(int(snapshot.get("risk", 0)) > 0, "wrong test should add risk")
	_expect(snapshot.get("danger_cases", []).size() == 1, "wrong test should create a danger case")
	_expect(snapshot.get("active_hypothesis_ids", []).size() == 2, "refresh should keep a two-hypothesis decision")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("CORE MVP 001 STATE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
