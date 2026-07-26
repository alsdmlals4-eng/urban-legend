class_name AnnualMvp002IncidentAdapter
extends "res://scripts/poc/annual_mvp_001/annual_mvp_001_incident_adapter.gd"

const ExtensionData = preload("res://scripts/poc/annual_mvp_002/annual_mvp_002_data.gd")
const ExtensionResolver = preload("res://scripts/poc/annual_mvp_002/annual_mvp_002_support_resolver.gd")
const EXTENSION_PATH := "res://data/poc/annual_mvp_002/companion_equipment_research.json"
const FAIRNESS_NOTICE := "동료·장비·연구는 피해·위험·허용 오차만 보조하며 신규 핵심 단서, 정답 가설, 미관측 패턴, 필수 회수 조건을 제공하지 않습니다."

var _extension_config: Dictionary = {}
var _extension_companions: Dictionary = {}
var _extension_unique_skills: Dictionary = {}
var _extension_support_skills: Dictionary = {}
var _extension_equipment: Dictionary = {}
var _extension_modules: Dictionary = {}
var _extension_snapshot: Dictionary = {}
var _extension_resolver := ExtensionResolver.new()
var _extension_support_log: Array[Dictionary] = []
var _fallback_active := true
var _fallback_warning := ""
var _role_overlap_efficiency := 100
var _selected_companion_ids: Array[String] = []
var _adapter_seed := 2001


func configure(config: Dictionary, annual_snapshot: Dictionary, run_seed: int) -> Dictionary:
	_adapter_seed = run_seed
	_extension_support_log.clear()
	_fallback_active = true
	_fallback_warning = ""
	_extension_snapshot = (annual_snapshot.get("annual_mvp_002", {}) as Dictionary).duplicate(true)

	# Keep the inherited ANNUAL-MVP-001 adapter operational as a fallback without
	# mutating the caller snapshot or the base save contract.
	var base_snapshot := annual_snapshot.duplicate(true)
	base_snapshot["selected_companion_id"] = "annual001_companion_oh_hyun"
	base_snapshot["selected_public_skill_id"] = ""
	base_snapshot["equipped_module_ids"] = (annual_snapshot.get("equipped_module_ids", []) as Array).duplicate()
	var base_trust := (base_snapshot.get("companion_trust", {}) as Dictionary).duplicate(true)
	if not base_trust.has("annual001_companion_oh_hyun"):
		base_trust["annual001_companion_oh_hyun"] = 0
	base_snapshot["companion_trust"] = base_trust
	var base_result: Dictionary = super.configure(config, base_snapshot, run_seed)
	if not bool(base_result.get("ok", false)):
		return base_result

	if _extension_snapshot.is_empty() or not bool(_extension_snapshot.get("enabled", false)):
		_fallback_warning = "ANNUAL-MVP-002 편성 정보가 없어 기본 ANNUAL-MVP-001 사건 동작을 사용합니다."
		return {"ok": true, "fallback_active": true, "warning": _fallback_warning}

	_extension_config = ExtensionData.load_config(EXTENSION_PATH)
	var errors: Array[String] = ExtensionData.validate_config(_extension_config, config)
	if not errors.is_empty():
		_fallback_warning = "ANNUAL-MVP-002 데이터를 해석할 수 없어 기본 사건 동작을 사용합니다: %s" % "; ".join(errors)
		return {"ok": true, "fallback_active": true, "warning": _fallback_warning}

	_extension_companions = ExtensionData.index_by_id(_extension_config.get("companions", []) as Array)
	_extension_unique_skills = ExtensionData.index_by_id(_extension_config.get("unique_skills", []) as Array)
	_extension_support_skills = ExtensionData.index_by_id(_extension_config.get("support_skills", []) as Array)
	_extension_equipment = ExtensionData.index_by_id(_extension_config.get("equipment", []) as Array)
	_extension_modules = ExtensionData.index_by_id(_extension_config.get("modules", []) as Array)
	_selected_companion_ids = _string_array(_extension_snapshot.get("selected_companion_ids", []))
	_role_overlap_efficiency = clampi(int(_extension_snapshot.get("role_overlap_efficiency", 100)), 1, 100)

	var equipped_entries: Array[Dictionary] = []
	var companion_states := _extension_snapshot.get("companion_states", {}) as Dictionary
	var selected_support := _extension_snapshot.get("equipped_support_skills", {}) as Dictionary
	for companion_id in _selected_companion_ids:
		if not _extension_companions.has(companion_id):
			continue
		var companion := _extension_companions[companion_id] as Dictionary
		var unique_id := String(companion.get("unique_skill_id", ""))
		if _extension_unique_skills.has(unique_id):
			var unique_entry := (_extension_unique_skills[unique_id] as Dictionary).duplicate(true)
			unique_entry["skill_kind"] = "unique"
			equipped_entries.append(unique_entry)
		var public_id := String(selected_support.get(companion_id, ""))
		if not public_id.is_empty() and _extension_support_skills.has(public_id):
			var public_entry := (_extension_support_skills[public_id] as Dictionary).duplicate(true)
			public_entry["skill_kind"] = "support"
			public_entry["owner_companion_id"] = companion_id
			equipped_entries.append(public_entry)

	if equipped_entries.is_empty():
		_fallback_warning = "ANNUAL-MVP-002 지원 편성이 비어 있어 기본 사건 동작을 사용합니다."
		return {"ok": true, "fallback_active": true, "warning": _fallback_warning}

	var preparation_tags: Array[String] = []
	for public_value in selected_support.values():
		_append_unique(preparation_tags, String(public_value))
	for research_id in _string_array(_extension_snapshot.get("completed_research_ids", [])):
		_append_unique(preparation_tags, research_id)
	var readiness := _extension_snapshot.get("readiness_by_skill", {}) as Dictionary
	var resolver_result: Dictionary = _extension_resolver.start(
		equipped_entries,
		companion_states,
		preparation_tags,
		readiness,
		run_seed
	)
	if not bool(resolver_result.get("ok", false)):
		_fallback_warning = "ANNUAL-MVP-002 지원 판정기를 시작하지 못해 기본 사건 동작을 사용합니다."
		return {"ok": true, "fallback_active": true, "warning": _fallback_warning}
	_fallback_active = false
	return {"ok": true, "fallback_active": false, "warning": ""}


func is_fallback_active() -> bool:
	return _fallback_active


func get_fallback_warning() -> String:
	return _fallback_warning


func get_fairness_notice() -> String:
	return FAIRNESS_NOTICE


func build_case_override(base_case: Dictionary) -> Dictionary:
	var result: Dictionary = super.build_case_override(base_case)
	if _fallback_active:
		return result
	var equipment_id := String(_extension_snapshot.get("selected_equipment_id", ""))
	var module_ids := _string_array(_extension_snapshot.get("installed_module_ids", []))
	var static_damage_reduction := 0
	if equipment_id == "annual002_equipment_field_coat":
		static_damage_reduction += 8
	if module_ids.has("annual002_module_impact_gel"):
		static_damage_reduction += 5
	if static_damage_reduction > 0:
		for field_value in result.get("field_tests", []) as Array:
			var field_test := field_value as Dictionary
			field_test["damage"] = maxi(0, int(field_test.get("damage", 0)) - static_damage_reduction)
		for pattern_value in result.get("recovery_patterns", []) as Array:
			var pattern := pattern_value as Dictionary
			if pattern.has("damage_on_failure"):
				pattern["damage_on_failure"] = maxi(0, int(pattern.get("damage_on_failure", 0)) - static_damage_reduction)
	if equipment_id == "annual002_equipment_seal_case":
		var capture_rule := result.get("capture_rule", {}) as Dictionary
		capture_rule["annual_capture_window_tolerance_percent"] = 8
		result["capture_rule"] = capture_rule
	if module_ids.has("annual002_module_repeat_buffer"):
		result["annual_observation_input_time_percent"] = 12
	if module_ids.has("annual002_module_stable_rune"):
		result["annual_capture_stability_tolerance"] = 5
	result["annual_mvp_002_modifiers"] = {
		"selected_equipment_id": equipment_id,
		"installed_module_ids": module_ids,
		"static_damage_reduction": static_damage_reduction,
		"role_overlap_efficiency": _role_overlap_efficiency,
		"fairness_notice": FAIRNESS_NOTICE,
	}
	return result


func after_omen(state: Object, snapshot_before: Dictionary, omen_result: Dictionary) -> Array[Dictionary]:
	if _fallback_active:
		return super.after_omen(state, snapshot_before, omen_result)
	var event_key := "annual002:omen:%d:%s" % [
		int(snapshot_before.get("turn", 0)),
		String(snapshot_before.get("current_pattern_id", "")),
	]
	return _resolve_and_apply_extension(state, event_key, {
		"after_clue_recorded": bool(omen_result.get("success", false)),
		"observed_pattern_reappears": bool(omen_result.get("success", false)),
		"clue_count": int(snapshot_before.get("clue_count", 0)),
	}, snapshot_before)


func after_recovery_action(
	state: Object,
	snapshot_before: Dictionary,
	action_id: String,
	action_result: Dictionary
) -> Array[Dictionary]:
	if _fallback_active:
		return super.after_recovery_action(state, snapshot_before, action_id, action_result)
	var event_key := "annual002:action:%d:%s:%s" % [
		int(snapshot_before.get("turn", 0)),
		String(snapshot_before.get("current_pattern_id", "")),
		action_id,
	]
	var pattern_id := String(snapshot_before.get("current_pattern_id", ""))
	var observed := snapshot_before.get("observed_pattern_ids", []) as Array
	return _resolve_and_apply_extension(state, event_key, {
		"damage": int(action_result.get("damage", 0)),
		"first_damage_before": int(action_result.get("damage", 0)) > 0,
		"risk_increase_before": int(action_result.get("risk_delta", 0)) > 0,
		"observed_pattern_reappears": observed.has(pattern_id),
		"civilian_or_containment_failure_before": bool(action_result.get("containment_failure", false)),
	}, snapshot_before)


func after_capture_window(
	state: Object,
	snapshot_before: Dictionary,
	capture_result: Dictionary
) -> Array[Dictionary]:
	if _fallback_active:
		return []
	var event_key := "annual002:capture:%d:%s" % [
		int(snapshot_before.get("turn", 0)),
		String(snapshot_before.get("current_pattern_id", "")),
	]
	return _resolve_and_apply_extension(state, event_key, {
		"capture_window_open": bool(capture_result.get("capture_window_open", false)),
	}, snapshot_before)


func get_status_lines() -> Array[String]:
	if _fallback_active:
		var base_lines: Array[String] = super.get_status_lines()
		if not _fallback_warning.is_empty():
			base_lines.append("기본 동작 | %s" % _fallback_warning)
		return base_lines
	var lines: Array[String] = []
	for item in _extension_resolver.preview({}):
		var status := "적격" if bool(item.get("eligible", false)) else "비적격: %s" % String(item.get("ineligible_reason", ""))
		var guarantee_text := "다음 적격 시 보장" if bool(item.get("guaranteed_next", false)) else "보장까지 %d" % int(item.get("guarantee_distance", 0))
		lines.append("%s · %s | %s | 확률 %d%% | 준비도 %d/100 | %s | 효과 %s" % [
			_companion_name(String(item.get("owner_companion_id", ""))),
			String(item.get("display_name", item.get("skill_id", ""))),
			status,
			int(item.get("chance", 0)),
			int(item.get("readiness", 0)),
			guarantee_text,
			String(item.get("effect_category", "")),
		])
	return lines


func get_support_log() -> Array[Dictionary]:
	if _fallback_active:
		return super.get_support_log()
	return _extension_support_log.duplicate(true)


func get_readiness_snapshot() -> Dictionary:
	if _fallback_active:
		return {}
	return (_extension_resolver.get_snapshot().get("readiness_by_skill", {}) as Dictionary).duplicate(true)


func build_research_reward(result: Dictionary, manual_delta: Dictionary) -> Dictionary:
	var quality := String(result.get("recovery_quality", "pending"))
	var manual_status := String(manual_delta.get("status", "candidate"))
	var resources := {
		"annual002_resource_records": 1,
		"annual002_resource_residue": 0,
		"annual002_resource_risk_cases": 0,
		"annual002_resource_institution": 0,
	}
	match quality:
		"normal_capture":
			resources["annual002_resource_records"] = 2
			resources["annual002_resource_residue"] = 2
			resources["annual002_resource_institution"] = 1
		"costly_capture":
			resources["annual002_resource_records"] = 2
			resources["annual002_resource_residue"] = 1
			resources["annual002_resource_risk_cases"] = 1
		"emergency_capture":
			resources["annual002_resource_records"] = 1
			resources["annual002_resource_residue"] = 1
			resources["annual002_resource_risk_cases"] = 2
	if manual_status == "verified":
		resources["annual002_resource_institution"] = int(resources["annual002_resource_institution"]) + 1
	resources["annual002_resource_risk_cases"] = int(resources["annual002_resource_risk_cases"]) + (manual_delta.get("danger_cases", []) as Array).size()
	return {
		"recovery_quality": quality,
		"knowledge_quality": manual_status,
		"resource_delta": resources,
	}


func _resolve_and_apply_extension(
	state: Object,
	event_key: String,
	context: Dictionary,
	snapshot_before: Dictionary
) -> Array[Dictionary]:
	var decisions: Array[Dictionary] = _extension_resolver.resolve(event_key, context)
	for index in range(decisions.size()):
		var decision := decisions[index]
		if not bool(decision.get("triggered", false)):
			continue
		var scaled_effect := _scaled_effect(
			String(decision.get("owner_companion_id", "")),
			decision.get("effect", {}) as Dictionary
		)
		decision["effect"] = scaled_effect
		decisions[index] = decision
		var skill_id := String(decision.get("skill_id", ""))
		if _was_logged(event_key, skill_id):
			continue
		var core_effect := _to_core_effect(scaled_effect)
		var applied := true
		if not core_effect.is_empty() and state.has_method("apply_external_support"):
			var response: Dictionary = state.call("apply_external_support", skill_id, event_key, core_effect)
			applied = bool(response.get("ok", false)) and bool(response.get("state_changed", false))
		if not applied:
			continue
		_extension_support_log.append({
			"skill_id": skill_id,
			"skill_name": String(decision.get("display_name", skill_id)),
			"owner_companion_id": String(decision.get("owner_companion_id", "")),
			"event_key": event_key,
			"turn": int(snapshot_before.get("turn", 0)),
			"chance": int(decision.get("chance", 0)),
			"roll": int(decision.get("roll", 0)),
			"readiness_before": int(decision.get("readiness_before", 0)),
			"readiness_after": int(decision.get("readiness_after", 0)),
			"guaranteed": bool(decision.get("guaranteed", false)),
			"effect": scaled_effect.duplicate(true),
		})
	return decisions


func _scaled_effect(owner_id: String, effect: Dictionary) -> Dictionary:
	var scale_percent := 100
	if _role_overlap_efficiency < 100 and _selected_companion_ids.size() >= 2 and owner_id == _selected_companion_ids[1]:
		scale_percent = _role_overlap_efficiency
	var result: Dictionary = {}
	for key_value in effect.keys():
		var value: Variant = effect[key_value]
		if typeof(value) == TYPE_INT or typeof(value) == TYPE_FLOAT:
			result[key_value] = int(round(float(value) * float(scale_percent) / 100.0))
		else:
			result[key_value] = value
	return result


func _to_core_effect(effect: Dictionary) -> Dictionary:
	var health_restore := int(effect.get("health_restore", 0))
	health_restore += int(effect.get("damage_reduction", 0))
	health_restore += int(effect.get("civilian_damage_reduction", 0))
	var risk_reduction := int(effect.get("risk_reduction", 0))
	var result: Dictionary = {}
	if health_restore > 0:
		result["health_restore"] = health_restore
	if risk_reduction > 0:
		result["risk_reduction"] = risk_reduction
	return result


func _was_logged(event_key: String, skill_id: String) -> bool:
	for entry in _extension_support_log:
		if String(entry.get("event_key", "")) == event_key and String(entry.get("skill_id", "")) == skill_id:
			return true
	return false


func _companion_name(companion_id: String) -> String:
	return String((_extension_companions.get(companion_id, {}) as Dictionary).get("display_name", companion_id))


func _string_array(value: Variant) -> Array[String]:
	var result: Array[String] = []
	if typeof(value) != TYPE_ARRAY:
		return result
	for item in value as Array:
		result.append(String(item))
	return result


func _append_unique(target: Array[String], value: String) -> void:
	if not value.is_empty() and not target.has(value):
		target.append(value)
