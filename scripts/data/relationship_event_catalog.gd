class_name RelationshipEventCatalog
extends RefCounted

const DATA_PATH := "res://data/relationship_events.json"

# The approved registry defines relationship tags as final-scene memory outcomes.
# Earlier saves only contain the selected memory text, so these rules deliberately
# derive display-only tags at read time instead of adding a score or save field.
const FINAL_MEMORY_TAGS := {
	"REL-P01": {"공동절차": ["신뢰", "경쟁"], "현장약속": ["신뢰", "보호"]},
	"REL-P02": {"세상태_승인": ["신뢰", "인정"], "논쟁중": ["경쟁", "신뢰"]},
	"REL-P03": {"공동철수규칙": ["보호", "신뢰"], "철수거부권": ["신뢰", "부채"]},
	"REL-P04": {"공동기준점": ["공감", "신뢰"], "열린약속": ["공감", "경계"]},
	"REL-A01": {"결손보존": ["인정", "신뢰"], "후속질문": ["경쟁", "인정"]},
	"REL-A02": {"표식회수": ["보호", "인정"], "안내전달": ["보호", "부채"]},
	"REL-A03": {"변동범위_공개": ["인정", "신뢰"], "감응기록_제한": ["신뢰", "경계"]},
	"REL-A04": {"금속기준점": ["신뢰", "보호"], "은실기준점": ["보호", "공감"]},
	"REL-F01": {"공동감시": ["신뢰", "경계"], "상호감사": ["경계", "인정"]},
	"REL-F02": {"반환기한": ["인정", "경계"], "최종관측": ["신뢰", "경계"]},
	"REL-F03": {"전설없는구조": ["신뢰", "인정"], "비공개공적": ["부채", "신뢰"]},
	"REL-F04": {"기록후정화": ["인정", "경쟁"], "사진기록": ["경계", "인정"]}
}

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
	var matched_chain: Dictionary = {}
	for chain_value in _chains:
		if typeof(chain_value) != TYPE_DICTIONARY:
			continue
		var chain: Dictionary = chain_value
		if String(chain.get("pair_key", "")) == pair_key:
			matched_chain = chain
			rules = chain.get("tag_rules", []) as Array
			break
	if rules.is_empty():
		return _get_final_memory_tags(matched_chain, memories)
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


func _get_final_memory_tags(chain: Dictionary, memories: Array) -> Array:
	if chain.is_empty():
		return []
	var tag_map: Dictionary = FINAL_MEMORY_TAGS.get(String(chain.get("id", "")), {})
	for memory_value in memories:
		var tags: Array = tag_map.get(String(memory_value), []) as Array
		if not tags.is_empty():
			return tags.duplicate()
	return []


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
