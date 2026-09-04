extends SceneTree

const BridgeScript := preload("res://scripts/ui/canon_v2_runtime_bridge.gd")
const OverlayScript := preload("res://scripts/ui/canon_v2_operation_overlay.gd")

class FakeGameState:
	extends Node
	var preview_channels: Array[String] = []
	var committed_preview_ids: Array[String] = []
	var sequence := 0

	func preview_canon_v2_recovery_action(action: Dictionary, _context: Dictionary = {}) -> Dictionary:
		sequence += 1
		var channel := String(action.get("action_id", ""))
		preview_channels.append(channel)
		if channel == "observe":
			return {
				"preview_id": "preview-%d" % sequence,
				"action_id": channel,
				"allowed": true,
				"base_cost": 0,
				"additional_cost": 0,
				"cost_adjustments": [],
				"risk_changes": [],
				"alternatives": [],
				"preview_text": "정보 확인 행동은 무료입니다."
			}
		return {
			"preview_id": "preview-%d" % sequence,
			"action_id": channel,
			"allowed": true,
			"base_cost": 1,
			"additional_cost": 0,
			"cost_adjustments": [],
			"risk_changes": [{
				"target": "victim_afterlife_station_001",
				"source_reason": "partial_separation",
				"consequence": "잔여 연결을 통해 피해가 전이될 수 있습니다."
			}],
			"alternatives": [{"action_id": "protect", "label": "보호 행동"}],
			"preview_text": "저작된 추가 수치 비용 없음 · 보호 위험을 확인하세요."
		}

	func commit_canon_v2_recovery_action(preview_id: String) -> Dictionary:
		committed_preview_ids.append(preview_id)
		return {"committed": true}


var _failures: Array[String] = []
var _continuation_count := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var bridge = BridgeScript.new()
	root.add_child(bridge)
	var overlay = OverlayScript.new()
	root.add_child(overlay)
	overlay.configure_for_test({
		"manual_state": {"pages": [], "active_rule_ids": []},
		"active_protection_obligations": [],
		"termination_preview": {},
		"follow_up_records": []
	}, "recovery")
	var fake_state := FakeGameState.new()
	root.add_child(fake_state)
	await process_frame

	_expect(bridge.classify_recovery_action_id("response_afterlife_present_official_ticket") == "seal", "official ticket response was not classified as seal")
	_expect(bridge.classify_recovery_action_id("response_afterlife_insert_official_identifier") == "seal", "official identifier response was not classified as seal")
	_expect(bridge.classify_recovery_action_id("response_afterlife_anchor_persistent_trace") == "observe", "trace-anchor response was not classified as observation")

	var handled: bool = bool(bridge.request_action_gate_for_test(
		"response_afterlife_present_official_ticket",
		Callable(self, "_continue_action"),
		overlay,
		fake_state
	))
	_expect(handled, "risk-bearing recovery response bypassed the action gate")
	_expect((fake_state.preview_channels as Array[String]) == ["seal"], "action gate previewed the wrong semantic channel")
	var confirmation_panel := overlay.get_node_or_null("ConfirmationLayer/ConfirmationPanel") as PanelContainer
	_expect(confirmation_panel != null and confirmation_panel.visible, "confirmation panel did not open")
	var detail_label := overlay.get_node_or_null("ConfirmationLayer/ConfirmationPanel/ConfirmationContent/ConfirmationDetailLabel") as Label
	_expect(detail_label != null and detail_label.text.contains("피해"), "confirmation panel omitted protection consequence")
	var confirm_button := overlay.get_node_or_null("ConfirmationLayer/ConfirmationPanel/ConfirmationContent/ConfirmationButtons/ConfirmButton") as Button
	_expect(confirm_button != null and confirm_button.focus_mode == Control.FOCUS_ALL, "confirmation button lacks accessible focus")
	if confirm_button != null:
		confirm_button.pressed.emit()
	await process_frame
	_expect(_continuation_count == 1, "confirmed action did not continue exactly once")
	_expect((fake_state.committed_preview_ids as Array[String]) == ["preview-1"], "confirmed preview was not committed")

	var observe_handled: bool = bool(bridge.request_action_gate_for_test(
		"response_afterlife_anchor_persistent_trace",
		Callable(self, "_continue_action"),
		overlay,
		fake_state
	))
	_expect(not observe_handled, "free observation response was unnecessarily gated")
	_expect(_continuation_count == 1, "ungated observation should be continued by the caller, not the bridge")

	bridge.queue_free()
	overlay.queue_free()
	fake_state.queue_free()
	await process_frame
	_finish()


func _continue_action() -> void:
	_continuation_count += 1


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("CANON V2 ACTION GATE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
