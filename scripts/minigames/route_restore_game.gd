# 저승역의 단일 노선 복원 미니게임: 3x3 학습 뒤 4x4 현장 검증.
extends Control

signal completed(successful: bool, details: Dictionary)
signal status_changed(text: String, progress: float)
signal stage_changed(stage_id: String, title: String, details: Dictionary)

const NORTH := Vector2i(0, -1)
const EAST := Vector2i(1, 0)
const SOUTH := Vector2i(0, 1)
const WEST := Vector2i(-1, 0)

var _grid_size := 3
var _start := Vector2i(0, 2)
var _safe := Vector2i(2, 0)
var _false := Vector2i(2, 2)
var _tiles: Array[Dictionary] = []
var _initial_tiles: Array[Dictionary] = []
var _selected := Vector2i(1, 2)
var _move_count := 0
var _wrong_destination_count := 0
var _danger_case_seen := false
var _tutorial_complete := false
var _route_lock := false
var _route_wobble := false
var _wobble_used := false
var _finished := false
var _input_locked := false
var _feedback := "오현: 공식 기록의 안전 출구는 북쪽 노선입니다."
var _feedback_color := Color(0.72, 0.84, 0.88)


func configure(config: Dictionary, _equipment_assisted: bool) -> void:
	_build_tutorial_board()
	# 저장된 조사 상태만 사용한다. 미니게임 중 결과는 다음 진입에 영향을 주지 않는다.
	var entrenchment := int(config.get("route_entrenchment", 0))
	_route_lock = entrenchment >= 5
	_route_wobble = int(config.get("route_risk", 0)) >= 5 and _route_lock
	custom_minimum_size = Vector2(520, 360)
	focus_mode = Control.FOCUS_ALL
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_process_unhandled_key_input(true)
	call_deferred("grab_focus")
	stage_changed.emit("tutorial", "조작 학습 1/2 · 결과 미저장", {"grid_size": 3, "result_saved": false})
	_emit_status()
	queue_redraw()


func _build_tutorial_board() -> void:
	_grid_size = 3
	_start = Vector2i(0, 2)
	_safe = Vector2i(2, 0)
	_false = Vector2i(2, 2)
	_tiles = [
		{"kind":"block"}, {"kind":"block"}, {"kind":"safe"},
		{"kind":"block"}, {"kind":"curve","orientation":0}, {"kind":"curve","orientation":1},
		{"kind":"start"}, {"kind":"switch","state":0}, {"kind":"false"}
	]
	_initial_tiles = _tiles.duplicate(true)
	_selected = Vector2i(1, 2)
	_move_count = 0
	_feedback = "3×3 조작 학습: 표지 문구보다 공식 기록 아이콘을 확인하세요."


func _build_final_board() -> void:
	_grid_size = 4
	_start = Vector2i(0, 3)
	_safe = Vector2i(3, 0)
	_false = Vector2i(3, 3)
	_tiles = [
		{"kind":"block"}, {"kind":"block"}, {"kind":"curve","orientation":2}, {"kind":"safe"},
		{"kind":"block"}, {"kind":"curve","orientation":0}, {"kind":"curve","orientation":1,"locked":_route_lock}, {"kind":"block"},
		{"kind":"block"}, {"kind":"straight","state":0}, {"kind":"block"}, {"kind":"block"},
		{"kind":"start"}, {"kind":"switch","state":0}, {"kind":"block"}, {"kind":"false"}
	]
	_initial_tiles = _tiles.duplicate(true)
	_selected = Vector2i(1, 3)
	_move_count = 0
	_feedback = "4×4 최종 검증: 확보 기록과 공식 식별 번호로 안전 노선을 복원하세요."
	if _route_lock:
		_feedback += " 강이준: 고정못이 박힌 구간은 먼저 해제해야 합니다."
	if _route_wobble:
		_feedback += " 오현: 세 번째 구간은 연결 직후 한 번 흔들릴 수 있습니다."


func _gui_input(event: InputEvent) -> void:
	if _finished or _input_locked:
		return
	if event is InputEventMouseButton:
		var mouse := event as InputEventMouseButton
		if mouse.button_index == MOUSE_BUTTON_LEFT and mouse.pressed:
			var coord := _coord_from_position(mouse.position)
			if coord.x >= 0:
				_selected = coord
				_rotate_selected()
			elif _confirm_rect().has_point(mouse.position):
				_confirm_route()
			elif _reset_rect().has_point(mouse.position):
				_reset_attempt()
			get_viewport().set_input_as_handled()
	elif event is InputEventKey:
		var key := event as InputEventKey
		if not key.pressed or key.echo:
			return
		if event.is_action_pressed("ui_left"): _move_selection(WEST)
		elif event.is_action_pressed("ui_right"): _move_selection(EAST)
		elif event.is_action_pressed("ui_up"): _move_selection(NORTH)
		elif event.is_action_pressed("ui_down"): _move_selection(SOUTH)
		elif event.is_action_pressed("ui_accept"): _rotate_selected()
		elif key.keycode == KEY_C: _confirm_route()
		elif key.keycode == KEY_R: _reset_attempt()
		else: return
		get_viewport().set_input_as_handled()


func _unhandled_key_input(event: InputEvent) -> void:
	_gui_input(event)


func set_input_locked(locked: bool) -> void:
	_input_locked = locked
	if not locked:
		call_deferred("grab_focus")


func _move_selection(direction: Vector2i) -> void:
	_selected.x = clampi(_selected.x + direction.x, 0, _grid_size - 1)
	_selected.y = clampi(_selected.y + direction.y, 0, _grid_size - 1)
	_feedback = "권나래: 현재 분기 상태를 확인합니다."
	_emit_status(); queue_redraw()


func _rotate_selected() -> void:
	var index := _coord_to_index(_selected)
	var tile: Dictionary = _tiles[index]
	if bool(tile.get("locked", false)):
		tile["locked"] = false
		_tiles[index] = tile
		_move_count += 1
		_feedback = "강이준: 고정못을 해제했습니다. 이제 이 구간을 회전할 수 있습니다."
		_emit_status(); queue_redraw(); return
	match String(tile.get("kind", "block")):
		"curve": tile["orientation"] = (int(tile.get("orientation", 0)) + 1) % 4
		"switch", "straight": tile["state"] = 1 - int(tile.get("state", 0))
		_:
			_feedback = "이 구간은 조작할 수 없습니다."
			_emit_status(); queue_redraw(); return
	_tiles[index] = tile
	_move_count += 1
	_feedback = "강이준: 노선 구간을 조정했습니다."
	_emit_status(); queue_redraw()


func _confirm_route() -> void:
	var reach := _get_reachability()
	if _is_solution() or (bool(reach.get("safe", false)) and not bool(reach.get("false", false))):
		if not _tutorial_complete:
			_tutorial_complete = true
			_build_final_board()
			stage_changed.emit("final", "현장 검증 2/2 · 결과 저장", {"grid_size": 4, "result_saved": true})
			_feedback = "3×3 조작 학습 완료. " + _feedback
			_emit_status(); queue_redraw(); return
		if _route_wobble and not _wobble_used:
			_wobble_used = true
			var straight_index := _coord_to_index(Vector2i(1, 2))
			var straight: Dictionary = _tiles[straight_index]
			straight["state"] = 0
			_tiles[straight_index] = straight
			_feedback = "위험 사례: 경로가 한 차례 뒤틀렸습니다. 세 번째 구간을 다시 맞추세요."
			_danger_case_seen = true
			_emit_status(); queue_redraw(); return
		_complete()
	elif bool(reach.get("false", false)):
		_wrong_destination_count += 1
		_danger_case_seen = true
		_feedback = "위험 사례: 개인이 인식한 목적지를 적용하자 위치가 출발 분기점으로 초기화됐습니다."
	else:
		_feedback = "권나래: 연결음이 없습니다. 끊긴 구간을 다시 확인해 주세요."
	_emit_status(); queue_redraw()


func _is_solution() -> bool:
	if not _tutorial_complete:
		return int(_tiles[_coord_to_index(Vector2i(1, 2))].get("state", 0)) == 1 and int(_tiles[_coord_to_index(Vector2i(1, 1))].get("orientation", 0)) == 1 and int(_tiles[_coord_to_index(Vector2i(2, 1))].get("orientation", 0)) == 3
	return int(_tiles[_coord_to_index(Vector2i(1, 3))].get("state", 0)) == 1 and int(_tiles[_coord_to_index(Vector2i(1, 2))].get("state", 0)) == 1 and int(_tiles[_coord_to_index(Vector2i(1, 1))].get("orientation", 0)) == 1 and int(_tiles[_coord_to_index(Vector2i(2, 1))].get("orientation", 0)) == 3 and int(_tiles[_coord_to_index(Vector2i(2, 0))].get("orientation", 0)) == 1


func _reset_attempt() -> void:
	_tiles = _initial_tiles.duplicate(true)
	_move_count = 0
	_selected = Vector2i(1, _grid_size - 1)
	_feedback = "노선과 조작 횟수만 초기화했습니다. 기록된 위험 사례는 유지됩니다."
	_emit_status(); queue_redraw()


func _complete() -> void:
	_finished = true
	var grade := "optimal" if _move_count <= 8 else ("precision" if _move_count <= 10 else "standard")
	var grade_label: String = String({"optimal":"최적 복원", "precision":"정밀 복원", "standard":"일반 복원"}.get(grade, "일반 복원"))
	_feedback = "오현: 공식 기록과 실제 이동 경로가 일치합니다. %s 완료." % grade_label
	_emit_status(1.0); queue_redraw()
	completed.emit(true, {"game_type":"route_restore","tutorial_completed":true,"move_count":_move_count,"optimal_move_count":8,"precision_move_limit":10,"clear_grade":grade,"clear_grade_label":grade_label,"danger_case_seen":_danger_case_seen,"wrong_destination_count":_wrong_destination_count,"final_clue_title":"안전 노선 검증 기록","final_clue_text":"공식 운행 기록과 일치하는 노선은 공간 초기화 없이 현실 승강장으로 연결되었다.","display_title":"저승역 노선 복원","input_summary":"4×4 조작 %d회 / 정밀 기준 10회 / %s" % [_move_count, grade_label]})


func _get_reachability() -> Dictionary:
	var queue: Array[Vector2i] = [_start]
	var visited: Dictionary = {_coord_to_index(_start):true}
	while not queue.is_empty():
		var current: Vector2i = queue.pop_front()
		for direction in _connections_for(current):
			var next := current + direction
			if _is_in_bounds(next) and _connections_for(next).has(-direction) and not visited.has(_coord_to_index(next)):
				visited[_coord_to_index(next)] = true; queue.append(next)
	return {"safe":visited.has(_coord_to_index(_safe)), "false":visited.has(_coord_to_index(_false))}


func _connections_for(coord: Vector2i) -> Array[Vector2i]:
	var tile: Dictionary = _tiles[_coord_to_index(coord)]
	match String(tile.get("kind", "block")):
		"start": return [EAST]
		"safe": return [SOUTH]
		"false": return [WEST]
		"switch": return [WEST, EAST] if int(tile.get("state", 0)) == 0 else [WEST, NORTH]
		"straight": return [WEST, EAST] if int(tile.get("state", 0)) == 0 else [NORTH, SOUTH]
		"curve":
			match int(tile.get("orientation", 0)) % 4:
				0: return [NORTH, EAST]
				1: return [EAST, SOUTH]
				2: return [SOUTH, WEST]
				_: return [WEST, NORTH]
	return []


func _emit_status(progress_override: float = -1.0) -> void:
	var limit := 6 if not _tutorial_complete else 10
	var stage := "조작 학습 1/2 · 결과 미저장" if not _tutorial_complete else "현장 검증 2/2 · 결과 저장"
	status_changed.emit("%s · 조작 %d회 / 정밀 기준 %d회\n%s" % [stage, _move_count, limit, _feedback], progress_override if progress_override >= 0 else clampf(float(_move_count) / limit, 0.0, 0.95))


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.02,0.035,0.045), true)
	var board := _board_rect(); var cell := board.size.x / float(_grid_size)
	for row in range(_grid_size):
		for column in range(_grid_size):
			var coord := Vector2i(column,row); var rect := Rect2(board.position + Vector2(column,row)*cell, Vector2.ONE*cell)
			_draw_tile(coord,rect); draw_rect(rect,Color(0.22,0.34,0.38),false,1.0)
			if coord == _selected: draw_rect(rect.grow(-4),Color(0.35,0.9,0.74),false,3.0)
	_draw_button(_reset_rect(),"R  처음부터",Color(0.28,0.38,0.42)); _draw_button(_confirm_rect(),"C  경로 확인",Color(0.16,0.58,0.48))
	draw_string(ThemeDB.fallback_font,Vector2(24,28),"공식 기록과 현장 표기를 대조해 안전 노선을 복원하십시오.",HORIZONTAL_ALIGNMENT_LEFT,-1,16,Color(0.64,0.78,0.82))


func _draw_tile(coord: Vector2i, rect: Rect2) -> void:
	var tile: Dictionary = _tiles[_coord_to_index(coord)]; var kind := String(tile.get("kind","block")); var center := rect.get_center(); var radius := rect.size.x*0.34
	var color := Color(0.055,0.08,0.095) if kind != "block" else Color(0.025,0.04,0.05)
	if kind == "safe": color=Color(0.08,0.28,0.22)
	elif kind == "false": color=Color(0.28,0.08,0.1)
	draw_rect(rect.grow(-3),color,true)
	for direction in _connections_for(coord): draw_line(center,center+Vector2(direction)*radius,Color(0.76,0.88,0.88),8,true)
	var font:=ThemeDB.fallback_font
	var labels={"start":"S","safe":"D✓","false":"D?","switch":"SW","straight":"┃","block":"■"}
	if labels.has(kind): draw_string(font,center+Vector2(-18,6),String(labels[kind]),HORIZONTAL_ALIGNMENT_LEFT,-1,16,Color(0.9,0.95,0.95))
	if bool(tile.get("locked",false)): draw_string(font,center+Vector2(8,-8),"🔒",HORIZONTAL_ALIGNMENT_LEFT,-1,14,Color(1,0.72,0.32))


func _draw_button(rect: Rect2,text: String,color: Color) -> void:
	draw_rect(rect,color,true); draw_rect(rect,Color(0.55,0.72,0.74),false,1); draw_string(ThemeDB.fallback_font,rect.position+Vector2(16,rect.size.y*0.65),text,HORIZONTAL_ALIGNMENT_LEFT,-1,16,Color(0.92,0.96,0.96))

func _board_rect() -> Rect2:
	var board_size:=maxf(210,minf(340,minf(size.x-48,size.y-116))); return Rect2(Vector2((size.x-board_size)*0.5,46),Vector2.ONE*board_size)
func _reset_rect() -> Rect2:
	var board:=_board_rect(); return Rect2(Vector2(board.position.x,board.end.y+14),Vector2(board.size.x*0.46,42))
func _confirm_rect() -> Rect2:
	var board:=_board_rect(); return Rect2(Vector2(board.position.x+board.size.x*0.54,board.end.y+14),Vector2(board.size.x*0.46,42))
func _coord_from_position(position: Vector2) -> Vector2i:
	var board:=_board_rect(); if not board.has_point(position): return Vector2i(-1,-1)
	var local:=position-board.position; var cell:=board.size.x/float(_grid_size); return Vector2i(clampi(int(local.x/cell),0,_grid_size-1),clampi(int(local.y/cell),0,_grid_size-1))
func _coord_to_index(coord: Vector2i) -> int: return coord.y*_grid_size+coord.x
func _is_in_bounds(coord: Vector2i) -> bool: return coord.x>=0 and coord.x<_grid_size and coord.y>=0 and coord.y<_grid_size
