# 두 액션 컨트롤이 성공/실패 신호와 플레이 요약을 생성하는지 검증한다.
extends SceneTree

const RhythmGame = preload("res://scripts/minigames/rhythm_timing_game.gd")
const RainGame = preload("res://scripts/minigames/rain_dodge_game.gd")
const RouteGame = preload("res://scripts/minigames/route_restore_game.gd")

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	await _test_route_danger_and_broken_paths()
	await _test_route_reset_preserves_danger_case()
	await _test_route_variables_are_deterministic()
	await _test_route_clear_grades()
	await _test_route_mouse_and_keyboard_inputs()
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


func _test_route_danger_and_broken_paths() -> void:
	var game := _new_route_game()
	var initial_tiles: Array = game.get("_tiles").duplicate(true)
	game.call("_confirm_route")
	_expect(bool(game.get("_danger_case_seen")), "the initial false destination should record a danger case")
	_expect(int(game.get("_wrong_destination_count")) == 1, "the initial false destination should increment danger cases once")
	_expect(int(game.get("_move_count")) == 0, "a danger case should preserve the move count")
	_expect(game.get("_tiles") == initial_tiles, "a danger case should preserve the board")

	game.call("_rotate_selected")
	game.call("_confirm_route")
	_expect(int(game.get("_wrong_destination_count")) == 1, "a broken route should not increment danger cases")
	_expect(not bool(game.get("_finished")), "a broken route should keep the board playable")
	game.queue_free()
	await process_frame


func _test_route_reset_preserves_danger_case() -> void:
	var game := _new_route_game()
	game.call("_confirm_route")
	game.call("_rotate_selected")
	game.call("_reset_attempt")
	_expect(game.get("_tiles") == game.get("_initial_tiles"), "reset should restore the initial route board")
	_expect(int(game.get("_move_count")) == 0, "reset should clear only the current move count")
	_expect(Vector2i(game.get("_selected")) == Vector2i(1, 2), "reset should restore the initial selection")
	_expect(bool(game.get("_danger_case_seen")), "reset should preserve an observed danger case")
	_expect(int(game.get("_wrong_destination_count")) == 1, "reset should preserve the danger case count")
	game.queue_free()
	await process_frame


func _test_route_variables_are_deterministic() -> void:
	var first := _new_route_game({"route_risk": 5, "route_entrenchment": 5})
	var second := _new_route_game({"route_risk": 5, "route_entrenchment": 5})
	_expect(bool(first.get("_route_lock")), "high entrenchment should enable the route lock")
	_expect(bool(first.get("_route_wobble")), "combined risk and entrenchment should enable the announced route wobble")
	first.call("_build_final_board")
	second.call("_build_final_board")
	_expect(first.get("_tiles") == second.get("_tiles"), "the same checkpoint risk inputs should create the same final board")
	var locked_tile: Dictionary = first.get("_tiles")[first.call("_coord_to_index", Vector2i(2, 1))]
	_expect(bool(locked_tile.get("locked", false)), "route lock should mark the documented final-board tile")
	first.queue_free()
	second.queue_free()
	await process_frame


func _test_route_clear_grades() -> void:
	var optimal := _complete_route(0)
	_assert_route_result(optimal, 8, "optimal", "최적 복원")
	var precision := _complete_route(1)
	_assert_route_result(precision, 9, "precision", "정밀 복원")
	var standard := _complete_route(3)
	_assert_route_result(standard, 11, "standard", "일반 복원")
	await process_frame


func _test_route_mouse_and_keyboard_inputs() -> void:
	var keyboard_game := _new_route_game()
	keyboard_game.call("set_input_locked", true)
	keyboard_game.call("_unhandled_key_input", _key_event(KEY_ENTER))
	_expect(int(keyboard_game.get("_move_count")) == 0, "manual overlay should block route keyboard input")
	keyboard_game.call("set_input_locked", false)
	keyboard_game.call("_unhandled_key_input", _key_event(KEY_ENTER))
	_expect(int(keyboard_game.get("_move_count")) == 1, "Enter should rotate the selected route tile")
	keyboard_game.call("_unhandled_key_input", _key_event(KEY_C))
	_expect(int(keyboard_game.get("_wrong_destination_count")) == 0, "C on a broken route should use the normal confirmation path")
	keyboard_game.call("_unhandled_key_input", _key_event(KEY_R))
	_expect(int(keyboard_game.get("_move_count")) == 0, "R should use the normal route reset path")
	keyboard_game.queue_free()
	await process_frame

	var mouse_game := _new_route_game()
	var board_rect: Rect2 = mouse_game.call("_board_rect")
	var cell_size := board_rect.size.x / 3.0
	var center_cell := board_rect.position + Vector2(cell_size * 1.5, cell_size * 1.5)
	mouse_game.call("_gui_input", _mouse_event(center_cell))
	_expect(Vector2i(mouse_game.get("_selected")) == Vector2i(1, 1), "a board click should select the clicked route tile")
	_expect(int(mouse_game.get("_move_count")) == 1, "a board click should rotate through the normal route path")
	var reset_rect: Rect2 = mouse_game.call("_reset_rect")
	mouse_game.call("_gui_input", _mouse_event(reset_rect.get_center()))
	_expect(int(mouse_game.get("_move_count")) == 0, "the mouse reset button should use the normal reset path")
	var confirm_rect: Rect2 = mouse_game.call("_confirm_rect")
	mouse_game.call("_gui_input", _mouse_event(confirm_rect.get_center()))
	_expect(int(mouse_game.get("_wrong_destination_count")) == 1, "the mouse confirm button should use the normal confirmation path")
	mouse_game.queue_free()
	await process_frame


func _new_route_game(config: Dictionary = {}) -> Control:
	var game := RouteGame.new()
	root.add_child(game)
	game.size = Vector2(620, 440)
	var route_config := {"optimal_move_count": 4, "precision_move_limit": 6}
	for key in config:
		route_config[key] = config[key]
	game.configure(route_config, false)
	return game


func _complete_route(extra_turns: int) -> Array:
	var game := _new_route_game()
	var captured: Array = []
	var stages: Array[String] = []
	game.completed.connect(func(successful: bool, details: Dictionary) -> void: captured.assign([successful, details]))
	game.stage_changed.connect(func(stage_id: String, _title: String, _details: Dictionary) -> void: stages.append(stage_id))
	_rotate_route_tile(game, Vector2i(1, 2), 1)
	_rotate_route_tile(game, Vector2i(1, 1), 1)
	_rotate_route_tile(game, Vector2i(2, 1), 2)
	game.call("_confirm_route")
	_expect(not bool(game.get("_finished")) and bool(game.get("_tutorial_complete")), "3x3 should advance to 4x4 without completing")
	_expect(stages == ["final"], "3x3 should emit only a final-stage display transition and no completion result")
	_rotate_route_tile(game, Vector2i(1, 3), 1)
	_rotate_route_tile(game, Vector2i(1, 2), 1)
	_rotate_route_tile(game, Vector2i(1, 1), 1)
	_rotate_route_tile(game, Vector2i(2, 1), 2)
	_rotate_route_tile(game, Vector2i(2, 0), 3)
	# Additional verified detours are counted by the final board, without changing the solved orientation.
	game.set("_move_count", 8 + extra_turns)
	game.call("_confirm_route")
	game.queue_free()
	return captured


func _rotate_route_tile(game: Control, coord: Vector2i, count: int) -> void:
	game.set("_selected", coord)
	for turn in range(count):
		game.call("_rotate_selected")


func _assert_route_result(captured: Array, move_count: int, grade: String, grade_label: String) -> void:
	_expect(captured.size() == 2 and bool(captured[0]), "%d route moves should complete successfully" % move_count)
	if captured.size() != 2:
		return
	var details: Dictionary = captured[1]
	_expect(int(details.get("move_count", -1)) == move_count, "route completion should store %d moves" % move_count)
	_expect(String(details.get("clear_grade", "")) == grade, "%d route moves should receive the %s grade" % [move_count, grade])
	_expect(String(details.get("clear_grade_label", "")) == grade_label, "%d route moves should use the expected grade label" % move_count)


func _key_event(keycode: Key) -> InputEventKey:
	var event := InputEventKey.new()
	event.keycode = keycode
	event.pressed = true
	return event


func _mouse_event(position: Vector2) -> InputEventMouseButton:
	var event := InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	event.position = position
	return event


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
