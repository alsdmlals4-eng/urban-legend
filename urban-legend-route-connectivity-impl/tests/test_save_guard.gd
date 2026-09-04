# Headless tests that touch GameState preserve the player's user:// save file.
class_name TestSaveGuard
extends RefCounted

var _save_path := ""
var _backup_path := ""
var _had_existing_save := false


func prepare(save_path: String) -> String:
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
	return ""


func restore() -> String:
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
