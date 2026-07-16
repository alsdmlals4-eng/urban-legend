class_name ResearchProjectCatalog
extends RefCounted

const DATA_PATH := "res://data/research_projects.json"

var _loaded := false
var _projects: Array = []


func get_projects() -> Array:
	_ensure_loaded()
	return _projects.duplicate(true)


func get_project(project_id: String) -> Dictionary:
	_ensure_loaded()
	var clean_id := project_id.strip_edges()
	for project_value in _projects:
		if typeof(project_value) == TYPE_DICTIONARY and String((project_value as Dictionary).get("id", "")) == clean_id:
			return (project_value as Dictionary).duplicate(true)
	return {}


func _ensure_loaded() -> void:
	if _loaded:
		return
	_loaded = true
	var file := FileAccess.open(DATA_PATH, FileAccess.READ)
	if file == null:
		push_error("Research project data cannot be opened: %s" % DATA_PATH)
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Research project data root must be a Dictionary")
		return
	for project_value in (parsed as Dictionary).get("projects", []):
		if typeof(project_value) != TYPE_DICTIONARY:
			continue
		var project: Dictionary = (project_value as Dictionary).duplicate(true)
		var output: Variant = project.get("output", {})
		if String(project.get("id", "")).is_empty() or int(project.get("research_cost", 0)) <= 0 or typeof(output) != TYPE_DICTIONARY:
			continue
		_projects.append(project)
