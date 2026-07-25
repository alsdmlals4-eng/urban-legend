extends SceneTree

const Data = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_data.gd")
const State = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_state.gd")

var _config: Dictionary

func _init() -> void:
	_config = Data.load_config("res://data/poc/annual_mvp_001/spring_vertical_slice.json")
	_test_initial_and_week_result()
	_test_early_deployment_verified_path()
	_test_week_three_candidate_path()
	_test_forced_emergency_path()
	_test_invalid_command_is_immutable()
	print("ANNUAL MVP 001 STATE: PASS")
	quit()


func _new_state(seed: int = 2001) -> RefCounted:
	var state := State.new()
	assert(state.start(_config, seed)["ok"])
	return state


func _commit_and_ack(state: RefCounted, activities: Array[String]) -> void:
	assert(state.commit_week(activities)["ok"])
	assert(state.get_snapshot()["phase"] == "WEEK_RESULT")
	assert(state.acknowledge_week_result()["ok"])


func _test_initial_and_week_result() -> void:
	var state := _new_state()
	var snapshot := state.get_snapshot()
	assert(snapshot["phase"] == "WEEK_PLANNING")
	assert(snapshot["week"] == 1)
	assert(snapshot["fatigue"] == 10)
	var result := state.commit_week([
		"annual001_activity_observation_drill",
		"annual001_activity_field_training",
		"annual001_activity_rest",
	])
	assert(result["ok"])
	snapshot = state.get_snapshot()
	assert(snapshot["competencies"]["observation"] == 2)
	assert(snapshot["competencies"]["field_response"] == 2)
	assert(snapshot["fatigue"] == 12)
	assert(snapshot["institution_support"] == 1)
	assert(snapshot["unlocked_skill_ids"].has("annual001_skill_emergency_cover"))


func _test_early_deployment_verified_path() -> void:
	var state := _new_state(2001)
	_commit_and_ack(state, [
		"annual001_activity_signal_research",
		"annual001_activity_signal_research",
		"annual001_activity_field_training",
	])
	_commit_and_ack(state, [
		"annual001_activity_companion_drill",
		"annual001_activity_companion_drill",
		"annual001_activity_rest",
	])
	assert(state.get_snapshot()["phase"] == "DEPLOYMENT_DECISION")
	assert(state.choose_deployment_decision("annual001_decision_deploy")["ok"])
	assert(state.get_snapshot()["deployment_risk"] == 0)
	assert(state.complete_research_project("annual001_research_signal_buffer")["ok"])
	assert(state.get_snapshot()["unlocked_module_ids"].has("annual001_module_signal_buffer"))
	assert(state.configure_loadout(
		"annual001_companion_oh_hyun",
		"annual001_skill_emergency_cover",
		["annual001_module_signal_buffer"]
	)["ok"])
	var begin := state.begin_incident()
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
	var snapshot := state.get_snapshot()
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
		"annual001_activity_rest",
		"annual001_activity_companion_drill",
	])
	_commit_and_ack(state, [
		"annual001_activity_observation_drill",
		"annual001_activity_rest",
		"annual001_activity_analysis_desk",
	])
	assert(state.choose_deployment_decision("annual001_decision_delay")["ok"])
	assert(state.get_snapshot()["week"] == 3)
	_commit_and_ack(state, [
		"annual001_activity_field_training",
		"annual001_activity_rest",
		"annual001_activity_interview_duty",
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
	var summary := state.get_snapshot()["quarter_summary"] as Dictionary
	assert(summary["weeks_used"] == 3)
	assert(summary["recovery_quality"] == "costly_capture")
	assert(summary["knowledge_quality"] == "candidate")
	assert(summary["next_cycle_flags"].has("annual001_flag_manual_candidate"))


func _test_forced_emergency_path() -> void:
	var state := _new_state(2003)
	_commit_and_ack(state, ["annual001_activity_rest", "annual001_activity_rest", "annual001_activity_rest"])
	_commit_and_ack(state, ["annual001_activity_rest", "annual001_activity_rest", "annual001_activity_rest"])
	assert(state.choose_deployment_decision("annual001_decision_delay")["ok"])
	_commit_and_ack(state, ["annual001_activity_rest", "annual001_activity_rest", "annual001_activity_rest"])
	assert(state.choose_deployment_decision("annual001_decision_delay")["ok"])
	var snapshot := state.get_snapshot()
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
	assert(state.get_snapshot()["quarter_summary"]["next_cycle_flags"].has("annual001_flag_emergency_deployment"))


func _test_invalid_command_is_immutable() -> void:
	var state := _new_state()
	var before := state.get_snapshot()
	var result := state.commit_week(["annual001_activity_rest"])
	assert(not result["ok"])
	assert(state.get_snapshot() == before)
