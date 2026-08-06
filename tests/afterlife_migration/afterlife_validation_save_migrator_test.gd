extends SceneTree

const InspectorScript := preload("res://scripts/core/afterlife_legacy_save_inspector.gd")
const RegistryScript := preload("res://scripts/data/afterlife_id_migration_registry.gd")
const MIGRATOR_PATH := "res://scripts/core/afterlife_validation_save_migrator.gd"
const REGISTRY_PATH := "res://data/migrations/afterlife_station_canon_v2_id_migration.json"
const EPISODE_ID := "episode_001_afterlife_station"

var _failures: Array[String] = []
var _inspector = InspectorScript.new()
var _registry = RegistryScript.new()


func _init() -> void:
	_expect(String(_registry.load_registry(REGISTRY_PATH).get("code", "")) == "EXACT", "registry fixture failed")
	_expect(FileAccess.file_exists(MIGRATOR_PATH), "validation save migrator script missing")
	if FileAccess.file_exists(MIGRATOR_PATH):
		var script_value: Variant = load(MIGRATOR_PATH)
		_expect(script_value is Script, "validation save migrator failed to load")
		if script_value is Script:
			var migrator = (script_value as Script).new()
			_test_active_and_suspended(migrator)
			_test_completed_history(migrator)
			_test_source_isolation_and_fail_closed(migrator)
	_finish()


func _test_active_and_suspended(migrator: Object) -> void:
	for lifecycle in ["active", "suspended"]:
		var source := _validation_payload(lifecycle)
		var original_bytes := JSON.stringify(source).to_utf8_buffer()
		var inspected := _inspector.inspect_validation_bytes(original_bytes)
		var result: Dictionary = migrator.migrate(inspected, _registry)
		_expect(String(result.get("code", "")) == "MIGRATED_FROM_VALIDATION_V1", "%s validation migration failed" % lifecycle)
		var payload := result.get("payload", {}) as Dictionary
		_expect(String(payload.get("version", "")) == "validation-save-v2", "validation target version missing")
		_expect(int(payload.get("payload_schema", 0)) == 2, "validation target schema missing")
		_expect(String(payload.get("content_contract_id", "")) == "afterlife-station-canon-v2", "validation content contract missing")
		var session := payload.get("session", {}) as Dictionary
		_expect(String(session.get("lifecycle", "")) == "suspended", "migrated validation must await explicit resume")
		_expect(String(session.get("checkpoint_id", "")) == "afterlife:v2:safe-investigation-entry", "safe validation checkpoint missing")
		var snapshots := payload.get("snapshots", {}) as Dictionary
		_expect((snapshots.get("recovery", {}) as Dictionary).is_empty(), "legacy recovery remained active")
		_expect((snapshots.get("route", {}) as Dictionary).is_empty(), "legacy route answer remained active")
		var v2 := payload.get("afterlife_canon_v2", {}) as Dictionary
		var manual := v2.get("manual", {}) as Dictionary
		_expect(String(manual.get("state", "")) == "draft_active", "validation manual state mismatch")
		_expect((manual.get("filled_slots", {}) as Dictionary).is_empty(), "validation slots auto-filled")
		for record_value in manual.get("evidence_records", []) as Array:
			_expect(String((record_value as Dictionary).get("state", "")) == "migrated_unverified", "validation evidence leaked correctness")
		var legacy_snapshot := payload.get("legacy_validation_snapshot", {}) as Dictionary
		_expect(bool(legacy_snapshot.get("read_only", false)), "legacy validation snapshot must be read-only")
		_expect(String(legacy_snapshot.get("correct_response_id", "")) == "cut_false_broadcast", "legacy response provenance lost")
		_expect(not _contains_v2_completion_effect(payload), "v2 completion inferred from active validation")
		_expect(original_bytes == JSON.stringify(source).to_utf8_buffer(), "validation migrator mutated source bytes")


func _test_completed_history(migrator: Object) -> void:
	var source := _validation_payload("completed")
	(source.get("result", {}) as Dictionary)["applied_effect_ids"] = {"validation:afterlife:completion:v1": true}
	var inspected := _inspector.inspect_validation_bytes(JSON.stringify(source).to_utf8_buffer())
	var result: Dictionary = migrator.migrate(inspected, _registry)
	_expect(String(result.get("code", "")) == "MIGRATED_FROM_VALIDATION_V1", "completed validation migration failed")
	var payload := result.get("payload", {}) as Dictionary
	var snapshot := payload.get("legacy_validation_snapshot", {}) as Dictionary
	_expect(bool(snapshot.get("read_only", false)), "completed validation history is mutable")
	_expect(String(snapshot.get("lifecycle", "")) == "completed", "completed lifecycle lost")
	_expect(String((payload.get("session", {}) as Dictionary).get("lifecycle", "")) == "completed", "completed v2 lifecycle changed")
	_expect(not _contains_v2_completion_effect(payload), "legacy completion promoted to v2 reward")
	var result_block := payload.get("result", {}) as Dictionary
	_expect((result_block.get("applied_effect_ids", {}) as Dictionary).is_empty(), "legacy completion effect remained executable")


func _test_source_isolation_and_fail_closed(migrator: Object) -> void:
	var source := _validation_payload("active")
	var inspected := _inspector.inspect_validation_bytes(JSON.stringify(source).to_utf8_buffer())
	var inspected_copy := inspected.duplicate(true)
	migrator.migrate(inspected, _registry)
	_expect(inspected == inspected_copy, "validation migrator mutated inspected input")

	var invalid := inspected.duplicate(true)
	invalid["code"] = "CORRUPT_MIGRATION_SOURCE"
	var invalid_result: Dictionary = migrator.migrate(invalid, _registry)
	_expect(String(invalid_result.get("code", "")) == "INVALID_INSPECTION_RESULT", "invalid inspection accepted")


func _validation_payload(lifecycle: String) -> Dictionary:
	return {
		"format": "urban-legend-validation-save",
		"version": "validation-save-v1",
		"payload_schema": 1,
		"revision": 4,
		"session": {
			"token": "validation-token",
			"lifecycle": lifecycle,
			"episode_id": EPISODE_ID,
			"flow_stage": "SIT-003",
			"checkpoint_id": "legacy:recovery",
			"return_target": "res://scenes/battle_scene.tscn",
			"focus_token": "legacy-focus"
		},
		"snapshots": {
			"runtime": {"current_scene_path": "res://scenes/battle_scene.tscn"},
			"preparation": {"team": ["agent_kwon_narae"]},
			"reasoning": {
				"collected_clue_ids": ["clue_repeating_announcement", "clue_black_ticket"],
				"hypothesis_ids": ["poc001_hypothesis_broadcast_blank"]
			},
			"route": {"correct_response_id": "cut_false_broadcast", "selected_response_id": "cut_false_broadcast"},
			"recovery": {"pattern_id": "pattern_station_false_terminal", "turn": 2}
		},
		"result": {
			"axes": {"safety": 2},
			"candidate_records": {"clue_repeating_announcement": true},
			"applied_effect_ids": {}
		},
		"timestamps": {"created_at_utc": "2026-08-01T00:00:00Z"},
		"integrity": {"content_episode_id": EPISODE_ID}
	}


func _contains_v2_completion_effect(payload: Dictionary) -> bool:
	var result := payload.get("result", {}) as Dictionary
	return (result.get("applied_effect_ids", {}) as Dictionary).has("validation:afterlife:completion:v2")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("AFTERLIFE VALIDATION SAVE MIGRATOR: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
