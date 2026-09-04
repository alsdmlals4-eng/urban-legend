class_name AfterlifeMigrationTransaction
extends RefCounted


const MIGRATION_ID := "afterlife-station-canon-v2-001"
const STATE_NEW := "NEW"
const STATE_PREPARED := "PREPARED"
const STATE_PENDING := "COMMITTED_PENDING_RUNTIME_APPLY"
const STATE_FINALIZED := "FINALIZED"
const STATE_ABORTED := "ABORTED"
const STATE_ROLLBACK := "ROLLBACK_RESTORED"
const FATAL_CODE := "MIGRATION_FATAL_RECOVERY_REQUIRED"

var _failure_stage := ""


func configure_failure_for_test(stage: String) -> void:
	_failure_stage = stage


func prepare(
	primary_path: String,
	inspected: Dictionary,
	target_payload: Dictionary,
	validator: Callable
) -> Dictionary:
	var paths := _paths(primary_path)
	if FileAccess.file_exists(paths.journal):
		return _result(false, "RECOVERY_REQUIRED", {"state": STATE_NEW, "journal_path": paths.journal})
	_cleanup_paths([paths.temp, paths.backup, paths.old])
	if not FileAccess.file_exists(primary_path):
		return _result(false, "READ_FAILED", {"state": STATE_NEW})

	var source_bytes := FileAccess.get_file_as_bytes(primary_path)
	var source_checksum := String(inspected.get("source_checksum", ""))
	if source_checksum.is_empty() or _sha256(source_bytes) != source_checksum:
		return _result(false, "SOURCE_CHANGED", {"state": STATE_NEW})
	if not _validator_accepts(validator, target_payload):
		return _result(false, "MIGRATION_VALIDATION_FAILED", {"state": STATE_NEW})

	var target_text := JSON.stringify(target_payload, "\t", false)
	var target_bytes := target_text.to_utf8_buffer()
	if _failure_stage == "write_temp" or not _write_bytes(paths.temp, target_bytes):
		_cleanup_paths([paths.temp, paths.backup, paths.old])
		return _result(false, "WRITE_FAILED", {"state": STATE_NEW})

	var temp_payload := _read_dictionary(paths.temp)
	var temp_bytes := FileAccess.get_file_as_bytes(paths.temp) if FileAccess.file_exists(paths.temp) else PackedByteArray()
	if temp_payload.is_empty() or not _validator_accepts(validator, temp_payload):
		_cleanup_paths([paths.temp, paths.backup, paths.old])
		return _result(false, "MIGRATION_VALIDATION_FAILED", {"state": STATE_NEW})
	var target_checksum := _sha256(temp_bytes)
	if target_checksum.is_empty():
		_cleanup_paths([paths.temp, paths.backup, paths.old])
		return _result(false, "VERIFY_FAILED", {"state": STATE_NEW})

	if _failure_stage == "write_backup" or not _write_bytes(paths.backup, source_bytes):
		_cleanup_paths([paths.temp, paths.backup, paths.old])
		return _result(false, "WRITE_FAILED", {"state": STATE_NEW, "phase": "backup"})
	if _sha256(FileAccess.get_file_as_bytes(paths.backup)) != source_checksum:
		_cleanup_paths([paths.temp, paths.backup, paths.old])
		return _result(false, "VERIFY_FAILED", {"state": STATE_NEW, "phase": "backup"})

	var handle := {
		"ok": true,
		"code": STATE_PREPARED,
		"transaction_id": "afterlife-v2-%s" % str(Time.get_ticks_usec()),
		"state": STATE_PREPARED,
		"primary_path": primary_path,
		"temp_path": paths.temp,
		"backup_path": paths.backup,
		"old_path": paths.old,
		"journal_path": paths.journal,
		"source_checksum": source_checksum,
		"target_checksum": target_checksum,
		"migration_id": MIGRATION_ID,
		"created_at_utc": Time.get_datetime_string_from_system(true, true)
	}
	if not _write_journal(handle):
		_cleanup_paths([paths.temp, paths.backup, paths.old, paths.journal])
		return _result(false, "WRITE_FAILED", {"state": STATE_NEW, "phase": "journal"})
	return handle


func commit_prepared(handle: Dictionary) -> Dictionary:
	var current := handle.duplicate(true)
	if String(current.get("state", "")) != STATE_PREPARED:
		return _result(false, "INVALID_TRANSACTION_STATE", {"state": String(current.get("state", STATE_NEW))})
	if not _handle_matches_journal(current):
		return _fatal(current, "journal_mismatch")

	var primary_path := String(current.get("primary_path", ""))
	var temp_path := String(current.get("temp_path", ""))
	var backup_path := String(current.get("backup_path", ""))
	var old_path := String(current.get("old_path", ""))
	var source_checksum := String(current.get("source_checksum", ""))
	var target_checksum := String(current.get("target_checksum", ""))
	if not FileAccess.file_exists(primary_path) or _sha256(FileAccess.get_file_as_bytes(primary_path)) != source_checksum:
		current["ok"] = false
		current["code"] = "SOURCE_CHANGED"
		return current
	if not FileAccess.file_exists(temp_path) or _sha256(FileAccess.get_file_as_bytes(temp_path)) != target_checksum:
		current["ok"] = false
		current["code"] = "VERIFY_FAILED"
		return current
	if not FileAccess.file_exists(backup_path) or _sha256(FileAccess.get_file_as_bytes(backup_path)) != source_checksum:
		return _fatal(current, "backup_mismatch")
	if _failure_stage == "promote_temp":
		current["ok"] = false
		current["code"] = "REPLACE_FAILED"
		current["phase"] = "promote_temp"
		return current

	_cleanup_paths([old_path])
	var primary_abs := ProjectSettings.globalize_path(primary_path)
	var temp_abs := ProjectSettings.globalize_path(temp_path)
	var old_abs := ProjectSettings.globalize_path(old_path)
	var move_old_error := DirAccess.rename_absolute(primary_abs, old_abs)
	if move_old_error != OK:
		current["ok"] = false
		current["code"] = "REPLACE_FAILED"
		current["phase"] = "stage_old_primary"
		current["error"] = move_old_error
		return current
	var promote_error := DirAccess.rename_absolute(temp_abs, primary_abs)
	if promote_error != OK:
		DirAccess.rename_absolute(old_abs, primary_abs)
		current["ok"] = false
		current["code"] = "REPLACE_FAILED"
		current["phase"] = "promote_temp"
		current["error"] = promote_error
		return current

	if _failure_stage == "final_readback" or _sha256(FileAccess.get_file_as_bytes(primary_path)) != target_checksum:
		_remove_path(primary_path)
		if FileAccess.file_exists(old_path):
			DirAccess.rename_absolute(old_abs, primary_abs)
		current["ok"] = false
		current["code"] = "VERIFY_FAILED"
		current["phase"] = "final_readback"
		return current

	current["ok"] = true
	current["code"] = STATE_PENDING
	current["state"] = STATE_PENDING
	current["committed_at_utc"] = Time.get_datetime_string_from_system(true, true)
	if not _write_journal(current):
		_remove_path(primary_path)
		if FileAccess.file_exists(old_path):
			DirAccess.rename_absolute(old_abs, primary_abs)
		return _fatal(current, "pending_journal_write_failed")
	_cleanup_paths([old_path])
	return current


func finalize(handle: Dictionary) -> Dictionary:
	var current := handle.duplicate(true)
	if String(current.get("state", "")) != STATE_PENDING:
		return _result(false, "INVALID_TRANSACTION_STATE", {"state": String(current.get("state", STATE_NEW))})
	var primary_path := String(current.get("primary_path", ""))
	if not FileAccess.file_exists(primary_path) or _sha256(FileAccess.get_file_as_bytes(primary_path)) != String(current.get("target_checksum", "")):
		return _fatal(current, "finalize_target_mismatch")
	current["ok"] = true
	current["code"] = STATE_FINALIZED
	current["state"] = STATE_FINALIZED
	current["finalized_at_utc"] = Time.get_datetime_string_from_system(true, true)
	if not _write_journal(current):
		return _fatal(current, "finalize_journal_write_failed")
	_cleanup_paths([
		String(current.get("temp_path", "")),
		String(current.get("backup_path", "")),
		String(current.get("old_path", "")),
		String(current.get("journal_path", ""))
	])
	return current


func rollback_last_commit(handle: Dictionary) -> Dictionary:
	var current := handle.duplicate(true)
	if String(current.get("state", "")) != STATE_PENDING:
		return _result(false, "INVALID_TRANSACTION_STATE", {"state": String(current.get("state", STATE_NEW))})
	var primary_path := String(current.get("primary_path", ""))
	var backup_path := String(current.get("backup_path", ""))
	var old_path := String(current.get("old_path", ""))
	var source_checksum := String(current.get("source_checksum", ""))
	if not FileAccess.file_exists(backup_path) or _sha256(FileAccess.get_file_as_bytes(backup_path)) != source_checksum:
		return _fatal(current, "rollback_backup_mismatch")

	_cleanup_paths([old_path])
	var primary_abs := ProjectSettings.globalize_path(primary_path)
	var backup_abs := ProjectSettings.globalize_path(backup_path)
	var old_abs := ProjectSettings.globalize_path(old_path)
	if FileAccess.file_exists(primary_path):
		var move_target_error := DirAccess.rename_absolute(primary_abs, old_abs)
		if move_target_error != OK:
			return _fatal(current, "rollback_stage_target_failed")
	var restore_error := DirAccess.rename_absolute(backup_abs, primary_abs)
	if restore_error != OK:
		if FileAccess.file_exists(old_path) and not FileAccess.file_exists(primary_path):
			DirAccess.rename_absolute(old_abs, primary_abs)
		return _fatal(current, "rollback_restore_failed")
	if _sha256(FileAccess.get_file_as_bytes(primary_path)) != source_checksum:
		return _fatal(current, "rollback_readback_mismatch")

	current["ok"] = true
	current["code"] = STATE_ROLLBACK
	current["state"] = STATE_ROLLBACK
	current["rolled_back_at_utc"] = Time.get_datetime_string_from_system(true, true)
	_write_journal(current)
	_cleanup_paths([
		String(current.get("temp_path", "")),
		String(current.get("backup_path", "")),
		old_path,
		String(current.get("journal_path", ""))
	])
	return current


func abort_prepared(handle: Dictionary) -> Dictionary:
	var current := handle.duplicate(true)
	if String(current.get("state", "")) != STATE_PREPARED:
		return _result(false, "INVALID_TRANSACTION_STATE", {"state": String(current.get("state", STATE_NEW))})
	var primary_path := String(current.get("primary_path", ""))
	var source_checksum := String(current.get("source_checksum", ""))
	if not FileAccess.file_exists(primary_path) or _sha256(FileAccess.get_file_as_bytes(primary_path)) != source_checksum:
		return _fatal(current, "abort_source_mismatch")
	current["ok"] = true
	current["code"] = STATE_ABORTED
	current["state"] = STATE_ABORTED
	current["aborted_at_utc"] = Time.get_datetime_string_from_system(true, true)
	_cleanup_paths([
		String(current.get("temp_path", "")),
		String(current.get("backup_path", "")),
		String(current.get("old_path", "")),
		String(current.get("journal_path", ""))
	])
	return current


func recover_pending(primary_path: String) -> Dictionary:
	var paths := _paths(primary_path)
	if not FileAccess.file_exists(paths.journal):
		return _result(true, "NO_PENDING_TRANSACTION", {"state": STATE_NEW})
	var journal := _read_dictionary(paths.journal)
	if journal.is_empty() or String(journal.get("primary_path", "")) != primary_path:
		return _fatal({"primary_path": primary_path, "journal_path": paths.journal}, "corrupt_journal")
	var state := String(journal.get("state", ""))
	match state:
		STATE_PREPARED:
			if not FileAccess.file_exists(primary_path):
				return _fatal(journal, "prepared_primary_missing")
			var current_checksum := _sha256(FileAccess.get_file_as_bytes(primary_path))
			if current_checksum == String(journal.get("source_checksum", "")):
				return abort_prepared(journal)
			if current_checksum == String(journal.get("target_checksum", "")):
				journal["state"] = STATE_PENDING
				return rollback_last_commit(journal)
			return _fatal(journal, "prepared_primary_unknown")
		STATE_PENDING:
			return rollback_last_commit(journal)
		STATE_FINALIZED:
			if not FileAccess.file_exists(primary_path) or _sha256(FileAccess.get_file_as_bytes(primary_path)) != String(journal.get("target_checksum", "")):
				return _fatal(journal, "finalized_target_mismatch")
			_cleanup_paths([paths.temp, paths.backup, paths.old, paths.journal])
			journal["ok"] = true
			journal["code"] = STATE_FINALIZED
			return journal
		_:
			return _fatal(journal, "unknown_journal_state")


func _validator_accepts(validator: Callable, payload: Dictionary) -> bool:
	if not validator.is_valid():
		return false
	var result: Variant = validator.call(payload.duplicate(true))
	if typeof(result) == TYPE_BOOL:
		return bool(result)
	if typeof(result) == TYPE_DICTIONARY:
		var dictionary := result as Dictionary
		return bool(dictionary.get("ok", false)) or String(dictionary.get("code", "")) in ["OK", "EXACT"]
	return false


func _handle_matches_journal(handle: Dictionary) -> bool:
	var journal_path := String(handle.get("journal_path", ""))
	if not FileAccess.file_exists(journal_path):
		return false
	var journal := _read_dictionary(journal_path)
	return (
		String(journal.get("transaction_id", "")) == String(handle.get("transaction_id", ""))
		and String(journal.get("state", "")) == String(handle.get("state", ""))
	)


func _write_journal(handle: Dictionary) -> bool:
	var journal_path := String(handle.get("journal_path", ""))
	if journal_path.is_empty() or _failure_stage == "write_journal":
		return false
	return _write_bytes(journal_path, JSON.stringify(handle, "\t", false).to_utf8_buffer())


func _paths(primary_path: String) -> Dictionary:
	var stem := primary_path.trim_suffix(".json") if primary_path.ends_with(".json") else primary_path
	return {
		"temp": "%s.migration.tmp.json" % stem,
		"backup": "%s.migration.bak.json" % stem,
		"old": "%s.migration.old.json" % stem,
		"journal": "%s.migration.journal.json" % stem
	}


func _read_dictionary(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	return parsed as Dictionary if typeof(parsed) == TYPE_DICTIONARY else {}


func _write_bytes(path: String, bytes: PackedByteArray) -> bool:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return false
	file.store_buffer(bytes)
	file.flush()
	file.close()
	return FileAccess.file_exists(path) and FileAccess.get_file_as_bytes(path) == bytes


func _sha256(bytes: PackedByteArray) -> String:
	var context := HashingContext.new()
	if context.start(HashingContext.HASH_SHA256) != OK:
		return ""
	if context.update(bytes) != OK:
		return ""
	return context.finish().hex_encode()


func _cleanup_paths(paths: Array) -> void:
	for path_value in paths:
		_remove_path(String(path_value))


func _remove_path(path: String) -> Error:
	if path.is_empty() or not FileAccess.file_exists(path):
		return OK
	return DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _fatal(handle: Dictionary, reason: String) -> Dictionary:
	var result := handle.duplicate(true)
	result["ok"] = false
	result["code"] = FATAL_CODE
	result["state"] = FATAL_CODE
	result["reason"] = reason
	return result


func _result(ok: bool, code: String, extra: Dictionary = {}) -> Dictionary:
	var result := {"ok": ok, "code": code}
	for key in extra.keys():
		result[key] = extra[key]
	return result
