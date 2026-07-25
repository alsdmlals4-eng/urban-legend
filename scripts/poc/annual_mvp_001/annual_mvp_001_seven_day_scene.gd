extends "res://scripts/poc/annual_mvp_001/annual_mvp_001_themed_scene.gd"


func _ready() -> void:
	super()
	if _week_result_label != null:
		_week_result_label.name = "WeekResultLabel"
	_apply_seven_day_result_copy()


func debug_confirm() -> void:
	_on_confirm_pressed()
	_apply_seven_day_result_copy()


func _on_confirm_pressed() -> void:
	super()
	_apply_seven_day_result_copy()


func _render() -> void:
	super()
	_apply_seven_day_result_copy()


func _apply_command(result: Dictionary) -> void:
	super(result)
	_apply_seven_day_result_copy()


func _apply_seven_day_result_copy() -> void:
	if _week_result_label != null:
		_week_result_label.text = _week_result_text(_state.get_snapshot())
