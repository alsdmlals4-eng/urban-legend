extends SceneTree

const Repository = preload("res://scripts/core/validation_save_repository.gd")
const Support = preload("res://tests/validation/validation_test_support.gd")
const TEST_PRIMARY := "user://validation_package_1_repository_test.json"
const LEGACY_PATH := "user://urban_legend_save.json"

var _failures: Array[String] = []
var _quarantine_path := ""


func _payload(revision: int = 1, version: String = "validation-save-v1") -> Dictionary:
	return {
		"format": "urban-legend-validation-save",
		"version": version,
		"payload_schema": 1,
		"revision": revision,
		"session": {
			"token": "repository-test-token",
			"lifecycle": "active",
			"episode_id": "episode_001_afterlife_station",
			"flow_stage": "SIT-004",
			"checkpoint_id": "investigation:platform:observation-02",
			"return_target": "investigation:platform",
			"focus_token": ""
		},
		"snapshots": {
			"runtime": {},
			"preparation": {},
			"reasoning": {},
			"route": {},
			"recovery": {}
		},
		"result": {
			"axes": {},
			"candidate_records": {},
			"applied_effect_ids": {}
		},
		"timestamps": {
			"created_at_utc": "2026-08-02T02:20:00Z",
			"updated_at_utc": "2026-08-02T02:20:00Z",
			"completed_at_utc": ""
		},
		"integrity": {"content_episode_id": "episode_001_afterlife_station"}
	}


func _init() -> void:
	var repository = Repository.new(TEST_PRIMARY)
	_expect(repository.has_method("get_paths"), "repository must expose get_paths")
	_expect(repository.has_method("inspect"), "repository must expose inspect")
	_expect(repository.has_method("delete_persistence"), "repository must expose delete_persistence")
	_expect(repository.has_method("quarantine_primary"), "repository must expose quarantine_primary")
	if not repository.has_method("get_paths"):
		_finish()
		return

	var paths: Dictionary = repository.get_paths()
	Support.remove_repository_paths(paths)
	_expect(String(paths.get("primary", "")) == TEST_PRIMARY, "repository must preserve its configured primary")
	_expect(String(paths.get("primary", "")) != LEGACY_PATH, "Validation primary must differ from Legacy")

	var legacy_guard = Repository.new(LEGACY_PATH)
	_expect(String(legacy_guard.inspect().get("code", "")) == "LEGACY_GUARD_VIOLATION", "repository must reject the Legacy namespace")
	_expect(String(repository.inspect().get("code", "")) == "EMPTY", "missing primary should inspect EMPTY")
	_expect(String(repository.write_payload(_payload(1)).get("code", "")) == "OK", "first write should succeed")
	_expect(String(repository.inspect().get("code", "")) == "EXACT", "written primary should inspect EXACT")
	_expect(Support.semantic_equal(repository.read_payload().get("payload", {}), _payload(1)), "readback should equal written payload")

	_expect(String(repository.write_payload(_payload(2)).get("code", "")) == "OK", "second write should succeed")
	var backup_path := String(paths.get("backup", ""))
	_expect(FileAccess.file_exists(backup_path), "second write should preserve one backup")
	_expect(int(Support.read_json(backup_path).get("revision", -1)) == 1, "backup should contain the previous revision")

	var corrupt_text := "{broken-json"
	Support.write_text(String(paths.get("primary", "")), corrupt_text)
	_expect(String(repository.inspect().get("code", "")) == "CORRUPT_JSON", "broken JSON should remain inspectable")
	_expect(FileAccess.file_exists(String(paths.get("primary", ""))), "corrupt primary must not be auto deleted")
	var corrupt_bytes := Support.read_bytes(String(paths.get("primary", "")))
	var quarantine: Dictionary = repository.quarantine_primary("parse-failure")
	_quarantine_path = String(quarantine.get("quarantine_path", ""))
	_expect(String(quarantine.get("code", "")) == "OK", "explicit quarantine should succeed")
	_expect(FileAccess.file_exists(_quarantine_path), "quarantine should preserve a file")
	_expect(Support.read_bytes(_quarantine_path) == corrupt_bytes, "quarantine must preserve original corrupt bytes")

	Support.write_text(String(paths.get("primary", "")), JSON.stringify(_payload(3, "validation-save-v2")))
	var newer_before := Support.read_bytes(String(paths.get("primary", "")))
	_expect(String(repository.inspect().get("code", "")) == "INCOMPATIBLE_NEWER", "v2 should be inspect-only")
	_expect(String(repository.write_payload(_payload(4)).get("code", "")) == "INCOMPATIBLE_NEWER", "newer primary must not be overwritten")
	_expect(Support.read_bytes(String(paths.get("primary", ""))) == newer_before, "newer primary bytes must remain unchanged")

	Support.remove_path(String(paths.get("primary", "")))
	Support.remove_path(String(paths.get("backup", "")))
	Support.write_text(String(paths.get("temp", "")), JSON.stringify(_payload(5)))
	_expect(String(repository.inspect().get("code", "")) == "INTERRUPTED_WRITE", "temp-only state must not auto promote")
	_expect(not FileAccess.file_exists(String(paths.get("primary", ""))), "interrupted temp must not become primary")

	Support.remove_path(String(paths.get("temp", "")))
	Support.write_text(String(paths.get("backup", "")), JSON.stringify(_payload(6)))
	_expect(String(repository.inspect().get("code", "")) == "RECOVERABLE_BACKUP", "backup-only state must be reported as recoverable")
	_expect(not FileAccess.file_exists(String(paths.get("primary", ""))), "recoverable backup must not auto promote")

	repository.delete_persistence()
	Support.remove_path(_quarantine_path)
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("VALIDATION SAVE REPOSITORY: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
