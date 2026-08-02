extends SceneTree

const SummaryScript = preload("res://scripts/core/validation_persistence_summary.gd")
const SessionScript = preload("res://scripts/core/validation_session_facade.gd")
const Support = preload("res://tests/validation/validation_test_support.gd")
const TEST_PRIMARY := "user://validation_package_2_summary_test.json"

var _failures: Array[String] = []


func _init() -> void:
	_test_action_mapping()
	_test_session_facade_is_read_only()
	_finish()


func _test_action_mapping() -> void:
	var active: Dictionary = SummaryScript.build({
		"ok": true,
		"code": "EXACT",
		"payload": _payload("active", "SIT-004")
	})
	_expect(active.get("can_continue") == true, "active EXACT must continue")
	_expect(active.get("requires_replace_confirmation") == true, "active EXACT must require replace confirmation")
	_expect(active.get("flow_stage") == "SIT-004", "summary must expose flow-stage data")

	var suspended: Dictionary = SummaryScript.build({
		"ok": true,
		"code": "EXACT",
		"payload": _payload("suspended", "SIT-002")
	})
	_expect(suspended.get("can_continue") == true, "suspended EXACT must continue")

	var completed: Dictionary = SummaryScript.build({
		"ok": true,
		"code": "EXACT",
		"payload": _payload("completed", "SIT-008")
	})
	_expect(completed.get("can_view_completed") == true, "completed EXACT must expose read-only record action")
	_expect(completed.get("can_continue") == false, "completed EXACT must not continue")

	for blocked_code in [
		"RECOVERABLE_BACKUP", "INTERRUPTED_WRITE",
		"INCOMPATIBLE_OLDER", "INCOMPATIBLE_NEWER",
		"CORRUPT_JSON", "CORRUPT_SCHEMA", "READ_FAILED", "UNEXPECTED"
	]:
		var blocked: Dictionary = SummaryScript.build({"ok": false, "code": blocked_code})
		_expect(not blocked.get("can_start", true), "%s must not start" % blocked_code)
		_expect(not blocked.get("can_continue", true), "%s must not continue" % blocked_code)
		_expect(not blocked.get("requires_replace_confirmation", true), "%s must not replace" % blocked_code)

	var empty: Dictionary = SummaryScript.build({"ok": false, "code": "EMPTY"})
	_expect(empty.get("can_start") == true, "EMPTY must start")
	_expect(empty.get("repository_code") == "EMPTY", "EMPTY code must be preserved")


func _test_session_facade_is_read_only() -> void:
	var session = SessionScript.new()
	_expect(session.has_method("inspect_persistence"), "session must expose inspect_persistence")
	if not session.has_method("inspect_persistence"):
		session.free()
		return
	session.configure_repository_path_for_test(TEST_PRIMARY)
	var paths: Dictionary = session.get_repository_paths()
	Support.remove_repository_paths(paths)
	var revision_before := session.get_revision()
	var routing_before := session.requires_save_routing()
	var first: Dictionary = session.inspect_persistence()
	var second: Dictionary = session.inspect_persistence()
	_expect(first.get("repository_code") == "EMPTY", "empty repository must inspect as EMPTY")
	_expect(second == first, "repeated inspection must be stable")
	_expect(session.get_revision() == revision_before, "inspection must not change revision")
	_expect(session.requires_save_routing() == routing_before, "inspection must not change mode")
	_expect(not FileAccess.file_exists(TEST_PRIMARY), "inspection must not create persistence")
	Support.remove_repository_paths(paths)
	session.free()


func _payload(lifecycle: String, flow_stage: String) -> Dictionary:
	return {
		"session": {
			"lifecycle": lifecycle,
			"episode_id": "episode_001_afterlife_station",
			"flow_stage": flow_stage,
			"checkpoint_id": "checkpoint-1"
		},
		"timestamps": {
			"updated_at_utc": "2026-08-02T07:00:00Z",
			"completed_at_utc": "2026-08-02T07:10:00Z"
		},
		"result": {"axes": {"rule": 1}}
	}


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("VALIDATION PERSISTENCE SUMMARY: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
