class_name ValidationRouteMapper
extends RefCounted

const AVAILABLE := {
	"SIT-001": {"route_id": "dialogue", "scene_path": "res://scenes/dialogue_scene.tscn"},
	"SIT-002": {"route_id": "dialogue", "scene_path": "res://scenes/dialogue_scene.tscn"},
	"SIT-004": {"route_id": "investigation", "scene_path": "res://scenes/investigation_scene.tscn"}
}
const KNOWN_UNAVAILABLE := ["SIT-003", "SIT-005", "SIT-006", "SIT-007", "SIT-008"]


func resolve(flow_stage: String, lifecycle: String) -> Dictionary:
	if lifecycle not in ["active", "suspended"]:
		return _result(false, "INVALID_LIFECYCLE")
	if AVAILABLE.has(flow_stage):
		var route := AVAILABLE[flow_stage] as Dictionary
		return _result(true, "OK", {
			"route_id": String(route.get("route_id", "")),
			"scene_path": String(route.get("scene_path", ""))
		})
	if KNOWN_UNAVAILABLE.has(flow_stage):
		return _result(false, "NOT_AVAILABLE", {"route_id": flow_stage, "scene_path": ""})
	return _result(false, "UNKNOWN_FLOW_STAGE", {"route_id": "", "scene_path": ""})


func _result(ok: bool, code: String, details: Dictionary = {}) -> Dictionary:
	var value := {"ok": ok, "code": code, "route_id": "", "scene_path": ""}
	for key in details.keys():
		value[key] = details[key]
	return value
