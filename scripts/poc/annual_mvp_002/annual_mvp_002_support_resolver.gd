class_name AnnualMvp002SupportResolver
extends RefCounted

const FORBIDDEN_OUTPUTS := [
	"new_core_clue",
	"answer_hypothesis",
	"unobserved_pattern",
	"capture_condition",
]

var _skills: Dictionary = {}
var _ordered_skill_ids: Array[String] = []
var _companion_states: Dictionary = {}
var _preparation_tags: Array[String] = []
var _readiness_by_skill: Dictionary = {}
var _run_seed := 3001
var _test_rolls: Array[int] = []
var _roll_index := 0
var _used_unique_skills: Dictionary = {}
var _resolved_events: Dictionary = {}


func start(
	skill_entries: Array[Dictionary],
	companion_states: Dictionary,
	preparation_tags: Array[String],
	readiness_by_skill: Dictionary,
	run_seed: int,
	test_rolls: Array[int] = []
) -> Dictionary:
	_skills.clear()
	_ordered_skill_ids.clear()
	for skill in skill_entries:
		var skill_id := String(skill.get("id", ""))
		var owner_id := String(skill.get("owner_companion_id", ""))
		var kind := String(skill.get("skill_kind", ""))
		if skill_id.is_empty() or _skills.has(skill_id):
			return {"ok": false, "error": "지원 스킬 ID가 비어 있거나 중복되었습니다."}
		if owner_id.is_empty() or not companion_states.has(owner_id):
			return {"ok": false, "error": "지원 스킬 소유 동료 상태가 없습니다: %s" % owner_id}
		if kind not in ["unique", "support"]:
			return {"ok": false, "error": "지원 스킬 종류가 잘못되었습니다: %s" % skill_id}
		_skills[skill_id] = skill.duplicate(true)
		_ordered_skill_ids.append(skill_id)
	_companion_states = companion_states.duplicate(true)
	_preparation_tags = preparation_tags.duplicate()
	_readiness_by_skill.clear()
	for skill_id in _ordered_skill_ids:
		var skill := _skills[skill_id] as Dictionary
		if String(skill.get("skill_kind", "")) == "support":
			_readiness_by_skill[skill_id] = clampi(int(readiness_by_skill.get(skill_id, 0)), 0, 100)
	_run_seed = run_seed
	_test_rolls = test_rolls.duplicate()
	_roll_index = 0
	_used_unique_skills.clear()
	_resolved_events.clear()
	return {"ok": true, "error": "", "snapshot": get_snapshot()}


func preview(context: Dictionary = {}) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for skill_id in _ordered_skill_ids:
		result.append(_preview_skill(skill_id, context))
	return result


func resolve(event_key: String, context: Dictionary) -> Array[Dictionary]:
	if event_key.is_empty():
		return []
	if _resolved_events.has(event_key):
		return _dictionary_array(_resolved_events[event_key])
	var resolved: Array[Dictionary] = []
	for skill_id in _ordered_skill_ids:
		var item := _preview_skill(skill_id, context)
		var skill := _skills[skill_id] as Dictionary
		var kind := String(skill.get("skill_kind", ""))
		var readiness_before := int(_readiness_by_skill.get(skill_id, 0))
		var readiness_after := readiness_before
		var triggered := false
		var guaranteed := false
		var roll := 0
		if bool(item.get("eligible", false)):
			if kind == "unique":
				triggered = true
				guaranteed = true
				_used_unique_skills[skill_id] = true
			else:
				guaranteed = readiness_before >= int(skill.get("readiness_guarantee", 100))
				roll = _next_roll(event_key, skill_id)
				triggered = guaranteed or roll <= int(item.get("chance", 0))
				if triggered:
					readiness_after = 0
				else:
					var gain := int(skill.get("readiness_gain", 20))
					if _preparation_tags.has("annual002_research_failure_learning"):
						gain = 25
					readiness_after = mini(100, readiness_before + gain)
				_readiness_by_skill[skill_id] = readiness_after
		var record := item.duplicate(true)
		record["event_key"] = event_key
		record["triggered"] = triggered
		record["guaranteed"] = guaranteed
		record["roll"] = roll
		record["readiness_before"] = readiness_before
		record["readiness_after"] = readiness_after
		record["effect"] = (skill.get("effect", {}) as Dictionary).duplicate(true) if triggered else {}
		resolved.append(record)
	_resolved_events[event_key] = resolved.duplicate(true)
	return resolved


func get_snapshot() -> Dictionary:
	return {
		"readiness_by_skill": _readiness_by_skill.duplicate(true),
		"used_unique_skills": _used_unique_skills.duplicate(true),
		"resolved_events": _resolved_events.duplicate(true),
		"roll_index": _roll_index,
		"run_seed": _run_seed,
	}


func _preview_skill(skill_id: String, context: Dictionary) -> Dictionary:
	var skill := _skills[skill_id] as Dictionary
	var kind := String(skill.get("skill_kind", ""))
	var owner_id := String(skill.get("owner_companion_id", ""))
	var readiness := int(_readiness_by_skill.get(skill_id, 0))
	var eligibility := _eligibility(skill, context)
	if kind == "unique" and _used_unique_skills.has(skill_id):
		eligibility = {"eligible": false, "reason": "고유 스킬은 사건당 1회만 사용할 수 있습니다."}
	var chance := 100 if kind == "unique" else _support_chance(skill, owner_id)
	return {
		"skill_id": skill_id,
		"display_name": String(skill.get("display_name", skill_id)),
		"skill_kind": kind,
		"owner_companion_id": owner_id,
		"eligible": bool(eligibility.get("eligible", false)),
		"ineligible_reason": String(eligibility.get("reason", "")),
		"chance": chance,
		"readiness": readiness,
		"guaranteed_next": kind == "support" and readiness >= int(skill.get("readiness_guarantee", 100)),
		"guarantee_distance": 0 if kind == "unique" else maxi(0, int(skill.get("readiness_guarantee", 100)) - readiness),
		"effect_category": String(skill.get("effect_category", "")),
		"trigger_label": String(skill.get("trigger_label", "")),
		"forbidden_outputs": FORBIDDEN_OUTPUTS.duplicate(),
	}


func _support_chance(skill: Dictionary, owner_id: String) -> int:
	var chance := int(skill.get("base_chance", 0))
	var preparation_activity_ids := skill.get("preparation_activity_ids", []) as Array
	for activity_id_value in preparation_activity_ids:
		if _preparation_tags.has(String(activity_id_value)):
			chance += 10
			break
	var companion := _companion_states.get(owner_id, {}) as Dictionary
	chance += _trust_bonus(int(companion.get("work_trust", 0)))
	return mini(90, chance)


func _trust_bonus(work_trust: int) -> int:
	if work_trust >= 70:
		return 10
	if work_trust >= 40:
		return 5
	return 0


func _eligibility(skill: Dictionary, context: Dictionary) -> Dictionary:
	var trigger := String(skill.get("trigger", ""))
	var eligible := false
	match trigger:
		"first_damage_before":
			eligible = bool(context.get("first_damage_before", false))
		"clue_count_at_least_3":
			eligible = int(context.get("clue_count", 0)) >= 3
		"civilian_or_containment_failure_before":
			eligible = bool(context.get("civilian_or_containment_failure_before", false))
		"after_clue_recorded":
			eligible = bool(context.get("after_clue_recorded", false))
		"hypothesis_conflict_before":
			eligible = bool(context.get("hypothesis_conflict_before", false))
		"damage_at_least_6":
			eligible = int(context.get("damage", 0)) >= 6
		"risk_increase_before":
			eligible = bool(context.get("risk_increase_before", false))
		"observed_pattern_reappears":
			eligible = bool(context.get("observed_pattern_reappears", false))
		"capture_window_open":
			eligible = bool(context.get("capture_window_open", false))
		_:
			return {"eligible": false, "reason": "해석할 수 없는 발동 조건입니다."}
	if eligible:
		return {"eligible": true, "reason": ""}
	return {"eligible": false, "reason": "현재 사건 맥락이 발동 조건을 충족하지 않습니다."}


func _next_roll(event_key: String, skill_id: String) -> int:
	if _roll_index < _test_rolls.size():
		var forced := clampi(_test_rolls[_roll_index], 1, 100)
		_roll_index += 1
		return forced
	var value := absi(hash("%d|%s|%s" % [_run_seed, event_key, skill_id]))
	return value % 100 + 1


func _dictionary_array(value: Variant) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if typeof(value) != TYPE_ARRAY:
		return result
	for item in value as Array:
		if typeof(item) == TYPE_DICTIONARY:
			result.append((item as Dictionary).duplicate(true))
	return result
