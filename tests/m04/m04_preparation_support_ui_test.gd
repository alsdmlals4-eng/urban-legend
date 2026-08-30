# M04 현장 준비 상태가 실제 회수 버튼의 가용성과 차단 이유로 이어지는지 검증한다.
extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")
const M04_ID := "episode_002_red_umbrella_alley"
const M04_PATH := "res://data/episodes/episode_002_red_umbrella_alley.json"
const KWON_SUPPORT_TEXT := "귀가 기억 고정"
const OUTPUT_ENV := "M04_PREPARATION_SUPPORT_QA_OUTPUT"

var _guard := TestSaveGuard.new()
var _prepared := false
var _game_state: Node
var _failures: Array[String] = []
var _output_dir := ""


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_output_dir = OS.get_environment(OUTPUT_ENV)
	if not _output_dir.is_empty():
		DirAccess.make_dir_recursive_absolute(_output_dir)
	_game_state = root.get_node_or_null("GameState")
	if _game_state == null:
		_failures.append("GameState autoload is unavailable")
		_finish()
		return
	var guard_error := _guard.prepare(_game_state.get_save_file_path())
	if not guard_error.is_empty():
		_failures.append(guard_error)
		_finish()
		return
	_prepared = true
	await _validate_locked_button_without_completed_rest()
	await _validate_unlocked_button_after_completed_rest()
	_finish()


func _validate_locked_button_without_completed_rest() -> void:
	_prepare_m04(false)
	_expect(change_scene_to_file(_game_state.SCENE_BATTLE) == OK, "M04 recovery scene loads without completed preparation")
	for _frame in range(5):
		await process_frame
	await create_timer(0.35).timeout
	await _open_active_operation_detail()
	var button := _find_support_button()
	_expect(button != null and button.is_visible_in_tree(), "M04 recovery renders Kwon's existing support button in the active operation overlay")
	_expect(button != null and button.disabled, "M04 recovery disables Kwon support at preparation 0/1")
	_expect(button != null and button.tooltip_text.contains("현장 준비"), "locked M04 support explains the completed-rest requirement")
	await _capture_if_requested("m04-preparation-support-locked")


func _validate_unlocked_button_after_completed_rest() -> void:
	_prepare_m04(true)
	_expect(change_scene_to_file(_game_state.SCENE_BATTLE) == OK, "M04 recovery scene loads after completed preparation")
	for _frame in range(5):
		await process_frame
	await create_timer(0.35).timeout
	await _open_active_operation_detail()
	var button := _find_support_button()
	_expect(button != null and button.is_visible_in_tree(), "prepared M04 recovery renders Kwon's existing support button in the active operation overlay")
	_expect(button != null and not button.disabled, "M04 recovery enables Kwon support at preparation 1/1")
	_expect(button != null and not button.tooltip_text.contains("현장 준비가 없습니다"), "unlocked M04 support no longer presents a blocking reason")
	await _capture_if_requested("m04-preparation-support-unlocked")
	if button != null:
		button.emit_signal("pressed")
		await process_frame
		await create_timer(0.35).timeout
		var used_button := _find_support_button()
		_expect(used_button != null and used_button.disabled, "using the enabled M04 support immediately disables its refreshed active operation button")
		_expect(_game_state.has_used_agent_support("support_kwon_return_route"), "using the enabled M04 support preserves the existing one-use state")
		var status := _find_support_status()
		var viewport_rect := Rect2(Vector2.ZERO, root.get_visible_rect().size)
		_expect(status != null, "using the enabled M04 support retains a status label")
		if status != null:
			_expect(status.is_visible_in_tree(), "using the enabled M04 support keeps its status label visible in the scene tree")
			_expect(status.get_global_rect().size.y > 0.0, "using the enabled M04 support keeps a non-empty status label rect")
			_expect(status.get_global_rect().intersects(viewport_rect), "using the enabled M04 support keeps the status label on-screen; rect=%s viewport=%s" % [status.get_global_rect(), viewport_rect])
			_expect(status.text.contains("사용 완료"), "using the enabled M04 support refreshes the active operation status text")
	await _capture_if_requested("m04-preparation-support-used")


func _prepare_m04(with_completed_rest: bool) -> void:
	_game_state.reset_run_state()
	_expect(_game_state.load_episode(M04_PATH), "M04 episode data loads")
	_game_state.set_selected_agent_ids(["agent_kwon_narae"])
	if with_completed_rest:
		_expect(_game_state.set_campaign_schedule("agent_kwon_narae", "morning", "rest"), "the M04 preparation rest can be scheduled")
		_expect(_game_state.complete_campaign_slot({"kind": "schedule", "results": [{"agent_id": "agent_kwon_narae", "activity": "rest"}]}), "the M04 preparation rest can complete")
		_expect(bool(_game_state.acknowledge_campaign_slot_result().get("advanced", false)), "the completed preparation rest advances time")
	_expect(_game_state.set_campaign_planned_case(M04_ID), "M04 can be planned")
	_expect(_game_state.begin_campaign_operation(M04_ID), "M04 dispatch begins")


func _find_support_button() -> Button:
	var overlay := current_scene.get_node_or_null("CanonV2OperationOverlay") as Control
	if overlay == null:
		return null
	for node in overlay.find_children("*", "Button", true, false):
		var button := node as Button
		if button != null and button.text.contains(KWON_SUPPORT_TEXT):
			return button
	return null


func _find_support_status() -> Label:
	var overlay := current_scene.get_node_or_null("CanonV2OperationOverlay") as Control
	if overlay == null:
		return null
	for node in overlay.find_children("*", "Label", true, false):
		var label := node as Label
		if label != null and label.name.contains("RecoverySupportStatus"):
			return label
	return null


func _open_active_operation_detail() -> void:
	var toggle := current_scene.get_node_or_null("CanonV2OperationOverlay/SafeArea/RootLayout/RuleStripPanel/RuleStrip/DetailToggleButton") as Button
	_expect(toggle != null, "M04 recovery mounts the active operation-detail control")
	if toggle == null:
		return
	toggle.emit_signal("pressed")
	await process_frame


func _capture_if_requested(label: String) -> void:
	if _output_dir.is_empty():
		return
	root.size = Vector2i(1280, 720)
	for _frame in range(6):
		await process_frame
	RenderingServer.force_draw(false)
	await process_frame
	var image := root.get_texture().get_image()
	if image == null or image.is_empty():
		_failures.append("empty image for %s" % label)
		return
	var error := image.save_png(_output_dir.path_join("%s-1280x720.png" % label))
	_expect(error == OK, "failed to save active-operation support capture: %s" % error_string(error))


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
		print("M04 PREPARATION SUPPORT UI: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
