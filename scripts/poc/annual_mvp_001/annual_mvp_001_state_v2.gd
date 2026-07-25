class_name AnnualMvp001StateV2
extends "res://scripts/poc/annual_mvp_001/annual_mvp_001_state.gd"


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
