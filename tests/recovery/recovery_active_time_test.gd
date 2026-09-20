extends SceneTree

const Guard = preload("res://tests/test_save_guard.gd")
var failures: Array[String] = []

func _initialize() -> void:
	call_deferred("run")

func check(ok: bool, message: String) -> void:
	if not ok:
		failures.append(message)

func run() -> void:
	var state := root.get_node("GameState")
	var guard := Guard.new()
	check(guard.prepare(state.get_save_file_path()).is_empty(), "save guard prepares")
	check(state.has_method("advance_recovery_clock_time"), "recovery needs an active-time consumer")
	if state.has_method("advance_recovery_clock_time"):
		state.reset_run_state()
		state.call("advance_recovery_clock_time", 11.5)
		check(state.get_recovery_clock_state().danger == 0, "partial interval does not add danger")
		check(state.save_game() and state.load_game(), "fractional interval save reload")
		state.call("advance_recovery_clock_time", 0.5)
		check(state.get_recovery_clock_state().danger == 1, "saved remainder completes exactly one interval")
		state.call("begin_recovery_clock_turn", false)
		state.call("begin_recovery_clock_turn", false)
		check(state.get_recovery_clock_state().danger == 1, "active-time turn changes cannot double-charge pressure")
		state.call("advance_recovery_clock_time", 5.0)
		state.resolve_recovery_clock_outcome(true, false)
		check(state.get_recovery_clock_state().danger == 0 and state.get_recovery_clock_state().active_seconds == 5.0, "successful action relieves danger without resetting elapsed time")
		state.change_recovery_clock_danger(5)
		var surge: Dictionary = state.call("advance_recovery_clock_time", 7.0)
		check(surge.danger == 3 and surge.surge_damage == 8 and surge.surge_triggered, "elapsed escalation uses existing damage/fallback once")
		var before: Dictionary = state.get_recovery_clock_state()
		state.call("advance_recovery_clock_time", NAN)
		state.call("advance_recovery_clock_time", -1.0)
		check(state.get_recovery_clock_state() == before, "invalid elapsed time cannot alter saved clock")
		check(state.call("_normalize_recovery_clock_state", {}).active_seconds == 0.0, "older saves start fractional time at zero")
		check(state.call("_normalize_recovery_clock_state", {"active_seconds": NAN}).active_seconds == 0.0, "non-finite saved remainder is repaired")
		state.reset_recovery_clock_state()
		var combined: Dictionary = state.call("advance_recovery_clock_time", 108.5)
		check(combined.danger == 3 and combined.surge_damage == 16 and combined.active_seconds == 0.5, "multiple active intervals apply two bounded surges and preserve fraction")
		var combined_state: Dictionary = state.get_recovery_clock_state()
		state.reset_recovery_clock_state()
		for interval in range(9):
			state.call("advance_recovery_clock_time", 12.0)
		state.call("advance_recovery_clock_time", 0.5)
		check(state.get_recovery_clock_state() == combined_state, "clock result is invariant to active delta partitioning")
	check(guard.restore().is_empty(), "save guard restores")
	for failure in failures:
		push_error(failure)
	print("Recovery active time: %d failures" % failures.size())
	quit(0 if failures.is_empty() else 1)
