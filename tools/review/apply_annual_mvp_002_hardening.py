from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]


def read(path: str) -> str:
    return (ROOT / path).read_text(encoding="utf-8")


def write(path: str, content: str) -> None:
    target = ROOT / path
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(content, encoding="utf-8")


def replace_once(path: str, old: str, new: str) -> None:
    content = read(path)
    count = content.count(old)
    if count != 1:
        raise RuntimeError(f"{path}: expected one match, found {count}: {old[:80]!r}")
    write(path, content.replace(old, new, 1))


def replace_all(path: str, old: str, new: str, minimum: int = 1) -> None:
    content = read(path)
    count = content.count(old)
    if count < minimum:
        raise RuntimeError(f"{path}: expected at least {minimum} matches, found {count}: {old!r}")
    write(path, content.replace(old, new))


def patch_data() -> None:
    path = "data/poc/annual_mvp_002/companion_equipment_research.json"
    data = json.loads(read(path))
    active = {
        "annual002_support_damage_buffer": ["annual001_activity_field_training"],
        "annual002_support_risk_dampening": ["annual001_activity_signal_research"],
    }
    for skill in data["support_skills"]:
        skill_id = skill["id"]
        if skill_id in active:
            skill["runtime_status"] = "ACTIVE"
            skill["preparation_activity_ids"] = active[skill_id]
        else:
            skill["runtime_status"] = "DISABLED_PENDING_CORE_HOOK"
            skill["preparation_activity_ids"] = []
    write(path, json.dumps(data, ensure_ascii=False, indent=2) + "\n")


def patch_validator() -> None:
    path = "scripts/poc/annual_mvp_002/annual_mvp_002_data.gd"
    replace_once(
        path,
        'const EQUIPMENT_FAMILIES := ["observation", "protection", "containment"]\n',
        'const EQUIPMENT_FAMILIES := ["observation", "protection", "containment"]\n'
        'const SUPPORT_RUNTIME_STATUSES := ["ACTIVE", "DISABLED_PENDING_CORE_HOOK"]\n'
        'const ACTIVE_SUPPORT_EFFECT_KEYS := ["damage_reduction", "risk_reduction"]\n',
    )
    replace_once(
        path,
        '\tvar research_nodes := index_by_id(data.get("research_nodes", []) as Array)\n',
        '\tvar research_nodes := index_by_id(data.get("research_nodes", []) as Array)\n'
        '\tvar base_activities := index_by_id(base_config.get("activities", []) as Array)\n',
    )
    old = '''\tfor value in data.get("support_skills", []) as Array:\n\t\tvar skill := value as Dictionary\n\t\tvar skill_id := String(skill.get("id", ""))\n\t\tvar chance := int(skill.get("base_chance", -1))\n\t\tif chance < 0 or chance > 90:\n\t\t\terrors.append("support skill %s base_chance must be 0..90" % skill_id)\n\t\tif int(skill.get("readiness_gain", 0)) != 20:\n\t\t\terrors.append("support skill %s readiness_gain must be 20" % skill_id)\n\t\tif int(skill.get("readiness_guarantee", 0)) != 100:\n\t\t\terrors.append("support skill %s readiness_guarantee must be 100" % skill_id)\n\t\tif String(skill.get("trigger", "")).is_empty() or String(skill.get("trigger_label", "")).is_empty():\n\t\t\terrors.append("support skill %s requires trigger and trigger_label" % skill_id)\n\t\t_validate_effect(skill, errors, "support skill %s" % skill_id)\n'''
    new = '''\tvar active_support_count := 0\n\tfor value in data.get("support_skills", []) as Array:\n\t\tvar skill := value as Dictionary\n\t\tvar skill_id := String(skill.get("id", ""))\n\t\tvar chance := int(skill.get("base_chance", -1))\n\t\tif chance < 0 or chance > 90:\n\t\t\terrors.append("support skill %s base_chance must be 0..90" % skill_id)\n\t\tif int(skill.get("readiness_gain", 0)) != 20:\n\t\t\terrors.append("support skill %s readiness_gain must be 20" % skill_id)\n\t\tif int(skill.get("readiness_guarantee", 0)) != 100:\n\t\t\terrors.append("support skill %s readiness_guarantee must be 100" % skill_id)\n\t\tif String(skill.get("trigger", "")).is_empty() or String(skill.get("trigger_label", "")).is_empty():\n\t\t\terrors.append("support skill %s requires trigger and trigger_label" % skill_id)\n\t\tvar runtime_status := String(skill.get("runtime_status", ""))\n\t\tif not SUPPORT_RUNTIME_STATUSES.has(runtime_status):\n\t\t\terrors.append("support skill %s runtime_status is invalid" % skill_id)\n\t\tvar preparation_ids := skill.get("preparation_activity_ids", []) as Array\n\t\tif runtime_status == "ACTIVE":\n\t\t\tactive_support_count += 1\n\t\t\tif preparation_ids.is_empty():\n\t\t\t\terrors.append("active support skill %s requires preparation_activity_ids" % skill_id)\n\t\t\tfor activity_id_value in preparation_ids:\n\t\t\t\tif not base_activities.has(String(activity_id_value)):\n\t\t\t\t\terrors.append("support skill %s references missing preparation activity %s" % [skill_id, activity_id_value])\n\t\t\tfor effect_key_value in (skill.get("effect", {}) as Dictionary).keys():\n\t\t\t\tif not ACTIVE_SUPPORT_EFFECT_KEYS.has(String(effect_key_value)):\n\t\t\t\t\terrors.append("active support skill %s uses unsupported runtime effect %s" % [skill_id, effect_key_value])\n\t\telif not preparation_ids.is_empty():\n\t\t\terrors.append("disabled support skill %s must not claim preparation activities" % skill_id)\n\t\t_validate_effect(skill, errors, "support skill %s" % skill_id)\n\tif active_support_count != 2:\n\t\terrors.append("exactly two support skills must be ACTIVE for the current CORE hook")\n'''
    replace_once(path, old, new)


def patch_resolver() -> None:
    path = "scripts/poc/annual_mvp_002/annual_mvp_002_support_resolver.gd"
    old = '''\tvar skill_id := String(skill.get("id", ""))\n\tvar effect_category := String(skill.get("effect_category", ""))\n\tif _preparation_tags.has(skill_id) or _preparation_tags.has(effect_category) or _preparation_tags.has("preparation:%s" % effect_category):\n\t\tchance += 10\n'''
    new = '''\tvar preparation_activity_ids := skill.get("preparation_activity_ids", []) as Array\n\tfor activity_id_value in preparation_activity_ids:\n\t\tif _preparation_tags.has(String(activity_id_value)):\n\t\t\tchance += 10\n\t\t\tbreak\n'''
    replace_once(path, old, new)


def patch_state() -> None:
    path = "scripts/poc/annual_mvp_002/annual_mvp_002_state.gd"
    replace_once(
        path,
        '''\t\tif not _extension_support_skills.has(skill_id):\n\t\t\treturn _response(false, "알 수 없는 공용 지원 스킬입니다.", false)\n''',
        '''\t\tif not _extension_support_skills.has(skill_id):\n\t\t\treturn _response(false, "알 수 없는 공용 지원 스킬입니다.", false)\n\t\tvar support_skill := _extension_support_skills[skill_id] as Dictionary\n\t\tif String(support_skill.get("runtime_status", "")) != "ACTIVE":\n\t\t\treturn _response(false, "이 지원은 후속 CORE hook이 필요해 현재 선택할 수 없습니다.", false)\n''',
    )
    insert = '''\n\nfunc apply_support_readiness_snapshot(values: Dictionary) -> Dictionary:\n\tfor skill_value in values.keys():\n\t\tvar skill_id := String(skill_value)\n\t\tif not _extension_support_skills.has(skill_id):\n\t\t\treturn _response(false, "알 수 없는 공용 지원 스킬 준비도입니다: %s" % skill_id, false)\n\tfor skill_value in values.keys():\n\t\tvar skill_id := String(skill_value)\n\t\t_readiness_by_skill[skill_id] = clampi(int(values[skill_value]), 0, 100)\n\treturn _response(true, "", true, [{"event": "annual_mvp_002_readiness_synced"}])\n\n\nfunc begin_incident() -> Dictionary:\n\tif _phase != "PREPARATION":\n\t\treturn _response(false, "사건을 시작할 준비가 되지 않았습니다.", false)\n\t_phase = "INCIDENT_ACTIVE"\n\treturn _response(true, "", true, [{\n\t\t"event": "annual_incident_requested",\n\t\t"case_path": String((_config.get("campaign", {}) as Dictionary).get("incident_case_path", "")),\n\t\t"run_seed": _run_seed,\n\t}])\n'''
    replace_once(path, '\n\nfunc apply_research_resource_reward(delta: Dictionary) -> Dictionary:\n', insert + '\n\nfunc apply_research_resource_reward(delta: Dictionary) -> Dictionary:\n')

    replace_once(
        path,
        '''\tfor companion_id in _string_array(saved.get("selected_companion_ids", [])):\n\t\tif _extension_companions.has(companion_id):\n\t\t\tselected.append(companion_id)\n''',
        '''\tfor companion_id in _string_array(saved.get("selected_companion_ids", [])):\n\t\tif _extension_companions.has(companion_id) and String((_extension_companions[companion_id] as Dictionary).get("availability", "")) == "AVAILABLE":\n\t\t\tselected.append(companion_id)\n''',
    )
    replace_once(
        path,
        '''\t\tif _selected_companion_ids.has(owner_id) and _extension_support_skills.has(skill_id):\n\t\t\tvar companion := _extension_companions[owner_id] as Dictionary\n\t\t\tif (companion.get("public_skill_ids", []) as Array).has(skill_id):\n''',
        '''\t\tif _selected_companion_ids.has(owner_id) and _extension_support_skills.has(skill_id):\n\t\t\tvar companion := _extension_companions[owner_id] as Dictionary\n\t\t\tvar support_skill := _extension_support_skills[skill_id] as Dictionary\n\t\t\tif String(support_skill.get("runtime_status", "")) == "ACTIVE" and (companion.get("public_skill_ids", []) as Array).has(skill_id):\n''',
    )
    old_equipment = '''\tvar selected_equipment := String(saved.get("selected_equipment_id", ""))\n\tif selected_equipment.is_empty() or _extension_equipment.has(selected_equipment):\n\t\t_selected_equipment_id = selected_equipment\n\telse:\n\t\t_selected_equipment_id = ""\n\t\t_append_unique_string(found_orphans, selected_equipment)\n\t_installed_module_ids.clear()\n\tfor module_id in _string_array(saved.get("installed_module_ids", [])):\n\t\tif _extension_modules.has(module_id):\n\t\t\t_installed_module_ids.append(module_id)\n\t\telse:\n\t\t\t_append_unique_string(found_orphans, module_id)\n'''
    new_equipment = '''\tvar saved_completed_ids := _string_array(saved.get("completed_research_ids", []))\n\tvar selected_equipment := String(saved.get("selected_equipment_id", ""))\n\tif selected_equipment.is_empty():\n\t\t_selected_equipment_id = ""\n\telif _extension_equipment.has(selected_equipment) and _owned_equipment_ids.has(selected_equipment):\n\t\t_selected_equipment_id = selected_equipment\n\telse:\n\t\t_selected_equipment_id = ""\n\t\t_append_unique_string(found_orphans, selected_equipment)\n\t_installed_module_ids.clear()\n\tif not _selected_equipment_id.is_empty():\n\t\tvar selected_item := _extension_equipment[_selected_equipment_id] as Dictionary\n\t\tvar allowed_modules := selected_item.get("allowed_module_ids", []) as Array\n\t\tvar module_slots := int(selected_item.get("module_slots", 1))\n\t\tif saved_completed_ids.has("annual002_research_safe_recheck"):\n\t\t\tmodule_slots = mini(2, module_slots + 1)\n\t\tfor module_id in _string_array(saved.get("installed_module_ids", [])):\n\t\t\tif _installed_module_ids.size() >= module_slots:\n\t\t\t\t_append_unique_string(found_orphans, module_id)\n\t\t\t\tcontinue\n\t\t\tif _extension_modules.has(module_id) and allowed_modules.has(module_id) and not _installed_module_ids.has(module_id):\n\t\t\t\t_installed_module_ids.append(module_id)\n\t\t\telse:\n\t\t\t\t_append_unique_string(found_orphans, module_id)\n\telse:\n\t\tfor module_id in _string_array(saved.get("installed_module_ids", [])):\n\t\t\t_append_unique_string(found_orphans, module_id)\n'''
    replace_once(path, old_equipment, new_equipment)
    replace_once(
        path,
        '''\t_completed_extension_research_ids.clear()\n\tfor node_id in _string_array(saved.get("completed_research_ids", [])):\n''',
        '''\t_completed_extension_research_ids.clear()\n\tfor node_id in saved_completed_ids:\n''',
    )
    replace_once(
        path,
        '''\t_last_loadout = (saved.get("last_loadout", {}) as Dictionary).duplicate(true)\n\t_role_overlap_efficiency = _calculate_role_overlap_efficiency(_selected_companion_ids)\n''',
        '''\t_role_overlap_efficiency = _calculate_role_overlap_efficiency(_selected_companion_ids)\n\t_last_loadout = {\n\t\t"selected_companion_ids": _selected_companion_ids.duplicate(),\n\t\t"equipped_support_skills": _equipped_support_skills.duplicate(true),\n\t\t"selected_equipment_id": _selected_equipment_id,\n\t\t"installed_module_ids": _installed_module_ids.duplicate(),\n\t\t"role_overlap_efficiency": _role_overlap_efficiency,\n\t}\n''',
    )


def patch_adapter() -> None:
    path = "scripts/poc/annual_mvp_002/annual_mvp_002_incident_adapter.gd"
    replace_once(
        path,
        '''\t\tvar public_id := String(selected_support.get(companion_id, ""))\n\t\tif not public_id.is_empty() and _extension_support_skills.has(public_id):\n\t\t\tvar public_entry := (_extension_support_skills[public_id] as Dictionary).duplicate(true)\n\t\t\tpublic_entry["skill_kind"] = "support"\n\t\t\tpublic_entry["owner_companion_id"] = companion_id\n\t\t\tequipped_entries.append(public_entry)\n''',
        '''\t\tvar public_id := String(selected_support.get(companion_id, ""))\n\t\tif not public_id.is_empty() and _extension_support_skills.has(public_id):\n\t\t\tvar public_source := _extension_support_skills[public_id] as Dictionary\n\t\t\tif String(public_source.get("runtime_status", "")) == "ACTIVE":\n\t\t\t\tvar public_entry := public_source.duplicate(true)\n\t\t\t\tpublic_entry["skill_kind"] = "support"\n\t\t\t\tpublic_entry["owner_companion_id"] = companion_id\n\t\t\t\tequipped_entries.append(public_entry)\n''',
    )
    replace_once(
        path,
        '''\tvar preparation_tags: Array[String] = []\n\tfor public_value in selected_support.values():\n\t\t_append_unique(preparation_tags, String(public_value))\n\tfor research_id in _string_array(_extension_snapshot.get("completed_research_ids", [])):\n''',
        '''\tvar preparation_tags: Array[String] = []\n\tvar last_week_result := annual_snapshot.get("last_week_result", {}) as Dictionary\n\tfor activity_id in _string_array(last_week_result.get("planned_activity_ids", [])):\n\t\t_append_unique(preparation_tags, activity_id)\n\tfor research_id in _string_array(_extension_snapshot.get("completed_research_ids", [])):\n''',
    )


def patch_scene() -> None:
    path = "scripts/poc/annual_mvp_002/annual_mvp_002_scene.gd"
    replace_once(
        path,
        'const CoreScene = preload("res://scenes/poc/annual_mvp_001/annual_mvp_001_core_scene.tscn")\n',
        'const CoreScene = preload("res://scenes/poc/annual_mvp_001/annual_mvp_001_core_scene.tscn")\n'
        'const SaveData = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_save_data.gd")\n',
    )
    replace_once(path, 'var _modules: Dictionary = {}\n', 'var _modules: Dictionary = {}\nvar _research_nodes: Dictionary = {}\n')
    replace_once(
        path,
        'var _module_option: OptionButton\n',
        'var _module_option: OptionButton\nvar _research_node_option: OptionButton\nvar _research_resource_label: Label\n',
    )
    replace_once(
        path,
        '\t_modules = ExtensionData.index_by_id(_extension_config.get("modules", []) as Array)\n',
        '\t_modules = ExtensionData.index_by_id(_extension_config.get("modules", []) as Array)\n'
        '\t_research_nodes = ExtensionData.index_by_id(_extension_config.get("research_nodes", []) as Array)\n',
    )
    methods = '''\n\nfunc debug_save_run(path: String = SaveData.SAVE_PATH) -> Dictionary:\n\tvar payload: Dictionary = _state.build_save_payload()\n\tif payload.is_empty():\n\t\treturn _ui_error("현재 단계에서는 저장할 수 없습니다.")\n\tvar error := SaveData.write_payload(payload, path)\n\tif error != OK:\n\t\treturn _ui_error("연도제 저장에 실패했습니다: %s" % error_string(error))\n\t_feedback_label.text = "ANNUAL-MVP-002 진행을 저장했습니다."\n\t_render()\n\treturn {"ok": true, "error": "", "state_changed": false}\n\n\nfunc debug_load_run(path: String = SaveData.SAVE_PATH) -> Dictionary:\n\tvar payload: Dictionary = SaveData.read_payload(path)\n\tif payload.is_empty():\n\t\treturn _ui_error("불러올 ANNUAL-MVP-002 저장이 없습니다.")\n\tvar restored: Dictionary = _state.restore(_config, payload)\n\tif not bool(restored.get("ok", false)):\n\t\treturn _ui_error(String(restored.get("error", "저장을 복구할 수 없습니다.")))\n\t_sync_runtime_from_state()\n\t_feedback_label.text = "ANNUAL-MVP-002 진행을 불러왔습니다."\n\t_render()\n\treturn restored\n\n\nfunc debug_award_research_resources(delta: Dictionary) -> Dictionary:\n\tvar response: Dictionary = _state.apply_research_resource_reward(delta)\n\t_feedback_label.text = String(response.get("error", ""))\n\t_render()\n\treturn response\n\n\nfunc debug_start_research(node_id: String) -> Dictionary:\n\tvar response: Dictionary = _state.start_research(node_id)\n\t_feedback_label.text = String(response.get("error", ""))\n\t_render()\n\treturn response\n\n\nfunc debug_advance_research(node_id: String, amount: int = 1) -> Dictionary:\n\tvar response: Dictionary = _state.advance_research(node_id, amount)\n\t_feedback_label.text = String(response.get("error", ""))\n\t_render()\n\treturn response\n\n\nfunc debug_cancel_research(node_id: String) -> Dictionary:\n\tvar response: Dictionary = _state.cancel_research(node_id)\n\t_feedback_label.text = String(response.get("error", ""))\n\t_render()\n\treturn response\n'''
    replace_once(path, '\n\nfunc debug_force_preparation_phase() -> void:\n', methods + '\n\nfunc debug_force_preparation_phase() -> void:\n')

    replace_once(
        path,
        '''\t\tvar public_ids := (_companions[companion_id] as Dictionary).get("public_skill_ids", []) as Array\n\t\tif not public_ids.is_empty():\n\t\t\tsupport_candidate[companion_id] = String(public_ids[0])\n''',
        '''\t\tvar public_ids := (_companions[companion_id] as Dictionary).get("public_skill_ids", []) as Array\n\t\tfor public_id_value in public_ids:\n\t\t\tvar public_id := String(public_id_value)\n\t\t\tif String((_support_skills.get(public_id, {}) as Dictionary).get("runtime_status", "")) == "ACTIVE":\n\t\t\t\tsupport_candidate[companion_id] = public_id\n\t\t\t\tbreak\n''',
    )

    replace_once(
        path,
        '''\tvar base_gate: Dictionary = _state.configure_loadout("annual001_companion_oh_hyun", "", [])\n\tif not bool(base_gate.get("ok", false)):\n\t\t_feedback_label.text = String(base_gate.get("error", "기본 사건 게이트를 구성할 수 없습니다."))\n\t\treturn\n''',
        '',
    )
    replace_once(
        path,
        '''\tvar applied: Dictionary = _state.apply_incident_result(result, manual_delta, support_log)\n''',
        '''\tvar readiness_sync: Dictionary = _state.apply_support_readiness_snapshot(_adapter.get_readiness_snapshot())\n\tif not bool(readiness_sync.get("ok", false)):\n\t\t_feedback_label.text = String(readiness_sync.get("error", "지원 준비도를 저장하지 못했습니다."))\n\t\t_render()\n\t\treturn\n\tvar applied: Dictionary = _state.apply_incident_result(result, manual_delta, support_log)\n''',
    )

    replace_once(
        path,
        '''\t_add_named_button(panel, "ConfirmWeekButton", "주간 일정 확정", debug_confirm)\n''',
        '''\t_add_named_button(panel, "ConfirmWeekButton", "주간 일정 확정", debug_confirm)\n\tvar save_row := HBoxContainer.new()\n\tpanel.add_child(save_row)\n\t_add_named_button(save_row, "SaveRunButton", "진행 저장", func() -> void: debug_save_run())\n\t_add_named_button(save_row, "LoadRunButton", "진행 불러오기", func() -> void: debug_load_run())\n''',
    )

    old_post = '''\tvar label := Label.new()\n\tlabel.name = "ResearchResourceLabel"\n\tlabel.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART\n\tlabel.text = "사건 결과의 관측 기록·잔향 자료·위험 사례·기관 협력 점수는 연구로 환류합니다."\n\tpanel.add_child(label)\n'''
    new_post = '''\t_research_resource_label = Label.new()\n\t_research_resource_label.name = "ResearchResourceLabel"\n\t_research_resource_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART\n\tpanel.add_child(_research_resource_label)\n\t_research_node_option = OptionButton.new()\n\t_research_node_option.name = "ResearchNodeOption"\n\tfor node_id_value in _research_nodes.keys():\n\t\tvar node_id := String(node_id_value)\n\t\tvar node := _research_nodes[node_id] as Dictionary\n\t\t_research_node_option.add_item(String(node.get("display_name", node_id)))\n\t\t_research_node_option.set_item_metadata(_research_node_option.item_count - 1, node_id)\n\tpanel.add_child(_research_node_option)\n\tvar research_row := HBoxContainer.new()\n\tpanel.add_child(research_row)\n\t_add_named_button(research_row, "StartResearchButton", "연구 시작", func() -> void: debug_start_research(_selected_research_node_id()))\n\t_add_named_button(research_row, "AdvanceResearchButton", "연구 진행", func() -> void: debug_advance_research(_selected_research_node_id(), 1))\n\t_add_named_button(research_row, "CancelResearchButton", "연구 취소", func() -> void: debug_cancel_research(_selected_research_node_id()))\n'''
    replace_once(path, old_post, new_post)
    replace_once(
        path,
        '''\t_support_status_label.text = _support_status_text()\n\t_sync_companion_buttons()\n''',
        '''\t_support_status_label.text = _support_status_text()\n\tif _research_resource_label != null:\n\t\t_research_resource_label.text = _research_status_text(snapshot)\n\t_sync_companion_buttons()\n''',
    )
    helpers = '''\n\nfunc _selected_research_node_id() -> String:\n\tif _research_node_option == null or _research_node_option.item_count == 0:\n\t\treturn ""\n\treturn String(_research_node_option.get_item_metadata(_research_node_option.selected))\n\n\nfunc _research_status_text(snapshot: Dictionary) -> String:\n\tvar extension := snapshot.get("annual_mvp_002", {}) as Dictionary\n\tvar resources := extension.get("research_resources", {}) as Dictionary\n\tvar active := extension.get("active_research", {}) as Dictionary\n\tvar completed := extension.get("completed_research_ids", []) as Array\n\treturn "연구 자원 · 기록 %d / 잔향 %d / 위험 사례 %d / 기관 %d\n진행 %d/2 · 완료 %d\n사건 결과는 연구 자원으로 환류하며 시작·진행·취소를 여기서 검증합니다." % [\n\t\tint(resources.get("annual002_resource_records", 0)),\n\t\tint(resources.get("annual002_resource_residue", 0)),\n\t\tint(resources.get("annual002_resource_risk_cases", 0)),\n\t\tint(resources.get("annual002_resource_institution", 0)),\n\t\tactive.size(),\n\t\tcompleted.size(),\n\t]\n\n\nfunc _sync_runtime_from_state() -> void:\n\tvar snapshot: Dictionary = _state.get_snapshot()\n\tvar extension := snapshot.get("annual_mvp_002", {}) as Dictionary\n\t_selected_companion_ids = _string_array(extension.get("selected_companion_ids", []))\n\t_support_by_companion = (extension.get("equipped_support_skills", {}) as Dictionary).duplicate(true)\n\t_selected_equipment_id = String(extension.get("selected_equipment_id", ""))\n\t_selected_module_ids = _string_array(extension.get("installed_module_ids", []))\n\tvar planner_snapshot := {\n\t\t"days_per_week": 7,\n\t\t"activity_ids": _string_array(snapshot.get("planned_activity_ids", [])),\n\t\t"undo_activity_ids": [],\n\t\t"undo_available": false,\n\t\t"templates": (extension.get("schedule_templates", [[], [], []]) as Array).duplicate(true),\n\t}\n\t_planner.restore(planner_snapshot)\n\t_refresh_module_option()\n'''
    replace_once(path, '\n\nfunc _sync_companion_buttons() -> void:\n', helpers + '\n\nfunc _sync_companion_buttons() -> void:\n')

    old_support = '''\tvar lines: Array[String] = preview_adapter.get_status_lines()\n\tlines.append(preview_adapter.get_fairness_notice())\n\treturn "\\n".join(lines)\n'''
    new_support = '''\tvar lines: Array[String] = preview_adapter.get_status_lines()\n\tfor companion_id in _selected_companion_ids:\n\t\tvar companion := _companions.get(companion_id, {}) as Dictionary\n\t\tfor support_id_value in companion.get("public_skill_ids", []) as Array:\n\t\t\tvar support_id := String(support_id_value)\n\t\t\tvar support := _support_skills.get(support_id, {}) as Dictionary\n\t\t\tif String(support.get("runtime_status", "")) == "DISABLED_PENDING_CORE_HOOK":\n\t\t\t\tlines.append("%s · %s | 비활성: 후속 CORE hook 필요" % [companion.get("display_name", companion_id), support.get("display_name", support_id)])\n\tlines.append(preview_adapter.get_fairness_notice())\n\treturn "\\n".join(lines)\n'''
    replace_once(path, old_support, new_support)


def patch_main_menu() -> None:
    path = "scripts/ui/main_menu.gd"
    replace_once(
        path,
        '''\t_add_scene_button(\n\t\tdev_content,\n\t\t"ANNUAL-MVP-001 육성→사건→연구 PoC",\n\t\t"res://scenes/poc/annual_mvp_001/annual_mvp_001_scene.tscn"\n\t)\n''',
        '''\t_add_scene_button(\n\t\tdev_content,\n\t\t"ANNUAL-MVP-001 육성→사건→연구 PoC",\n\t\t"res://scenes/poc/annual_mvp_001/annual_mvp_001_scene.tscn"\n\t)\n\tvar annual_mvp_002_button := Button.new()\n\tannual_mvp_002_button.name = "AnnualMvp002Button"\n\tannual_mvp_002_button.text = "ANNUAL-MVP-002 동료·장비·연구 PoC"\n\tannual_mvp_002_button.pressed.connect(func() -> void:\n\t\tget_tree().change_scene_to_file("res://scenes/poc/annual_mvp_002/annual_mvp_002_scene.tscn")\n\t)\n\tdev_content.add_child(annual_mvp_002_button)\n''',
    )
    for dead in ["scripts/ui/main_menu_annual_mvp_002.gd", "scenes/ui/main_menu.tscn"]:
        target = ROOT / dead
        if target.exists():
            target.unlink()


def patch_documents() -> None:
    replacements = {
        "docs/CURRENT_STATUS.md": [
            ("`ON_BRANCH / AUTOMATED_QA_PASSED` — Issue #88 / draft PR #89", "`MERGED / AUTOMATED_QA_PASSED` — Issue #88 / PR #89 / commit `c790bf747c0fa4f4427d9e4b49b22adbfce92824`"),
            ("## ANNUAL-MVP-002 수직절편 — 현재 브랜치 구현", "## ANNUAL-MVP-002 수직절편 — main 병합 구현"),
        ],
        "docs/CURRENT_HANDOFF.md": [
            ("status: ANNUAL_MVP_002_ON_BRANCH_AUTOMATED_QA_PASSED", "status: ANNUAL_MVP_002_MERGED_AUTOMATED_QA_PASSED_REVIEW_HARDENING"),
            ("pr: 89_DRAFT", "pr: 89"),
            ("implementation: ON_BRANCH", "implementation: MERGED"),
            ("1. PR #89 changed-file·보호 경로·review thread 최종 감사\n2. PR #89 squash merge 후 merge commit을 상태 원본과 Issue #88에 기록\n3.", "1. PR #89 squash merge 완료 — commit `c790bf747c0fa4f4427d9e4b49b22adbfce92824`\n2. Issue #90 / PR #91 적대적 검수 보정\n3."),
        ],
        "MVP_ROADMAP.md": [
            ("`ON_BRANCH / AUTOMATED_QA_PASSED` — Issue #88 / draft PR #89", "`MERGED / AUTOMATED_QA_PASSED` — Issue #88 / PR #89 / commit `c790bf747c0fa4f4427d9e4b49b22adbfce92824`"),
        ],
        "docs/qa/ANNUAL_MVP_002_AUTOMATED_VALIDATION_2026-07-26.md": [
            ("> 추적: Issue #88 / draft PR #89", "> 추적: Issue #88 / PR #89 / review Issue #90 / PR #91"),
            ("> 상태: `ON_BRANCH / AUTOMATED_QA_PASSED`", "> 상태: `MERGED / AUTOMATED_QA_PASSED / REVIEW_HARDENING`"),
        ],
        "docs/superpowers/plans/2026-07-26-annual-mvp-002-vertical-slice-implementation-plan.md": [
            ("> 상태: `IN_EXECUTION`", "> 상태: `EXECUTED / MERGED / REVIEW_HARDENING`"),
            ("> 추적: Issue #88 / draft PR #89", "> 추적: Issue #88 / PR #89 / review Issue #90 / PR #91"),
        ],
        "docs/superpowers/specs/2026-07-26-annual-mvp-002-as-built.md": [
            ("> 추적: Issue #88 / draft PR #89", "> 추적: Issue #88 / PR #89 / review Issue #90 / PR #91"),
            ("> 상태: `ON_BRANCH / AUTOMATED_QA_PASSED`", "> 상태: `MERGED / AUTOMATED_QA_PASSED / REVIEW_HARDENING`"),
            ("annual_mvp_002_implementation: ON_BRANCH", "annual_mvp_002_implementation: MERGED"),
            ("annual_mvp_002_merge: PENDING", "annual_mvp_002_merge: c790bf747c0fa4f4427d9e4b49b22adbfce92824"),
        ],
    }
    for path, pairs in replacements.items():
        for old, new in pairs:
            replace_once(path, old, new)

    decision_path = "docs/DECISION_LOG.md"
    decision = read(decision_path)
    marker = "## 2026-07-26 — ANNUAL-MVP-002 적대적 검수 C안\n"
    if marker not in decision:
        decision += '''\n\n## 2026-07-26 — ANNUAL-MVP-002 적대적 검수 C안\n\n- 상태: `APPROVED_REVIEW_DECISION`\n- 추적: Issue #90 / PR #91\n- 지원 데이터 6개는 보존한다.\n- 현재 CORE hook이 실제 적용 가능한 피해·위험 계열 2개만 `ACTIVE`로 둔다.\n- 기록 가독성·실수 면제·표시 시간·회수 창 계열 4개는 `DISABLED_PENDING_CORE_HOOK`으로 두며 선택·발동·성공 로그를 금지한다.\n- 준비 보정은 장착 자체가 아니라 직전 주간의 대응 활동 이력에서만 +10%p를 얻는다.\n- 병합 후 정본 상태, 실제 main menu 경로, 준비도 영속화, save 복구 정화, 런타임 저장·연구 조작을 기술 보정한다.\n- 사람 검증 전 `POC_PASSED`, `annual_loop_passed`, 제작 확대는 계속 미선언한다.\n'''
        write(decision_path, decision)


def main() -> None:
    patch_data()
    patch_validator()
    patch_resolver()
    patch_state()
    patch_adapter()
    patch_scene()
    patch_main_menu()
    patch_documents()
    print("ANNUAL-MVP-002 review hardening patch applied")


if __name__ == "__main__":
    main()
