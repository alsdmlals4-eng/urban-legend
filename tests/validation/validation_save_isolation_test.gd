extends SceneTree

const Support = preload("res://tests/validation/validation_test_support.gd")
const LEGACY_PATH := "user://urban_legend_save.json"
const VALIDATION_PATH := "user://urban_legend_validation_save.json"

var _failures: Array[String] = []


func _init() -> void:
	var session_path := String(ProjectSettings.get_setting("autoload/ValidationSession", ""))
	var game_state_path := String(ProjectSettings.get_setting("autoload/GameState", ""))
	_expect(session_path == "*res://scripts/core/validation_session.gd", "ValidationSession must be registered before GameState")
	_expect(game_state_path == "*res://scripts/core/validation_game_state.gd", "GameState autoload must use the isolated wrapper")

	# SceneTree --script tests do not instantiate project autoload nodes.
	# Mount the scripts with their production root names after checking project.godot.
	var session_script: Script = load("res://scripts/core/validation_session.gd")
	var game_state_script: Script = load("res://scripts/core/validation_game_state.gd")
	_expect(session_script != null, "ValidationSession script must load")
	_expect(game_state_script != null, "GameState wrapper script must load")
	if session_script == null or game_state_script == null:
		_finish()
		return

	var root := get_root()
	var session = session_script.new()
	session.name = "ValidationSession"
	root.add_child(session)
	var game_state = game_state_script.new()
	game_state.name = "GameState"
	root.add_child(game_state)

	_expect(root.get_node_or_null("ValidationSession") == session, "ValidationSession must mount at the production root name")
	_expect(root.get_node_or_null("GameState") == game_state, "GameState must mount at the production root name")

	Support.delete_path(LEGACY_PATH)
	Support.delete_path(VALIDATION_PATH)
	Support.write_text(LEGACY_PATH, "LEGACY-BYTES-MUST-NOT-CHANGE")
	var legacy_before := Support.read_bytes(LEGACY_PATH)
	var hidden_before: Dictionary = game_state.capture_validation_hidden_state_guard()

	var create_result: Dictionary = session.create_session(
		"episode_001_afterlife_station",
		"SIT-001",
		game_state.export_validation_runtime_snapshot()
	)
	_expect(bool(create_result.get("ok", false)), "runtime session must be creatable")
	var token := String(create_result.get("token", ""))
	var activate_result: Dictionary = session.activate_session(token)
	_expect(bool(activate_result.get("ok", false)), "runtime session must activate with its token")

	var save_ok := bool(game_state.save_game())
	_expect(save_ok, "active Validation save must route to the Validation repository")
	_expect(FileAccess.file_exists(VALIDATION_PATH), "active Validation save must create only the Validation file")
	_expect(Support.read_bytes(LEGACY_PATH) == legacy_before, "active Validation save must preserve Legacy bytes")
	_expect(game_state.validation_hidden_state_matches(hidden_before), "active Validation save must preserve hidden Legacy memory")

	session.invalidate_active_contract_for_test()
	var validation_before := Support.read_bytes(VALIDATION_PATH)
	var invalid_save_ok := bool(game_state.save_game())
	_expect(not invalid_save_ok, "invalid active Validation contract must fail closed")
	_expect(Support.read_bytes(LEGACY_PATH) == legacy_before, "fail-closed save must not touch Legacy bytes")
	_expect(Support.read_bytes(VALIDATION_PATH) == validation_before, "fail-closed save must not touch Validation bytes")

	session.deactivate_session()
	Support.delete_path(LEGACY_PATH)
	Support.delete_path(VALIDATION_PATH)
	game_state.queue_free()
	session.queue_free()
	_finish()


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
