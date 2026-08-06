extends SceneTree

const Support = preload("res://tests/validation/validation_test_support.gd")
const SessionScript = preload("res://scripts/core/afterlife_migrating_validation_session.gd")
const GameStateScript = preload("res://scripts/core/afterlife_migrating_game_state.gd")
const LEGACY_PATH := "user://urban_legend_save.json"

var _failures: Array[String] = []
var _created_session := false
var _created_game_state := false


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var session_path := String(ProjectSettings.get_setting("autoload/ValidationSession", ""))
	var game_state_path := String(ProjectSettings.get_setting("autoload/GameState", ""))
	_expect(session_path == "*res://scripts/core/afterlife_migrating_validation_session.gd", "ValidationSession must use the Canon v2 migration wrapper")
	_expect(game_state_path == "*res://scripts/core/afterlife_migrating_game_state.gd", "GameState must use the Canon v2 migration wrapper")

	# Godot may instantiate project autoloads before a SceneTree --script test runs.
	# Reuse them when present; only mount production-equivalent wrappers when the runner did not create them.
	var root := get_root()
	var session = root.get_node_or_null("ValidationSession")
	if session == null:
		session = SessionScript.new()
		session.name = "ValidationSession"
		root.add_child(session)
		_created_session = true
	var game_state = root.get_node_or_null("GameState")
	if game_state == null:
		game_state = GameStateScript.new()
		game_state.name = "GameState"
		root.add_child(game_state)
		_created_game_state = true

	_expect(root.get_node_or_null("ValidationSession") == session, "test must use the production ValidationSession root node")
	_expect(root.get_node_or_null("GameState") == game_state, "test must use the production GameState root node")
	_expect(session.has_method("create"), "session must expose the approved create API")
	_expect(session.has_method("invalidate_token_for_test"), "session must expose fail-closed test invalidation")
	_expect(session.has_method("get_last_migration_result"), "session wrapper must expose migration evidence")
	_expect(game_state.has_method("snapshot_hidden_legacy_state_for_test"), "GameState must expose hidden-state evidence")
	_expect(game_state.has_method("get_afterlife_content_contract_id"), "GameState wrapper must expose Canon v2 contract evidence")
	if not session.has_method("create") or not game_state.has_method("snapshot_hidden_legacy_state_for_test"):
		_cleanup(game_state, session, {})
		_finish()
		return

	var paths: Dictionary = session.get_repository_paths()
	Support.remove_repository_paths(paths)
	Support.remove_path(LEGACY_PATH)
	session.deactivate()
	game_state.reset_run_state()
	_expect(game_state.save_game(), "inactive Legacy save should succeed")
	var legacy_before := Support.read_bytes(LEGACY_PATH)
	var hidden_before: Dictionary = game_state.snapshot_hidden_legacy_state_for_test()

	var created: Dictionary = session.create("episode_001_afterlife_station")
	var token := String(created.get("session_token", ""))
	_expect(String(created.get("code", "")) == "OK", "session should create")
	_expect(String(session.activate(token).get("code", "")) == "OK", "session should activate")
	_expect(String(session.capture_legacy_guard(game_state).get("code", "")) == "OK", "session should capture hidden guard")
	game_state.add_flag("validation:integration-save")
	_expect(game_state.save_game(), "active save should route to Validation")
	var validation_path := String(paths.get("primary", ""))
	_expect(FileAccess.file_exists(validation_path), "Validation primary should exist")
	_expect(Support.read_bytes(LEGACY_PATH) == legacy_before, "active Validation save must preserve Legacy bytes")
	_expect(Support.semantic_equal(game_state.snapshot_hidden_legacy_state_for_test(), hidden_before), "active Validation save must preserve hidden Legacy memory")

	var validation_before_invalid := Support.read_bytes(validation_path)
	session.invalidate_token_for_test()
	_expect(not game_state.save_game(), "invalid active session must fail closed")
	_expect(Support.read_bytes(LEGACY_PATH) == legacy_before, "invalid active session must not fall back to Legacy")
	_expect(Support.read_bytes(validation_path) == validation_before_invalid, "invalid active session must not change Validation bytes")

	session.deactivate()
	var validation_before_legacy_ops := Support.read_bytes(validation_path)
	_expect(game_state.load_game(), "Legacy load should still succeed while Validation is inactive")
	_expect(game_state.clear_save_file(), "Legacy clear should still succeed while Validation is inactive")
	_expect(Support.read_bytes(validation_path) == validation_before_legacy_ops, "Legacy load/clear must preserve Validation bytes")

	game_state.reset_run_state()
	_expect(game_state.save_game(), "Legacy save should recreate for reverse isolation test")
	var legacy_before_validation_delete := Support.read_bytes(LEGACY_PATH)
	_expect(String(session.delete_persistence().get("code", "")) == "OK", "Validation persistence delete should succeed")
	_expect(Support.read_bytes(LEGACY_PATH) == legacy_before_validation_delete, "Validation delete must preserve Legacy bytes")

	_cleanup(game_state, session, paths)
	_finish()


func _cleanup(game_state: Node, session: Node, paths: Dictionary) -> void:
	Support.remove_repository_paths(paths)
	Support.remove_path(LEGACY_PATH)
	if _created_game_state:
		game_state.queue_free()
	if _created_session:
		session.queue_free()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("VALIDATION SAVE ISOLATION: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
