# 두 액션 컨트롤이 성공/실패 신호와 플레이 요약을 생성하는지 검증한다.
extends SceneTree

const RhythmGame = preload("res://scripts/minigames/rhythm_timing_game.gd")
const RainGame = preload("res://scripts/minigames/rain_dodge_game.gd")

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	await _test_rhythm_success()
	await _test_rhythm_failure()
	await _test_rain_arrow_action_moves_player()
	await _test_rain_equipment_shield()
	await _test_rain_success()
	await _test_rain_failure()
	if _failures.is_empty():
		print("MINIGAME CONTROLS: all assertions passed")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)


func _test_rhythm_success() -> void:
	var game := RhythmGame.new()
	root.add_child(game)
	var captured: Array = []
	game.completed.connect(func(successful: bool, details: Dictionary) -> void: captured.assign([successful, details]))
	game.configure({"round_count": 5, "required_hits": 3, "target_radius": 64.0, "hit_tolerance": 10.0}, false)
	await process_frame
	_submit_rhythm(game, 64.0)
	_submit_rhythm(game, 64.0)
	_submit_rhythm(game, 100.0)
	_submit_rhythm(game, 64.0)
	_submit_rhythm(game, 100.0)
	_expect(captured.size() == 2, "rhythm success should emit completion")
	if captured.size() == 2:
		_expect(bool(captured[0]), "three rhythm hits should succeed")
		_expect(int(captured[1].get("hit_count", 0)) == 3, "rhythm details should store three hits")
	game.queue_free()


func _test_rhythm_failure() -> void:
	var game := RhythmGame.new()
	root.add_child(game)
	var captured: Array = []
	game.completed.connect(func(successful: bool, details: Dictionary) -> void: captured.assign([successful, details]))
	game.configure({"round_count": 5, "required_hits": 3, "target_radius": 64.0, "hit_tolerance": 10.0}, false)
	await process_frame
	for round_index in range(5):
		_submit_rhythm(game, 110.0)
	_expect(captured.size() == 2 and not bool(captured[0]), "five rhythm misses should fail")
	if captured.size() == 2:
		_expect(int(captured[1].get("miss_count", 0)) == 5, "rhythm details should store five misses")
	game.queue_free()


func _submit_rhythm(game: Control, radius: float) -> void:
	game.set("_current_radius", radius)
	game.set("_cooldown", 0.0)
	var event := InputEventKey.new()
	event.keycode = KEY_SPACE
	event.pressed = true
	game.call("_unhandled_key_input", event)
	if not bool(game.get("_finished")):
		game.call("_begin_next_round")


func _test_rain_success() -> void:
	var game := RainGame.new()
	root.add_child(game)
	var captured: Array = []
	game.completed.connect(func(successful: bool, details: Dictionary) -> void: captured.assign([successful, details]))
	game.configure({"duration": 3.0, "max_hits": 3}, false)
	await process_frame
	await process_frame
	game.set("_elapsed", 3.0)
	game.call("_process", 0.0)
	_expect(captured.size() == 2 and bool(captured[0]), "rain survival duration should succeed")
	if captured.size() == 2:
		_expect(float(captured[1].get("elapsed_time", 0.0)) >= 3.0, "rain details should store elapsed time")
	game.queue_free()


func _test_rain_arrow_action_moves_player() -> void:
	var game := RainGame.new()
	root.add_child(game)
	game.configure({"duration": 3.0, "max_hits": 3, "move_speed": 300.0}, false)
	await process_frame
	await process_frame
	var before := Vector2(game.get("_player_position"))
	Input.action_press("ui_right")
	game.call("_move_player", 0.25)
	Input.action_release("ui_right")
	var after := Vector2(game.get("_player_position"))
	_expect(after.x > before.x, "ui_right should move the umbrella to the right")
	game.queue_free()


func _test_rain_equipment_shield() -> void:
	var game := RainGame.new()
	root.add_child(game)
	game.configure({"duration": 3.0, "max_hits": 3}, true)
	await process_frame
	await process_frame
	game.call("_handle_collision")
	_expect(int(game.get("_hits")) == 0, "equipment shield should prevent the first rain hit")
	_expect(int(game.get("_shield_used")) == 1, "equipment shield use should be recorded")
	game.queue_free()


func _test_rain_failure() -> void:
	var game := RainGame.new()
	root.add_child(game)
	var captured: Array = []
	game.completed.connect(func(successful: bool, details: Dictionary) -> void: captured.assign([successful, details]))
	game.configure({"duration": 3.0, "max_hits": 3}, false)
	await process_frame
	await process_frame
	game.set("_hits", 3)
	game.call("_process", 0.0)
	_expect(captured.size() == 2 and not bool(captured[0]), "three rain hits should fail")
	if captured.size() == 2:
		_expect(int(captured[1].get("hit_count", 0)) == 3, "rain details should store hit count")
	game.queue_free()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
