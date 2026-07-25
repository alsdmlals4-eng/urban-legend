extends "res://scripts/poc/annual_mvp_001/annual_mvp_001_themed_scene.gd"

const BaseData = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_data.gd")
const ExtensionData = preload("res://scripts/poc/annual_mvp_002/annual_mvp_002_data.gd")
const ExtensionState = preload("res://scripts/poc/annual_mvp_002/annual_mvp_002_state.gd")
const ExtensionPlanner = preload("res://scripts/poc/annual_mvp_002/annual_mvp_002_planner.gd")
const ExtensionAdapter = preload("res://scripts/poc/annual_mvp_002/annual_mvp_002_incident_adapter.gd")
const ExtensionThemeFactory = preload("res://scripts/ui/ui_theme_factory.gd")
const ExtensionCaseData = preload("res://scripts/poc/core_mvp_001/core_mvp_001_case_data.gd")
const ExtensionCoreScene = preload("res://scenes/poc/annual_mvp_001/annual_mvp_001_core_scene.tscn")
const EXTENSION_CONFIG_PATH := "res://data/poc/annual_mvp_002/companion_equipment_research.json"

var _planner := ExtensionPlanner.new()
var _extension_config: Dictionary = {}
var _extension_companions: Dictionary = {}
var _extension_support_skills: Dictionary = {}
var _extension_equipment: Dictionary = {}
var _extension_modules: Dictionary = {}

var _activity_preview_label: Label
var _week_causal_summary_label: Label
var _support_status_label: Label
var _equipment_option: OptionButton
var _module_option: OptionButton
var _companion_buttons: Dictionary = {}
var _template_save_buttons: Array[Button] = []
var _template_apply_buttons: Array[Button] = []

var _selected_extension_companion_ids: Array[String] = []
var _selected_support_by_companion: Dictionary = {}
var _selected_extension_equipment_id := ""
var _selected_extension_module_ids: Array[String] = []
var _ui_syncing := false


func _ready() -> void:
	_state = ExtensionState.new()
	_adapter = ExtensionAdapter.new()
	theme = ExtensionThemeFactory.create_theme()
	_add_background()
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_config = BaseData.load_config(CONFIG_PATH)
	_extension_config = ExtensionData.load_config(EXTENSION_CONFIG_PATH)
	_extension_companions = ExtensionData.index_by_id(_extension_config.get("companions", []) as Array)
	_extension_support_skills = ExtensionData.index_by_id(_extension_config.get("support_skills", []) as Array)
	_extension_equipment = ExtensionData.index_by_id(_extension_config.get("equipment", []) as Array)
	_extension_modules = ExtensionData.index_by_id(_extension_config.get("modules", []) as Array)
	_planner.configure(_dictionary_array(_config.get("activities", []) as Array), 7)
	_build_ui()
	var title := Label.new()
	title.name = "AnnualMvp002Title"
	title.text = "ANNUAL-MVP-002 · 동료·장비·연구 수직절편"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var header := find_child("Header", true, false) as Control
	if header != null:
		header.add_child(title)
	var started: Dictionary = _state.start(_config, 2201)
	if not bool(started.get("ok", false)):
		_feedback_label.text = String(started.get("error", "초기화 실패"))
	_replace_module_toggle_handler()
	var incident_host := find_child("IncidentHost", true, false) as Control
	if incident_host != null:
		incident_host.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		incident_host.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_render()
	_localize_rendered_text()
	call_deferred("_focus_current_panel")


func _build_week_planning_panel() -> void:
	super()
	var panel := _panels.get("WeekPlanningPanel") as VBoxContainer
	_activity_preview_label = Label.new()
	_activity_preview_label.name = "ActivityPreviewLabel"
	_activity_preview_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(_activity_preview_label)

	var edit_row := HBoxContainer.new()
	edit_row.name = "PlannerEditRow"
	edit_row.add_theme_constant_override("separation", 8)
	panel.add_child(edit_row)
	var copy_button := Button.new()
	copy_button.name = "CopyLastWeekButton"
	copy_button.text = "지난주 복사"
	copy_button.pressed.connect(func() -> void: debug_copy_last_week())
	edit_row.add_child(copy_button)
	var undo_button := Button.new()
	undo_button.name = "UndoPlanButton"
	undo_button.text = "마지막 변경 취소"
	undo_button.pressed.connect(func() -> void: debug_undo_plan())
	edit_row.add_child(undo_button)
	var clear_button := Button.new()
	clear_button.name = "ClearPlanButton"
	clear_button.text = "전체 초기화"
	clear_button.pressed.connect(func() -> void: debug_clear_plan())
	edit_row.add_child(clear_button)

	for slot in range(1, 4):
		var template_row := HBoxContainer.new()
		template_row.name = "Template%dRow" % slot
		template_row.add_theme_constant_override("separation", 8)
		panel.add_child(template_row)
		var save_button := Button.new()
		save_button.name = "Template%dSaveButton" % slot
		save_button.text = "템플릿 %d 저장" % slot
		save_button.pressed.connect(func() -> void: debug_save_template(slot))
		template_row.add_child(save_button)
		_template_save_buttons.append(save_button)
		var apply_button := Button.new()
		apply_button.name = "Template%dApplyButton" % slot
		apply_button.text = "템플릿 %d 적용" % slot
		apply_button.pressed.connect(func() -> void: debug_apply_template(slot))
		template_row.add_child(apply_button)
		_template_apply_buttons.append(apply_button)


func _build_simple_panel(panel_name: String) -> void:
	super(panel_name)
	if panel_name != "WeekResultPanel":
		return
	var panel := _panels.get(panel_name) as VBoxContainer
	_week_causal_summary_label = Label.new()
	_week_causal_summary_label.name = "WeekCausalSummaryLabel"
	_week_causal_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(_week_causal_summary_label)


func _build_preparation_panel() -> void:
	var panel := VBoxContainer.new()
	panel.name = "PreparationPanel"
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_phase_host.add_child(panel)
	_panels[panel.name] = panel

	_preparation_label = Label.new()
	_preparation_label.name = "PreparationLabel"
	_preparation_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(_preparation_label)

	var companion_guide := Label.new()
	companion_guide.text = "동료는 최대 2명입니다. 고유 스킬은 조건 충족 시 사건당 1회, 공용 지원은 확률·준비도·보장 발동을 공개합니다."
	companion_guide.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(companion_guide)
	var companion_grid := GridContainer.new()
	companion_grid.columns = 3
	panel.add_child(companion_grid)
	for companion_id_value in _extension_companions.keys():
		var companion_id := String(companion_id_value)
		var companion := _extension_companions[companion_id] as Dictionary
		var card := CheckButton.new()
		card.name = "CompanionCard_%s" % companion_id
		card.text = "%s\n%s / %s" % [
			String(companion.get("display_name", companion_id)),
			String(companion.get("role_primary", "")),
			String(companion.get("role_secondary", "")),
		]
		card.custom_minimum_size = Vector2(210, 72)
		card.toggled.connect(func(enabled: bool) -> void:
			if _ui_syncing:
				return
			var response := debug_toggle_companion(companion_id, enabled)
			if not bool(response.get("ok", false)):
				_ui_syncing = true
				card.button_pressed = not enabled
				_ui_syncing = false
		)
		companion_grid.add_child(card)
		_companion_buttons[companion_id] = card

	var support_guide := Label.new()
	support_guide.text = "공용 지원 선택은 동료 카드 선택 후 디버그/자동 기본값 또는 향후 카드 세부 선택에서 변경됩니다."
	support_guide.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(support_guide)

	var equipment_row := HBoxContainer.new()
	equipment_row.add_theme_constant_override("separation", 10)
	panel.add_child(equipment_row)
	var equipment_label := Label.new()
	equipment_label.text = "주 장비"
	equipment_label.custom_minimum_size.x = 90
	equipment_row.add_child(equipment_label)
	_equipment_option = OptionButton.new()
	_equipment_option.name = "EquipmentOption"
	_equipment_option.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_equipment_option.add_item("장비 없음")
	_equipment_option.set_item_metadata(0, "")
	for equipment_id_value in _extension_equipment.keys():
		var equipment_id := String(equipment_id_value)
		var equipment := _extension_equipment[equipment_id] as Dictionary
		_equipment_option.add_item("%s · %s" % [equipment.get("display_name", equipment_id), equipment.get("family", "")])
		_equipment_option.set_item_metadata(_equipment_option.item_count - 1, equipment_id)
	_equipment_option.item_selected.connect(_on_equipment_option_selected)
	equipment_row.add_child(_equipment_option)

	var module_label := Label.new()
	module_label.text = "모듈"
	module_label.custom_minimum_size.x = 70
	equipment_row.add_child(module_label)
	_module_option = OptionButton.new()
	_module_option.name = "ModuleOption"
	_module_option.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_module_option.item_selected.connect(_on_module_option_selected)
	equipment_row.add_child(_module_option)
	_refresh_module_option()

	_support_status_label = Label.new()
	_support_status_label.name = "SupportStatusLabel"
	_support_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(_support_status_label)

	var start_button := Button.new()
	start_button.name = "StartIncidentButton"
	start_button.text = "출동 구성 확정 후 사건 시작"
	start_button.pressed.connect(_start_incident)
	panel.add_child(start_button)


func _select_activity(activity_id: String) -> void:
	if _effective_phase() != "WEEK_PLANNING":
		return
	var response: Dictionary = _planner.append_activity(activity_id)
	if not bool(response.get("ok", false)):
		_feedback_label.text = String(response.get("error", "일정을 추가할 수 없습니다."))
		_render()
		return
	_sync_plan_from_planner()
	_feedback_label.text = ""
	_auto_rest_confirmation_pending = false
	_render()


func _on_back_pressed() -> void:
	if _effective_phase() != "WEEK_PLANNING":
		return
	var response: Dictionary = _planner.undo()
	if not bool(response.get("ok", false)):
		_feedback_label.text = String(response.get("error", "되돌릴 변경이 없습니다."))
	else:
		_feedback_label.text = ""
		_sync_plan_from_planner()
		_auto_rest_confirmation_pending = false
	_render()


func _on_confirm_pressed() -> void:
	var phase_before := _effective_phase()
	super()
	if phase_before == "WEEK_PLANNING" and _effective_phase() == "WEEK_RESULT":
		_planner.configure(_dictionary_array(_config.get("activities", []) as Array), 7)
		_selected_activity_ids.clear()
	_render()


func _render() -> void:
	super()
	if _activity_preview_label != null:
		_activity_preview_label.text = _activity_preview_text()
	if _week_causal_summary_label != null:
		_week_causal_summary_label.text = _causal_summary_text(_state.get_snapshot())
	if _support_status_label != null:
		_support_status_label.text = _support_status_text()
	_sync_companion_buttons()


func _start_incident() -> void:
	var loadout_result := _state.configure_loadout_v2(
		_selected_extension_companion_ids,
		_selected_support_by_companion,
		_selected_extension_equipment_id,
		_selected_extension_module_ids
	)
	if not bool(loadout_result.get("ok", false)):
		_apply_command(loadout_result)
		return
	# Preserve the parent incident gate and save contract without using its effects.
	var base_gate: Dictionary = _state.configure_loadout("annual001_companion_oh_hyun", "", [])
	if not bool(base_gate.get("ok", false)):
		_apply_command(base_gate)
		return
	var snapshot := _state.get_snapshot()
	var adapter_result: Dictionary = _adapter.configure(_config, snapshot, int(snapshot.get("run_seed", 2201)))
	if not bool(adapter_result.get("ok", false)):
		_feedback_label.text = String(adapter_result.get("error", "사건 어댑터 구성 실패"))
		return
	if bool(adapter_result.get("fallback_active", false)):
		_feedback_label.text = String(adapter_result.get("warning", "기본 사건 동작으로 전환합니다."))
	var begin: Dictionary = _state.begin_incident()
	if not bool(begin.get("ok", false)):
		_apply_command(begin)
		return
	var base_case := ExtensionCaseData.load_case(String((_config.get("campaign", {}) as Dictionary).get("incident_case_path", "")))
	var override := _adapter.build_case_override(base_case)
	var incident := ExtensionCoreScene.instantiate() as Control
	incident.configure_session(override, int(snapshot.get("run_seed", 2201)), _adapter)
	incident.session_completed.connect(_on_incident_completed)
	incident.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	incident.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_incident_host.add_child(incident)
	_render()


func _on_incident_completed(result: Dictionary, manual_delta: Dictionary, support_log: Array[Dictionary]) -> void:
	for child in _incident_host.get_children():
		child.queue_free()
	var applied: Dictionary = _state.apply_incident_result(result, manual_delta, support_log)
	if bool(applied.get("ok", false)) and not _adapter.is_fallback_active():
		var reward: Dictionary = _adapter.build_research_reward(result, manual_delta)
		_state.apply_research_resource_reward(reward.get("resource_delta", {}) as Dictionary)
	_apply_command(applied)


func debug_set_plan(values: Array) -> Dictionary:
	var response: Dictionary = _planner.set_plan(_string_array(values))
	if bool(response.get("ok", false)):
		_sync_plan_from_planner()
		_feedback_label.text = ""
	else:
		_feedback_label.text = String(response.get("error", "일정을 적용할 수 없습니다."))
	_render()
	return response


func debug_plan_ids() -> Array[String]:
	return _selected_activity_ids.duplicate()


func debug_undo_plan() -> Dictionary:
	var response: Dictionary = _planner.undo()
	if bool(response.get("ok", false)):
		_sync_plan_from_planner()
	_feedback_label.text = String(response.get("error", ""))
	_render()
	return response


func debug_clear_plan() -> Dictionary:
	var response: Dictionary = _planner.clear()
	if bool(response.get("ok", false)):
		_sync_plan_from_planner()
	_feedback_label.text = String(response.get("error", ""))
	_render()
	return response


func debug_copy_last_week() -> Dictionary:
	var response: Dictionary = _planner.copy_last_week((_state.get_snapshot().get("last_week_result", {}) as Dictionary))
	if bool(response.get("ok", false)):
		_sync_plan_from_planner()
	_feedback_label.text = String(response.get("error", ""))
	_render()
	return response


func debug_save_template(slot: int) -> Dictionary:
	var response: Dictionary = _planner.save_template(slot)
	if bool(response.get("ok", false)):
		_state.save_schedule_template(slot, _selected_activity_ids)
	_feedback_label.text = String(response.get("error", ""))
	_render()
	return response


func debug_apply_template(slot: int) -> Dictionary:
	var response: Dictionary = _planner.apply_template(slot)
	if bool(response.get("ok", false)):
		_sync_plan_from_planner()
	_feedback_label.text = String(response.get("error", ""))
	_render()
	return response


func debug_force_preparation_phase() -> void:
	_debug_phase_override = ""
	var guard := 0
	while String(_state.get_snapshot().get("phase", "")) != "PREPARATION" and guard < 12:
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
	if not _extension_companions.has(companion_id):
		return _ui_error("알 수 없는 동료입니다.")
	var candidate := _selected_extension_companion_ids.duplicate()
	if enabled:
		if candidate.has(companion_id):
			return {"ok": true, "error": ""}
		if candidate.size() >= 2:
			return _ui_error("동료는 최대 2명까지 편성할 수 있습니다.")
		candidate.append(companion_id)
		var companion := _extension_companions[companion_id] as Dictionary
		var public_ids := companion.get("public_skill_ids", []) as Array
		if not public_ids.is_empty():
			_selected_support_by_companion[companion_id] = String(public_ids[0])
	else:
		candidate.erase(companion_id)
		_selected_support_by_companion.erase(companion_id)
	var previous := _selected_extension_companion_ids.duplicate()
	_selected_extension_companion_ids = candidate
	var response := _apply_local_loadout()
	if not bool(response.get("ok", false)):
		_selected_extension_companion_ids = previous
		return response
	_render()
	return response


func debug_selected_companions() -> Array[String]:
	return _selected_extension_companion_ids.duplicate()


func debug_set_support(companion_id: String, support_id: String) -> Dictionary:
	if not _selected_extension_companion_ids.has(companion_id):
		return _ui_error("먼저 동료를 선택해야 합니다.")
	var companion := _extension_companions.get(companion_id, {}) as Dictionary
	if not (companion.get("public_skill_ids", []) as Array).has(support_id):
		return _ui_error("해당 동료가 사용할 수 없는 공용 지원입니다.")
	var previous := _selected_support_by_companion.duplicate(true)
	_selected_support_by_companion[companion_id] = support_id
	var response := _apply_local_loadout()
	if not bool(response.get("ok", false)):
		_selected_support_by_companion = previous
		return response
	_render()
	return response


func debug_set_equipment(equipment_id: String) -> Dictionary:
	if not equipment_id.is_empty() and not _extension_equipment.has(equipment_id):
		return _ui_error("알 수 없는 주 장비입니다.")
	var previous_equipment := _selected_extension_equipment_id
	var previous_modules := _selected_extension_module_ids.duplicate()
	_selected_extension_equipment_id = equipment_id
	_selected_extension_module_ids.clear()
	var response := _apply_local_loadout()
	if not bool(response.get("ok", false)):
		_selected_extension_equipment_id = previous_equipment
		_selected_extension_module_ids = previous_modules
		return response
	_refresh_module_option()
	_render()
	return response


func debug_set_module(module_id: String) -> Dictionary:
	var previous := _selected_extension_module_ids.duplicate()
	_selected_extension_module_ids.clear()
	if not module_id.is_empty():
		_selected_extension_module_ids.append(module_id)
	var response := _apply_local_loadout()
	if not bool(response.get("ok", false)):
		_selected_extension_module_ids = previous
		return response
	_render()
	return response


func debug_loadout_snapshot() -> Dictionary:
	return {
		"selected_companion_ids": _selected_extension_companion_ids.duplicate(),
		"support_by_companion": _selected_support_by_companion.duplicate(true),
		"equipment_id": _selected_extension_equipment_id,
		"module_ids": _selected_extension_module_ids.duplicate(),
	}


func _on_equipment_option_selected(index: int) -> void:
	if _ui_syncing:
		return
	debug_set_equipment(String(_equipment_option.get_item_metadata(index)))


func _on_module_option_selected(index: int) -> void:
	if _ui_syncing:
		return
	debug_set_module(String(_module_option.get_item_metadata(index)))


func _refresh_module_option() -> void:
	if _module_option == null:
		return
	_ui_syncing = true
	_module_option.clear()
	_module_option.add_item("모듈 없음")
	_module_option.set_item_metadata(0, "")
	if _extension_equipment.has(_selected_extension_equipment_id):
		var equipment := _extension_equipment[_selected_extension_equipment_id] as Dictionary
		for module_id_value in equipment.get("allowed_module_ids", []) as Array:
			var module_id := String(module_id_value)
			var module := _extension_modules.get(module_id, {}) as Dictionary
			_module_option.add_item(String(module.get("display_name", module_id)))
			_module_option.set_item_metadata(_module_option.item_count - 1, module_id)
	_ui_syncing = false


func _apply_local_loadout() -> Dictionary:
	var response: Dictionary = _state.configure_loadout_v2(
		_selected_extension_companion_ids,
		_selected_support_by_companion,
		_selected_extension_equipment_id,
		_selected_extension_module_ids
	)
	_feedback_label.text = String(response.get("error", ""))
	return response


func _support_status_text() -> String:
	if _selected_extension_companion_ids.is_empty():
		return "동료 미편성 · 사건 진행은 가능하지만 지원 효과는 없습니다.\n%s" % ExtensionAdapter.FAIRNESS_NOTICE
	var preview_adapter := ExtensionAdapter.new()
	var configured: Dictionary = preview_adapter.configure(_config, _state.get_snapshot(), int(_state.get_snapshot().get("run_seed", 2201)))
	if bool(configured.get("fallback_active", false)):
		return "%s\n%s" % [String(configured.get("warning", "기본 동작")), preview_adapter.get_fairness_notice()]
	var lines: Array[String] = preview_adapter.get_status_lines()
	lines.append(preview_adapter.get_fairness_notice())
	return "\n".join(lines)


func _activity_preview_text() -> String:
	var preview: Dictionary = _planner.preview()
	var aggregate := preview.get("aggregate", {}) as Dictionary
	var competencies := aggregate.get("competencies", {}) as Dictionary
	var competency_parts: Array[String] = []
	for key in competencies.keys():
		competency_parts.append("%s %+d" % [String(COMPETENCY_LABELS.get(key, key)), int(competencies[key])])
	return "일정 결과 미리보기 · 사용 %d/7일 · 남은 %d일\n피로 %+d · 기관 지원 %+d · 역량 %s\n확정 전 예상치이며 사건 정답이나 숨은 분기는 공개하지 않습니다." % [
		int(preview.get("used_days", 0)),
		int(preview.get("remaining_days", 7)),
		int(aggregate.get("fatigue", 0)),
		int(aggregate.get("institution_support", 0)),
		"변화 없음" if competency_parts.is_empty() else ", ".join(competency_parts),
	]


func _causal_summary_text(snapshot: Dictionary) -> String:
	var result := snapshot.get("last_week_result", {}) as Dictionary
	if result.is_empty():
		return "무엇이 변했는가\n- 아직 확정된 주간 결과가 없습니다.\n왜 변했는가\n- 일정을 확정하면 활동별 원인을 기록합니다.\n다음 주 영향\n- 현재는 없음"
	var change_lines: Array[String] = []
	var cause_lines: Array[String] = []
	for activity_id in _string_array(result.get("planned_activity_ids", [])):
		var activity := _activity_by_id(activity_id)
		var name := String(activity.get("name", activity_id))
		var day_cost := int(activity.get("day_cost", 0))
		var deltas := activity.get("deltas", {}) as Dictionary
		cause_lines.append("- %s %d일이 피로·역량·기관·관계 변화에 반영됨" % [name, day_cost])
		if int(deltas.get("fatigue", 0)) != 0:
			change_lines.append("- 피로 %+d — %s %d일" % [int(deltas.get("fatigue", 0)), name, day_cost])
		for competency_value in (deltas.get("competencies", {}) as Dictionary).keys():
			change_lines.append("- %s %+d — %s %d일" % [
				String(COMPETENCY_LABELS.get(competency_value, competency_value)),
				int((deltas.get("competencies", {}) as Dictionary)[competency_value]),
				name,
				day_cost,
			])
	var auto_rest_days := int(result.get("auto_rest_days", 0))
	var future_lines: Array[String] = ["- 누적 역량·피로·지원 상태가 다음 주 일정과 출동 준비에 반영됩니다."]
	if auto_rest_days > 0:
		future_lines.append("- 자동 휴식 %d일은 하루당 피로 5만 회복하고 관계·특수 회복·추가 보상을 만들지 않았습니다." % auto_rest_days)
	else:
		future_lines.append("- 직접 선택한 휴식은 정상 회복 효과와 상태 회복 가능성을 유지합니다.")
	return "무엇이 변했는가\n%s\n왜 변했는가\n%s\n다음 주 영향\n%s" % [
		"- 수치 변화 없음" if change_lines.is_empty() else "\n".join(change_lines),
		"- 원인 활동 없음" if cause_lines.is_empty() else "\n".join(cause_lines),
		"\n".join(future_lines),
	]


func _sync_plan_from_planner() -> void:
	_selected_activity_ids = _string_array(_planner.preview().get("activity_ids", []))


func _sync_companion_buttons() -> void:
	if _companion_buttons.is_empty():
		return
	_ui_syncing = true
	for companion_id_value in _companion_buttons.keys():
		var companion_id := String(companion_id_value)
		(_companion_buttons[companion_id] as CheckButton).button_pressed = _selected_extension_companion_ids.has(companion_id)
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
