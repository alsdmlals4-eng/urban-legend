class_name ValidationSaveRepository
extends RefCounted

const PRIMARY_PATH := "user://urban_legend_validation_save.json"
const LEGACY_FORBIDDEN_PATH := "user://urban_legend_save.json"
const FORMAT_ID := "urban-legend-validation-save"
const SAVE_VERSION := "validation-save-v1"
const PAYLOAD_SCHEMA := 1

var _primary_path: String
var _backup_path: String
var _temp_path: String
var _quarantine_prefix: String


func _init(primary_path: String = PRIMARY_PATH) -> void:
	_primary_path = primary_path
	var stem := primary_path.substr(0, primary_path.length() - 5) if primary_path.ends_with(".json") else primary_path
	_backup_path = "%s.bak.json" % stem
	_temp_path = "%s.tmp.json" % stem
	_quarantine_prefix = "%s.corrupt." % stem


func get_paths() -> Dictionary:
	return {
		"primary": _primary_path,
		"backup": _backup_path,
		"temp": _temp_path,
		"quarantine_prefix": _quarantine_prefix,
		"legacy_forbidden": LEGACY_FORBIDDEN_PATH
	}


func inspect() -> Dictionary:
	if _primary_path == LEGACY_FORBIDDEN_PATH:
		return _result(false, "LEGACY_GUARD_VIOLATION")
	if not FileAccess.file_exists(_primary_path):
		if FileAccess.file_exists(_temp_path):
			return _result(false, "INTERRUPTED_WRITE")
		if FileAccess.file_exists(_backup_path):
			var backup_state := _inspect_path(_backup_path)
			return _result(false, "RECOVERABLE_BACKUP", {
				"backup_code": String(backup_state.get("code", "READ_FAILED")),
				"backup_payload": backup_state.get("payload", {}).duplicate(true) if typeof(backup_state.get("payload")) == TYPE_DICTIONARY else {}
			})
		return _result(false, "EMPTY")
	return _inspect_path(_primary_path)


func read_payload() -> Dictionary:
	return inspect()


func write_payload(payload: Dictionary) -> Dictionary:
	if _primary_path == LEGACY_FORBIDDEN_PATH:
		return _result(false, "LEGACY_GUARD_VIOLATION")

	var requested := _validate_payload(payload)
	if String(requested.get("code", "")) != "EXACT":
		return requested

	var current := inspect()
	var current_code := String(current.get("code", ""))
	if current_code not in ["EMPTY", "EXACT"]:
		return current

	var temp_file := FileAccess.open(_temp_path, FileAccess.WRITE)
	if temp_file == null:
		return _result(false, "WRITE_FAILED", {"error": FileAccess.get_open_error()})
	temp_file.store_string(JSON.stringify(payload, "\t", false))
	temp_file.flush()
	temp_file.close()

	var temp_state := _inspect_path(_temp_path)
	if String(temp_state.get("code", "")) != "EXACT":
		return _result(false, "VERIFY_FAILED", {"temp_code": temp_state.get("code", "READ_FAILED")})

	var primary_abs := ProjectSettings.globalize_path(_primary_path)
	var backup_abs := ProjectSettings.globalize_path(_backup_path)
	var temp_abs := ProjectSettings.globalize_path(_temp_path)
	var moved_primary_to_backup := false

	if FileAccess.file_exists(_primary_path):
		if FileAccess.file_exists(_backup_path):
			var remove_backup := DirAccess.remove_absolute(backup_abs)
			if remove_backup != OK:
				_remove_path(_temp_path)
				return _result(false, "REPLACE_FAILED", {"error": remove_backup, "phase": "remove_backup"})
		var backup_error := DirAccess.rename_absolute(primary_abs, backup_abs)
		if backup_error != OK:
			_remove_path(_temp_path)
			return _result(false, "REPLACE_FAILED", {"error": backup_error, "phase": "backup_primary"})
		moved_primary_to_backup = true

	var replace_error := DirAccess.rename_absolute(temp_abs, primary_abs)
	if replace_error != OK:
		if moved_primary_to_backup and FileAccess.file_exists(_backup_path) and not FileAccess.file_exists(_primary_path):
			DirAccess.rename_absolute(backup_abs, primary_abs)
		_remove_path(_temp_path)
		return _result(false, "REPLACE_FAILED", {"error": replace_error, "phase": "promote_temp"})

	var final_state := _inspect_path(_primary_path)
	if String(final_state.get("code", "")) != "EXACT":
		_remove_path(_primary_path)
		if moved_primary_to_backup and FileAccess.file_exists(_backup_path):
			DirAccess.rename_absolute(backup_abs, primary_abs)
		return _result(false, "VERIFY_FAILED", {"primary_code": final_state.get("code", "READ_FAILED")})

	return _result(true, "OK", {"revision": int(payload.get("revision", 0))})


func delete_persistence() -> Dictionary:
	if _primary_path == LEGACY_FORBIDDEN_PATH:
		return _result(false, "LEGACY_GUARD_VIOLATION")
	for path in [_primary_path, _backup_path, _temp_path]:
		var error := _remove_path(path)
		if error != OK:
			return _result(false, "DELETE_FAILED", {"path": path, "error": error})
	return _result(true, "OK")


func quarantine_primary(reason: String) -> Dictionary:
	if _primary_path == LEGACY_FORBIDDEN_PATH:
		return _result(false, "LEGACY_GUARD_VIOLATION")
	var state := inspect()
	if String(state.get("code", "")) not in ["CORRUPT_JSON", "CORRUPT_SCHEMA"]:
		return _result(false, "INVALID_LIFECYCLE", {"current_code": state.get("code", "EMPTY")})
	var stamp := Time.get_datetime_string_from_system(true, true).replace(":", "-")
	var safe_reason := reason.validate_filename()
	if safe_reason.is_empty():
		safe_reason = "unspecified"
	var path := "%s%s-%s.%s.json" % [_quarantine_prefix, stamp, str(Time.get_ticks_usec()), safe_reason]
	var error := DirAccess.rename_absolute(
		ProjectSettings.globalize_path(_primary_path),
		ProjectSettings.globalize_path(path)
	)
	return _result(error == OK, "OK" if error == OK else "REPLACE_FAILED", {
		"quarantine_path": path,
		"error": error
	})


func _inspect_path(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return _result(false, "READ_FAILED", {"error": FileAccess.get_open_error()})
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		return _result(false, "CORRUPT_JSON")
	var normalized: Variant = _normalize_json_numbers(parsed)
	if typeof(normalized) != TYPE_DICTIONARY:
		return _result(false, "CORRUPT_JSON")
	return _validate_payload(normalized as Dictionary)


func _validate_payload(payload: Dictionary) -> Dictionary:
	if String(payload.get("format", "")) != FORMAT_ID:
		return _result(false, "CORRUPT_SCHEMA")
	var version_code := _classify_version(String(payload.get("version", "")))
	if version_code != "EXACT":
		return _result(false, version_code, {"payload": payload.duplicate(true)})
	if int(payload.get("payload_schema", 0)) != PAYLOAD_SCHEMA:
		return _result(false, "CORRUPT_SCHEMA", {"field": "payload_schema"})
	if int(payload.get("revision", -1)) < 0:
		return _result(false, "CORRUPT_SCHEMA", {"field": "revision"})
	for key in ["session", "snapshots", "result", "timestamps", "integrity"]:
		if typeof(payload.get(key)) != TYPE_DICTIONARY:
			return _result(false, "CORRUPT_SCHEMA", {"field": key})
	return _result(true, "EXACT", {"payload": payload.duplicate(true)})


func _classify_version(version: String) -> String:
	if version == SAVE_VERSION:
		return "EXACT"
	const PREFIX := "validation-save-v"
	if not version.begins_with(PREFIX):
		return "CORRUPT_SCHEMA"
	var number_text := version.substr(PREFIX.length())
	if not number_text.is_valid_int():
		return "CORRUPT_SCHEMA"
	return "INCOMPATIBLE_OLDER" if int(number_text) < 1 else "INCOMPATIBLE_NEWER"


func _remove_path(path: String) -> Error:
	if not FileAccess.file_exists(path):
		return OK
	return DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _normalize_json_numbers(value: Variant) -> Variant:
	match typeof(value):
		TYPE_FLOAT:
			var number := float(value)
			if is_equal_approx(number, round(number)):
				return int(round(number))
			return number
		TYPE_ARRAY:
			var array: Array = []
			for item in value as Array:
				array.append(_normalize_json_numbers(item))
			return array
		TYPE_DICTIONARY:
			var dictionary: Dictionary = {}
			for key in (value as Dictionary).keys():
				dictionary[key] = _normalize_json_numbers((value as Dictionary)[key])
			return dictionary
	return value


func _result(ok: bool, code: String, details: Dictionary = {}) -> Dictionary:
	var result := {"ok": ok, "code": code}
	for key in details.keys():
		result[key] = details[key]
	return result
