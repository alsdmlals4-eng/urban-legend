extends SceneTree

const CoordinatorScript = preload("res://scripts/ui/validation_entry_coordinator.gd")
const MapperScript = preload("res://scripts/core/validation_route_mapper.gd")
var _failures: Array[String] = []


class FakeInspector:
	extends RefCounted
	var summaries: Array[Dictionary] = []
	var index := 0
	func inspect_persistence() -> Dictionary:
		if summaries.is_empty():
			return {"repository_code": "EMPTY", "can_start": true}
		var value: Dictionary = summaries[min(index, summaries.size() - 1)].duplicate(true)
		index += 1
		return value


class FakeSession:
	extends RefCounted
	var calls: Array[String] = []
	var fail_code := ""
	var persistence_exists := false
	func create(_episode_id: String) -> Dictionary:
		calls.append("create")
		if fail_code == "create": return {"ok": false, "code": "CREATE_FAILED"}
		persistence_exists = true
		return {"ok": true, "code": "OK", "session_token": "token"}
	func activate(_token: String) -> Dictionary:
		calls.append("activate")
		return {"ok": fail_code != "activate", "code": "ACTIVATE_FAILED" if fail_code == "activate" else "OK"}
	func capture_legacy_guard(_game_state: Object) -> Dictionary:
		calls.append("guard")
		return {"ok": true, "code": "OK"}
	func save(_game_state: Object) -> Dictionary:
		calls.append("save")
		return {"ok": fail_code != "save", "code": "SAVE_FAILED" if fail_code == "save" else "OK"}
	func load(game_state: Object) -> Dictionary:
		calls.append("load")
		game_state.runtime["scene_path"] = "restored"
		return {"ok": fail_code != "load", "code": "LOAD_FAILED" if fail_code == "load" else "OK"}
	func resume(_game_state: Object) -> Dictionary:
		calls.append("resume")
		return {"ok": true, "code": "OK"}
	func delete_persistence() -> Dictionary:
		calls.append("delete")
		persistence_exists = false
		return {"ok": true, "code": "OK"}
	func abandon_runtime() -> Dictionary:
		calls.append("abandon")
		return {"ok": true, "code": "OK"}


class FakeGameState:
	extends RefCounted
	var hidden := {"campaign": 7}
	var runtime := {"scene_path": "before", "episode_id": "episode_001_afterlife_station"}
	var initialize_calls := 0
	func snapshot_hidden_legacy_state_for_test() -> Dictionary:
		return hidden.duplicate(true)
	func export_validation_runtime_snapshot() -> Dictionary:
		return runtime.duplicate(true)
	func restore_validation_runtime_snapshot(value: Dictionary) -> Dictionary:
		runtime = value.duplicate(true)
		return {"ok": true, "code": "OK"}
	func initialize_validation_runtime(_episode_id: String, _agent_ids: Array) -> Dictionary:
		initialize_calls += 1
		runtime["scene_path"] = "initialized"
		return {"ok": true, "code": "OK"}


class FakeSceneChanger:
	extends RefCounted
	var calls: Array[String] = []
	var next_error := OK
	func change(scene_path: String) -> int:
		calls.append(scene_path)
		return next_error


func _init() -> void:
	_test_empty_start_and_busy()
	_test_replace_and_blocked()
	_test_failure_cleanup()
	_test_continue_completed_and_route_rollback()
	_finish()


func _coordinator(inspector: FakeInspector, session: FakeSession, game_state: FakeGameState, changer: FakeSceneChanger) -> Object:
	return CoordinatorScript.new(session, inspector, game_state, Callable(changer, "change"), MapperScript.new(), "")


func _test_empty_start_and_busy() -> void:
	var inspector := FakeInspector.new()
	inspector.summaries = [{"repository_code": "EMPTY", "can_start": true}]
	var session := FakeSession.new()
	var game_state := FakeGameState.new()
	var changer := FakeSceneChanger.new()
	var coordinator = _coordinator(inspector, session, game_state, changer)
	var result: Dictionary = coordinator.start_new_validation()
	_expect(result.get("code") == "OK", "EMPTY start must succeed")
	_expect(session.calls == ["create", "activate", "guard", "save"], "start call order must be exact")
	_expect(game_state.initialize_calls == 1, "initializer must run once")
	_expect(changer.calls == ["res://scenes/dialogue_scene.tscn"], "start must route once")

	coordinator.force_busy_for_test(true)
	_expect(coordinator.start_new_validation().get("code") == "BUSY", "busy command must fail closed")
	_expect(session.calls.size() == 4, "busy command must make no calls")


func _test_replace_and_blocked() -> void:
	var exact := {
		"repository_code": "EXACT", "episode_id": "episode_001_afterlife_station",
		"lifecycle": "active", "flow_stage": "SIT-001", "checkpoint_id": "c1",
		"updated_at_utc": "t1", "requires_replace_confirmation": true
	}
	var inspector := FakeInspector.new()
	inspector.summaries = [exact, exact, {"repository_code": "EMPTY", "can_start": true}]
	var session := FakeSession.new()
	var game_state := FakeGameState.new()
	var changer := FakeSceneChanger.new()
	var coordinator = _coordinator(inspector, session, game_state, changer)
	_expect(coordinator.start_new_validation().get("code") == "REPLACE_CONFIRMATION_REQUIRED", "EXACT must ask before replacement")
	_expect(session.calls.is_empty(), "replacement prompt must not mutate")
	_expect(coordinator.confirm_replace_and_start().get("code") == "OK", "confirmed replacement must start")
	_expect(session.calls[0] == "delete", "replacement must delete Validation first")

	var blocked_inspector := FakeInspector.new()
	blocked_inspector.summaries = [{"repository_code": "CORRUPT_JSON", "can_start": false, "requires_replace_confirmation": false}]
	var blocked_session := FakeSession.new()
	var blocked = _coordinator(blocked_inspector, blocked_session, FakeGameState.new(), FakeSceneChanger.new())
	_expect(blocked.start_new_validation().get("code") == "CORRUPT_JSON", "blocked storage code must surface")
	_expect(blocked_session.calls.is_empty(), "blocked storage must not mutate")


func _test_failure_cleanup() -> void:
	var inspector := FakeInspector.new()
	inspector.summaries = [{"repository_code": "EMPTY", "can_start": true}]
	var session := FakeSession.new()
	session.fail_code = "save"
	var game_state := FakeGameState.new()
	var before := game_state.runtime.duplicate(true)
	var changer := FakeSceneChanger.new()
	var coordinator = _coordinator(inspector, session, game_state, changer)
	var result: Dictionary = coordinator.start_new_validation()
	_expect(result.get("code") == "SAVE_FAILED", "save failure cause must surface")
	_expect(game_state.runtime == before, "failed start must restore runtime")
	_expect(session.calls.has("abandon"), "failed start must abandon runtime")
	_expect(session.calls.has("delete"), "failed newly-created start must delete Validation persistence")
	_expect(not coordinator.is_busy(), "failure must release lock")


func _test_continue_completed_and_route_rollback() -> void:
	var active := {
		"repository_code": "EXACT", "episode_id": "episode_001_afterlife_station",
		"lifecycle": "active", "flow_stage": "SIT-004", "can_continue": true
	}
	var inspector := FakeInspector.new()
	inspector.summaries = [active]
	var session := FakeSession.new()
	var state := FakeGameState.new()
	var changer := FakeSceneChanger.new()
	var coordinator = _coordinator(inspector, session, state, changer)
	_expect(coordinator.continue_validation().get("code") == "OK", "active record must continue")
	_expect(changer.calls == ["res://scenes/investigation_scene.tscn"], "continue must use allowlist route")

	var completed_inspector := FakeInspector.new()
	completed_inspector.summaries = [{"repository_code": "EXACT", "lifecycle": "completed", "can_view_completed": true, "episode_title": "저승역"}]
	var completed_session := FakeSession.new()
	var completed = _coordinator(completed_inspector, completed_session, FakeGameState.new(), FakeSceneChanger.new())
	_expect(completed.view_completed_validation().get("code") == "OK", "completed summary must open read-only")
	_expect(completed_session.calls.is_empty(), "completed summary must not load GameState")

	var unavailable := active.duplicate(true)
	unavailable["flow_stage"] = "SIT-005"
	var rollback_inspector := FakeInspector.new()
	rollback_inspector.summaries = [unavailable]
	var rollback_session := FakeSession.new()
	var rollback_state := FakeGameState.new()
	var before := rollback_state.runtime.duplicate(true)
	var rollback = _coordinator(rollback_inspector, rollback_session, rollback_state, FakeSceneChanger.new())
	_expect(rollback.continue_validation().get("code") == "NOT_AVAILABLE", "unavailable route must fail closed")
	_expect(rollback_state.runtime == before, "route failure must rollback runtime")
	_expect(rollback_session.calls.has("abandon"), "route failure must abandon loaded Session")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("VALIDATION ENTRY COORDINATOR: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
