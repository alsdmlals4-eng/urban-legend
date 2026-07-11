# 저승역의 축소 원 리듬 판정과 키 입력을 관리한다.
extends Control

signal completed(successful: bool, details: Dictionary)
signal status_changed(text: String, progress: float)

const Rules = preload("res://scripts/minigames/minigame_rules.gd")

var _round_count := 5
var _required_hits := 3
var _beat_duration := 1.4
var _start_radius := 180.0
var _target_radius := 64.0
var _minimum_radius := 28.0
var _tolerance := 10.0
var _round_index := 0
var _hits := 0
var _misses := 0
var _beat_elapsed := 0.0
var _current_radius := 180.0
var _cooldown := 0.0
var _feedback := "첫 파형을 기다리는 중"
var _feedback_color := Color(0.72, 0.82, 0.86)
var _finished := false


func configure(config: Dictionary, equipment_assisted: bool) -> void:
	_round_count = max(1, int(config.get("round_count", 5)))
	_required_hits = clampi(int(config.get("required_hits", 3)), 1, _round_count)
	_beat_duration = maxf(0.5, float(config.get("beat_duration", 1.4)))
	_start_radius = maxf(100.0, float(config.get("start_radius", 180.0)))
	_target_radius = maxf(30.0, float(config.get("target_radius", 64.0)))
	_minimum_radius = minf(_target_radius - 8.0, float(config.get("minimum_radius", 28.0)))
	_tolerance = maxf(4.0, float(config.get("hit_tolerance", 10.0)))
	if equipment_assisted:
		_tolerance *= 1.6
	_current_radius = _start_radius
	custom_minimum_size = Vector2(600, 430)
	focus_mode = Control.FOCUS_ALL
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_process(true)
	set_process_unhandled_key_input(true)
	call_deferred("grab_focus")
	_emit_status()


func _process(delta: float) -> void:
	if _finished:
		return
	if _cooldown > 0.0:
		_cooldown -= delta
		if _cooldown <= 0.0:
			_begin_next_round()
		queue_redraw()
		return

	_beat_elapsed += delta
	var ratio := clampf(_beat_elapsed / _beat_duration, 0.0, 1.0)
	_current_radius = lerpf(_start_radius, _minimum_radius, ratio)
	if _beat_elapsed >= _beat_duration:
		_finish_round(false, "파형을 놓쳤습니다")
	queue_redraw()


func _unhandled_key_input(event: InputEvent) -> void:
	if _finished or _cooldown > 0.0 or not event is InputEventKey:
		return
	var key_event := event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return
	if key_event.keycode != KEY_SPACE and key_event.keycode != KEY_ENTER and key_event.keycode != KEY_KP_ENTER:
		return

	var hit := Rules.is_rhythm_hit(_current_radius, _target_radius, _tolerance)
	_finish_round(hit, "동기화 성공" if hit else "타이밍이 어긋났습니다")
	get_viewport().set_input_as_handled()


func _finish_round(hit: bool, message: String) -> void:
	if hit:
		_hits += 1
		_feedback_color = Color(0.35, 0.9, 0.72)
	else:
		_misses += 1
		_feedback_color = Color(0.95, 0.42, 0.42)
	_round_index += 1
	_feedback = message
	_cooldown = 0.48
	_emit_status()
	if _round_index >= _round_count:
		_cooldown = 0.0
		_complete()


func _begin_next_round() -> void:
	_beat_elapsed = 0.0
	_current_radius = _start_radius
	_feedback = "다음 파형 접근 중"
	_feedback_color = Color(0.72, 0.82, 0.86)
	_emit_status()


func _complete() -> void:
	_finished = true
	set_process(false)
	var successful := _hits >= _required_hits
	_feedback = "주파수 고정 완료" if successful else "잡음 동기화 실패"
	_feedback_color = Color(0.35, 0.9, 0.72) if successful else Color(0.95, 0.42, 0.42)
	_emit_status()
	queue_redraw()
	completed.emit(successful, {
		"game_type": "rhythm_timing",
		"hit_count": _hits,
		"miss_count": _misses,
		"accuracy": float(_hits) / float(_round_count),
		"input_summary": "%d박자 중 %d회 동기화" % [_round_count, _hits]
	})


func _emit_status() -> void:
	var progress := float(_round_index) / float(_round_count)
	status_changed.emit("박자 %d/%d  |  성공 %d  |  실패 %d\n%s" % [min(_round_index + 1, _round_count), _round_count, _hits, _misses, _feedback], progress)


func _draw() -> void:
	var play_rect := Rect2(Vector2.ZERO, size)
	draw_rect(play_rect, Color(0.025, 0.04, 0.055), true)
	for index in range(7):
		var y := 54.0 + float(index) * 52.0
		draw_line(Vector2(28, y), Vector2(size.x - 28, y), Color(0.12, 0.2, 0.23, 0.5), 1.0)

	var center := Vector2(size.x * 0.5, size.y * 0.53)
	draw_circle(center, _target_radius + _tolerance, Color(0.12, 0.55, 0.52, 0.12))
	draw_arc(center, _target_radius + _tolerance, 0, TAU, 96, Color(0.26, 0.78, 0.7, 0.5), 2.0)
	draw_arc(center, maxf(1.0, _target_radius - _tolerance), 0, TAU, 96, Color(0.26, 0.78, 0.7, 0.5), 2.0)
	draw_circle(center, 8.0, Color(0.78, 0.93, 0.9))
	draw_arc(center, maxf(1.0, _current_radius), 0, TAU, 128, Color(0.85, 0.9, 0.94), 5.0)

	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(24, 34), "SPACE / ENTER", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(0.68, 0.78, 0.82))
	draw_string(font, Vector2(24, size.y - 24), _feedback, HORIZONTAL_ALIGNMENT_LEFT, -1, 20, _feedback_color)

