# Headless tests that touch GameState preserve the player's user:// save file.
class_name TestSaveGuard
extends RefCounted

var _save_path := ""
var _backup_path := ""
var _had_existing_save := false
var _extra_paths: Array[String] = []
var _extra_backup_paths: Dictionary = {}
var _extra_had_existing: Dictionary = {}


func prepare(save_path: String, extra_paths: Array = []) -> String:
	_save_path = ProjectSettings.globalize_path(save_path)
	_backup_path = "%s.godot-test-backup" % _save_path
	if FileAccess.file_exists(_backup_path):
		if FileAccess.file_exists(_save_path):
			var remove_error := DirAccess.remove_absolute(_save_path)
			if remove_error != OK:
				return "interrupted test save could not be removed before recovery"
		var recovery_error := DirAccess.rename_absolute(_backup_path, _save_path)
		if recovery_error != OK:
			return "backup from an interrupted test could not be recovered"

	_had_existing_save = FileAccess.file_exists(_save_path)
	if _had_existing_save:
		var backup_error := DirAccess.rename_absolute(_save_path, _backup_path)
		if backup_error != OK:
			return "existing user save could not be backed up before the test"
	for path_value in extra_paths:
		var path := ProjectSettings.globalize_path(String(path_value))
		if path.is_empty() or path == _save_path:
			continue
		var extra_error := _prepare_extra_path(path)
		if not extra_error.is_empty():
			return extra_error
	return ""


func restore() -> String:
	var extra_restore_error := _restore_extra_paths()
	if not extra_restore_error.is_empty():
		return extra_restore_error
	if _had_existing_save:
		if not FileAccess.file_exists(_backup_path):
			return "user save backup is missing; generated test save was preserved"
		if FileAccess.file_exists(_save_path):
			var remove_error := DirAccess.remove_absolute(_save_path)
			if remove_error != OK:
				return "generated test save could not be removed before restore"
		var restore_error := DirAccess.rename_absolute(_backup_path, _save_path)
		if restore_error != OK:
			return "existing user save could not be restored after the test"
	elif FileAccess.file_exists(_save_path):
		var remove_error := DirAccess.remove_absolute(_save_path)
		if remove_error != OK:
			return "generated test save could not be removed"
	return ""


func _prepare_extra_path(path: String) -> String:
	var backup_path := "%s.godot-test-backup" % path
	if FileAccess.file_exists(backup_path):
		if FileAccess.file_exists(path):
			var remove_error := DirAccess.remove_absolute(path)
			if remove_error != OK:
				return "interrupted test user-data file could not be removed before recovery: %s" % path
		var recovery_error := DirAccess.rename_absolute(backup_path, path)
		if recovery_error != OK:
			return "backup from an interrupted user-data test could not be recovered: %s" % path
	var had_existing := FileAccess.file_exists(path)
	if had_existing:
		var backup_error := DirAccess.rename_absolute(path, backup_path)
		if backup_error != OK:
			return "existing user-data file could not be backed up before the test: %s" % path
	_extra_paths.append(path)
	_extra_backup_paths[path] = backup_path
	_extra_had_existing[path] = had_existing
	return ""


func _restore_extra_paths() -> String:
	for path in _extra_paths:
		var backup_path := String(_extra_backup_paths.get(path, ""))
		var had_existing := bool(_extra_had_existing.get(path, false))
		if had_existing:
			if not FileAccess.file_exists(backup_path):
				return "user-data backup is missing; generated test file was preserved: %s" % path
			if FileAccess.file_exists(path):
				var remove_error := DirAccess.remove_absolute(path)
				if remove_error != OK:
					return "generated user-data test file could not be removed before restore: %s" % path
			var restore_error := DirAccess.rename_absolute(backup_path, path)
			if restore_error != OK:
				return "existing user-data file could not be restored after the test: %s" % path
		elif FileAccess.file_exists(path):
			var cleanup_error := DirAccess.remove_absolute(path)
			if cleanup_error != OK:
				return "generated user-data test file could not be removed: %s" % path
	_extra_paths.clear()
	_extra_backup_paths.clear()
	_extra_had_existing.clear()
	return ""
