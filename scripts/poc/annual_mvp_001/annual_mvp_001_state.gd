class_name AnnualMvp001State
extends RefCounted

const Data = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_data.gd")

var _config: Dictionary = {}
var _activities: Dictionary = {}
var _companions: Dictionary = {}
var _skills: Dictionary = {}
var _modules: Dictionary = {}
var _research_projects: Dictionary = {}

var _phase := "BOOT"
var _week := 0
var _planned_activity_ids: Array[String] = []
var _last_week_result: Dictionary = {}
var _competencies: Dictionary = {}
var _fatigue := 0
var _institution_support := 0
var _residual_data := 0
var _companion_trust: Dictionary = {}
var _research_progress: Dictionary = {}
var _completed_research_ids: Array[String] = []
var _unlocked_module_ids: Array[String] = []
var _unlocked_skill_ids: Array[String] = []
var _selected_companion_id := ""
var _selected_public_skill_id := ""
var _equipped_module_ids: Array[String] = []
var _deployment_risk := 0
var _forced_deployment := false
var _incident_result: Dictionary = {}
var _manual_delta: Dictionary = {}
var _support_log: Array[Dictionary] = []
var _quarter_summary: Dictionary = {}
var _run_seed := 2001


func start(config: Dictionary, run_seed: int = 2001) -> Dictionary:
	var errors := Data.validate_config(config)
	if not errors.is_empty():
		return _response(false, "; ".join(errors), false)
	_config = config.duplicate(true)
	_activities = Data.index_by_id(_config["activities"])
	_companions = Data.index_by_id(_config["companions"])
	_skills = Data.index_by_id(_config["support_skills"])
	_modules = Data.index_by_id(_config["modules"])
	_research_projects = Data.index_by_id(_config["research_projects"])
	_phase = "WEEK_PLANNING"
	_week = 1
	_planned_activity_ids.clear()
	_last_week_result.clear()
	_competencies = (_config["starting_state"]["competencies"] as Dictionary).duplicate(true)
	_fatigue = int(_config["starting_state"].get("fatigue", 0))
	_institution_support = int(_config["starting_state"].get("institution_support", 0))
	_residual_data = int(_config["starting_state"].get("residual_data", 0))
	_companion_trust = (_config["starting_state"].get("companion_trust", {}) as Dictionary).duplicate(true)
	_research_progress.clear()
	for project_id in _research_projects.keys():
		_research_progress[String(project_id)] = 0
	_completed_research_ids.clear()
	_unlocked_module_ids.clear()
	_unlocked_skill_ids.clear()
	_selected_companion_id = ""
	_selected_public_skill_id = ""
	_equipped_module_ids.clear()
	_deployment_risk = 0
	_forced_deployment = false
	_incident_result.clear()
	_manual_delta.clear()
	_support_log.clear()
	_quarter_summary.clear()
	_run_seed = run_seed
	_refresh_institution_unlocks()
	return _response(true, "", true, [{"event": "annual_mvp_001_started"}])


func get_snapshot() -> Dictionary:
	return {
		"phase": _phase,
		"week": _week,
		"planned_activity_ids": _planned_activity_ids.duplicate(),
		"last_week_result": _last_week_result.duplicate(true),
		"competencies": _competencies.duplicate(true),
		"fatigue": _fatigue,
		"institution_support": _institution_support,
		"residual_data": _residual_data,
		"companion_trust": _companion_trust.duplicate(true),
		"research_progress": _research_progress.duplicate(true),
		"completed_research_ids": _completed_research_ids.duplicate(),
		"unlocked_module_ids": _unlocked_module_ids.duplicate(),
		"unlocked_skill_ids": _unlocked_skill_ids.duplicate(),
		"selected_companion_id": _selected_companion_id,
		"selected_public_skill_id": _selected_public_skill_id,
		"equipped_module_ids": _equipped_module_ids.duplicate(),
		"deployment_risk": _deployment_risk,
		"forced_deployment": _forced_deployment,
		"incident_result": _incident_result.duplicate(true),
		"manual_delta": _manual_delta.duplicate(true),
		"support_log": _support_log.duplicate(true),
		"quarter_summary": _quarter_summary.duplicate(true),
		"run_seed": _run_seed
	}


func commit_week(activity_ids: Array[String]) -> Dictionary:
	if _phase != "WEEK_PLANNING":
		return _response(false, "현재 단계에서는 주간 계획을 확정할 수 없다.", false)
	var slots := int((_config.get("campaign", {}) as Dictionary).get("slots_per_week", 0))
	if activity_ids.size() != slots:
		return _response(false, "정확히 %d개 활동이 필요하다." % slots, false)
	for activity_id in activity_ids:
		if not _activities.has(activity_id):
			return _response(false, "알 수 없는 활동: %s" % activity_id, false)

	var before := get_snapshot()
	_planned_activity_ids = activity_ids.duplicate()
	var slot_results: Array[Dictionary] = []
	for activity_id in activity_ids:
		var activity := _activities[activity_id] as Dictionary
		var deltas := activity.get("deltas", {}) as Dictionary
		var slot_start_fatigue := _fatigue
		var applied: Dictionary = {
			"activity_id": activity_id,
			"competencies": {},
			"fatigue": 0,
			"institution_support": 0,
			"research_progress": {},
			"companion_trust": {}
		}
		var competency_deltas := deltas.get("competencies", {}) as Dictionary
		for competency_id in competency_deltas.keys():
			var requested := int(competency_deltas[competency_id])
			var effective := requested
			if requested > 0 and slot_start_fatigue >= 60:
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
			var new_progress := max(0, old_progress + int((deltas.get("research_progress", {}) as Dictionary)[project_id]))
			_research_progress[project_id] = new_progress
			(applied["research_progress"] as Dictionary)[project_id] = new_progress - old_progress

		for companion_id in (deltas.get("companion_trust", {}) as Dictionary).keys():
			var old_trust := int(_companion_trust.get(companion_id, 0))
			var new_trust: int = clampi(old_trust + int((deltas.get("companion_trust", {}) as Dictionary)[companion_id]), 0, 3)
			_companion_trust[companion_id] = new_trust
			(applied["companion_trust"] as Dictionary)[companion_id] = new_trust - old_trust
		slot_results.append(applied)

	_refresh_institution_unlocks()
	_last_week_result = {
		"week": _week,
		"activity_ids": activity_ids.duplicate(),
		"slot_results": slot_results,
		"before": _summary_values(before),
		"after": _summary_values(get_snapshot())
	}
	_phase = "WEEK_RESULT"
	return _response(true, "", true, [{"event": "annual_week_committed", "week": _week}])


func acknowledge_week_result() -> Dictionary:
	if _phase != "WEEK_RESULT":
		return _response(false, "확인할 주간 결과가 없다.", false)
	var max_weeks := int((_config.get("campaign", {}) as Dictionary).get("max_weeks", 3))
	if _week == 1:
		_week = 2
		_phase = "WEEK_PLANNING"
	elif _week <= max_weeks:
		_phase = "DEPLOYMENT_DECISION"
	else:
		return _response(false, "주차 범위를 벗어났다.", false)
	_planned_activity_ids.clear()
	return _response(true, "", true)


func choose_deployment_decision(decision_id: String) -> Dictionary:
	if _phase != "DEPLOYMENT_DECISION":
		return _response(false, "현재 단계에서는 출동을 결정할 수 없다.", false)
	if decision_id not in ["annual001_decision_deploy", "annual001_decision_delay"]:
		return _response(false, "알 수 없는 출동 결정이다.", false)
	if decision_id == "annual001_decision_deploy":
		_deployment_risk = 0 if _week == 2 else int((_config["campaign"] as Dictionary).get("week_3_entry_risk", 15))
		_phase = "PREPARATION"
		return _response(true, "", true, [{"event": "annual_deployment_selected", "forced": false}])
	if _week == 2:
		_week = 3
		_phase = "WEEK_PLANNING"
		_planned_activity_ids.clear()
		return _response(true, "", true, [{"event": "annual_deployment_delayed", "week": 3}])
	_deployment_risk = int((_config["campaign"] as Dictionary).get("forced_entry_risk", 30))
	_forced_deployment = true
	_phase = "PREPARATION"
	return _response(true, "", true, [{"event": "annual_forced_deployment"}])


func complete_research_project(project_id: String) -> Dictionary:
	if not _research_projects.has(project_id):
		return _response(false, "연구 프로젝트를 찾을 수 없다.", false)
	if _completed_research_ids.has(project_id):
		return _response(true, "", false)
	var project := _research_projects[project_id] as Dictionary
	var timing := String(project.get("timing", ""))
	if timing == "pre_incident":
		if _phase != "PREPARATION":
			return _response(false, "이 연구는 출동 준비 중에만 완료할 수 있다.", false)
		if int(_research_progress.get(project_id, 0)) < int(project.get("progress_required", 0)):
			return _response(false, "연구 진척도가 부족하다.", false)
	elif timing == "post_incident":
		if _phase != "POST_INCIDENT_RESEARCH":
			return _response(false, "이 연구는 사건 결과 뒤에만 완료할 수 있다.", false)
		var required_status := String(project.get("required_manual_status", ""))
		if not required_status.is_empty() and String(_manual_delta.get("status", "")) != required_status:
			return _response(false, "괴이 매뉴얼 검증 상태가 부족하다.", false)
		var cost := int(project.get("residual_data_cost", 0))
		if _residual_data < cost:
			return _response(false, "잔향 자료가 부족하다.", false)
		_residual_data -= cost
	else:
		return _response(false, "연구 시점을 해석할 수 없다.", false)

	_completed_research_ids.append(project_id)
	for module_id in project.get("unlock_module_ids", []) as Array:
		_append_unique(_unlocked_module_ids, String(module_id))
	for skill_id in project.get("unlock_skill_ids", []) as Array:
		_append_unique(_unlocked_skill_ids, String(skill_id))
	if timing == "post_incident":
		_build_quarter_summary()
		_phase = "QUARTER_SUMMARY"
	return _response(true, "", true, [{"event": "annual_research_completed", "project_id": project_id}])


func configure_loadout(companion_id: String, public_skill_id: String, module_ids: Array[String]) -> Dictionary:
	if _phase != "PREPARATION":
		return _response(false, "현재 단계에서는 출동 구성을 변경할 수 없다.", false)
	if not _companions.has(companion_id) or companion_id != "annual001_companion_oh_hyun":
		return _response(false, "오현만 이 수직절편에 편성할 수 있다.", false)
	var companion := _companions[companion_id] as Dictionary
	if not public_skill_id.is_empty():
		if not _unlocked_skill_ids.has(public_skill_id):
			return _response(false, "해금되지 않은 공용 보조 스킬이다.", false)
		if not (companion.get("allowed_public_skill_ids", []) as Array).has(public_skill_id):
			return _response(false, "동료가 장착할 수 없는 공용 보조 스킬이다.", false)
	if module_ids.size() > 1:
		return _response(false, "모듈 슬롯은 하나다.", false)
	for module_id in module_ids:
		if not _unlocked_module_ids.has(module_id) or not _modules.has(module_id):
			return _response(false, "해금되지 않은 모듈이다.", false)
	_selected_companion_id = companion_id
	_selected_public_skill_id = public_skill_id
	_equipped_module_ids = module_ids.duplicate()
	return _response(true, "", true, [{"event": "annual_loadout_configured"}])


func begin_incident() -> Dictionary:
	if _phase != "PREPARATION":
		return _response(false, "사건을 시작할 준비가 되지 않았다.", false)
	if _selected_companion_id.is_empty():
		return _response(false, "동료 편성을 먼저 확정해야 한다.", false)
	_phase = "INCIDENT_ACTIVE"
	return _response(true, "", true, [{
		"event": "annual_incident_requested",
		"case_path": String((_config["campaign"] as Dictionary).get("incident_case_path", "")),
		"run_seed": _run_seed
	}])


func apply_incident_result(result: Dictionary, manual_delta: Dictionary, support_log: Array[Dictionary]) -> Dictionary:
	if _phase != "INCIDENT_ACTIVE":
		return _response(false, "사건 결과를 적용할 수 없다.", false)
	var quality := String(result.get("recovery_quality", ""))
	if quality not in ["normal_capture", "costly_capture", "emergency_capture"]:
		return _response(false, "회수 품질을 해석할 수 없다.", false)
	_incident_result = result.duplicate(true)
	_manual_delta = manual_delta.duplicate(true)
	_support_log = support_log.duplicate(true)
	match quality:
		"normal_capture":
			_residual_data += 2
			_institution_support = clampi(_institution_support + 1, 0, 3)
		"costly_capture":
			_residual_data += 1
		"emergency_capture":
			_residual_data += 1
			_institution_support = clampi(_institution_support - 1, 0, 3)
	_phase = "INCIDENT_RESULT"
	return _response(true, "", true, [{"event": "annual_incident_result_applied", "recovery_quality": quality}])


func advance_from_incident_result() -> Dictionary:
	if _phase != "INCIDENT_RESULT":
		return _response(false, "사건 결과 단계가 아니다.", false)
	_phase = "POST_INCIDENT_RESEARCH"
	return _response(true, "", true)


func skip_post_incident_research() -> Dictionary:
	if _phase != "POST_INCIDENT_RESEARCH":
		return _response(false, "건너뛸 사후 연구 단계가 아니다.", false)
	_build_quarter_summary()
	_phase = "QUARTER_SUMMARY"
	return _response(true, "", true, [{"event": "annual_post_research_skipped"}])


func confirm_quarter_summary() -> Dictionary:
	if _phase != "QUARTER_SUMMARY":
		return _response(false, "확인할 분기 결산이 없다.", false)
	_phase = "COMPLETE"
	return _response(true, "", true, [{"event": "annual_mvp_001_completed"}])


func build_save_payload() -> Dictionary:
	if _phase in ["BOOT", "INCIDENT_ACTIVE"]:
		return {}
	return {
		"save_version": "annual-mvp-001-save-v1",
		"state": get_snapshot()
	}


func restore(config: Dictionary, payload: Dictionary) -> Dictionary:
	if String(payload.get("save_version", "")) != "annual-mvp-001-save-v1":
		return _response(false, "지원하지 않는 연도제 저장 버전이다.", false)
	var saved_value: Variant = payload.get("state")
	if typeof(saved_value) != TYPE_DICTIONARY:
		return _response(false, "연도제 저장 상태가 없다.", false)
	var saved := saved_value as Dictionary
	var saved_phase := String(saved.get("phase", ""))
	var allowed_phases := [
		"WEEK_PLANNING", "WEEK_RESULT", "DEPLOYMENT_DECISION", "PREPARATION",
		"INCIDENT_RESULT", "POST_INCIDENT_RESEARCH", "QUARTER_SUMMARY", "COMPLETE"
	]
	if not allowed_phases.has(saved_phase):
		return _response(false, "저장할 수 없는 연도제 단계다.", false)
	var started := start(config, int(saved.get("run_seed", 2001)))
	if not bool(started.get("ok", false)):
		return started
	_phase = saved_phase
	_week = int(saved.get("week", 1))
	_planned_activity_ids = _string_array(saved.get("planned_activity_ids", []))
	_last_week_result = (saved.get("last_week_result", {}) as Dictionary).duplicate(true)
	_competencies = (saved.get("competencies", {}) as Dictionary).duplicate(true)
	_fatigue = clampi(int(saved.get("fatigue", 0)), 0, 100)
	_institution_support = clampi(int(saved.get("institution_support", 0)), 0, 3)
	_residual_data = maxi(0, int(saved.get("residual_data", 0)))
	_companion_trust = (saved.get("companion_trust", {}) as Dictionary).duplicate(true)
	_research_progress = (saved.get("research_progress", {}) as Dictionary).duplicate(true)
	_completed_research_ids = _string_array(saved.get("completed_research_ids", []))
	_unlocked_module_ids = _string_array(saved.get("unlocked_module_ids", []))
	_unlocked_skill_ids = _string_array(saved.get("unlocked_skill_ids", []))
	_selected_companion_id = String(saved.get("selected_companion_id", ""))
	_selected_public_skill_id = String(saved.get("selected_public_skill_id", ""))
	_equipped_module_ids = _string_array(saved.get("equipped_module_ids", []))
	_deployment_risk = clampi(int(saved.get("deployment_risk", 0)), 0, 100)
	_forced_deployment = bool(saved.get("forced_deployment", false))
	_incident_result = (saved.get("incident_result", {}) as Dictionary).duplicate(true)
	_manual_delta = (saved.get("manual_delta", {}) as Dictionary).duplicate(true)
	_support_log = _dictionary_array(saved.get("support_log", []))
	_quarter_summary = (saved.get("quarter_summary", {}) as Dictionary).duplicate(true)
	_run_seed = int(saved.get("run_seed", 2001))
	_refresh_institution_unlocks()
	return _response(true, "", true, [{"event": "annual_mvp_001_restored"}])


func _string_array(value: Variant) -> Array[String]:
	var result: Array[String] = []
	if typeof(value) != TYPE_ARRAY:
		return result
	for item in value as Array:
		result.append(String(item))
	return result


func _dictionary_array(value: Variant) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if typeof(value) != TYPE_ARRAY:
		return result
	for item in value as Array:
		if typeof(item) == TYPE_DICTIONARY:
			result.append((item as Dictionary).duplicate(true))
	return result


func _refresh_institution_unlocks() -> void:
	for value in _config.get("support_skills", []) as Array:
		var skill := value as Dictionary
		var unlock := skill.get("unlock", {}) as Dictionary
		if int(unlock.get("institution_support_min", 999)) <= _institution_support:
			_append_unique(_unlocked_skill_ids, String(skill.get("id", "")))


func _build_quarter_summary() -> void:
	var flags: Array[String] = []
	if _unlocked_module_ids.has("annual001_module_signal_buffer"):
		flags.append("annual001_flag_signal_module_known")
	if _unlocked_skill_ids.has("annual001_skill_signal_cross_check"):
		flags.append("annual001_flag_ticket_protocol_known")
	if _forced_deployment:
		flags.append("annual001_flag_emergency_deployment")
	var manual_status := String(_manual_delta.get("status", "unknown"))
	if manual_status == "candidate":
		flags.append("annual001_flag_manual_candidate")
	elif manual_status == "verified":
		flags.append("annual001_flag_manual_verified")
	_quarter_summary = {
		"weeks_used": _week,
		"forced_deployment": _forced_deployment,
		"competency_focus": _highest_competency(),
		"fatigue_band": _fatigue_band(),
		"companion_trust": _companion_trust.duplicate(true),
		"recovery_quality": String(_incident_result.get("recovery_quality", "unknown")),
		"knowledge_quality": manual_status,
		"danger_case_count": (_manual_delta.get("danger_cases", []) as Array).size(),
		"support_trigger_count": _support_log.size(),
		"completed_research_ids": _completed_research_ids.duplicate(),
		"unlocked_module_ids": _unlocked_module_ids.duplicate(),
		"unlocked_skill_ids": _unlocked_skill_ids.duplicate(),
		"next_cycle_flags": flags
	}


func _highest_competency() -> String:
	var best_id := "observation"
	var best_value := -1
	for competency_id in ["observation", "analysis", "field_response", "interpersonal"]:
		var value := int(_competencies.get(competency_id, 0))
		if value > best_value:
			best_id = competency_id
			best_value = value
	return best_id


func _fatigue_band() -> String:
	if _fatigue <= 30:
		return "stable"
	if _fatigue <= 60:
		return "strained"
	return "exhausted"


func _summary_values(snapshot: Dictionary) -> Dictionary:
	return {
		"competencies": (snapshot.get("competencies", {}) as Dictionary).duplicate(true),
		"fatigue": int(snapshot.get("fatigue", 0)),
		"institution_support": int(snapshot.get("institution_support", 0)),
		"companion_trust": (snapshot.get("companion_trust", {}) as Dictionary).duplicate(true),
		"research_progress": (snapshot.get("research_progress", {}) as Dictionary).duplicate(true)
	}


func _append_unique(target: Array[String], value: String) -> void:
	if not value.is_empty() and not target.has(value):
		target.append(value)


func _response(ok: bool, error: String, state_changed: bool, events: Array = []) -> Dictionary:
	return {
		"ok": ok,
		"error": error,
		"state_changed": state_changed,
		"events": events.duplicate(true),
		"snapshot": get_snapshot()
	}
