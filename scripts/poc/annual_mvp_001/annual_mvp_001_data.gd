class_name AnnualMvp001Data
extends RefCounted

const CONTRACT_VERSION := "annual-mvp-001-v3"
const REQUIRED_COUNTS := {
	"activities": 7,
	"companions": 1,
	"support_skills": 3,
	"base_equipment": 1,
	"modules": 1,
	"research_projects": 2
}
const ALLOWED_EFFECT_KEYS := ["health_restore", "risk_reduction"]
const DAYS_PER_WEEK := 7
const AUTO_REST_RECOVERY_PER_DAY := 5


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


static func validate_config(data: Dictionary) -> Array[String]:
	var errors: Array[String] = []
	if String(data.get("contract_version", "")) != CONTRACT_VERSION:
		errors.append("contract_version must be %s" % CONTRACT_VERSION)

	var campaign_value: Variant = data.get("campaign")
	if typeof(campaign_value) != TYPE_DICTIONARY:
		errors.append("campaign must be a dictionary")
		return errors
	var campaign := campaign_value as Dictionary
	if int(campaign.get("max_weeks", 0)) != 4:
		errors.append("campaign max_weeks must be 4")
	if int(campaign.get("days_per_week", 0)) != DAYS_PER_WEEK:
		errors.append("campaign days_per_week must be %d" % DAYS_PER_WEEK)
	if campaign.has("slots_per_week"):
		errors.append("campaign slots_per_week is obsolete")
	if int(campaign.get("auto_rest_fatigue_recovery_per_day", 0)) != AUTO_REST_RECOVERY_PER_DAY:
		errors.append("campaign auto_rest_fatigue_recovery_per_day must be %d" % AUTO_REST_RECOVERY_PER_DAY)
	if int(campaign.get("voluntary_entry_week", 0)) != 2:
		errors.append("campaign voluntary_entry_week must be 2")
	if int(campaign.get("deadline_week", 0)) != 4:
		errors.append("campaign deadline_week must be 4")
	if int(campaign.get("max_weeks", 0)) * int(campaign.get("days_per_week", 0)) != 28:
		errors.append("campaign must contain 28 monthly days")
	var incident_path := String(campaign.get("incident_case_path", ""))
	if incident_path.is_empty() or not FileAccess.file_exists(incident_path):
		errors.append("campaign incident_case_path must exist")

	var all_ids: Dictionary = {}
	for group in REQUIRED_COUNTS:
		var entries_value: Variant = data.get(group)
		if typeof(entries_value) != TYPE_ARRAY:
			errors.append("%s must be an array" % group)
			continue
		var entries := entries_value as Array
		if entries.size() != int(REQUIRED_COUNTS[group]):
			errors.append("%s must contain %d entries" % [group, int(REQUIRED_COUNTS[group])])
		for value in entries:
			if typeof(value) != TYPE_DICTIONARY:
				errors.append("%s entries must be dictionaries" % group)
				continue
			var entry := value as Dictionary
			var entry_id := String(entry.get("id", ""))
			if entry_id.is_empty() or not entry_id.begins_with("annual001_"):
				errors.append("%s has invalid id %s" % [group, entry_id])
			elif all_ids.has(entry_id):
				errors.append("duplicate id %s" % entry_id)
			else:
				all_ids[entry_id] = group

	if not errors.is_empty():
		return errors

	var skills := index_by_id(data.get("support_skills", []) as Array)
	var modules := index_by_id(data.get("modules", []) as Array)
	for value in data.get("companions", []) as Array:
		var companion := value as Dictionary
		var unique_skill_id := String(companion.get("unique_skill_id", ""))
		if not skills.has(unique_skill_id):
			errors.append("companion references missing unique skill %s" % unique_skill_id)
		for skill_id in companion.get("allowed_public_skill_ids", []) as Array:
			if not skills.has(String(skill_id)):
				errors.append("companion references missing public skill %s" % skill_id)

	for value in data.get("research_projects", []) as Array:
		var project := value as Dictionary
		for module_id in project.get("unlock_module_ids", []) as Array:
			if not modules.has(String(module_id)):
				errors.append("research references missing module %s" % module_id)
		for skill_id in project.get("unlock_skill_ids", []) as Array:
			if not skills.has(String(skill_id)):
				errors.append("research references missing skill %s" % skill_id)

	var allowed_competencies := ["observation", "analysis", "field_response", "interpersonal"]
	for value in data.get("activities", []) as Array:
		var activity := value as Dictionary
		var activity_id := String(activity.get("id", ""))
		var day_cost := int(activity.get("day_cost", 0))
		if day_cost < 1 or day_cost > 3:
			errors.append("activity %s day_cost must be 1..3" % activity_id)
		var deltas_value: Variant = activity.get("deltas")
		if typeof(deltas_value) != TYPE_DICTIONARY:
			errors.append("activity %s requires deltas" % activity_id)
			continue
		var deltas := deltas_value as Dictionary
		for competency_id in (deltas.get("competencies", {}) as Dictionary).keys():
			if not allowed_competencies.has(String(competency_id)):
				errors.append("activity has invalid competency %s" % competency_id)
			if abs(int((deltas.get("competencies", {}) as Dictionary)[competency_id])) > 5:
				errors.append("activity competency delta out of range")
		if abs(int(deltas.get("fatigue", 0))) > 100:
			errors.append("activity fatigue delta out of range")
		if abs(int(deltas.get("institution_support", 0))) > 3:
			errors.append("activity institution support delta out of range")
		if activity_id == "annual001_activity_rest":
			if day_cost != 1:
				errors.append("direct rest day_cost must be 1")
			if String(activity.get("rest_mode", "")) != "direct":
				errors.append("direct rest must use rest_mode direct")
			if not bool(activity.get("status_recovery_eligible", false)):
				errors.append("direct rest must be status recovery eligible")
			if int(deltas.get("fatigue", 0)) != -25:
				errors.append("direct rest fatigue delta must remain -25")

	for value in data.get("support_skills", []) as Array:
		var skill := value as Dictionary
		var chance := int(skill.get("base_chance", -1))
		if chance < 0 or chance > 100:
			errors.append("skill chance must be 0..100")
		if int(skill.get("readiness_gain", 0)) <= 0:
			errors.append("skill readiness_gain must be positive")
		var readiness_max := int(skill.get("readiness_max", 0))
		if readiness_max < 1 or readiness_max > 100:
			errors.append("skill readiness_max must be 1..100")
		var effect_value: Variant = skill.get("effect")
		if typeof(effect_value) != TYPE_DICTIONARY:
			errors.append("skill effect must be a dictionary")
			continue
		for effect_key in (effect_value as Dictionary).keys():
			if not ALLOWED_EFFECT_KEYS.has(String(effect_key)):
				errors.append("skill effect key %s is not allowed" % effect_key)
			if int((effect_value as Dictionary)[effect_key]) < 0:
				errors.append("skill effect values must be non-negative")

	return errors


static func index_by_id(entries: Array) -> Dictionary:
	var index: Dictionary = {}
	for value in entries:
		if typeof(value) != TYPE_DICTIONARY:
			continue
		var entry := value as Dictionary
		var entry_id := String(entry.get("id", ""))
		if not entry_id.is_empty():
			index[entry_id] = entry.duplicate(true)
	return index
