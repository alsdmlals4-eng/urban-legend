extends SceneTree

const TRAVEL_PATH := "res://scripts/ui/case01_travel_session.gd"

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var exists := ResourceLoader.exists(TRAVEL_PATH)
	_expect(exists, "CASE-01 shared travel session must exist")
	if not exists:
		_finish()
		return

	var script_value: Variant = load(TRAVEL_PATH)
	_expect(script_value is Script, "CASE-01 shared travel session must load as Script")
	if script_value is Script:
		var session = (script_value as Script).new()
		_expect(session != null, "CASE-01 shared travel session must instantiate")
		if session != null:
			for method_name in [
				"configure",
				"get_current_location_id",
				"get_location_snapshot",
				"request_from_map",
				"request_from_field",
				"request_travel",
				"visible_point_ids"
			]:
				_expect(session.has_method(method_name), "shared travel session must expose %s" % method_name)
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("CASE01 SHARED TRAVEL: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
