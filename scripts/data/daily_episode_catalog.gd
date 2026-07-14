class_name DailyEpisodeCatalog
extends RefCounted

const DATA_PATH := "res://data/daily_episodes.json"

var _loaded := false
var _episodes: Array = []


func get_all() -> Array:
	_ensure_loaded()
	return _episodes.duplicate(true)


func get_by_id(episode_id: String) -> Dictionary:
	_ensure_loaded()
	for value in _episodes:
		if typeof(value) == TYPE_DICTIONARY and String(value.get("id", "")) == episode_id:
			return value.duplicate(true)
	return {}


func _ensure_loaded() -> void:
	if _loaded:
		return
	_loaded = true
	var file := FileAccess.open(DATA_PATH, FileAccess.READ)
	if file == null:
		push_error("Daily episode data cannot be opened: %s" % DATA_PATH)
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Daily episode data root must be a Dictionary: %s" % DATA_PATH)
		return
	var entries: Variant = (parsed as Dictionary).get("episodes", [])
	if typeof(entries) != TYPE_ARRAY:
		push_error("Daily episode data must contain an episodes Array: %s" % DATA_PATH)
		return
	for entry in entries:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var episode: Dictionary = entry.duplicate(true)
		if String(episode.get("id", "")).is_empty() or String(episode.get("case_id", "")).is_empty():
			continue
		if (episode.get("choices", []) as Array).size() < 2:
			continue
		_episodes.append(episode)
