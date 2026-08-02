class_name ValidationEntryCoordinator
extends RefCounted

const EPISODE_ID := "episode_001_afterlife_station"
const DEFAULT_AGENT_IDS := ["agent_oh_hyun", "agent_kwon_narae", "agent_kang_ijun"]
const DEFAULT_LEGACY_PATH := "user://urban_legend_save.json"
const IDENTITY_KEYS := ["episode_id", "lifecycle", "flow_stage", "checkpoint_id", "updated_at_utc"]

var _session: Object
var _inspector: Object
var _game_state: Object
var _scene_changer: Callable
var _route_mapper: Object
var _legacy_path: String
var _busy := false
var _pending_replace_summary: Dictionary = {}


func _init(
	session: Object,
	inspector: Object,
	game_state: Object,
	scene_changer: Callable,
	route_mapper: Object,
	legacy_path: String = DEFAULT_LEGACY_PATH
) -> void:
	_session = session
	_inspector = inspector
	_game_state = game_state
	_scene_changer = scene_changer
	_route_mapper = route_mapper
	_legacy_path = legacy_path


func is_busy() -> bool:
	return _busy


func force_busy_for_test(value: bool) -> void:
	_busy = value


func get_pending_replace_summary() -> Dictionary:
	return _pending_replace_summary.duplicate(true)


func start_new_validation() -> Dictionary:
	if _busy:
		return _result(false, "BUSY")
	var summary := _inspect()
	if bool(summary.get("can_start", false)):
		return _start_from_empty()
	if bool(summary.get("requires_replace_confirmation", false)):
		_pending_replace_summary = summary.duplicate(true)
		return _result(false, "REPLACE_CONFIRMATION_REQUIRED", {"summary": summary})
	return _result(false, String(summary.get("repository_code", "UNKNOWN")), {"summary": summary})


func confirm_replace_and_start() -> Dictionary:
	if _busy:
		return _result(false, "BUSY")
	if _pending_replace_summary.is_empty():
		return _result(false, "NO_PENDING_REPLACE")
	var current := _inspect()
	if not bool(current.get("requires_replace_confirmation", false)):
		_pending_replace_summary.clear()
		return _result(false, "RECORD_CHANGED", {"summary": current})
	if not _same_record(_pending_replace_summary, current):
		_pending_replace_summary = current.duplicate(true)
		return _result(false, "RECORD_CHANGED", {"summary": current})

	_busy = true
	var deleted: Dictionary = _session.delete_persistence()
	if String(deleted.get("code", "")) != "OK":
		_busy = false
		return deleted
	var empty := _inspect()
	if not bool(empty.get("can_start", false)):
		_busy = false
		_pending_replace_summary.clear()
		return _result(false, "DELETE_VERIFY_FAILED", {"summary": empty})
	_pending_replace_summary.clear()
	_busy = false
	return _start_from_empty()


func cancel_replace() -> Dictionary:
	_pending_replace_summary.clear()
	return _result(true, "OK")


func continue_validation() -> Dictionary:
	if _busy:
		return _result(false, "BUSY")
	var summary := _inspect()
	if not bool(summary.get("can_continue", false)):
		return _result(false, String(summary.get("repository_code", "INVALID_LIFECYCLE")), {"summary": summary})

	_busy = true
	var runtime_before: Dictionary = _game_state.export_validation_runtime_snapshot()
	var hidden_before: Dictionary = _game_state.snapshot_hidden_legacy_state_for_test()
	var legacy_before := _legacy_snapshot()
	var loaded: Dictionary = _session.load(_game_state)
	if String(loaded.get("code", "")) != "OK":
		return _rollback_loaded(String(loaded.get("code", "LOAD_FAILED")), runtime_before, hidden_before, legacy_before)

	if String(summary.get("lifecycle", "")) == "suspended":
		var resumed: Dictionary = _session.resume(_game_state)
		if String(resumed.get("code", "")) != "OK":
			return _rollback_loaded(String(resumed.get("code", "RESUME_FAILED")), runtime_before, hidden_before, legacy_before)

	var route: Dictionary = _route_mapper.resolve(
		String(summary.get("flow_stage", "")),
		String(summary.get("lifecycle", ""))
	)
	if String(route.get("code", "")) != "OK":
		return _rollback_loaded(String(route.get("code", "UNKNOWN_FLOW_STAGE")), runtime_before, hidden_before, legacy_before)
	if not _guards_match(hidden_before, legacy_before):
		return _rollback_loaded("LEGACY_GUARD_VIOLATION", runtime_before, hidden_before, legacy_before)

	var changed: Variant = _scene_changer.call(String(route.get("scene_path", "")))
	if int(changed) != OK:
		return _rollback_loaded("SCENE_CHANGE_FAILED", runtime_before, hidden_before, legacy_before)
	_busy = false
	return _result(true, "OK", {"route": route})


func view_completed_validation() -> Dictionary:
	if _busy:
		return _result(false, "BUSY")
	var summary := _inspect()
	if not bool(summary.get("can_view_completed", false)):
		return _result(false, String(summary.get("repository_code", "INVALID_LIFECYCLE")), {"summary": summary})
	return _result(true, "OK", {"summary": summary})


func _start_from_empty() -> Dictionary:
	if _busy:
		return _result(false, "BUSY")
	var route: Dictionary = _route_mapper.resolve("SIT-001", "active")
	if String(route.get("code", "")) != "OK":
		return route

	_busy = true
	var runtime_before: Dictionary = _game_state.export_validation_runtime_snapshot()
	var hidden_before: Dictionary = _game_state.snapshot_hidden_legacy_state_for_test()
	var legacy_before := _legacy_snapshot()
	var created_persistence := false

	var created: Dictionary = _session.create(EPISODE_ID)
	if String(created.get("code", "")) != "OK":
		return _rollback_new(String(created.get("code", "CREATE_FAILED")), runtime_before, hidden_before, legacy_before, false)
	created_persistence = true

	var activated: Dictionary = _session.activate(String(created.get("session_token", "")))
	if String(activated.get("code", "")) != "OK":
		return _rollback_new(String(activated.get("code", "ACTIVATE_FAILED")), runtime_before, hidden_before, legacy_before, created_persistence)
	var guarded: Dictionary = _session.capture_legacy_guard(_game_state)
	if String(guarded.get("code", "")) != "OK":
		return _rollback_new(String(guarded.get("code", "LEGACY_GUARD_VIOLATION")), runtime_before, hidden_before, legacy_before, created_persistence)
	var initialized: Dictionary = _game_state.initialize_validation_runtime(EPISODE_ID, DEFAULT_AGENT_IDS)
	if String(initialized.get("code", "")) != "OK":
		return _rollback_new(String(initialized.get("code", "INITIALIZE_FAILED")), runtime_before, hidden_before, legacy_before, created_persistence)
	if not _guards_match(hidden_before, legacy_before):
		return _rollback_new("LEGACY_GUARD_VIOLATION", runtime_before, hidden_before, legacy_before, created_persistence)
	var saved: Dictionary = _session.save(_game_state)
	if String(saved.get("code", "")) != "OK":
		return _rollback_new(String(saved.get("code", "SAVE_FAILED")), runtime_before, hidden_before, legacy_before, created_persistence)
	if not _guards_match(hidden_before, legacy_before):
		return _rollback_new("LEGACY_GUARD_VIOLATION", runtime_before, hidden_before, legacy_before, created_persistence)

	var changed: Variant = _scene_changer.call(String(route.get("scene_path", "")))
	if int(changed) != OK:
		return _rollback_new("SCENE_CHANGE_FAILED", runtime_before, hidden_before, legacy_before, created_persistence)
	_busy = false
	return _result(true, "OK", {"route": route})


func _rollback_new(
	code: String,
	runtime_before: Dictionary,
	hidden_before: Dictionary,
	legacy_before: Dictionary,
	created_persistence: bool
) -> Dictionary:
	_game_state.restore_validation_runtime_snapshot(runtime_before)
	_session.abandon_runtime()
	if created_persistence:
		_session.delete_persistence()
	_busy = false
	if not _guards_match(hidden_before, legacy_before):
		return _result(false, "LEGACY_GUARD_VIOLATION", {"cause": code})
	return _result(false, code)


func _rollback_loaded(
	code: String,
	runtime_before: Dictionary,
	hidden_before: Dictionary,
	legacy_before: Dictionary
) -> Dictionary:
	_game_state.restore_validation_runtime_snapshot(runtime_before)
	_session.abandon_runtime()
	_busy = false
	if not _guards_match(hidden_before, legacy_before):
		return _result(false, "LEGACY_GUARD_VIOLATION", {"cause": code})
	return _result(false, code)


func _inspect() -> Dictionary:
	if _inspector == null or not _inspector.has_method("inspect_persistence"):
		return {"repository_code": "READ_FAILED", "can_start": false, "can_continue": false}
	return _inspector.inspect_persistence()


func _same_record(left: Dictionary, right: Dictionary) -> bool:
	for key in IDENTITY_KEYS:
		if left.get(key) != right.get(key):
			return false
	return true


func _legacy_snapshot() -> Dictionary:
	if _legacy_path.is_empty():
		return {"checked": false}
	var exists := FileAccess.file_exists(_legacy_path)
	return {
		"checked": true,
		"exists": exists,
		"bytes": FileAccess.get_file_as_bytes(_legacy_path) if exists else PackedByteArray()
	}


func _guards_match(hidden_before: Dictionary, legacy_before: Dictionary) -> bool:
	if not _semantic_equal(hidden_before, _game_state.snapshot_hidden_legacy_state_for_test()):
		return false
	if not bool(legacy_before.get("checked", false)):
		return true
	var exists_now := FileAccess.file_exists(_legacy_path)
	if exists_now != bool(legacy_before.get("exists", false)):
		return false
	if not exists_now:
		return true
	return FileAccess.get_file_as_bytes(_legacy_path) == legacy_before.get("bytes", PackedByteArray())


func _semantic_equal(left: Variant, right: Variant) -> bool:
	var left_type := typeof(left)
	var right_type := typeof(right)
	if left_type in [TYPE_INT, TYPE_FLOAT] and right_type in [TYPE_INT, TYPE_FLOAT]:
		return is_equal_approx(float(left), float(right))
	if left_type == TYPE_DICTIONARY and right_type == TYPE_DICTIONARY:
		var left_dict := left as Dictionary
		var right_dict := right as Dictionary
		if left_dict.size() != right_dict.size():
			return false
		for key in left_dict.keys():
			if not right_dict.has(key) or not _semantic_equal(left_dict[key], right_dict[key]):
				return false
		return true
	if left_type == TYPE_ARRAY and right_type == TYPE_ARRAY:
		var left_array := left as Array
		var right_array := right as Array
		if left_array.size() != right_array.size():
			return false
		for index in range(left_array.size()):
			if not _semantic_equal(left_array[index], right_array[index]):
				return false
		return true
	return left == right


func _result(ok: bool, code: String, details: Dictionary = {}) -> Dictionary:
	var value := {"ok": ok, "code": code}
	for key in details.keys():
		value[key] = details[key]
	return value
