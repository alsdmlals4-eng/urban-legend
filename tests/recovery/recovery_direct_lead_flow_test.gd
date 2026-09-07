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
	_expect(_game_state != null, "GameState autoload must be available for direct-lead recovery verification")
	if _game_state == null:
		_finish()
		return
	var guard_error := _guard.prepare(String(_game_state.call("get_save_file_path")))
	_expect(guard_error.is_empty(), "test save guard must prepare before direct-lead recovery verification")
	if not guard_error.is_empty():
		_finish()
		return
	_prepared = true

	_game_state.call("reset_run_state")
	_expect(change_scene_to_file("res://scenes/battle_scene.tscn") == OK, "recovery scene must load")
	for _frame in range(6):
		await process_frame
	var bridge := root.get_node_or_null("CanonV2RuntimeBridge")
	if bridge != null:
		bridge.call("_sync_current_scene")
	await process_frame

	var scene := current_scene
	_expect(scene != null and scene.has_method("is_recovery_ready_for_resolution"), "recovery scene must expose a read-only automatic-resolution readiness query")
	_expect(scene != null and scene.has_method("request_manual_quick_open"), "recovery scene must expose lower-right manual access")
	_expect(scene != null and scene.find_child("RepresentativeSwitchButton", true, false) == null, "recovery must not retain representative switching")
	_expect(scene != null and scene.find_child("RecoverButton", true, false) == null, "recovery must not retain a separate execute button")
	var manual_button := scene.get_node_or_null("ActionDock/Content/Footer/ManualQuickButton") as Button if scene != null else null
	_expect(manual_button != null, "recovery action footer must contain the manual quick button")
	if manual_button != null:
		manual_button.emit_signal("pressed")
		await process_frame
		var overlay := scene.get_node_or_null("CanonV2OperationOverlay") as Control
		var manual_panel := overlay.get_node_or_null("ManualDetailPanel") as Control if overlay != null else null
		_expect(manual_panel != null and manual_panel.visible, "lower-right manual button must open the field-reference panel")

	var recovery_threshold := int(scene.get("_recovery_threshold")) if scene != null else 0
	if scene != null:
		scene.set("_anomaly_stability", recovery_threshold)
		scene.call("_update_battle_view", "automatic completion fixture")
		scene.call("_update_battle_view", "automatic completion fixture duplicate refresh")
		_expect(bool(scene.get("_recovery_completion_queued")), "reaching the stability threshold must queue one automatic result transition")
	for _frame in range(4):
		await process_frame
	_expect(current_scene != null and current_scene.scene_file_path == "res://scenes/result_scene.tscn", "recovery threshold must advance to the result scene without a separate execute action")

	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _prepared:
		var restore_error := _guard.restore()
		_expect(restore_error.is_empty(), "test save guard must restore the player save after direct-lead verification")
		_prepared = false
	if _failures.is_empty():
		print("Recovery direct-lead flow test: 12 passed, 0 failed")
		quit(0)
		return
	for failure in _failures:
		push_error("FAIL: %s" % failure)
	print("Recovery direct-lead flow test: %d passed, %d failed" % [12 - _failures.size(), _failures.size()])
	quit(1)
