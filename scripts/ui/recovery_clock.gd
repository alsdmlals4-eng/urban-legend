class_name RecoveryClock
extends Control

@export_range(1, 12) var total_segments := 6:
	set(value):
		total_segments = maxi(1, value)
		filled_segments = clampi(filled_segments, 0, total_segments)
		queue_redraw()

@export var active_color := Color("c7aa65")
@export var inactive_color := Color(0.26, 0.22, 0.19, 0.9)
@export var urgent_color := Color("d15c4d")

var filled_segments := 0
var _urgent := false


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	custom_minimum_size = Vector2(42, 42)
	queue_redraw()


func set_clock(value: int, segment_count: int = total_segments, urgent: bool = false) -> void:
	total_segments = maxi(1, segment_count)
	filled_segments = clampi(value, 0, total_segments)
	_urgent = urgent
	queue_redraw()


func play_feedback(kind: String) -> void:
	var flash_color := active_color
	if kind == "danger" or kind == "surge":
		flash_color = urgent_color
	elif kind == "relief":
		flash_color = Color("75c9b1")
	modulate = flash_color
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.28)


func _draw() -> void:
	var center := size * 0.5
	var outer_radius := maxf(4.0, minf(size.x, size.y) * 0.47)
	var inner_radius := outer_radius * 0.57
	var span := TAU / float(total_segments)
	var gap := minf(0.10, span * 0.20)
	for index in range(total_segments):
		var start_angle := -PI * 0.5 + span * float(index) + gap * 0.5
		var end_angle := -PI * 0.5 + span * float(index + 1) - gap * 0.5
		var color := active_color if index < filled_segments else inactive_color
		if _urgent and index < filled_segments:
			color = urgent_color
		var points := PackedVector2Array([
			center + Vector2(cos(start_angle), sin(start_angle)) * inner_radius,
			center + Vector2(cos(start_angle), sin(start_angle)) * outer_radius,
			center + Vector2(cos(end_angle), sin(end_angle)) * outer_radius,
			center + Vector2(cos(end_angle), sin(end_angle)) * inner_radius
		])
		draw_colored_polygon(points, color)
	draw_circle(center, inner_radius * 0.68, Color(0.06, 0.07, 0.08, 0.94))
	draw_arc(center, outer_radius, 0.0, TAU, 32, urgent_color if _urgent else Color(0.72, 0.65, 0.48, 0.65), 1.0, true)
