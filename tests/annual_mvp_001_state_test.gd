extends SceneTree

const Data = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_data.gd")
const State = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_state_v2.gd")

var _config: Dictionary

func _init() -> void:
	_config = Data.load_config("res://data/poc/annual_mvp_001/spring_vertical_slice.json")
	_test_initial_and_week_result()
	_test_underfilled_warning_and_auto_rest()
	_test_direct_rest_is_stronger_than_auto_rest()
	_test_early_deployment_verified_path()
	_test_week_three_candidate_path()
	_test_forced_emergency_path()
	_test_invalid_command_is_immutable()
	print("ANNUAL MVP 001 STATE: PASS")
	quit()


func _new_state(seed: int = 2001, starting_fatigue: int = 10) -> RefCounted:
	var state := State.new()
	var config := _config.duplicate(true)
	config["starting_state"]["fatigue"] = starting_fatigue
	assert(state.start(config, seed)["ok"])
	return state


func _commit_and_ack(state: RefCounted, activities: Array[String]) -> void:
	var result: Dictionary = state.commit_week(activities)
	if bool(result.get("requires_auto_rest_confirmation", false)):
		result = state.commit_week_with_auto_rest(activities)
	assert(result["ok"])
	assert(state.get_snapshot()["phase"] == "WEEK_RESULT")
	assert(state.acknowledge_week_result()["ok"])


func _rests(count: int) -> Array[String]:
	var values: Array[String] = []
	for _index in range(count):
		values.append("annual001_activity_rest")
	return values


func _test_initial_and_week_result() -> void:
	var state := _new_state()
	var snapshot: Dictionary = state.get_snapshot()
	assert(snapshot["phase"] == "WEEK_PLANNING")
	assert(snapshot["week"] == 1)
	assert(snapshot["fatigue"] == 10)
	var result: Dictionary = state.commit_week([
		"annual001_activity_observation_drill",
		"annual001_activity_field_training",
		"annual001_activity_rest",
		"annual001_activity_rest",
	])
	assert(result["ok"])
	snapshot = state.get_snapshot()
	assert(snapshot["competencies"]["observation"] == 2)
	assert(snapshot["competencies"]["field_response"] == 2)
	assert(snapshot["fatigue"] == 0)
	assert(snapshot["institution_support"] == 1)
	assert(snapshot["unlocked_skill_ids"].has("annual001_skill_emergency_cover"))
	assert(snapshot["last_week_result"]["planned_days"] == 7)
	assert(snapshot["last_week_result"]["used_days"] == 7)
	assert(snapshot["last_week_result"]["auto_rest_days"] == 0)
	assert((snapshot["last_week_result"]["activity_results"] as Array).size() == 4)


func _test_underfilled_warning_and_auto_rest() -> void:
	var state := _new_state(2010, 60)
	var before: Dictionary = state.get_snapshot()
	var activities: Array[String] = ["annual001_activity_analysis_desk"]
	var warning: Dictionary = state.commit_week(activities)
	assert(not warning["ok"])
	assert(warning["requires_auto_rest_confirmation"])
	assert(warning["planned_days"] == 2)
	assert(warning["remaining_days"] == 5)
	assert(String(warning["error"]).contains("자동 휴식"))
	assert(state.get_snapshot() == before)
	var committed: Dictionary = state.commit_week_with_auto_rest(activities)
	assert(committed["ok"])
	var snapshot: Dictionary = state.get_snapshot()
	assert(snapshot["phase"] == "WEEK_RESULT")
	assert(snapshot["fatigue"] == 45)
	assert(snapshot["competencies"]["analysis"] == 2)
	assert(snapshot["institution_support"] == 0)
	assert(snapshot["companion_trust"]["annual001_companion_oh_hyun"] == 0)
	var week_result := snapshot["last_week_result"] as Dictionary
	assert(week_result["planned_days"] == 2)
	assert(week_result["used_days"] == 7)
	assert(week_result["auto_rest_days"] == 5)
	var auto_result := (week_result["activity_results"] as Array)[1] as Dictionary
	assert(auto_result["activity_id"] == "annual001_activity_auto_rest")
	assert(auto_result["fatigue"] == -25)
	assert(not auto_result["status_recovery_eligible"])
	assert(not auto_result["relationship_event_eligible"])
	assert(not auto_result["special_recovery_eligible"])
	assert(not auto_result["bonus_eligible"])


func _test_direct_rest_is_stronger_than_auto_rest() -> void:
	var automatic := _new_state(2011, 60)
	assert(automatic.commit_week([])["requires_auto_rest_confirmation"])
	assert(automatic.commit_week_with_auto_rest([])["ok"])
	assert(automatic.get_snapshot()["fatigue"] == 25)

	var direct := _new_state(2012, 60)
	var direct_plan: Array[String] = ["annual001_activity_rest"]
	assert(direct.commit_week(direct_plan)["requires_auto_rest_confirmation"])
	assert(direct.commit_week_with_auto_rest(direct_plan)["ok"])
	assert(direct.get_snapshot()["fatigue"] == 5)
	var first_result := (direct.get_snapshot()["last_week_result"]["activity_results"] as Array)[0] as Dictionary
	assert(first_result["activity_id"] == "annual001_activity_rest")
	assert(first_result["status_recovery_eligible"])


func _test_early_deployment_verified_path() -> void:
	var state := _new_state(2001)
	_commit_and_ack(state, [
		"annual001_activity_signal_research",
		"annual001_activity_signal_research",
		"annual001_activity_rest",
	])
	_commit_and_ack(state, [
		"annual001_activity_companion_drill",
		"annual001_activity_companion_drill",
		"annual001_activity_rest",
		"annual001_activity_rest",
		"annual001_activity_rest",
	])
	assert(state.get_snapshot()["phase"] == "DEPLOYMENT_DECISION")
	assert(state.choose_deployment_decision("annual001_decision_deploy")["ok"])
	assert(state.get_snapshot()["deployment_risk"] == 0)
	assert(state.complete_research_project("annual001_research_signal_buffer")["ok"])
	assert(state.get_snapshot()["unlocked_module_ids"].has("annual001_module_signal_buffer"))
	assert(state.configure_loadout(
		"annual001_companion_oh_hyun",
		"",
		["annual001_module_signal_buffer"]
	)["ok"])
	var begin: Dictionary = state.begin_incident()
	assert(begin["ok"])
	assert(begin["events"][0]["event"] == "annual_incident_requested")
	assert(begin["events"][0]["run_seed"] == 2001)
	assert(state.apply_incident_result(
		{"recovery_quality": "normal_capture"},
		{"status": "verified", "danger_cases": []},
		[{"skill_id": "annual001_skill_procedural_check"}]
	)["ok"])
	assert(state.advance_from_incident_result()["ok"])
	assert(state.complete_research_project("annual001_research_ticket_protocol")["ok"])
	var snapshot: Dictionary = state.get_snapshot()
	assert(snapshot["phase"] == "QUARTER_SUMMARY")
	assert(snapshot["residual_data"] == 1)
	assert(snapshot["unlocked_skill_ids"].has("annual001_skill_signal_cross_check"))
	assert(snapshot["quarter_summary"]["knowledge_quality"] == "verified")
	assert(snapshot["quarter_summary"]["support_trigger_count"] == 1)
	assert(snapshot["quarter_summary"]["next_cycle_flags"].has("annual001_flag_manual_verified"))
	assert(state.confirm_quarter_summary()["ok"])
	assert(state.get_snapshot()["phase"] == "COMPLETE")


func _test_week_three_candidate_path() -> void:
	var state := _new_state(2002)
	_commit_and_ack(state, [
		"annual001_activity_analysis_desk",
		"annual001_activity_companion_drill",
		"annual001_activity_rest",
		"annual001_activity_rest",
		"annual001_activity_rest",
	])
	_commit_and_ack(state, [
		"annual001_activity_observation_drill",
		"annual001_activity_analysis_desk",
		"annual001_activity_rest",
		"annual001_activity_rest",
		"annual001_activity_rest",
	])
	assert(state.choose_deployment_decision("annual001_decision_delay")["ok"])
	assert(state.get_snapshot()["week"] == 3)
	_commit_and_ack(state, [
		"annual001_activity_field_training",
		"annual001_activity_interview_duty",
		"annual001_activity_rest",
		"annual001_activity_rest",
	])
	assert(state.choose_deployment_decision("annual001_decision_deploy")["ok"])
	assert(state.get_snapshot()["deployment_risk"] == 15)
	assert(state.configure_loadout("annual001_companion_oh_hyun", "annual001_skill_emergency_cover", [])["ok"])
	assert(state.begin_incident()["ok"])
	assert(state.apply_incident_result(
		{"recovery_quality": "costly_capture"},
		{"status": "candidate", "danger_cases": [{"id": "danger-1"}]},
		[]
	)["ok"])
	assert(state.advance_from_incident_result()["ok"])
	assert(state.skip_post_incident_research()["ok"])
	var summary: Dictionary = state.get_snapshot()["quarter_summary"] as Dictionary
	assert(summary["weeks_used"] == 3)
	assert(summary["recovery_quality"] == "costly_capture")
	assert(summary["knowledge_quality"] == "candidate")
	assert(summary["next_cycle_flags"].has("annual001_flag_manual_candidate"))


func _test_forced_emergency_path() -> void:
	var state := _new_state(2003)
	_commit_and_ack(state, _rests(7))
	_commit_and_ack(state, _rests(7))
	assert(state.choose_deployment_decision("annual001_decision_delay")["ok"])
	_commit_and_ack(state, _rests(7))
	assert(state.choose_deployment_decision("annual001_decision_delay")["ok"])
	assert(state.get_snapshot()["week"] == 4)
	assert(state.get_snapshot()["phase"] == "WEEK_PLANNING")
	assert(state.commit_week(_rests(7))["ok"])
	assert(state.get_snapshot()["phase"] == "WEEK_RESULT")
	var forced: Dictionary = state.acknowledge_week_result()
	assert(forced["ok"])
	assert(forced["events"][0]["event"] == "annual_forced_deployment")
	assert(forced["events"][0]["week"] == 4)
	var snapshot: Dictionary = state.get_snapshot()
	assert(snapshot["phase"] == "PREPARATION")
	assert(snapshot["forced_deployment"])
	assert(snapshot["deployment_risk"] == 30)
	assert(state.configure_loadout("annual001_companion_oh_hyun", "", [])["ok"])
	assert(state.begin_incident()["ok"])
	assert(state.apply_incident_result(
		{"recovery_quality": "emergency_capture"},
		{"status": "verified", "danger_cases": []},
		[]
	)["ok"])
	assert(state.get_snapshot()["institution_support"] == 0)
	assert(state.advance_from_incident_result()["ok"])
	assert(state.skip_post_incident_research()["ok"])
	assert(state.get_snapshot()["quarter_summary"]["weeks_used"] == 4)
	assert(state.get_snapshot()["quarter_summary"]["next_cycle_flags"].has("annual001_flag_emergency_deployment"))


func _test_invalid_command_is_immutable() -> void:
	var state := _new_state()
	var before: Dictionary = state.get_snapshot()
	var over_budget: Dictionary = state.commit_week([
		"annual001_activity_field_training",
		"annual001_activity_field_training",
		"annual001_activity_field_training",
	])
	assert(not over_budget["ok"])
	assert(String(over_budget["error"]).contains("7일"))
	assert(state.get_snapshot() == before)
	var unknown: Dictionary = state.commit_week(["annual001_activity_missing"])
	assert(not unknown["ok"])
	assert(state.get_snapshot() == before)
