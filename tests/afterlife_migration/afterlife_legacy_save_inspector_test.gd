extends SceneTree

const SCRIPT_PATH := "res://scripts/core/afterlife_legacy_save_inspector.gd"
const EPISODE_ID := "episode_001_afterlife_station"

var _failures: Array[String] = []


func _init() -> void:
	_expect(FileAccess.file_exists(SCRIPT_PATH), "legacy save inspector script missing")
	if FileAccess.file_exists(SCRIPT_PATH):
		var script_value: Variant = load(SCRIPT_PATH)
		_expect(script_value is Script, "legacy save inspector failed to load")
		if script_value is Script:
			_test_main_stages((script_value as Script).new())
			_test_validation_stages((script_value as Script).new())
			_test_checksum_and_fail_closed((script_value as Script).new())
	_finish()


func _test_main_stages(inspector: Object) -> void:
	var fixtures := [
		{
			"payload": _main_payload("mvp-038", "res://scenes/preparation_scene.tscn"),
			"stage": "PRE_RUN",
			"code": "MIGRATABLE_MAIN"
		},
		{
			"payload": _main_payload("mvp-039", "res://scenes/investigation_scene.tscn"),
			"stage": "INVESTIGATION_ACTIVE",
			"code": "MIGRATABLE_MAIN"
		},
		{
			"payload": _main_payload("mvp-039", "res://scenes/battle_scene.tscn", {"current_recovery_pattern_id": "pattern_station_false_terminal"}),
			"stage": "LEGACY_RESCUE_OR_RECOVERY_ACTIVE",
			"code": "MIGRATABLE_MAIN"
		},
		{
			"payload": _main_payload("mvp-039", "res://scenes/result_scene.tscn", {"capture_success": true}),
			"stage": "LEGACY_COMPLETED",
			"code": "MIGRATABLE_MAIN"
		}
	]
	for fixture_value in fixtures:
		var fixture := fixture_value as Dictionary
		var bytes := _json_bytes(fixture.get("payload", {}) as Dictionary)
		var original := bytes.duplicate()
		var result: Dictionary = inspector.inspect_main_bytes(bytes)
		_expect(String(result.get("code", "")) == String(fixture.get("code", "")), "main inspect code mismatch")
		_expect(String(result.get("run_stage", "")) == String(fixture.get("stage", "")), "main stage mismatch: %s" % fixture.get("stage", ""))
		_expect(String(result.get("source_version", "")) in ["mvp-038", "mvp-039"], "main source version missing")
		_expect(String(result.get("episode_id", "")) == EPISODE_ID, "main episode ID mismatch")
		_expect(String(result.get("source_checksum", "")).length() == 64, "main checksum missing")
		_expect(bytes == original, "inspector mutated source bytes")


func _test_validation_stages(inspector: Object) -> void:
	for lifecycle in ["active", "suspended", "completed"]:
		var payload := {
			"format": "urban-legend-validation-save",
			"version": "validation-save-v1",
			"payload_schema": 1,
			"revision": 3,
			"session": {
				"token": "token-%s" % lifecycle,
				"lifecycle": lifecycle,
				"episode_id": EPISODE_ID,
				"flow_stage": "SIT-001"
			},
			"snapshots": {"runtime": {}, "preparation": {}, "reasoning": {}, "route": {}, "recovery": {}},
			"result": {"axes": {}, "candidate_records": {}, "applied_effect_ids": {}},
			"timestamps": {},
			"integrity": {"content_episode_id": EPISODE_ID}
		}
		var bytes := _json_bytes(payload)
		var result: Dictionary = inspector.inspect_validation_bytes(bytes)
		_expect(String(result.get("code", "")) == "MIGRATABLE_VALIDATION", "validation inspect code mismatch")
		_expect(String(result.get("run_stage", "")) == "VALIDATION_%s" % lifecycle.to_upper(), "validation lifecycle mismatch")
		_expect(String(result.get("source_version", "")) == "validation-save-v1", "validation version missing")
		_expect(String(result.get("source_checksum", "")).length() == 64, "validation checksum missing")


func _test_checksum_and_fail_closed(inspector: Object) -> void:
	var payload := _main_payload("mvp-039", "res://scenes/investigation_scene.tscn")
	var bytes := _json_bytes(payload)
	var exact: Dictionary = inspector.inspect_main_bytes(bytes)
	var changed := bytes.duplicate()
	changed.append(32)
	var changed_result: Dictionary = inspector.inspect_main_bytes(changed)
	_expect(String(exact.get("source_checksum", "")) != String(changed_result.get("source_checksum", "")), "checksum did not change with bytes")

	var unsupported := _main_payload("mvp-037", "res://scenes/investigation_scene.tscn")
	var unsupported_result: Dictionary = inspector.inspect_main_bytes(_json_bytes(unsupported))
	_expect(String(unsupported_result.get("code", "")) == "UNSUPPORTED_SOURCE_VERSION", "unsupported version accepted")

	var ambiguous := _main_payload("mvp-039", "res://scenes/main_menu.tscn", {"current_recovery_pattern_id": "pattern_station_false_terminal"})
	var ambiguous_result: Dictionary = inspector.inspect_main_bytes(_json_bytes(ambiguous))
	_expect(String(ambiguous_result.get("code", "")) == "AMBIGUOUS_LEGACY_STAGE", "ambiguous main stage guessed")

	var wrong_episode := _main_payload("mvp-039", "res://scenes/investigation_scene.tscn", {"episode_id": "episode_002_red_umbrella_alley"})
	var wrong_result: Dictionary = inspector.inspect_main_bytes(_json_bytes(wrong_episode))
	_expect(String(wrong_result.get("code", "")) == "CONTENT_EPISODE_MISMATCH", "wrong episode accepted")

	var corrupt_result: Dictionary = inspector.inspect_main_bytes("not-json".to_utf8_buffer())
	_expect(String(corrupt_result.get("code", "")) == "CORRUPT_MIGRATION_SOURCE", "corrupt source accepted")


func _main_payload(version: String, scene_path: String, extra: Dictionary = {}) -> Dictionary:
	var payload := {
		"save_version": version,
		"episode_id": EPISODE_ID,
		"episode_path": "res://data/episodes/episode_001_afterlife_station.json",
		"current_scene_path": scene_path,
		"current_recovery_pattern_id": "",
		"forced_recovery_phase": false,
		"capture_success": false,
		"completed_case_reports": []
	}
	for key in extra.keys():
		payload[key] = extra[key]
	return payload


func _json_bytes(payload: Dictionary) -> PackedByteArray:
	return JSON.stringify(payload).to_utf8_buffer()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("AFTERLIFE LEGACY SAVE INSPECTOR: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
