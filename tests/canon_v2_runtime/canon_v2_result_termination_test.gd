extends SceneTree

const BridgeScript := preload("res://scripts/ui/canon_v2_runtime_bridge.gd")
const ResultAxesBridgeScript := preload("res://scripts/ui/canon_v2_result_axes_bridge.gd")
const OverlayScript := preload("res://scripts/ui/canon_v2_operation_overlay.gd")
const RuntimeGameStateScript := preload("res://scripts/core/afterlife_migrating_game_state.gd")

class FakeTerminationGameState:
	extends Node
	var requested_candidates: Array[String] = []

	func evaluate_canon_v2_recovery_termination(candidate: String, context: Dictionary = {}) -> Dictionary:
		requested_candidates.append(candidate)
		return {
			"termination_candidate": candidate,
			"eligible": true,
			"blocking_reasons": [],
			"non_blocking_consequences": context.get("obligations", []),
			"accountable_transfer": [],
			"retreat_selectable": true,
			"fallback_outcome": ""
		}

	func get_active_protection_obligations() -> Array:
		return [{
			"obligation_id": "ob_records_watch",
			"status": "unresolved",
			"priority_class": "watch"
		}]


class FakeRecoveryHost:
	extends Control

	func is_recovery_ready_for_resolution() -> bool:
		return true


var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_test_recovery_termination_preview()
	await _test_result_axes_overlay()
	_test_legacy_recovery_finalization()
	_finish()


func _test_recovery_termination_preview() -> void:
	var bridge = BridgeScript.new()
	var host := FakeRecoveryHost.new()
	host.name = "BattleSceneTerminationHost"
	var fake_state := FakeTerminationGameState.new()
	var preview: Dictionary = bridge.sync_recovery_termination_preview_for_test(host, fake_state)
	_expect((fake_state.requested_candidates as Array[String]) == ["residue_recovered"], "enabled core recovery did not preview residue_recovered")
	_expect(String(preview.get("termination_candidate", "")) == "residue_recovered", "termination preview candidate mismatch")
	_expect(bool(preview.get("eligible", false)), "eligible core recovery preview was blocked")
	bridge.free()
	host.free()
	fake_state.free()


func _test_result_axes_overlay() -> void:
	_expect(ProjectSettings.has_setting("autoload/CanonV2ResultAxesBridge"), "CanonV2ResultAxesBridge autoload is not registered")
	var overlay = OverlayScript.new()
	root.add_child(overlay)
	var evaluation_packet := {
		"control_axis": {"status": "residue_recovered"},
		"protection_responsibility_axis": {"incident_end": "breached", "current": "breached"},
		"evidence_integrity_axis": {"status": "preserved"},
		"follow_up_execution_axis": {"current": "mitigated"},
		"mastery_axis": {"ceiling_applied": false}
	}
	overlay.configure_for_test({
		"manual_state": {"pages": [], "active_rule_ids": []},
		"active_protection_obligations": [],
		"termination_preview": {},
		"follow_up_records": [],
		"evaluation_packet": evaluation_packet
	}, "result")
	var axes_bridge = ResultAxesBridgeScript.new()
	root.add_child(axes_bridge)
	var attached := axes_bridge.attach_result_axes_for_test(overlay, evaluation_packet)
	await process_frame
	var panel := overlay.get_node_or_null("SafeArea/RootLayout/DetailStack/ResultAxesPanel") as PanelContainer
	_expect(attached == panel, "result axes bridge returned a different panel")
	_expect(panel != null and panel.visible, "result axes panel is missing or hidden")
	var label := overlay.get_node_or_null("SafeArea/RootLayout/DetailStack/ResultAxesPanel/ResultAxesContent/ResultAxesLabel") as Label
	_expect(label != null and label.text.contains("현상 통제"), "result axes omitted control outcome")
	_expect(label != null and label.text.contains("보호 책임"), "result axes omitted protection responsibility")
	_expect(label != null and label.focus_mode == Control.FOCUS_ALL, "result axes lacks keyboard/gamepad focus")
	axes_bridge.queue_free()
	overlay.queue_free()
	await process_frame


func _test_legacy_recovery_finalization() -> void:
	var state = RuntimeGameStateScript.new()
	state.recovery_successful = true
	state.recovery_result_status = "core_recovered"
	state.recovery_result_stability = 82
	state.apply_canon_v2_runtime_state({
		"schema_version": 1,
		"rescue_outcome_snapshot": {},
		"recovery_handoff_state": {},
		"active_protection_obligations": [{
			"obligation_id": "ob_records_watch",
			"target": "station_records",
			"responsibility_type": "identity_record_preservation",
			"source_reason": "records_need_follow_up",
			"priority_class": "watch",
			"status": "unresolved",
			"created_order": 0
		}],
		"protection_history": [],
		"follow_up_records": [],
		"evaluation_packet": {},
		"reward_claims": {}
	})
	var bridge = BridgeScript.new()
	var finalized: Dictionary = bridge.finalize_legacy_recovery_for_test(state)
	_expect(bool(finalized.get("ok", false)), "legacy recovery result was not finalized into Canon v2 packet")
	var runtime: Dictionary = state.get_canon_v2_runtime_state()
	_expect(String(runtime.get("representative_outcome", "")) == "residue_recovered", "core_recovered did not map to residue_recovered")
	var packet := runtime.get("incident_end_packet", {}) as Dictionary
	_expect(String(packet.get("protection_status", "")) == "unresolved", "protection axis disappeared from incident-end packet")
	_expect(int(packet.get("legacy_recovery_stability", 0)) == 82, "legacy stability provenance missing")
	bridge.free()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("CANON V2 RESULT AND TERMINATION: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
