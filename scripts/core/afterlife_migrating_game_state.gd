extends "res://scripts/core/validation_game_state.gd"


const AfterlifeInspectorScript := preload("res://scripts/core/afterlife_legacy_save_inspector.gd")
const AfterlifeRegistryScript := preload("res://scripts/data/afterlife_id_migration_registry.gd")
const AfterlifeMainMigratorScript := preload("res://scripts/core/afterlife_main_save_migrator.gd")
const AfterlifeTransactionScript := preload("res://scripts/core/afterlife_migration_transaction.gd")
const AfterlifeEpisodeLoaderScript := preload("res://scripts/data/episode_loader.gd")
const AFTERLIFE_REGISTRY_PATH := "res://data/migrations/afterlife_station_canon_v2_id_migration.json"
const AFTERLIFE_EPISODE_ID := "episode_001_afterlife_station"
const AFTERLIFE_CONTRACT_ID := "afterlife-station-canon-v2"
const MAIN_TARGET_VERSION := "mvp-040"

var _afterlife_content_contract_id := ""
var _afterlife_v2_state: Dictionary = {}
var _afterlife_migration_history: Array = []
var _afterlife_orphan_legacy_ids: Array = []
var _afterlife_legacy_migration_notes: Array = []
var _afterlife_legacy_resolution_snapshot: Dictionary = {}
var _afterlife_first_v2_investigation: Dictionary = {}
var _afterlife_applied_migration_effect_ids: Dictionary = {}
var _last_migration_result: Dictionary = {}
var _inject_runtime_failure := false


func configure_migration_runtime_failure_for_test(enabled: bool) -> void:
	_inject_runtime_failure = enabled


func get_last_migration_result() -> Dictionary:
	return _last_migration_result.duplicate(true)


func get_afterlife_content_contract_id() -> String:
	return _afterlife_content_contract_id


func get_afterlife_manual_state() -> Dictionary:
	var manual_value: Variant = _afterlife_v2_state.get("manual")
	return (manual_value as Dictionary).duplicate(true) if typeof(manual_value) == TYPE_DICTIONARY else {}


func load_episode(file_path: String = DEFAULT_EPISODE_PATH) -> bool:
	var loader = AfterlifeEpisodeLoaderScript.new()
	var loaded_data: Dictionary
	if file_path == DEFAULT_EPISODE_PATH and _afterlife_content_contract_id == AFTERLIFE_CONTRACT_ID:
		loaded_data = loader.load_episode_contract(file_path, AFTERLIFE_CONTRACT_ID)
	else:
		loaded_data = loader.load_episode(file_path)
	if loaded_data.is_empty():
		return false
	current_episode_path = file_path
	current_episode_data = CaseDataScript.refresh_resolution_progress(loaded_data)
	_clear_resolution_phase_selection()
	_clear_recovery_result()
	return true


func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		return false
	var recovery := AfterlifeTransactionScript.new().recover_pending(SAVE_FILE_PATH)
	if String(recovery.get("code", "")) == "MIGRATION_FATAL_RECOVERY_REQUIRED":
		_last_migration_result = recovery.duplicate(true)
		return false
	var source_payload := _read_dictionary(SAVE_FILE_PATH)
	if source_payload.is_empty():
		return false
	var source_version := String(source_payload.get("save_version", ""))
	var episode_id := String(source_payload.get("episode_id", ""))
	if source_version == MAIN_TARGET_VERSION:
		_hydrate_afterlife_fields(source_payload)
		var loaded_v2 := super.load_game()
		if not loaded_v2:
			return false
		return true
	if source_version not in ["mvp-038", "mvp-039"] or episode_id != AFTERLIFE_EPISODE_ID:
		return super.load_game()

	var source_bytes := FileAccess.get_file_as_bytes(SAVE_FILE_PATH)
	var inspector = AfterlifeInspectorScript.new()
	var inspected: Dictionary = inspector.inspect_main_bytes(source_bytes)
	if String(inspected.get("code", "")) != "MIGRATABLE_MAIN":
		_last_migration_result = inspected.duplicate(true)
		return false
	var registry = AfterlifeRegistryScript.new()
	var registry_result: Dictionary = registry.load_registry(AFTERLIFE_REGISTRY_PATH)
	if String(registry_result.get("code", "")) != "EXACT":
		_last_migration_result = registry_result.duplicate(true)
		return false
	var migrated: Dictionary = AfterlifeMainMigratorScript.new().migrate(inspected, registry)
	if not bool(migrated.get("ok", false)):
		_last_migration_result = migrated.duplicate(true)
		return false
	var target_payload := migrated.get("payload", {}) as Dictionary
	var transaction = AfterlifeTransactionScript.new()
	var prepared: Dictionary = transaction.prepare(
		SAVE_FILE_PATH,
		inspected,
		target_payload,
		Callable(self, "_validate_main_v2_payload")
	)
	if String(prepared.get("state", "")) != "PREPARED":
		_last_migration_result = prepared.duplicate(true)
		return false
	var committed: Dictionary = transaction.commit_prepared(prepared)
	if String(committed.get("state", "")) != "COMMITTED_PENDING_RUNTIME_APPLY":
		transaction.abort_prepared(committed if String(committed.get("state", "")) == "PREPARED" else prepared)
		_last_migration_result = committed.duplicate(true)
		return false
	if _inject_runtime_failure:
		var rolled_back := transaction.rollback_last_commit(committed)
		_last_migration_result = rolled_back.duplicate(true)
		return false

	_afterlife_content_contract_id = AFTERLIFE_CONTRACT_ID
	var applied := super.load_game()
	if not applied:
		_afterlife_content_contract_id = ""
		var rollback := transaction.rollback_last_commit(committed)
		_last_migration_result = rollback.duplicate(true)
		return false
	_hydrate_afterlife_fields(target_payload)
	var finalized := transaction.finalize(committed)
	_last_migration_result = finalized.duplicate(true)
	if String(finalized.get("state", "")) != "FINALIZED":
		return false
	return true


func save_game() -> bool:
	var session = get_node_or_null("/root/ValidationSession")
	if session != null and session.has_method("requires_save_routing") and bool(session.requires_save_routing()):
		if not session.has_method("is_active_and_valid") or not bool(session.is_active_and_valid()):
			return false
		if not session.has_method("save"):
			return false
		var validation_result: Dictionary = session.save(self)
		return String(validation_result.get("code", "")) == "OK"
	if current_episode_data.is_empty() and not load_episode(DEFAULT_EPISODE_PATH):
		return false
	var payload := _make_save_data()
	payload["save_version"] = MAIN_TARGET_VERSION
	if get_current_episode_id() == AFTERLIFE_EPISODE_ID:
		payload["content_contract_id"] = AFTERLIFE_CONTRACT_ID
		payload["afterlife_canon_v2"] = _afterlife_v2_state.duplicate(true)
		payload["migration_history"] = _afterlife_migration_history.duplicate(true)
		payload["orphan_legacy_ids"] = _afterlife_orphan_legacy_ids.duplicate(true)
		payload["legacy_migration_notes"] = _afterlife_legacy_migration_notes.duplicate(true)
		payload["legacy_resolution_snapshot"] = _afterlife_legacy_resolution_snapshot.duplicate(true)
		payload["first_v2_investigation"] = _afterlife_first_v2_investigation.duplicate(true)
		payload["applied_migration_effect_ids"] = _afterlife_applied_migration_effect_ids.duplicate(true)
	return _write_current_main_payload(payload)


func _write_current_main_payload(payload: Dictionary) -> bool:
	if not _validate_main_v2_payload(payload):
		return false
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		return _write_new_primary(SAVE_FILE_PATH, payload)
	var bytes := FileAccess.get_file_as_bytes(SAVE_FILE_PATH)
	var inspected := {"source_checksum": _sha256(bytes)}
	var transaction = AfterlifeTransactionScript.new()
	var prepared: Dictionary = transaction.prepare(
		SAVE_FILE_PATH,
		inspected,
		payload,
		Callable(self, "_validate_main_v2_payload")
	)
	if String(prepared.get("state", "")) != "PREPARED":
		_last_migration_result = prepared.duplicate(true)
		return false
	var committed: Dictionary = transaction.commit_prepared(prepared)
	if String(committed.get("state", "")) != "COMMITTED_PENDING_RUNTIME_APPLY":
		transaction.abort_prepared(committed if String(committed.get("state", "")) == "PREPARED" else prepared)
		_last_migration_result = committed.duplicate(true)
		return false
	var finalized := transaction.finalize(committed)
	_last_migration_result = finalized.duplicate(true)
	return String(finalized.get("state", "")) == "FINALIZED"


func _write_new_primary(path: String, payload: Dictionary) -> bool:
	var temp_path := path + ".new.tmp"
	_remove_path(temp_path)
	var bytes := JSON.stringify(payload, "\t", false).to_utf8_buffer()
	var file := FileAccess.open(temp_path, FileAccess.WRITE)
	if file == null:
		return false
	file.store_buffer(bytes)
	file.flush()
	file.close()
	if _read_dictionary(temp_path).is_empty():
		_remove_path(temp_path)
		return false
	var rename_error := DirAccess.rename_absolute(
		ProjectSettings.globalize_path(temp_path),
		ProjectSettings.globalize_path(path)
	)
	if rename_error != OK:
		_remove_path(temp_path)
		return false
	return _validate_main_v2_payload(_read_dictionary(path))


func _hydrate_afterlife_fields(payload: Dictionary) -> void:
	_afterlife_content_contract_id = String(payload.get("content_contract_id", ""))
	_afterlife_v2_state = _dictionary_copy(payload.get("afterlife_canon_v2"))
	_afterlife_migration_history = _array_copy(payload.get("migration_history"))
	_afterlife_orphan_legacy_ids = _array_copy(payload.get("orphan_legacy_ids"))
	_afterlife_legacy_migration_notes = _array_copy(payload.get("legacy_migration_notes"))
	_afterlife_legacy_resolution_snapshot = _dictionary_copy(payload.get("legacy_resolution_snapshot"))
	_afterlife_first_v2_investigation = _dictionary_copy(payload.get("first_v2_investigation"))
	_afterlife_applied_migration_effect_ids = _dictionary_copy(payload.get("applied_migration_effect_ids"))


func _validate_main_v2_payload(payload: Dictionary) -> bool:
	if String(payload.get("save_version", "")) != MAIN_TARGET_VERSION:
		return false
	if String(payload.get("episode_id", "")) != AFTERLIFE_EPISODE_ID:
		return false
	if String(payload.get("content_contract_id", "")) != AFTERLIFE_CONTRACT_ID:
		return false
	var v2 := _dictionary_copy(payload.get("afterlife_canon_v2"))
	var manual := _dictionary_copy(v2.get("manual"))
	if not _dictionary_copy(manual.get("filled_slots")).is_empty():
		return false
	for record_value in _array_copy(manual.get("evidence_records")):
		if typeof(record_value) != TYPE_DICTIONARY:
			return false
		if String((record_value as Dictionary).get("state", "")) != "migrated_unverified":
			return false
	return typeof(payload.get("migration_history")) == TYPE_ARRAY


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
