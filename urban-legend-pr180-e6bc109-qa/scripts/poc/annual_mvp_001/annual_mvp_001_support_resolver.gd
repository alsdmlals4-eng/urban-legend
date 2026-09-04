class_name AnnualMvp001SupportResolver
extends RefCounted

var _skill_entries: Array[Dictionary] = []
var _skills: Dictionary = {}
var _readiness: Dictionary = {}
var _use_counts: Dictionary = {}
var _event_cache: Dictionary = {}
var _trust := 0
var _interpersonal := 0
var _run_seed := 2001
var _rng := RandomNumberGenerator.new()
var _test_rolls: Array[int] = []
var _test_roll_index := 0
var _signature_guarantee_used := false


func start(
	skill_entries: Array[Dictionary],
	trust: int,
	interpersonal: int,
	run_seed: int,
	test_rolls: Array[int] = []
) -> Dictionary:
	if skill_entries.is_empty():
		return _response(false, "보조 스킬이 하나 이상 필요하다.", false)
	var ids: Array[String] = []
	for skill in skill_entries:
		var skill_id := String(skill.get("id", ""))
		if skill_id.is_empty() or ids.has(skill_id):
			return _response(false, "보조 스킬 ID가 비어 있거나 중복됐다.", false)
		if int(skill.get("base_chance", -1)) < 0 or int(skill.get("base_chance", -1)) > 100:
			return _response(false, "보조 스킬 확률 범위가 잘못됐다.", false)
		ids.append(skill_id)
	_skill_entries.clear()
	_skills.clear()
	_readiness.clear()
	_use_counts.clear()
	_event_cache.clear()
	for skill in skill_entries:
		var copy := skill.duplicate(true) as Dictionary
		var skill_id := String(copy["id"])
		_skill_entries.append(copy)
		_skills[skill_id] = copy
		_readiness[skill_id] = 0
		_use_counts[skill_id] = 0
	_trust = clampi(trust, 0, 3)
	_interpersonal = clampi(interpersonal, 0, 5)
	_run_seed = run_seed
	_rng.seed = run_seed
	_test_rolls = test_rolls.duplicate()
	_test_roll_index = 0
	_signature_guarantee_used = false
	return _response(true, "", true)


func resolve(event_key: String, context: Dictionary) -> Array[Dictionary]:
	if event_key.is_empty():
		return []
	if _event_cache.has(event_key):
		return (_event_cache[event_key] as Array).duplicate(true)
	var results: Array[Dictionary] = []
	for skill in _skill_entries:
		var skill_id := String(skill.get("id", ""))
		if not _is_eligible(skill, context):
			continue
		var battle_limit := int(skill.get("battle_limit", 0))
		if int(_use_counts.get(skill_id, 0)) >= battle_limit:
			continue
		var readiness_before := int(_readiness.get(skill_id, 0))
		var readiness_max := int(skill.get("readiness_max", 100))
		var chance := _current_chance(skill, readiness_before)
		var signature_guarantee := (
			String(skill.get("type", "")) == "unique"
			and _trust >= 2
			and not _signature_guarantee_used
		)
		var readiness_guarantee := readiness_before >= readiness_max
		var guaranteed := signature_guarantee or readiness_guarantee
		var roll := 0
		if not guaranteed:
			roll = _next_roll()
		var triggered := guaranteed or roll <= chance
		var readiness_after := readiness_before
		if triggered:
			readiness_after = 0
			_readiness[skill_id] = 0
			_use_counts[skill_id] = int(_use_counts.get(skill_id, 0)) + 1
			if signature_guarantee:
				_signature_guarantee_used = true
		else:
			readiness_after = mini(readiness_max, readiness_before + int(skill.get("readiness_gain", 0)))
			_readiness[skill_id] = readiness_after
		results.append({
			"skill_id": skill_id,
			"skill_name": String(skill.get("name", skill_id)),
			"eligible": true,
			"triggered": triggered,
			"chance": chance,
			"roll": roll,
			"readiness_before": readiness_before,
			"readiness_after": readiness_after,
			"guaranteed": guaranteed,
			"effect": (skill.get("effect", {}) as Dictionary).duplicate(true),
			"event_key": event_key
		})
	if not results.is_empty():
		_event_cache[event_key] = results.duplicate(true)
	return results


func get_snapshot() -> Dictionary:
	var status: Array[Dictionary] = []
	for skill in _skill_entries:
		var skill_id := String(skill.get("id", ""))
		var readiness_value := int(_readiness.get(skill_id, 0))
		var limit := int(skill.get("battle_limit", 0))
		var used := int(_use_counts.get(skill_id, 0))
		status.append({
			"skill_id": skill_id,
			"skill_name": String(skill.get("name", skill_id)),
			"trigger": String(skill.get("trigger", "")),
			"trigger_label": String(skill.get("trigger_label", skill.get("trigger", ""))),
			"chance": _current_chance(skill, readiness_value),
			"readiness": readiness_value,
			"readiness_max": int(skill.get("readiness_max", 100)),
			"uses": used,
			"battle_limit": limit,
			"remaining_uses": maxi(0, limit - used)
		})
	return {
		"run_seed": _run_seed,
		"trust": _trust,
		"interpersonal": _interpersonal,
		"readiness": _readiness.duplicate(true),
		"use_counts": _use_counts.duplicate(true),
		"signature_guarantee_used": _signature_guarantee_used,
		"cached_results": _event_cache.duplicate(true),
		"skill_status": status
	}


func _current_chance(skill: Dictionary, readiness_value: int) -> int:
	var interpersonal_bonus := 5 if _interpersonal >= 2 else 0
	return mini(100, int(skill.get("base_chance", 0)) + _trust * 5 + interpersonal_bonus + readiness_value)


func _is_eligible(skill: Dictionary, context: Dictionary) -> bool:
	match String(skill.get("trigger", "")):
		"omen_failed":
			return String(context.get("event", "")) == "omen_read" and not bool(context.get("success", true))
		"damage_at_least_12":
			return String(context.get("event", "")) == "recovery_action_resolved" and int(context.get("damage", 0)) >= 12
		"first_hidden_pattern_resolved":
			return String(context.get("event", "")) == "recovery_action_resolved" and bool(context.get("first_hidden", false))
	return false


func _next_roll() -> int:
	if _test_roll_index < _test_rolls.size():
		var value := clampi(_test_rolls[_test_roll_index], 1, 100)
		_test_roll_index += 1
		return value
	return _rng.randi_range(1, 100)


func _response(ok: bool, error: String, state_changed: bool) -> Dictionary:
	return {
		"ok": ok,
		"error": error,
		"state_changed": state_changed,
		"snapshot": get_snapshot()
	}
