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
	_expect(_game_state != null, "GameState autoload must be available for recovery runtime verification")
	if _game_state == null:
		_finish()
		return
	var guard_error := _guard.prepare(String(_game_state.call("get_save_file_path")))
	_expect(guard_error.is_empty(), "test save guard must prepare before recovery runtime mutation")
	if not guard_error.is_empty():
		_finish()
		return
	_prepared = true

	_game_state.call("reset_run_state")
	_expect(bool(_game_state.call("load_episode", "res://data/episodes/episode_001_afterlife_station.json")), "afterlife recovery fixture must load")
	_game_state.call("set_selected_agent_ids", ["agent_kwon_narae", "agent_oh_hyun", "agent_kang_ijun"])
	_expect(change_scene_to_file("res://scenes/battle_scene.tscn") == OK, "recovery scene must load")
	for _frame in range(6):
		await process_frame
	var bridge := root.get_node_or_null("CanonV2RuntimeBridge")
	_expect(bridge != null, "runtime bridge autoload must be available for recovery overlay")
	if bridge != null:
		bridge.call("_sync_current_scene")
	await process_frame

	var scene := current_scene
	var overlay := scene.get_node_or_null("CanonV2OperationOverlay") as Control if scene != null else null
	var cluster := overlay.get_node_or_null("SafeArea/RootLayout/RuleStripPanel/RuleStrip/RecoveryClockCluster") if overlay != null else null
	var stability_label := cluster.get_node_or_null("StabilityClockLabel") as Label if cluster != null else null
	var danger_label := cluster.get_node_or_null("DangerClockLabel") as Label if cluster != null else null
	_expect(overlay != null and overlay.visible, "actual recovery scene must mount the operation overlay")
	_expect(cluster != null, "actual recovery overlay must own both visible clocks")
	_expect(stability_label != null and stability_label.text.contains("안정도") and stability_label.text.contains("/8"), "actual recovery scene must expose the eight-segment stability clock")
	_expect(danger_label != null and danger_label.text == "위험도 0/6", "the first telegraph must begin with zero danger")

	if scene != null:
		scene.call("_begin_recovery_turn")
	if bridge != null:
		bridge.call("_sync_current_scene")
	await process_frame
	danger_label = cluster.get_node_or_null("DangerClockLabel") as Label if cluster != null else null
	_expect(int((_game_state.call("get_recovery_clock_state") as Dictionary).get("danger", -1)) == 1, "the second meaningful telegraph advances danger exactly once")
	_expect(danger_label != null and danger_label.text == "위험도 1/6", "visible danger clock must refresh after the next telegraph")
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _prepared:
		var restore_error := _guard.restore()
		_expect(restore_error.is_empty(), "test save guard must restore the player save after recovery runtime mutation")
		_prepared = false
	if _failures.is_empty():
		print("Recovery dual-clock scene test: 12 passed, 0 failed")
		quit(0)
		return
	for failure in _failures:
		push_error("FAIL: %s" % failure)
	print("Recovery dual-clock scene test: %d passed, %d failed" % [12 - _failures.size(), _failures.size()])
	quit(1)
