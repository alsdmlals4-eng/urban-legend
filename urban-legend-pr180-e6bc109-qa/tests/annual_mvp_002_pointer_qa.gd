extends SceneTree

const SCENE_PATH := "res://scenes/poc/annual_mvp_002/annual_mvp_002_scene.tscn"

var _failures: Array[String] = []
var _scene: Control


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(1280, 720)
	var packed := load(SCENE_PATH) as PackedScene
	_expect(packed != null, "ANNUAL-MVP-002 scene should load")
	if packed == null:
		_finish()
		return
	_scene = packed.instantiate() as Control
	root.add_child(_scene)
	for _frame in range(8):
		await process_frame

	await _click_text("현장 대응 훈련")
	await _click_text("관측 훈련")
	await _click_text("휴식")
	await _click_text("휴식")
	_expect((_scene.call("debug_plan_ids") as Array).size() == 4, "pointer should select four activities")
	await _click_text("마지막 변경 취소")
	_expect((_scene.call("debug_plan_ids") as Array).size() == 3, "undo pointer should remove the last activity")
	await _click_text("휴식")
	await _click_text("템플릿 1 저장")
	await _click_text("전체 초기화")
	_expect((_scene.call("debug_plan_ids") as Array).is_empty(), "clear pointer should empty plan")
	await _click_text("템플릿 1 적용")
	_expect((_scene.call("debug_plan_ids") as Array).size() == 4, "template pointer should restore plan")
	await _click_text("주간 일정 확정")
	_expect_phase("WEEK_RESULT", "week one pointer confirmation")
	await _click_text("주간 결과 확인")
	_expect_phase("WEEK_PLANNING", "week two pointer planning")

	await _click_text("템플릿 1 적용")
	await _click_text("주간 일정 확정")
	_expect_phase("WEEK_RESULT", "week two pointer confirmation")
	await _click_text("주간 결과 확인")
	_expect_phase("DEPLOYMENT_DECISION", "week two pointer deployment")
	await _click_text("지금 출동")
	_expect_phase("PREPARATION", "pointer deployment should enter preparation")

	await _click_named("CompanionCard_annual002_companion_ohyun")
	await _click_named("CompanionCard_annual002_companion_han_serin")
	_expect((_scene.call("debug_selected_companions") as Array).size() == 2, "pointer should select two companions")
	_expect((_scene.call("debug_set_equipment", "annual002_equipment_echo_recorder") as Dictionary).get("ok", false), "equipment should configure")
	_expect((_scene.call("debug_set_module", "annual002_module_noise_filter") as Dictionary).get("ok", false), "module should configure")
	var support_label := _scene.find_child("SupportStatusLabel", true, false) as Label
	_expect(support_label != null and support_label.text.contains("확률"), "support status should be pointer-visible")
	_expect(support_label != null and support_label.text.contains("준비도"), "readiness should be pointer-visible")
	await _click_text("출동 구성 확정 후 사건 시작")
	_expect_phase("INCIDENT_ACTIVE", "pointer start should enter incident")
	var choice_grid := _scene.find_child("ChoiceGrid", true, false)
	var choice := _first_enabled_button(choice_grid)
	_expect(choice != null, "embedded incident should expose a pointer choice")
	if choice != null:
		await _click_control(choice)

	_finish()


func _click_text(text: String) -> void:
	var button := _find_button_by_text(_scene, text)
	_expect(button != null, "button should exist: %s" % text)
	if button != null:
		await _click_control(button)


func _click_named(node_name: String) -> void:
	var button := _scene.find_child(node_name, true, false) as BaseButton
	_expect(button != null and button.is_visible_in_tree() and not button.disabled, "button should be clickable: %s" % node_name)
	if button != null:
		await _click_control(button)


func _click_control(control: BaseButton) -> void:
	if not is_instance_valid(control):
		_failures.append("pointer target was freed")
		return
	var ancestor: Node = control.get_parent()
	while ancestor != null:
		if ancestor is ScrollContainer:
			(ancestor as ScrollContainer).ensure_control_visible(control)
		ancestor = ancestor.get_parent()
	for _frame in range(4):
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
	for _frame in range(4):
		await process_frame


func _find_button_by_text(node: Node, text: String) -> BaseButton:
	if node is BaseButton:
		var button := node as BaseButton
		if (button.text == text or button.text.begins_with("%s · " % text)) and button.is_visible_in_tree() and not button.disabled:
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


func _expect_phase(expected: String, context: String) -> void:
	var actual := String((_scene.call("debug_snapshot") as Dictionary).get("phase", ""))
	_expect(actual == expected, "%s expected %s, got %s" % [context, expected, actual])


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if is_instance_valid(_scene):
		_scene.queue_free()
	if _failures.is_empty():
		print("ANNUAL MVP 002 POINTER QA: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
