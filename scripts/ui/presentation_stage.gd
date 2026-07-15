class_name PresentationStage
extends RefCounted

var _speaker := ""
var _text := ""
var _expression := "normal"
var _active_cutin := ""


func present_line(line: Dictionary) -> void:
	_speaker = _display_speaker(String(line.get("speaker", line.get("name", ""))))
	_text = String(line.get("text", ""))
	_expression = String(line.get("expression", "normal"))


func present_cutin(cutin_id: String) -> void:
	_active_cutin = cutin_id.strip_edges()


func clear_cutin() -> void:
	_active_cutin = ""


func get_display_speaker() -> String:
	return _speaker


func get_display_text() -> String:
	return _text


func get_expression_id() -> String:
	return _expression


func get_active_cutin() -> String:
	return _active_cutin


func _display_speaker(source: String) -> String:
	return "기록관 아카 · 괴이 기록국 관제 AI" if source == "로그" else source
