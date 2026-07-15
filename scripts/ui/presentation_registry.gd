class_name PresentationRegistry
extends RefCounted

const DATA_PATH := "res://data/presentation_registry.json"

var _loaded := false
var _data: Dictionary = {}


func get_expression(agent_id: String, expression_id: String) -> String:
	_ensure_loaded()
	var expressions: Dictionary = _data.get("expressions", {})
	var agent_expressions: Dictionary = expressions.get(agent_id, {})
	var requested := String(agent_expressions.get(expression_id, ""))
	if not requested.is_empty():
		return requested
	var normal := String(agent_expressions.get("normal", ""))
	return normal if not normal.is_empty() else "normal"


func get_cutins() -> Array:
	_ensure_loaded()
	return (_data.get("cutins", []) as Array).duplicate(true)


func _ensure_loaded() -> void:
	if _loaded:
		return
	_loaded = true
	var file := FileAccess.open(DATA_PATH, FileAccess.READ)
	if file == null:
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) == TYPE_DICTIONARY:
		_data = (parsed as Dictionary).duplicate(true)
