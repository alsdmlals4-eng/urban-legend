extends Node

const RepositoryScript := preload("res://scripts/core/validation_save_repository.gd")
const SAVE_VERSION := "validation-save-v1"
const LIFECYCLE_CREATED := "CREATED"
const LIFECYCLE_ACTIVE := "ACTIVE"
const LIFECYCLE_SUSPENDED := "SUSPENDED"
const LIFECYCLE_COMPLETED := "COMPLETED"
const LIFECYCLE_ABANDONED := "ABANDONED"

var _repository = RepositoryScript.new()
var _session: Dictionary = {}
var _active := false
var _contract_valid := false
var _activation_token := ""


func create_session(episode_id: String, stage: String, runtime_snapshot: Dictionary = {}) -> Dictionary:
	var clean_episode := episode_id.strip_edges()
	var clean_stage := stage.strip_edges()
	if clean_episode.is_empty():
		return {"ok": false, "code": "MISSING_EPISODE_ID"}
	if clean_stage.is_empty():
		return {"ok": false, "code": "MISSING_STAGE"}
	_activation_token = "%s-%s-%s" % [str(Time.get_unix_time_from_system()), str(Time.get_ticks_usec()), str(randi())]
	_session = {
		"session_id": "validation-%s" % _activation_token,
		"episode_id": clean_episode,
		"lifecycle": LIFECYCLE_CREATED,
		"stage": clean_stage,
		"checkpoint": {},
		"runtime_snapshot": runtime_snapshot.duplicate(true),
		"completion_ids": [],
		"created_at": Time.get_datetime_string_from_system(false, true),
		"updated_at": Time.get_datetime_string_from_system(false, true)
	}
	_active = false
	_contract_valid = true
	return {"ok": true, "code": "OK", "token": _activation_token}


func activate_session(token: String) -> Dictionary:
	if _session.is_empty():
		return {"ok": false, "code": "NO_SESSION"}
	if token.is_empty() or token != _activation_token:
		_contract_valid = false
		return {"ok": false, "code": "INVALID_TOKEN"}
	var lifecycle := String(_session.get("lifecycle", ""))
	if lifecycle in [LIFECYCLE_COMPLETED, LIFECYCLE_ABANDONED]:
		_contract_valid = false
		return {"ok": false, "code": "INVALID_LIFECYCLE"}
	_active = true
	_contract_valid = true
	_session["lifecycle"] = LIFECYCLE_ACTIVE
	_session["updated_at"] = Time.get_datetime_string_from_system(false, true)
	return {"ok": true, "code": "OK"}


func is_validation_active() -> bool:
	return _active


func is_routing_to_validation() -> bool:
	return _active


func is_active_contract_valid() -> bool:
	return _active and _contract_valid and not _session.is_empty() and String(_session.get("lifecycle", "")) == LIFECYCLE_ACTIVE and not String(_session.get("episode_id", "")).is_empty() and not String(_session.get("stage", "")).is_empty()


func save_active_session(game_state: Object) -> Dictionary:
	if not is_active_contract_valid():
		return {"ok": false, "code": "INVALID_ACTIVE_CONTRACT"}
	if game_state == null or not game_state.has_method("export_validation_runtime_snapshot"):
		return {"ok": false, "code": "MISSING_GAME_STATE_ADAPTER"}
	_session["runtime_snapshot"] = game_state.export_validation_runtime_snapshot()
	_session["updated_at"] = Time.get_datetime_string_from_system(false, true)
	return _repository.write_payload(build_payload())


func load_session() -> Dictionary:
	var read_result: Dictionary = _repository.read_payload()
	if not bool(read_result.get("ok", false)):
		return read_result
	var payload: Dictionary = read_result.get("payload", {})
	var session_value: Variant = payload.get("session")
	if typeof(session_value) != TYPE_DICTIONARY:
		return {"ok": false, "code": "INVALID_SESSION"}
	_session = (session_value as Dictionary).duplicate(true)
	_activation_token = ""
	_active = false
	_contract_valid = true
	return {"ok": true, "code": "OK", "session": _session.duplicate(true)}


func build_payload() -> Dictionary:
	return {
		"save_version": SAVE_VERSION,
		"session": _session.duplicate(true)
	}


func mark_completion_applied(completion_id: String) -> Dictionary:
	var clean_id := completion_id.strip_edges()
	if clean_id.is_empty():
		return {"ok": false, "applied": false, "code": "MISSING_COMPLETION_ID"}
	var ids: Array = _session.get("completion_ids", [])
	if ids.has(clean_id):
		return {"ok": true, "applied": false, "code": "ALREADY_APPLIED"}
	ids.append(clean_id)
	_session["completion_ids"] = ids
	_session["updated_at"] = Time.get_datetime_string_from_system(false, true)
	return {"ok": true, "applied": true, "code": "OK"}


func complete_session() -> Dictionary:
	if _session.is_empty():
		return {"ok": false, "code": "NO_SESSION"}
	_session["lifecycle"] = LIFECYCLE_COMPLETED
	_session["updated_at"] = Time.get_datetime_string_from_system(false, true)
	_active = false
	_contract_valid = true
	return _repository.write_payload(build_payload())


func abandon_session() -> Dictionary:
	if _session.is_empty():
		return {"ok": false, "code": "NO_SESSION"}
	_session["lifecycle"] = LIFECYCLE_ABANDONED
	_session["updated_at"] = Time.get_datetime_string_from_system(false, true)
	_active = false
	_contract_valid = true
	return _repository.write_payload(build_payload())


func deactivate_session() -> void:
	if not _session.is_empty() and String(_session.get("lifecycle", "")) == LIFECYCLE_ACTIVE:
		_session["lifecycle"] = LIFECYCLE_SUSPENDED
		_session["updated_at"] = Time.get_datetime_string_from_system(false, true)
	_active = false
	_contract_valid = true


func delete_session() -> Dictionary:
	_active = false
	_contract_valid = false
	_activation_token = ""
	_session.clear()
	return _repository.delete_validation_files()


func get_session_snapshot() -> Dictionary:
	return _session.duplicate(true)


func invalidate_active_contract_for_test() -> void:
	_contract_valid = false
