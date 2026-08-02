class_name ValidationSaveRepository
extends RefCounted

const SAVE_VERSION := "validation-save-v1"
const PRIMARY_PATH := "user://urban_legend_validation_save.json"
const BACKUP_PATH := "user://urban_legend_validation_save.backup.json"
const TEMP_PATH := "user://urban_legend_validation_save.tmp"
const LEGACY_PATH := "user://urban_legend_save.json"


func get_primary_path() -> String:
	return PRIMARY_PATH


func get_backup_path() -> String:
	return BACKUP_PATH


func get_temp_path() -> String:
	return TEMP_PATH


func inspect_primary() -> Dictionary:
	return _inspect_path(PRIMARY_PATH)


func write_payload(payload: Dictionary) -> Dictionary:
	var validation := _validate_payload(payload)
	if not bool(validation.get("ok", false)):
		return validation

	var write_error := _write_json(TEMP_PATH, payload)
	if write_error != OK:
		return {"ok": false, "code": "TEMP_WRITE_FAILED", "error": write_error}

	var readback := _read_payload_from_path(TEMP_PATH)
	if not bool(readback.get("ok", false)) or not _semantic_equal(readback.get("payload", {}), payload):
		_remove_if_exists(TEMP_PATH)
		return {"ok": false, "code": "TEMP_READBACK_FAILED"}

	if FileAccess.file_exists(PRIMARY_PATH):
		_remove_if_exists(BACKUP_PATH)
		var backup_error := _copy_file(PRIMARY_PATH, BACKUP_PATH)
		if backup_error != OK:
			_remove_if_exists(TEMP_PATH)
			return {"ok": false, "code": "BACKUP_WRITE_FAILED", "error": backup_error}

	var absolute_primary := ProjectSettings.globalize_path(PRIMARY_PATH)
	var absolute_temp := ProjectSettings.globalize_path(TEMP_PATH)
	if FileAccess.file_exists(PRIMARY_PATH):
		var remove_error := DirAccess.remove_absolute(absolute_primary)
		if remove_error != OK:
			_remove_if_exists(TEMP_PATH)
			return {"ok": false, "code": "PRIMARY_REMOVE_FAILED", "error": remove_error}
	var rename_error := DirAccess.rename_absolute(absolute_temp, absolute_primary)
	if rename_error != OK:
		_remove_if_exists(TEMP_PATH)
		return {"ok": false, "code": "PRIMARY_REPLACE_FAILED", "error": rename_error}
	return {"ok": true, "code": "OK"}


func read_payload() -> Dictionary:
	var inspection := inspect_primary()
	if String(inspection.get("status", "")) != "EXACT":
		return {
			"ok": false,
			"code": String(inspection.get("status", "MISSING")),
			"inspection": inspection
		}
	return {
		"ok": true,
		"code": "OK",
		"payload": inspection.get("payload", {}).duplicate(true)
	}


func delete_validation_files() -> Dictionary:
	for path in [PRIMARY_PATH, BACKUP_PATH, TEMP_PATH]:
		var error := _remove_if_exists(path)
		if error != OK:
			return {"ok": false, "code": "DELETE_FAILED", "path": path, "error": error}
	return {"ok": true, "code": "OK"}


func _inspect_path(path: String) -> Dictionary:
	if path == LEGACY_PATH:
		return {"ok": false, "status": "FORBIDDEN_LEGACY_PATH"}
	if not FileAccess.file_exists(path):
		return {"ok": false, "status": "MISSING"}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {"ok": false, "status": "UNREADABLE", "error": FileAccess.get_open_error()}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		return {"ok": false, "status": "CORRUPT"}
	var payload := _normalize_json_numbers(parsed) as Dictionary
	var version := String(payload.get("save_version", ""))
	if version == SAVE_VERSION:
		var validation := _validate_payload(payload)
		if bool(validation.get("ok", false)):
			return {"ok": true, "status": "EXACT", "payload": payload}
		return {"ok": false, "status": "CORRUPT", "code": validation.get("code", "INVALID_PAYLOAD")}
	if version.begins_with("validation-save-v"):
		var number_text := version.trim_prefix("validation-save-v")
		if number_text.is_valid_int() and int(number_text) > 1:
			return {"ok": false, "status": "INCOMPATIBLE_NEWER", "payload": payload}
		if number_text.is_valid_int() and int(number_text) < 1:
			return {"ok": false, "status": "MIGRATABLE_OLDER", "payload": payload}
	return {"ok": false, "status": "INCOMPATIBLE", "payload": payload}


func _validate_payload(payload: Dictionary) -> Dictionary:
	if String(payload.get("save_version", "")) != SAVE_VERSION:
		return {"ok": false, "code": "INVALID_SAVE_VERSION"}
	var session_value: Variant = payload.get("session")
	if typeof(session_value) != TYPE_DICTIONARY:
		return {"ok": false, "code": "INVALID_SESSION"}
	var session := session_value as Dictionary
	if String(session.get("session_id", "")).is_empty():
		return {"ok": false, "code": "MISSING_SESSION_ID"}
	if String(session.get("episode_id", "")).is_empty():
		return {"ok": false, "code": "MISSING_EPISODE_ID"}
	if String(session.get("stage", "")).is_empty():
		return {"ok": false, "code": "MISSING_STAGE"}
	return {"ok": true, "code": "OK"}


func _write_json(path: String, payload: Dictionary) -> Error:
	if path == LEGACY_PATH:
		return ERR_UNAUTHORIZED
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string(JSON.stringify(payload, "\t", false))
	file.flush()
	file.close()
	return OK


func _copy_file(source_path: String, target_path: String) -> Error:
	if source_path == LEGACY_PATH or target_path == LEGACY_PATH:
		return ERR_UNAUTHORIZED
	var source := FileAccess.open(source_path, FileAccess.READ)
	if source == null:
		return FileAccess.get_open_error()
	var bytes := source.get_buffer(source.get_length())
	source.close()
	var target := FileAccess.open(target_path, FileAccess.WRITE)
	if target == null:
		return FileAccess.get_open_error()
	target.store_buffer(bytes)
	target.flush()
	target.close()
	return OK


func _read_payload_from_path(path: String) -> Dictionary:
	if path == LEGACY_PATH or not FileAccess.file_exists(path):
		return {"ok": false, "code": "MISSING_OR_FORBIDDEN"}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {"ok": false, "code": "UNREADABLE", "error": FileAccess.get_open_error()}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		return {"ok": false, "code": "CORRUPT"}
	return {"ok": true, "payload": _normalize_json_numbers(parsed)}


func _remove_if_exists(path: String) -> Error:
	if path == LEGACY_PATH:
		return ERR_UNAUTHORIZED
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
