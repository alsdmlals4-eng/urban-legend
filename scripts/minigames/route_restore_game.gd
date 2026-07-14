# 저승역의 3x3 노선 복원 PoC를 관리한다.
extends Control

signal completed(successful: bool, details: Dictionary)
signal status_changed(text: String, progress: float)

const GRID_SIZE := 3
const NORTH := Vector2i(0, -1)
const EAST := Vector2i(1, 0)
const SOUTH := Vector2i(0, 1)
const WEST := Vector2i(-1, 0)
const START_COORD := Vector2i(0, 2)
const SAFE_COORD := Vector2i(2, 0)
const FALSE_COORD := Vector2i(2, 2)

var _tiles: Array[Dictionary] = []
var _initial_tiles: Array[Dictionary] = []
var _selected := Vector2i(1, 2)
var _move_count := 0
var _optimal_move_count := 4
var _precision_move_limit := 6
var _wrong_destination_count := 0
var _danger_case_seen := false
var _finished := false
var _feedback := "오현: 공식 기록의 안전 출구는 북쪽 노선입니다."
var _feedback_color := Color(0.72, 0.84, 0.88)


func configure(config: Dictionary, _equipment_assisted: bool) -> void:
	_optimal_move_count = max(1, int(config.get("optimal_move_count", 4)))
	_precision_move_limit = max(_optimal_move_count, int(config.get("precision_move_limit", _optimal_move_count + 2)))
	_build_initial_board()
	custom_minimum_size = Vector2(620, 440)
	focus_mode = Control.FOCUS_ALL
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_process_unhandled_key_input(true)
	call_deferred("grab_focus")
	_emit_status()
	queue_redraw()


func _build_initial_board() -> void:
	_tiles = [
		{"kind": "block"},
		{"kind": "block"},
		{"kind": "safe"},
		{"kind": "block"},
		{"kind": "curve", "orientation": 0},
		{"kind": "curve", "orientation": 1},
		{"kind": "start"},
		{"kind": "switch", "state": 0},
		{"kind": "false"}
	]
	_initial_tiles = _tiles.duplicate(true)


func _gui_input(event: InputEvent) -> void:
	if _finished:
		return
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index != MOUSE_BUTTON_LEFT or not mouse_event.pressed:
			return
		var board_coord := _coord_from_position(mouse_event.position)
		if board_coord.x >= 0:
			_selected = board_coord
			_rotate_selected()
		elif _confirm_rect().has_point(mouse_event.position):
			_confirm_route()
		elif _reset_rect().has_point(mouse_event.position):
			_reset_attempt()
		get_viewport().set_input_as_handled()
		return
	if event is InputEventKey:
		var key_event := event as InputEventKey
		if not key_event.pressed or key_event.echo:
			return
		if event.is_action_pressed("ui_left"):
			_move_selection(WEST)
		elif event.is_action_pressed("ui_right"):
			_move_selection(EAST)
		elif event.is_action_pressed("ui_up"):
			_move_selection(NORTH)
		elif event.is_action_pressed("ui_down"):
			_move_selection(SOUTH)
		elif event.is_action_pressed("ui_accept"):
			_rotate_selected()
		elif key_event.keycode == KEY_C:
			_confirm_route()
		elif key_event.keycode == KEY_R:
			_reset_attempt()
		else:
			return
		get_viewport().set_input_as_handled()


func _unhandled_key_input(event: InputEvent) -> void:
	_gui_input(event)


func _move_selection(direction: Vector2i) -> void:
	_selected.x = clampi(_selected.x + direction.x, 0, GRID_SIZE - 1)
	_selected.y = clampi(_selected.y + direction.y, 0, GRID_SIZE - 1)
	_feedback = "권나래: 현재 분기 상태를 확인합니다."
	_feedback_color = Color(0.72, 0.84, 0.88)
	_emit_status()
	queue_redraw()


func _rotate_selected() -> void:
	var index := _coord_to_index(_selected)
	var tile: Dictionary = _tiles[index]
	match String(tile.get("kind", "block")):
		"curve":
			tile["orientation"] = (int(tile.get("orientation", 0)) + 1) % 4
			_move_count += 1
			_feedback = "강이준: 선택한 곡선 구간을 회전시켰습니다."
		"switch":
			tile["state"] = 1 - int(tile.get("state", 0))
			_move_count += 1
			_feedback = "강이준: 분기 스위치를 전환했습니다."
		_:
			_feedback = "이 구간은 조작할 수 없습니다."
			_feedback_color = Color(0.9, 0.66, 0.35)
			_emit_status()
			queue_redraw()
			return
	_tiles[index] = tile
	_feedback_color = Color(0.42, 0.9, 0.74)
	_emit_status()
	queue_redraw()


func _confirm_route() -> void:
	var reach := _get_reachability()
	var reaches_safe := bool(reach.get("safe", false))
	var reaches_false := bool(reach.get("false", false))
	if reaches_safe and not reaches_false:
		_complete()
		return
	if reaches_false:
		_wrong_destination_count += 1
		_danger_case_seen = true
		_feedback = "위험 사례: 개인이 인식한 목적지를 적용하자 같은 승강장으로 되돌아왔습니다."
		_feedback_color = Color(0.96, 0.42, 0.42)
	else:
		_feedback = "권나래: 선로 연결음이 없습니다. 끊긴 구간을 다시 확인해 주세요."
		_feedback_color = Color(0.9, 0.66, 0.35)
	_emit_status()
	queue_redraw()


func _reset_attempt() -> void:
	_tiles = _initial_tiles.duplicate(true)
	_move_count = 0
	_selected = Vector2i(1, 2)
	_feedback = "현재 시도의 노선과 조작 횟수를 초기화했습니다. 기록된 위험 사례는 유지됩니다."
	_feedback_color = Color(0.72, 0.84, 0.88)
	_emit_status()
	queue_redraw()


func _complete() -> void:
	_finished = true
	var clear_grade := "standard"
	var grade_label := "일반 복원"
	if _move_count <= _optimal_move_count:
		clear_grade = "optimal"
		grade_label = "최적 복원"
	elif _move_count <= _precision_move_limit:
		clear_grade = "precision"
		grade_label = "정밀 복원"
	_feedback = "오현: 공식 기록과 실제 이동 경로가 일치합니다. %s 완료." % grade_label
	_feedback_color = Color(0.35, 0.92, 0.72)
	_emit_status(1.0)
	queue_redraw()
	completed.emit(true, {
		"game_type": "route_restore",
		"move_count": _move_count,
		"optimal_move_count": _optimal_move_count,
		"precision_move_limit": _precision_move_limit,
		"clear_grade": clear_grade,
		"clear_grade_label": grade_label,
		"danger_case_seen": _danger_case_seen,
		"wrong_destination_count": _wrong_destination_count,
		"input_summary": "노선 조작 %d회 / 정밀 기준 %d회 / %s%s" % [
			_move_count,
			_precision_move_limit,
			grade_label,
			" / 위험 사례 %d회" % _wrong_destination_count if _danger_case_seen else ""
		]
	})


func _get_reachability() -> Dictionary:
	var queue: Array[Vector2i] = [START_COORD]
	var visited: Dictionary = {_coord_to_index(START_COORD): true}
	while not queue.is_empty():
		var current: Vector2i = queue.pop_front()
		for direction in _connections_for(current):
			var next := current + direction
			if not _is_in_bounds(next):
				continue
			if not _connections_for(next).has(-direction):
				continue
			var next_index := _coord_to_index(next)
			if visited.has(next_index):
				continue
			visited[next_index] = true
			queue.append(next)
	return {
		"safe": visited.has(_coord_to_index(SAFE_COORD)),
		"false": visited.has(_coord_to_index(FALSE_COORD))
	}


func _connections_for(coord: Vector2i) -> Array[Vector2i]:
	var tile: Dictionary = _tiles[_coord_to_index(coord)]
	match String(tile.get("kind", "block")):
		"start": return [EAST]
		"safe": return [SOUTH]
		"false": return [WEST]
		"switch":
			return [WEST, EAST] if int(tile.get("state", 0)) == 0 else [WEST, NORTH]
		"curve":
			match int(tile.get("orientation", 0)) % 4:
				0: return [NORTH, EAST]
				1: return [EAST, SOUTH]
				2: return [SOUTH, WEST]
				_: return [WEST, NORTH]
		_: return []


func _emit_status(progress_override: float = -1.0) -> void:
	var progress := progress_override
	if progress < 0.0:
		progress = clampf(float(_move_count) / float(max(1, _precision_move_limit)), 0.0, 0.95)
	status_changed.emit("조작 %d회  |  정밀 기준 %d회\n%s" % [_move_count, _precision_move_limit, _feedback], progress)


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.02, 0.035, 0.045), true)
	var board := _board_rect()
	var cell_size := board.size.x / float(GRID_SIZE)
	for row in range(GRID_SIZE):
		for column in range(GRID_SIZE):
			var coord := Vector2i(column, row)
			var rect := Rect2(board.position + Vector2(column, row) * cell_size, Vector2.ONE * cell_size)
			_draw_tile(coord, rect)
			draw_rect(rect, Color(0.22, 0.34, 0.38), false, 1.0)
			if coord == _selected:
				draw_rect(rect.grow(-4.0), Color(0.35, 0.9, 0.74), false, 3.0)
	_draw_button(_reset_rect(), "R  처음부터", Color(0.28, 0.38, 0.42))
	_draw_button(_confirm_rect(), "C  경로 확인", Color(0.16, 0.58, 0.48))
	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(24, 28), "오현: 방송실  /  권나래: 피해자 호송  /  강이준: 현실 경계", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color(0.64, 0.78, 0.82))


func _draw_tile(coord: Vector2i, rect: Rect2) -> void:
	var tile: Dictionary = _tiles[_coord_to_index(coord)]
	var center := rect.get_center()
	var radius := rect.size.x * 0.34
	var kind := String(tile.get("kind", "block"))
	var tile_color := Color(0.055, 0.08, 0.095)
	if kind == "block":
		tile_color = Color(0.025, 0.04, 0.05)
	elif kind == "safe":
		tile_color = Color(0.08, 0.28, 0.22)
	elif kind == "false":
		tile_color = Color(0.28, 0.08, 0.1)
	draw_rect(rect.grow(-3.0), tile_color, true)
	var line_color := Color(0.76, 0.88, 0.88)
	for direction in _connections_for(coord):
		draw_line(center, center + Vector2(direction) * radius, line_color, 8.0, true)
	var font := ThemeDB.fallback_font
	match kind:
		"start": draw_string(font, center + Vector2(-18, 6), "S", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(0.5, 0.95, 0.78))
		"safe": draw_string(font, center + Vector2(-22, 6), "D✓", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(0.5, 0.95, 0.78))
		"false": draw_string(font, center + Vector2(-20, 6), "D?", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(1.0, 0.58, 0.58))
		"switch": draw_string(font, center + Vector2(-16, 6), "SW", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color(0.96, 0.8, 0.38))
		"block": draw_string(font, center + Vector2(-7, 6), "■", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(0.18, 0.24, 0.26))


func _draw_button(rect: Rect2, text: String, color: Color) -> void:
	draw_rect(rect, color, true)
	draw_rect(rect, Color(0.55, 0.72, 0.74), false, 1.0)
	var font := ThemeDB.fallback_font
	draw_string(font, rect.position + Vector2(16, rect.size.y * 0.65), text, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color(0.92, 0.96, 0.96))


func _board_rect() -> Rect2:
	var board_size := minf(315.0, minf(size.x - 48.0, size.y - 116.0))
	board_size = maxf(210.0, board_size)
	return Rect2(Vector2((size.x - board_size) * 0.5, 46.0), Vector2.ONE * board_size)


func _reset_rect() -> Rect2:
	var board := _board_rect()
	return Rect2(Vector2(board.position.x, board.end.y + 14.0), Vector2(board.size.x * 0.46, 42.0))


func _confirm_rect() -> Rect2:
	var board := _board_rect()
	return Rect2(Vector2(board.position.x + board.size.x * 0.54, board.end.y + 14.0), Vector2(board.size.x * 0.46, 42.0))


func _coord_from_position(position: Vector2) -> Vector2i:
	var board := _board_rect()
	if not board.has_point(position):
		return Vector2i(-1, -1)
	var local := position - board.position
	var cell_size := board.size.x / float(GRID_SIZE)
	return Vector2i(clampi(int(local.x / cell_size), 0, GRID_SIZE - 1), clampi(int(local.y / cell_size), 0, GRID_SIZE - 1))


func _coord_to_index(coord: Vector2i) -> int:
	return coord.y * GRID_SIZE + coord.x


func _is_in_bounds(coord: Vector2i) -> bool:
	return coord.x >= 0 and coord.x < GRID_SIZE and coord.y >= 0 and coord.y < GRID_SIZE
