extends "res://scripts/core/validation_session.gd"


const AfterlifeInspectorScript := preload("res://scripts/core/afterlife_legacy_save_inspector.gd")
const AfterlifeRegistryScript := preload("res://scripts/data/afterlife_id_migration_registry.gd")
const AfterlifeValidationMigratorScript := preload("res://scripts/core/afterlife_validation_save_migrator.gd")
const AfterlifeTransactionScript := preload("res://scripts/core/afterlife_migration_transaction.gd")
const AFTERLIFE_REGISTRY_PATH := "res://data/migrations/afterlife_station_canon_v2_id_migration.json"
const TARGET_SAVE_VERSION := "validation-save-v2"
const TARGET_PAYLOAD_SCHEMA := 2
const TARGET_CONTENT_CONTRACT := "afterlife-station-canon-v2"
const TARGET_COMPLETION_EFFECT_ID := "validation:afterlife:completion:v2"
const LEGACY_COMPLETION_EFFECT_ID := "validation:afterlife:completion:v1"

var _legacy_validation_snapshot: Dictionary = {}
var _afterlife_v2_state: Dictionary = {}
var _migration_history: Array = []
var _last_migration_result: Dictionary = {}
var _inject_runtime_failure := false


func configure_migration_runtime_failure_for_test(enabled: bool) -> void:
	_inject_runtime_failure = enabled


func get_last_migration_result() -> Dictionary:
	return _last_migration_result.duplicate(true)


func load(game_state: Object) -> Dictionary:
	if _mode == MODE_VALIDATION:
		return _result(false, "SESSION_ALREADY_ACTIVE")
	if game_state == null or not game_state.has_method("restore_validation_runtime_snapshot") or not game_state.has_method("snapshot_hidden_legacy_state_for_test"):
		return _result(false, "MISSING_GAME_STATE_ADAPTER")
	var primary_path := _get_primary_path()
	if primary_path.is_empty() or not FileAccess.file_exists(primary_path):
		return _result(false, "EMPTY")
	var pending_recovery := AfterlifeTransactionScript.new().recover_pending(primary_path)
	if String(pending_recovery.get("code", "")) == "MIGRATION_FATAL_RECOVERY_REQUIRED":
		_last_migration_result = pending_recovery.duplicate(true)
		return pending_recovery
	var source_payload := _read_dictionary(primary_path)
	if source_payload.is_empty():
		return _result(false, "CORRUPT_SCHEMA")
	var source_version := String(source_payload.get("version", ""))
	if source_version == TARGET_SAVE_VERSION:
		return _apply_and_restore_v2(source_payload, game_state, null, {})
	if source_version != "validation-save-v1":
		return _result(false, "CORRUPT_SCHEMA")

	var source_bytes := FileAccess.get_file_as_bytes(primary_path)
	var inspector = AfterlifeInspectorScript.new()
	var inspected: Dictionary = inspector.inspect_validation_bytes(source_bytes)
	if String(inspected.get("code", "")) != "MIGRATABLE_VALIDATION":
		_last_migration_result = inspected.duplicate(true)
		return inspected
	var registry = AfterlifeRegistryScript.new()
	var registry_result: Dictionary = registry.load_registry(AFTERLIFE_REGISTRY_PATH)
	if String(registry_result.get("code", "")) != "EXACT":
		_last_migration_result = registry_result.duplicate(true)
		return registry_result
	var migrated: Dictionary = AfterlifeValidationMigratorScript.new().migrate(inspected, registry)
	if not bool(migrated.get("ok", false)):
		_last_migration_result = migrated.duplicate(true)
		return migrated
	var target_payload := migrated.get("payload", {}) as Dictionary
	var transaction = AfterlifeTransactionScript.new()
	var prepared: Dictionary = transaction.prepare(
		primary_path,
		inspected,
		target_payload,
		Callable(self, "_validate_v2_payload")
	)
	if String(prepared.get("state", "")) != "PREPARED":
		_last_migration_result = prepared.duplicate(true)
		return prepared
	var committed: Dictionary = transaction.commit_prepared(prepared)
	if String(committed.get("state", "")) != "COMMITTED_PENDING_RUNTIME_APPLY":
		transaction.abort_prepared(committed if String(committed.get("state", "")) == "PREPARED" else prepared)
		_last_migration_result = committed.duplicate(true)
		return committed
	if _inject_runtime_failure:
		var injected_rollback := transaction.rollback_last_commit(committed)
		_last_migration_result = injected_rollback.duplicate(true)
		return _result(false, "RESTORE_FAILED", {"restore_code": "INJECTED_RUNTIME_APPLY_FAILURE"})
	return _apply_and_restore_v2(target_payload, game_state, transaction, committed)


func save(game_state: Object) -> Dictionary:
	if not is_active_and_valid():
		return _result(false, "SESSION_NOT_ACTIVE")
	var guard := _verify_hidden_guard(game_state)
	if String(guard.get("code", "")) != "OK":
		return guard
	if not game_state.has_method("export_validation_runtime_snapshot"):
		return _result(false, "MISSING_GAME_STATE_ADAPTER")
	var previous_state := _capture_memory_state()
	_runtime_snapshot = game_state.export_validation_runtime_snapshot()
	_revision += 1
	_updated_at_utc = Time.get_datetime_string_from_system(true, true)
	var written := _write_v2_payload(_build_v2_payload())
	if String(written.get("code", "")) != "OK":
		_restore_memory_state(previous_state)
	return written


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
	var written := _write_v2_payload(_build_v2_payload())
	if String(written.get("code", "")) == "OK":
		_mode = MODE_INACTIVE
	else:
		_restore_memory_state(previous_state)
	return written


func complete(payload: Dictionary, game_state: Object) -> Dictionary:
	if _lifecycle == LIFECYCLE_COMPLETED:
		return _result(false, "ALREADY_COMPLETED")
	if not is_active_and_valid():
		return _result(false, "SESSION_NOT_ACTIVE")
	var requested_effect := String(payload.get("effect_id", ""))
	if requested_effect not in [TARGET_COMPLETION_EFFECT_ID, LEGACY_COMPLETION_EFFECT_ID]:
		return _result(false, "INVALID_PAYLOAD")
	var guard := _verify_hidden_guard(game_state)
	if String(guard.get("code", "")) != "OK":
		return guard
	if not game_state.has_method("export_validation_runtime_snapshot"):
		return _result(false, "MISSING_GAME_STATE_ADAPTER")
	var previous_state := _capture_memory_state()
	_applied_effect_ids[TARGET_COMPLETION_EFFECT_ID] = true
	_lifecycle = LIFECYCLE_COMPLETED
	_completed_at_utc = Time.get_datetime_string_from_system(true, true)
	_updated_at_utc = _completed_at_utc
	_runtime_snapshot = game_state.export_validation_runtime_snapshot()
	_revision += 1
	var written := _write_v2_payload(_build_v2_payload())
	if String(written.get("code", "")) == "OK":
		_mode = MODE_INACTIVE
	else:
		_restore_memory_state(previous_state)
	return written


func _apply_and_restore_v2(
	payload: Dictionary,
	game_state: Object,
	transaction: Variant,
	committed_handle: Dictionary
) -> Dictionary:
	var previous_state := _capture_memory_state()
	var hidden_before: Dictionary = game_state.snapshot_hidden_legacy_state_for_test()
	var applied := _apply_v2_payload(payload)
	if String(applied.get("code", "")) != "OK":
		_restore_memory_state(previous_state)
		if transaction != null:
			var rollback_apply: Dictionary = transaction.rollback_last_commit(committed_handle)
			_last_migration_result = rollback_apply.duplicate(true)
		return applied
	if game_state.has_method("activate_afterlife_content_contract_for_migration"):
		game_state.activate_afterlife_content_contract_for_migration(TARGET_CONTENT_CONTRACT)
	var restored: Dictionary = game_state.restore_validation_runtime_snapshot(_runtime_snapshot)
	if String(restored.get("code", "")) != "OK":
		_restore_memory_state(previous_state)
		if transaction != null:
			var rollback_restore: Dictionary = transaction.rollback_last_commit(committed_handle)
			_last_migration_result = rollback_restore.duplicate(true)
		return _result(false, "RESTORE_FAILED", {"restore_code": restored.get("code", "UNKNOWN")})
	var hidden_after: Dictionary = game_state.snapshot_hidden_legacy_state_for_test()
	if not _semantic_equal(hidden_before, hidden_after):
		_restore_memory_state(previous_state)
		if transaction != null:
			var rollback_hidden: Dictionary = transaction.rollback_last_commit(committed_handle)
			_last_migration_result = rollback_hidden.duplicate(true)
		return _result(false, "HIDDEN_STATE_GUARD_VIOLATION")
	_legacy_guard_snapshot = hidden_after.duplicate(true)
	_mode = MODE_VALIDATION if _lifecycle == LIFECYCLE_ACTIVE else MODE_INACTIVE
	if transaction != null:
		var finalized: Dictionary = transaction.finalize(committed_handle)
		_last_migration_result = finalized.duplicate(true)
		if String(finalized.get("state", "")) != "FINALIZED":
			return finalized
	return _result(true, "OK")


func _apply_v2_payload(payload: Dictionary) -> Dictionary:
	if not _validate_v2_payload(payload):
		return _result(false, "CORRUPT_SCHEMA")
	var session := payload.get("session", {}) as Dictionary
	var snapshots := payload.get("snapshots", {}) as Dictionary
	var result_block := payload.get("result", {}) as Dictionary
	var timestamps := payload.get("timestamps", {}) as Dictionary
	_session_token = String(session.get("token", ""))
	_episode_id = String(session.get("episode_id", ""))
	_lifecycle = String(session.get("lifecycle", ""))
	_flow_stage = String(session.get("flow_stage", ""))
	_checkpoint_id = String(session.get("checkpoint_id", ""))
	_return_target = String(session.get("return_target", ""))
	_focus_token = String(session.get("focus_token", ""))
	_runtime_snapshot = (snapshots.get("runtime") as Dictionary).duplicate(true)
	_preparation_snapshot = (snapshots.get("preparation") as Dictionary).duplicate(true)
	_reasoning_state = (snapshots.get("reasoning") as Dictionary).duplicate(true)
	_route_state = (snapshots.get("route") as Dictionary).duplicate(true)
	_recovery_progress = (snapshots.get("recovery") as Dictionary).duplicate(true)
	_result_axes = (result_block.get("axes") as Dictionary).duplicate(true)
	_candidate_records = (result_block.get("candidate_records") as Dictionary).duplicate(true)
	_applied_effect_ids = (result_block.get("applied_effect_ids") as Dictionary).duplicate(true)
	_created_at_utc = String(timestamps.get("created_at_utc", ""))
	_updated_at_utc = String(timestamps.get("updated_at_utc", ""))
	_completed_at_utc = String(timestamps.get("completed_at_utc", ""))
	_revision = int(payload.get("revision", 0))
	_legacy_validation_snapshot = _dictionary_copy(payload.get("legacy_validation_snapshot"))
	_afterlife_v2_state = _dictionary_copy(payload.get("afterlife_canon_v2"))
	_migration_history = _array_copy(payload.get("migration_history"))
	return _result(true, "OK")


func _build_v2_payload() -> Dictionary:
	return {
		"format": FORMAT_ID,
		"version": TARGET_SAVE_VERSION,
		"payload_schema": TARGET_PAYLOAD_SCHEMA,
		"content_contract_id": TARGET_CONTENT_CONTRACT,
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
		"integrity": {"content_episode_id": _episode_id},
		"legacy_validation_snapshot": _legacy_validation_snapshot.duplicate(true),
		"afterlife_canon_v2": _afterlife_v2_state.duplicate(true),
		"migration_history": _migration_history.duplicate(true)
	}


func _write_v2_payload(payload: Dictionary) -> Dictionary:
	if not _validate_v2_payload(payload):
		return _result(false, "CORRUPT_SCHEMA")
	var primary_path := _get_primary_path()
	if primary_path.is_empty():
		return _result(false, "WRITE_FAILED")
	if not FileAccess.file_exists(primary_path):
		return _write_new_primary(primary_path, payload)
	var source_bytes := FileAccess.get_file_as_bytes(primary_path)
	var transaction = AfterlifeTransactionScript.new()
	var prepared: Dictionary = transaction.prepare(
		primary_path,
		{"source_checksum": _sha256(source_bytes)},
		payload,
		Callable(self, "_validate_v2_payload")
	)
	if String(prepared.get("state", "")) != "PREPARED":
		return prepared
	var committed: Dictionary = transaction.commit_prepared(prepared)
	if String(committed.get("state", "")) != "COMMITTED_PENDING_RUNTIME_APPLY":
		transaction.abort_prepared(committed if String(committed.get("state", "")) == "PREPARED" else prepared)
		return committed
	var finalized := transaction.finalize(committed)
	if String(finalized.get("state", "")) != "FINALIZED":
		return finalized
	return _result(true, "OK")


func _write_new_primary(path: String, payload: Dictionary) -> Dictionary:
	var temp_path := path + ".new.tmp"
	_remove_path(temp_path)
	var file := FileAccess.open(temp_path, FileAccess.WRITE)
	if file == null:
		return _result(false, "WRITE_FAILED")
	file.store_string(JSON.stringify(payload, "\t", false))
	file.flush()
	file.close()
	if not _validate_v2_payload(_read_dictionary(temp_path)):
		_remove_path(temp_path)
		return _result(false, "VERIFY_FAILED")
	var rename_error := DirAccess.rename_absolute(ProjectSettings.globalize_path(temp_path), ProjectSettings.globalize_path(path))
	if rename_error != OK:
		_remove_path(temp_path)
		return _result(false, "REPLACE_FAILED", {"error": rename_error})
	return _result(true, "OK")


func _validate_v2_payload(payload: Dictionary) -> bool:
	if String(payload.get("format", "")) != FORMAT_ID:
		return false
	if String(payload.get("version", "")) != TARGET_SAVE_VERSION:
		return false
	if int(payload.get("payload_schema", 0)) != TARGET_PAYLOAD_SCHEMA:
		return false
	if String(payload.get("content_contract_id", "")) != TARGET_CONTENT_CONTRACT:
		return false
	if int(payload.get("revision", -1)) < 0:
		return false
	for key in ["session", "snapshots", "result", "timestamps", "integrity", "legacy_validation_snapshot", "afterlife_canon_v2"]:
		if typeof(payload.get(key)) != TYPE_DICTIONARY:
			return false
	if typeof(payload.get("migration_history")) != TYPE_ARRAY:
		return false
	var session := payload.get("session", {}) as Dictionary
	var snapshots := payload.get("snapshots", {}) as Dictionary
	var result_block := payload.get("result", {}) as Dictionary
	if String(session.get("token", "")).is_empty():
		return false
	if String(session.get("episode_id", "")) not in ALLOWED_EPISODES:
		return false
	if String(session.get("lifecycle", "")) not in [LIFECYCLE_ACTIVE, LIFECYCLE_SUSPENDED, LIFECYCLE_COMPLETED]:
		return false
	for key in ["runtime", "preparation", "reasoning", "route", "recovery"]:
		if typeof(snapshots.get(key)) != TYPE_DICTIONARY:
			return false
	for key in ["axes", "candidate_records", "applied_effect_ids"]:
		if typeof(result_block.get(key)) != TYPE_DICTIONARY:
			return false
	return String((payload.get("integrity") as Dictionary).get("content_episode_id", "")) == String(session.get("episode_id", ""))


func _get_primary_path() -> String:
	var paths := _repository.get_paths()
	return String(paths.get("primary", ""))


func _read_dictionary(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	return parsed as Dictionary if typeof(parsed) == TYPE_DICTIONARY else {}


func _dictionary_copy(value: Variant) -> Dictionary:
	return (value as Dictionary).duplicate(true) if typeof(value) == TYPE_DICTIONARY else {}


func _array_copy(value: Variant) -> Array:
	return (value as Array).duplicate(true) if typeof(value) == TYPE_ARRAY else []


func _sha256(bytes: PackedByteArray) -> String:
	var context := HashingContext.new()
	if context.start(HashingContext.HASH_SHA256) != OK:
		return ""
	if context.update(bytes) != OK:
		return ""
	return context.finish().hex_encode()


func _remove_path(path: String) -> void:
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
