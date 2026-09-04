extends SceneTree

const TRANSACTION_PATH := "res://scripts/core/afterlife_migration_transaction.gd"
const ROOT := "user://afterlife_migration_transaction_test"

var _failures: Array[String] = []
var _sequence := 0


func _init() -> void:
	_reset_root()
	_expect(FileAccess.file_exists(TRANSACTION_PATH), "migration transaction script missing")
	if FileAccess.file_exists(TRANSACTION_PATH):
		var script_value: Variant = load(TRANSACTION_PATH)
		_expect(script_value is Script, "migration transaction failed to load")
		if script_value is Script:
			var script := script_value as Script
			_test_success_finalize(script)
			_test_source_changed(script)
			_test_validator_failure(script)
			_test_abort_prepared(script)
			_test_runtime_apply_rollback(script)
			_test_crash_recovery_from_prepared(script)
			_test_crash_recovery_from_pending(script)
			_test_promote_failure_preserves_source(script)
	_reset_root()
	_finish()


func _test_success_finalize(script: Script) -> void:
	var fixture := _fixture("success")
	var transaction = script.new()
	var prepared: Dictionary = transaction.prepare(
		fixture.primary,
		{"source_checksum": _sha256(fixture.original_bytes)},
		fixture.target_payload,
		Callable(self, "_validate_target")
	)
	_expect(String(prepared.get("state", "")) == "PREPARED", "prepare did not reach PREPARED")
	_expect(_read_bytes(fixture.primary) == fixture.original_bytes, "prepare changed primary")
	_expect(FileAccess.file_exists(String(prepared.get("temp_path", ""))), "prepared temp missing")
	_expect(FileAccess.file_exists(String(prepared.get("backup_path", ""))), "prepared backup missing")
	_expect(FileAccess.file_exists(String(prepared.get("journal_path", ""))), "prepared journal missing")

	var committed: Dictionary = transaction.commit_prepared(prepared)
	_expect(String(committed.get("state", "")) == "COMMITTED_PENDING_RUNTIME_APPLY", "commit did not enter pending runtime state")
	_expect(_read_json(fixture.primary).get("save_version", "") == "mvp-040", "target primary not promoted")
	_expect(_read_bytes(String(committed.get("backup_path", ""))) == fixture.original_bytes, "immutable source backup changed")

	var finalized: Dictionary = transaction.finalize(committed)
	_expect(String(finalized.get("state", "")) == "FINALIZED", "finalize failed")
	_expect(_read_json(fixture.primary).get("save_version", "") == "mvp-040", "finalized primary changed")
	_expect(not FileAccess.file_exists(String(finalized.get("journal_path", ""))), "finalized journal not cleaned")
	_expect(not FileAccess.file_exists(String(finalized.get("backup_path", ""))), "finalized backup not cleaned")


func _test_source_changed(script: Script) -> void:
	var fixture := _fixture("source_changed")
	var inspected_checksum := _sha256(fixture.original_bytes)
	_write_json(fixture.primary, {"save_version": "mvp-039", "episode_id": "episode_001_afterlife_station", "external_change": true})
	var changed_bytes := _read_bytes(fixture.primary)
	var transaction = script.new()
	var result: Dictionary = transaction.prepare(
		fixture.primary,
		{"source_checksum": inspected_checksum},
		fixture.target_payload,
		Callable(self, "_validate_target")
	)
	_expect(String(result.get("code", "")) == "SOURCE_CHANGED", "source checksum race accepted")
	_expect(_read_bytes(fixture.primary) == changed_bytes, "source race mutated current primary")
	_expect(not _any_artifact_exists(fixture.primary), "source race left transaction artifacts")


func _test_validator_failure(script: Script) -> void:
	var fixture := _fixture("validator_failure")
	var transaction = script.new()
	var result: Dictionary = transaction.prepare(
		fixture.primary,
		{"source_checksum": _sha256(fixture.original_bytes)},
		{"save_version": "broken"},
		Callable(self, "_validate_target")
	)
	_expect(String(result.get("code", "")) == "MIGRATION_VALIDATION_FAILED", "invalid target accepted")
	_expect(_read_bytes(fixture.primary) == fixture.original_bytes, "validator failure changed primary")
	_expect(not _any_artifact_exists(fixture.primary), "validator failure left artifacts")


func _test_abort_prepared(script: Script) -> void:
	var fixture := _fixture("abort_prepared")
	var transaction = script.new()
	var prepared: Dictionary = transaction.prepare(
		fixture.primary,
		{"source_checksum": _sha256(fixture.original_bytes)},
		fixture.target_payload,
		Callable(self, "_validate_target")
	)
	var aborted: Dictionary = transaction.abort_prepared(prepared)
	_expect(String(aborted.get("state", "")) == "ABORTED", "prepared transaction did not abort")
	_expect(_read_bytes(fixture.primary) == fixture.original_bytes, "abort changed primary")
	_expect(not _any_artifact_exists(fixture.primary), "abort left artifacts")


func _test_runtime_apply_rollback(script: Script) -> void:
	var fixture := _fixture("runtime_rollback")
	var transaction = script.new()
	var prepared: Dictionary = transaction.prepare(
		fixture.primary,
		{"source_checksum": _sha256(fixture.original_bytes)},
		fixture.target_payload,
		Callable(self, "_validate_target")
	)
	var committed: Dictionary = transaction.commit_prepared(prepared)
	_expect(String(committed.get("state", "")) == "COMMITTED_PENDING_RUNTIME_APPLY", "runtime rollback fixture did not commit")
	var rolled_back: Dictionary = transaction.rollback_last_commit(committed)
	_expect(String(rolled_back.get("state", "")) == "ROLLBACK_RESTORED", "runtime failure did not restore source")
	_expect(_read_bytes(fixture.primary) == fixture.original_bytes, "runtime rollback bytes differ from source")
	_expect(not _any_artifact_exists(fixture.primary), "runtime rollback left artifacts")


func _test_crash_recovery_from_prepared(script: Script) -> void:
	var fixture := _fixture("recover_prepared")
	var transaction = script.new()
	var prepared: Dictionary = transaction.prepare(
		fixture.primary,
		{"source_checksum": _sha256(fixture.original_bytes)},
		fixture.target_payload,
		Callable(self, "_validate_target")
	)
	_expect(String(prepared.get("state", "")) == "PREPARED", "prepared recovery fixture failed")
	var recovered: Dictionary = script.new().recover_pending(fixture.primary)
	_expect(String(recovered.get("state", "")) == "ABORTED", "PREPARED crash did not abort")
	_expect(_read_bytes(fixture.primary) == fixture.original_bytes, "PREPARED crash changed source")
	_expect(not _any_artifact_exists(fixture.primary), "PREPARED recovery left artifacts")


func _test_crash_recovery_from_pending(script: Script) -> void:
	var fixture := _fixture("recover_pending")
	var transaction = script.new()
	var prepared: Dictionary = transaction.prepare(
		fixture.primary,
		{"source_checksum": _sha256(fixture.original_bytes)},
		fixture.target_payload,
		Callable(self, "_validate_target")
	)
	var committed: Dictionary = transaction.commit_prepared(prepared)
	_expect(String(committed.get("state", "")) == "COMMITTED_PENDING_RUNTIME_APPLY", "pending recovery fixture failed")
	var recovered: Dictionary = script.new().recover_pending(fixture.primary)
	_expect(String(recovered.get("state", "")) == "ROLLBACK_RESTORED", "pending crash did not roll back")
	_expect(_read_bytes(fixture.primary) == fixture.original_bytes, "pending crash recovery bytes differ")
	_expect(not _any_artifact_exists(fixture.primary), "pending recovery left artifacts")


func _test_promote_failure_preserves_source(script: Script) -> void:
	var fixture := _fixture("promote_failure")
	var transaction = script.new()
	transaction.configure_failure_for_test("promote_temp")
	var prepared: Dictionary = transaction.prepare(
		fixture.primary,
		{"source_checksum": _sha256(fixture.original_bytes)},
		fixture.target_payload,
		Callable(self, "_validate_target")
	)
	var committed: Dictionary = transaction.commit_prepared(prepared)
	_expect(String(committed.get("code", "")) == "REPLACE_FAILED", "injected promote failure not surfaced")
	_expect(_read_bytes(fixture.primary) == fixture.original_bytes, "promote failure changed source")
	var aborted: Dictionary = transaction.abort_prepared(committed)
	_expect(String(aborted.get("state", "")) == "ABORTED", "failed promote could not abort")
	_expect(not _any_artifact_exists(fixture.primary), "failed promote cleanup incomplete")


func _fixture(name: String) -> Dictionary:
	_sequence += 1
	var directory := "%s/%02d_%s" % [ROOT, _sequence, name]
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(directory))
	var primary := "%s/save.json" % directory
	var original_payload := {
		"save_version": "mvp-039",
		"episode_id": "episode_001_afterlife_station",
		"revision": 3,
		"campaign_state": {"day": 5}
	}
	var target_payload := {
		"save_version": "mvp-040",
		"episode_id": "episode_001_afterlife_station",
		"content_contract_id": "afterlife-station-canon-v2",
		"revision": 4,
		"migration_history": [{"migration_id": "afterlife-station-canon-v2-001", "state": "pending"}]
	}
	_write_json(primary, original_payload)
	return {
		"primary": primary,
		"original_bytes": _read_bytes(primary),
		"target_payload": target_payload
	}


func _validate_target(payload: Dictionary) -> bool:
	return (
		String(payload.get("save_version", "")) == "mvp-040"
		and String(payload.get("content_contract_id", "")) == "afterlife-station-canon-v2"
		and typeof(payload.get("migration_history")) == TYPE_ARRAY
	)


func _artifact_paths(primary: String) -> Array[String]:
	var stem := primary.trim_suffix(".json") if primary.ends_with(".json") else primary
	return [
		"%s.migration.tmp.json" % stem,
		"%s.migration.bak.json" % stem,
		"%s.migration.old.json" % stem,
		"%s.migration.journal.json" % stem
	]


func _any_artifact_exists(primary: String) -> bool:
	for path in _artifact_paths(primary):
		if FileAccess.file_exists(path):
			return true
	return false


func _write_json(path: String, payload: Dictionary) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	_expect(file != null, "failed to write fixture: %s" % path)
	if file != null:
		file.store_string(JSON.stringify(payload, "\t", false))
		file.flush()
		file.close()


func _read_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	return parsed as Dictionary if typeof(parsed) == TYPE_DICTIONARY else {}


func _read_bytes(path: String) -> PackedByteArray:
	return FileAccess.get_file_as_bytes(path) if FileAccess.file_exists(path) else PackedByteArray()


func _sha256(bytes: PackedByteArray) -> String:
	var context := HashingContext.new()
	if context.start(HashingContext.HASH_SHA256) != OK:
		return ""
	if context.update(bytes) != OK:
		return ""
	return context.finish().hex_encode()


func _reset_root() -> void:
	var absolute := ProjectSettings.globalize_path(ROOT)
	if DirAccess.dir_exists_absolute(absolute):
		_remove_tree(absolute)
	DirAccess.make_dir_recursive_absolute(absolute)


func _remove_tree(absolute_path: String) -> void:
	var directory := DirAccess.open(absolute_path)
	if directory == null:
		return
	directory.list_dir_begin()
	var name := directory.get_next()
	while not name.is_empty():
		if name not in [".", ".."]:
			var child := absolute_path.path_join(name)
			if directory.current_is_dir():
				_remove_tree(child)
			else:
				DirAccess.remove_absolute(child)
		name = directory.get_next()
	directory.list_dir_end()
	DirAccess.remove_absolute(absolute_path)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("AFTERLIFE MIGRATION TRANSACTION: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
