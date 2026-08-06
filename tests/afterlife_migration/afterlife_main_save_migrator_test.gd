extends SceneTree

const InspectorScript := preload("res://scripts/core/afterlife_legacy_save_inspector.gd")
const RegistryScript := preload("res://scripts/data/afterlife_id_migration_registry.gd")
const MIGRATOR_PATH := "res://scripts/core/afterlife_main_save_migrator.gd"
const REGISTRY_PATH := "res://data/migrations/afterlife_station_canon_v2_id_migration.json"
const EPISODE_ID := "episode_001_afterlife_station"

var _failures: Array[String] = []
var _registry = RegistryScript.new()
var _inspector = InspectorScript.new()


func _init() -> void:
	var loaded := _registry.load_registry(REGISTRY_PATH)
	_expect(String(loaded.get("code", "")) == "EXACT", "registry fixture failed")
	_expect(FileAccess.file_exists(MIGRATOR_PATH), "main save migrator script missing")
	if FileAccess.file_exists(MIGRATOR_PATH):
		var script_value: Variant = load(MIGRATOR_PATH)
		_expect(script_value is Script, "main save migrator failed to load")
		if script_value is Script:
			var migrator = (script_value as Script).new()
			_test_pre_run(migrator)
			_test_investigation(migrator)
			_test_recovery_restart(migrator)
			_test_completed_history(migrator)
			_test_mvp038_result_code(migrator)
	_finish()


func _test_pre_run(migrator: Object) -> void:
	var source := _base_payload("mvp-039", "res://scenes/preparation_scene.tscn")
	var inspected := _inspect(source)
	var protected_before := _protected_snapshot(inspected.get("payload", {}) as Dictionary)
	var result: Dictionary = migrator.migrate(inspected, _registry)
	_expect(String(result.get("code", "")) == "MIGRATED_FROM_MVP_039", "pre-run migration code mismatch")
	var payload := result.get("payload", {}) as Dictionary
	_expect(String(payload.get("save_version", "")) == "mvp-040", "pre-run target version missing")
	_expect(String(payload.get("content_contract_id", "")) == "afterlife-station-canon-v2", "pre-run contract missing")
	var v2 := payload.get("afterlife_canon_v2", {}) as Dictionary
	_expect(String(v2.get("run_state", "")) == "new_run_ready", "pre-run should create a new v2 run")
	_expect(_manual(payload).get("filled_slots", {}) == {}, "pre-run slots auto-filled")
	_expect(_protected_snapshot(payload) == protected_before, "pre-run changed protected state")


func _test_investigation(migrator: Object) -> void:
	var source := _base_payload("mvp-039", "res://scenes/investigation_scene.tscn")
	source["collected_clue_ids"] = [
		"clue_repeating_announcement",
		"clue_staff_room_log",
		"clue_black_ticket",
		"unknown_legacy_id"
	]
	source["unlocked_records"] = ["clue_last_message"]
	var source_copy := source.duplicate(true)
	var inspected := _inspect(source)
	var protected_before := _protected_snapshot(inspected.get("payload", {}) as Dictionary)
	var result: Dictionary = migrator.migrate(inspected, _registry)
	_expect(String(result.get("code", "")) == "MIGRATED_FROM_MVP_039", "investigation migration code mismatch")
	var payload := result.get("payload", {}) as Dictionary
	var manual := _manual(payload)
	_expect(String(manual.get("state", "")) == "draft_active", "investigation manual state mismatch")
	_expect(manual.get("filled_slots", {}) == {}, "investigation slots auto-filled")
	var evidence := manual.get("evidence_records", []) as Array
	_expect(evidence.size() >= 5, "migrated evidence coverage too small")
	for record_value in evidence:
		_expect(typeof(record_value) == TYPE_DICTIONARY, "migrated evidence must be Dictionary")
		if typeof(record_value) == TYPE_DICTIONARY:
			_expect(String((record_value as Dictionary).get("state", "")) == "migrated_unverified", "migrated evidence leaked correctness")
	var orphans := (payload.get("orphan_legacy_ids", []) as Array)
	_expect(orphans.size() == 1, "unknown legacy ID not preserved exactly once")
	_expect(String((orphans[0] as Dictionary).get("id", "")) == "unknown_legacy_id", "orphan legacy ID changed")
	var notes := payload.get("legacy_migration_notes", []) as Array
	_expect(_contains_legacy_id(notes, "clue_black_ticket"), "historical black ticket note lost")
	_expect(_protected_snapshot(payload) == protected_before, "investigation changed protected state")
	_expect(source == source_copy, "migrator mutated source payload")
	_expect((payload.get("migration_history", []) as Array).size() == 1, "migration history missing")


func _test_recovery_restart(migrator: Object) -> void:
	var source := _base_payload("mvp-039", "res://scenes/battle_scene.tscn")
	source["current_recovery_pattern_id"] = "pattern_station_ticket_imprint"
	var inspected := _inspect(source)
	var protected_before := _protected_snapshot(inspected.get("payload", {}) as Dictionary)
	var result: Dictionary = migrator.migrate(inspected, _registry)
	_expect(String(result.get("code", "")) == "LEGACY_CASE_RESTART_REQUIRED", "legacy recovery did not require restart")
	var payload := result.get("payload", {}) as Dictionary
	var v2 := payload.get("afterlife_canon_v2", {}) as Dictionary
	_expect(String(v2.get("run_state", "")) == "legacy_case_restart_required", "restart state missing")
	_expect(int(v2.get("restart_penalty", -1)) == 0, "restart penalty added")
	_expect(String(v2.get("safe_checkpoint_id", "")) == "afterlife:v2:safe-investigation-entry", "safe checkpoint missing")
	_expect(String(payload.get("current_scene_path", "")) == "res://scenes/investigation_scene.tscn", "unsafe battle scene retained")
	_expect(String(payload.get("current_recovery_pattern_id", "")) == "", "legacy recovery pattern remained active")
	_expect(not bool(payload.get("forced_recovery_phase", true)), "forced recovery remained active")
	_expect(_protected_snapshot(payload) == protected_before, "restart changed protected state")


func _test_completed_history(migrator: Object) -> void:
	var source := _base_payload("mvp-039", "res://scenes/result_scene.tscn")
	source["capture_success"] = true
	source["capture_result_state"] = "stable"
	source["selected_resolution_grade"] = "A"
	source["completed_case_reports"] = [{"episode_id": EPISODE_ID, "grade": "A", "content_contract_id": "afterlife-station-legacy-v1"}]
	source["granted_reward_ids"] = ["reward:legacy:afterlife:A"]
	var inspected := _inspect(source)
	var inspected_payload := inspected.get("payload", {}) as Dictionary
	var reward_before := (inspected_payload.get("granted_reward_ids", []) as Array).duplicate(true)
	var report_before := (inspected_payload.get("completed_case_reports", []) as Array).duplicate(true)
	var result: Dictionary = migrator.migrate(inspected, _registry)
	_expect(String(result.get("code", "")) == "MIGRATED_FROM_MVP_039", "completed migration code mismatch")
	var payload := result.get("payload", {}) as Dictionary
	var snapshot := payload.get("legacy_resolution_snapshot", {}) as Dictionary
	_expect(bool(snapshot.get("read_only", false)), "legacy completion snapshot must be read-only")
	_expect(String(snapshot.get("grade", "")) == "A", "legacy grade lost")
	var first_v2 := payload.get("first_v2_investigation", {}) as Dictionary
	_expect(String(first_v2.get("status", "")) == "not_started", "completed legacy run became v2 completion")
	_expect(not bool(first_v2.get("s_rank_awarded", true)), "legacy result promoted to v2 S rank")
	_expect((payload.get("granted_reward_ids", []) as Array) == reward_before, "legacy reward duplicated or removed")
	_expect((payload.get("completed_case_reports", []) as Array) == report_before, "legacy report overwritten")


func _test_mvp038_result_code(migrator: Object) -> void:
	var source := _base_payload("mvp-038", "res://scenes/investigation_scene.tscn")
	var result: Dictionary = migrator.migrate(_inspect(source), _registry)
	_expect(String(result.get("code", "")) == "MIGRATED_FROM_MVP_038", "mvp-038 result code mismatch")
	_expect(String((result.get("payload", {}) as Dictionary).get("save_version", "")) == "mvp-040", "mvp-038 target version mismatch")


func _inspect(payload: Dictionary) -> Dictionary:
	var inspected: Dictionary = _inspector.inspect_main_bytes(JSON.stringify(payload).to_utf8_buffer())
	_expect(String(inspected.get("code", "")) == "MIGRATABLE_MAIN", "main fixture inspection failed")
	return inspected


func _base_payload(version: String, scene_path: String) -> Dictionary:
	return {
		"save_version": version,
		"episode_id": EPISODE_ID,
		"episode_path": "res://data/episodes/episode_001_afterlife_station.json",
		"current_scene_path": scene_path,
		"current_recovery_pattern_id": "",
		"forced_recovery_phase": false,
		"capture_success": false,
		"collected_clue_ids": [],
		"unlocked_records": [],
		"completed_case_reports": [],
		"campaign_state": {"day": 5, "resolved_cases": [EPISODE_ID]},
		"echo_fragments": 77,
		"granted_reward_ids": ["reward:existing"],
		"faction_relations": {"rumor_market": 12},
		"consumable_inventory": {"consumable_first_aid": 2},
		"unlocked_equipment": ["gear_resonance_prism"],
		"agent_trust": {"agent_kwon_narae": 2}
	}


func _manual(payload: Dictionary) -> Dictionary:
	return (payload.get("afterlife_canon_v2", {}) as Dictionary).get("manual", {}) as Dictionary


func _protected_snapshot(payload: Dictionary) -> Dictionary:
	var result := {}
	for key in ["campaign_state", "echo_fragments", "granted_reward_ids", "faction_relations", "consumable_inventory", "unlocked_equipment", "agent_trust", "completed_case_reports"]:
		var value: Variant = payload.get(key)
		result[key] = value.duplicate(true) if typeof(value) in [TYPE_DICTIONARY, TYPE_ARRAY] else value
	return result


func _contains_legacy_id(notes: Array, legacy_id: String) -> bool:
	for note_value in notes:
		if typeof(note_value) == TYPE_DICTIONARY and String((note_value as Dictionary).get("legacy_id", "")) == legacy_id:
			return true
	return false


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("AFTERLIFE MAIN SAVE MIGRATOR: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
