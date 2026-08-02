extends SceneTree

const Support = preload("res://tests/validation/validation_test_support.gd")

var _failures: Array[String] = []


func _init() -> void:
	var script: Script = load("res://scripts/core/validation_save_repository.gd")
	_expect(script != null, "validation repository script must exist before persistence tests can run")
	if script == null:
		_finish()
		return

	var repository = script.new()
	_expect(repository.has_method("get_primary_path"), "repository must expose get_primary_path")
	_expect(repository.has_method("write_payload"), "repository must expose write_payload")
	_expect(repository.has_method("read_payload"), "repository must expose read_payload")
	_expect(repository.has_method("inspect_primary"), "repository must expose inspect_primary")
	_expect(repository.has_method("delete_validation_files"), "repository must expose delete_validation_files")
	if not repository.has_method("get_primary_path"):
		_finish()
		return

	var primary_path := String(repository.get_primary_path())
	_expect(primary_path == "user://urban_legend_validation_save.json", "repository must use the independent Validation namespace")
	_expect(primary_path != "user://urban_legend_save.json", "repository must never target the Legacy save path")

	if repository.has_method("delete_validation_files"):
		repository.delete_validation_files()

	var payload := {
		"save_version": "validation-save-v1",
		"session": {
			"session_id": "validation-test-session",
			"episode_id": "episode_001_afterlife_station",
			"lifecycle": "ACTIVE",
			"stage": "SIT-001"
		}
	}
	if repository.has_method("write_payload"):
		var write_result: Dictionary = repository.write_payload(payload)
		_expect(bool(write_result.get("ok", false)), "valid Validation payload must write successfully")
	if repository.has_method("read_payload"):
		var read_result: Dictionary = repository.read_payload()
		_expect(bool(read_result.get("ok", false)), "written Validation payload must read successfully")
		_expect(Support.semantic_equal(read_result.get("payload", {}), payload), "read payload must preserve the written values")
	if repository.has_method("inspect_primary"):
		var inspect_result: Dictionary = repository.inspect_primary()
		_expect(String(inspect_result.get("status", "")) == "EXACT", "valid v1 payload must inspect as EXACT")

	if repository.has_method("delete_validation_files"):
		repository.delete_validation_files()
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
