extends SceneTree

const BridgeScript := preload("res://scripts/ui/canon_v2_runtime_bridge.gd")

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_expect(ProjectSettings.has_setting("autoload/CanonV2RuntimeBridge"), "CanonV2RuntimeBridge autoload is not registered")
	var bridge = BridgeScript.new()
	root.add_child(bridge)
	var host := Control.new()
	host.name = "BattleSceneTestHost"
	root.add_child(host)
	var legacy_action_dock := Control.new()
	legacy_action_dock.name = "ActionDock"
	host.add_child(legacy_action_dock)
	var mounted: Node = bridge.mount_overlay_for_test(host, {
		"manual_state": {"pages": [], "active_rule_ids": []},
		"active_protection_obligations": [],
		"termination_preview": {},
		"follow_up_records": []
	}, "recovery")
	_expect(mounted != null, "bridge did not mount the operation overlay")
	_expect(host.get_node_or_null("CanonV2OperationOverlay") != null, "mounted overlay is not attached to the scene host")
	_expect(host.get_node_or_null("RecoveryHud") == null, "recovery host must not retain a duplicate legacy HUD")
	_expect(legacy_action_dock.visible, "Canon V2 overlay must preserve the legacy recovery action dock input")
	_expect(mounted.get_node_or_null("SafeArea/RootLayout/RuleStripPanel/RuleStrip/RecoveryClockCluster") != null, "bridge-mounted overlay must own the recovery clocks")
	var detail_toggle := mounted.get_node_or_null("SafeArea/RootLayout/RuleStripPanel/RuleStrip/DetailToggleButton") as Button
	_expect(detail_toggle != null, "bridge-mounted overlay lacks the recovery detail toggle")
	if detail_toggle != null:
		detail_toggle.emit_signal("pressed")
		await process_frame
		_expect(not legacy_action_dock.visible, "opened recovery detail must replace the action dock instead of overlapping it")
		detail_toggle.emit_signal("pressed")
		await process_frame
		_expect(legacy_action_dock.visible, "closing recovery detail must restore the action dock input")
	var mounted_again: Node = bridge.mount_overlay_for_test(host, {}, "recovery")
	_expect(mounted_again == mounted, "bridge mounted a duplicate overlay")
	var investigation_host := _make_investigation_host()
	root.add_child(investigation_host)
	var legacy_top_hud := investigation_host.get_node("SafeFrame/MainColumn/TopHud") as Control
	var legacy_log_bar := investigation_host.get_node("SafeFrame/MainColumn/LogBar") as Control
	var investigation_overlay := bridge.mount_overlay_for_test(investigation_host, {
		"manual_state": {"pages": [], "active_rule_ids": []},
		"active_protection_obligations": [],
		"termination_preview": {},
		"follow_up_records": []
	}, "investigation")
	_expect(investigation_overlay != null, "bridge did not mount the investigation overlay")
	_expect(legacy_top_hud.visible, "investigation must preserve the legacy top HUD navigation")
	_expect(not legacy_log_bar.visible, "Canon V2 investigation strip must replace the duplicate legacy log bar")
	var safe_area := investigation_overlay.get_node_or_null("SafeArea") as Control
	_expect(
		safe_area != null and safe_area.get_theme_constant("margin_top") == 72,
		"investigation rule strip must begin below the legacy top HUD"
	)
	_expect(bridge.classify_scene_path("res://scenes/minigame_scene.tscn") == "rescue", "minigame scene was not classified as rescue")
	_expect(bridge.classify_scene_path("res://scenes/battle_scene.tscn") == "recovery", "battle scene was not classified as recovery")
	_expect(bridge.classify_scene_path("res://scenes/result_scene.tscn") == "result", "result scene was not classified as result")
	bridge.queue_free()
	host.queue_free()
	investigation_host.queue_free()
	await process_frame
	_finish()


func _make_investigation_host() -> Control:
	var host := Control.new()
	host.name = "InvestigationSceneTestHost"
	var safe_frame := Control.new()
	safe_frame.name = "SafeFrame"
	host.add_child(safe_frame)
	var main_column := Control.new()
	main_column.name = "MainColumn"
	safe_frame.add_child(main_column)
	var top_hud := Control.new()
	top_hud.name = "TopHud"
	main_column.add_child(top_hud)
	var log_bar := Control.new()
	log_bar.name = "LogBar"
	main_column.add_child(log_bar)
	return host


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("CANON V2 RUNTIME BRIDGE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
