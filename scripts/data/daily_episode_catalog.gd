class_name DailyEpisodeCatalog
extends RefCounted

const DATA_PATH := "res://data/daily_episodes.json"
const NARRATIVE_DATA_PATH := "res://data/narrative_events.json"

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
	var seen_ids := {}
	_load_entries(DATA_PATH, "episodes", seen_ids)
	_load_entries(NARRATIVE_DATA_PATH, "events", seen_ids)


func _load_entries(path: String, key: String, seen_ids: Dictionary) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Optional narrative data cannot be opened: %s" % path)
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Optional narrative data root must be a Dictionary: %s" % path)
		return
	var entries: Variant = (parsed as Dictionary).get(key, [])
	if typeof(entries) != TYPE_ARRAY:
		push_error("Optional narrative data must contain a %s Array: %s" % [key, path])
		return
	for entry in entries:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var episode: Dictionary = entry.duplicate(true)
		var episode_id := String(episode.get("id", "")).strip_edges()
		if episode_id.is_empty() or seen_ids.has(episode_id):
			continue
		if (episode.get("choices", []) as Array).size() < 2:
			continue
		if String(episode.get("category", "")).is_empty():
			episode["category"] = "daily"
		seen_ids[episode_id] = true
		_episodes.append(episode)
