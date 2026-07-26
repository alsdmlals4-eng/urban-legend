class_name AnnualMvp002Scene
extends Control

const BaseData = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_data.gd")
const ExtensionData = preload("res://scripts/poc/annual_mvp_002/annual_mvp_002_data.gd")
const State = preload("res://scripts/poc/annual_mvp_002/annual_mvp_002_state.gd")
const Planner = preload("res://scripts/poc/annual_mvp_002/annual_mvp_002_planner.gd")
const Adapter = preload("res://scripts/poc/annual_mvp_002/annual_mvp_002_incident_adapter.gd")
const ThemeFactory = preload("res://scripts/ui/ui_theme_factory.gd")
const CaseData = preload("res://scripts/poc/core_mvp_001/core_mvp_001_case_data.gd")
const CoreScene = preload("res://scenes/poc/annual_mvp_001/annual_mvp_001_core_scene.tscn")
const SaveData = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_save_data.gd")

const BASE_CONFIG_PATH := "res://data/poc/annual_mvp_001/spring_vertical_slice.json"
const EXTENSION_CONFIG_PATH := "res://data/poc/annual_mvp_002/companion_equipment_research.json"
const COMPETENCY_LABELS := {
	"observation": "관찰",
	"analysis": "분석",
	"field_response": "현장 대응",
	"interpersonal": "대인 대응",
}

var _config: Dictionary = {}
var _extension_config: Dictionary = {}
var _companions: Dictionary = {}
var _unique_skills: Dictionary = {}
var _support_skills: Dictionary = {}
var _equipment: Dictionary = {}
var _modules: Dictionary = {}
var _research_nodes: Dictionary = {}
var _state := State.new()
var _planner := Planner.new()
var _adapter := Adapter.new()

var _panels: Dictionary = {}
var _phase_label: Label
var _week_label: Label
var _stats_label: Label
var _feedback_label: Label
var _activity_preview_label: Label
var _week_causal_summary_label: Label
var _support_status_label: Label
var _incident_host: VBoxContainer
var _equipment_option: OptionButton
var _module_option: OptionButton
var _research_node_option: OptionButton
var _research_resource_label: Label
var _companion_buttons: Dictionary = {}
var _support_options: Dictionary = {}

var _selected_companion_ids: Array[String] = []
var _support_by_companion: Dictionary = {}
var _selected_equipment_id := ""
var _selected_module_ids: Array[String] = []
var _auto_rest_confirmation_pending := false
var _ui_syncing := false


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	theme = ThemeFactory.create_theme()
	_config = BaseData.load_config(BASE_CONFIG_PATH)
	_extension_config = ExtensionData.load_config(EXTENSION_CONFIG_PATH)
	_companions = ExtensionData.index_by_id(_extension_config.get("companions", []) as Array)
	_unique_skills = ExtensionData.index_by_id(_extension_config.get("unique_skills", []) as Array)
	_support_skills = ExtensionData.index_by_id(_extension_config.get("support_skills", []) as Array)
	_equipment = ExtensionData.index_by_id(_extension_config.get("equipment", []) as Array)
	_modules = ExtensionData.index_by_id(_extension_config.get("modules", []) as Array)
	_research_nodes = ExtensionData.index_by_id(_extension_config.get("research_nodes", []) as Array)
	_planner.configure(_dictionary_array(_config.get("activities", []) as Array), 7)
	_build_ui()
	var started: Dictionary = _state.start(_config, 2201)
	if not bool(started.get("ok", false)):
		_feedback_label.text = String(started.get("error", "ANNUAL-MVP-002 초기화 실패"))
	_render()


func debug_snapshot() -> Dictionary:
	return _state.get_snapshot()


func debug_set_plan(values: Array) -> Dictionary:
	var response: Dictionary = _planner.set_plan(_string_array(values))
	_feedback_label.text = String(response.get("error", ""))
	_render()
	return response


func debug_plan_ids() -> Array[String]:
	return _string_array(_planner.preview().get("activity_ids", []))


func debug_undo_plan() -> Dictionary:
	var response: Dictionary = _planner.undo()
	_feedback_label.text = String(response.get("error", ""))
	_auto_rest_confirmation_pending = false
	_render()
	return response


func debug_clear_plan() -> Dictionary:
	var response: Dictionary = _planner.clear()
	_feedback_label.text = String(response.get("error", ""))
	_auto_rest_confirmation_pending = false
	_render()
	return response


func debug_copy_last_week() -> Dictionary:
	var response: Dictionary = _planner.copy_last_week(_state.get_snapshot().get("last_week_result", {}) as Dictionary)
	_feedback_label.text = String(response.get("error", ""))
	_auto_rest_confirmation_pending = false
	_render()
	return response


func debug_save_template(slot: int) -> Dictionary:
	var response: Dictionary = _planner.save_template(slot)
	if bool(response.get("ok", false)):
		_state.save_schedule_template(slot, debug_plan_ids())
	_feedback_label.text = String(response.get("error", ""))
	_render()
	return response


func debug_apply_template(slot: int) -> Dictionary:
	var response: Dictionary = _planner.apply_template(slot)
	_feedback_label.text = String(response.get("error", ""))
	_auto_rest_confirmation_pending = false
	_render()
	return response


func debug_confirm() -> void:
	if String(_state.get_snapshot().get("phase", "")) != "WEEK_PLANNING":
		return
	var plan := debug_plan_ids()
	var result: Dictionary
	if _auto_rest_confirmation_pending:
		result = _state.commit_week_with_auto_rest(plan)
	else:
		result = _state.commit_week(plan)
		if bool(result.get("requires_auto_rest_confirmation", false)):
			_auto_rest_confirmation_pending = true
			_feedback_label.text = String(result.get("error", "남은 일수는 자동 휴식 처리됩니다."))
			_render()
			return
	if bool(result.get("ok", false)):
		_planner.configure(_dictionary_array(_config.get("activities", []) as Array), 7)
		_auto_rest_confirmation_pending = false
	_feedback_label.text = String(result.get("error", ""))
	_render()


func debug_save_run(path: String = SaveData.SAVE_PATH) -> Dictionary:
	var payload: Dictionary = _state.build_save_payload()
	if payload.is_empty():
		return _ui_error("현재 단계에서는 저장할 수 없습니다.")
	var error := SaveData.write_payload(payload, path)
	if error != OK:
		return _ui_error("연도제 저장에 실패했습니다: %s" % error_string(error))
	_feedback_label.text = "ANNUAL-MVP-002 진행을 저장했습니다."
	_render()
	return {"ok": true, "error": "", "state_changed": false}


func debug_load_run(path: String = SaveData.SAVE_PATH) -> Dictionary:
	var payload: Dictionary = SaveData.read_payload(path)
	if payload.is_empty():
		return _ui_error("불러올 ANNUAL-MVP-002 저장이 없습니다.")
	var restored: Dictionary = _state.restore(_config, payload)
	if not bool(restored.get("ok", false)):
		return _ui_error(String(restored.get("error", "저장을 복구할 수 없습니다.")))
	_sync_runtime_from_state()
	_feedback_label.text = "ANNUAL-MVP-002 진행을 불러왔습니다."
	_render()
	return restored


func debug_award_research_resources(delta: Dictionary) -> Dictionary:
	var response: Dictionary = _state.apply_research_resource_reward(delta)
	_feedback_label.text = String(response.get("error", ""))
	_render()
	return response


func debug_start_research(node_id: String) -> Dictionary:
	var response: Dictionary = _state.start_research(node_id)
	_feedback_label.text = String(response.get("error", ""))
	_render()
	return response


func debug_advance_research(node_id: String, amount: int = 1) -> Dictionary:
	var response: Dictionary = _state.advance_research(node_id, amount)
	_feedback_label.text = String(response.get("error", ""))
	_render()
	return response


func debug_cancel_research(node_id: String) -> Dictionary:
	var response: Dictionary = _state.cancel_research(node_id)
	_feedback_label.text = String(response.get("error", ""))
	_render()
	return response


func debug_force_preparation_phase() -> void:
	var guard := 0
	while String(_state.get_snapshot().get("phase", "")) != "PREPARATION" and guard < 16:
		guard += 1
		var phase := String(_state.get_snapshot().get("phase", ""))
		match phase:
			"WEEK_RESULT":
				_state.acknowledge_week_result()
			"WEEK_PLANNING":
				var seven_rest: Array[String] = []
				for _day in range(7):
					seven_rest.append("annual001_activity_rest")
				_state.commit_week(seven_rest)
			"DEPLOYMENT_DECISION":
				_state.choose_deployment_decision("annual001_decision_deploy")
			_:
				break
	_render()


func debug_toggle_companion(companion_id: String, enabled: bool) -> Dictionary:
	if not _companions.has(companion_id):
		return _ui_error("알 수 없는 동료입니다.")
	var candidate := _selected_companion_ids.duplicate()
	var support_candidate := _support_by_companion.duplicate(true)
	if enabled:
		if candidate.has(companion_id):
			return {"ok": true, "error": "", "state_changed": false}
		if candidate.size() >= 2:
			return _ui_error("동료는 최대 2명까지 편성할 수 있습니다.")
		candidate.append(companion_id)
		var public_ids := (_companions[companion_id] as Dictionary).get("public_skill_ids", []) as Array
		for public_id_value in public_ids:
			var public_id := String(public_id_value)
			if String((_support_skills.get(public_id, {}) as Dictionary).get("runtime_status", "")) == "ACTIVE":
				support_candidate[companion_id] = public_id
				break
	else:
		candidate.erase(companion_id)
		support_candidate.erase(companion_id)
	var response: Dictionary = _state.configure_loadout_v2(
		candidate,
		support_candidate,
		_selected_equipment_id,
		_selected_module_ids
	)
	if bool(response.get("ok", false)):
		_selected_companion_ids = candidate
		_support_by_companion = support_candidate
	_feedback_label.text = String(response.get("error", ""))
	_render()
	return response


func debug_selected_companions() -> Array[String]:
	return _selected_companion_ids.duplicate()


func debug_set_support(companion_id: String, support_id: String) -> Dictionary:
	if not _selected_companion_ids.has(companion_id):
		return _ui_error("먼저 동료를 선택해야 합니다.")
	var companion := _companions.get(companion_id, {}) as Dictionary
	if not support_id.is_empty():
		if not (companion.get("public_skill_ids", []) as Array).has(support_id):
			return _ui_error("해당 동료가 사용할 수 없는 공용 지원입니다.")
		var support := _support_skills.get(support_id, {}) as Dictionary
		if String(support.get("runtime_status", "")) != "ACTIVE":
			return _ui_error("이 지원은 후속 CORE hook이 필요해 현재 선택할 수 없습니다.")
	var candidate := _support_by_companion.duplicate(true)
	if support_id.is_empty():
		candidate.erase(companion_id)
	else:
		candidate[companion_id] = support_id
	var response: Dictionary = _state.configure_loadout_v2(
		_selected_companion_ids,
		candidate,
		_selected_equipment_id,
		_selected_module_ids
	)
	if bool(response.get("ok", false)):
		_support_by_companion = candidate
	_feedback_label.text = String(response.get("error", ""))
	_render()
	return response


func debug_set_equipment(equipment_id: String) -> Dictionary:
	if not equipment_id.is_empty() and not _equipment.has(equipment_id):
		return _ui_error("알 수 없는 주 장비입니다.")
	var response: Dictionary = _state.configure_loadout_v2(
		_selected_companion_ids,
		_support_by_companion,
		equipment_id,
		[]
	)
	if bool(response.get("ok", false)):
		_selected_equipment_id = equipment_id
		_selected_module_ids.clear()
		_refresh_module_option()
	_feedback_label.text = String(response.get("error", ""))
	_render()
	return response


func debug_set_module(module_id: String) -> Dictionary:
	var modules: Array[String] = []
	if not module_id.is_empty():
		modules.append(module_id)
	var response: Dictionary = _state.configure_loadout_v2(
		_selected_companion_ids,
		_support_by_companion,
		_selected_equipment_id,
		modules
	)
	if bool(response.get("ok", false)):
		_selected_module_ids = modules
	_feedback_label.text = String(response.get("error", ""))
	_render()
	return response


func debug_loadout_snapshot() -> Dictionary:
	return {
		"selected_companion_ids": _selected_companion_ids.duplicate(),
		"support_by_companion": _support_by_companion.duplicate(true),
		"equipment_id": _selected_equipment_id,
		"module_ids": _selected_module_ids.duplicate(),
	}


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color("090d13")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_right", 24)
	margin.add_theme_constant_override("margin_bottom", 20)
	add_child(margin)
	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(scroll)
	var root_column := VBoxContainer.new()
	root_column.custom_minimum_size = Vector2(920, 0)
	root_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root_column.add_theme_constant_override("separation", 10)
	scroll.add_child(root_column)

	var title := Label.new()
	title.text = "ANNUAL-MVP-002 · 동료·장비·연구 수직절편"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 22)
	root_column.add_child(title)
	_phase_label = Label.new()
	_phase_label.name = "PhaseLabel"
	root_column.add_child(_phase_label)
	_week_label = Label.new()
	_week_label.name = "WeekLabel"
	root_column.add_child(_week_label)
	_stats_label = Label.new()
	_stats_label.name = "StatsLabel"
	_stats_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root_column.add_child(_stats_label)

	var host := VBoxContainer.new()
	host.name = "PhaseHost"
	host.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root_column.add_child(host)
	_build_planning_panel(host)
	_build_result_panel(host)
	_build_deployment_panel(host)
	_build_preparation_panel(host)
	_incident_host = VBoxContainer.new()
	_incident_host.name = "IncidentHost"
	_incident_host.size_flags_vertical = Control.SIZE_EXPAND_FILL
	host.add_child(_incident_host)
	_panels["IncidentHost"] = _incident_host
	_build_post_incident_panel(host)

	_feedback_label = Label.new()
	_feedback_label.name = "FeedbackLabel"
	_feedback_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_feedback_label.custom_minimum_size.y = 38
	root_column.add_child(_feedback_label)


func _build_planning_panel(host: Control) -> void:
	var panel := VBoxContainer.new()
	panel.name = "WeekPlanningPanel"
	panel.add_theme_constant_override("separation", 8)
	host.add_child(panel)
	_panels[panel.name] = panel
	var guide := Label.new()
	guide.text = "한 주 7일 안에서 일정별 1~3일을 배치합니다. 주차 경계를 넘을 수 없습니다."
	guide.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(guide)
	var grid := GridContainer.new()
	grid.columns = 2
	panel.add_child(grid)
	for value in _config.get("activities", []) as Array:
		var activity := value as Dictionary
		var activity_id := String(activity.get("id", ""))
		var button := Button.new()
		button.name = "ActivityButton_%s" % activity_id
		button.text = "%s · %d일" % [activity.get("name", activity_id), int(activity.get("day_cost", 0))]
		button.pressed.connect(func() -> void: _append_activity(activity_id))
		grid.add_child(button)
	_activity_preview_label = Label.new()
	_activity_preview_label.name = "ActivityPreviewLabel"
	_activity_preview_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(_activity_preview_label)
	var edit_row := HBoxContainer.new()
	panel.add_child(edit_row)
	_add_named_button(edit_row, "CopyLastWeekButton", "지난주 복사", func() -> void: debug_copy_last_week())
	_add_named_button(edit_row, "UndoPlanButton", "마지막 변경 취소", func() -> void: debug_undo_plan())
	_add_named_button(edit_row, "ClearPlanButton", "전체 초기화", func() -> void: debug_clear_plan())
	for slot in range(1, 4):
		var row := HBoxContainer.new()
		panel.add_child(row)
		_add_named_button(row, "Template%dSaveButton" % slot, "템플릿 %d 저장" % slot, func() -> void: debug_save_template(slot))
		_add_named_button(row, "Template%dApplyButton" % slot, "템플릿 %d 적용" % slot, func() -> void: debug_apply_template(slot))
	_add_named_button(panel, "ConfirmWeekButton", "주간 일정 확정", debug_confirm)
	var save_row := HBoxContainer.new()
	panel.add_child(save_row)
	_add_named_button(save_row, "SaveRunButton", "진행 저장", func() -> void: debug_save_run())
	_add_named_button(save_row, "LoadRunButton", "진행 불러오기", func() -> void: debug_load_run())


func _build_result_panel(host: Control) -> void:
	var panel := VBoxContainer.new()
	panel.name = "WeekResultPanel"
	panel.add_theme_constant_override("separation", 8)
	host.add_child(panel)
	_panels[panel.name] = panel
	_week_causal_summary_label = Label.new()
	_week_causal_summary_label.name = "WeekCausalSummaryLabel"
	_week_causal_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(_week_causal_summary_label)
	_add_named_button(panel, "AcknowledgeWeekButton", "주간 결과 확인", func() -> void:
		_state.acknowledge_week_result()
		_render()
	)


func _build_deployment_panel(host: Control) -> void:
	var panel := VBoxContainer.new()
	panel.name = "DeploymentPanel"
	host.add_child(panel)
	_panels[panel.name] = panel
	var label := Label.new()
	label.name = "DeploymentLabel"
	label.text = "2주차 조기 출동 위험 0 · 3주차 자율 출동 위험 15 · 4주차 강제 출동 위험 30"
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(label)
	var row := HBoxContainer.new()
	panel.add_child(row)
	_add_named_button(row, "DeployNowButton", "지금 출동", func() -> void:
		_state.choose_deployment_decision("annual001_decision_deploy")
		_render()
	)
	_add_named_button(row, "DelayDeploymentButton", "1주 더 준비", func() -> void:
		_state.choose_deployment_decision("annual001_decision_delay")
		_render()
	)


func _build_preparation_panel(host: Control) -> void:
	var panel := VBoxContainer.new()
	panel.name = "PreparationPanel"
	panel.add_theme_constant_override("separation", 8)
	host.add_child(panel)
	_panels[panel.name] = panel
	var guide := Label.new()
	guide.text = "동료 최대 2명 · 주 장비 1개 · 호환 모듈. 동료와 장비는 사건 정답을 대신하지 않습니다."
	guide.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(guide)
	var companion_grid := GridContainer.new()
	companion_grid.columns = 3
	panel.add_child(companion_grid)
	for companion_id_value in _companions.keys():
		var companion_id := String(companion_id_value)
		var companion := _companions[companion_id] as Dictionary
		var card := CheckButton.new()
		card.name = "CompanionCard_%s" % companion_id
		card.text = "%s\n%s / %s" % [companion.get("display_name", companion_id), companion.get("role_primary", ""), companion.get("role_secondary", "")]
		card.custom_minimum_size = Vector2(210, 66)
		card.toggled.connect(func(enabled: bool) -> void:
			if _ui_syncing:
				return
			var result := debug_toggle_companion(companion_id, enabled)
			if not bool(result.get("ok", false)):
				_ui_syncing = true
				card.button_pressed = not enabled
				_ui_syncing = false
		)
		companion_grid.add_child(card)
		_companion_buttons[companion_id] = card
	var support_title := Label.new()
	support_title.text = "공용 지원 선택 · 비활성 항목은 후속 CORE hook이 필요합니다."
	support_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(support_title)
	var support_grid := GridContainer.new()
	support_grid.columns = 2
	panel.add_child(support_grid)
	for companion_id_value in _companions.keys():
		var companion_id := String(companion_id_value)
		var companion := _companions[companion_id] as Dictionary
		var label := Label.new()
		label.text = String(companion.get("display_name", companion_id))
		label.custom_minimum_size.x = 120
		support_grid.add_child(label)
		var option := OptionButton.new()
		option.name = "SupportOption_%s" % companion_id
		option.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		option.add_item("지원 없음")
		option.set_item_metadata(0, "")
		for support_id_value in companion.get("public_skill_ids", []) as Array:
			var support_id := String(support_id_value)
			var support := _support_skills.get(support_id, {}) as Dictionary
			var active := String(support.get("runtime_status", "")) == "ACTIVE"
			var suffix := "" if active else " · 후속 CORE hook"
			option.add_item("%s%s" % [support.get("display_name", support_id), suffix])
			var item_index := option.item_count - 1
			option.set_item_metadata(item_index, support_id)
			option.set_item_disabled(item_index, not active)
		option.item_selected.connect(func(index: int) -> void:
			if _ui_syncing:
				return
			var response := debug_set_support(companion_id, String(option.get_item_metadata(index)))
			if not bool(response.get("ok", false)):
				_sync_companion_buttons()
		)
		support_grid.add_child(option)
		_support_options[companion_id] = option
	var equipment_row := HBoxContainer.new()
	panel.add_child(equipment_row)
	var equipment_label := Label.new()
	equipment_label.text = "주 장비"
	equipment_row.add_child(equipment_label)
	_equipment_option = OptionButton.new()
	_equipment_option.name = "EquipmentOption"
	_equipment_option.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_equipment_option.add_item("장비 없음")
	_equipment_option.set_item_metadata(0, "")
	for equipment_id_value in _equipment.keys():
		var equipment_id := String(equipment_id_value)
		var item := _equipment[equipment_id] as Dictionary
		_equipment_option.add_item("%s · %s" % [item.get("display_name", equipment_id), item.get("family", "")])
		_equipment_option.set_item_metadata(_equipment_option.item_count - 1, equipment_id)
	_equipment_option.item_selected.connect(func(index: int) -> void:
		if not _ui_syncing:
			debug_set_equipment(String(_equipment_option.get_item_metadata(index)))
	)
	equipment_row.add_child(_equipment_option)
	var module_label := Label.new()
	module_label.text = "모듈"
	equipment_row.add_child(module_label)
	_module_option = OptionButton.new()
	_module_option.name = "ModuleOption"
	_module_option.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_module_option.item_selected.connect(func(index: int) -> void:
		if not _ui_syncing:
			debug_set_module(String(_module_option.get_item_metadata(index)))
	)
	equipment_row.add_child(_module_option)
	_refresh_module_option()
	_support_status_label = Label.new()
	_support_status_label.name = "SupportStatusLabel"
	_support_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(_support_status_label)
	_add_named_button(panel, "StartIncidentButton", "출동 구성 확정 후 사건 시작", _start_incident)


func _build_post_incident_panel(host: Control) -> void:
	var panel := VBoxContainer.new()
	panel.name = "PostIncidentPanel"
	host.add_child(panel)
	_panels[panel.name] = panel
	_research_resource_label = Label.new()
	_research_resource_label.name = "ResearchResourceLabel"
	_research_resource_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(_research_resource_label)
	_research_node_option = OptionButton.new()
	_research_node_option.name = "ResearchNodeOption"
	for node_id_value in _research_nodes.keys():
		var node_id := String(node_id_value)
		var node := _research_nodes[node_id] as Dictionary
		_research_node_option.add_item(String(node.get("display_name", node_id)))
		_research_node_option.set_item_metadata(_research_node_option.item_count - 1, node_id)
	panel.add_child(_research_node_option)
	var research_row := HBoxContainer.new()
	panel.add_child(research_row)
	_add_named_button(research_row, "StartResearchButton", "연구 시작", func() -> void: debug_start_research(_selected_research_node_id()))
	_add_named_button(research_row, "AdvanceResearchButton", "연구 진행", func() -> void: debug_advance_research(_selected_research_node_id(), 1))
	_add_named_button(research_row, "CancelResearchButton", "연구 취소", func() -> void: debug_cancel_research(_selected_research_node_id()))


func _add_named_button(parent: Control, node_name: String, text: String, callback: Callable) -> Button:
	var button := Button.new()
	button.name = node_name
	button.text = text
	button.pressed.connect(callback)
	parent.add_child(button)
	return button


func _append_activity(activity_id: String) -> void:
	var response: Dictionary = _planner.append_activity(activity_id)
	_feedback_label.text = String(response.get("error", ""))
	_auto_rest_confirmation_pending = false
	_render()


func _start_incident() -> void:
	var loadout: Dictionary = _state.configure_loadout_v2(
		_selected_companion_ids,
		_support_by_companion,
		_selected_equipment_id,
		_selected_module_ids
	)
	if not bool(loadout.get("ok", false)):
		_feedback_label.text = String(loadout.get("error", "편성을 확정할 수 없습니다."))
		return
	var snapshot := _state.get_snapshot()
	var configured: Dictionary = _adapter.configure(_config, snapshot, int(snapshot.get("run_seed", 2201)))
	if not bool(configured.get("ok", false)):
		_feedback_label.text = String(configured.get("error", "사건 adapter 구성 실패"))
		return
	var begin: Dictionary = _state.begin_incident()
	if not bool(begin.get("ok", false)):
		_feedback_label.text = String(begin.get("error", "사건을 시작할 수 없습니다."))
		return
	var case_data := CaseData.load_case(String((_config.get("campaign", {}) as Dictionary).get("incident_case_path", "")))
	var incident := CoreScene.instantiate() as Control
	incident.configure_session(_adapter.build_case_override(case_data), int(snapshot.get("run_seed", 2201)), _adapter)
	incident.session_completed.connect(_on_incident_completed)
	_incident_host.add_child(incident)
	_render()


func _on_incident_completed(result: Dictionary, manual_delta: Dictionary, support_log: Array[Dictionary]) -> void:
	for child in _incident_host.get_children():
		child.queue_free()
	var readiness_sync: Dictionary = _state.apply_support_readiness_snapshot(_adapter.get_readiness_snapshot())
	if not bool(readiness_sync.get("ok", false)):
		_feedback_label.text = String(readiness_sync.get("error", "지원 준비도를 저장하지 못했습니다."))
		_render()
		return
	var applied: Dictionary = _state.apply_incident_result(result, manual_delta, support_log)
	if bool(applied.get("ok", false)) and not _adapter.is_fallback_active():
		var reward: Dictionary = _adapter.build_research_reward(result, manual_delta)
		_state.apply_research_resource_reward(reward.get("resource_delta", {}) as Dictionary)
	_feedback_label.text = String(applied.get("error", ""))
	_render()


func _refresh_module_option() -> void:
	if _module_option == null:
		return
	_ui_syncing = true
	_module_option.clear()
	_module_option.add_item("모듈 없음")
	_module_option.set_item_metadata(0, "")
	if _equipment.has(_selected_equipment_id):
		for module_id_value in (_equipment[_selected_equipment_id] as Dictionary).get("allowed_module_ids", []) as Array:
			var module_id := String(module_id_value)
			_module_option.add_item(String((_modules.get(module_id, {}) as Dictionary).get("display_name", module_id)))
			_module_option.set_item_metadata(_module_option.item_count - 1, module_id)
	_ui_syncing = false


func _render() -> void:
	if _phase_label == null:
		return
	var snapshot := _state.get_snapshot()
	var phase := String(snapshot.get("phase", "BOOT"))
	_phase_label.text = "현재 단계: %s" % phase
	_week_label.text = "주차: %d / 4" % int(snapshot.get("week", 0))
	var competencies := snapshot.get("competencies", {}) as Dictionary
	_stats_label.text = "관찰 %d · 분석 %d · 현장 대응 %d · 대인 대응 %d · 피로 %d · 위험 %d" % [
		int(competencies.get("observation", 0)),
		int(competencies.get("analysis", 0)),
		int(competencies.get("field_response", 0)),
		int(competencies.get("interpersonal", 0)),
		int(snapshot.get("fatigue", 0)),
		int(snapshot.get("deployment_risk", 0)),
	]
	var panel_name := _panel_for_phase(phase)
	for key in _panels.keys():
		(_panels[key] as Control).visible = String(key) == panel_name
	_activity_preview_label.text = _activity_preview_text()
	_week_causal_summary_label.text = _causal_summary_text(snapshot)
	_support_status_label.text = _support_status_text()
	if _research_resource_label != null:
		_research_resource_label.text = _research_status_text(snapshot)
	_sync_companion_buttons()


func _panel_for_phase(phase: String) -> String:
	match phase:
		"WEEK_PLANNING": return "WeekPlanningPanel"
		"WEEK_RESULT": return "WeekResultPanel"
		"DEPLOYMENT_DECISION": return "DeploymentPanel"
		"PREPARATION": return "PreparationPanel"
		"INCIDENT_ACTIVE": return "IncidentHost"
		"INCIDENT_RESULT", "POST_INCIDENT_RESEARCH", "QUARTER_SUMMARY", "COMPLETE": return "PostIncidentPanel"
	return "WeekPlanningPanel"


func _activity_preview_text() -> String:
	var preview: Dictionary = _planner.preview()
	var aggregate := preview.get("aggregate", {}) as Dictionary
	var competencies := aggregate.get("competencies", {}) as Dictionary
	var parts: Array[String] = []
	for key in competencies.keys():
		parts.append("%s %+d" % [String(COMPETENCY_LABELS.get(key, key)), int(competencies[key])])
	return "일정 결과 미리보기 · 사용 %d/7일 · 남은 %d일\n피로 %+d · 기관 지원 %+d · 역량 %s\n확정 전 예상치이며 사건 정답이나 숨은 분기는 공개하지 않습니다." % [
		int(preview.get("used_days", 0)),
		int(preview.get("remaining_days", 7)),
		int(aggregate.get("fatigue", 0)),
		int(aggregate.get("institution_support", 0)),
		"변화 없음" if parts.is_empty() else ", ".join(parts),
	]


func _causal_summary_text(snapshot: Dictionary) -> String:
	var result := snapshot.get("last_week_result", {}) as Dictionary
	if result.is_empty():
		return "무엇이 변했는가\n- 아직 확정된 결과가 없습니다.\n왜 변했는가\n- 일정 확정 후 활동별 원인을 표시합니다.\n다음 주 영향\n- 현재 없음"
	var changes: Array[String] = []
	var causes: Array[String] = []
	for activity_id in _string_array(result.get("planned_activity_ids", [])):
		var activity := _activity_by_id(activity_id)
		var name := String(activity.get("name", activity_id))
		var day_cost := int(activity.get("day_cost", 0))
		var deltas := activity.get("deltas", {}) as Dictionary
		causes.append("- %s %d일이 피로·역량·기관·관계 변화의 원인" % [name, day_cost])
		if int(deltas.get("fatigue", 0)) != 0:
			changes.append("- 피로 %+d — %s %d일" % [int(deltas.get("fatigue", 0)), name, day_cost])
		for key in (deltas.get("competencies", {}) as Dictionary).keys():
			changes.append("- %s %+d — %s %d일" % [String(COMPETENCY_LABELS.get(key, key)), int((deltas.get("competencies", {}) as Dictionary)[key]), name, day_cost])
	var auto_rest_days := int(result.get("auto_rest_days", 0))
	var future := "- 직접 휴식은 정상 회복과 상태 회복 가능성을 유지합니다."
	if auto_rest_days > 0:
		future = "- 자동 휴식 %d일은 하루당 피로 5만 회복하며 관계·특수 회복·추가 보상을 만들지 않았습니다." % auto_rest_days
	return "무엇이 변했는가\n%s\n왜 변했는가\n%s\n다음 주 영향\n- 누적 변화가 다음 일정과 출동 준비에 반영됩니다.\n%s" % [
		"- 수치 변화 없음" if changes.is_empty() else "\n".join(changes),
		"- 원인 활동 없음" if causes.is_empty() else "\n".join(causes),
		future,
	]


func _support_status_text() -> String:
	if _selected_companion_ids.is_empty():
		return "동료 미편성 · 지원 효과 없음\n%s" % Adapter.FAIRNESS_NOTICE
	var preview_adapter := Adapter.new()
	var configured: Dictionary = preview_adapter.configure(_config, _state.get_snapshot(), int(_state.get_snapshot().get("run_seed", 2201)))
	var lines: Array[String] = []
	if bool(configured.get("fallback_active", false)):
		lines.append(String(configured.get("warning", "기본 동작")))
	else:
		lines = preview_adapter.get_status_lines()
	for companion_id in _selected_companion_ids:
		var companion := _companions.get(companion_id, {}) as Dictionary
		var unique_id := String(companion.get("unique_skill_id", ""))
		var unique_skill := _unique_skills.get(unique_id, {}) as Dictionary
		if String(unique_skill.get("runtime_status", "")) == "DISABLED_PENDING_HYPOTHESIS_BOARD_HOOK":
			lines.append("%s · %s | 비활성: 관측·가설 보드 hook 필요" % [companion.get("display_name", companion_id), unique_skill.get("display_name", unique_id)])
		for support_id_value in companion.get("public_skill_ids", []) as Array:
			var support_id := String(support_id_value)
			var support := _support_skills.get(support_id, {}) as Dictionary
			if String(support.get("runtime_status", "")) == "DISABLED_PENDING_CORE_HOOK":
				lines.append("%s · %s | 비활성: 후속 CORE hook 필요" % [companion.get("display_name", companion_id), support.get("display_name", support_id)])
	lines.append(preview_adapter.get_fairness_notice())
	return "\n".join(lines)


func _selected_research_node_id() -> String:
	if _research_node_option == null or _research_node_option.item_count == 0:
		return ""
	return String(_research_node_option.get_item_metadata(_research_node_option.selected))


func _research_status_text(snapshot: Dictionary) -> String:
	var extension := snapshot.get("annual_mvp_002", {}) as Dictionary
	var resources := extension.get("research_resources", {}) as Dictionary
	var active := extension.get("active_research", {}) as Dictionary
	var completed := extension.get("completed_research_ids", []) as Array
	return "연구 자원 · 기록 %d / 잔향 %d / 위험 사례 %d / 기관 %d
진행 %d/2 · 완료 %d
사건 결과는 연구 자원으로 환류하며 시작·진행·취소를 여기서 검증합니다." % [
		int(resources.get("annual002_resource_records", 0)),
		int(resources.get("annual002_resource_residue", 0)),
		int(resources.get("annual002_resource_risk_cases", 0)),
		int(resources.get("annual002_resource_institution", 0)),
		active.size(),
		completed.size(),
	]


func _sync_runtime_from_state() -> void:
	var snapshot: Dictionary = _state.get_snapshot()
	var extension := snapshot.get("annual_mvp_002", {}) as Dictionary
	_selected_companion_ids = _string_array(extension.get("selected_companion_ids", []))
	_support_by_companion = (extension.get("equipped_support_skills", {}) as Dictionary).duplicate(true)
	_selected_equipment_id = String(extension.get("selected_equipment_id", ""))
	_selected_module_ids = _string_array(extension.get("installed_module_ids", []))
	var planner_snapshot := {
		"days_per_week": 7,
		"activity_ids": _string_array(snapshot.get("planned_activity_ids", [])),
		"undo_activity_ids": [],
		"undo_available": false,
		"templates": (extension.get("schedule_templates", [[], [], []]) as Array).duplicate(true),
	}
	_planner.restore(planner_snapshot)
	_refresh_module_option()


func _sync_companion_buttons() -> void:
	_ui_syncing = true
	for key in _companion_buttons.keys():
		(_companion_buttons[key] as CheckButton).button_pressed = _selected_companion_ids.has(String(key))
	for key in _support_options.keys():
		var companion_id := String(key)
		var option := _support_options[key] as OptionButton
		option.disabled = not _selected_companion_ids.has(companion_id)
		var selected_support := String(_support_by_companion.get(companion_id, ""))
		var selected_index := 0
		for index in range(option.item_count):
			if String(option.get_item_metadata(index)) == selected_support:
				selected_index = index
				break
		option.select(selected_index)
	_ui_syncing = false


func _activity_by_id(activity_id: String) -> Dictionary:
	for value in _config.get("activities", []) as Array:
		var activity := value as Dictionary
		if String(activity.get("id", "")) == activity_id:
			return activity
	return {}


func _ui_error(message: String) -> Dictionary:
	_feedback_label.text = message
	_render()
	return {"ok": false, "error": message, "state_changed": false}


func _string_array(value: Variant) -> Array[String]:
	var result: Array[String] = []
	if typeof(value) != TYPE_ARRAY:
		return result
	for item in value as Array:
		result.append(String(item))
	return result


func _dictionary_array(values: Array) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for value in values:
		if typeof(value) == TYPE_DICTIONARY:
			result.append((value as Dictionary).duplicate(true))
	return result
