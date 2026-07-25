class_name AnnualMvp001IncidentAdapter
extends RefCounted

const AnnualData = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_data.gd")
const SupportResolver = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_support_resolver.gd")

const ANALYSIS_NOTE := "전광판 변동 기록과 방송 원본의 불일치 항목을 분리해 비교할 수 있다."

var _config: Dictionary = {}
var _annual_snapshot: Dictionary = {}
var _run_seed := 2001
var _skills: Dictionary = {}
var _resolver := SupportResolver.new()
var _support_log: Array[Dictionary] = []


func configure(config: Dictionary, annual_snapshot: Dictionary, run_seed: int) -> Dictionary:
	var errors := AnnualData.validate_config(config)
	if not errors.is_empty():
		return {"ok": false, "error": "; ".join(errors)}
	_config = config.duplicate(true)
	_annual_snapshot = annual_snapshot.duplicate(true)
	_run_seed = run_seed
	_skills = AnnualData.index_by_id(_config.get("support_skills", []) as Array)
	_support_log.clear()
	var equipped: Array[Dictionary] = []
	var companion_id := String(_annual_snapshot.get("selected_companion_id", ""))
	var companions := AnnualData.index_by_id(_config.get("companions", []) as Array)
	if companions.has(companion_id):
		var companion := companions[companion_id] as Dictionary
		var unique_id := String(companion.get("unique_skill_id", ""))
		if _skills.has(unique_id):
			equipped.append((_skills[unique_id] as Dictionary).duplicate(true))
	var public_id := String(_annual_snapshot.get("selected_public_skill_id", ""))
	if not public_id.is_empty() and _skills.has(public_id):
		equipped.append((_skills[public_id] as Dictionary).duplicate(true))
	if equipped.is_empty():
		return {"ok": false, "error": "사건 지원 스킬이 구성되지 않았다."}
	var trust := int((_annual_snapshot.get("companion_trust", {}) as Dictionary).get(companion_id, 0))
	var interpersonal := int((_annual_snapshot.get("competencies", {}) as Dictionary).get("interpersonal", 0))
	var started := _resolver.start(equipped, trust, interpersonal, run_seed)
	return {"ok": bool(started.get("ok", false)), "error": String(started.get("error", ""))}


func build_case_override(base_case: Dictionary) -> Dictionary:
	var result := base_case.duplicate(true)
	var competencies := _annual_snapshot.get("competencies", {}) as Dictionary
	var fatigue := int(_annual_snapshot.get("fatigue", 0))
	var starting_health := 100
	if fatigue >= 81:
		starting_health = 75
	elif fatigue >= 71:
		starting_health = 80
	elif fatigue >= 61:
		starting_health = 85
	elif fatigue >= 51:
		starting_health = 90
	elif fatigue >= 41:
		starting_health = 95
	var case_info := result.get("case", {}) as Dictionary
	case_info["starting_health"] = starting_health
	case_info["starting_risk"] = clampi(
		int(case_info.get("starting_risk", 0)) + int(_annual_snapshot.get("deployment_risk", 0)),
		0,
		100
	)
	result["case"] = case_info

	if int(competencies.get("observation", 0)) >= 2:
		var understanding := result.get("understanding", {}) as Dictionary
		var rates := understanding.get("omen_read_rates", {}) as Dictionary
		rates["clue"] = mini(100, int(rates.get("clue", 0)) + 10)
		rates["likely"] = mini(90, int(rates.get("likely", 0)) + 10)
		understanding["omen_read_rates"] = rates
		result["understanding"] = understanding

	if int(competencies.get("field_response", 0)) >= 2:
		for value in result.get("field_tests", []) as Array:
			var field_test := value as Dictionary
			field_test["damage"] = maxi(0, int(field_test.get("damage", 0)) - 4)
		for value in result.get("recovery_patterns", []) as Array:
			var pattern := value as Dictionary
			if pattern.has("damage_on_failure"):
				pattern["damage_on_failure"] = maxi(0, int(pattern.get("damage_on_failure", 0)) - 4)

	if (_annual_snapshot.get("equipped_module_ids", []) as Array).has("annual001_module_signal_buffer"):
		for value in result.get("recovery_patterns", []) as Array:
			var pattern := value as Dictionary
			if bool(pattern.get("first_use_hidden", false)):
				pattern["max_first_observation_damage"] = 12

	var notes: Array[String] = []
	if int(competencies.get("analysis", 0)) >= 2:
		notes.append(ANALYSIS_NOTE)
	result["annual_analysis_notes"] = notes
	return result


func after_omen(state: Object, snapshot_before: Dictionary, omen_result: Dictionary) -> Array[Dictionary]:
	var event_key := "omen:%d:%s" % [
		int(snapshot_before.get("turn", 0)),
		String(snapshot_before.get("current_pattern_id", ""))
	]
	return _resolve_and_apply(state, event_key, {
		"event": "omen_read",
		"success": bool(omen_result.get("success", false))
	}, snapshot_before)


func after_recovery_action(
	state: Object,
	snapshot_before: Dictionary,
	action_id: String,
	action_result: Dictionary
) -> Array[Dictionary]:
	var pattern_id := String(snapshot_before.get("current_pattern_id", ""))
	var before_observed := snapshot_before.get("observed_pattern_ids", []) as Array
	var after_snapshot := action_result.get("snapshot", {}) as Dictionary
	var after_observed := after_snapshot.get("observed_pattern_ids", []) as Array
	var first_hidden := not before_observed.has(pattern_id) and after_observed.has(pattern_id)
	var event_key := "action:%d:%s:%s" % [
		int(snapshot_before.get("turn", 0)),
		pattern_id,
		action_id
	]
	return _resolve_and_apply(state, event_key, {
		"event": "recovery_action_resolved",
		"damage": int(action_result.get("damage", 0)),
		"first_hidden": first_hidden
	}, snapshot_before)


func get_status_lines() -> Array[String]:
	var lines: Array[String] = []
	var snapshot := _resolver.get_snapshot()
	for value in snapshot.get("skill_status", []) as Array:
		var status := value as Dictionary
		var skill_id := String(status.get("skill_id", ""))
		var skill := _skills.get(skill_id, {}) as Dictionary
		var owner := "오현" if String(skill.get("type", "")) == "unique" else "공용"
		lines.append("%s · %s | 조건: %s | 확률 %d%% | 준비도 %d/%d | 남은 %d회" % [
			owner,
			String(status.get("skill_name", skill_id)),
			String(status.get("trigger_label", status.get("trigger", ""))),
			int(status.get("chance", 0)),
			int(status.get("readiness", 0)),
			int(status.get("readiness_max", 100)),
			int(status.get("remaining_uses", 0))
		])
	return lines


func get_support_log() -> Array[Dictionary]:
	return _support_log.duplicate(true)


func build_annual_reward(result: Dictionary, manual_delta: Dictionary) -> Dictionary:
	var quality := String(result.get("recovery_quality", "pending"))
	var residual_gain := 0
	var institution_delta := 0
	match quality:
		"normal_capture":
			residual_gain = 2
			institution_delta = 1
		"costly_capture":
			residual_gain = 1
		"emergency_capture":
			residual_gain = 1
			institution_delta = -1
	return {
		"recovery_quality": quality,
		"knowledge_quality": String(manual_delta.get("status", "candidate")),
		"residual_data_gain": residual_gain,
		"institution_support_delta": institution_delta,
		"danger_case_count": (manual_delta.get("danger_cases", []) as Array).size()
	}


func _resolve_and_apply(
	state: Object,
	event_key: String,
	context: Dictionary,
	snapshot_before: Dictionary
) -> Array[Dictionary]:
	var decisions: Array[Dictionary] = _resolver.resolve(event_key, context)
	for decision in decisions:
		if not bool(decision.get("triggered", false)):
			continue
		var effect := decision.get("effect", {}) as Dictionary
		var applied: Dictionary = state.call(
			"apply_external_support",
			String(decision.get("skill_id", "")),
			event_key,
			effect
		)
		if not bool(applied.get("ok", false)) or not bool(applied.get("state_changed", false)):
			continue
		var entry := {
			"skill_id": String(decision.get("skill_id", "")),
			"skill_name": String(decision.get("skill_name", decision.get("skill_id", ""))),
			"turn": int(snapshot_before.get("turn", 0)),
			"pattern_id": String(snapshot_before.get("current_pattern_id", "")),
			"event_key": event_key,
			"chance": int(decision.get("chance", 0)),
			"roll": int(decision.get("roll", 0)),
			"readiness_before": int(decision.get("readiness_before", 0)),
			"readiness_after": int(decision.get("readiness_after", 0)),
			"guaranteed": bool(decision.get("guaranteed", false)),
			"triggered": true,
			"effect": effect.duplicate(true)
		}
		_support_log.append(entry)
	return decisions
