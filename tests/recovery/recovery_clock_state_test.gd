extends SceneTree

const TestSaveGuard := preload("res://tests/test_save_guard.gd")

var _guard := TestSaveGuard.new()
var _prepared := false
var _game_state: Node
var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_game_state = root.get_node_or_null("GameState")
	_expect(_game_state != null, "GameState autoload must be available to the recovery-clock contract")
	if _game_state == null:
		_finish()
		return
	var guard_error := _guard.prepare(String(_game_state.call("get_save_file_path")))
	_expect(guard_error.is_empty(), "test save guard must prepare before recovery-clock mutation")
	if not guard_error.is_empty():
		_finish()
		return
	_prepared = true

	_expect(_game_state.has_method("get_recovery_clock_state"), "GameState must expose recovery clock state")
	_expect(_game_state.has_method("begin_recovery_clock_turn"), "GameState must advance recovery clock turns")
	_expect(_game_state.has_method("resolve_recovery_clock_outcome"), "GameState must resolve recovery clock outcomes")
	_expect(_game_state.has_method("change_recovery_clock_danger"), "GameState must expose support danger adjustments")
	_expect(_game_state.has_method("reset_recovery_clock_state"), "GameState must reset recovery clock state")
	if _failures.is_empty():
		_game_state.call("reset_run_state")
		var initial: Dictionary = _game_state.call("get_recovery_clock_state")
		_expect(int(initial.get("danger", -1)) == 0, "new recovery starts at danger zero")
		var legacy_default: Dictionary = _game_state.call("_normalize_recovery_clock_state", {})
		_expect(int(legacy_default.get("danger", -1)) == 0 and int(legacy_default.get("turn_count", -1)) == 0 and int(legacy_default.get("surge_count", -1)) == 0, "pre-clock saves receive a safe zero-default clock")

		_game_state.call("begin_recovery_clock_turn")
		_expect(int((_game_state.call("get_recovery_clock_state") as Dictionary).get("danger", -1)) == 0, "first telegraph is free")
		_game_state.call("begin_recovery_clock_turn")
		_expect(int((_game_state.call("get_recovery_clock_state") as Dictionary).get("danger", -1)) == 1, "second telegraph advances danger")
		var verified: Dictionary = _game_state.call("resolve_recovery_clock_outcome", true, true)
		_expect(int(verified.get("danger", -1)) == 0, "verified manual-and-method response relieves danger")

		_game_state.call("change_recovery_clock_danger", 6)
		var surge: Dictionary = _game_state.call("resolve_recovery_clock_outcome", false, false)
		_expect(bool(surge.get("surge_triggered", false)), "danger six plus a wrong response triggers one bounded surge")
		_expect(int(surge.get("danger", -1)) == 3, "surge returns danger to three segments")

		_expect(bool(_game_state.call("save_game")), "recovery clock state must save through the normal contract")
		_game_state.call("reset_run_state")
		_expect(bool(_game_state.call("load_game")), "recovery clock state must load through the normal contract")
		var restored: Dictionary = _game_state.call("get_recovery_clock_state")
		_expect(int(restored.get("danger", -1)) == 3, "saved danger segments must survive a load")
		_expect(restored.has("turn_count"), "legacy-safe clock schema must retain its turn counter")

	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _prepared:
		var restore_error := _guard.restore()
		_expect(restore_error.is_empty(), "test save guard must restore the player save after recovery-clock mutation")
		_prepared = false
	if _failures.is_empty():
		print("Recovery clock state test: 17 passed, 0 failed")
		quit(0)
		return
	for failure in _failures:
		push_error("FAIL: %s" % failure)
	print("Recovery clock state test: %d passed, %d failed" % [17 - _failures.size(), _failures.size()])
	quit(1)
