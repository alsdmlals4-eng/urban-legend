# 사건 준비 화면에서 요원, 장비, 기록물, 로그 안내를 확인하고 조사 시작을 연결한다.
extends Control

const ThemeFactory = preload("res://scripts/ui/ui_theme_factory.gd")
const LogGuideScript = preload("res://scripts/ui/log_guide.gd")
const LogTutorialCatalog = preload("res://scripts/ui/log_tutorial_catalog.gd")
const AgentSelectionCardScene = preload("res://scenes/ui/agent_selection_card.tscn")
const SCHEDULE_ACTIVITIES: Array[Dictionary] = [
	{"id": "investigation", "label": "현장 조사"},
	{"id": "rest", "label": "대기·회복"}
]

var _equipment_list: VBoxContainer
var _episode_list: VBoxContainer
var _equipped_label: Label
var _modifier_label: Label
var _record_list: VBoxContainer
var _log_guide: LogGuide
var _start_button: Button
var _status_label: Label
var _agent_list: VBoxContainer
var _agent_detail_panel: PanelContainer
var _agent_detail_label: Label
var _selected_detail_agent_id := ""
var _contact_list: VBoxContainer
var _consumable_list: VBoxContainer
var _campaign_day_label: Label
var _schedule_list: VBoxContainer
var _current_case_label: Label


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
	_add_schedule_panel(root)
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


func _add_header(parent: Control) -> void:
	var title := Label.new()
	title.text = "사건 준비"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	parent.add_child(title)


func _add_schedule_panel(parent: Control) -> void:
	var content := _add_section(parent, "오늘의 일정", "현재 반일의 업무만 정합니다. 결과를 확인한 뒤 다음 반일 일정이 열립니다.")
	_campaign_day_label = Label.new()
	_campaign_day_label.name = "CampaignDayLabel"
	_campaign_day_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(_campaign_day_label)

	_schedule_list = VBoxContainer.new()
	_schedule_list.name = "ScheduleList"
	_schedule_list.add_theme_constant_override("separation", 8)
	content.add_child(_schedule_list)


func _add_current_case_panel(parent: Control) -> void:
	var content := _add_section(parent, "현재 사건", "지금 조사 준비를 적용할 사건입니다.")

	_current_case_label = Label.new()
	_current_case_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_current_case_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(_current_case_label)


func _add_episode_panel(parent: Control) -> void:
	var content := _add_section(parent, "사건 선택", "두 사건 중 이번에 조사할 대상을 고릅니다.")

	_episode_list = VBoxContainer.new()
	_episode_list.add_theme_constant_override("separation", 6)
	content.add_child(_episode_list)


func _add_agent_panel(parent: Control) -> void:
	var content := _add_section(parent, "요원 편성", "임무에 투입할 요원 2~3명을 선택하고 상세 정보를 확인합니다.")

	_agent_list = VBoxContainer.new()
	_agent_list.name = "AgentList"
	_agent_list.add_theme_constant_override("separation", 8)
	content.add_child(_agent_list)

	_agent_detail_panel = PanelContainer.new()
	_agent_detail_panel.name = "AgentDetailPanel"
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
	var all_agent_ids := _get_all_agent_ids()
	var schedule_ready := GameState.is_campaign_schedule_complete(all_agent_ids)
	var phase := GameState.get_campaign_slot_phase()
	var operation := GameState.get_active_campaign_operation()
	if _start_button != null:
		_start_button.disabled = false
		if phase == "result":
			_start_button.text = "결과 확인 후 다음 일정으로"
		elif String(operation.get("status", "")) == "suspended":
			_start_button.text = "현장 조사 재개"
		else:
			_start_button.text = "현재 일정 실행"
			_start_button.disabled = not GameState.can_start_mission_with_agents() or not schedule_ready

	if _status_label != null:
		if phase == "result":
			_status_label.text = "현재 반일 결과를 확인했습니다. 다음 일정으로 이동할 수 있습니다."
		elif String(operation.get("status", "")) == "suspended":
			_status_label.text = "현장 진행이 보존되어 있습니다. 완료 전에는 일정과 사건을 변경할 수 없습니다."
		elif GameState.can_start_mission_with_agents() and schedule_ready:
			_status_label.text = "실행 가능: 요원 %d명의 현재 반일 일정이 정해졌습니다." % selected_count
		elif GameState.can_start_mission_with_agents():
			_status_label.text = "전 요원의 현재 반일 일정을 정하세요."
		else:
			_status_label.text = GameState.get_agent_selection_status_text()


func _add_agent_card(parent: Control, agent: Dictionary) -> void:
	var agent_id := String(agent.get("id", ""))
	if agent_id.is_empty():
		return

	var selected := GameState.is_agent_selected(agent_id)
	var abilities := {}
	for key in GameState.ABILITY_KEYS:
		abilities[key] = GameState.get_agent_ability(agent_id, key)

	var card := AgentSelectionCardScene.instantiate()
	if card == null:
		return
	parent.add_child(card)
	card.configure(agent, {
		"selected": selected,
		"selection_disabled": not selected and GameState.get_selected_agent_ids().size() >= GameState.MAX_SELECTED_AGENTS,
		"current_hp": GameState.get_agent_current_hp(agent_id),
		"max_hp": GameState.get_agent_max_hp(agent_id),
		"current_mental": GameState.get_agent_current_mental(agent_id),
		"max_mental": GameState.get_agent_max_mental(agent_id),
		"abilities": abilities,
		"ability_labels": GameState.ABILITY_LABELS
	})
	card.selection_requested.connect(func(requested_agent_id: String) -> void:
		if GameState.is_agent_selected(requested_agent_id):
			GameState.deselect_agent(requested_agent_id)
		else:
			GameState.select_agent(requested_agent_id)
		_refresh_agents()
	)
	card.detail_requested.connect(_show_agent_detail)


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
	var content := _add_section(parent, "로그 · 준비 지원", "괴담기록국 AI가 전자기기 데스크에서 편성과 외부 접점을 함께 점검합니다.")
	_log_guide = LogGuideScript.new()
	_log_guide.set_compact(true)
	content.add_child(_log_guide)


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
	_refresh_schedule()
	_refresh_episode_selection()
	_refresh_external_contacts()
	_refresh_agents()
	_refresh_equipment()
	_refresh_records()
	_refresh_log()


func _refresh_schedule() -> void:
	if _campaign_day_label == null or _schedule_list == null:
		return
	var campaign := GameState.get_campaign_snapshot()
	var time_slot := String(campaign.get("time_slot", "morning"))
	var slot_label := "오전" if time_slot == "morning" else "오후"
	var phase := String(campaign.get("slot_phase", "planning"))
	_campaign_day_label.text = "운영 %d일차 %s / 최대 %d일 · 현재 단계: %s" % [
		int(campaign.get("day", 1)),
		slot_label,
		int(campaign.get("max_days", 10)),
		{"planning": "일정 선택", "in_progress": "진행 중", "result": "결과 확인"}.get(phase, phase)
	]
	_clear_children(_schedule_list)
	if phase == "result":
		_schedule_list.add_child(_make_label(_make_slot_result_text(GameState.get_campaign_slot_result(), slot_label)))
		return
	if phase == "in_progress":
		var operation := GameState.get_active_campaign_operation()
		_schedule_list.add_child(_make_label("%s 현장 조사가 %s 상태입니다.\n사건: %s" % [slot_label, "일시 중단" if String(operation.get("status", "")) == "suspended" else "진행 중", String(operation.get("case_id", ""))]))
		return
	for agent in GameState.get_agents():
		if typeof(agent) != TYPE_DICTIONARY:
			continue
		var agent_id := String(agent.get("id", ""))
		if agent_id.is_empty():
			continue
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 8)
		_schedule_list.add_child(row)

		var name_label := Label.new()
		name_label.text = String(agent.get("name", agent_id))
		name_label.custom_minimum_size.x = 140
		row.add_child(name_label)

		var schedule := GameState.get_campaign_agent_schedule(agent_id)
		var picker := OptionButton.new()
		picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		picker.add_item("%s 미정" % slot_label)
		picker.set_item_metadata(0, "")
		var selected_index := 0
		for activity in SCHEDULE_ACTIVITIES:
			if String(activity.get("id", "")) == "investigation" and not GameState.is_agent_selected(agent_id):
				continue
			var item_index := picker.item_count
			picker.add_item("%s · %s" % [slot_label, String(activity.get("label", ""))])
			picker.set_item_metadata(item_index, String(activity.get("id", "")))
			if String(schedule.get(time_slot, "")) == String(activity.get("id", "")):
				selected_index = item_index
		for request in GameState.get_faction_request_board():
			if typeof(request) != TYPE_DICTIONARY or String(request.get("status", "")) != "accepted" or String(request.get("kind", "")) != "dispatch":
				continue
			var activity_id := "request:%s" % String(request.get("instance_id", ""))
			var request_index := picker.item_count
			picker.add_item("의뢰 · %s" % String(request.get("title", "외부 의뢰")))
			picker.set_item_metadata(request_index, activity_id)
			if String(schedule.get(time_slot, "")) == activity_id:
				selected_index = request_index
		picker.select(selected_index)
		picker.item_selected.connect(func(index: int) -> void:
			var activity_id := String(picker.get_item_metadata(index))
			if not activity_id.is_empty():
				_set_schedule_activity(agent_id, time_slot, activity_id)
		)
		row.add_child(picker)
	_schedule_list.add_child(_make_label("일상 교류·괴이 연구·장비 정비는 실제 콘텐츠 연결 후 사용할 수 있습니다."))


func _set_schedule_activity(agent_id: String, time_slot: String, activity_id: String) -> void:
	if not GameState.set_campaign_schedule(agent_id, time_slot, activity_id):
		if _status_label != null:
			_status_label.text = "일정 항목을 저장하지 못했습니다."
		return
	GameState.save_game()
	_refresh()


func _get_all_agent_ids() -> Array:
	var result: Array = []
	for agent in GameState.get_agents():
		if typeof(agent) == TYPE_DICTIONARY:
			var agent_id := String(agent.get("id", ""))
			if not agent_id.is_empty():
				result.append(agent_id)
	return result


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
	var board_title := Label.new()
	board_title.text = "반일 의뢰 게시판 · 수락한 의뢰는 완료 또는 취소까지 유지됩니다."
	_contact_list.add_child(board_title)
	for request in GameState.get_faction_request_board():
		if typeof(request) == TYPE_DICTIONARY:
			_add_request_card(_contact_list, request)
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
	var planned_case_id := GameState.get_campaign_planned_case()
	var phase := GameState.get_campaign_slot_phase()
	var has_investigation := _selected_team_has_investigation()
	var campaign := GameState.get_campaign_snapshot()
	var cases: Dictionary = campaign.get("cases", {})
	var emergency_case_id := String(campaign.get("emergency_case_id", ""))
	if _current_case_label != null:
		_current_case_label.text = "계획 사건: %s\n%s" % [GameState.get_current_episode_title() if not planned_case_id.is_empty() else "선택되지 않음", GameState.get_project_core_sentence()]
	for entry in GameState.get_preparation_episode_entries():
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var episode_path := String(entry.get("path", ""))
		var episode_id := String(entry.get("id", ""))
		var active := episode_id == planned_case_id
		var case_state: Dictionary = cases.get(episode_id, {})
		var resolved := String(case_state.get("resolution_state", "unresolved")) == "resolved"
		var emergency_locked := not emergency_case_id.is_empty() and episode_id != emergency_case_id
		var button := Button.new()
		button.text = "%s: %s" % ["해결 완료" if resolved else ("선택됨" if active else "사건 선택"), String(entry.get("title", "사건"))]
		button.disabled = resolved or emergency_locked or active or phase != "planning" or not has_investigation
		button.tooltip_text = "현장 편성 요원을 조사 일정에 배치하면 선택할 수 있습니다." if not has_investigation else ""
		button.pressed.connect(_select_episode.bind(episode_path, episode_id))
		_episode_list.add_child(button)

		var summary := Label.new()
		summary.text = String(entry.get("summary", ""))
		summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_episode_list.add_child(summary)


func _select_episode(episode_path: String, episode_id: String) -> void:
	if not GameState.set_campaign_planned_case(episode_id):
		_status_label.text = "현재 캠페인 상태에서는 이 사건을 선택할 수 없습니다."
		return
	if not GameState.start_episode_from_preparation(episode_path):
		GameState.set_campaign_planned_case("")
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
	if _log_guide.is_sequence_active():
		return
	if not GameState.has_seen_log_tutorial("preparation_agents"):
		_log_guide.present_tutorial("preparation_agents", true)
		_log_guide.sequence_finished.connect(func() -> void: GameState.claim_log_tutorial("preparation_agents"), CONNECT_ONE_SHOT)
		return
	if not GameState.has_seen_log_tutorial("preparation_contacts"):
		_log_guide.present_tutorial("preparation_contacts", true)
		_log_guide.sequence_finished.connect(func() -> void: GameState.claim_log_tutorial("preparation_contacts"), CONNECT_ONE_SHOT)
		return
	var lines: Array = []
	for line in GameState.get_preparation_log_lines():
		lines.append({"text": String(line), "expression": "normal"})
	for line in GameState.get_episode_log_lines():
		lines.append({"text": String(line), "expression": "focus"})
	if lines.is_empty():
		_log_guide.show_compact_hint(LogTutorialCatalog.get_repeat_hint("preparation_agents"))
	else:
		_log_guide.present_lines(lines.slice(0, 4), "normal", false)


func _toggle_equipment(equipment_id: String) -> void:
	if GameState.has_equipped_item(equipment_id):
		GameState.unequip_item(equipment_id)
	else:
		GameState.equip_item(equipment_id)
	_refresh()


func _start_investigation() -> void:
	var phase := GameState.get_campaign_slot_phase()
	if phase == "result":
		GameState.acknowledge_campaign_slot_result()
		GameState.save_game()
		get_tree().reload_current_scene()
		return
	var operation := GameState.get_active_campaign_operation()
	if String(operation.get("status", "")) == "suspended":
		GameState.resume_campaign_operation()
		GameState.set_current_scene_path(GameState.SCENE_INVESTIGATION)
		GameState.save_game()
		get_tree().change_scene_to_file(GameState.SCENE_INVESTIGATION)
		return
	if not GameState.can_start_mission_with_agents():
		_status_label.text = GameState.get_agent_selection_status_text()
		return
	if not GameState.is_campaign_schedule_complete(_get_all_agent_ids()):
		_status_label.text = "전 요원의 현재 반일 일정을 먼저 정하세요."
		return
	if not _selected_team_has_investigation():
		var schedule_result := GameState.resolve_non_investigation_campaign_slot(_get_all_agent_ids())
		if schedule_result.has("error"):
			_status_label.text = String(schedule_result.get("error", "일정 처리에 실패했습니다."))
		else:
			get_tree().reload_current_scene()
		return
	var slot := String(GameState.get_campaign_snapshot().get("time_slot", "morning"))
	for agent_id in GameState.get_selected_agent_ids():
		if String(GameState.get_campaign_agent_schedule(String(agent_id)).get(slot, "")) != "investigation":
			_status_label.text = "현장 편성 요원은 모두 조사 일정에 배치해야 합니다."
			return
	var planned_case_id := GameState.get_campaign_planned_case()
	if planned_case_id.is_empty() or not GameState.begin_campaign_operation(planned_case_id):
		_status_label.text = "조사할 사건을 선택하세요."
		return

	GameState.set_current_scene_path(GameState.SCENE_INVESTIGATION)
	GameState.save_game()
	get_tree().change_scene_to_file(GameState.SCENE_INVESTIGATION)


func _selected_team_has_investigation() -> bool:
	var slot := String(GameState.get_campaign_snapshot().get("time_slot", "morning"))
	for agent_id in GameState.get_selected_agent_ids():
		if String(GameState.get_campaign_agent_schedule(String(agent_id)).get(slot, "")) == "investigation":
			return true
	return false


func _add_request_card(parent: Control, request: Dictionary) -> void:
	var panel := PanelContainer.new()
	parent.add_child(panel)
	var content := VBoxContainer.new()
	panel.add_child(content)
	var status := String(request.get("status", ""))
	if status in ["declined", "canceled"]:
		content.add_child(_make_label("빈 의뢰 슬롯 · 다음 반일 갱신 시 보충됩니다."))
		return
	var faction_names := {"rumor_market": "소문시장", "mage_society": "마도회", "exorcist_lineage": "퇴마사 계열"}
	var ability_key := String(request.get("ability_key", ""))
	content.add_child(_make_label("%s · %s\n%s\n유형: %s / 요구: %s / 난이도 %d / 상태: %s" % [faction_names.get(String(request.get("faction_id", "")), "외부 세력"), String(request.get("title", "의뢰")), String(request.get("description", "")), "반일 파견" if String(request.get("kind", "")) == "dispatch" else "회수 행동", GameState.ABILITY_LABELS.get(ability_key, ability_key), int(request.get("difficulty", 0)), String(request.get("status", "offered"))]))
	var row := HBoxContainer.new()
	content.add_child(row)
	var instance_id := String(request.get("instance_id", ""))
	match status:
		"offered":
			var accept := Button.new()
			accept.text = "수락"
			accept.pressed.connect(_accept_request.bind(instance_id))
			row.add_child(accept)
			var decline := Button.new()
			decline.text = "거부"
			decline.pressed.connect(_decline_request.bind(instance_id))
			row.add_child(decline)
		"accepted":
			var cancel := Button.new()
			cancel.text = "취소 · 관계 -1"
			cancel.pressed.connect(_cancel_request.bind(instance_id))
			row.add_child(cancel)


func _accept_request(instance_id: String) -> void:
	GameState.accept_faction_request(instance_id)
	GameState.save_game()
	_refresh()


func _decline_request(instance_id: String) -> void:
	GameState.decline_faction_request(instance_id)
	GameState.save_game()
	_refresh()


func _cancel_request(instance_id: String) -> void:
	GameState.cancel_faction_request(instance_id)
	GameState.save_game()
	_refresh()


func _make_slot_result_text(result: Dictionary, slot_label: String) -> String:
	var lines: Array = ["%s 일정 결과" % slot_label]
	for entry in result.get("results", []):
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		if entry.has("check"):
			var check: Dictionary = entry.get("check", {})
			lines.append("의뢰 판정: 1d100 %d / 성공률 %d%% · %s · 잔향 +%d · 관계 +%d" % [int(check.get("roll", 0)), int(check.get("chance", 0)), String(check.get("grade", "failure")), int(entry.get("fragments", 0)), int(entry.get("relation", 0))])
			var result_text := String(entry.get("result_text", "")).strip_edges()
			if not result_text.is_empty():
				lines.append(result_text)
		else:
			lines.append(String(entry.get("message", "일정을 마쳤습니다.")))
	if lines.size() == 1:
		lines.append("현장 조사 결과가 기록되었습니다.")
	return "\n".join(lines)


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
