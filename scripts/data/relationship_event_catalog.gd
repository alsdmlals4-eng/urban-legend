class_name RelationshipEventCatalog
extends RefCounted

const DATA_PATH := "res://data/relationship_events.json"

var _loaded := false
var _chains: Array = []


func get_chains() -> Array:
	_ensure_loaded()
	return _chains.duplicate(true)


func get_scene(scene_id: String) -> Dictionary:
	_ensure_loaded()
	for chain_value in _chains:
		if typeof(chain_value) != TYPE_DICTIONARY:
			continue
		var chain: Dictionary = chain_value
		for scene_value in chain.get("scenes", []):
			if typeof(scene_value) == TYPE_DICTIONARY and String((scene_value as Dictionary).get("id", "")) == scene_id:
				var scene: Dictionary = (scene_value as Dictionary).duplicate(true)
				scene["chain_id"] = String(chain.get("id", ""))
				scene["chain_title"] = String(chain.get("title", ""))
				return scene
	return {}


func get_tags_for(pair_key: String, memories: Array) -> Array:
	_ensure_loaded()
	var rules: Array = []
	for chain_value in _chains:
		if typeof(chain_value) != TYPE_DICTIONARY:
			continue
		var chain: Dictionary = chain_value
		if String(chain.get("pair_key", "")) == pair_key:
			rules = chain.get("tag_rules", []) as Array
			break
	var tags: Array = []
	for rule_value in rules:
		if typeof(rule_value) != TYPE_DICTIONARY:
			continue
		var rule: Dictionary = rule_value
		var required: Array = rule.get("memories_all", []) as Array
		var matched := true
		for memory in required:
			if not memories.has(String(memory)):
				matched = false
				break
		if not matched:
			continue
		for tag in rule.get("tags", []) as Array:
			var clean_tag := String(tag).strip_edges()
			if not clean_tag.is_empty() and not tags.has(clean_tag):
				tags.append(clean_tag)
				if tags.size() >= 2:
					return tags
	return tags


func _ensure_loaded() -> void:
	if _loaded:
		return
	_loaded = true
	var file := FileAccess.open(DATA_PATH, FileAccess.READ)
	if file == null:
		push_error("Relationship event data cannot be opened: %s" % DATA_PATH)
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Relationship event data root must be a Dictionary")
		return
	for chain_value in (parsed as Dictionary).get("chains", []):
		if typeof(chain_value) != TYPE_DICTIONARY:
			continue
		var chain: Dictionary = (chain_value as Dictionary).duplicate(true)
		if String(chain.get("id", "")).is_empty() or (chain.get("scenes", []) as Array).is_empty():
			continue
		_chains.append(chain)
