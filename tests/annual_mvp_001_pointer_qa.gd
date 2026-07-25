extends SceneTree

const SCENE_PATH := "res://scenes/poc/annual_mvp_001/annual_mvp_001_scene.tscn"
const SaveData = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_save_data.gd")

var _failures: Array[String] = []
var _scene: Control


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(1280, 720)
	SaveData.delete_payload()
	var packed := load(SCENE_PATH) as PackedScene
	_expect(packed != null, "annual scene should load")
	if packed == null:
		_finish()
		return
	_scene = packed.instantiate() as Control
	root.add_child(_scene)
	for _frame in range(8):
		await process_frame

	# Week 1: 3 + 3 + 1 = 7 days. This also prepares the signal-buffer research.
	await _click_text("신호 현상 연구")
	await _click_text("신호 현상 연구")
	await _click_text("휴식")
	_expect_selected_count(3, "week 1 pointer selection")
	_expect_selected_days(7, "week 1 pointer day budget")
	await _click_text("주간 일정 확정")
	_expect_phase("WEEK_RESULT", "week 1 confirm")

	await _click_text("PoC 저장")
	_expect(FileAccess.file_exists(SaveData.SAVE_PATH), "pointer save should create the isolated save")
	await _click_text("확인")
	_expect_phase("WEEK_PLANNING", "advance to week 2")
	await _click_text("PoC 불러오기")
	_expect_phase("WEEK_RESULT", "pointer load should restore week 1 result")
	await _click_text("확인")
	_expect_phase("WEEK_PLANNING", "advance to week 2 after restore")

	# Week 2: 3 + 2 + 1 + 1 = 7 days and unlocks institutional support.
	await _click_text("현장 대응 훈련")
	await _click_text("오현 협업 훈련")
	await _click_text("휴식")
	await _click_text("휴식")
	_expect_selected_days(7, "week 2 pointer day budget")
	await _click_text("주간 일정 확정")
	_expect_phase("WEEK_RESULT", "week 2 confirm")
	await _click_text("확인")
	_expect_phase("DEPLOYMENT_DECISION", "week 2 deployment decision")
	await _click_text("1주 더 준비")
	_expect_phase("WEEK_PLANNING", "delay should enter week 3 planning")

	# Week 3: 2 + 3 + 1 + 1 = 7 days.
	await _click_text("기록 분석")
	await _click_text("현장 대응 훈련")
	await _click_text("휴식")
	await _click_text("휴식")
	_expect_selected_days(7, "week 3 pointer day budget")
	await _click_text("주간 일정 확정")
	_expect_phase("WEEK_RESULT", "week 3 confirm")
	await _click_text("확인")
	_expect_phase("DEPLOYMENT_DECISION", "week 3 deployment decision")
	await _click_text("지금 출동")
	_expect_phase("PREPARATION", "pointer deployment should enter preparation")

	await _click_text("신호 완충 연구 완료 시도")
	var snapshot: Dictionary = _scene.call("debug_snapshot")
	_expect((snapshot.get("unlocked_module_ids", []) as Array).has("annual001_module_signal_buffer"), "pointer research should unlock signal buffer")
	await _click_text("공용 보조 스킬: 긴급 엄호")
	await _click_text("모듈: 신호 완충")
	await _click_text("출동 구성 확정 후 사건 시작")
	_expect_phase("INCIDENT_ACTIVE", "pointer start should enter incident")
	var save_button := _scene.find_child("SaveButton", true, false) as Button
	_expect(save_button != null and save_button.disabled, "save button should be disabled during incident")

	var manual_list := _scene.find_child("ManualList", true, false)
	var manual_button := _first_enabled_button(manual_list)
	_expect(manual_button != null, "embedded manual button should be pointer-accessible")
	if manual_button != null:
		await _click_control(manual_button)
	var choice_grid := _scene.find_child("ChoiceGrid", true, false)
	var choice_button := _first_enabled_button(choice_grid)
	_expect(choice_button != null, "embedded choice button should be pointer-accessible after rerender")
	if choice_button != null:
		await _click_control(choice_button)
		var feedback := _scene.find_child("FeedbackLabel", true, false) as Label
		_expect(feedback != null and not feedback.text.is_empty(), "embedded pointer choice should produce feedback")

	SaveData.delete_payload()
	_finish()


func _click_text(text: String) -> void:
	var button := _find_button_by_text(_scene, text)
	_expect(button != null, "button should exist: %s" % text)
	if button != null:
		await _click_control(button)


func _click_control(control: BaseButton) -> void:
	if not is_instance_valid(control):
		_failures.append("pointer target was freed before click")
		return
	for _frame in range(2):
		await process_frame
	if not is_instance_valid(control):
		_failures.append("pointer target was freed during layout")
		return
	var center := control.get_global_rect().get_center()
	Input.warp_mouse(center)
	var motion := InputEventMouseMotion.new()
	motion.position = center
	motion.global_position = center
	Input.parse_input_event(motion)
	await process_frame
	var press := InputEventMouseButton.new()
	press.button_index = MOUSE_BUTTON_LEFT
	press.position = center
	press.global_position = center
	press.pressed = true
	Input.parse_input_event(press)
	await process_frame
	var release := InputEventMouseButton.new()
	release.button_index = MOUSE_BUTTON_LEFT
	release.position = center
	release.global_position = center
	release.pressed = false
	Input.parse_input_event(release)
	for _frame in range(3):
		await process_frame


func _find_button_by_text(node: Node, text: String) -> BaseButton:
	if node is BaseButton:
		var button := node as BaseButton
		var matches_activity_cost: bool = button.text.begins_with("%s · " % text)
		if (button.text == text or matches_activity_cost) and button.is_visible_in_tree() and not button.disabled:
			return button
	for child in node.get_children():
		var found := _find_button_by_text(child, text)
		if found != null:
			return found
	return null


func _first_enabled_button(node: Node) -> BaseButton:
	if node == null:
		return null
	if node is BaseButton:
		var button := node as BaseButton
		if button.is_visible_in_tree() and not button.disabled:
			return button
	for child in node.get_children():
		var found := _first_enabled_button(child)
		if found != null:
			return found
	return null


func _expect_selected_count(expected: int, context: String) -> void:
	var selected := _scene.get("_selected_activity_ids") as Array
	_expect(selected.size() == expected, "%s expected %d selections, got %d" % [context, expected, selected.size()])


func _expect_selected_days(expected: int, context: String) -> void:
	var actual := int(_scene.call("debug_selected_days"))
	_expect(actual == expected, "%s expected %d days, got %d" % [context, expected, actual])


func _expect_phase(expected: String, context: String) -> void:
	var snapshot: Dictionary = _scene.call("debug_snapshot")
	var actual := String(snapshot.get("phase", ""))
	_expect(actual == expected, "%s expected %s, got %s" % [context, expected, actual])


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _scene != null:
		_scene.queue_free()
	if _failures.is_empty():
		print("ANNUAL MVP 001 POINTER QA: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
