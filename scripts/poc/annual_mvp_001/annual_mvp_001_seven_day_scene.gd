extends "res://scripts/poc/annual_mvp_001/annual_mvp_001_themed_scene.gd"


func _render() -> void:
	super()
	# The legacy base renderer owns the shared labels. Re-apply the active
	# seven-day result copy after all inherited render layers complete.
	if _week_result_label != null:
		_week_result_label.text = _week_result_text(_state.get_snapshot())
