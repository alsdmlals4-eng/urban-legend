from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]


def patch(path: str, old: str, new: str) -> None:
    target = ROOT / path
    text = target.read_text(encoding="utf-8")
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f"{path}: expected one match, found {count}: {old[:100]!r}")
    target.write_text(text.replace(old, new, 1), encoding="utf-8")


patch(
    "scripts/poc/annual_mvp_002/annual_mvp_002_state.gd",
    '''\t_active_research.clear()\n\tvar saved_active := saved.get("active_research", {}) as Dictionary\n\tfor node_value in saved_active.keys():\n\t\tvar node_id := String(node_value)\n\t\tif _extension_research_nodes.has(node_id) and typeof(saved_active[node_value]) == TYPE_DICTIONARY:\n\t\t\t_active_research[node_id] = (saved_active[node_value] as Dictionary).duplicate(true)\n\t\telse:\n\t\t\t_append_unique_string(found_orphans, node_id)\n\t_completed_extension_research_ids.clear()\n\tfor node_id in saved_completed_ids:\n\t\tif _extension_research_nodes.has(node_id):\n\t\t\t_append_unique_string(_completed_extension_research_ids, node_id)\n\t\telse:\n\t\t\t_append_unique_string(found_orphans, node_id)\n''',
    '''\t_completed_extension_research_ids.clear()\n\tfor node_id in saved_completed_ids:\n\t\tif _extension_research_nodes.has(node_id):\n\t\t\t_append_unique_string(_completed_extension_research_ids, node_id)\n\t\telse:\n\t\t\t_append_unique_string(found_orphans, node_id)\n\n\t_active_research.clear()\n\tvar saved_active := saved.get("active_research", {}) as Dictionary\n\tvar max_active := int((_extension_config.get("rules", {}) as Dictionary).get("max_active_research", 2))\n\tfor node_value in saved_active.keys():\n\t\tvar node_id := String(node_value)\n\t\tif _active_research.size() >= max_active:\n\t\t\t_append_unique_string(found_orphans, node_id)\n\t\t\tcontinue\n\t\tif not _extension_research_nodes.has(node_id) or typeof(saved_active[node_value]) != TYPE_DICTIONARY:\n\t\t\t_append_unique_string(found_orphans, node_id)\n\t\t\tcontinue\n\t\tif _completed_extension_research_ids.has(node_id):\n\t\t\t_append_unique_string(found_orphans, node_id)\n\t\t\tcontinue\n\t\tvar node := _extension_research_nodes[node_id] as Dictionary\n\t\tvar prerequisites_valid := true\n\t\tfor prerequisite_value in node.get("prerequisite_ids", []) as Array:\n\t\t\tif not _completed_extension_research_ids.has(String(prerequisite_value)):\n\t\t\t\tprerequisites_valid = false\n\t\t\t\tbreak\n\t\tif not prerequisites_valid:\n\t\t\t_append_unique_string(found_orphans, node_id)\n\t\t\tcontinue\n\t\tvar saved_project := saved_active[node_value] as Dictionary\n\t\tvar required := maxi(1, int(node.get("progress_required", 1)))\n\t\t_active_research[node_id] = {\n\t\t\t"progress": clampi(int(saved_project.get("progress", 0)), 0, required - 1),\n\t\t\t"reserved_cost": (node.get("resource_cost", {}) as Dictionary).duplicate(true),\n\t\t}\n''',
)

patch(
    "scripts/poc/annual_mvp_002/annual_mvp_002_scene.gd",
    'var _companion_buttons: Dictionary = {}\n',
    'var _companion_buttons: Dictionary = {}\nvar _support_options: Dictionary = {}\n',
)

patch(
    "scripts/poc/annual_mvp_002/annual_mvp_002_scene.gd",
    '''func debug_set_support(companion_id: String, support_id: String) -> Dictionary:\n\tif not _selected_companion_ids.has(companion_id):\n\t\treturn _ui_error("먼저 동료를 선택해야 합니다.")\n\tvar companion := _companions.get(companion_id, {}) as Dictionary\n\tif not (companion.get("public_skill_ids", []) as Array).has(support_id):\n\t\treturn _ui_error("해당 동료가 사용할 수 없는 공용 지원입니다.")\n\tvar candidate := _support_by_companion.duplicate(true)\n\tcandidate[companion_id] = support_id\n\tvar response: Dictionary = _state.configure_loadout_v2(\n''',
    '''func debug_set_support(companion_id: String, support_id: String) -> Dictionary:\n\tif not _selected_companion_ids.has(companion_id):\n\t\treturn _ui_error("먼저 동료를 선택해야 합니다.")\n\tvar companion := _companions.get(companion_id, {}) as Dictionary\n\tif not support_id.is_empty():\n\t\tif not (companion.get("public_skill_ids", []) as Array).has(support_id):\n\t\t\treturn _ui_error("해당 동료가 사용할 수 없는 공용 지원입니다.")\n\t\tvar support := _support_skills.get(support_id, {}) as Dictionary\n\t\tif String(support.get("runtime_status", "")) != "ACTIVE":\n\t\t\treturn _ui_error("이 지원은 후속 CORE hook이 필요해 현재 선택할 수 없습니다.")\n\tvar candidate := _support_by_companion.duplicate(true)\n\tif support_id.is_empty():\n\t\tcandidate.erase(companion_id)\n\telse:\n\t\tcandidate[companion_id] = support_id\n\tvar response: Dictionary = _state.configure_loadout_v2(\n''',
)

patch(
    "scripts/poc/annual_mvp_002/annual_mvp_002_scene.gd",
    '''\t\tcompanion_grid.add_child(card)\n\t\t_companion_buttons[companion_id] = card\n\tvar equipment_row := HBoxContainer.new()\n''',
    '''\t\tcompanion_grid.add_child(card)\n\t\t_companion_buttons[companion_id] = card\n\tvar support_title := Label.new()\n\tsupport_title.text = "공용 지원 선택 · 비활성 항목은 후속 CORE hook이 필요합니다."\n\tsupport_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART\n\tpanel.add_child(support_title)\n\tvar support_grid := GridContainer.new()\n\tsupport_grid.columns = 2\n\tpanel.add_child(support_grid)\n\tfor companion_id_value in _companions.keys():\n\t\tvar companion_id := String(companion_id_value)\n\t\tvar companion := _companions[companion_id] as Dictionary\n\t\tvar label := Label.new()\n\t\tlabel.text = String(companion.get("display_name", companion_id))\n\t\tlabel.custom_minimum_size.x = 120\n\t\tsupport_grid.add_child(label)\n\t\tvar option := OptionButton.new()\n\t\toption.name = "SupportOption_%s" % companion_id\n\t\toption.size_flags_horizontal = Control.SIZE_EXPAND_FILL\n\t\toption.add_item("지원 없음")\n\t\toption.set_item_metadata(0, "")\n\t\tfor support_id_value in companion.get("public_skill_ids", []) as Array:\n\t\t\tvar support_id := String(support_id_value)\n\t\t\tvar support := _support_skills.get(support_id, {}) as Dictionary\n\t\t\tvar active := String(support.get("runtime_status", "")) == "ACTIVE"\n\t\t\tvar suffix := "" if active else " · 후속 CORE hook"\n\t\t\toption.add_item("%s%s" % [support.get("display_name", support_id), suffix])\n\t\t\tvar item_index := option.item_count - 1\n\t\t\toption.set_item_metadata(item_index, support_id)\n\t\t\toption.set_item_disabled(item_index, not active)\n\t\toption.item_selected.connect(func(index: int) -> void:\n\t\t\tif _ui_syncing:\n\t\t\t\treturn\n\t\t\tvar response := debug_set_support(companion_id, String(option.get_item_metadata(index)))\n\t\t\tif not bool(response.get("ok", false)):\n\t\t\t\t_sync_companion_buttons()\n\t\t)\n\t\tsupport_grid.add_child(option)\n\t\t_support_options[companion_id] = option\n\tvar equipment_row := HBoxContainer.new()\n''',
)

patch(
    "scripts/poc/annual_mvp_002/annual_mvp_002_scene.gd",
    '''func _sync_companion_buttons() -> void:\n\t_ui_syncing = true\n\tfor key in _companion_buttons.keys():\n\t\t(_companion_buttons[key] as CheckButton).button_pressed = _selected_companion_ids.has(String(key))\n\t_ui_syncing = false\n''',
    '''func _sync_companion_buttons() -> void:\n\t_ui_syncing = true\n\tfor key in _companion_buttons.keys():\n\t\t(_companion_buttons[key] as CheckButton).button_pressed = _selected_companion_ids.has(String(key))\n\tfor key in _support_options.keys():\n\t\tvar companion_id := String(key)\n\t\tvar option := _support_options[key] as OptionButton\n\t\toption.disabled = not _selected_companion_ids.has(companion_id)\n\t\tvar selected_support := String(_support_by_companion.get(companion_id, ""))\n\t\tvar selected_index := 0\n\t\tfor index in range(option.item_count):\n\t\t\tif String(option.get_item_metadata(index)) == selected_support:\n\t\t\t\tselected_index = index\n\t\t\t\tbreak\n\t\toption.select(selected_index)\n\t_ui_syncing = false\n''',
)

print("review follow-up runtime patch applied")
