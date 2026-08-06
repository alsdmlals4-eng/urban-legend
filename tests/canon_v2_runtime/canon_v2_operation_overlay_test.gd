extends SceneTree

const OverlayScript := preload("res://scripts/ui/canon_v2_operation_overlay.gd")

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var overlay = OverlayScript.new()
	root.add_child(overlay)
	overlay.configure_for_test({
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
	}, "recovery")
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

	overlay.queue_free()
	await process_frame
	_finish()


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
