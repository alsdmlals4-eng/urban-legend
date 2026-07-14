class_name CampaignState
extends RefCounted

const MAX_DAYS := 10
const AUTO_DISCOVERY_RISK := 60
const OUTBREAK_RISK := 100
const DAILY_UNDERSTANDING_CAP := 10
const PRIMARY_DAILY_RISK_DELTA := 10
const SECONDARY_DAILY_RISK_DELTA := 5
const REQUEST_BOARD_SIZE := 3
const REQUEST_CATALOG_PATH := "res://data/faction_requests.json"

const AFTERLIFE := "episode_001_afterlife_station"
const RED_UMBRELLA := "episode_002_red_umbrella_alley"
const DEAD_FREQUENCY := "episode_003_dead_frequency_station"
const CASE_ORDER := [AFTERLIFE, RED_UMBRELLA, DEAD_FREQUENCY]
const TIME_SLOTS := ["morning", "afternoon"]
const SLOT_PHASES := ["planning", "in_progress", "result"]
const SCHEDULE_ACTIVITIES := ["investigation", "rest"]
const REQUEST_STATUSES := ["offered", "accepted", "completed", "failed", "declined", "canceled"]

var _state: Dictionary = {}
var _request_templates: Array = []


func _init() -> void:
	_request_templates = _load_request_templates()
	reset()


func reset(seed: int = 0) -> void:
	var initial_seed := seed
	if initial_seed <= 0:
		initial_seed = int(Time.get_ticks_usec() % 2147483647)
	_state = {
		"day": 1,
		"time_slot": "morning",
		"slot_phase": "planning",
		"slot_result": {},
		"planned_case_id": "",
		"max_days": MAX_DAYS,
		"demo_ended": false,
		"game_over": false,
		"emergency_case_id": "",
		"risk_rotation_cursor": 0,
		"schedules": {},
		"active_operation": {},
		"request_rng_state": maxi(1, initial_seed),
		"request_sequence": 0,
		"request_board": [],
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
	_refresh_request_board(true)


func get_snapshot() -> Dictionary:
	return _state.duplicate(true)


func get_current_slot() -> String:
	return String(_state.get("time_slot", "morning"))


func get_slot_phase() -> String:
	return String(_state.get("slot_phase", "planning"))


func get_slot_result() -> Dictionary:
	var value: Variant = _state.get("slot_result", {})
	return value.duplicate(true) if typeof(value) == TYPE_DICTIONARY else {}


func set_schedule(agent_id: String, time_slot: String, activity_id: String) -> bool:
	var clean_agent_id := agent_id.strip_edges()
	if get_slot_phase() != "planning" or time_slot != get_current_slot() or clean_agent_id.is_empty():
		return false
	if not _is_valid_activity(activity_id):
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
	if agent_ids.is_empty() or get_slot_phase() != "planning":
		return false
	var slot := get_current_slot()
	for agent_id in agent_ids:
		if not _is_valid_activity(String(get_agent_schedule(String(agent_id)).get(slot, ""))):
			return false
	return true


func set_planned_case(case_id: String) -> bool:
	if get_slot_phase() != "planning":
		return false
	var clean_id := case_id.strip_edges()
	if not clean_id.is_empty() and not CASE_ORDER.has(clean_id):
		return false
	var emergency := String(_state.get("emergency_case_id", ""))
	if not emergency.is_empty() and clean_id != emergency:
		return false
	_state["planned_case_id"] = clean_id
	return true


func get_planned_case() -> String:
	return String(_state.get("planned_case_id", ""))


func begin_operation(case_id: String) -> bool:
	if get_slot_phase() != "planning" or not CASE_ORDER.has(case_id) or bool(_state.get("demo_ended", false)):
		return false
	if get_planned_case() != case_id:
		return false
	_state["active_operation"] = {
		"case_id": case_id,
		"day": int(_state.get("day", 1)),
		"time_slot": get_current_slot(),
		"status": "in_progress"
	}
	_state["slot_phase"] = "in_progress"
	return true


func suspend_operation() -> bool:
	var operation := _get_active_operation()
	if operation.is_empty() or get_slot_phase() != "in_progress":
		return false
	operation["status"] = "suspended"
	_state["active_operation"] = operation
	return true


func resume_operation() -> bool:
	var operation := _get_active_operation()
	if operation.is_empty() or String(operation.get("status", "")) != "suspended":
		return false
	operation["status"] = "in_progress"
	_state["active_operation"] = operation
	return true


func get_active_operation() -> Dictionary:
	return _get_active_operation()


func complete_current_slot(result: Dictionary = {}) -> bool:
	if get_slot_phase() == "result":
		return false
	if get_slot_phase() == "in_progress":
		var operation := _get_active_operation()
		if operation.is_empty():
			return false
		operation["status"] = "completed"
		_state["active_operation"] = operation
	elif get_slot_phase() != "planning":
		return false
	_state["slot_result"] = result.duplicate(true)
	_state["slot_phase"] = "result"
	return true


func acknowledge_slot_result(high_spread: bool = false) -> Dictionary:
	if get_slot_phase() != "result":
		return {"advanced": false}
	var completed_slot := get_current_slot()
	_state["slot_result"] = {}
	_state["active_operation"] = {}
	_state["planned_case_id"] = ""
	if completed_slot == "morning":
		_state["time_slot"] = "afternoon"
		_state["slot_phase"] = "planning"
		_refresh_request_board(false)
		return {"advanced": true, "time_slot": "afternoon", "day": int(_state.get("day", 1))}
	var result := _advance_day_internal(high_spread)
	_refresh_request_board(false)
	return result


func finish_operation_day() -> Dictionary:
	# Legacy facade: an operation now completes only the current half-day.
	if not complete_current_slot({"kind": "investigation"}):
		return {"advanced": false, "changed_case_ids": []}
	return {"advanced": true, "day": int(_state.get("day", 1)), "time_slot": get_current_slot()}


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
	var result := _advance_day_internal(high_spread)
	_refresh_request_board(false)
	return result


func _advance_day_internal(high_spread: bool) -> Dictionary:
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
	_state["slot_phase"] = "planning"
	return {"advanced": true, "day": int(_state["day"]), "time_slot": "morning", "changed_case_ids": changed_case_ids, "demo_ended": false}


func get_request_board() -> Array:
	return _state.get("request_board", []).duplicate(true)


func accept_request(instance_id: String) -> bool:
	return _set_request_status(instance_id, "offered", "accepted")


func decline_request(instance_id: String) -> bool:
	return _set_request_status(instance_id, "offered", "declined")


func cancel_request(instance_id: String) -> Dictionary:
	var request := get_request(instance_id)
	if request.is_empty() or String(request.get("status", "")) != "accepted":
		return {}
	if not _set_request_status(instance_id, "accepted", "canceled"):
		return {}
	return request


func complete_request(instance_id: String, result_grade: String, roll_result: Dictionary) -> Dictionary:
	var request := get_request(instance_id)
	if request.is_empty() or String(request.get("status", "")) != "accepted":
		return {}
	var next_status := "failed" if result_grade == "failure" else "completed"
	request["status"] = next_status
	request["result_grade"] = result_grade
	request["roll_result"] = roll_result.duplicate(true)
	_replace_request(request)
	return request


func assign_request(instance_id: String, agent_id: String) -> bool:
	var request := get_request(instance_id)
	if request.is_empty() or String(request.get("status", "")) != "accepted" or String(request.get("kind", "")) != "dispatch":
		return false
	request["assigned_agent_id"] = agent_id.strip_edges()
	_replace_request(request)
	return not String(request["assigned_agent_id"]).is_empty()


func get_request(instance_id: String) -> Dictionary:
	for request in get_request_board():
		if typeof(request) == TYPE_DICTIONARY and String(request.get("instance_id", "")) == instance_id:
			return request.duplicate(true)
	return {}


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


func load_save_data(value: Variant, legacy_mvp037: bool = false) -> void:
	reset(380714)
	if typeof(value) != TYPE_DICTIONARY:
		return
	var saved: Dictionary = value
	_state["day"] = clampi(int(saved.get("day", 1)), 1, MAX_DAYS)
	_state["time_slot"] = String(saved.get("time_slot", "morning")) if TIME_SLOTS.has(String(saved.get("time_slot", "morning"))) else "morning"
	_state["slot_phase"] = String(saved.get("slot_phase", "planning")) if SLOT_PHASES.has(String(saved.get("slot_phase", "planning"))) else "planning"
	_state["slot_result"] = saved.get("slot_result", {}).duplicate(true) if typeof(saved.get("slot_result", {})) == TYPE_DICTIONARY else {}
	_state["planned_case_id"] = String(saved.get("planned_case_id", ""))
	_state["demo_ended"] = bool(saved.get("demo_ended", false))
	_state["emergency_case_id"] = String(saved.get("emergency_case_id", ""))
	_state["risk_rotation_cursor"] = maxi(0, int(saved.get("risk_rotation_cursor", 0)))
	_state["schedules"] = _sanitize_schedules(saved.get("schedules", {}), legacy_mvp037)
	_state["request_rng_state"] = maxi(1, int(saved.get("request_rng_state", _state["request_rng_state"])))
	_state["request_sequence"] = maxi(0, int(saved.get("request_sequence", 0)))
	var board := _sanitize_request_board(saved.get("request_board", []))
	if not board.is_empty():
		_state["request_board"] = board
	var saved_operation: Variant = saved.get("active_operation", {})
	if typeof(saved_operation) == TYPE_DICTIONARY:
		var operation_case_id := String(saved_operation.get("case_id", ""))
		var operation_day := int(saved_operation.get("day", 0))
		if CASE_ORDER.has(operation_case_id) and operation_day == int(_state["day"]):
			_state["active_operation"] = saved_operation.duplicate(true)
			_state["active_operation"]["time_slot"] = String(saved_operation.get("time_slot", _state["time_slot"]))
			_state["active_operation"]["status"] = String(saved_operation.get("status", "suspended" if legacy_mvp037 else "in_progress"))
			_state["slot_phase"] = "in_progress"
			_state["planned_case_id"] = operation_case_id
	var saved_cases: Variant = saved.get("cases", {})
	if typeof(saved_cases) == TYPE_DICTIONARY:
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


func _load_request_templates() -> Array:
	if not FileAccess.file_exists(REQUEST_CATALOG_PATH):
		return []
	var file := FileAccess.open(REQUEST_CATALOG_PATH, FileAccess.READ)
	if file == null:
		return []
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY or typeof(parsed.get("requests", [])) != TYPE_ARRAY:
		return []
	return parsed.get("requests", []).duplicate(true)


func _refresh_request_board(initial: bool) -> void:
	var board: Array = _state.get("request_board", []).duplicate(true)
	while board.size() < REQUEST_BOARD_SIZE:
		board.append({})
	var used: Array = []
	for request in board:
		if typeof(request) == TYPE_DICTIONARY and String(request.get("status", "")) in ["offered", "accepted"]:
			used.append(String(request.get("template_id", "")))
	for index in range(REQUEST_BOARD_SIZE):
		var request: Dictionary = board[index] if typeof(board[index]) == TYPE_DICTIONARY else {}
		var status := String(request.get("status", ""))
		if status == "accepted":
			continue
		if not initial and status == "offered" and _next_percent() <= 50:
			continue
		var previous_template := String(request.get("template_id", ""))
		used.erase(previous_template)
		board[index] = _make_request_instance(used)
		if not board[index].is_empty():
			used.append(String(board[index].get("template_id", "")))
	_state["request_board"] = board


func _make_request_instance(excluded_template_ids: Array) -> Dictionary:
	var candidates: Array = []
	for template in _request_templates:
		if typeof(template) == TYPE_DICTIONARY and not excluded_template_ids.has(String(template.get("id", ""))):
			candidates.append(template)
	if candidates.is_empty():
		return {}
	var selected: Dictionary = candidates[_next_percent() % candidates.size()].duplicate(true)
	_state["request_sequence"] = int(_state.get("request_sequence", 0)) + 1
	selected["template_id"] = String(selected.get("id", ""))
	selected["instance_id"] = "%s-%04d" % [selected["template_id"], int(_state["request_sequence"])]
	selected.erase("id")
	selected["status"] = "offered"
	selected["assigned_agent_id"] = ""
	selected["result_grade"] = ""
	selected["roll_result"] = {}
	return selected


func _next_percent() -> int:
	var next_state := int((int(_state.get("request_rng_state", 1)) * 48271) % 2147483647)
	_state["request_rng_state"] = maxi(1, next_state)
	return (next_state % 100) + 1


func _set_request_status(instance_id: String, expected: String, next_status: String) -> bool:
	if not REQUEST_STATUSES.has(next_status):
		return false
	var request := get_request(instance_id)
	if request.is_empty() or String(request.get("status", "")) != expected:
		return false
	request["status"] = next_status
	_replace_request(request)
	return true


func _replace_request(request: Dictionary) -> void:
	var board: Array = _state.get("request_board", []).duplicate(true)
	for index in range(board.size()):
		if typeof(board[index]) == TYPE_DICTIONARY and String(board[index].get("instance_id", "")) == String(request.get("instance_id", "")):
			board[index] = request.duplicate(true)
			break
	_state["request_board"] = board


func _sanitize_request_board(value: Variant) -> Array:
	var result: Array = []
	if typeof(value) != TYPE_ARRAY:
		return result
	for raw in value:
		if typeof(raw) != TYPE_DICTIONARY or result.size() >= REQUEST_BOARD_SIZE:
			continue
		var request: Dictionary = raw.duplicate(true)
		if String(request.get("instance_id", "")).is_empty() or not REQUEST_STATUSES.has(String(request.get("status", ""))):
			continue
		result.append(request)
	return result


func _is_valid_activity(activity_id: String) -> bool:
	if SCHEDULE_ACTIVITIES.has(activity_id):
		return true
	if not activity_id.begins_with("request:"):
		return false
	var request := get_request(activity_id.trim_prefix("request:"))
	return not request.is_empty() and String(request.get("status", "")) == "accepted" and String(request.get("kind", "")) == "dispatch"


func _get_active_operation() -> Dictionary:
	var value: Variant = _state.get("active_operation", {})
	return value.duplicate(true) if typeof(value) == TYPE_DICTIONARY else {}


func _make_case_state(discovery_state: String) -> Dictionary:
	return {"discovery_state": discovery_state, "resolution_state": "unresolved", "resolution_grade": "", "risk": 0, "daily_understanding": 0, "last_daily_reward_day": 0, "last_risk_day": 0, "rewarded_daily_content_ids": []}


func _get_unresolved_case_ids() -> Array:
	var result: Array = []
	for case_id in CASE_ORDER:
		if String(_get_case_state(case_id).get("resolution_state", "unresolved")) == "unresolved":
			result.append(case_id)
	return result


func _has_high_spread() -> bool:
	for case_id in _get_unresolved_case_ids():
		if int(_get_case_state(String(case_id)).get("risk", 0)) >= AUTO_DISCOVERY_RISK:
			return true
	return false


func has_high_spread() -> bool:
	return _has_high_spread()


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


func _sanitize_schedules(value: Variant, legacy_mvp037: bool) -> Dictionary:
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
				if legacy_mvp037 and time_slot == "afternoon":
					continue
				var activity_id := String(raw_agent_schedule.get(time_slot, ""))
				if SCHEDULE_ACTIVITIES.has(activity_id) or activity_id.begins_with("request:"):
					agent_schedule[time_slot] = activity_id
			if not agent_schedule.is_empty():
				day_schedule[agent_id] = agent_schedule
		if not day_schedule.is_empty():
			result[day_key] = day_schedule
	return result
