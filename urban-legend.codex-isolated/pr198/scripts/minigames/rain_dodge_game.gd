# 빨간 우산의 방향키 이동, 빗방울 충돌과 생존 판정을 관리한다.
extends Control

signal completed(successful: bool, details: Dictionary)
signal status_changed(text: String, progress: float)

const Rules = preload("res://scripts/minigames/minigame_rules.gd")
const MAX_SIMULATION_STEP := 1.0 / 60.0

var _duration := 12.0
var _max_hits := 3
var _move_speed := 310.0
var _spawn_interval := 0.34
var _drop_speed_min := 190.0
var _drop_speed_max := 280.0
var _elapsed := 0.0
var _spawn_elapsed := 0.0
var _hits := 0
var _dodged := 0
var _shield_count := 0
var _shield_used := 0
var _invulnerability := 0.0
var _player_position := Vector2.ZERO
var _player_size := Vector2(70, 30)
var _drops: Array[Dictionary] = []
var _rng := RandomNumberGenerator.new()
var _finished := false
var _initialized := false
var _started := false


func configure(config: Dictionary, equipment_assisted: bool) -> void:
	_duration = maxf(3.0, float(config.get("duration", 12.0)))
	_max_hits = max(1, int(config.get("max_hits", 3)))
	_move_speed = maxf(120.0, float(config.get("move_speed", 310.0)))
	_spawn_interval = maxf(0.12, float(config.get("spawn_interval", 0.34)))
	_drop_speed_min = maxf(100.0, float(config.get("drop_speed_min", 190.0)))
	_drop_speed_max = maxf(_drop_speed_min, float(config.get("drop_speed_max", 280.0)))
	_shield_count = 1 if equipment_assisted else 0
	_rng.randomize()
	custom_minimum_size = Vector2(600, 430)
	focus_mode = Control.FOCUS_ALL
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_process(true)
	call_deferred("_initialize_player")
	call_deferred("grab_focus")


func _initialize_player() -> void:
	var bounds := _get_playfield()
	_player_position = Vector2(bounds.get_center().x - _player_size.x * 0.5, bounds.end.y - _player_size.y - 12.0)
	_initialized = true
	_emit_status()
	queue_redraw()


func _process(delta: float) -> void:
	if _finished or not _initialized:
		return
	if not _started:
		if Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").is_zero_approx():
			return
		_started = true
	if Rules.is_rain_failure(_hits, _max_hits):
		_complete(false)
		return

	var remaining_delta := minf(delta, maxf(0.0, _duration - _elapsed))
	while remaining_delta > 0.000001:
		var step := minf(remaining_delta, MAX_SIMULATION_STEP)
		_advance_simulation(step)
		remaining_delta -= step
		if Rules.is_rain_failure(_hits, _max_hits):
			_complete(false)
			return

	if _elapsed >= _duration:
		_complete(true)
		return
	_emit_status()
	queue_redraw()


func _advance_simulation(delta: float) -> void:
	_elapsed = minf(_duration, _elapsed + delta)
	_invulnerability = maxf(0.0, _invulnerability - delta)
	_move_player(delta)
	_update_drops(delta)
	_spawn_elapsed += delta
	while _spawn_elapsed >= _spawn_interval:
		_spawn_elapsed -= _spawn_interval
		_spawn_drop()


func _move_player(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	_player_position += direction * _move_speed * delta
	_player_position = Rules.clamp_player_position(_player_position, _get_playfield(), _player_size)


func _spawn_drop() -> void:
	var bounds := _get_playfield()
	var cluster_roll := _rng.randi_range(1, 10)
	var count := 2 if cluster_roll >= 9 else 1
	for index in range(count):
		_drops.append({
			"position": Vector2(_rng.randf_range(bounds.position.x + 8.0, bounds.end.x - 8.0), bounds.position.y - 32.0 - float(index) * 22.0),
			"speed": _rng.randf_range(_drop_speed_min, _drop_speed_max),
			"length": _rng.randf_range(22.0, 36.0)
		})


func _update_drops(delta: float) -> void:
	var player_rect := Rect2(_player_position, _player_size)
	for index in range(_drops.size() - 1, -1, -1):
		var drop: Dictionary = _drops[index]
		var position := Vector2(drop.get("position", Vector2.ZERO))
		position.y += float(drop.get("speed", 300.0)) * delta
		drop["position"] = position
		_drops[index] = drop
		var drop_rect := Rect2(position.x - 6.0, position.y, 12.0, float(drop.get("length", 28.0)))
		if _invulnerability <= 0.0 and Rules.rects_overlap(player_rect, drop_rect):
			_handle_collision()
			_drops.remove_at(index)
		elif position.y > size.y + 40.0:
			_dodged += 1
			_drops.remove_at(index)


func _handle_collision() -> void:
	_invulnerability = 0.65
	if _shield_count > 0:
		_shield_count -= 1
		_shield_used += 1
		return
	_hits += 1


func _complete(successful: bool) -> void:
	_finished = true
	set_process(false)
	var final_text := "12초 생존 완료  |  빗방울 %d개 회피" % _dodged if successful else "빗길 차단  |  충돌 %d/%d" % [_hits, _max_hits]
	status_changed.emit(final_text, 1.0 if successful else clampf(_elapsed / _duration, 0.0, 1.0))
	queue_redraw()
	completed.emit(successful, {
		"game_type": "rain_dodge",
		"elapsed_time": minf(_elapsed, _duration),
		"hit_count": _hits,
		"dodged_count": _dodged,
		"shield_used": _shield_used,
		"input_summary": "%.1f초 생존 / 충돌 %d회 / 빗방울 %d개 회피" % [minf(_elapsed, _duration), _hits, _dodged]
	})


func _emit_status() -> void:
	if not _started:
		status_changed.emit("방향키를 눌러 시작\n%.0f초 동안 빗방울을 피하세요" % _duration, 0.0)
		return
	var remaining := maxf(0.0, _duration - _elapsed)
	var shield_text := " / 보호 1회" if _shield_count > 0 else ""
	status_changed.emit("남은 시간 %.1f초  |  충돌 %d/%d%s\n방향키로 우산을 이동하세요" % [remaining, _hits, _max_hits, shield_text], clampf(_elapsed / _duration, 0.0, 1.0))


func _get_playfield() -> Rect2:
	return Rect2(22.0, 24.0, maxf(100.0, size.x - 44.0), maxf(100.0, size.y - 48.0))


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.025, 0.04, 0.055), true)
	var bounds := _get_playfield()
	draw_rect(bounds, Color(0.08, 0.11, 0.14), true)
	draw_line(Vector2(bounds.position.x, bounds.end.y), Vector2(bounds.end.x, bounds.end.y), Color(0.42, 0.48, 0.52), 3.0)
	for line_index in range(6):
		var x := bounds.position.x + float(line_index) * bounds.size.x / 5.0
		draw_line(Vector2(x, bounds.position.y), Vector2(bounds.get_center().x, bounds.end.y), Color(0.18, 0.23, 0.27, 0.5), 1.0)

	for drop in _drops:
		var position := Vector2(drop.get("position", Vector2.ZERO))
		var length := float(drop.get("length", 28.0))
		draw_line(position, position + Vector2(-5.0, length), Color(0.4, 0.72, 0.9), 3.0)

	if _initialized:
		var umbrella_center := _player_position + Vector2(_player_size.x * 0.5, 14.0)
		var umbrella_color := Color(0.95, 0.25, 0.3) if _invulnerability <= 0.0 else Color(1.0, 0.72, 0.74)
		draw_arc(umbrella_center, _player_size.x * 0.45, PI, TAU, 32, umbrella_color, 11.0)
		draw_line(umbrella_center, umbrella_center + Vector2(0, 28), umbrella_color, 5.0)
		draw_arc(umbrella_center + Vector2(8, 28), 8.0, 0, PI, 12, umbrella_color, 4.0)

	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(34, 48), "ARROW KEYS", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(0.68, 0.78, 0.82))
