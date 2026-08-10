extends SceneTree

const OverlayScript := preload("res://scripts/ui/canon_v2_operation_overlay.gd")

var _failures: Array[String] = []
var _underlying_pressed_count := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var overlay = OverlayScript.new()
	root.add_child(overlay)
	var runtime_state := {
		"manual_state": {
			"pages": [
				{"id": "manual_afterlife_page_02_boundary_reset", "title": "안내 종료 전 이동은 공간만 되감는다"},
				{"id": "manual_afterlife_page_03_official_return", "title": "귀환은 공식 운행 절차를 복원한다"}
			],
			"active_rule_ids": ["manual_afterlife_page_02_boundary_reset"]
		},
		"active_protection_obligations": [
			{
				"obligation_id": "ob_treatment",
				"priority_class": "critical",
				"priority_reason": "피해자 상태가 위중합니다.",
				"responsibility_type": "treatment",
				"status": "unresolved"
			}
		],
		"termination_preview": {
			"termination_candidate": "approved_withdrawal",
			"eligible": false,
			"blocking_reasons": ["중대 보호 의무가 인계되지 않았습니다."],
			"non_blocking_consequences": []
		},
		"follow_up_records": [
			{
				"follow_up_id": "follow_up_ob_treatment",
				"source_status": "unresolved",
				"resolution_state": "open",
				"actionable_reason": "의료 인계가 필요합니다."
			}
		]
	}
	overlay.configure_for_test(runtime_state, "recovery")
	await process_frame

	_expect(overlay.name == "CanonV2OperationOverlay", "overlay root name mismatch")
	_expect(overlay.get_node_or_null("SafeArea/RootLayout/RuleStripPanel") != null, "rule strip panel missing")
	_expect(overlay.get_node_or_null("SafeArea/RootLayout/DetailStack/ObligationPanel") != null, "protection obligation panel missing")
	_expect(overlay.get_node_or_null("SafeArea/RootLayout/DetailStack/TerminationPreviewPanel") != null, "termination preview panel missing")
	_expect(overlay.get_node_or_null("SafeArea/RootLayout/DetailStack/FollowUpPanel") != null, "follow-up panel missing")
	var manual_button := overlay.get_node_or_null("SafeArea/RootLayout/RuleStripPanel/RuleStrip/ManualToggleButton") as Button
	_expect(manual_button != null, "manual toggle button missing")
	if manual_button != null:
		_expect(manual_button.focus_mode == Control.FOCUS_ALL, "manual toggle lacks keyboard/gamepad focus")
		_expect(not manual_button.text.is_empty(), "manual toggle lacks text label")
	var summary_label := overlay.get_node_or_null("SafeArea/RootLayout/RuleStripPanel/RuleStrip/RuleSummaryLabel") as Label
	_expect(summary_label != null and not summary_label.text.is_empty(), "rule strip lacks text summary")
	var priority_label := overlay.get_node_or_null("SafeArea/RootLayout/DetailStack/ObligationPanel/ObligationContent/PriorityLabel") as Label
	_expect(priority_label != null and priority_label.text.contains("critical"), "priority is not expressed as text")

	overlay.configure_for_test(runtime_state, "investigation")
	await process_frame
	await _verify_investigation_pointer_passthrough()
	var safe_area := overlay.get_node_or_null("SafeArea") as Control
	var root_layout := overlay.get_node_or_null("SafeArea/RootLayout") as Control
	var rule_strip := overlay.get_node_or_null("SafeArea/RootLayout/RuleStripPanel") as Control
	var obligation_panel := overlay.get_node_or_null("SafeArea/RootLayout/DetailStack/ObligationPanel") as Control
	var termination_panel := overlay.get_node_or_null("SafeArea/RootLayout/DetailStack/TerminationPreviewPanel") as Control
	var follow_up_panel := overlay.get_node_or_null("SafeArea/RootLayout/DetailStack/FollowUpPanel") as Control
	var confirmation_layer := overlay.get_node_or_null("ConfirmationLayer") as Control
	_expect(rule_strip != null and rule_strip.visible, "investigation must retain compact rule continuity")
	_expect(obligation_panel != null and not obligation_panel.visible, "investigation must hide obligation detail")
	_expect(termination_panel != null and not termination_panel.visible, "investigation must hide termination detail")
	_expect(follow_up_panel != null and not follow_up_panel.visible, "investigation must hide follow-up detail")
	_expect(overlay.mouse_filter == Control.MOUSE_FILTER_IGNORE, "full-screen overlay root must not consume investigation pointer input")
	_expect(safe_area != null and safe_area.mouse_filter == Control.MOUSE_FILTER_IGNORE, "full-screen safe area must not consume investigation pointer input")
	_expect(root_layout != null and root_layout.mouse_filter == Control.MOUSE_FILTER_IGNORE, "full-screen root layout must not consume investigation pointer input")
	_expect(confirmation_layer != null and confirmation_layer.mouse_filter == Control.MOUSE_FILTER_IGNORE, "inactive confirmation layer must not consume pointer input")
	overlay.request_action_confirmation({}, Callable())
	_expect(confirmation_layer != null and confirmation_layer.visible and confirmation_layer.mouse_filter == Control.MOUSE_FILTER_STOP, "active confirmation layer must be the full-screen pointer blocker")
	overlay.close_action_confirmation()
	_expect(confirmation_layer != null and not confirmation_layer.visible and confirmation_layer.mouse_filter == Control.MOUSE_FILTER_IGNORE, "closed confirmation layer must restore pointer passthrough")

	overlay.configure_for_test(runtime_state, "result")
	await process_frame
	await _verify_result_detail_pointer_passthrough(overlay)

	overlay.queue_free()
	await process_frame
	_finish()


func _verify_investigation_pointer_passthrough() -> void:
	var action_button := Button.new()
	action_button.name = "UnderlyingInvestigationAction"
	action_button.text = "조사 진행"
	action_button.position = Vector2(520, 360)
	action_button.size = Vector2(240, 72)
	_underlying_pressed_count = 0
	action_button.pressed.connect(func() -> void: _underlying_pressed_count += 1)
	root.add_child(action_button)
	root.move_child(action_button, 0)
	await process_frame

	var click_position := action_button.get_global_rect().get_center()
	var press := InputEventMouseButton.new()
	press.position = click_position
	press.button_index = MOUSE_BUTTON_LEFT
	press.pressed = true
	root.get_viewport().push_input(press, true)
	var release := InputEventMouseButton.new()
	release.position = click_position
	release.button_index = MOUSE_BUTTON_LEFT
	release.pressed = false
	root.get_viewport().push_input(release, true)
	await process_frame

	_expect(_underlying_pressed_count == 1, "investigation overlay must allow actual mouse press/release to reach the underlying action")
	action_button.queue_free()


func _verify_result_detail_pointer_passthrough(overlay: Control) -> void:
	var obligation_panel := overlay.get_node_or_null("SafeArea/RootLayout/DetailStack/ObligationPanel") as Control
	_expect(obligation_panel != null and obligation_panel.visible, "result pointer test requires a visible obligation panel")
	if obligation_panel == null or not obligation_panel.visible:
		return

	var panel_rect := obligation_panel.get_global_rect()
	_expect(panel_rect.size.x > 0.0 and panel_rect.size.y > 0.0, "result pointer test requires a laid-out obligation panel")
	if panel_rect.size.x <= 0.0 or panel_rect.size.y <= 0.0:
		return

	var action_button := Button.new()
	action_button.name = "UnderlyingPostClearReturnAction"
	action_button.text = "현장 기록으로 복귀"
	action_button.position = panel_rect.position
	action_button.size = panel_rect.size
	_underlying_pressed_count = 0
	action_button.pressed.connect(func() -> void: _underlying_pressed_count += 1)
	root.add_child(action_button)
	root.move_child(action_button, 0)
	await process_frame

	var click_position := panel_rect.get_center()
	var press := InputEventMouseButton.new()
	press.position = click_position
	press.button_index = MOUSE_BUTTON_LEFT
	press.pressed = true
	root.get_viewport().push_input(press, true)
	var release := InputEventMouseButton.new()
	release.position = click_position
	release.button_index = MOUSE_BUTTON_LEFT
	release.pressed = false
	root.get_viewport().push_input(release, true)
	await process_frame

	_expect(_underlying_pressed_count == 1, "read-only result detail must allow actual mouse press/release to reach the underlying post-clear return action")
	action_button.queue_free()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("CANON V2 OPERATION OVERLAY: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
