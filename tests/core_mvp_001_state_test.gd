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
	_expect_common_response(started, "start")
	_expect(started.get("ok", false), "state should start with valid case data")
	var snapshot := state.get_snapshot()
	_expect(snapshot.get("phase") == "ELIMINATION", "state should start in elimination")
	_expect(snapshot.get("health") == 100, "state should start with 100 health")
	_expect(snapshot.get("risk") == 0, "state should start with zero risk")
	_expect(snapshot.get("available_choice_ids", []).size() == 4, "four choices should be available")
	_expect(not snapshot.has("enemy_hp"), "PoC state must not expose enemy hp")

	var invalid := state.link_record_to_choice("poc001_manual_ticket_contact_danger", "poc001_choice_move_before_end")
	_expect_common_response(invalid, "invalid elimination")
	_expect(not invalid.get("ok", true), "invalid record-choice link should fail")
	_expect(not invalid.get("state_changed", true), "invalid link should not change state")
	_expect(state.get_snapshot().get("health") == 100, "invalid link should not cost health")
	_expect(state.get_snapshot().get("risk") == 0, "invalid link should not add risk")

	_expect(state.link_record_to_choice("poc001_manual_early_movement_reset", "poc001_choice_move_before_end").get("ok", false), "first valid elimination should pass")
	_expect(state.link_record_to_choice("poc001_manual_personal_destination", "poc001_choice_follow_passenger_count").get("ok", false), "second valid elimination should pass")
	_expect(state.get_snapshot().get("eliminated_choice_ids", []).size() == 2, "exactly two choices should be eliminated")
	_expect(state.advance_to_hypothesis().get("ok", false), "two eliminations should unlock hypothesis authoring")

	var irrelevant := state.submit_hypothesis(
		"poc001_hypothesis_display_route",
		["poc001_clue_passenger_count"],
		["poc001_clue_display_mismatch"],
		["poc001_question_ticket_trigger"]
	)
	_expect(not irrelevant.get("ok", true), "hypothesis should reject unrelated supporting evidence")
	_expect(state.get_snapshot().get("phase") == "HYPOTHESIS_AUTHORING", "invalid evidence must not advance phase")

	var missing_question := state.submit_hypothesis(
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
		[]
	)
	_expect(not missing_question.get("ok", true), "hypothesis should require its unresolved question to be authored")
	_expect(state.get_snapshot().get("phase") == "HYPOTHESIS_AUTHORING", "missing unresolved question must not advance phase")

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
	_expect_common_response(submitted, "hypothesis submission")
	_expect(submitted.get("ok", false), "supported hypothesis should be accepted")
	_expect(state.get_snapshot().get("understanding") == "likely", "authored supported hypothesis should reach likely")
	var field_result := state.resolve_field_test("poc001_test_wait_official_signal")
	_expect_common_response(field_result, "field test")
	_expect(field_result.get("ok", false), "correct field test should resolve")
	_expect(state.get_snapshot().get("understanding") == "understood", "decisive field test should reach understood")
	_expect((state.get_snapshot().get("resolved_question_ids", []) as Array).has("poc001_question_ticket_trigger"), "decisive field test should record the resolved question")
	_expect(state.get_snapshot().get("phase") == "RECOVERY_READY", "correct field test should unlock recovery")

	_expect(state.begin_recovery_turn().get("ok", false), "recovery turn one should begin")
	var omen_one := state.read_current_omen(100)
	_expect_common_response(omen_one, "omen read")
	_expect(omen_one.get("success", false), "understood observed pattern should always read")
	_expect(state.resolve_recovery_action("poc001_action_hold_position").get("valid", false), "turn one rule response should be valid")

	state.begin_recovery_turn()
	state.read_current_omen(100)
	_expect(state.resolve_recovery_action("poc001_action_fix_boundary").get("valid", false), "turn two rule response should be valid")

	state.begin_recovery_turn()
	var hidden_read := state.read_current_omen(1)
	_expect_common_response(hidden_read, "hidden omen read")
	_expect(not hidden_read.get("success", true), "first hidden pattern should not be identified")
	_expect(hidden_read.get("text") == "놈은 무언가 하려 한다.", "hidden pattern should use the unknown omen text")
	_expect(not hidden_read.has("target") and not hidden_read.has("range") and not hidden_read.has("condition"), "failed omen must not leak pattern fields")
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
	_expect((delta.get("unresolved_question_ids", []) as Array).is_empty(), "resolved questions should not remain unresolved in the manual delta")
	_expect((delta.get("resolved_question_ids", []) as Array).has("poc001_question_ticket_trigger"), "manual delta should preserve resolved question evidence")
	var result := state.build_result()
	_expect(result.get("outcome_id") == "poc001_outcome_normal_capture", "low damage complete capture should be normal")
	_expect(result.has("recovery_quality"), "result should separate recovery quality")
	_expect(result.has("damage_management"), "result should separate damage management")
	_expect(result.has("knowledge_quality"), "result should separate knowledge quality")
	_expect(state.confirm_manual_promotion().get("ok", false), "first manual confirmation should enter promotion review")
	_expect(state.get_snapshot().get("phase") == "MANUAL_PROMOTION", "result comparison should lead to manual promotion")
	_expect(state.confirm_manual_promotion().get("ok", false), "second manual confirmation should record the rule")
	_expect(state.get_snapshot().get("phase") == "COMPLETE", "record confirmation should complete state")

	_test_wrong_hypothesis(data)
	_test_emergency_recovery(data)
	_finish()


func _test_wrong_hypothesis(data: Dictionary) -> void:
	var state := CoreState.new()
	state.start(data, 1001)
	state.link_record_to_choice("poc001_manual_early_movement_reset", "poc001_choice_move_before_end")
	state.link_record_to_choice("poc001_manual_personal_destination", "poc001_choice_follow_passenger_count")
	state.advance_to_hypothesis()
	state.submit_hypothesis(
		"poc001_hypothesis_display_route",
		["poc001_clue_broadcast_blank"],
		["poc001_clue_display_mismatch"],
		["poc001_question_ticket_trigger"]
	)
	var failed := state.resolve_field_test("poc001_test_follow_display")
	_expect(failed.get("ok", false), "wrong field test should resolve as information-bearing failure")
	_expect(String(failed.get("reaction_clue_id", "")) == "poc001_clue_display_mismatch", "wrong test should expose only the observed reaction clue")
	var snapshot := state.get_snapshot()
	_expect(snapshot.get("phase") == "HYPOTHESIS_REFRESH", "wrong test should refresh hypotheses")
	_expect(int(snapshot.get("health", 100)) < 100, "wrong test should cost health")
	_expect(int(snapshot.get("risk", 0)) > 0, "wrong test should add risk")
	_expect(snapshot.get("danger_cases", []).size() == 1, "wrong test should create a danger case")
	_expect(snapshot.get("active_hypothesis_ids", []).size() == 2, "refresh should keep a two-hypothesis decision")


func _test_emergency_recovery(data: Dictionary) -> void:
	var emergency_data := data.duplicate(true)
	for value in emergency_data.get("field_tests", []):
		var test := value as Dictionary
		if String(test.get("id", "")) == "poc001_test_follow_display":
			test["risk_delta"] = 100
	var state := CoreState.new()
	state.start(emergency_data, 1001)
	state.link_record_to_choice("poc001_manual_early_movement_reset", "poc001_choice_move_before_end")
	state.link_record_to_choice("poc001_manual_personal_destination", "poc001_choice_follow_passenger_count")
	state.advance_to_hypothesis()
	state.submit_hypothesis(
		"poc001_hypothesis_display_route",
		["poc001_clue_broadcast_blank"],
		["poc001_clue_display_mismatch"],
		["poc001_question_ticket_trigger"]
	)
	state.resolve_field_test("poc001_test_follow_display")
	_expect(state.get_snapshot().get("phase") == "EMERGENCY_RECOVERY", "risk 100 should force emergency recovery")
	_expect(state.begin_recovery_turn().get("ok", false), "emergency recovery should still start a response turn")


func _expect_common_response(response: Dictionary, context: String) -> void:
	for key in ["ok", "error", "state_changed", "events", "snapshot"]:
		_expect(response.has(key), "%s response should include %s" % [context, key])


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
