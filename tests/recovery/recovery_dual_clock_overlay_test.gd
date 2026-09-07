extends SceneTree

const OperationOverlay := preload("res://scripts/ui/canon_v2_operation_overlay.gd")

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var overlay := OperationOverlay.new()
	root.add_child(overlay)
	overlay.configure_for_test({
		"recovery_clock": {
			"stability_segments": 5,
			"stability_total": 8,
			"danger_segments": 3,
			"danger_total": 6,
			"danger_urgent": false
		}
	}, "recovery")
	await process_frame

	var cluster := overlay.get_node_or_null("SafeArea/RootLayout/RuleStripPanel/RuleStrip/RecoveryClockCluster")
	var stability_clock := cluster.get_node_or_null("StabilityClock") if cluster != null else null
	var danger_clock := cluster.get_node_or_null("DangerClock") if cluster != null else null
	var stability_label := cluster.get_node_or_null("StabilityClockLabel") as Label if cluster != null else null
	var danger_label := cluster.get_node_or_null("DangerClockLabel") as Label if cluster != null else null
	_expect(cluster != null, "visible recovery overlay must own a recovery clock cluster")
	_expect(stability_clock != null and stability_clock.has_method("set_clock"), "stability clock must use a dedicated segmented renderer")
	_expect(danger_clock != null and danger_clock.has_method("set_clock"), "danger clock must use a dedicated segmented renderer")
	_expect(stability_clock != null and int(stability_clock.get("total_segments")) == 8, "stability clock must render eight segments")
	_expect(danger_clock != null and int(danger_clock.get("total_segments")) == 6, "danger clock must render six segments")
	_expect(stability_label != null and stability_label.text == "안정도 5/8", "stability clock must expose its numerical progress")
	_expect(danger_label != null and danger_label.text == "위험도 3/6", "danger clock must expose its numerical pressure")

	overlay.configure_for_test({
		"recovery_clock": {
			"stability_segments": 5,
			"stability_total": 8,
			"danger_segments": 6,
			"danger_total": 6,
			"danger_urgent": true
		}
	}, "recovery")
	_expect(danger_label != null and danger_label.text == "위험도 6/6", "clock refresh must render danger without issuing a recommendation")

	overlay.queue_free()
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("Recovery dual-clock overlay test: 8 passed, 0 failed")
		quit(0)
		return
	for failure in _failures:
		push_error("FAIL: %s" % failure)
	print("Recovery dual-clock overlay test: %d passed, %d failed" % [8 - _failures.size(), _failures.size()])
	quit(1)
