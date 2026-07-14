# 10일 데모의 사건 공개, 위험도 순환, 일상 보너스와 종료 상태를 계산한다.
class_name CampaignState
extends RefCounted

const MAX_DAYS := 10
const AUTO_DISCOVERY_RISK := 60
const OUTBREAK_RISK := 100
const DAILY_UNDERSTANDING_CAP := 10
const PRIMARY_DAILY_RISK_DELTA := 10
const SECONDARY_DAILY_RISK_DELTA := 5

const AFTERLIFE := "episode_001_afterlife_station"
const RED_UMBRELLA := "episode_002_red_umbrella_alley"
const DEAD_FREQUENCY := "episode_003_dead_frequency_station"
const CASE_ORDER := [AFTERLIFE, RED_UMBRELLA, DEAD_FREQUENCY]
const TIME_SLOTS := ["morning", "afternoon"]
const SCHEDULE_ACTIVITIES := ["investigation", "daily", "research", "maintenance", "rest"]

var _state: Dictionary = {}


func _init() -> void:
	reset()


func reset() -> void:
	_state = {
		"day": 1,
		"time_slot": "morning",
		"max_days": MAX_DAYS,
		"demo_ended": false,
		"game_over": false,
		"emergency_case_id": "",
		"risk_rotation_cursor": 0,
		"schedules": {},
		"active_operation": {},
		"thresholds": {
			"auto_discovery": AUTO_DISCOVERY_RISK,
			"outbreak": OUTBREAK_RISK
		},
		"cases": {
			AFTERLIFE: _make_case_state("lead"),
			RED_UMBRELLA: _make_case_state("lead"),
			DEAD_FREQUENCY: _make_case_state("unknown")
		}
	}


func get_snapshot() -> Dictionary:
	return _state.duplicate(true)


func set_schedule(agent_id: String, time_slot: String, activity_id: String) -> bool:
	var clean_agent_id := agent_id.strip_edges()
	if clean_agent_id.is_empty() or not TIME_SLOTS.has(time_slot) or not SCHEDULE_ACTIVITIES.has(activity_id):
		return false
	var schedules: Dictionary = _state.get("schedules", {})
	var day_key := str(int(_state.get("day", 1)))
	var day_schedule: Dictionary = schedules.get(day_key, {}).duplicate(true)
	var agent_schedule: Dictionary = day_schedule.get(clean_agent_id, {}).duplicate(true)
	agent_schedule[time_slot] = activity_id
	day_schedule[clean_agent_id] = agent_schedule
	schedules[day_key] = day_schedule
	_state["schedules"] = schedules
	return true


func get_agent_schedule(agent_id: String) -> Dictionary:
	var schedules: Dictionary = _state.get("schedules", {})
	var day_schedule: Dictionary = schedules.get(str(int(_state.get("day", 1))), {})
	var value: Variant = day_schedule.get(agent_id, {})
	return value.duplicate(true) if typeof(value) == TYPE_DICTIONARY else {}


func is_schedule_complete(agent_ids: Array) -> bool:
	if agent_ids.is_empty():
		return false
	for agent_id in agent_ids:
		var agent_schedule := get_agent_schedule(String(agent_id))
		for time_slot in TIME_SLOTS:
			if not SCHEDULE_ACTIVITIES.has(String(agent_schedule.get(time_slot, ""))):
				return false
	return true


func begin_operation(case_id: String) -> bool:
	if not CASE_ORDER.has(case_id) or bool(_state.get("demo_ended", false)):
		return false
	_state["active_operation"] = {
		"case_id": case_id,
		"day": int(_state.get("day", 1))
	}
	return true


func finish_operation_day() -> Dictionary:
	var operation: Variant = _state.get("active_operation", {})
	if typeof(operation) != TYPE_DICTIONARY or operation.is_empty():
		return {"advanced": false, "changed_case_ids": []}
	if int(operation.get("day", 0)) != int(_state.get("day", 1)):
		_state["active_operation"] = {}
		return {"advanced": false, "changed_case_ids": []}
	_state["active_operation"] = {}
	return advance_day(_has_high_spread())


func resolve_case(case_id: String, resolution_grade: String) -> bool:
	if not CASE_ORDER.has(case_id):
		return false
	var case_state := _get_case_state(case_id)
	case_state["resolution_state"] = "resolved"
	case_state["resolution_grade"] = resolution_grade.strip_edges()
	_set_case_state(case_id, case_state)
	if String(_state.get("emergency_case_id", "")) == case_id:
		_state["emergency_case_id"] = ""
	return true


func advance_day(high_spread: bool = false) -> Dictionary:
	if bool(_state.get("demo_ended", false)):
		return {"advanced": false, "changed_case_ids": []}

	var current_day := int(_state.get("day", 1))
	if current_day >= MAX_DAYS:
		_state["demo_ended"] = true
		return {"advanced": false, "changed_case_ids": [], "demo_ended": true}

	var candidates := _get_unresolved_case_ids()
	var change_count := mini(2 if high_spread else 1, candidates.size())
	var changed_case_ids: Array = []
	if change_count > 0:
		var cursor := posmod(int(_state.get("risk_rotation_cursor", 0)), candidates.size())
		for offset in range(change_count):
			var case_id := String(candidates[(cursor + offset) % candidates.size()])
			var delta := PRIMARY_DAILY_RISK_DELTA if offset == 0 else SECONDARY_DAILY_RISK_DELTA
			apply_case_risk(case_id, delta)
			var case_state := _get_case_state(case_id)
			case_state["last_risk_day"] = current_day + 1
			_set_case_state(case_id, case_state)
			changed_case_ids.append(case_id)
		_state["risk_rotation_cursor"] = (cursor + change_count) % candidates.size()

	_state["day"] = current_day + 1
	_state["time_slot"] = "morning"
	return {
		"advanced": true,
		"day": int(_state["day"]),
		"changed_case_ids": changed_case_ids,
		"demo_ended": false
	}


func apply_case_risk(case_id: String, delta: int) -> int:
	if not CASE_ORDER.has(case_id):
		return 0
	var case_state := _get_case_state(case_id)
	var risk := clampi(int(case_state.get("risk", 0)) + delta, 0, OUTBREAK_RISK)
	case_state["risk"] = risk
	if risk >= AUTO_DISCOVERY_RISK and String(case_state.get("discovery_state", "unknown")) == "unknown":
		case_state["discovery_state"] = "lead"
	if risk >= OUTBREAK_RISK:
		_state["emergency_case_id"] = case_id
	_set_case_state(case_id, case_state)
	return risk


func grant_daily_understanding(case_id: String, reward_type: String, content_id: String = "") -> int:
	if not CASE_ORDER.has(case_id) or bool(_state.get("demo_ended", false)):
		return 0
	var case_state := _get_case_state(case_id)
	var current_day := int(_state.get("day", 1))
	if int(case_state.get("last_daily_reward_day", 0)) == current_day:
		return 0
	var clean_content_id := content_id.strip_edges()
	var rewarded_content_ids: Array = case_state.get("rewarded_daily_content_ids", []).duplicate()
	if not clean_content_id.is_empty() and rewarded_content_ids.has(clean_content_id):
		return 0
	var current_value := int(case_state.get("daily_understanding", 0))
	var requested := 2 if reward_type == "first_view" else 1
	var granted := mini(requested, DAILY_UNDERSTANDING_CAP - current_value)
	if granted <= 0:
		return 0
	case_state["daily_understanding"] = current_value + granted
	case_state["last_daily_reward_day"] = current_day
	if not clean_content_id.is_empty():
		rewarded_content_ids.append(clean_content_id)
	case_state["rewarded_daily_content_ids"] = rewarded_content_ids
	_set_case_state(case_id, case_state)
	return granted


func to_save_data() -> Dictionary:
	return get_snapshot()


func load_save_data(value: Variant) -> void:
	reset()
	if typeof(value) != TYPE_DICTIONARY:
		return
	var saved: Dictionary = value
	_state["day"] = clampi(int(saved.get("day", 1)), 1, MAX_DAYS)
	_state["time_slot"] = String(saved.get("time_slot", "morning"))
	_state["demo_ended"] = bool(saved.get("demo_ended", false))
	_state["emergency_case_id"] = String(saved.get("emergency_case_id", ""))
	_state["risk_rotation_cursor"] = maxi(0, int(saved.get("risk_rotation_cursor", 0)))
	_state["schedules"] = _sanitize_schedules(saved.get("schedules", {}))
	var saved_operation: Variant = saved.get("active_operation", {})
	if typeof(saved_operation) == TYPE_DICTIONARY:
		var operation_case_id := String(saved_operation.get("case_id", ""))
		var operation_day := int(saved_operation.get("day", 0))
		if CASE_ORDER.has(operation_case_id) and operation_day == int(_state["day"]):
			_state["active_operation"] = {"case_id": operation_case_id, "day": operation_day}

	var saved_cases: Variant = saved.get("cases", {})
	if typeof(saved_cases) != TYPE_DICTIONARY:
		return
	for case_id in CASE_ORDER:
		var loaded_case: Variant = saved_cases.get(case_id, {})
		if typeof(loaded_case) != TYPE_DICTIONARY:
			continue
		var case_state := _get_case_state(case_id)
		case_state["discovery_state"] = String(loaded_case.get("discovery_state", case_state["discovery_state"]))
		case_state["resolution_state"] = String(loaded_case.get("resolution_state", "unresolved"))
		case_state["resolution_grade"] = String(loaded_case.get("resolution_grade", ""))
		case_state["risk"] = clampi(int(loaded_case.get("risk", 0)), 0, OUTBREAK_RISK)
		case_state["daily_understanding"] = clampi(int(loaded_case.get("daily_understanding", 0)), 0, DAILY_UNDERSTANDING_CAP)
		case_state["last_daily_reward_day"] = maxi(0, int(loaded_case.get("last_daily_reward_day", 0)))
		case_state["last_risk_day"] = maxi(0, int(loaded_case.get("last_risk_day", 0)))
		case_state["rewarded_daily_content_ids"] = _to_unique_strings(loaded_case.get("rewarded_daily_content_ids", []))
		_set_case_state(case_id, case_state)


func _make_case_state(discovery_state: String) -> Dictionary:
	return {
		"discovery_state": discovery_state,
		"resolution_state": "unresolved",
		"resolution_grade": "",
		"risk": 0,
		"daily_understanding": 0,
		"last_daily_reward_day": 0,
		"last_risk_day": 0,
		"rewarded_daily_content_ids": []
	}


func _get_unresolved_case_ids() -> Array:
	var result: Array = []
	for case_id in CASE_ORDER:
		var case_state := _get_case_state(case_id)
		if String(case_state.get("resolution_state", "unresolved")) == "unresolved":
			result.append(case_id)
	return result


func _has_high_spread() -> bool:
	for case_id in _get_unresolved_case_ids():
		if int(_get_case_state(String(case_id)).get("risk", 0)) >= AUTO_DISCOVERY_RISK:
			return true
	return false


func _get_case_state(case_id: String) -> Dictionary:
	var cases: Dictionary = _state.get("cases", {})
	var value: Variant = cases.get(case_id, {})
	return value.duplicate(true) if typeof(value) == TYPE_DICTIONARY else {}


func _set_case_state(case_id: String, case_state: Dictionary) -> void:
	var cases: Dictionary = _state.get("cases", {})
	cases[case_id] = case_state
	_state["cases"] = cases


func _to_unique_strings(value: Variant) -> Array:
	var result: Array = []
	if typeof(value) != TYPE_ARRAY:
		return result
	for item in value:
		var text := String(item).strip_edges()
		if not text.is_empty() and not result.has(text):
			result.append(text)
	return result


func _sanitize_schedules(value: Variant) -> Dictionary:
	var result: Dictionary = {}
	if typeof(value) != TYPE_DICTIONARY:
		return result
	for raw_day in value:
		var day_key := String(raw_day)
		var raw_day_schedule: Variant = value.get(raw_day, {})
		if typeof(raw_day_schedule) != TYPE_DICTIONARY:
			continue
		var day_schedule: Dictionary = {}
		for raw_agent_id in raw_day_schedule:
			var agent_id := String(raw_agent_id).strip_edges()
			var raw_agent_schedule: Variant = raw_day_schedule.get(raw_agent_id, {})
			if agent_id.is_empty() or typeof(raw_agent_schedule) != TYPE_DICTIONARY:
				continue
			var agent_schedule: Dictionary = {}
			for time_slot in TIME_SLOTS:
				var activity_id := String(raw_agent_schedule.get(time_slot, ""))
				if SCHEDULE_ACTIVITIES.has(activity_id):
					agent_schedule[time_slot] = activity_id
			if not agent_schedule.is_empty():
				day_schedule[agent_id] = agent_schedule
		if not day_schedule.is_empty():
			result[day_key] = day_schedule
	return result
