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
	var mounted: Node = bridge.mount_overlay_for_test(host, {
		"manual_state": {"pages": [], "active_rule_ids": []},
		"active_protection_obligations": [],
		"termination_preview": {},
		"follow_up_records": []
	}, "recovery")
	_expect(mounted != null, "bridge did not mount the operation overlay")
	_expect(host.get_node_or_null("CanonV2OperationOverlay") != null, "mounted overlay is not attached to the scene host")
	var mounted_again: Node = bridge.mount_overlay_for_test(host, {}, "recovery")
	_expect(mounted_again == mounted, "bridge mounted a duplicate overlay")
	_expect(bridge.classify_scene_path("res://scenes/minigame_scene.tscn") == "rescue", "minigame scene was not classified as rescue")
	_expect(bridge.classify_scene_path("res://scenes/battle_scene.tscn") == "recovery", "battle scene was not classified as recovery")
	_expect(bridge.classify_scene_path("res://scenes/result_scene.tscn") == "result", "result scene was not classified as result")
	bridge.queue_free()
	host.queue_free()
	await process_frame
	_finish()


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
