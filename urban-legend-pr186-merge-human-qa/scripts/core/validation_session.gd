extends Node

const RepositoryScript := preload("res://scripts/core/validation_save_repository.gd")
const MODE_INACTIVE := "inactive"
const MODE_VALIDATION := "validation"
const LIFECYCLE_EMPTY := "empty"
const LIFECYCLE_ACTIVE := "active"
const LIFECYCLE_SUSPENDED := "suspended"
const LIFECYCLE_COMPLETED := "completed"
const SAVE_VERSION := "validation-save-v1"
const FORMAT_ID := "urban-legend-validation-save"
const PAYLOAD_SCHEMA := 1
const ALLOWED_EPISODES := ["episode_001_afterlife_station"]
const COMPLETION_EFFECT_ID := "validation:afterlife:completion:v1"

var _repository = RepositoryScript.new()
var _mode := MODE_INACTIVE
var _lifecycle := LIFECYCLE_EMPTY
var _session_token := ""
var _episode_id := ""
var _flow_stage := "SIT-001"
var _checkpoint_id := ""
var _return_target := ""
var _focus_token := ""
var _runtime_snapshot: Dictionary = {}
var _preparation_snapshot: Dictionary = {}
var _reasoning_state: Dictionary = {}
var _route_state: Dictionary = {}
var _recovery_progress: Dictionary = {}
var _result_axes: Dictionary = {}
var _candidate_records: Dictionary = {}
var _applied_effect_ids: Dictionary = {}
var _legacy_guard_snapshot: Dictionary = {}
var _created_at_utc := ""
var _updated_at_utc := ""
var _completed_at_utc := ""
var _revision := 0


func configure_repository_path_for_test(path: String) -> void:
	if _mode == MODE_INACTIVE:
		_repository = RepositoryScript.new(path)


func get_repository_paths() -> Dictionary:
	return _repository.get_paths()


func get_revision() -> int:
	return _revision


func requires_save_routing() -> bool:
	return _mode == MODE_VALIDATION


func is_active_and_valid() -> bool:
	return (
		_mode == MODE_VALIDATION
		and _lifecycle == LIFECYCLE_ACTIVE
		and not _session_token.is_empty()
		and ALLOWED_EPISODES.has(_episode_id)
	)


func create(episode_id: String) -> Dictionary:
	if not ALLOWED_EPISODES.has(episode_id):
		return _result(false, "INVALID_EPISODE")
	var persistence_state := _repository.inspect()
	if String(persistence_state.get("code", "")) != "EMPTY":
		return _result(false, "ALREADY_EXISTS", {"persistence_code": persistence_state.get("code", "UNKNOWN")})
	_reset_memory()
	_episode_id = episode_id
	_lifecycle = LIFECYCLE_ACTIVE
	_session_token = Crypto.new().generate_random_bytes(16).hex_encode()
	_created_at_utc = Time.get_datetime_string_from_system(true, true)
	_updated_at_utc = _created_at_utc
	return _result(true, "OK", {"session_token": _session_token})


func activate(token: String) -> Dictionary:
	if _mode == MODE_VALIDATION:
		return _result(false, "SESSION_ALREADY_ACTIVE")
	if _lifecycle != LIFECYCLE_ACTIVE:
		return _result(false, "INVALID_LIFECYCLE")
	if token != _session_token:
		return _result(false, "SESSION_TOKEN_MISMATCH")
	if not ALLOWED_EPISODES.has(_episode_id):
		return _result(false, "INVALID_EPISODE")
	_mode = MODE_VALIDATION
	return _result(true, "OK")


func capture_legacy_guard(game_state: Object) -> Dictionary:
	if game_state == null or not game_state.has_method("snapshot_hidden_legacy_state_for_test"):
		return _result(false, "MISSING_GAME_STATE_ADAPTER")
	_legacy_guard_snapshot = game_state.snapshot_hidden_legacy_state_for_test()
	return _result(true, "OK")


func save(game_state: Object) -> Dictionary:
	if not is_active_and_valid():
		return _result(false, "SESSION_NOT_ACTIVE")
	var guard := _verify_hidden_guard(game_state)
	if String(guard.get("code", "")) != "OK":
		return guard
	if not game_state.has_method("export_validation_runtime_snapshot"):
		return _result(false, "MISSING_GAME_STATE_ADAPTER")

	var previous_snapshot := _runtime_snapshot.duplicate(true)
	var previous_revision := _revision
	var previous_updated := _updated_at_utc
	_runtime_snapshot = game_state.export_validation_runtime_snapshot()
	_revision += 1
	_updated_at_utc = Time.get_datetime_string_from_system(true, true)
	var written := _repository.write_payload(_build_payload())
	if String(written.get("code", "")) != "OK":
		_runtime_snapshot = previous_snapshot
		_revision = previous_revision
		_updated_at_utc = previous_updated
	return written


func load(game_state: Object) -> Dictionary:
	if _mode == MODE_VALIDATION:
		return _result(false, "SESSION_ALREADY_ACTIVE")
	if game_state == null or not game_state.has_method("restore_validation_runtime_snapshot") or not game_state.has_method("snapshot_hidden_legacy_state_for_test"):
		return _result(false, "MISSING_GAME_STATE_ADAPTER")
	var read_result := _repository.read_payload()
	if String(read_result.get("code", "")) != "EXACT":
		return read_result

	var previous_state := _capture_memory_state()
	var applied := _apply_payload(read_result.get("payload", {}) as Dictionary)
	if String(applied.get("code", "")) != "OK":
		_restore_memory_state(previous_state)
		return applied

	var hidden_before: Dictionary = game_state.snapshot_hidden_legacy_state_for_test()
	var restored: Dictionary = game_state.restore_validation_runtime_snapshot(_runtime_snapshot)
	if String(restored.get("code", "")) != "OK":
		_restore_memory_state(previous_state)
		return _result(false, "RESTORE_FAILED", {"restore_code": restored.get("code", "UNKNOWN")})
	var hidden_after: Dictionary = game_state.snapshot_hidden_legacy_state_for_test()
	if not _semantic_equal(hidden_before, hidden_after):
		_restore_memory_state(previous_state)
		return _result(false, "HIDDEN_STATE_GUARD_VIOLATION")

	_legacy_guard_snapshot = hidden_after.duplicate(true)
	_mode = MODE_VALIDATION if _lifecycle == LIFECYCLE_ACTIVE else MODE_INACTIVE
	return _result(true, "OK")


func suspend(game_state: Object) -> Dictionary:
	if not is_active_and_valid():
		return _result(false, "SESSION_NOT_ACTIVE")
	var guard := _verify_hidden_guard(game_state)
	if String(guard.get("code", "")) != "OK":
		return guard
	if not game_state.has_method("export_validation_runtime_snapshot"):
		return _result(false, "MISSING_GAME_STATE_ADAPTER")

	var previous_state := _capture_memory_state()
	_runtime_snapshot = game_state.export_validation_runtime_snapshot()
	_lifecycle = LIFECYCLE_SUSPENDED
	_revision += 1
	_updated_at_utc = Time.get_datetime_string_from_system(true, true)
	var written := _repository.write_payload(_build_payload())
	if String(written.get("code", "")) == "OK":
		_mode = MODE_INACTIVE
	else:
		_restore_memory_state(previous_state)
	return written


func resume(game_state: Object) -> Dictionary:
	if _mode == MODE_VALIDATION:
		return _result(false, "SESSION_ALREADY_ACTIVE")
	if _lifecycle != LIFECYCLE_SUSPENDED:
		return _result(false, "INVALID_LIFECYCLE")
	if game_state == null or not game_state.has_method("snapshot_hidden_legacy_state_for_test"):
		return _result(false, "MISSING_GAME_STATE_ADAPTER")
	_lifecycle = LIFECYCLE_ACTIVE
	_mode = MODE_VALIDATION
	_legacy_guard_snapshot = game_state.snapshot_hidden_legacy_state_for_test()
	return _result(true, "OK")


func complete(payload: Dictionary, game_state: Object) -> Dictionary:
	if _lifecycle == LIFECYCLE_COMPLETED:
		return _result(false, "ALREADY_COMPLETED")
	if not is_active_and_valid():
		return _result(false, "SESSION_NOT_ACTIVE")
	if String(payload.get("effect_id", "")) != COMPLETION_EFFECT_ID:
		return _result(false, "INVALID_PAYLOAD")
	var guard := _verify_hidden_guard(game_state)
	if String(guard.get("code", "")) != "OK":
		return guard
	if not game_state.has_method("export_validation_runtime_snapshot"):
		return _result(false, "MISSING_GAME_STATE_ADAPTER")

	var previous_state := _capture_memory_state()
	_applied_effect_ids[COMPLETION_EFFECT_ID] = true
	_lifecycle = LIFECYCLE_COMPLETED
	_completed_at_utc = Time.get_datetime_string_from_system(true, true)
	_updated_at_utc = _completed_at_utc
	_runtime_snapshot = game_state.export_validation_runtime_snapshot()
	_revision += 1
	var written := _repository.write_payload(_build_payload())
	if String(written.get("code", "")) == "OK":
		_mode = MODE_INACTIVE
	else:
		_restore_memory_state(previous_state)
	return written


func abandon_runtime() -> Dictionary:
	_mode = MODE_INACTIVE
	_reset_memory()
	return _result(true, "OK")


func delete_persistence() -> Dictionary:
	if _mode == MODE_VALIDATION:
		return _result(false, "SESSION_ALREADY_ACTIVE")
	var result := _repository.delete_persistence()
	if String(result.get("code", "")) == "OK":
		_reset_memory()
	return result


func deactivate() -> Dictionary:
	_mode = MODE_INACTIVE
	return _result(true, "OK")


func invalidate_token_for_test() -> void:
	_session_token = ""


func _build_payload() -> Dictionary:
	return {
		"format": FORMAT_ID,
		"version": SAVE_VERSION,
		"payload_schema": PAYLOAD_SCHEMA,
		"revision": _revision,
		"session": {
			"token": _session_token,
			"lifecycle": _lifecycle,
			"episode_id": _episode_id,
			"flow_stage": _flow_stage,
			"checkpoint_id": _checkpoint_id,
			"return_target": _return_target,
			"focus_token": _focus_token
		},
		"snapshots": {
			"runtime": _runtime_snapshot.duplicate(true),
			"preparation": _preparation_snapshot.duplicate(true),
			"reasoning": _reasoning_state.duplicate(true),
			"route": _route_state.duplicate(true),
			"recovery": _recovery_progress.duplicate(true)
		},
		"result": {
			"axes": _result_axes.duplicate(true),
			"candidate_records": _candidate_records.duplicate(true),
			"applied_effect_ids": _applied_effect_ids.duplicate(true)
		},
		"timestamps": {
			"created_at_utc": _created_at_utc,
			"updated_at_utc": _updated_at_utc,
			"completed_at_utc": _completed_at_utc
		},
		"integrity": {"content_episode_id": _episode_id}
	}


func _apply_payload(payload: Dictionary) -> Dictionary:
	if String(payload.get("format", "")) != FORMAT_ID or String(payload.get("version", "")) != SAVE_VERSION:
		return _result(false, "CORRUPT_SCHEMA")
	if int(payload.get("payload_schema", 0)) != PAYLOAD_SCHEMA or int(payload.get("revision", -1)) < 0:
		return _result(false, "CORRUPT_SCHEMA")

	var session_value: Variant = payload.get("session")
	var snapshots_value: Variant = payload.get("snapshots")
	var result_value: Variant = payload.get("result")
	var timestamps_value: Variant = payload.get("timestamps")
	var integrity_value: Variant = payload.get("integrity")
	if typeof(session_value) != TYPE_DICTIONARY or typeof(snapshots_value) != TYPE_DICTIONARY or typeof(result_value) != TYPE_DICTIONARY or typeof(timestamps_value) != TYPE_DICTIONARY or typeof(integrity_value) != TYPE_DICTIONARY:
		return _result(false, "CORRUPT_SCHEMA")

	var session := session_value as Dictionary
	var snapshots := snapshots_value as Dictionary
	var result := result_value as Dictionary
	var timestamps := timestamps_value as Dictionary
	var integrity := integrity_value as Dictionary
	var token := String(session.get("token", ""))
	var episode_id := String(session.get("episode_id", ""))
	var lifecycle := String(session.get("lifecycle", ""))
	if token.is_empty():
		return _result(false, "CORRUPT_SCHEMA", {"field": "session.token"})
	if not ALLOWED_EPISODES.has(episode_id):
		return _result(false, "INVALID_EPISODE")
	if String(integrity.get("content_episode_id", "")) != episode_id:
		return _result(false, "INCOMPATIBLE_CONTENT")
	if lifecycle not in [LIFECYCLE_ACTIVE, LIFECYCLE_SUSPENDED, LIFECYCLE_COMPLETED]:
		return _result(false, "INVALID_LIFECYCLE")
	for key in ["runtime", "preparation", "reasoning", "route", "recovery"]:
		if typeof(snapshots.get(key)) != TYPE_DICTIONARY:
			return _result(false, "CORRUPT_SCHEMA", {"field": "snapshots.%s" % key})
	for key in ["axes", "candidate_records", "applied_effect_ids"]:
		if typeof(result.get(key)) != TYPE_DICTIONARY:
			return _result(false, "CORRUPT_SCHEMA", {"field": "result.%s" % key})

	_session_token = token
	_episode_id = episode_id
	_lifecycle = lifecycle
	_flow_stage = String(session.get("flow_stage", ""))
	_checkpoint_id = String(session.get("checkpoint_id", ""))
	_return_target = String(session.get("return_target", ""))
	_focus_token = String(session.get("focus_token", ""))
	_runtime_snapshot = (snapshots.get("runtime") as Dictionary).duplicate(true)
	_preparation_snapshot = (snapshots.get("preparation") as Dictionary).duplicate(true)
	_reasoning_state = (snapshots.get("reasoning") as Dictionary).duplicate(true)
	_route_state = (snapshots.get("route") as Dictionary).duplicate(true)
	_recovery_progress = (snapshots.get("recovery") as Dictionary).duplicate(true)
	_result_axes = (result.get("axes") as Dictionary).duplicate(true)
	_candidate_records = (result.get("candidate_records") as Dictionary).duplicate(true)
	_applied_effect_ids = (result.get("applied_effect_ids") as Dictionary).duplicate(true)
	_created_at_utc = String(timestamps.get("created_at_utc", ""))
	_updated_at_utc = String(timestamps.get("updated_at_utc", ""))
	_completed_at_utc = String(timestamps.get("completed_at_utc", ""))
	_revision = int(payload.get("revision", 0))
	return _result(true, "OK")


func _verify_hidden_guard(game_state: Object) -> Dictionary:
	if game_state == null or not game_state.has_method("snapshot_hidden_legacy_state_for_test"):
		return _result(false, "MISSING_GAME_STATE_ADAPTER")
	var current: Dictionary = game_state.snapshot_hidden_legacy_state_for_test()
	if _legacy_guard_snapshot.is_empty():
		_legacy_guard_snapshot = current.duplicate(true)
		return _result(true, "OK")
	return _result(
		_semantic_equal(current, _legacy_guard_snapshot),
		"OK" if _semantic_equal(current, _legacy_guard_snapshot) else "HIDDEN_STATE_GUARD_VIOLATION"
	)


func _reset_memory() -> void:
	_mode = MODE_INACTIVE
	_lifecycle = LIFECYCLE_EMPTY
	_session_token = ""
	_episode_id = ""
	_flow_stage = "SIT-001"
	_checkpoint_id = ""
	_return_target = ""
	_focus_token = ""
	_runtime_snapshot.clear()
	_preparation_snapshot.clear()
	_reasoning_state.clear()
	_route_state.clear()
	_recovery_progress.clear()
	_result_axes.clear()
	_candidate_records.clear()
	_applied_effect_ids.clear()
	_legacy_guard_snapshot.clear()
	_created_at_utc = ""
	_updated_at_utc = ""
	_completed_at_utc = ""
	_revision = 0


func _capture_memory_state() -> Dictionary:
	return {
		"mode": _mode,
		"lifecycle": _lifecycle,
		"session_token": _session_token,
		"episode_id": _episode_id,
		"flow_stage": _flow_stage,
		"checkpoint_id": _checkpoint_id,
		"return_target": _return_target,
		"focus_token": _focus_token,
		"runtime_snapshot": _runtime_snapshot.duplicate(true),
		"preparation_snapshot": _preparation_snapshot.duplicate(true),
		"reasoning_state": _reasoning_state.duplicate(true),
		"route_state": _route_state.duplicate(true),
		"recovery_progress": _recovery_progress.duplicate(true),
		"result_axes": _result_axes.duplicate(true),
		"candidate_records": _candidate_records.duplicate(true),
		"applied_effect_ids": _applied_effect_ids.duplicate(true),
		"legacy_guard_snapshot": _legacy_guard_snapshot.duplicate(true),
		"created_at_utc": _created_at_utc,
		"updated_at_utc": _updated_at_utc,
		"completed_at_utc": _completed_at_utc,
		"revision": _revision
	}


func _restore_memory_state(state: Dictionary) -> void:
	_mode = String(state.get("mode", MODE_INACTIVE))
	_lifecycle = String(state.get("lifecycle", LIFECYCLE_EMPTY))
	_session_token = String(state.get("session_token", ""))
	_episode_id = String(state.get("episode_id", ""))
	_flow_stage = String(state.get("flow_stage", "SIT-001"))
	_checkpoint_id = String(state.get("checkpoint_id", ""))
	_return_target = String(state.get("return_target", ""))
	_focus_token = String(state.get("focus_token", ""))
	_runtime_snapshot = (state.get("runtime_snapshot", {}) as Dictionary).duplicate(true)
	_preparation_snapshot = (state.get("preparation_snapshot", {}) as Dictionary).duplicate(true)
	_reasoning_state = (state.get("reasoning_state", {}) as Dictionary).duplicate(true)
	_route_state = (state.get("route_state", {}) as Dictionary).duplicate(true)
	_recovery_progress = (state.get("recovery_progress", {}) as Dictionary).duplicate(true)
	_result_axes = (state.get("result_axes", {}) as Dictionary).duplicate(true)
	_candidate_records = (state.get("candidate_records", {}) as Dictionary).duplicate(true)
	_applied_effect_ids = (state.get("applied_effect_ids", {}) as Dictionary).duplicate(true)
	_legacy_guard_snapshot = (state.get("legacy_guard_snapshot", {}) as Dictionary).duplicate(true)
	_created_at_utc = String(state.get("created_at_utc", ""))
	_updated_at_utc = String(state.get("updated_at_utc", ""))
	_completed_at_utc = String(state.get("completed_at_utc", ""))
	_revision = int(state.get("revision", 0))


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
	var result := {"ok": ok, "code": code}
	for key in details.keys():
		result[key] = details[key]
	return result


# Compatibility aliases for the initial integration wrapper; canonical callers use the APIs above.
func is_routing_to_validation() -> bool:
	return requires_save_routing()


func is_active_contract_valid() -> bool:
	return is_active_and_valid()


func save_active_session(game_state: Object) -> Dictionary:
	return save(game_state)


func invalidate_active_contract_for_test() -> void:
	invalidate_token_for_test()


func deactivate_session() -> void:
	deactivate()
