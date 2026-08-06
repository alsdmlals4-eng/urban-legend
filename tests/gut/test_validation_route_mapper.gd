extends GutTest

var mapper: ValidationRouteMapper


func before_each() -> void:
    mapper = ValidationRouteMapper.new()


func test_sit_001_active_routes_to_dialogue() -> void:
    var result := mapper.resolve("SIT-001", "active")
    assert_true(result["ok"])
    assert_eq(result["code"], "OK")
    assert_eq(result["route_id"], "dialogue")
    assert_eq(result["scene_path"], "res://scenes/dialogue_scene.tscn")


func test_sit_004_suspended_routes_to_investigation() -> void:
    var result := mapper.resolve("SIT-004", "suspended")
    assert_true(result["ok"])
    assert_eq(result["code"], "OK")
    assert_eq(result["route_id"], "investigation")
    assert_eq(result["scene_path"], "res://scenes/investigation_scene.tscn")


func test_known_unavailable_stage_is_explicit() -> void:
    var result := mapper.resolve("SIT-003", "active")
    assert_false(result["ok"])
    assert_eq(result["code"], "NOT_AVAILABLE")
    assert_eq(result["route_id"], "SIT-003")
    assert_eq(result["scene_path"], "")


func test_unknown_stage_is_not_treated_as_unavailable() -> void:
    var result := mapper.resolve("SIT-999", "active")
    assert_false(result["ok"])
    assert_eq(result["code"], "UNKNOWN_FLOW_STAGE")
    assert_eq(result["route_id"], "")


func test_invalid_lifecycle_is_rejected_before_routing() -> void:
    var result := mapper.resolve("SIT-001", "completed")
    assert_false(result["ok"])
    assert_eq(result["code"], "INVALID_LIFECYCLE")
