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
	_game_state.reset_run_state()
	_game_state.load_episode("res://data/episodes/episode_001_afterlife_station.json")
	_game_state.set_selected_agent_ids(["agent_kwon_narae", "agent_oh_hyun", "agent_kang_ijun"])
	if change_scene_to_file(_game_state.SCENE_BATTLE) != OK:
		_expect(false, "recovery scene failed to load")
		_finish()
		return
	for _frame in range(5):
		await process_frame
	var overlay := current_scene.get_node_or_null("CanonV2OperationOverlay") as Control
	_expect(overlay != null and overlay.visible, "actual recovery overlay must be visible")
	var clock_cluster := overlay.get_node_or_null("SafeArea/RootLayout/RuleStripPanel/RuleStrip/RecoveryClockCluster") if overlay != null else null
	var stability_clock := clock_cluster.get_node_or_null("StabilityClock") if clock_cluster != null else null
	var danger_clock := clock_cluster.get_node_or_null("DangerClock") if clock_cluster != null else null
	var stability_label := clock_cluster.get_node_or_null("StabilityClockLabel") as Label if clock_cluster != null else null
	var danger_label := clock_cluster.get_node_or_null("DangerClockLabel") as Label if clock_cluster != null else null
	_expect(clock_cluster != null, "recovery clocks must belong to the actual visible overlay")
	_expect(stability_clock != null, "recovery overlay renders an eight-segment stability clock")
	_expect(danger_clock != null, "recovery overlay renders a six-segment danger clock")
	_expect(stability_clock != null and stability_clock.has_method("set_clock"), "stability clock loads its live renderer")
	_expect(danger_clock != null and danger_clock.has_method("set_clock"), "danger clock loads its live renderer")
	_expect(stability_clock != null and int(stability_clock.get("total_segments")) == 8, "stability clock has eight immutable segments")
	_expect(danger_clock != null and int(danger_clock.get("total_segments")) == 6, "danger clock has six immutable segments")
	_expect(not current_scene.has_node("RecoveryHud"), "hidden legacy recovery HUD must not retain player-facing state")
	_expect(current_scene.get_node_or_null("ActionDock/Content/Footer/ManualQuickButton") != null, "manual must open from the lower-right action footer")
	_expect(current_scene.find_child("RepresentativeSwitchButton", true, false) == null, "direct command lead cannot be switched in recovery")
	_expect(current_scene.find_child("RecoverButton", true, false) == null, "recovery completion must not require a separate button")
	_expect(stability_label != null and stability_label.text.contains("/8"), "stability label exposes segmented progress")
	_expect(danger_label != null and danger_label.text.contains("/6"), "danger label exposes segmented pressure")
	_expect(int(_game_state.get_recovery_clock_state().get("danger", -1)) == 0, "opening the first telegraph does not advance danger")
	current_scene.call("_begin_recovery_turn")
	await process_frame
	overlay = current_scene.get_node_or_null("CanonV2OperationOverlay") as Control
	clock_cluster = overlay.get_node_or_null("SafeArea/RootLayout/RuleStripPanel/RuleStrip/RecoveryClockCluster") if overlay != null else null
	danger_label = clock_cluster.get_node_or_null("DangerClockLabel") as Label if clock_cluster != null else null
	_expect(int(_game_state.get_recovery_clock_state().get("danger", -1)) == 1, "the next telegraph advances danger once")
	_expect(danger_label != null and danger_label.text.contains("1/6"), "danger label refreshes after the new telegraph")
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
		print("RECOVERY DUAL CLOCK SCENE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
