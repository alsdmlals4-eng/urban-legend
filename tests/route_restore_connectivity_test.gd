# 노선 복원 미니게임의 endpoint 연결성과 성공 판정 계약을 검증한다.
extends SceneTree

const RouteGame = preload("res://scripts/minigames/route_restore_game.gd")
const WEST := Vector2i(-1, 0)
const SOUTH := Vector2i(0, 1)

var _failures: Array[String] = []

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var route := RouteGame.new()
	root.add_child(route)
	route.configure({}, false)

	var tutorial_safe: Array[Vector2i] = route.call("_connections_for", Vector2i(2, 0))
	_expect(tutorial_safe == [SOUTH], "tutorial safe endpoint should enter from SOUTH")

	route.call("_build_final_board")
	var final_safe: Array[Vector2i] = route.call("_connections_for", Vector2i(3, 0))
	_expect(final_safe == [WEST], "final safe endpoint should enter from WEST")
	_expect(route.has_method("_has_reciprocal_connection"), "route should expose reciprocal endpoint connectivity")
	if route.has_method("_has_reciprocal_connection"):
		_expect(not bool(route.call("_has_reciprocal_connection", Vector2i(3, 0), WEST)), "disconnected final endpoint should not have a reciprocal rail")

	var disconnected: Dictionary = route.call("_get_reachability")
	_expect(not bool(disconnected.get("safe", false)), "initial final board should leave the safe endpoint disconnected")

	var tiles: Array[Dictionary] = route.get("_tiles")
	tiles[13]["state"] = 1
	tiles[9]["state"] = 1
	tiles[5]["orientation"] = 1
	tiles[6]["orientation"] = 3
	tiles[2]["orientation"] = 1
	tiles[3]["connections"] = [SOUTH]
	route.set("_tiles", tiles)
	if route.has_method("_has_reciprocal_connection"):
		_expect(bool(route.call("_has_reciprocal_connection", Vector2i(3, 0), WEST)), "reciprocally linked rail should be detected")
	route.set("_tutorial_complete", true)

	var old_tuple_reachability: Dictionary = route.call("_get_reachability")
	_expect(not bool(old_tuple_reachability.get("safe", false)), "old final orientation tuple should not reach a disconnected safe endpoint")
	_expect(route.call("_is_solution"), "fixture should reproduce the legacy hardcoded final solution tuple")

	var completions: Array[bool] = []
	route.completed.connect(func(successful: bool, _details: Dictionary) -> void:
		completions.append(successful)
	)
	route.call("_confirm_route")
	_expect(completions.is_empty(), "confirmation must not complete from the old tuple when safe is unreachable")

	route.queue_free()
	await process_frame
	if _failures.is_empty():
		print("route_restore_connectivity_test: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)

func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
