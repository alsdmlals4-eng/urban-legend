extends SceneTree

const TRAVEL_PATH := "res://scripts/ui/case01_travel_session.gd"

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var travel_script: Variant = load(TRAVEL_PATH)
	_expect(travel_script is Script, "CASE-01 shared travel session must exist")
	if travel_script is Script:
		var travel = (travel_script as Script).new()
		var locations := [
			{
				"id": "location_afterlife_platform",
				"label": "승강장",
				"point_ids": ["point_victim_phone", "point_platform_speaker"]
			},
			{
				"id": "location_afterlife_ticket_gate",
				"label": "개찰구",
				"point_ids": ["point_black_ticket"]
			},
			{
				"id": "location_afterlife_staff_room",
				"label": "역무원실",
				"point_ids": ["point_staff_room_door", "point_staff_room_log"]
			}
		]
		travel.configure(locations, "location_afterlife_platform")
		_expect(travel.get_current_location_id() == "location_afterlife_platform", "travel session must retain configured current location")
		_expect(travel.visible_point_ids() == ["point_victim_phone", "point_platform_speaker"], "visible points must follow current presentation location")

		var from_map: Dictionary = travel.request_from_map("location_afterlife_staff_room")
		travel.configure(locations, "location_afterlife_platform")
		var from_field: Dictionary = travel.request_from_field("location_afterlife_staff_room")
		_expect(from_map == from_field, "map and field travel entrypoints must use identical semantics")
		_expect(bool(from_map.get("ok", false)), "known presentation location should be travelable")
		_expect(String(from_map.get("location_id", "")) == "location_afterlife_staff_room", "travel result must identify destination")
		_expect(from_map.get("visible_point_ids", []) == ["point_staff_room_door", "point_staff_room_log"], "travel must expose only the destination's existing point IDs")

		var before_unknown := travel.get_current_location_id()
		var unknown: Dictionary = travel.request_from_map("location_unknown")
		_expect(not bool(unknown.get("ok", false)), "unknown location must fail closed")
		_expect(String(unknown.get("reason", "")) == "unknown_location", "unknown location must report explicit reason")
		_expect(travel.get_current_location_id() == before_unknown, "blocked travel must not mutate current presentation location")
		travel.free()
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
