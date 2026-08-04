extends SceneTree

const GAME_STATE_PATH := "res://scripts/core/afterlife_migrating_game_state.gd"
const SESSION_PATH := "res://scripts/core/afterlife_migrating_validation_session.gd"
const PROJECT_PATH := "res://project.godot"
const MAIN_PATH := "user://urban_legend_save.json"
const VALIDATION_PATH := "user://afterlife_migration_integration_validation.json"
const EPISODE_ID := "episode_001_afterlife_station"

var _failures: Array[String] = []


func _init() -> void:
	_cleanup()
	_expect(FileAccess.file_exists(GAME_STATE_PATH), "migrating GameState wrapper missing")
	_expect(FileAccess.file_exists(SESSION_PATH), "migrating ValidationSession wrapper missing")
	var project_text := FileAccess.get_file_as_string(PROJECT_PATH)
	_expect(project_text.contains("GameState=\"*res://scripts/core/afterlife_migrating_game_state.gd\""), "GameState autoload not migrated")
	_expect(project_text.contains("ValidationSession=\"*res://scripts/core/afterlife_migrating_validation_session.gd\""), "ValidationSession autoload not migrated")
	if FileAccess.file_exists(GAME_STATE_PATH) and FileAccess.file_exists(SESSION_PATH):
		var game_script_value: Variant = load(GAME_STATE_PATH)
		var session_script_value: Variant = load(SESSION_PATH)
		_expect(game_script_value is Script, "migrating GameState failed to load")
		_expect(session_script_value is Script, "migrating ValidationSession failed to load")
		if game_script_value is Script and session_script_value is Script:
			_test_main_success(game_script_value as Script)
			_test_main_runtime_failure_rollback(game_script_value as Script)
			_test_validation_success(game_script_value as Script, session_script_value as Script)
			_test_validation_runtime_failure_rollback(game_script_value as Script, session_script_value as Script)
	_cleanup()
	_finish()


func _test_main_success(game_script: Script) -> void:
	var legacy := _main_payload("res://scenes/investigation_scene.tscn")
	legacy["collected_clue_ids"] = ["clue_repeating_announcement", "clue_black_ticket"]
	_write_json(MAIN_PATH, legacy)
	var game_state = game_script.new()
	var loaded: bool = game_state.load_game()
	_expect(loaded, "legacy main save failed to load through migration")
	var stored := _read_json(MAIN_PATH)
	_expect(String(stored.get("save_version", "")) == "mvp-040", "main primary not upgraded to mvp-040")
	_expect(String(stored.get("content_contract_id", "")) == "afterlife-station-canon-v2", "main contract not upgraded")
	_expect(String(game_state.get_afterlife_content_contract_id()) == "afterlife-station-canon-v2", "runtime contract missing")
	_expect(String(game_state.get_current_episode_id()) == EPISODE_ID, "episode identity split")
	var manual: Dictionary = game_state.get_afterlife_manual_state()
	_expect((manual.get("filled_slots", {}) as Dictionary).is_empty(), "runtime migration auto-filled answer slots")
	var episode: Dictionary = game_state.get_current_episode()
	_expect(typeof(episode.get("recovery_encounters")) == TYPE_DICTIONARY, "Canon v2 episode block not active")
	_expect(not episode.has("recovery_patterns"), "legacy and v2 patterns mixed at runtime")
	_expect(game_state.save_game(), "mvp-040 save failed")
	_expect(String(_read_json(MAIN_PATH).get("save_version", "")) == "mvp-040", "new write regressed from mvp-040")
	game_state.free()


func _test_main_runtime_failure_rollback(game_script: Script) -> void:
	var legacy := _main_payload("res://scenes/investigation_scene.tscn")
	var original_bytes := _write_json(MAIN_PATH, legacy)
	var game_state = game_script.new()
	game_state.configure_migration_runtime_failure_for_test(true)
	_expect(not game_state.load_game(), "injected main runtime failure unexpectedly succeeded")
	_expect(_read_bytes(MAIN_PATH) == original_bytes, "main runtime failure did not restore original bytes")
	var result: Dictionary = game_state.get_last_migration_result()
	_expect(String(result.get("state", "")) == "ROLLBACK_RESTORED", "main runtime failure rollback state missing")
	game_state.free()


func _test_validation_success(game_script: Script, session_script: Script) -> void:
	_remove(VALIDATION_PATH)
	var game_state = game_script.new()
	var session = session_script.new()
	session.configure_repository_path_for_test(VALIDATION_PATH)
	var hidden_before: Dictionary = game_state.snapshot_hidden_legacy_state_for_test()
	_write_json(VALIDATION_PATH, _validation_payload("active"))
	var loaded: Dictionary = session.load(game_state)
	_expect(String(loaded.get("code", "")) == "OK", "Validation v1 integration load failed")
	var stored := _read_json(VALIDATION_PATH)
	_expect(String(stored.get("version", "")) == "validation-save-v2", "Validation primary not upgraded to v2")
	_expect(int(stored.get("payload_schema", 0)) == 2, "Validation v2 schema missing")
	_expect(game_state.snapshot_hidden_legacy_state_for_test() == hidden_before, "Validation migration changed hidden main state")
	_expect((stored.get("snapshots", {}) as Dictionary).get("route", {}) == {}, "Validation legacy route remained active")
	_expect((stored.get("snapshots", {}) as Dictionary).get("recovery", {}) == {}, "Validation legacy recovery remained active")
	var resume: Dictionary = session.resume(game_state)
	_expect(String(resume.get("code", "")) == "OK", "migrated Validation session could not resume")
	var saved: Dictionary = session.save(game_state)
	_expect(String(saved.get("code", "")) == "OK", "migrated Validation session could not write v2")
	_expect(String(_read_json(VALIDATION_PATH).get("version", "")) == "validation-save-v2", "Validation save regressed to v1")
	session.free()
	game_state.free()


func _test_validation_runtime_failure_rollback(game_script: Script, session_script: Script) -> void:
	_remove(VALIDATION_PATH)
	var original_bytes := _write_json(VALIDATION_PATH, _validation_payload("active"))
	var game_state = game_script.new()
	var session = session_script.new()
	session.configure_repository_path_for_test(VALIDATION_PATH)
	session.configure_migration_runtime_failure_for_test(true)
	var hidden_before: Dictionary = game_state.snapshot_hidden_legacy_state_for_test()
	var loaded: Dictionary = session.load(game_state)
	_expect(String(loaded.get("code", "")) == "RESTORE_FAILED", "injected Validation runtime failure code mismatch")
	_expect(_read_bytes(VALIDATION_PATH) == original_bytes, "Validation runtime failure did not restore v1 bytes")
	_expect(game_state.snapshot_hidden_legacy_state_for_test() == hidden_before, "Validation runtime failure changed hidden state")
	var result: Dictionary = session.get_last_migration_result()
	_expect(String(result.get("state", "")) == "ROLLBACK_RESTORED", "Validation rollback state missing")
	session.free()
	game_state.free()


func _main_payload(scene_path: String) -> Dictionary:
	return {
		"save_version": "mvp-039",
		"episode_id": EPISODE_ID,
		"episode_path": "res://data/episodes/episode_001_afterlife_station.json",
		"current_scene_path": scene_path,
		"current_dialogue_node_id": "dialogue_intro",
		"current_field_node_id": "dialogue_intro",
		"current_minigame_id": "minigame_frequency_sync",
		"selected_agent_ids": ["agent_kwon_narae", "agent_oh_hyun", "agent_kang_ijun"],
		"flags": [],
		"seen_hint_ids": [],
		"seen_log_tutorial_ids": [],
		"minigame_results": {},
		"method_results": {},
		"agent_trust": {},
		"triggered_agent_event_ids": [],
		"used_agent_supports": [],
		"unlocked_records": [],
		"unlocked_equipment": [],
		"unlocked_research_rewards": [],
		"equipped_items": [],
		"used_equipment_effects": [],
		"completed_case_reports": [],
		"anomaly_manual_records": {},
		"completed_daily_episode_records": [],
		"active_daily_episode": {},
		"echo_fragments": 77,
		"granted_reward_ids": ["reward:existing"],
		"faction_relations": {"rumor_market": 12},
		"triggered_faction_event_ids": [],
		"completed_faction_request_ids": [],
		"purchased_market_item_ids": [],
		"consumable_inventory": {"consumable_first_aid": 2},
		"consumable_loadout": {},
		"active_consumable_effects": {},
		"rewarded_resolution_grades": {},
		"campaign_state": {},
		"investigation_risk": 0,
		"case_understanding": 0,
		"victim_understanding": 0,
		"anomaly_stability": 100,
		"stability_schema_version": 2,
		"mental_stamina": 100,
		"prediction_success_streak": 0,
		"prediction_failure_streak": 0,
		"current_recovery_pattern_id": "",
		"last_recovery_pattern_id": "",
		"confirmed_recovery_pattern_id": "",
		"seen_recovery_pattern_ids": [],
		"recovery_pattern_learning": {},
		"last_random_event_id": "",
		"last_random_event_result": {},
		"forced_recovery_phase": false,
		"collected_clue_ids": [],
		"selected_resolution_grade": "",
		"selected_resolution_label": "",
		"selected_resolution_rate": 0,
		"capture_success": false,
		"capture_result_state": "",
		"capture_result_stability": 100,
		"agent_case_states": {},
		"victim_state": {}
	}


func _validation_payload(lifecycle: String) -> Dictionary:
	return {
		"format": "urban-legend-validation-save",
		"version": "validation-save-v1",
		"payload_schema": 1,
		"revision": 3,
		"session": {
			"token": "integration-token",
			"lifecycle": lifecycle,
			"episode_id": EPISODE_ID,
			"flow_stage": "SIT-003",
			"checkpoint_id": "legacy:recovery",
			"return_target": "res://scenes/battle_scene.tscn",
			"focus_token": "legacy"
		},
		"snapshots": {
			"runtime": {
				"episode_id": EPISODE_ID,
				"episode_path": "res://data/episodes/episode_001_afterlife_station.json",
				"scene_path": "res://scenes/battle_scene.tscn",
				"dialogue_node_id": "dialogue_intro",
				"field_node_id": "dialogue_intro",
				"minigame_id": "minigame_frequency_sync",
				"selected_agent_ids": ["agent_kwon_narae"],
				"flags": [],
				"collected_clue_ids": ["clue_repeating_announcement"],
				"seen_hint_ids": [],
				"method_results": {},
				"minigame_results": {},
				"resolution": {"grade": "temporary", "label": "임시", "rate": 0.3},
				"recovery": {
					"successful": false,
					"result_status": "",
					"stability": 80,
					"current_pattern_id": "pattern_station_false_terminal",
					"last_pattern_id": "",
					"confirmed_pattern_id": "",
					"seen_pattern_ids": [],
					"pattern_learning": {}
				},
				"agent_case_states": {},
				"victim_state": {}
			},
			"preparation": {},
			"reasoning": {"collected_clue_ids": ["clue_repeating_announcement"]},
			"route": {"correct_response_id": "cut_false_broadcast"},
			"recovery": {"pattern_id": "pattern_station_false_terminal"}
		},
		"result": {"axes": {}, "candidate_records": {}, "applied_effect_ids": {}},
		"timestamps": {"created_at_utc": "2026-08-01T00:00:00Z", "updated_at_utc": "", "completed_at_utc": ""},
		"integrity": {"content_episode_id": EPISODE_ID}
	}


func _write_json(path: String, payload: Dictionary) -> PackedByteArray:
	var file := FileAccess.open(path, FileAccess.WRITE)
	_expect(file != null, "failed to write integration fixture: %s" % path)
	if file != null:
		file.store_string(JSON.stringify(payload, "\t", false))
		file.flush()
		file.close()
	return _read_bytes(path)


func _read_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	return parsed as Dictionary if typeof(parsed) == TYPE_DICTIONARY else {}


func _read_bytes(path: String) -> PackedByteArray:
	return FileAccess.get_file_as_bytes(path) if FileAccess.file_exists(path) else PackedByteArray()


func _remove(path: String) -> void:
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	var stem := path.trim_suffix(".json") if path.ends_with(".json") else path
	for suffix in [".migration.tmp.json", ".migration.bak.json", ".migration.old.json", ".migration.journal.json", ".tmp.json", ".bak.json"]:
		var artifact := stem + suffix
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
		print("AFTERLIFE MIGRATION INTEGRATION: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
