# 두 액션 컨트롤이 성공/실패 신호와 플레이 요약을 생성하는지 검증한다.
extends SceneTree

const RhythmGame = preload("res://scripts/minigames/rhythm_timing_game.gd")
const RainGame = preload("res://scripts/minigames/rain_dodge_game.gd")

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	await _test_games_wait_for_start()
	await _test_rhythm_success()
	await _test_rhythm_failure()
	await _test_rain_arrow_action_moves_player()
	await _test_rain_long_frame_collision_is_detected()
	await _test_rain_duration_boundary_resolves_collision_first()
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


func _test_games_wait_for_start() -> void:
	var rhythm := RhythmGame.new()
	root.add_child(rhythm)
	rhythm.configure({"round_count": 5, "beat_duration": 1.0}, false)
	await process_frame
	rhythm.call("_process", 2.0)
	_expect(int(rhythm.get("_round_index")) == 0, "rhythm timer should wait for an explicit start key")
	rhythm.queue_free()

	var rain := RainGame.new()
	root.add_child(rain)
	rain.configure({"duration": 3.0}, false)
	await process_frame
	await process_frame
	rain.call("_process", 2.0)
	_expect(float(rain.get("_elapsed")) == 0.0, "rain timer should wait for an arrow-key start")
	Input.action_press("ui_right")
	rain.call("_process", 0.1)
	Input.action_release("ui_right")
	_expect(bool(rain.get("_started")), "an arrow-key action should start the rain timer")
	rain.queue_free()


func _test_rhythm_success() -> void:
	var game := RhythmGame.new()
	root.add_child(game)
	var captured: Array = []
	game.completed.connect(func(successful: bool, details: Dictionary) -> void: captured.assign([successful, details]))
	game.configure({"round_count": 5, "required_hits": 3, "target_radius": 64.0, "hit_tolerance": 10.0}, false)
	await process_frame
	_start_rhythm(game)
	_submit_rhythm(game, 64.0, KEY_ENTER)
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
	_start_rhythm(game)
	for round_index in range(5):
		_submit_rhythm(game, 110.0)
	_expect(captured.size() == 2 and not bool(captured[0]), "five rhythm misses should fail")
	if captured.size() == 2:
		_expect(int(captured[1].get("miss_count", 0)) == 5, "rhythm details should store five misses")
	game.queue_free()


func _start_rhythm(game: Control) -> void:
	var event := InputEventKey.new()
	event.keycode = KEY_SPACE
	event.pressed = true
	game.call("_unhandled_key_input", event)


func _submit_rhythm(game: Control, radius: float, keycode: Key = KEY_SPACE) -> void:
	game.set("_current_radius", radius)
	game.set("_cooldown", 0.0)
	var event := InputEventKey.new()
	event.keycode = keycode
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
	game.set("_started", true)
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


func _test_rain_long_frame_collision_is_detected() -> void:
	var game := RainGame.new()
	root.add_child(game)
	game.configure({"duration": 3.0, "max_hits": 3, "spawn_interval": 2.0}, false)
	await process_frame
	await process_frame
	game.set("_started", true)
	var player_position := Vector2(game.get("_player_position"))
	var drops: Array = game.get("_drops")
	drops.append({
		"position": Vector2(player_position.x + 35.0, player_position.y - 5.0),
		"speed": 1000.0,
		"length": 28.0
	})
	game.call("_process", 0.2)
	_expect(int(game.get("_hits")) == 1, "substeps should detect a rain drop crossing the player during a long frame")
	game.queue_free()


func _test_rain_duration_boundary_resolves_collision_first() -> void:
	var game := RainGame.new()
	root.add_child(game)
	var captured: Array = []
	game.completed.connect(func(successful: bool, details: Dictionary) -> void: captured.assign([successful, details]))
	game.configure({"duration": 3.0, "max_hits": 3}, false)
	await process_frame
	await process_frame
	game.set("_started", true)
	game.set("_elapsed", 2.9)
	game.set("_hits", 2)
	var player_position := Vector2(game.get("_player_position"))
	var drops: Array = game.get("_drops")
	drops.append({
		"position": Vector2(player_position.x + 35.0, player_position.y - 5.0),
		"speed": 240.0,
		"length": 28.0
	})
	game.call("_process", 0.1)
	_expect(captured.size() == 2 and not bool(captured[0]), "a third collision before the duration boundary should fail the run")
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
	game.set("_started", true)
	game.set("_hits", 3)
	game.call("_process", 0.0)
	_expect(captured.size() == 2 and not bool(captured[0]), "three rain hits should fail")
	if captured.size() == 2:
		_expect(int(captured[1].get("hit_count", 0)) == 3, "rain details should store hit count")
	game.queue_free()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
