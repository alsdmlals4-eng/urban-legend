# 사건 준비 화면에서 요원, 장비, 기록물, 로그 안내를 확인하고 조사 시작을 연결한다.
extends Control

const ThemeFactory = preload("res://scripts/ui/ui_theme_factory.gd")

var _equipment_list: VBoxContainer
var _episode_list: VBoxContainer
var _equipped_label: Label
var _modifier_label: Label
var _record_list: VBoxContainer
var _log_list: VBoxContainer
var _start_button: Button
var _status_label: Label
var _agent_list: VBoxContainer
var _agent_detail_panel: PanelContainer
var _agent_detail_label: Label
var _selected_detail_agent_id := ""
var _agent_card_by_id: Dictionary = {}
var _contact_list: VBoxContainer
var _consumable_list: VBoxContainer


func _ready() -> void:
	theme = ThemeFactory.create_theme()
	if GameState.get_current_episode().is_empty():
		GameState.load_episode()

	GameState.set_current_scene_path(GameState.SCENE_PREPARATION)
	GameState.save_game()
	_build_ui()
	_refresh()


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.052, 0.058, 0.069, 1.0)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	add_child(margin)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(scroll)

	var root := VBoxContainer.new()
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.add_theme_constant_override("separation", 10)
	scroll.add_child(root)

	_add_navigation(root)
	_add_header(root)
	_add_current_case_panel(root)
	_add_episode_panel(root)
	_add_external_contact_panel(root)
	_add_agent_panel(root)
	_add_equipment_panel(root)
	_add_record_panel(root)
	_add_log_panel(root)
	_add_start_panel(root)


func _add_navigation(parent: Control) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	parent.add_child(row)

	_add_scene_button(row, "메뉴", GameState.SCENE_MAIN_MENU)
	_add_scene_button(row, "기록국 DB", "res://scenes/database_view.tscn")
	_add_scene_button(row, "조사", GameState.SCENE_INVESTIGATION)


func _add_header(parent: Control) -> void:
	var title := Label.new()
	title.text = "사건 준비"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	parent.add_child(title)


func _add_current_case_panel(parent: Control) -> void:
	var content := _add_section(parent, "현재 사건", "지금 조사 준비를 적용할 사건입니다.")

	var case_label := Label.new()
	case_label.text = "현재 사건: %s\n%s" % [
		GameState.get_current_episode_title(),
		GameState.get_project_core_sentence()
	]
	case_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	case_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(case_label)


func _add_episode_panel(parent: Control) -> void:
	var content := _add_section(parent, "사건 선택", "두 사건 중 이번에 조사할 대상을 고릅니다.")

	_episode_list = VBoxContainer.new()
	_episode_list.add_theme_constant_override("separation", 6)
	content.add_child(_episode_list)


func _add_agent_panel(parent: Control) -> void:
	var content := _add_section(parent, "요원 편성", "임무에 투입할 요원 2~3명을 선택하고 상세 정보를 확인합니다.")

	_agent_list = VBoxContainer.new()
	_agent_list.add_theme_constant_override("separation", 8)
	content.add_child(_agent_list)

	_agent_detail_panel = PanelContainer.new()
	_agent_detail_panel.visible = false
	content.add_child(_agent_detail_panel)

	var detail_content := VBoxContainer.new()
	detail_content.add_theme_constant_override("separation", 6)
	_agent_detail_panel.add_child(detail_content)

	_agent_detail_label = Label.new()
	_agent_detail_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_content.add_child(_agent_detail_label)

	var close_detail_button := Button.new()
	close_detail_button.text = "상세 닫기"
	close_detail_button.pressed.connect(func() -> void:
		_selected_detail_agent_id = ""
		_agent_detail_panel.visible = false
	)
	detail_content.add_child(close_detail_button)


func _add_external_contact_panel(parent: Control) -> void:
	var content := _add_section(parent, "외부 접점", "사건 사이에 세력과 교류하고 시장 거래·연구 의뢰·현장 의뢰를 준비합니다.")
	_contact_list = VBoxContainer.new()
	_contact_list.add_theme_constant_override("separation", 6)
	content.add_child(_contact_list)
	_consumable_list = VBoxContainer.new()
	_consumable_list.add_theme_constant_override("separation", 6)
	content.add_child(_consumable_list)


func _refresh_agents() -> void:
	_clear_children(_agent_list)
	for agent in GameState.get_agents():
		if typeof(agent) != TYPE_DICTIONARY:
			continue
		_add_agent_card(_agent_list, agent)

	var selected_count := GameState.get_selected_agent_ids().size()
	if _start_button != null:
		_start_button.disabled = not GameState.can_start_mission_with_agents()

	if _status_label != null:
		if GameState.can_start_mission_with_agents():
			_status_label.text = "시작 가능: 요원 %d명 편성됨. 장비와 기록물을 확인한 뒤 조사를 시작하세요." % selected_count
		else:
			_status_label.text = GameState.get_agent_selection_status_text()


func _add_agent_card(parent: Control, agent: Dictionary) -> void:
	var agent_id := String(agent.get("id", ""))
	if agent_id.is_empty():
		return

	var card := PanelContainer.new()
	parent.add_child(card)

	var card_content := VBoxContainer.new()
	card_content.add_theme_constant_override("separation", 4)
	card.add_child(card_content)

	# Name and class row
	var name_row := HBoxContainer.new()
	name_row.add_theme_constant_override("separation", 8)
	card_content.add_child(name_row)

	var selected := GameState.is_agent_selected(agent_id)
	var toggle_button := Button.new()
	toggle_button.text = "해제" if selected else "선택"
	toggle_button.pressed.connect(func() -> void:
		if GameState.is_agent_selected(agent_id):
			GameState.deselect_agent(agent_id)
		else:
			GameState.select_agent(agent_id)
		_refresh_agents()
	)
	toggle_button.disabled = not selected and GameState.get_selected_agent_ids().size() >= GameState.MAX_SELECTED_AGENTS
	name_row.add_child(toggle_button)

	var name_label := Label.new()
	name_label.text = "%s [%s] · %s / %s" % [
		String(agent.get("name", "")),
		String(agent.get("temperament_label", "")),
		String(agent.get("class", "")),
		String(agent.get("role", ""))
	]
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_row.add_child(name_label)

	# HP and Mental bars
	var hp_row := HBoxContainer.new()
	hp_row.add_theme_constant_override("separation", 6)
	card_content.add_child(hp_row)
	var hp_label := Label.new()
	hp_label.text = "체력"
	hp_label.custom_minimum_size.x = 40
	hp_row.add_child(hp_label)
	var hp_bar := ProgressBar.new()
	hp_bar.min_value = 0
	hp_bar.max_value = GameState.get_agent_max_hp(agent_id)
	hp_bar.value = GameState.get_agent_current_hp(agent_id)
	hp_bar.custom_minimum_size = Vector2(120, 14)
	hp_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hp_row.add_child(hp_bar)
	var hp_value := Label.new()
	hp_value.text = "%d/%d" % [GameState.get_agent_current_hp(agent_id), GameState.get_agent_max_hp(agent_id)]
	hp_value.custom_minimum_size.x = 70
	hp_row.add_child(hp_value)

	var mental_row := HBoxContainer.new()
	mental_row.add_theme_constant_override("separation", 6)
	card_content.add_child(mental_row)
	var mental_label := Label.new()
	mental_label.text = "정신"
	mental_label.custom_minimum_size.x = 40
	mental_row.add_child(mental_label)
	var mental_bar := ProgressBar.new()
	mental_bar.min_value = 0
	mental_bar.max_value = GameState.get_agent_max_mental(agent_id)
	mental_bar.value = GameState.get_agent_current_mental(agent_id)
	mental_bar.custom_minimum_size = Vector2(120, 14)
	mental_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mental_row.add_child(mental_bar)
	var mental_value := Label.new()
	mental_value.text = "%d/%d" % [GameState.get_agent_current_mental(agent_id), GameState.get_agent_max_mental(agent_id)]
	mental_value.custom_minimum_size.x = 70
	mental_row.add_child(mental_value)

	# Five ability bars
	var abilities := ["suppression", "analysis", "protection", "treatment", "rapport"]
	var ability_row := HBoxContainer.new()
	ability_row.add_theme_constant_override("separation", 4)
	card_content.add_child(ability_row)
	for key in abilities:
		var val := GameState.get_agent_ability(agent_id, key)
		var label: String = String(GameState.ABILITY_LABELS.get(key, key))
		var ab_label := Label.new()
		ab_label.text = "%s %d" % [label, val]
		ab_label.add_theme_font_size_override("font_size", 10)
		ability_row.add_child(ab_label)

	# Description and detail button
	var desc := Label.new()
	desc.text = String(agent.get("description", ""))
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	card_content.add_child(desc)

	var detail_button := Button.new()
	detail_button.text = "상세 정보"
	detail_button.pressed.connect(func() -> void:
		_show_agent_detail(agent_id)
	)
	card_content.add_child(detail_button)

	_agent_card_by_id[agent_id] = { "card": card, "toggle": toggle_button }


func _show_agent_detail(agent_id: String) -> void:
	var agent := GameState.get_agent_by_id(agent_id)
	if agent.is_empty():
		return

	_selected_detail_agent_id = agent_id
	var lines: Array = [
		"=== %s [%s] ===" % [String(agent.get("name", "")), String(agent.get("temperament_label", ""))],
		"직책: %s / %s" % [String(agent.get("class", "")), String(agent.get("role", ""))],
		"전문분야: %s" % String(agent.get("specialty", "")),
		"계통: %s" % String(agent.get("magic_lineage", "")),
		"",
		"체력: %d/%d" % [GameState.get_agent_current_hp(agent_id), GameState.get_agent_max_hp(agent_id)],
		"정신력: %d/%d" % [GameState.get_agent_current_mental(agent_id), GameState.get_agent_max_mental(agent_id)],
		"",
		"능력치:",
	]
	for key in GameState.ABILITY_KEYS:
		lines.append("  %s: %d/5" % [GameState.ABILITY_LABELS.get(key, key), GameState.get_agent_ability(agent_id, key)])
	lines.append("")
	lines.append("고유 장비:")
	for item in agent.get("equipment", []):
		lines.append("  · %s" % _format_agent_feature(item))
	lines.append("")
	lines.append("기술:")
	for skill in agent.get("skills", []):
		lines.append("  · %s" % _format_agent_feature(skill))
	lines.append("")

	var aspects: Array = agent.get("aspects", [])
	if not aspects.is_empty():
		lines.append("면모:")
		for aspect in aspects:
			if typeof(aspect) == TYPE_DICTIONARY:
				lines.append("  · %s: %s" % [String(aspect.get("name", "")), String(aspect.get("description", ""))])
		lines.append("")

	lines.append("배경:")
	lines.append("  %s" % String(agent.get("backstory", "")))
	lines.append("")
	lines.append("설명: %s" % String(agent.get("description", "")))

	_agent_detail_label.text = "\n".join(lines)
	_agent_detail_panel.visible = true


func _format_agent_feature(value: Variant) -> String:
	if typeof(value) != TYPE_DICTIONARY:
		return String(value)
	var ability_key := String(value.get("ability", ""))
	var ability_label := String(GameState.ABILITY_LABELS.get(ability_key, ability_key))
	return "%s — %s 효과 +%d" % [String(value.get("name", "")), ability_label, int(value.get("bonus", 0))]


func _add_equipment_panel(parent: Control) -> void:
	var content := _add_section(parent, "장비", "해금된 도구를 장착해 다음 조사 보정을 확인합니다.")

	_equipped_label = Label.new()
	_equipped_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(_equipped_label)

	_modifier_label = Label.new()
	_modifier_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(_modifier_label)

	_equipment_list = VBoxContainer.new()
	_equipment_list.add_theme_constant_override("separation", 6)
	content.add_child(_equipment_list)


func _add_record_panel(parent: Control) -> void:
	var content := _add_section(parent, "기록물", "해금된 기록물이 이번 조사에 주는 참고 효과를 봅니다.")

	_record_list = VBoxContainer.new()
	_record_list.add_theme_constant_override("separation", 6)
	content.add_child(_record_list)


func _add_log_panel(parent: Control) -> void:
	var content := _add_section(parent, "로그", "준비 상태와 사건별 주의 문구를 한 번 더 확인합니다.")

	var profile := Label.new()
	profile.text = "로그 / 기관에서 지급한 괴담 기록 단말기 속 안내 AI / 작은 픽셀 유령 또는 말하는 부적 스티커"
	profile.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(profile)

	_log_list = VBoxContainer.new()
	_log_list.add_theme_constant_override("separation", 5)
	content.add_child(_log_list)


func _add_start_panel(parent: Control) -> void:
	var content := _add_section(parent, "조사 시작", "조건을 만족하면 현재 사건의 조사 화면으로 이동합니다.")

	_status_label = Label.new()
	_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(_status_label)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	content.add_child(row)

	_start_button = Button.new()
	_start_button.text = "조사 시작"
	_start_button.pressed.connect(_start_investigation)
	row.add_child(_start_button)

	var save_button := Button.new()
	save_button.text = "준비 저장"
	save_button.pressed.connect(func() -> void:
		GameState.save_game()
		_status_label.text = "준비 상태를 저장했습니다."
	)
	row.add_child(save_button)


func _add_section(parent: Control, title_text: String, description_text: String = "") -> VBoxContainer:
	var panel := PanelContainer.new()
	parent.add_child(panel)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 8)
	panel.add_child(content)

	var title := Label.new()
	title.text = title_text
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(title)

	if not description_text.is_empty():
		var description := Label.new()
		description.text = description_text
		description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		content.add_child(description)

	return content


func _refresh() -> void:
	_refresh_episode_selection()
	_refresh_external_contacts()
	_refresh_agents()
	_refresh_equipment()
	_refresh_records()
	_refresh_log()


func _refresh_external_contacts() -> void:
	_clear_children(_contact_list)
	var currency := Label.new()
	currency.text = "잔향 파편: %d" % GameState.get_echo_fragments()
	_contact_list.add_child(currency)
	for faction in [
		{"id": "rumor_market", "name": "소문시장"},
		{"id": "mage_society", "name": "마도회"},
		{"id": "exorcist_lineage", "name": "퇴마사 계열"}
	]:
		var label := Label.new()
		label.text = "%s · %s (%d)" % [faction.name, GameState.get_faction_tier_label(faction.id), GameState.get_faction_relation(faction.id)]
		_contact_list.add_child(label)
	var market := Button.new()
	market.text = "소문시장 방문 · 장비와 소모품 구매"
	market.pressed.connect(func() -> void:
		GameState.set_current_scene_path(GameState.SCENE_MARKET)
		GameState.save_game()
		get_tree().change_scene_to_file(GameState.SCENE_MARKET)
	)
	_contact_list.add_child(market)
	var mage := Button.new()
	mage.text = "마도회 분석 의뢰 전달 (최초 1회)"
	mage.disabled = GameState.get_completed_faction_requests().has("request_mage_first_analysis")
	mage.pressed.connect(func() -> void:
		GameState.complete_faction_request("request_mage_first_analysis", "mage_society")
		GameState.save_game()
		_refresh_external_contacts()
	)
	_contact_list.add_child(mage)
	var exorcist := Button.new()
	exorcist.text = "퇴마사 현장 방호 의뢰 전달 (최초 1회)"
	exorcist.disabled = GameState.get_completed_faction_requests().has("request_exorcist_first_guard")
	exorcist.pressed.connect(func() -> void:
		GameState.complete_faction_request("request_exorcist_first_guard", "exorcist_lineage")
		GameState.save_game()
		_refresh_external_contacts()
	)
	_contact_list.add_child(exorcist)
	_clear_children(_consumable_list)
	var loadout_title := Label.new()
	loadout_title.text = "사건 반입 소모품 · 최대 2종, 종류별 3개"
	_consumable_list.add_child(loadout_title)
	var inventory := GameState.get_consumable_inventory()
	var loadout := GameState.get_consumable_loadout()
	for item in GameState.get_market_catalog():
		if String(item.get("category", "")) != "consumable":
			continue
		var item_id := String(item.get("id", ""))
		var owned := int(inventory.get(item_id, 0))
		if owned <= 0:
			continue
		var button := Button.new()
		button.text = "%s · 보유 %d / 반입 %d" % [String(item.get("name", item_id)), owned, int(loadout.get(item_id, 0))]
		button.pressed.connect(_cycle_consumable_loadout.bind(item_id, owned))
		_consumable_list.add_child(button)


func _cycle_consumable_loadout(item_id: String, owned: int) -> void:
	var current := int(GameState.get_consumable_loadout().get(item_id, 0))
	var next := 0 if current >= owned else current + 1
	if not GameState.set_consumable_loadout(item_id, next):
		_status_label.text = "반입 소모품은 최대 2종까지 선택할 수 있습니다."
	GameState.save_game()
	_refresh_external_contacts()


func _refresh_episode_selection() -> void:
	_clear_children(_episode_list)
	for entry in GameState.get_preparation_episode_entries():
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var episode_path := String(entry.get("path", ""))
		var episode_id := String(entry.get("id", ""))
		var active := episode_id == GameState.get_current_episode_id()
		var button := Button.new()
		button.text = "%s: %s" % ["선택됨" if active else "사건 선택", String(entry.get("title", "사건"))]
		button.disabled = active
		button.pressed.connect(_select_episode.bind(episode_path))
		_episode_list.add_child(button)

		var summary := Label.new()
		summary.text = String(entry.get("summary", ""))
		summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_episode_list.add_child(summary)


func _select_episode(episode_path: String) -> void:
	if not GameState.start_episode_from_preparation(episode_path):
		_status_label.text = "사건 데이터를 불러오지 못했습니다."
		return
	GameState.save_game()
	get_tree().reload_current_scene()


func _refresh_equipment() -> void:
	var equipped_entries := GameState.get_equipped_equipment_entries()
	if equipped_entries.is_empty():
		_equipped_label.text = "장착 장비: 없음"
	else:
		var names: Array = []
		for item in equipped_entries:
			if typeof(item) == TYPE_DICTIONARY:
				names.append(String(item.get("name", "")))
		_equipped_label.text = "장착 장비: %s" % ", ".join(names)

	_modifier_label.text = "적용될 조사 보정: %s" % GameState.get_next_investigation_modifier_text()
	_clear_children(_equipment_list)

	var equipment_entries := GameState.get_unlocked_equipment_entries()
	if equipment_entries.is_empty():
		_equipment_list.add_child(_make_label("- 해금된 장비가 없습니다. 회수 결과에서 연구 보상을 먼저 확보해야 합니다."))
		return

	for item in equipment_entries:
		if typeof(item) != TYPE_DICTIONARY:
			continue
		var equipment_id := String(item.get("id", ""))
		var equipped := GameState.has_equipped_item(equipment_id)
		var button := Button.new()
		button.text = "%s: %s" % ["장착 해제" if equipped else "장착", String(item.get("name", equipment_id))]
		button.pressed.connect(_toggle_equipment.bind(equipment_id))
		_equipment_list.add_child(button)

		var description := Label.new()
		description.text = "%s\n획득처: %s\n활용처: 조사/미니게임 보조\n다음 조사 연결: %s" % [
			String(item.get("description", "")),
			_make_equipment_source_text(item),
			String(item.get("next_investigation_modifier", ""))
		]
		description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_equipment_list.add_child(description)


func _refresh_records() -> void:
	_clear_children(_record_list)
	var records := GameState.get_unlocked_record_entries()
	if records.is_empty():
		_record_list.add_child(_make_label("- 참고 가능한 해금 기록물이 없습니다."))
		return

	for record in records:
		if typeof(record) != TYPE_DICTIONARY:
			continue
		var effect := String(record.get("next_investigation_effect", "다음 조사 전 규칙 확인용 참고 기록입니다."))
		_record_list.add_child(_make_label("- %s\n  %s\n  획득처: %s\n  활용처: 사건 규칙 대조 / 다음 조사 영향: %s" % [
			String(record.get("title", "")),
			String(record.get("description", "")),
			_make_record_source_text(record),
			effect
		]))


func _refresh_log() -> void:
	_clear_children(_log_list)
	for line in GameState.get_preparation_log_lines():
		_log_list.add_child(_make_label("- %s" % String(line)))
	for line in GameState.get_episode_log_lines():
		_log_list.add_child(_make_label("- 로그: %s" % String(line)))


func _toggle_equipment(equipment_id: String) -> void:
	if GameState.has_equipped_item(equipment_id):
		GameState.unequip_item(equipment_id)
	else:
		GameState.equip_item(equipment_id)
	_refresh()


func _start_investigation() -> void:
	if not GameState.can_start_mission_with_agents():
		_status_label.text = GameState.get_agent_selection_status_text()
		return

	GameState.set_current_scene_path(GameState.SCENE_INVESTIGATION)
	GameState.save_game()
	get_tree().change_scene_to_file(GameState.SCENE_INVESTIGATION)


func _make_equipment_source_text(item: Dictionary) -> String:
	var reward_id := String(item.get("unlock_reward_id", "")).strip_edges()
	if reward_id.is_empty():
		return "완료 사건 회수 보상"
	return "연구 보상 %s" % reward_id


func _make_record_source_text(record: Dictionary) -> String:
	var episode_id := String(record.get("episode_id", "")).strip_edges()
	var source_result := String(record.get("source_result", "")).strip_edges()
	var parts: Array = []
	if not episode_id.is_empty():
		parts.append(episode_id)
	if not source_result.is_empty():
		parts.append(source_result)
	if parts.is_empty():
		return "완료 사건 보고서"
	return " / ".join(parts)


func _add_scene_button(parent: Control, label: String, scene_path: String) -> void:
	var button := Button.new()
	button.text = label
	button.pressed.connect(func() -> void:
		GameState.set_current_scene_path(scene_path)
		GameState.save_game()
		get_tree().change_scene_to_file(scene_path)
	)
	parent.add_child(button)


func _make_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label


func _clear_children(parent: Node) -> void:
	if parent == null:
		return

	for child in parent.get_children():
		child.queue_free()
