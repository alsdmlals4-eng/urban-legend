# 미니게임의 타이밍과 충돌 규칙을 headless로 검증한다.
extends SceneTree

const Rules = preload("res://scripts/minigames/minigame_rules.gd")

var _failures: Array[String] = []


func _init() -> void:
	_test_rhythm_window()
	_test_player_clamp()
	_test_drop_overlap()
	_test_rain_outcomes()
	if _failures.is_empty():
		print("MINIGAME RULES: 10 assertions passed")
		quit(0)
		return

	for failure in _failures:
		push_error(failure)
	quit(1)


func _test_rhythm_window() -> void:
	_expect(Rules.is_rhythm_hit(70.0, 64.0, 8.0), "radius inside tolerance should hit")
	_expect(Rules.is_rhythm_hit(56.0, 64.0, 8.0), "tolerance boundary should hit")
	_expect(not Rules.is_rhythm_hit(55.9, 64.0, 8.0), "radius outside tolerance should miss")


func _test_player_clamp() -> void:
	var bounds := Rect2(10.0, 20.0, 300.0, 200.0)
	var size := Vector2(40.0, 20.0)
	_expect_equal(Rules.clamp_player_position(Vector2(-10.0, 500.0), bounds, size), Vector2(10.0, 200.0), "player should remain inside playfield")
	_expect_equal(Rules.clamp_player_position(Vector2(120.0, 100.0), bounds, size), Vector2(120.0, 100.0), "valid player position should remain unchanged")


func _test_drop_overlap() -> void:
	_expect(Rules.rects_overlap(Rect2(10, 10, 20, 20), Rect2(25, 25, 10, 10)), "overlapping rectangles should collide")
	_expect(not Rules.rects_overlap(Rect2(10, 10, 20, 20), Rect2(31, 31, 10, 10)), "separated rectangles should not collide")


func _test_rain_outcomes() -> void:
	_expect(Rules.is_rain_success(12.0, 12.0, 2, 3), "surviving duration below hit limit should succeed")
	_expect(not Rules.is_rain_success(11.9, 12.0, 0, 3), "ending early should not succeed")
	_expect(Rules.is_rain_failure(3, 3), "reaching hit limit should fail")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s: expected %s, got %s" % [message, expected, actual])
