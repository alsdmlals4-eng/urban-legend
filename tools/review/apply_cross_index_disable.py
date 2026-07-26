from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]


def replace_once(path: str, old: str, new: str) -> None:
    target = ROOT / path
    text = target.read_text(encoding="utf-8")
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f"expected one match in {path}, found {count}: {old[:80]!r}")
    target.write_text(text.replace(old, new, 1), encoding="utf-8")


DATA_PATH = "data/poc/annual_mvp_002/companion_equipment_research.json"
replace_once(
    DATA_PATH,
    '      "incident_limit": 1,\n      "effect_category": "damage_and_risk",',
    '      "incident_limit": 1,\n      "runtime_status": "ACTIVE",\n      "effect_category": "damage_and_risk",',
)
replace_once(
    DATA_PATH,
    '      "incident_limit": 1,\n      "effect_category": "record_readability",',
    '      "incident_limit": 1,\n      "runtime_status": "DISABLED_PENDING_HYPOTHESIS_BOARD_HOOK",\n      "effect_category": "record_readability",',
)
replace_once(
    DATA_PATH,
    '      "incident_limit": 1,\n      "effect_category": "protection_and_tolerance",',
    '      "incident_limit": 1,\n      "runtime_status": "ACTIVE",\n      "effect_category": "protection_and_tolerance",',
)

DATA_SCRIPT = "scripts/poc/annual_mvp_002/annual_mvp_002_data.gd"
replace_once(
    DATA_SCRIPT,
    'const SUPPORT_RUNTIME_STATUSES := ["ACTIVE", "DISABLED_PENDING_CORE_HOOK"]\nconst ACTIVE_SUPPORT_EFFECT_KEYS := ["damage_reduction", "risk_reduction"]',
    'const SUPPORT_RUNTIME_STATUSES := ["ACTIVE", "DISABLED_PENDING_CORE_HOOK"]\nconst UNIQUE_RUNTIME_STATUSES := ["ACTIVE", "DISABLED_PENDING_HYPOTHESIS_BOARD_HOOK"]\nconst ACTIVE_SUPPORT_EFFECT_KEYS := ["damage_reduction", "risk_reduction"]',
)
replace_once(
    DATA_SCRIPT,
    '\t\tif int(skill.get("incident_limit", 0)) != 1:\n\t\t\terrors.append("unique skill incident_limit must be 1")\n\t\t_validate_effect(skill, errors, "unique skill %s" % String(skill.get("id", "")))',
    '\t\tif int(skill.get("incident_limit", 0)) != 1:\n\t\t\terrors.append("unique skill incident_limit must be 1")\n\t\tvar runtime_status := String(skill.get("runtime_status", ""))\n\t\tif not UNIQUE_RUNTIME_STATUSES.has(runtime_status):\n\t\t\terrors.append("unique skill %s runtime_status is invalid" % String(skill.get("id", "")))\n\t\t_validate_effect(skill, errors, "unique skill %s" % String(skill.get("id", "")))',
)

ADAPTER = "scripts/poc/annual_mvp_002/annual_mvp_002_incident_adapter.gd"
replace_once(
    ADAPTER,
    '\t\tif _extension_unique_skills.has(unique_id):\n\t\t\tvar unique_entry := (_extension_unique_skills[unique_id] as Dictionary).duplicate(true)\n\t\t\tunique_entry["skill_kind"] = "unique"\n\t\t\tequipped_entries.append(unique_entry)',
    '\t\tif _extension_unique_skills.has(unique_id):\n\t\t\tvar unique_source := _extension_unique_skills[unique_id] as Dictionary\n\t\t\tif String(unique_source.get("runtime_status", "")) == "ACTIVE":\n\t\t\t\tvar unique_entry := unique_source.duplicate(true)\n\t\t\t\tunique_entry["skill_kind"] = "unique"\n\t\t\t\tequipped_entries.append(unique_entry)',
)

SCENE = "scripts/poc/annual_mvp_002/annual_mvp_002_scene.gd"
replace_once(
    SCENE,
    'var _companions: Dictionary = {}\nvar _support_skills: Dictionary = {}',
    'var _companions: Dictionary = {}\nvar _unique_skills: Dictionary = {}\nvar _support_skills: Dictionary = {}',
)
replace_once(
    SCENE,
    '\t_companions = ExtensionData.index_by_id(_extension_config.get("companions", []) as Array)\n\t_support_skills = ExtensionData.index_by_id(_extension_config.get("support_skills", []) as Array)',
    '\t_companions = ExtensionData.index_by_id(_extension_config.get("companions", []) as Array)\n\t_unique_skills = ExtensionData.index_by_id(_extension_config.get("unique_skills", []) as Array)\n\t_support_skills = ExtensionData.index_by_id(_extension_config.get("support_skills", []) as Array)',
)
replace_once(
    SCENE,
    '''func _support_status_text() -> String:\n\tif _selected_companion_ids.is_empty():\n\t\treturn "동료 미편성 · 지원 효과 없음\\n%s" % Adapter.FAIRNESS_NOTICE\n\tvar preview_adapter := Adapter.new()\n\tvar configured: Dictionary = preview_adapter.configure(_config, _state.get_snapshot(), int(_state.get_snapshot().get("run_seed", 2201)))\n\tif bool(configured.get("fallback_active", false)):\n\t\treturn "%s\\n%s" % [String(configured.get("warning", "기본 동작")), preview_adapter.get_fairness_notice()]\n\tvar lines: Array[String] = preview_adapter.get_status_lines()\n\tfor companion_id in _selected_companion_ids:\n\t\tvar companion := _companions.get(companion_id, {}) as Dictionary\n\t\tfor support_id_value in companion.get("public_skill_ids", []) as Array:\n\t\t\tvar support_id := String(support_id_value)\n\t\t\tvar support := _support_skills.get(support_id, {}) as Dictionary\n\t\t\tif String(support.get("runtime_status", "")) == "DISABLED_PENDING_CORE_HOOK":\n\t\t\t\tlines.append("%s · %s | 비활성: 후속 CORE hook 필요" % [companion.get("display_name", companion_id), support.get("display_name", support_id)])\n\tlines.append(preview_adapter.get_fairness_notice())\n\treturn "\\n".join(lines)''',
    '''func _support_status_text() -> String:\n\tif _selected_companion_ids.is_empty():\n\t\treturn "동료 미편성 · 지원 효과 없음\\n%s" % Adapter.FAIRNESS_NOTICE\n\tvar preview_adapter := Adapter.new()\n\tvar configured: Dictionary = preview_adapter.configure(_config, _state.get_snapshot(), int(_state.get_snapshot().get("run_seed", 2201)))\n\tvar lines: Array[String] = []\n\tif bool(configured.get("fallback_active", false)):\n\t\tlines.append(String(configured.get("warning", "기본 동작")))\n\telse:\n\t\tlines = preview_adapter.get_status_lines()\n\tfor companion_id in _selected_companion_ids:\n\t\tvar companion := _companions.get(companion_id, {}) as Dictionary\n\t\tvar unique_id := String(companion.get("unique_skill_id", ""))\n\t\tvar unique_skill := _unique_skills.get(unique_id, {}) as Dictionary\n\t\tif String(unique_skill.get("runtime_status", "")) == "DISABLED_PENDING_HYPOTHESIS_BOARD_HOOK":\n\t\t\tlines.append("%s · %s | 비활성: 관측·가설 보드 hook 필요" % [companion.get("display_name", companion_id), unique_skill.get("display_name", unique_id)])\n\t\tfor support_id_value in companion.get("public_skill_ids", []) as Array:\n\t\t\tvar support_id := String(support_id_value)\n\t\t\tvar support := _support_skills.get(support_id, {}) as Dictionary\n\t\t\tif String(support.get("runtime_status", "")) == "DISABLED_PENDING_CORE_HOOK":\n\t\t\t\tlines.append("%s · %s | 비활성: 후속 CORE hook 필요" % [companion.get("display_name", companion_id), support.get("display_name", support_id)])\n\tlines.append(preview_adapter.get_fairness_notice())\n\treturn "\\n".join(lines)''',
)

print("cross-index disable patch applied")
