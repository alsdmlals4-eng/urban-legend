class_name AnnualMvp002Data
extends RefCounted

const CONTRACT_VERSION := "annual-mvp-002-v1"
const BASE_CONTRACT_VERSION := "annual-mvp-001-v3"
const REQUIRED_COUNTS := {
	"companions": 3,
	"unique_skills": 3,
	"support_skills": 6,
	"equipment": 3,
	"modules": 6,
	"research_resources": 4,
	"research_nodes": 8,
}
const FORBIDDEN_EFFECT_KEYS := [
	"clue_id",
	"hypothesis_id",
	"pattern_id",
	"capture_condition",
	"answer",
	"auto_solution",
	"new_core_clue",
	"answer_hypothesis",
	"unobserved_pattern",
]
const EQUIPMENT_FAMILIES := ["observation", "protection", "containment"]
const SUPPORT_RUNTIME_STATUSES := ["ACTIVE", "DISABLED_PENDING_CORE_HOOK"]
const ACTIVE_SUPPORT_EFFECT_KEYS := ["damage_reduction", "risk_reduction"]


static func load_config(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return {}
	return (parsed as Dictionary).duplicate(true)


static func validate_config(data: Dictionary, base_config: Dictionary) -> Array[String]:
	var errors: Array[String] = []
	if String(data.get("contract_version", "")) != CONTRACT_VERSION:
		errors.append("contract_version must be %s" % CONTRACT_VERSION)
	if String(data.get("base_contract_version", "")) != BASE_CONTRACT_VERSION:
		errors.append("base_contract_version must be %s" % BASE_CONTRACT_VERSION)
	if String(base_config.get("contract_version", "")) != BASE_CONTRACT_VERSION:
		errors.append("base config must remain %s" % BASE_CONTRACT_VERSION)

	var all_ids: Dictionary = {}
	for group_name in REQUIRED_COUNTS.keys():
		var entries_value: Variant = data.get(group_name)
		if typeof(entries_value) != TYPE_ARRAY:
			errors.append("%s must be an array" % group_name)
			continue
		var entries := entries_value as Array
		if entries.size() != int(REQUIRED_COUNTS[group_name]):
			errors.append("%s must contain %d entries" % [group_name, int(REQUIRED_COUNTS[group_name])])
		for value in entries:
			if typeof(value) != TYPE_DICTIONARY:
				errors.append("%s entries must be dictionaries" % group_name)
				continue
			var entry := value as Dictionary
			var entry_id := String(entry.get("id", ""))
			if entry_id.is_empty() or not entry_id.begins_with("annual002_"):
				errors.append("%s has invalid id %s" % [group_name, entry_id])
			elif all_ids.has(entry_id):
				errors.append("duplicate id %s" % entry_id)
			else:
				all_ids[entry_id] = String(group_name)

	if not errors.is_empty():
		return errors

	var companions := index_by_id(data.get("companions", []) as Array)
	var unique_skills := index_by_id(data.get("unique_skills", []) as Array)
	var support_skills := index_by_id(data.get("support_skills", []) as Array)
	var equipment := index_by_id(data.get("equipment", []) as Array)
	var modules := index_by_id(data.get("modules", []) as Array)
	var resources := index_by_id(data.get("research_resources", []) as Array)
	var research_nodes := index_by_id(data.get("research_nodes", []) as Array)
	var base_activities := index_by_id(base_config.get("activities", []) as Array)

	var unique_owners: Dictionary = {}
	for value in data.get("unique_skills", []) as Array:
		var skill := value as Dictionary
		var owner_id := String(skill.get("owner_companion_id", ""))
		if not companions.has(owner_id):
			errors.append("unique skill references missing companion %s" % owner_id)
		elif unique_owners.has(owner_id):
			errors.append("companion %s owns multiple unique skills" % owner_id)
		else:
			unique_owners[owner_id] = String(skill.get("id", ""))
		if int(skill.get("incident_limit", 0)) != 1:
			errors.append("unique skill incident_limit must be 1")
		_validate_effect(skill, errors, "unique skill %s" % String(skill.get("id", "")))

	for value in data.get("companions", []) as Array:
		var companion := value as Dictionary
		var companion_id := String(companion.get("id", ""))
		var unique_skill_id := String(companion.get("unique_skill_id", ""))
		if not unique_skills.has(unique_skill_id):
			errors.append("companion %s references missing unique skill %s" % [companion_id, unique_skill_id])
		elif String((unique_skills[unique_skill_id] as Dictionary).get("owner_companion_id", "")) != companion_id:
			errors.append("companion %s unique skill owner mismatch" % companion_id)
		var public_ids := companion.get("public_skill_ids", []) as Array
		if public_ids.size() > 2:
			errors.append("companion %s may reference at most two public skills" % companion_id)
		for public_skill_id in public_ids:
			if not support_skills.has(String(public_skill_id)):
				errors.append("companion %s references missing support skill %s" % [companion_id, public_skill_id])
		var trust := int(companion.get("work_trust", -1))
		var bond := int(companion.get("personal_bond", -1))
		if trust < 0 or trust > 100:
			errors.append("companion %s work_trust must be 0..100" % companion_id)
		if bond < 0 or bond > 100:
			errors.append("companion %s personal_bond must be 0..100" % companion_id)
		if String(companion.get("availability", "")) not in ["AVAILABLE", "UNAVAILABLE"]:
			errors.append("companion %s availability is invalid" % companion_id)

	var active_support_count := 0
	for value in data.get("support_skills", []) as Array:
		var skill := value as Dictionary
		var skill_id := String(skill.get("id", ""))
		var chance := int(skill.get("base_chance", -1))
		if chance < 0 or chance > 90:
			errors.append("support skill %s base_chance must be 0..90" % skill_id)
		if int(skill.get("readiness_gain", 0)) != 20:
			errors.append("support skill %s readiness_gain must be 20" % skill_id)
		if int(skill.get("readiness_guarantee", 0)) != 100:
			errors.append("support skill %s readiness_guarantee must be 100" % skill_id)
		if String(skill.get("trigger", "")).is_empty() or String(skill.get("trigger_label", "")).is_empty():
			errors.append("support skill %s requires trigger and trigger_label" % skill_id)
		var runtime_status := String(skill.get("runtime_status", ""))
		if not SUPPORT_RUNTIME_STATUSES.has(runtime_status):
			errors.append("support skill %s runtime_status is invalid" % skill_id)
		var preparation_ids := skill.get("preparation_activity_ids", []) as Array
		if runtime_status == "ACTIVE":
			active_support_count += 1
			if preparation_ids.is_empty():
				errors.append("active support skill %s requires preparation_activity_ids" % skill_id)
			for activity_id_value in preparation_ids:
				if not base_activities.has(String(activity_id_value)):
					errors.append("support skill %s references missing preparation activity %s" % [skill_id, activity_id_value])
			for effect_key_value in (skill.get("effect", {}) as Dictionary).keys():
				if not ACTIVE_SUPPORT_EFFECT_KEYS.has(String(effect_key_value)):
					errors.append("active support skill %s uses unsupported runtime effect %s" % [skill_id, effect_key_value])
		elif not preparation_ids.is_empty():
			errors.append("disabled support skill %s must not claim preparation activities" % skill_id)
		_validate_effect(skill, errors, "support skill %s" % skill_id)
	if active_support_count != 2:
		errors.append("exactly two support skills must be ACTIVE for the current CORE hook")

	var observed_families: Dictionary = {}
	for value in data.get("equipment", []) as Array:
		var item := value as Dictionary
		var equipment_id := String(item.get("id", ""))
		var family := String(item.get("family", ""))
		if not EQUIPMENT_FAMILIES.has(family):
			errors.append("equipment %s has invalid family %s" % [equipment_id, family])
		elif observed_families.has(family):
			errors.append("equipment family %s is duplicated" % family)
		else:
			observed_families[family] = equipment_id
		var slots := int(item.get("module_slots", 0))
		if slots < 1 or slots > 2:
			errors.append("equipment %s module_slots must be 1..2" % equipment_id)
		var allowed_modules := item.get("allowed_module_ids", []) as Array
		if allowed_modules.size() != 2:
			errors.append("equipment %s must allow exactly two PoC modules" % equipment_id)
		for module_id_value in allowed_modules:
			var module_id := String(module_id_value)
			if not modules.has(module_id):
				errors.append("equipment %s references missing module %s" % [equipment_id, module_id])
			elif String((modules[module_id] as Dictionary).get("family", "")) != family:
				errors.append("equipment %s module %s family mismatch" % [equipment_id, module_id])
		_validate_effect(item, errors, "equipment %s" % equipment_id)

	for value in data.get("modules", []) as Array:
		var module := value as Dictionary
		var module_id := String(module.get("id", ""))
		var family := String(module.get("family", ""))
		if not EQUIPMENT_FAMILIES.has(family):
			errors.append("module %s has invalid family %s" % [module_id, family])
		var compatible_count := 0
		for equipment_value in data.get("equipment", []) as Array:
			var item := equipment_value as Dictionary
			if (item.get("allowed_module_ids", []) as Array).has(module_id):
				compatible_count += 1
		if compatible_count != 1:
			errors.append("module %s must belong to exactly one equipment entry" % module_id)
		_validate_effect(module, errors, "module %s" % module_id)

	for value in data.get("research_nodes", []) as Array:
		var node := value as Dictionary
		var node_id := String(node.get("id", ""))
		if int(node.get("progress_required", 0)) < 1:
			errors.append("research node %s progress_required must be positive" % node_id)
		var cost_value: Variant = node.get("resource_cost")
		if typeof(cost_value) != TYPE_DICTIONARY:
			errors.append("research node %s resource_cost must be a dictionary" % node_id)
		else:
			for resource_id_value in (cost_value as Dictionary).keys():
				var resource_id := String(resource_id_value)
				if not resources.has(resource_id):
					errors.append("research node %s references missing resource %s" % [node_id, resource_id])
				if int((cost_value as Dictionary)[resource_id_value]) < 0:
					errors.append("research node %s cost must be non-negative" % node_id)
		for prerequisite_id_value in node.get("prerequisite_ids", []) as Array:
			if not research_nodes.has(String(prerequisite_id_value)):
				errors.append("research node %s references missing prerequisite %s" % [node_id, prerequisite_id_value])
		_validate_effect(node, errors, "research node %s" % node_id)

	_validate_research_acyclic(research_nodes, errors)
	_scan_forbidden_keys(data, "root", errors)
	return errors


static func index_by_id(entries: Array) -> Dictionary:
	var result: Dictionary = {}
	for value in entries:
		if typeof(value) != TYPE_DICTIONARY:
			continue
		var entry := value as Dictionary
		var entry_id := String(entry.get("id", ""))
		if not entry_id.is_empty():
			result[entry_id] = entry.duplicate(true)
	return result


static func _validate_effect(entry: Dictionary, errors: Array[String], label: String) -> void:
	if typeof(entry.get("effect")) != TYPE_DICTIONARY:
		errors.append("%s effect must be a dictionary" % label)
	if String(entry.get("effect_category", "")).is_empty() and label.begins_with("support skill"):
		errors.append("%s requires effect_category" % label)


static func _validate_research_acyclic(nodes: Dictionary, errors: Array[String]) -> void:
	var states: Dictionary = {}
	for node_id_value in nodes.keys():
		_visit_research_node(String(node_id_value), nodes, states, errors)


static func _visit_research_node(node_id: String, nodes: Dictionary, states: Dictionary, errors: Array[String]) -> void:
	var state := int(states.get(node_id, 0))
	if state == 2:
		return
	if state == 1:
		errors.append("research prerequisite cycle detected at %s" % node_id)
		return
	states[node_id] = 1
	var node := nodes.get(node_id, {}) as Dictionary
	for prerequisite_id_value in node.get("prerequisite_ids", []) as Array:
		var prerequisite_id := String(prerequisite_id_value)
		if nodes.has(prerequisite_id):
			_visit_research_node(prerequisite_id, nodes, states, errors)
	states[node_id] = 2


static func _scan_forbidden_keys(value: Variant, path: String, errors: Array[String]) -> void:
	if typeof(value) == TYPE_DICTIONARY:
		var dictionary := value as Dictionary
		for key_value in dictionary.keys():
			var key := String(key_value)
			if FORBIDDEN_EFFECT_KEYS.has(key):
				errors.append("forbidden CORE answer key %s at %s" % [key, path])
			_scan_forbidden_keys(dictionary[key_value], "%s.%s" % [path, key], errors)
	elif typeof(value) == TYPE_ARRAY:
		var values := value as Array
		for index in range(values.size()):
			_scan_forbidden_keys(values[index], "%s[%d]" % [path, index], errors)
