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
		_enrich_scene_context(chain)
		_chains.append(chain)


func _enrich_scene_context(chain: Dictionary) -> void:
	var pair_key := String(chain.get("pair_key", ""))
	var participant_names: Array[String] = []
	for participant_id in pair_key.split("::", false):
		participant_names.append(_get_participant_name(String(participant_id)))
	var cast_text := "·".join(participant_names)
	var scenes: Array = chain.get("scenes", [])
	for scene_value in scenes:
		if typeof(scene_value) != TYPE_DICTIONARY:
			continue
		var scene: Dictionary = scene_value
		var title := String(scene.get("title", "관계 기록"))
		var location := String(scene.get("location", "기록실"))
		scene["agent_name"] = cast_text
		scene["case_title"] = location
		if String(scene.get("intro", "")).strip_edges().is_empty():
			scene["intro"] = "%s에서 %s에 관한 기록을 함께 확인한다. 이번 선택은 관계의 기억으로만 남으며 능력치나 보상은 바꾸지 않는다." % [location, title]


func _get_participant_name(participant_id: String) -> String:
	var names := {
		"agent_kwon_narae": "권나래",
		"agent_yoon_seoha": "윤서하",
		"agent_oh_hyun": "오현",
		"agent_kang_ijun": "강이준",
		"agent_han_yuri": "한유리",
		"faction_rumor_market_park_doyoon": "박도윤",
		"faction_mage_society_lee_serin": "이세린",
		"mercenary_raymond_kane": "레이먼드 케인",
		"exorcist_camila_vargas": "카밀라 바르가스"
	}
	return String(names.get(participant_id, participant_id))
