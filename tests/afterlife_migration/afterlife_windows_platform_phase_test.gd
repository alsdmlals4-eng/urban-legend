extends SceneTree

const TransactionScript := preload("res://scripts/core/afterlife_migration_transaction.gd")

var _failures: Array[String] = []


func _init() -> void:
	var args := _parse_args(OS.get_cmdline_user_args())
	var mode := String(args.get("mode", ""))
	var primary := String(args.get("primary", ""))
	_expect(not primary.is_empty(), "primary path missing")
	if primary.is_empty():
		_finish()
		return

	match mode:
		"hold_prepared":
			_hold_prepared(primary)
		"recover_prepared":
			_recover_prepared(primary)
		"hold_pending":
			_hold_pending(primary)
		"recover_pending":
			_recover_pending(primary)
		"source_changed":
			_source_changed(primary)
		"write_failed":
			_write_failed(primary, true)
		"write_acl":
			_write_failed(primary, false)
		_:
			_failures.append("unknown mode: %s" % mode)
	_finish()


func _hold_prepared(primary: String) -> void:
	var transaction = TransactionScript.new()
	var prepared: Dictionary = transaction.prepare(
		primary,
		{"source_checksum": _sha256(FileAccess.get_file_as_bytes(primary))},
		_target_payload(),
		Callable(self, "_validate_target")
	)
	_expect(String(prepared.get("state", "")) == "PREPARED", "prepare did not reach PREPARED")
	if _failures.is_empty():
		print("WINDOWS PLATFORM PHASE: PREPARED")
		OS.delay_msec(300000)


func _recover_prepared(primary: String) -> void:
	var recovered: Dictionary = TransactionScript.new().recover_pending(primary)
	_expect(String(recovered.get("state", "")) == "ABORTED", "PREPARED recovery did not abort")
	_expect(String(recovered.get("code", "")) == "ABORTED", "PREPARED recovery code mismatch")


func _hold_pending(primary: String) -> void:
	var transaction = TransactionScript.new()
	var prepared: Dictionary = transaction.prepare(
		primary,
		{"source_checksum": _sha256(FileAccess.get_file_as_bytes(primary))},
		_target_payload(),
		Callable(self, "_validate_target")
	)
	_expect(String(prepared.get("state", "")) == "PREPARED", "pending fixture prepare failed")
	if not _failures.is_empty():
		return
	var committed: Dictionary = transaction.commit_prepared(prepared)
	_expect(
		String(committed.get("state", "")) == "COMMITTED_PENDING_RUNTIME_APPLY",
		"commit did not reach COMMITTED_PENDING_RUNTIME_APPLY"
	)
	if _failures.is_empty():
		print("WINDOWS PLATFORM PHASE: COMMITTED_PENDING_RUNTIME_APPLY")
		OS.delay_msec(300000)


func _recover_pending(primary: String) -> void:
	var recovered: Dictionary = TransactionScript.new().recover_pending(primary)
	_expect(String(recovered.get("state", "")) == "ROLLBACK_RESTORED", "pending recovery did not roll back")
	_expect(String(recovered.get("code", "")) == "ROLLBACK_RESTORED", "pending recovery code mismatch")


func _source_changed(primary: String) -> void:
	var stale_checksum := _sha256(FileAccess.get_file_as_bytes(primary))
	var payload := _read_dictionary(primary)
	payload["external_change"] = true
	_write_dictionary(primary, payload)
	var result: Dictionary = TransactionScript.new().prepare(
		primary,
		{"source_checksum": stale_checksum},
		_target_payload(),
		Callable(self, "_validate_target")
	)
	_expect(String(result.get("code", "")) == "SOURCE_CHANGED", "source race was accepted")


func _write_failed(primary: String, inject_failure: bool) -> void:
	var transaction = TransactionScript.new()
	if inject_failure:
		transaction.configure_failure_for_test("write_temp")
	var result: Dictionary = transaction.prepare(
		primary,
		{"source_checksum": _sha256(FileAccess.get_file_as_bytes(primary))},
		_target_payload(),
		Callable(self, "_validate_target")
	)
	_expect(String(result.get("code", "")) == "WRITE_FAILED", "write failure was not surfaced")


func _target_payload() -> Dictionary:
	return {
		"save_version": "mvp-040",
		"episode_id": "episode_001_afterlife_station",
		"content_contract_id": "afterlife-station-canon-v2",
		"afterlife_canon_v2": {"manual": {"filled_slots": {}, "evidence_records": []}},
		"migration_history": [{"migration_id": "afterlife-station-canon-v2-001"}]
	}


func _validate_target(payload: Dictionary) -> bool:
	return (
		String(payload.get("save_version", "")) == "mvp-040"
		and String(payload.get("content_contract_id", "")) == "afterlife-station-canon-v2"
		and typeof(payload.get("migration_history")) == TYPE_ARRAY
	)


func _parse_args(values: PackedStringArray) -> Dictionary:
	var result := {}
	var index := 0
	while index < values.size():
		var key := String(values[index])
		if key.begins_with("--") and index + 1 < values.size():
			result[key.trim_prefix("--")] = String(values[index + 1])
			index += 2
		else:
			index += 1
	return result


func _read_dictionary(path: String) -> Dictionary:
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	return parsed as Dictionary if typeof(parsed) == TYPE_DICTIONARY else {}


func _write_dictionary(path: String, payload: Dictionary) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	_expect(file != null, "failed to mutate source fixture")
	if file != null:
		file.store_string(JSON.stringify(payload, "\t", false))
		file.flush()
		file.close()


func _sha256(bytes: PackedByteArray) -> String:
	var context := HashingContext.new()
	if context.start(HashingContext.HASH_SHA256) != OK:
		return ""
	if context.update(bytes) != OK:
		return ""
	return context.finish().hex_encode()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("AFTERLIFE WINDOWS PLATFORM PHASE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
