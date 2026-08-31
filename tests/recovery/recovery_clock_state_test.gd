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
	_expect(_game_state != null, "GameState autoload missing")
	if _game_state == null:
		_finish()
		return
	var guard_error := _guard.prepare(_game_state.get_save_file_path())
	_expect(guard_error.is_empty(), guard_error)
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
		_game_state.reset_run_state()
		var initial: Dictionary = _game_state.call("get_recovery_clock_state")
		_expect(int(initial.get("danger", -1)) == 0, "new runs start danger at 0")
		var legacy_clock: Dictionary = _game_state.call("_normalize_recovery_clock_state", {})
		_expect(int(legacy_clock.get("danger", -1)) == 0 and int(legacy_clock.get("turn_count", -1)) == 0 and int(legacy_clock.get("surge_count", -1)) == 0, "save payloads from before recovery clocks default all clock fields safely")
		var clamped_clock: Dictionary = _game_state.call("_normalize_recovery_clock_state", {"danger": 99, "turn_count": -3, "surge_count": -1})
		_expect(int(clamped_clock.get("danger", -1)) == 6 and int(clamped_clock.get("turn_count", -1)) == 0 and int(clamped_clock.get("surge_count", -1)) == 0, "loaded recovery clock state remains bounded")
		_game_state.call("begin_recovery_clock_turn")
		_expect(int((_game_state.call("get_recovery_clock_state") as Dictionary).get("danger", -1)) == 0, "first telegraph does not advance danger")
		_game_state.call("begin_recovery_clock_turn")
		_expect(int((_game_state.call("get_recovery_clock_state") as Dictionary).get("danger", -1)) == 1, "second telegraph advances danger")
		var verified: Dictionary = _game_state.call("resolve_recovery_clock_outcome", true, true)
		_expect(int(verified.get("danger", -1)) == 0, "fully verified response relieves danger without going below zero")
		_game_state.call("begin_recovery_clock_turn")
		var field_correct: Dictionary = _game_state.call("resolve_recovery_clock_outcome", true, false)
		_expect(int(field_correct.get("danger", -1)) == 0, "correct field response relieves one danger segment even while evidence is incomplete")
		_game_state.call("begin_recovery_clock_turn")
		_game_state.call("begin_recovery_clock_turn")
		var fully_verified: Dictionary = _game_state.call("resolve_recovery_clock_outcome", true, true)
		_expect(int(fully_verified.get("danger", -1)) == 0, "full manual verification relieves an additional danger segment")
		_game_state.call("reset_recovery_clock_state")
		_game_state.call("begin_recovery_clock_turn")
		_game_state.call("resolve_recovery_clock_outcome", false, false)
		var support_relief: Dictionary = _game_state.call("change_recovery_clock_danger", -1)
		_expect(int(support_relief.get("danger", -1)) == 1, "support adjustment can relieve one danger segment")
		_game_state.call("begin_recovery_clock_turn")
		_game_state.call("resolve_recovery_clock_outcome", false, false)
		_expect(_game_state.save_game(), "clock state must save")
		_game_state.reset_run_state()
		_expect(_game_state.load_game(), "clock save fixture must load")
		var reloaded: Dictionary = _game_state.call("get_recovery_clock_state")
		_expect(int(reloaded.get("danger", -1)) == 4, "saved danger survives reload")
		_expect(int(reloaded.get("turn_count", -1)) == 2, "saved recovery turn count survives reload")
		_game_state.call("reset_recovery_clock_state")
		_game_state.call("begin_recovery_clock_turn")
		_game_state.call("resolve_recovery_clock_outcome", false, false)
		_game_state.call("begin_recovery_clock_turn")
		_game_state.call("resolve_recovery_clock_outcome", false, false)
		_game_state.call("begin_recovery_clock_turn")
		var surge: Dictionary = _game_state.call("resolve_recovery_clock_outcome", false, false)
		_expect(bool(surge.get("surge_triggered", false)), "unresolved max danger triggers one surge")
		_expect(int(surge.get("surge_damage", 0)) == 8, "surge damage is fixed at 8")
		_expect(int(surge.get("danger", -1)) == 3, "surge resets danger to 3 instead of ending recovery")
		_game_state.call("reset_recovery_clock_state")
		_game_state.call("begin_recovery_clock_turn")
		_game_state.call("resolve_recovery_clock_outcome", false, false)
		_game_state.call("begin_recovery_clock_turn")
		_game_state.call("resolve_recovery_clock_outcome", false, false)
		_game_state.call("begin_recovery_clock_turn")
		var averted: Dictionary = _game_state.call("resolve_recovery_clock_outcome", true, false)
		_expect(not bool(averted.get("surge_triggered", false)), "correct field success at max danger averts the surge")
		_expect(int(averted.get("danger", -1)) == 5, "correct field success lowers max danger by one")
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _prepared:
		var restore_error := _guard.restore()
		if not restore_error.is_empty():
			_failures.append(restore_error)
		_prepared = false
	if _failures.is_empty():
		print("RECOVERY CLOCK STATE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
