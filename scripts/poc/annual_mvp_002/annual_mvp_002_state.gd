class_name AnnualMvp002State
extends "res://scripts/poc/annual_mvp_001/annual_mvp_001_state_v2.gd"

const ExtensionData = preload("res://scripts/poc/annual_mvp_002/annual_mvp_002_data.gd")
const EXTENSION_PATH := "res://data/poc/annual_mvp_002/companion_equipment_research.json"

var _extension_config: Dictionary = {}
var _extension_enabled := false
var _extension_warning := ""
var _extension_companions: Dictionary = {}
var _extension_support_skills: Dictionary = {}
var _extension_equipment: Dictionary = {}
var _extension_modules: Dictionary = {}
var _extension_research_nodes: Dictionary = {}
var _extension_resource_defs: Dictionary = {}

var _companion_states: Dictionary = {}
var _selected_companion_ids: Array[String] = []
var _equipped_support_skills: Dictionary = {}
var _readiness_by_skill: Dictionary = {}
var _owned_equipment_ids: Array[String] = []
var _selected_equipment_id := ""
var _installed_module_ids: Array[String] = []
var _research_resources: Dictionary = {}
var _active_research: Dictionary = {}
var _completed_extension_research_ids: Array[String] = []
var _schedule_templates: Array = [[], [], []]
var _orphaned_ids: Array[String] = []
var _role_overlap_efficiency := 100
var _last_loadout: Dictionary = {}


func start(config: Dictionary, run_seed: int = 2001) -> Dictionary:
	var base_result: Dictionary = super.start(config, run_seed)
	if not bool(base_result.get("ok", false)):
		return base_result
	_reset_extension_runtime()
	_extension_config = ExtensionData.load_config(EXTENSION_PATH)
	var errors: Array[String] = ExtensionData.validate_config(_extension_config, config)
	if not errors.is_empty():
		_extension_enabled = false
		_extension_warning = "ANNUAL-MVP-002 확장을 비활성화했습니다: %s" % "; ".join(errors)
		return _response(true, "", true, [{
			"event": "annual_mvp_002_disabled",
			"warning": _extension_warning,
		}])
	_index_extension_config()
	_initialize_extension_defaults()
	_extension_enabled = true
	return _response(true, "", true, [{"event": "annual_mvp_002_started"}])


func get_snapshot() -> Dictionary:
	var snapshot: Dictionary = super.get_snapshot()
	snapshot["annual_mvp_002"] = _extension_snapshot()
	return snapshot


func configure_loadout_v2(
	companion_ids: Array[String],
	support_skill_by_companion: Dictionary,
	equipment_id: String,
	module_ids: Array[String]
) -> Dictionary:
	if not _extension_enabled:
		return _response(false, "ANNUAL-MVP-002 확장이 비활성화되어 있습니다.", false)
	if _phase not in ["WEEK_PLANNING", "PREPARATION"]:
		return _response(false, "현재 단계에서는 확장 편성을 변경할 수 없습니다.", false)
	if companion_ids.size() > int((_extension_config.get("rules", {}) as Dictionary).get("max_companions", 2)):
		return _response(false, "동료는 최대 2명까지 편성할 수 있습니다.", false)
	if _has_duplicates(companion_ids):
		return _response(false, "같은 동료를 중복 편성할 수 없습니다.", false)
	for companion_id in companion_ids:
		if not _extension_companions.has(companion_id):
			return _response(false, "알 수 없는 동료: %s" % companion_id, false)
		if String((_extension_companions[companion_id] as Dictionary).get("availability", "")) != "AVAILABLE":
			return _response(false, "현재 편성할 수 없는 동료입니다: %s" % companion_id, false)

	for owner_value in support_skill_by_companion.keys():
		var owner_id := String(owner_value)
		var skill_id := String(support_skill_by_companion[owner_value])
		if not companion_ids.has(owner_id):
			return _response(false, "선택하지 않은 동료의 지원 스킬을 장착할 수 없습니다.", false)
		var companion := _extension_companions[owner_id] as Dictionary
		if not (companion.get("public_skill_ids", []) as Array).has(skill_id):
			return _response(false, "동료가 사용할 수 없는 공용 지원 스킬입니다.", false)
		if not _extension_support_skills.has(skill_id):
			return _response(false, "알 수 없는 공용 지원 스킬입니다.", false)
		var support_skill := _extension_support_skills[skill_id] as Dictionary
		if String(support_skill.get("runtime_status", "")) != "ACTIVE":
			return _response(false, "이 지원은 후속 CORE hook이 필요해 현재 선택할 수 없습니다.", false)

	if equipment_id.is_empty() and not module_ids.is_empty():
		return _response(false, "주 장비 없이 모듈을 장착할 수 없습니다.", false)
	if not equipment_id.is_empty():
		if not _extension_equipment.has(equipment_id):
			return _response(false, "알 수 없는 주 장비입니다.", false)
		if not _owned_equipment_ids.has(equipment_id):
			return _response(false, "보유하지 않은 주 장비입니다.", false)
		if _has_duplicates(module_ids):
			return _response(false, "같은 모듈을 중복 장착할 수 없습니다.", false)
		var equipment := _extension_equipment[equipment_id] as Dictionary
		var module_slots := int(equipment.get("module_slots", 1))
		if _completed_extension_research_ids.has("annual002_research_safe_recheck"):
			module_slots = mini(2, module_slots + 1)
		if module_ids.size() > module_slots:
			return _response(false, "현재 장비의 모듈 슬롯을 초과했습니다.", false)
		var allowed_modules := equipment.get("allowed_module_ids", []) as Array
		for module_id in module_ids:
			if not _extension_modules.has(module_id) or not allowed_modules.has(module_id):
				return _response(false, "장비 계열과 맞지 않는 모듈입니다: %s" % module_id, false)

	_selected_companion_ids = companion_ids.duplicate()
	_equipped_support_skills = support_skill_by_companion.duplicate(true)
	_selected_equipment_id = equipment_id
	_installed_module_ids = module_ids.duplicate()
	_role_overlap_efficiency = _calculate_role_overlap_efficiency(_selected_companion_ids)
	_last_loadout = {
		"selected_companion_ids": _selected_companion_ids.duplicate(),
		"equipped_support_skills": _equipped_support_skills.duplicate(true),
		"selected_equipment_id": _selected_equipment_id,
		"installed_module_ids": _installed_module_ids.duplicate(),
		"role_overlap_efficiency": _role_overlap_efficiency,
	}
	return _response(true, "", true, [{
		"event": "annual_mvp_002_loadout_configured",
		"role_overlap_efficiency": _role_overlap_efficiency,
	}])


func save_schedule_template(slot: int, activity_ids: Array[String]) -> Dictionary:
	if slot < 1 or slot > 3:
		return _response(false, "일정 템플릿 슬롯은 1~3입니다.", false)
	var planned_days := 0
	for activity_id in activity_ids:
		if not _activities.has(activity_id):
			return _response(false, "알 수 없는 활동: %s" % activity_id, false)
		planned_days += int((_activities[activity_id] as Dictionary).get("day_cost", 0))
		if planned_days > int((_config.get("campaign", {}) as Dictionary).get("days_per_week", 7)):
			return _response(false, "템플릿 일정은 한 주 7일을 넘을 수 없습니다.", false)
	_schedule_templates[slot - 1] = activity_ids.duplicate()
	return _response(true, "", true, [{"event": "annual_mvp_002_template_saved", "slot": slot}])


func set_support_readiness(skill_id: String, value: int) -> Dictionary:
	if not _extension_support_skills.has(skill_id):
		return _response(false, "알 수 없는 공용 지원 스킬입니다.", false)
	_readiness_by_skill[skill_id] = clampi(value, 0, 100)
	return _response(true, "", true)


func apply_support_readiness_snapshot(values: Dictionary) -> Dictionary:
	for skill_value in values.keys():
		var skill_id := String(skill_value)
		if not _extension_support_skills.has(skill_id):
			return _response(false, "알 수 없는 공용 지원 스킬 준비도입니다: %s" % skill_id, false)
	for skill_value in values.keys():
		var skill_id := String(skill_value)
		_readiness_by_skill[skill_id] = clampi(int(values[skill_value]), 0, 100)
	return _response(true, "", true, [{"event": "annual_mvp_002_readiness_synced"}])


func begin_incident() -> Dictionary:
	if _phase != "PREPARATION":
		return _response(false, "사건을 시작할 준비가 되지 않았습니다.", false)
	_phase = "INCIDENT_ACTIVE"
	return _response(true, "", true, [{
		"event": "annual_incident_requested",
		"case_path": String((_config.get("campaign", {}) as Dictionary).get("incident_case_path", "")),
		"run_seed": _run_seed,
	}])


func apply_research_resource_reward(delta: Dictionary) -> Dictionary:
	for resource_value in delta.keys():
		var resource_id := String(resource_value)
		if not _extension_resource_defs.has(resource_id):
			return _response(false, "알 수 없는 연구 자원입니다: %s" % resource_id, false)
		if int(delta[resource_value]) < 0:
			return _response(false, "연구 자원 보상은 음수일 수 없습니다.", false)
	for resource_value in delta.keys():
		var resource_id := String(resource_value)
		_research_resources[resource_id] = int(_research_resources.get(resource_id, 0)) + int(delta[resource_value])
	return _response(true, "", true, [{"event": "annual_mvp_002_resources_awarded"}])


func start_research(node_id: String) -> Dictionary:
	if not _extension_research_nodes.has(node_id):
		return _response(false, "알 수 없는 연구 노드입니다.", false)
	if _completed_extension_research_ids.has(node_id):
		return _response(false, "이미 완료한 연구입니다.", false)
	if _active_research.has(node_id):
		return _response(false, "이미 진행 중인 연구입니다.", false)
	var max_active := int((_extension_config.get("rules", {}) as Dictionary).get("max_active_research", 2))
	if _active_research.size() >= max_active:
		return _response(false, "동시에 진행할 수 있는 연구는 최대 2개입니다.", false)
	var node := _extension_research_nodes[node_id] as Dictionary
	for prerequisite_value in node.get("prerequisite_ids", []) as Array:
		if not _completed_extension_research_ids.has(String(prerequisite_value)):
			return _response(false, "선행 연구가 완료되지 않았습니다.", false)
	var cost := node.get("resource_cost", {}) as Dictionary
	for resource_value in cost.keys():
		var resource_id := String(resource_value)
		if int(_research_resources.get(resource_id, 0)) < int(cost[resource_value]):
			return _response(false, "연구 자원이 부족합니다: %s" % resource_id, false)
	for resource_value in cost.keys():
		var resource_id := String(resource_value)
		_research_resources[resource_id] = int(_research_resources.get(resource_id, 0)) - int(cost[resource_value])
	_active_research[node_id] = {
		"progress": 0,
		"reserved_cost": cost.duplicate(true),
	}
	return _response(true, "", true, [{"event": "annual_mvp_002_research_started", "node_id": node_id}])


func advance_research(node_id: String, amount: int = 1) -> Dictionary:
	if amount <= 0:
		return _response(false, "연구 진척량은 양수여야 합니다.", false)
	if not _active_research.has(node_id):
		return _response(false, "진행 중인 연구가 아닙니다.", false)
	var project := (_active_research[node_id] as Dictionary).duplicate(true)
	project["progress"] = int(project.get("progress", 0)) + amount
	var node := _extension_research_nodes[node_id] as Dictionary
	var completed := int(project["progress"]) >= int(node.get("progress_required", 1))
	if completed:
		_active_research.erase(node_id)
		_append_unique_string(_completed_extension_research_ids, node_id)
	else:
		_active_research[node_id] = project
	return _response(true, "", true, [{
		"event": "annual_mvp_002_research_completed" if completed else "annual_mvp_002_research_advanced",
		"node_id": node_id,
	}])


func cancel_research(node_id: String) -> Dictionary:
	if not _active_research.has(node_id):
		return _response(false, "진행 중인 연구가 아닙니다.", false)
	var project := _active_research[node_id] as Dictionary
	var reserved := project.get("reserved_cost", {}) as Dictionary
	var refund_percent := int((_extension_config.get("rules", {}) as Dictionary).get("research_cancel_refund_percent", 75))
	for resource_value in reserved.keys():
		var resource_id := String(resource_value)
		var refund := int(floor(float(int(reserved[resource_value]) * refund_percent) / 100.0))
		_research_resources[resource_id] = int(_research_resources.get(resource_id, 0)) + refund
	_active_research.erase(node_id)
	return _response(true, "", true, [{"event": "annual_mvp_002_research_cancelled", "node_id": node_id}])


func build_save_payload() -> Dictionary:
	return super.build_save_payload()


func restore(config: Dictionary, payload: Dictionary) -> Dictionary:
	var restored: Dictionary = super.restore(config, payload)
	if not bool(restored.get("ok", false)):
		return restored
	var saved_state := payload.get("state", {}) as Dictionary
	var extension_value: Variant = saved_state.get("annual_mvp_002")
	if typeof(extension_value) != TYPE_DICTIONARY:
		return _response(true, "", true, [{"event": "annual_mvp_002_old_save_defaulted"}])
	_restore_extension(extension_value as Dictionary)
	return _response(true, "", true, [{"event": "annual_mvp_002_restored"}])


func _reset_extension_runtime() -> void:
	_extension_config.clear()
	_extension_enabled = false
	_extension_warning = ""
	_extension_companions.clear()
	_extension_support_skills.clear()
	_extension_equipment.clear()
	_extension_modules.clear()
	_extension_research_nodes.clear()
	_extension_resource_defs.clear()
	_companion_states.clear()
	_selected_companion_ids.clear()
	_equipped_support_skills.clear()
	_readiness_by_skill.clear()
	_owned_equipment_ids.clear()
	_selected_equipment_id = ""
	_installed_module_ids.clear()
	_research_resources.clear()
	_active_research.clear()
	_completed_extension_research_ids.clear()
	_schedule_templates = [[], [], []]
	_orphaned_ids.clear()
	_role_overlap_efficiency = 100
	_last_loadout.clear()


func _index_extension_config() -> void:
	_extension_companions = ExtensionData.index_by_id(_extension_config.get("companions", []) as Array)
	_extension_support_skills = ExtensionData.index_by_id(_extension_config.get("support_skills", []) as Array)
	_extension_equipment = ExtensionData.index_by_id(_extension_config.get("equipment", []) as Array)
	_extension_modules = ExtensionData.index_by_id(_extension_config.get("modules", []) as Array)
	_extension_research_nodes = ExtensionData.index_by_id(_extension_config.get("research_nodes", []) as Array)
	_extension_resource_defs = ExtensionData.index_by_id(_extension_config.get("research_resources", []) as Array)


func _initialize_extension_defaults() -> void:
	for companion_value in _extension_companions.values():
		var companion := companion_value as Dictionary
		var companion_id := String(companion.get("id", ""))
		_companion_states[companion_id] = {
			"work_trust": int(companion.get("work_trust", 0)),
			"personal_bond": int(companion.get("personal_bond", 0)),
			"availability": String(companion.get("availability", "UNAVAILABLE")),
		}
	for skill_id_value in _extension_support_skills.keys():
		_readiness_by_skill[String(skill_id_value)] = 0
	for equipment_id_value in _extension_equipment.keys():
		_owned_equipment_ids.append(String(equipment_id_value))
	_owned_equipment_ids.sort()
	for resource_id_value in _extension_resource_defs.keys():
		_research_resources[String(resource_id_value)] = 0


func _extension_snapshot() -> Dictionary:
	var templates_copy: Array = []
	for template in _schedule_templates:
		templates_copy.append(_string_array(template))
	return {
		"enabled": _extension_enabled,
		"warning": _extension_warning,
		"contract_version": String(_extension_config.get("contract_version", "")),
		"companion_states": _companion_states.duplicate(true),
		"selected_companion_ids": _selected_companion_ids.duplicate(),
		"equipped_support_skills": _equipped_support_skills.duplicate(true),
		"readiness_by_skill": _readiness_by_skill.duplicate(true),
		"owned_equipment_ids": _owned_equipment_ids.duplicate(),
		"selected_equipment_id": _selected_equipment_id,
		"installed_module_ids": _installed_module_ids.duplicate(),
		"research_resources": _research_resources.duplicate(true),
		"active_research": _active_research.duplicate(true),
		"completed_research_ids": _completed_extension_research_ids.duplicate(),
		"last_loadout": _last_loadout.duplicate(true),
		"schedule_templates": templates_copy,
		"orphaned_ids": _orphaned_ids.duplicate(),
		"role_overlap_efficiency": _role_overlap_efficiency,
	}


func _restore_extension(saved: Dictionary) -> void:
	var found_orphans: Array[String] = _string_array(saved.get("orphaned_ids", []))
	var selected: Array[String] = []
	for companion_id in _string_array(saved.get("selected_companion_ids", [])):
		if _extension_companions.has(companion_id) and String((_extension_companions[companion_id] as Dictionary).get("availability", "")) == "AVAILABLE":
			selected.append(companion_id)
		else:
			_append_unique_string(found_orphans, companion_id)
	_selected_companion_ids = selected.slice(0, 2)

	var saved_support := saved.get("equipped_support_skills", {}) as Dictionary
	var valid_support: Dictionary = {}
	for owner_value in saved_support.keys():
		var owner_id := String(owner_value)
		var skill_id := String(saved_support[owner_value])
		if _selected_companion_ids.has(owner_id) and _extension_support_skills.has(skill_id):
			var companion := _extension_companions[owner_id] as Dictionary
			var support_skill := _extension_support_skills[skill_id] as Dictionary
			if String(support_skill.get("runtime_status", "")) == "ACTIVE" and (companion.get("public_skill_ids", []) as Array).has(skill_id):
				valid_support[owner_id] = skill_id
				continue
		_append_unique_string(found_orphans, skill_id)
	_equipped_support_skills = valid_support

	var saved_readiness := saved.get("readiness_by_skill", {}) as Dictionary
	for skill_value in saved_readiness.keys():
		var skill_id := String(skill_value)
		if _extension_support_skills.has(skill_id):
			_readiness_by_skill[skill_id] = clampi(int(saved_readiness[skill_value]), 0, 100)
		else:
			_append_unique_string(found_orphans, skill_id)

	var owned: Array[String] = []
	for equipment_id in _string_array(saved.get("owned_equipment_ids", _owned_equipment_ids)):
		if _extension_equipment.has(equipment_id):
			_append_unique_string(owned, equipment_id)
		else:
			_append_unique_string(found_orphans, equipment_id)
	_owned_equipment_ids = owned

	var saved_completed_ids := _string_array(saved.get("completed_research_ids", []))
	var selected_equipment := String(saved.get("selected_equipment_id", ""))
	if selected_equipment.is_empty():
		_selected_equipment_id = ""
	elif _extension_equipment.has(selected_equipment) and _owned_equipment_ids.has(selected_equipment):
		_selected_equipment_id = selected_equipment
	else:
		_selected_equipment_id = ""
		_append_unique_string(found_orphans, selected_equipment)
	_installed_module_ids.clear()
	if not _selected_equipment_id.is_empty():
		var selected_item := _extension_equipment[_selected_equipment_id] as Dictionary
		var allowed_modules := selected_item.get("allowed_module_ids", []) as Array
		var module_slots := int(selected_item.get("module_slots", 1))
		if saved_completed_ids.has("annual002_research_safe_recheck"):
			module_slots = mini(2, module_slots + 1)
		for module_id in _string_array(saved.get("installed_module_ids", [])):
			if _installed_module_ids.size() >= module_slots:
				_append_unique_string(found_orphans, module_id)
				continue
			if _extension_modules.has(module_id) and allowed_modules.has(module_id) and not _installed_module_ids.has(module_id):
				_installed_module_ids.append(module_id)
			else:
				_append_unique_string(found_orphans, module_id)
	else:
		for module_id in _string_array(saved.get("installed_module_ids", [])):
			_append_unique_string(found_orphans, module_id)

	var saved_resources := saved.get("research_resources", {}) as Dictionary
	for resource_id_value in _research_resources.keys():
		var resource_id := String(resource_id_value)
		_research_resources[resource_id] = maxi(0, int(saved_resources.get(resource_id, 0)))

	_completed_extension_research_ids.clear()
	for node_id in saved_completed_ids:
		if _extension_research_nodes.has(node_id):
			_append_unique_string(_completed_extension_research_ids, node_id)
		else:
			_append_unique_string(found_orphans, node_id)

	_active_research.clear()
	var saved_active := saved.get("active_research", {}) as Dictionary
	var max_active := int((_extension_config.get("rules", {}) as Dictionary).get("max_active_research", 2))
	for node_value in saved_active.keys():
		var node_id := String(node_value)
		if _active_research.size() >= max_active:
			_append_unique_string(found_orphans, node_id)
			continue
		if not _extension_research_nodes.has(node_id) or typeof(saved_active[node_value]) != TYPE_DICTIONARY:
			_append_unique_string(found_orphans, node_id)
			continue
		if _completed_extension_research_ids.has(node_id):
			_append_unique_string(found_orphans, node_id)
			continue
		var node := _extension_research_nodes[node_id] as Dictionary
		var prerequisites_valid := true
		for prerequisite_value in node.get("prerequisite_ids", []) as Array:
			if not _completed_extension_research_ids.has(String(prerequisite_value)):
				prerequisites_valid = false
				break
		if not prerequisites_valid:
			_append_unique_string(found_orphans, node_id)
			continue
		var saved_project := saved_active[node_value] as Dictionary
		var required := maxi(1, int(node.get("progress_required", 1)))
		_active_research[node_id] = {
			"progress": clampi(int(saved_project.get("progress", 0)), 0, required - 1),
			"reserved_cost": (node.get("resource_cost", {}) as Dictionary).duplicate(true),
		}

	var templates_value: Variant = saved.get("schedule_templates")
	if typeof(templates_value) == TYPE_ARRAY and (templates_value as Array).size() == 3:
		var restored_templates: Array = []
		for template_value in templates_value as Array:
			var template := _string_array(template_value)
			var valid_template: Array[String] = []
			var used_days := 0
			for activity_id in template:
				if not _activities.has(activity_id):
					_append_unique_string(found_orphans, activity_id)
					continue
				used_days += int((_activities[activity_id] as Dictionary).get("day_cost", 0))
				if used_days <= int((_config.get("campaign", {}) as Dictionary).get("days_per_week", 7)):
					valid_template.append(activity_id)
			restored_templates.append(valid_template)
		_schedule_templates = restored_templates

	_role_overlap_efficiency = _calculate_role_overlap_efficiency(_selected_companion_ids)
	_last_loadout = {
		"selected_companion_ids": _selected_companion_ids.duplicate(),
		"equipped_support_skills": _equipped_support_skills.duplicate(true),
		"selected_equipment_id": _selected_equipment_id,
		"installed_module_ids": _installed_module_ids.duplicate(),
		"role_overlap_efficiency": _role_overlap_efficiency,
	}
	_orphaned_ids = found_orphans
	_orphaned_ids.sort()


func _calculate_role_overlap_efficiency(companion_ids: Array[String]) -> int:
	var categories: Dictionary = {}
	for companion_id in companion_ids:
		var role := String((_extension_companions.get(companion_id, {}) as Dictionary).get("role_primary", ""))
		var category := "field" if role in ["field_control", "containment"] else role
		if categories.has(category):
			return int((_extension_config.get("rules", {}) as Dictionary).get("duplicate_role_efficiency", 70))
		categories[category] = true
	return 100


func _has_duplicates(values: Array[String]) -> bool:
	var seen: Dictionary = {}
	for value in values:
		if seen.has(value):
			return true
		seen[value] = true
	return false


func _append_unique_string(target: Array[String], value: String) -> void:
	if not value.is_empty() and not target.has(value):
		target.append(value)
