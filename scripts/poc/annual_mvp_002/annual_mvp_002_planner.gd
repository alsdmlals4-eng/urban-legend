class_name AnnualMvp002Planner
extends RefCounted

var _activities: Dictionary = {}
var _days_per_week := 7
var _plan: Array[String] = []
var _undo_plan: Array[String] = []
var _undo_available := false
var _templates: Array = [[], [], []]


func configure(activities: Array[Dictionary], days_per_week: int = 7) -> Dictionary:
	if days_per_week <= 0:
		return _response(false, "주간 일수는 양수여야 합니다.", false)
	var indexed: Dictionary = {}
	for activity in activities:
		var activity_id := String(activity.get("id", ""))
		var day_cost := int(activity.get("day_cost", 0))
		if activity_id.is_empty() or indexed.has(activity_id):
			return _response(false, "활동 ID가 비어 있거나 중복되었습니다.", false)
		if day_cost < 1 or day_cost > days_per_week:
			return _response(false, "활동 %s의 일수 계약이 잘못되었습니다." % activity_id, false)
		indexed[activity_id] = activity.duplicate(true)
	var had_configuration := not _activities.is_empty()
	var preserved_templates: Array = []
	if had_configuration:
		for template in _templates:
			preserved_templates.append(_strings(template as Array))
	_activities = indexed
	_days_per_week = days_per_week
	_plan.clear()
	_undo_plan.clear()
	_undo_available = false
	if had_configuration:
		_templates = preserved_templates
	else:
		_templates = [[], [], []]
	return _response(true, "", true)


func set_plan(activity_ids: Array[String]) -> Dictionary:
	var validation := _validate_plan(activity_ids)
	if not bool(validation.get("ok", false)):
		return _response(false, String(validation.get("error", "일정을 적용할 수 없습니다.")), false)
	_push_undo()
	_plan = activity_ids.duplicate()
	return _response(true, "", true)


func append_activity(activity_id: String) -> Dictionary:
	var candidate := _plan.duplicate()
	candidate.append(activity_id)
	var validation := _validate_plan(candidate)
	if not bool(validation.get("ok", false)):
		return _response(false, String(validation.get("error", "일정을 추가할 수 없습니다.")), false)
	_push_undo()
	_plan = candidate
	return _response(true, "", true)


func undo() -> Dictionary:
	if not _undo_available:
		return _response(false, "되돌릴 마지막 편성 변경이 없습니다.", false)
	_plan = _undo_plan.duplicate()
	_undo_plan.clear()
	_undo_available = false
	return _response(true, "", true)


func clear() -> Dictionary:
	if _plan.is_empty():
		return _response(false, "초기화할 일정이 없습니다.", false)
	_push_undo()
	_plan.clear()
	return _response(true, "", true)


func copy_last_week(last_week_result: Dictionary) -> Dictionary:
	var values: Variant = last_week_result.get("planned_activity_ids")
	if typeof(values) != TYPE_ARRAY:
		return _response(false, "지난주 정본 일정이 없습니다.", false)
	return set_plan(_strings(values as Array))


func save_template(slot: int) -> Dictionary:
	var index := slot - 1
	if index < 0 or index >= 3:
		return _response(false, "일정 템플릿 슬롯은 1~3입니다.", false)
	_templates[index] = _plan.duplicate()
	return _response(true, "", true)


func apply_template(slot: int) -> Dictionary:
	var index := slot - 1
	if index < 0 or index >= 3:
		return _response(false, "일정 템플릿 슬롯은 1~3입니다.", false)
	var template := _strings(_templates[index] as Array)
	return set_plan(template)


func preview() -> Dictionary:
	var aggregate := {
		"fatigue": 0,
		"competencies": {},
		"institution_support": 0,
		"research_progress": {},
		"companion_trust": {},
	}
	var lines: Array[Dictionary] = []
	var used_days := 0
	for activity_id in _plan:
		var activity := _activities.get(activity_id, {}) as Dictionary
		var day_cost := int(activity.get("day_cost", 0))
		var deltas := activity.get("deltas", {}) as Dictionary
		used_days += day_cost
		aggregate["fatigue"] = int(aggregate.get("fatigue", 0)) + int(deltas.get("fatigue", 0))
		aggregate["institution_support"] = int(aggregate.get("institution_support", 0)) + int(deltas.get("institution_support", 0))
		_merge_numeric_dictionary(aggregate["competencies"] as Dictionary, deltas.get("competencies", {}) as Dictionary)
		_merge_numeric_dictionary(aggregate["research_progress"] as Dictionary, deltas.get("research_progress", {}) as Dictionary)
		_merge_numeric_dictionary(aggregate["companion_trust"] as Dictionary, deltas.get("companion_trust", {}) as Dictionary)
		lines.append({
			"activity_id": activity_id,
			"name": String(activity.get("name", activity_id)),
			"day_cost": day_cost,
			"deltas": deltas.duplicate(true),
		})
	return {
		"ok": true,
		"activity_ids": _plan.duplicate(),
		"used_days": used_days,
		"remaining_days": maxi(0, _days_per_week - used_days),
		"aggregate": aggregate,
		"lines": lines,
	}


func get_snapshot() -> Dictionary:
	var templates_copy: Array = []
	for template in _templates:
		templates_copy.append(_strings(template as Array))
	return {
		"days_per_week": _days_per_week,
		"activity_ids": _plan.duplicate(),
		"undo_activity_ids": _undo_plan.duplicate(),
		"undo_available": _undo_available,
		"templates": templates_copy,
	}


func restore(snapshot: Dictionary) -> Dictionary:
	var days_per_week := int(snapshot.get("days_per_week", 0))
	if days_per_week != _days_per_week:
		return _response(false, "저장된 주간 일수 계약이 현재 계약과 다릅니다.", false)
	var activity_ids_value: Variant = snapshot.get("activity_ids")
	var undo_value: Variant = snapshot.get("undo_activity_ids")
	var templates_value: Variant = snapshot.get("templates")
	if typeof(activity_ids_value) != TYPE_ARRAY or typeof(undo_value) != TYPE_ARRAY or typeof(templates_value) != TYPE_ARRAY:
		return _response(false, "일정 편성 저장 형식이 잘못되었습니다.", false)
	var templates_array := templates_value as Array
	if templates_array.size() != 3:
		return _response(false, "일정 템플릿은 정확히 3개여야 합니다.", false)
	var restored_plan := _strings(activity_ids_value as Array)
	var restored_undo := _strings(undo_value as Array)
	var plan_validation := _validate_plan(restored_plan)
	var undo_validation := _validate_plan(restored_undo)
	if not bool(plan_validation.get("ok", false)) or not bool(undo_validation.get("ok", false)):
		return _response(false, "저장된 일정에 현재 사용할 수 없는 활동이 있습니다.", false)
	var restored_templates: Array = []
	for template_value in templates_array:
		if typeof(template_value) != TYPE_ARRAY:
			return _response(false, "일정 템플릿 형식이 잘못되었습니다.", false)
		var template := _strings(template_value as Array)
		var validation := _validate_plan(template)
		if not bool(validation.get("ok", false)):
			return _response(false, "저장된 템플릿에 현재 사용할 수 없는 활동이 있습니다.", false)
		restored_templates.append(template)
	_plan = restored_plan
	_undo_plan = restored_undo
	_undo_available = bool(snapshot.get("undo_available", false))
	_templates = restored_templates
	return _response(true, "", true)


func _validate_plan(activity_ids: Array[String]) -> Dictionary:
	var used_days := 0
	for activity_id in activity_ids:
		if not _activities.has(activity_id):
			return {"ok": false, "error": "알 수 없는 활동: %s" % activity_id}
		used_days += int((_activities[activity_id] as Dictionary).get("day_cost", 0))
		if used_days > _days_per_week:
			return {"ok": false, "error": "일정은 한 주 %d일을 넘을 수 없습니다." % _days_per_week}
	return {"ok": true, "used_days": used_days}


func _push_undo() -> void:
	_undo_plan = _plan.duplicate()
	_undo_available = true


func _merge_numeric_dictionary(target: Dictionary, source: Dictionary) -> void:
	for key in source.keys():
		target[key] = int(target.get(key, 0)) + int(source[key])


func _strings(values: Array) -> Array[String]:
	var result: Array[String] = []
	for value in values:
		result.append(String(value))
	return result


func _response(ok: bool, error: String, state_changed: bool) -> Dictionary:
	return {
		"ok": ok,
		"error": error,
		"state_changed": state_changed,
		"snapshot": get_snapshot(),
	}
