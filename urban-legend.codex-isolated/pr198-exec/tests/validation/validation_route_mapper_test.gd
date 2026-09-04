extends SceneTree

const MapperScript = preload("res://scripts/core/validation_route_mapper.gd")
var _failures: Array[String] = []


func _init() -> void:
	var sit1: Dictionary = MapperScript.new().resolve("SIT-001", "active")
	_expect(sit1.get("code") == "OK", "SIT-001 must route")
	_expect(sit1.get("scene_path") == "res://scenes/dialogue_scene.tscn", "SIT-001 must use dialogue")

	var sit2: Dictionary = MapperScript.new().resolve("SIT-002", "suspended")
	_expect(sit2.get("code") == "OK", "SIT-002 must route")
	_expect(sit2.get("scene_path") == "res://scenes/dialogue_scene.tscn", "SIT-002 must use dialogue")

	var sit4: Dictionary = MapperScript.new().resolve("SIT-004", "active")
	_expect(sit4.get("scene_path") == "res://scenes/investigation_scene.tscn", "SIT-004 must use investigation")

	for unavailable in ["SIT-003", "SIT-005", "SIT-006", "SIT-007", "SIT-008"]:
		_expect(MapperScript.new().resolve(unavailable, "active").get("code") == "NOT_AVAILABLE", "%s must stay closed" % unavailable)

	_expect(MapperScript.new().resolve("SIT-999", "active").get("code") == "UNKNOWN_FLOW_STAGE", "unknown stage must fail closed")
	_expect(MapperScript.new().resolve("SIT-001", "completed").get("code") == "INVALID_LIFECYCLE", "completed must use read-only viewer")
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("VALIDATION ROUTE MAPPER: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
