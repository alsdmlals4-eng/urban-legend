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


func get_expression_index(agent_id: String, expression_id: String) -> int:
	var resolved := get_expression(agent_id, expression_id)
	match resolved:
		"focus", "focused", "analytical", "alert", "concerned", "warning":
			return 1
		"serious", "firm", "stern", "irritated", "skeptical", "disapproval":
			return 2
		_:
			return 0


func get_cutins() -> Array:
	_ensure_loaded()
	return (_data.get("cutins", []) as Array).duplicate(true)


func get_relationship_cutin(scene_id: String) -> String:
	_ensure_loaded()
	var mappings: Dictionary = _data.get("relationship_cutins", {})
	return String(mappings.get(scene_id, "")).strip_edges()


func get_cutin_label(cutin_id: String) -> String:
	for value in get_cutins():
		if typeof(value) == TYPE_DICTIONARY and String((value as Dictionary).get("id", "")) == cutin_id:
			return String((value as Dictionary).get("label", cutin_id))
	return cutin_id


func _ensure_loaded() -> void:
	if _loaded:
		return
	_loaded = true
	var file := FileAccess.open(DATA_PATH, FileAccess.READ)
	if file == null:
		push_error("Presentation registry cannot be opened: %s" % DATA_PATH)
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) == TYPE_DICTIONARY:
		_data = (parsed as Dictionary).duplicate(true)
