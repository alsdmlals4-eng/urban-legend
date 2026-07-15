# 사건 JSON의 기존 요원과 프로젝트 공용 신규 요원을 병합한다.
extends RefCounted

const CATALOG_PATH := "res://data/agents.json"

var _supplemental_agents: Array = []


func _init() -> void:
	_supplemental_agents = _load_supplemental_agents()


func merge_agents(legacy_agents: Array) -> Array:
	var result: Array = []
	var seen: Dictionary = {}
	for value in legacy_agents + _supplemental_agents:
		if typeof(value) != TYPE_DICTIONARY:
			continue
		var agent: Dictionary = value
		var agent_id := String(agent.get("id", ""))
		if agent_id.is_empty() or seen.has(agent_id):
			continue
		seen[agent_id] = true
		result.append(agent.duplicate(true))
	return result


func get_agent(legacy_agents: Array, agent_id: String) -> Dictionary:
	for agent in merge_agents(legacy_agents):
		if String(agent.get("id", "")) == agent_id:
			return agent.duplicate(true)
	return {}


func _load_supplemental_agents() -> Array:
	if not FileAccess.file_exists(CATALOG_PATH):
		return []
	var file := FileAccess.open(CATALOG_PATH, FileAccess.READ)
	if file == null:
		return []
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY or typeof(parsed.get("agents", [])) != TYPE_ARRAY:
		return []
	return parsed.get("agents", []).duplicate(true)
