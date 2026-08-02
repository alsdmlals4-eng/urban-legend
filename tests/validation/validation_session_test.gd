extends SceneTree

var _failures: Array[String] = []


func _init() -> void:
	var script: Script = load("res://scripts/core/validation_session.gd")
	_expect(script != null, "validation session script must exist before lifecycle tests can run")
	if script == null:
		_finish()
		return

	var session = script.new()
	_expect(session.has_method("create_session"), "session must expose create_session")
	_expect(session.has_method("activate_session"), "session must expose activate_session")
	_expect(session.has_method("is_validation_active"), "session must expose is_validation_active")
	_expect(session.has_method("mark_completion_applied"), "session must expose mark_completion_applied")
	_expect(session.has_method("build_payload"), "session must expose build_payload")
	_expect(session.has_method("deactivate_session"), "session must expose deactivate_session")
	if not session.has_method("create_session"):
		_finish()
		return

	var create_result: Dictionary = session.create_session(
		"episode_001_afterlife_station",
		"SIT-001",
		{"current_scene_path": "res://scenes/dialogue_scene.tscn"}
	)
	_expect(bool(create_result.get("ok", false)), "create_session must accept a valid episode and stage")
	var token := String(create_result.get("token", ""))
	_expect(not token.is_empty(), "create_session must return an activation token")

	if session.has_method("activate_session"):
		var activate_result: Dictionary = session.activate_session(token)
		_expect(bool(activate_result.get("ok", false)), "activate_session must accept the issued token")
	if session.has_method("is_validation_active"):
		_expect(bool(session.is_validation_active()), "session must report active after token activation")

	if session.has_method("mark_completion_applied"):
		var first: Dictionary = session.mark_completion_applied("validation-completion-001")
		var second: Dictionary = session.mark_completion_applied("validation-completion-001")
		_expect(bool(first.get("applied", false)), "first completion application must be accepted")
		_expect(not bool(second.get("applied", true)), "duplicate completion application must be rejected")

	if session.has_method("build_payload"):
		var payload: Dictionary = session.build_payload()
		_expect(String(payload.get("save_version", "")) == "validation-save-v1", "session payload must use validation-save-v1")
		var session_data: Dictionary = payload.get("session", {})
		_expect(String(session_data.get("episode_id", "")) == "episode_001_afterlife_station", "session payload must preserve episode id")
		_expect(String(session_data.get("stage", "")) == "SIT-001", "session payload must preserve stage")

	if session.has_method("deactivate_session"):
		session.deactivate_session()
	if session.has_method("is_validation_active"):
		_expect(not bool(session.is_validation_active()), "deactivate_session must clear active mode")
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
