extends SceneTree

const SessionScript = preload("res://scripts/core/validation_session.gd")
const Support = preload("res://tests/validation/validation_test_support.gd")
const TEST_PRIMARY := "user://validation_package_1_session_test.json"
const LEGACY_PATH := "user://urban_legend_save.json"

var _failures: Array[String] = []


class FakeGameState:
	extends RefCounted
	var runtime := {
		"episode_id": "episode_001_afterlife_station",
		"episode_path": "res://data/episodes/episode_001_afterlife_station.json",
		"scene_path": "res://scenes/dialogue_scene.tscn",
		"dialogue_node_id": "dialogue_intro",
		"field_node_id": "dialogue_intro",
		"minigame_id": "minigame_frequency_sync",
		"selected_agent_ids": ["agent_kwon_narae"],
		"flags": [],
		"collected_clue_ids": [],
		"seen_hint_ids": [],
		"method_results": {},
		"minigame_results": {},
		"resolution": {},
		"recovery": {},
		"agent_case_states": {},
		"victim_state": {}
	}
	var hidden := {"echo_fragments": 30, "campaign_state": {"week": 1}}
	func export_validation_runtime_snapshot() -> Dictionary:
		return runtime.duplicate(true)
	func restore_validation_runtime_snapshot(snapshot: Dictionary) -> Dictionary:
		runtime = snapshot.duplicate(true)
		return {"ok": true, "code": "OK"}
	func snapshot_hidden_legacy_state_for_test() -> Dictionary:
		return hidden.duplicate(true)


func _init() -> void:
	Support.remove_path(LEGACY_PATH)
	Support.write_text(LEGACY_PATH, "LEGACY-SESSION-TEST")
	var legacy_before := Support.read_bytes(LEGACY_PATH)
	var game_state := FakeGameState.new()
	var session = SessionScript.new()

	_expect(session.has_method("configure_repository_path_for_test"), "session must support an isolated repository path")
	_expect(session.has_method("create"), "session must expose create")
	_expect(session.has_method("activate"), "session must expose activate")
	_expect(session.has_method("capture_legacy_guard"), "session must expose capture_legacy_guard")
	_expect(session.has_method("save"), "session must expose save")
	_expect(session.has_method("suspend"), "session must expose suspend")
	_expect(session.has_method("resume"), "session must expose resume")
	_expect(session.has_method("complete"), "session must expose complete")
	_expect(session.has_method("abandon_runtime"), "session must expose abandon_runtime")
	_expect(session.has_method("load"), "session must expose load")
	_expect(session.has_method("delete_persistence"), "session must expose delete_persistence")
	if not session.has_method("configure_repository_path_for_test"):
		Support.remove_path(LEGACY_PATH)
		_finish()
		return

	session.configure_repository_path_for_test(TEST_PRIMARY)
	var paths: Dictionary = session.get_repository_paths()
	Support.remove_repository_paths(paths)

	var created: Dictionary = session.create("episode_001_afterlife_station")
	var token := String(created.get("session_token", ""))
	_expect(String(created.get("code", "")) == "OK" and not token.is_empty(), "create should generate a token")
	_expect(String(session.activate("wrong-token").get("code", "")) == "SESSION_TOKEN_MISMATCH", "wrong token should fail")
	_expect(String(session.activate(token).get("code", "")) == "OK", "correct token should activate")
	_expect(bool(session.requires_save_routing()), "active session should require save routing")
	_expect(String(session.capture_legacy_guard(game_state).get("code", "")) == "OK", "guard should capture")
	_expect(String(session.save(game_state).get("code", "")) == "OK", "active session should save")

	var validation_before_drift := Support.read_bytes(String(paths.get("primary", "")))
	game_state.hidden["echo_fragments"] = 31
	_expect(String(session.save(game_state).get("code", "")) == "HIDDEN_STATE_GUARD_VIOLATION", "hidden drift must block save")
	_expect(Support.read_bytes(String(paths.get("primary", ""))) == validation_before_drift, "hidden drift must not write Validation bytes")
	_expect(Support.read_bytes(LEGACY_PATH) == legacy_before, "hidden drift must not write Legacy bytes")
	game_state.hidden["echo_fragments"] = 30

	_expect(String(session.suspend(game_state).get("code", "")) == "OK", "active session should suspend")
	_expect(not bool(session.requires_save_routing()), "suspended session should stop routing")
	_expect(String(session.resume(game_state).get("code", "")) == "OK", "suspended session should resume")
	var completion := {"effect_id": "validation:afterlife:completion:v1"}
	_expect(String(session.complete(completion, game_state).get("code", "")) == "OK", "completion should persist")
	var completed_revision := int(session.get_revision())
	_expect(String(session.complete(completion, game_state).get("code", "")) == "ALREADY_COMPLETED", "completion should be idempotent")
	_expect(int(session.get_revision()) == completed_revision, "duplicate completion must not increment revision")

	_expect(String(session.abandon_runtime().get("code", "")) == "OK", "abandon should clear runtime memory")
	_expect(FileAccess.file_exists(TEST_PRIMARY), "abandon should retain persistence")
	_expect(String(session.load(game_state).get("code", "")) == "OK", "completed save should load for inspection")
	_expect(String(session.delete_persistence().get("code", "")) == "OK", "inactive completed persistence should delete")
	_expect(not FileAccess.file_exists(TEST_PRIMARY), "delete should remove Validation primary")
	_expect(Support.read_bytes(LEGACY_PATH) == legacy_before, "Validation delete must preserve Legacy bytes")

	Support.remove_repository_paths(paths)
	Support.remove_path(LEGACY_PATH)
	session.free()
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("VALIDATION SESSION: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
