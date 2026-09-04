class_name AnnualMvp001StateV2
extends "res://scripts/poc/annual_mvp_001/annual_mvp_001_state.gd"

const AUTO_REST_ACTIVITY_ID := "annual001_activity_auto_rest"


func commit_week(activity_ids: Array[String]) -> Dictionary:
	var validation := _validate_day_plan(activity_ids)
	if not bool(validation.get("ok", false)):
		return _response(false, String(validation.get("error", "주간 계획을 확정할 수 없다.")), false)
	var remaining_days := int(validation.get("remaining_days", 0))
	if remaining_days > 0:
		var warning := _response(
			false,
			"사용하지 않은 일정이 %d일 남아 있습니다. 지금 확정하면 남은 %d일은 자동 휴식 처리됩니다." % [remaining_days, remaining_days],
			false
		)
		warning["requires_auto_rest_confirmation"] = true
		warning["planned_days"] = int(validation.get("planned_days", 0))
		warning["remaining_days"] = remaining_days
		return warning
	return _apply_day_plan(activity_ids, 0)


func commit_week_with_auto_rest(activity_ids: Array[String]) -> Dictionary:
	var validation := _validate_day_plan(activity_ids)
	if not bool(validation.get("ok", false)):
		return _response(false, String(validation.get("error", "주간 계획을 확정할 수 없다.")), false)
	return _apply_day_plan(activity_ids, int(validation.get("remaining_days", 0)))


func _validate_day_plan(activity_ids: Array[String]) -> Dictionary:
	if _phase != "WEEK_PLANNING":
		return {"ok": false, "error": "현재 단계에서는 주간 계획을 확정할 수 없다."}
	var campaign := _config.get("campaign", {}) as Dictionary
	var days_per_week := int(campaign.get("days_per_week", 7))
	var planned_days := 0
	for activity_id in activity_ids:
		if not _activities.has(activity_id):
			return {"ok": false, "error": "알 수 없는 활동: %s" % activity_id}
		var activity := _activities[activity_id] as Dictionary
		var day_cost := int(activity.get("day_cost", 0))
		if day_cost < 1:
			return {"ok": false, "error": "활동 일수 계약이 잘못되었습니다: %s" % activity_id}
		planned_days += day_cost
		if planned_days > days_per_week:
			return {
				"ok": false,
				"error": "일정은 주차 경계를 넘을 수 없습니다. 한 주는 %d일입니다." % days_per_week,
				"planned_days": planned_days,
				"remaining_days": 0,
			}
	return {
		"ok": true,
		"planned_days": planned_days,
		"remaining_days": days_per_week - planned_days,
		"days_per_week": days_per_week,
	}


func _apply_day_plan(activity_ids: Array[String], auto_rest_days: int) -> Dictionary:
	var before := get_snapshot()
	var campaign := _config.get("campaign", {}) as Dictionary
	var days_per_week := int(campaign.get("days_per_week", 7))
	var planned_days := days_per_week - auto_rest_days
	_planned_activity_ids = activity_ids.duplicate()
	var activity_results: Array[Dictionary] = []
	for activity_id in activity_ids:
		activity_results.append(_apply_activity(String(activity_id)))
	if auto_rest_days > 0:
		activity_results.append(_apply_auto_rest(auto_rest_days))

	# `activity_results` is the canonical machine-readable record. The legacy
	# `activity_ids` field also feeds the inherited result label, so append a
	# localized automatic-rest entry without changing authored activity IDs.
	var display_activity_ids: Array[String] = activity_ids.duplicate()
	if auto_rest_days > 0:
		display_activity_ids.append("자동 휴식 %d일" % auto_rest_days)

	_refresh_institution_unlocks()
	_last_week_result = {
		"week": _week,
		"activity_ids": display_activity_ids,
		"planned_activity_ids": activity_ids.duplicate(),
		"planned_days": planned_days,
		"used_days": days_per_week,
		"auto_rest_days": auto_rest_days,
		"activity_results": activity_results.duplicate(true),
		"slot_results": activity_results.duplicate(true),
		"before": _summary_values(before),
		"after": _summary_values(get_snapshot()),
	}
	_phase = "WEEK_RESULT"
	return _response(true, "", true, [{
		"event": "annual_week_committed",
		"week": _week,
		"planned_days": planned_days,
		"auto_rest_days": auto_rest_days,
	}])


func _apply_activity(activity_id: String) -> Dictionary:
	var activity := _activities[activity_id] as Dictionary
	var deltas := activity.get("deltas", {}) as Dictionary
	var activity_start_fatigue := _fatigue
	var applied: Dictionary = {
		"activity_id": activity_id,
		"day_cost": int(activity.get("day_cost", 0)),
		"auto_rest": false,
		"status_recovery_eligible": bool(activity.get("status_recovery_eligible", false)),
		"relationship_event_eligible": true,
		"special_recovery_eligible": String(activity.get("rest_mode", "")) == "direct",
		"bonus_eligible": true,
		"competencies": {},
		"fatigue": 0,
		"institution_support": 0,
		"research_progress": {},
		"companion_trust": {},
	}
	var competency_deltas := deltas.get("competencies", {}) as Dictionary
	for competency_id in competency_deltas.keys():
		var requested := int(competency_deltas[competency_id])
		var effective := requested
		if requested > 0 and activity_start_fatigue >= 60:
			effective = max(0, requested - 1)
		var old_value := int(_competencies.get(competency_id, 0))
		var new_value: int = clampi(old_value + effective, 0, 5)
		_competencies[competency_id] = new_value
		(applied["competencies"] as Dictionary)[competency_id] = new_value - old_value

	var fatigue_delta := int(deltas.get("fatigue", 0))
	var old_fatigue := _fatigue
	_fatigue = clampi(_fatigue + fatigue_delta, 0, 100)
	applied["fatigue"] = _fatigue - old_fatigue

	var support_delta := int(deltas.get("institution_support", 0))
	var old_support := _institution_support
	_institution_support = clampi(_institution_support + support_delta, 0, 3)
	applied["institution_support"] = _institution_support - old_support

	for project_id in (deltas.get("research_progress", {}) as Dictionary).keys():
		var old_progress := int(_research_progress.get(project_id, 0))
		var new_progress: int = maxi(0, old_progress + int((deltas.get("research_progress", {}) as Dictionary)[project_id]))
		_research_progress[project_id] = new_progress
		(applied["research_progress"] as Dictionary)[project_id] = new_progress - old_progress

	for companion_id in (deltas.get("companion_trust", {}) as Dictionary).keys():
		var old_trust := int(_companion_trust.get(companion_id, 0))
		var new_trust: int = clampi(old_trust + int((deltas.get("companion_trust", {}) as Dictionary)[companion_id]), 0, 3)
		_companion_trust[companion_id] = new_trust
		(applied["companion_trust"] as Dictionary)[companion_id] = new_trust - old_trust
	return applied


func _apply_auto_rest(auto_rest_days: int) -> Dictionary:
	var recovery_per_day := int((_config.get("campaign", {}) as Dictionary).get("auto_rest_fatigue_recovery_per_day", 5))
	var old_fatigue := _fatigue
	_fatigue = clampi(_fatigue - auto_rest_days * recovery_per_day, 0, 100)
	return {
		"activity_id": AUTO_REST_ACTIVITY_ID,
		"day_cost": auto_rest_days,
		"auto_rest": true,
		"status_recovery_eligible": false,
		"relationship_event_eligible": false,
		"special_recovery_eligible": false,
		"bonus_eligible": false,
		"competencies": {},
		"fatigue": _fatigue - old_fatigue,
		"institution_support": 0,
		"research_progress": {},
		"companion_trust": {},
	}


func acknowledge_week_result() -> Dictionary:
	if _phase != "WEEK_RESULT":
		return _response(false, "확인할 주간 결과가 없다.", false)
	var campaign := _config.get("campaign", {}) as Dictionary
	var max_weeks := int(campaign.get("max_weeks", 4))
	var deadline_week := int(campaign.get("deadline_week", max_weeks))
	if _week == 1:
		_week = 2
		_phase = "WEEK_PLANNING"
		_planned_activity_ids.clear()
		return _response(true, "", true)
	if _week < deadline_week:
		_phase = "DEPLOYMENT_DECISION"
		_planned_activity_ids.clear()
		return _response(true, "", true)
	if _week == deadline_week and _week <= max_weeks:
		_deployment_risk = int(campaign.get("forced_entry_risk", 30))
		_forced_deployment = true
		_phase = "PREPARATION"
		_planned_activity_ids.clear()
		return _response(true, "", true, [{"event": "annual_forced_deployment", "week": _week}])
	return _response(false, "주차 범위를 벗어났다.", false)


func choose_deployment_decision(decision_id: String) -> Dictionary:
	if _phase != "DEPLOYMENT_DECISION":
		return _response(false, "현재 단계에서는 출동을 결정할 수 없다.", false)
	if decision_id not in ["annual001_decision_deploy", "annual001_decision_delay"]:
		return _response(false, "알 수 없는 출동 결정이다.", false)
	var campaign := _config.get("campaign", {}) as Dictionary
	var voluntary_entry_week := int(campaign.get("voluntary_entry_week", 2))
	var deadline_week := int(campaign.get("deadline_week", 4))
	if decision_id == "annual001_decision_deploy":
		if _week >= deadline_week:
			return _response(false, "최종 주차에는 자율 출동 결정을 사용할 수 없다.", false)
		_deployment_risk = 0 if _week == voluntary_entry_week else int(campaign.get("week_3_entry_risk", 15))
		_phase = "PREPARATION"
		return _response(true, "", true, [{"event": "annual_deployment_selected", "forced": false, "week": _week}])
	if _week >= deadline_week:
		return _response(false, "최종 주차에는 출동을 더 지연할 수 없다.", false)
	_week += 1
	_phase = "WEEK_PLANNING"
	_planned_activity_ids.clear()
	return _response(true, "", true, [{"event": "annual_deployment_delayed", "week": _week}])
