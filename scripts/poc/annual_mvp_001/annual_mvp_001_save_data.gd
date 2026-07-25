class_name AnnualMvp001SaveData
extends RefCounted

const SAVE_PATH := "user://annual_mvp_001_poc.json"
const SAVE_VERSION := "annual-mvp-001-save-v1"


static func write_payload(payload: Dictionary, path: String = SAVE_PATH) -> Error:
	if String(payload.get("save_version", "")) != SAVE_VERSION:
		return ERR_INVALID_DATA
	var state_value: Variant = payload.get("state")
	if typeof(state_value) != TYPE_DICTIONARY:
		return ERR_INVALID_DATA
	if String((state_value as Dictionary).get("phase", "")) == "INCIDENT_ACTIVE":
		return ERR_UNAVAILABLE
	var temp_path := "%s.tmp" % path
	var file := FileAccess.open(temp_path, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string(JSON.stringify(payload, "\t", false))
	file.flush()
	file.close()
	var absolute_temp := ProjectSettings.globalize_path(temp_path)
	var absolute_target := ProjectSettings.globalize_path(path)
	if FileAccess.file_exists(path):
		var remove_error := DirAccess.remove_absolute(absolute_target)
		if remove_error != OK:
			DirAccess.remove_absolute(absolute_temp)
			return remove_error
	var rename_error := DirAccess.rename_absolute(absolute_temp, absolute_target)
	if rename_error != OK:
		DirAccess.remove_absolute(absolute_temp)
	return rename_error


static func read_payload(path: String = SAVE_PATH) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return {}
	var payload := parsed as Dictionary
	if String(payload.get("save_version", "")) != SAVE_VERSION:
		return {}
	if typeof(payload.get("state")) != TYPE_DICTIONARY:
		return {}
	if String((payload["state"] as Dictionary).get("phase", "")) == "INCIDENT_ACTIVE":
		return {}
	return payload.duplicate(true)


static func delete_payload(path: String = SAVE_PATH) -> Error:
	var temp_path := "%s.tmp" % path
	if FileAccess.file_exists(temp_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(temp_path))
	if not FileAccess.file_exists(path):
		return OK
	return DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
