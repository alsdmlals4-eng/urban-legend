extends "res://scripts/poc/annual_mvp_001/annual_mvp_001_themed_scene.gd"


func _render() -> void:
	super()
	_apply_seven_day_result_copy()


func _apply_command(result: Dictionary) -> void:
	super(result)
	# The inherited command handler may invoke its own base renderer directly.
	# Re-apply the active result copy after the entire command chain completes.
	_apply_seven_day_result_copy()


func _apply_seven_day_result_copy() -> void:
	if _week_result_label != null:
		_week_result_label.text = _week_result_text(_state.get_snapshot())
