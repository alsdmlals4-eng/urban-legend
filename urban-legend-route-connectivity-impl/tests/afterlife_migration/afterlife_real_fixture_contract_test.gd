extends SceneTree

const GAME_STATE_PATH := "res://scripts/core/afterlife_migrating_game_state.gd"
const SESSION_PATH := "res://scripts/core/afterlife_migrating_validation_session.gd"
const MAIN_PATH := "user://urban_legend_save.json"
const VALIDATION_PATH := "user://afterlife_real_fixture_validation.json"
const FIXTURE_ROOT := "res://tests/fixtures/afterlife_migration"
const MAIN_INVESTIGATION := FIXTURE_ROOT + "/main_mvp038_investigation.json"
const MAIN_RECOVERY := FIXTURE_ROOT + "/main_mvp039_recovery.json"
const MAIN_COMPLETED := FIXTURE_ROOT + "/main_mvp039_completed.json"
const VALIDATION_ACTIVE := FIXTURE_ROOT + "/validation_v1_active_recovery.json"
const EPISODE_ID := "episode_001_afterlife_station"

var _failures: Array[String] = []


func _init() -> void:
	_cleanup()
	for fixture_path in [MAIN_INVESTIGATION, MAIN_RECOVERY, MAIN_COMPLETED, VALIDATION_ACTIVE]:
		_expect(FileAccess.file_exists(fixture_path), "representative fixture missing: %s" % fixture_path)
	_expect(FileAccess.file_exists(GAME_STATE_PATH), "migrating GameState wrapper missing")
	_expect(FileAccess.file_exists(SESSION_PATH), "migrating ValidationSession wrapper missing")
	if _failures.is_empty():
		var game_script_value: Variant = load(GAME_STATE_PATH)
		var session_script_value: Variant = load(SESSION_PATH)
		_expect(game_script_value is Script, "migrating GameState failed to load")
		_expect(session_script_value is Script, "migrating ValidationSession failed to load")
		if game_script_value is Script and session_script_value is Script:
			var game_script := game_script_value as Script
			var session_script := session_script_value as Script
			_test_investigation_fixture(game_script)
			_test_recovery_fixture(game_script)
			_test_completed_fixture(game_script)
			_test_validation_fixture(game_script, session_script)
	_cleanup()
	_finish()


func _test_investigation_fixture(game_script: Script) -> void:
	_copy_fixture(MAIN_INVESTIGATION, MAIN_PATH)
	var original := _read_json(MAIN_PATH)
	var game_state = game_script.new()
	_expect(game_state.load_game(), "mvp-038 investigation fixture failed to migrate")
	var stored := _read_json(MAIN_PATH)
	_expect(String(stored.get("save_version", "")) == "mvp-040", "investigation fixture target version mismatch")
	_expect(String(stored.get("content_contract_id", "")) == "afterlife-station-canon-v2", "investigation fixture contract missing")
	var v2 := stored.get("afterlife_canon_v2", {}) as Dictionary
	var manual := v2.get("manual", {}) as Dictionary
	_expect(String(manual.get("state", "")) == "draft_active", "investigation fixture manual state mismatch")
	_expect((manual.get("filled_slots", {}) as Dictionary).is_empty(), "investigation fixture auto-filled answer slots")
	for record_value in manual.get("evidence_records", []) as Array:
		_expect(typeof(record_value) == TYPE_DICTIONARY, "investigation fixture evidence is not Dictionary")
		if typeof(record_value) == TYPE_DICTIONARY:
			_expect(String((record_value as Dictionary).get("state", "")) == "migrated_unverified", "investigation fixture leaked correctness")
	_expect(_has_orphan(stored, "unknown_legacy_id"), "investigation fixture orphan ID missing")
	_expect(int(stored.get("echo_fragments", -1)) == int(original.get("echo_fragments", -2)), "investigation fixture echo fragments changed")
	_expect((stored.get("granted_reward_ids", []) as Array) == (original.get("granted_reward_ids", []) as Array), "investigation fixture rewards changed")
	var history_before := (stored.get("migration_history", []) as Array).size()
	game_state.free()
	var second_state = game_script.new()
	_expect(second_state.load_game(), "migrated investigation fixture failed second load")
	var second := _read_json(MAIN_PATH)
	_expect((second.get("migration_history", []) as Array).size() == history_before, "investigation fixture migration history duplicated")
	second_state.free()


func _test_recovery_fixture(game_script: Script) -> void:
	_copy_fixture(MAIN_RECOVERY, MAIN_PATH)
	var game_state = game_script.new()
	_expect(game_state.load_game(), "mvp-039 recovery fixture failed to migrate")
	var stored := _read_json(MAIN_PATH)
	var v2 := stored.get("afterlife_canon_v2", {}) as Dictionary
	_expect(String(v2.get("run_state", "")) == "legacy_case_restart_required", "recovery fixture restart state missing")
	_expect(int(v2.get("restart_penalty", -1)) == 0, "recovery fixture gained a restart penalty")
	_expect(String(v2.get("safe_checkpoint_id", "")) == "afterlife:v2:safe-investigation-entry", "recovery fixture safe checkpoint mismatch")
	_expect(String(stored.get("current_scene_path", "")) == "res://scenes/investigation_scene.tscn", "recovery fixture retained unsafe battle scene")
	_expect(String(stored.get("current_recovery_pattern_id", "")) == "", "recovery fixture retained legacy recovery pattern")
	_expect(not bool(stored.get("forced_recovery_phase", true)), "recovery fixture retained forced recovery")
	game_state.free()


func _test_completed_fixture(game_script: Script) -> void:
	_copy_fixture(MAIN_COMPLETED, MAIN_PATH)
	var original := _read_json(MAIN_PATH)
	var game_state = game_script.new()
	_expect(game_state.load_game(), "mvp-039 completed fixture failed to migrate")
	var stored := _read_json(MAIN_PATH)
	var snapshot := stored.get("legacy_resolution_snapshot", {}) as Dictionary
	_expect(bool(snapshot.get("read_only", false)), "completed fixture snapshot is not read-only")
	_expect(String(snapshot.get("grade", "")) == "A", "completed fixture grade changed")
	var first_v2 := stored.get("first_v2_investigation", {}) as Dictionary
	_expect(String(first_v2.get("status", "")) == "not_started", "completed fixture became a v2 completion")
	_expect(not bool(first_v2.get("s_rank_awarded", true)), "completed fixture gained v2 S rank")
	_expect((stored.get("granted_reward_ids", []) as Array) == (original.get("granted_reward_ids", []) as Array), "completed fixture rewards duplicated or removed")
	_expect((stored.get("completed_case_reports", []) as Array) == (original.get("completed_case_reports", []) as Array), "completed fixture report changed")
	game_state.free()


func _test_validation_fixture(game_script: Script, session_script: Script) -> void:
	_copy_fixture(VALIDATION_ACTIVE, VALIDATION_PATH)
	var game_state = game_script.new()
	var hidden_before: Dictionary = game_state.snapshot_hidden_legacy_state_for_test()
	var session = session_script.new()
	session.configure_repository_path_for_test(VALIDATION_PATH)
	var loaded: Dictionary = session.load(game_state)
	_expect(String(loaded.get("code", "")) == "OK", "validation fixture failed to migrate")
	var stored := _read_json(VALIDATION_PATH)
	_expect(String(stored.get("version", "")) == "validation-save-v2", "validation fixture target version mismatch")
	_expect(int(stored.get("payload_schema", 0)) == 2, "validation fixture schema mismatch")
	var snapshots := stored.get("snapshots", {}) as Dictionary
	_expect((snapshots.get("route", {}) as Dictionary).is_empty(), "validation fixture retained legacy route semantics")
	_expect((snapshots.get("recovery", {}) as Dictionary).is_empty(), "validation fixture retained legacy recovery semantics")
	_expect(game_state.snapshot_hidden_legacy_state_for_test() == hidden_before, "validation fixture changed hidden main state")
	var resume: Dictionary = session.resume(game_state)
	_expect(String(resume.get("code", "")) == "OK", "validation fixture could not resume after migration")
	session.free()
	game_state.free()


func _copy_fixture(source: String, destination: String) -> void:
	var bytes := FileAccess.get_file_as_bytes(source)
	_expect(not bytes.is_empty(), "fixture bytes empty: %s" % source)
	var file := FileAccess.open(destination, FileAccess.WRITE)
	_expect(file != null, "failed to open fixture destination: %s" % destination)
	if file != null:
		file.store_buffer(bytes)
		file.flush()
		file.close()


func _has_orphan(payload: Dictionary, legacy_id: String) -> bool:
	for orphan_value in payload.get("orphan_legacy_ids", []) as Array:
		if typeof(orphan_value) == TYPE_DICTIONARY and String((orphan_value as Dictionary).get("id", "")) == legacy_id:
			return true
	return false


func _read_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	return parsed as Dictionary if typeof(parsed) == TYPE_DICTIONARY else {}


func _remove(path: String) -> void:
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	var stem: String = path.trim_suffix(".json") if path.ends_with(".json") else path
	for suffix_value in [".migration.tmp.json", ".migration.bak.json", ".migration.old.json", ".migration.journal.json", ".tmp.json", ".bak.json"]:
		var artifact := stem + String(suffix_value)
		if FileAccess.file_exists(artifact):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(artifact))


func _cleanup() -> void:
	_remove(MAIN_PATH)
	_remove(VALIDATION_PATH)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("AFTERLIFE REAL FIXTURE CONTRACT: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
