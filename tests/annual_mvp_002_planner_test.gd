extends SceneTree

const BaseData = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_data.gd")
const Planner = preload("res://scripts/poc/annual_mvp_002/annual_mvp_002_planner.gd")

var _activities: Array[Dictionary] = []


func _init() -> void:
	var config: Dictionary = BaseData.load_config("res://data/poc/annual_mvp_001/spring_vertical_slice.json")
	_activities = _dictionaries(config.get("activities", []) as Array)
	_test_preview_aggregates_effects()
	_test_over_budget_rejected_without_mutation()
	_test_undo_and_clear()
	_test_last_week_copy_uses_canonical_ids()
	_test_three_templates_and_restore()
	print("ANNUAL MVP 002 PLANNER: PASS")
	quit()


func _strings(values: Array) -> Array[String]:
	var result: Array[String] = []
	for value in values:
		result.append(String(value))
	return result


func _dictionaries(values: Array) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for value in values:
		result.append((value as Dictionary).duplicate(true))
	return result


func _new_planner() -> RefCounted:
	var planner: RefCounted = Planner.new()
	var configured: Dictionary = planner.configure(_activities, 7)
	assert(configured.get("ok", false))
	return planner


func _test_preview_aggregates_effects() -> void:
	var planner: RefCounted = _new_planner()
	assert(planner.set_plan(_strings([
		"annual001_activity_observation_drill",
		"annual001_activity_interview_duty",
		"annual001_activity_rest",
	]))["ok"])
	var preview: Dictionary = planner.preview()
	assert(preview["ok"])
	assert(preview["used_days"] == 5)
	assert(preview["remaining_days"] == 2)
	assert(preview["activity_ids"] == _strings([
		"annual001_activity_observation_drill",
		"annual001_activity_interview_duty",
		"annual001_activity_rest",
	]))
	var aggregate: Dictionary = preview["aggregate"] as Dictionary
	assert(aggregate["fatigue"] == -3)
	assert((aggregate["competencies"] as Dictionary)["observation"] == 1)
	assert((aggregate["competencies"] as Dictionary)["interpersonal"] == 1)
	assert(aggregate["institution_support"] == 1)
	assert((preview["lines"] as Array).size() == 3)


func _test_over_budget_rejected_without_mutation() -> void:
	var planner: RefCounted = _new_planner()
	assert(planner.set_plan(_strings([
		"annual001_activity_field_training",
		"annual001_activity_field_training",
	]))["ok"])
	var before: Dictionary = planner.get_snapshot()
	var rejected: Dictionary = planner.append_activity("annual001_activity_field_training")
	assert(not rejected["ok"])
	assert(String(rejected["error"]).contains("7일"))
	assert(planner.get_snapshot() == before)
	assert(not planner.append_activity("annual001_activity_missing")["ok"])
	assert(planner.get_snapshot() == before)


func _test_undo_and_clear() -> void:
	var planner: RefCounted = _new_planner()
	assert(planner.append_activity("annual001_activity_analysis_desk")["ok"])
	assert(planner.append_activity("annual001_activity_rest")["ok"])
	assert(planner.undo()["ok"])
	assert(planner.preview()["activity_ids"] == _strings(["annual001_activity_analysis_desk"]))
	assert(planner.clear()["ok"])
	assert((planner.preview()["activity_ids"] as Array).is_empty())
	assert(planner.undo()["ok"])
	assert(planner.preview()["activity_ids"] == _strings(["annual001_activity_analysis_desk"]))
	assert(not planner.undo()["ok"])


func _test_last_week_copy_uses_canonical_ids() -> void:
	var planner: RefCounted = _new_planner()
	var copied: Dictionary = planner.copy_last_week({
		"activity_ids": ["관측 훈련(2일)", "자동 휴식 5일"],
		"planned_activity_ids": ["annual001_activity_observation_drill"],
	})
	assert(copied["ok"])
	assert(planner.preview()["activity_ids"] == _strings(["annual001_activity_observation_drill"]))
	var before: Dictionary = planner.get_snapshot()
	assert(not planner.copy_last_week({"planned_activity_ids": ["annual001_activity_missing"]})["ok"])
	assert(planner.get_snapshot() == before)


func _test_three_templates_and_restore() -> void:
	var planner: RefCounted = _new_planner()
	assert(planner.set_plan(_strings([
		"annual001_activity_signal_research",
		"annual001_activity_rest",
	]))["ok"])
	assert(planner.save_template(1)["ok"])
	assert(planner.clear()["ok"])
	assert(planner.apply_template(1)["ok"])
	assert(planner.preview()["activity_ids"] == _strings([
		"annual001_activity_signal_research",
		"annual001_activity_rest",
	]))
	assert(not planner.save_template(0)["ok"])
	assert(not planner.save_template(4)["ok"])
	var snapshot: Dictionary = planner.get_snapshot()
	assert((snapshot["templates"] as Array).size() == 3)
	var restored: RefCounted = _new_planner()
	assert(restored.restore(snapshot)["ok"])
	assert(restored.get_snapshot() == snapshot)
	var invalid: Dictionary = snapshot.duplicate(true)
	(invalid["templates"] as Array)[0] = ["annual001_activity_missing"]
	var before: Dictionary = restored.get_snapshot()
	assert(not restored.restore(invalid)["ok"])
	assert(restored.get_snapshot() == before)
