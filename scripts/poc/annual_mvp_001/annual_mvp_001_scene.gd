class_name AnnualMvp001Scene
extends Control

const Data = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_data.gd")
const State = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_state.gd")
const Adapter = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_incident_adapter.gd")
const SaveData = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_save_data.gd")
const CaseData = preload("res://scripts/poc/core_mvp_001/core_mvp_001_case_data.gd")
const CoreScene = preload("res://scenes/poc/core_mvp_001/core_mvp_001_scene.tscn")

const CONFIG_PATH := "res://data/poc/annual_mvp_001/spring_vertical_slice.json"

var _config: Dictionary = {}
var _state := State.new()
var _adapter := Adapter.new()
var _selected_activity_ids: Array[String] = []
var _selected_public_skill_id := ""
var _selected_module_ids: Array[String] = []
var _debug_phase_override := ""

var _phase_label: Label
var _week_label: Label
var _stats_label: Label
var _resource_label: Label
var _feedback_label: Label
var _phase_host: Control
var _panels: Dictionary = {}
var _planning_selection_label: Label
var _week_result_label: Label
var _deployment_label: Label
var _preparation_label: Label
var _research_label: Label
var _summary_label: Label
var _incident_host: Control
var _back_button: Button
var _confirm_button: Button
var _save_button: Button
var _load_button: Button


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_build_ui()
	_config = Data.load_config(CONFIG_PATH)
	var started: Dictionary = _state.start(_config, 2001)
	if not bool(started.get("ok", false)):
		_feedback_label.text = String(started.get("error", "초기화 실패"))
	_render()


func debug_snapshot() -> Dictionary:
	return _state.get_snapshot()


func debug_select_activity(activity_id: String) -> void:
	_select_activity(activity_id)


func debug_confirm() -> void:
	_on_confirm_pressed()


func debug_visible_panel() -> String:
	for panel_name in _panels.keys():
		var panel := _panels[panel_name] as Control
		if panel.visible:
			return String(panel_name)
	return ""


func debug_force_incident_phase() -> void:
	_debug_phase_override = "INCIDENT_ACTIVE"
	_render()


func _build_ui() -> void:
	var safe := MarginContainer.new()
	safe.name = "SafeFrame"
	safe.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	safe.add_theme_constant_override("margin_left", 24)
	safe.add_theme_constant_override("margin_top", 20)
	safe.add_theme_constant_override("margin_right", 24)
	safe.add_theme_constant_override("margin_bottom", 20)
	add_child(safe)

	var root_column := VBoxContainer.new()
	root_column.name = "RootColumn"
	root_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root_column.size_flags_vertical = Control.SIZE_EXPAND_FILL
	safe.add_child(root_column)

	var header := VBoxContainer.new()
	header.name = "Header"
	root_column.add_child(header)
	var title := Label.new()
	title.text = "ANNUAL-MVP-001 · 봄 분기 수직절편"
	title.add_theme_font_size_override("font_size", 24)
	header.add_child(title)
	_phase_label = Label.new()
	_phase_label.name = "PhaseLabel"
	header.add_child(_phase_label)
	_week_label = Label.new()
	_week_label.name = "WeekLabel"
	header.add_child(_week_label)
	_stats_label = Label.new()
	_stats_label.name = "StatsLabel"
	_stats_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	header.add_child(_stats_label)
	_resource_label = Label.new()
	_resource_label.name = "ResourceLabel"
	header.add_child(_resource_label)

	var separator := HSeparator.new()
	root_column.add_child(separator)

	_phase_host = VBoxContainer.new()
	_phase_host.name = "PhaseHost"
	_phase_host.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root_column.add_child(_phase_host)

	_build_week_planning_panel()
	_build_simple_panel("WeekResultPanel")
	_build_deployment_panel()
	_build_preparation_panel()
	_incident_host = VBoxContainer.new()
	_incident_host.name = "IncidentHost"
	_incident_host.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_phase_host.add_child(_incident_host)
	_panels[_incident_host.name] = _incident_host
	_build_research_panel()
	_build_summary_panel()

	_feedback_label = Label.new()
	_feedback_label.name = "FeedbackLabel"
	_feedback_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_feedback_label.custom_minimum_size.y = 42
	root_column.add_child(_feedback_label)

	var footer := HBoxContainer.new()
	footer.name = "Footer"
	footer.alignment = BoxContainer.ALIGNMENT_END
	root_column.add_child(footer)
	_back_button = Button.new()
	_back_button.name = "BackButton"
	_back_button.text = "선택 지우기"
	_back_button.pressed.connect(_on_back_pressed)
	footer.add_child(_back_button)
	_save_button = Button.new()
	_save_button.name = "SaveButton"
	_save_button.text = "PoC 저장"
	_save_button.pressed.connect(_on_save_pressed)
	footer.add_child(_save_button)
	_load_button = Button.new()
	_load_button.name = "LoadButton"
	_load_button.text = "PoC 불러오기"
	_load_button.pressed.connect(_on_load_pressed)
	footer.add_child(_load_button)
	_confirm_button = Button.new()
	_confirm_button.name = "ConfirmButton"
	_confirm_button.text = "확인"
	_confirm_button.pressed.connect(_on_confirm_pressed)
	footer.add_child(_confirm_button)


func _build_week_planning_panel() -> void:
	var panel := VBoxContainer.new()
	panel.name = "WeekPlanningPanel"
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_phase_host.add_child(panel)
	_panels[panel.name] = panel
	var guide := Label.new()
	guide.text = "이번 주 활동 3개를 순서대로 선택합니다. 같은 활동을 반복할 수 있습니다."
	guide.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(guide)
	_planning_selection_label = Label.new()
	panel.add_child(_planning_selection_label)
	var activity_grid := GridContainer.new()
	activity_grid.columns = 2
	panel.add_child(activity_grid)
	for value in _config_activities_fallback():
		var activity := value as Dictionary
		var button := Button.new()
		button.text = String(activity.get("name", activity.get("id", "활동")))
		button.custom_minimum_size = Vector2(260, 42)
		var activity_id := String(activity.get("id", ""))
		button.pressed.connect(func() -> void: _select_activity(activity_id))
		activity_grid.add_child(button)


func _build_simple_panel(panel_name: String) -> void:
	var panel := VBoxContainer.new()
	panel.name = panel_name
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_phase_host.add_child(panel)
	_panels[panel.name] = panel
	_week_result_label = Label.new()
	_week_result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(_week_result_label)


func _build_deployment_panel() -> void:
	var panel := VBoxContainer.new()
	panel.name = "DeploymentPanel"
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_phase_host.add_child(panel)
	_panels[panel.name] = panel
	_deployment_label = Label.new()
	_deployment_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(_deployment_label)
	var row := HBoxContainer.new()
	panel.add_child(row)
	var deploy := Button.new()
	deploy.text = "지금 출동"
	deploy.pressed.connect(func() -> void: _apply_command(_state.choose_deployment_decision("annual001_decision_deploy")))
	row.add_child(deploy)
	var delay := Button.new()
	delay.text = "1주 더 준비"
	delay.pressed.connect(func() -> void: _apply_command(_state.choose_deployment_decision("annual001_decision_delay")))
	row.add_child(delay)


func _build_preparation_panel() -> void:
	var panel := VBoxContainer.new()
	panel.name = "PreparationPanel"
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_phase_host.add_child(panel)
	_panels[panel.name] = panel
	_preparation_label = Label.new()
	_preparation_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(_preparation_label)
	var research := Button.new()
	research.text = "신호 완충 연구 완료 시도"
	research.pressed.connect(func() -> void: _apply_command(_state.complete_research_project("annual001_research_signal_buffer")))
	panel.add_child(research)
	var public_toggle := CheckButton.new()
	public_toggle.text = "공용 보조 스킬: 긴급 엄호"
	public_toggle.toggled.connect(func(enabled: bool) -> void:
		_selected_public_skill_id = "annual001_skill_emergency_cover" if enabled else ""
		_render()
	)
	panel.add_child(public_toggle)
	var module_toggle := CheckButton.new()
	module_toggle.text = "모듈: 신호 완충"
	module_toggle.toggled.connect(func(enabled: bool) -> void:
		_selected_module_ids = ["annual001_module_signal_buffer"] if enabled else []
		_render()
	)
	panel.add_child(module_toggle)
	var start_button := Button.new()
	start_button.text = "출동 구성 확정 후 사건 시작"
	start_button.pressed.connect(_start_incident)
	panel.add_child(start_button)


func _build_research_panel() -> void:
	var panel := VBoxContainer.new()
	panel.name = "ResearchPanel"
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_phase_host.add_child(panel)
	_panels[panel.name] = panel
	_research_label = Label.new()
	_research_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(_research_label)
	var research := Button.new()
	research.text = "승차권 대응 절차 연구"
	research.pressed.connect(func() -> void: _apply_command(_state.complete_research_project("annual001_research_ticket_protocol")))
	panel.add_child(research)
	var skip := Button.new()
	skip.text = "연구를 건너뛰고 분기 결산"
	skip.pressed.connect(func() -> void: _apply_command(_state.skip_post_incident_research()))
	panel.add_child(skip)


func _build_summary_panel() -> void:
	var panel := VBoxContainer.new()
	panel.name = "QuarterSummaryPanel"
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_phase_host.add_child(panel)
	_panels[panel.name] = panel
	_summary_label = Label.new()
	_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(_summary_label)


func _config_activities_fallback() -> Array:
	var loaded := Data.load_config(CONFIG_PATH)
	return loaded.get("activities", []) as Array


func _select_activity(activity_id: String) -> void:
	if _effective_phase() != "WEEK_PLANNING" or _selected_activity_ids.size() >= 3:
		return
	_selected_activity_ids.append(activity_id)
	_render()


func _on_back_pressed() -> void:
	if _effective_phase() == "WEEK_PLANNING" and not _selected_activity_ids.is_empty():
		_selected_activity_ids.pop_back()
		_render()


func _on_confirm_pressed() -> void:
	match _effective_phase():
		"WEEK_PLANNING":
			if _selected_activity_ids.size() != 3:
				_feedback_label.text = "활동 3개를 선택해야 합니다."
				return
			_apply_command(_state.commit_week(_selected_activity_ids))
			_selected_activity_ids.clear()
		"WEEK_RESULT":
			_apply_command(_state.acknowledge_week_result())
		"INCIDENT_RESULT":
			_apply_command(_state.advance_from_incident_result())
		"QUARTER_SUMMARY":
			_apply_command(_state.confirm_quarter_summary())
		"COMPLETE":
			_feedback_label.text = "분기 결산 모형이 완료되었습니다. 최종 엔딩이 아닙니다."


func _start_incident() -> void:
	var configured: Dictionary = _state.configure_loadout(
		"annual001_companion_oh_hyun",
		_selected_public_skill_id,
		_selected_module_ids
	)
	if not bool(configured.get("ok", false)):
		_apply_command(configured)
		return
	var snapshot := _state.get_snapshot()
	var adapter_result: Dictionary = _adapter.configure(_config, snapshot, int(snapshot.get("run_seed", 2001)))
	if not bool(adapter_result.get("ok", false)):
		_feedback_label.text = String(adapter_result.get("error", "사건 어댑터 구성 실패"))
		return
	var begin: Dictionary = _state.begin_incident()
	if not bool(begin.get("ok", false)):
		_apply_command(begin)
		return
	var base_case := CaseData.load_case(String((_config.get("campaign", {}) as Dictionary).get("incident_case_path", "")))
	var override := _adapter.build_case_override(base_case)
	var incident := CoreScene.instantiate()
	incident.configure_session(override, int(snapshot.get("run_seed", 2001)), _adapter)
	incident.session_completed.connect(_on_incident_completed)
	_incident_host.add_child(incident)
	_render()


func _on_incident_completed(result: Dictionary, manual_delta: Dictionary, support_log: Array[Dictionary]) -> void:
	for child in _incident_host.get_children():
		child.queue_free()
	var applied: Dictionary = _state.apply_incident_result(result, manual_delta, support_log)
	_apply_command(applied)


func _on_save_pressed() -> void:
	var payload: Dictionary = _state.build_save_payload()
	if payload.is_empty():
		_feedback_label.text = "현재 단계에서는 저장할 수 없습니다."
		return
	var error := SaveData.write_payload(payload)
	_feedback_label.text = "PoC 저장 완료" if error == OK else "PoC 저장 실패: %s" % error_string(error)


func _on_load_pressed() -> void:
	var payload := SaveData.read_payload()
	if payload.is_empty():
		_feedback_label.text = "불러올 PoC 저장이 없습니다."
		return
	var restored: Dictionary = _state.restore(_config, payload)
	if bool(restored.get("ok", false)):
		_debug_phase_override = ""
		_selected_activity_ids.clear()
		for child in _incident_host.get_children():
			child.queue_free()
	_apply_command(restored)


func _apply_command(result: Dictionary) -> void:
	_feedback_label.text = String(result.get("error", ""))
	if bool(result.get("ok", false)) and _feedback_label.text.is_empty():
		_feedback_label.text = "상태가 갱신되었습니다."
	_render()


func _effective_phase() -> String:
	if not _debug_phase_override.is_empty():
		return _debug_phase_override
	return String(_state.get_snapshot().get("phase", "BOOT"))


func _render() -> void:
	if _phase_label == null:
		return
	var snapshot := _state.get_snapshot()
	var phase := _effective_phase()
	_phase_label.text = "현재 단계: %s" % phase
	_week_label.text = "주차: %d / 3" % int(snapshot.get("week", 0))
	var competencies := snapshot.get("competencies", {}) as Dictionary
	_stats_label.text = "관찰 %d · 분석 %d · 현장 대응 %d · 대인 대응 %d · 피로 %d" % [
		int(competencies.get("observation", 0)),
		int(competencies.get("analysis", 0)),
		int(competencies.get("field_response", 0)),
		int(competencies.get("interpersonal", 0)),
		int(snapshot.get("fatigue", 0))
	]
	_resource_label.text = "기관 지원 %d · 잔향 자료 %d · 오현 신뢰 %d" % [
		int(snapshot.get("institution_support", 0)),
		int(snapshot.get("residual_data", 0)),
		int((snapshot.get("companion_trust", {}) as Dictionary).get("annual001_companion_oh_hyun", 0))
	]
	for panel_name in _panels.keys():
		(_panels[panel_name] as Control).visible = String(panel_name) == _panel_for_phase(phase)
	_planning_selection_label.text = "선택 %d/3: %s" % [_selected_activity_ids.size(), ", ".join(_selected_activity_ids)]
	_week_result_label.text = _week_result_text(snapshot)
	_deployment_label.text = _deployment_text(snapshot)
	_preparation_label.text = _preparation_text(snapshot)
	_research_label.text = _research_text(snapshot)
	_summary_label.text = _summary_text(snapshot)
	_back_button.disabled = phase != "WEEK_PLANNING" or _selected_activity_ids.is_empty()
	_confirm_button.disabled = phase in ["DEPLOYMENT_DECISION", "PREPARATION", "INCIDENT_ACTIVE", "POST_INCIDENT_RESEARCH"]
	_save_button.disabled = phase == "INCIDENT_ACTIVE"


func _panel_for_phase(phase: String) -> String:
	match phase:
		"WEEK_PLANNING": return "WeekPlanningPanel"
		"WEEK_RESULT": return "WeekResultPanel"
		"DEPLOYMENT_DECISION": return "DeploymentPanel"
		"PREPARATION": return "PreparationPanel"
		"INCIDENT_ACTIVE": return "IncidentHost"
		"INCIDENT_RESULT", "POST_INCIDENT_RESEARCH": return "ResearchPanel"
		"QUARTER_SUMMARY", "COMPLETE": return "QuarterSummaryPanel"
	return "WeekPlanningPanel"


func _week_result_text(snapshot: Dictionary) -> String:
	var result := snapshot.get("last_week_result", {}) as Dictionary
	if result.is_empty():
		return "주간 결과가 없습니다."
	return "%d주차 결과\n활동: %s\n피로·역량·기관 지원·신뢰 변화가 다음 출동 준비에 반영됩니다." % [
		int(result.get("week", 0)),
		", ".join(result.get("activity_ids", []) as Array)
	]


func _deployment_text(snapshot: Dictionary) -> String:
	if int(snapshot.get("week", 0)) == 2:
		return "지금 출동하면 추가 위험이 없습니다. 1주 더 준비하면 역량을 보완할 수 있습니다."
	return "3주차입니다. 지금 출동하면 위험 +15. 다시 지연하면 긴급 출동으로 전환되어 위험 +30입니다."


func _preparation_text(snapshot: Dictionary) -> String:
	var health := 100
	var fatigue := int(snapshot.get("fatigue", 0))
	if fatigue >= 81: health = 75
	elif fatigue >= 71: health = 80
	elif fatigue >= 61: health = 85
	elif fatigue >= 51: health = 90
	elif fatigue >= 41: health = 95
	return "동료: 오현 / 고유 스킬: 절차 교차 확인\n공용 스킬: %s\n기본 장비: 현장 기록기 / 모듈: %s\n예상 시작 체력 %d · 시작 위험 %d\n성장 효과는 정답이 아니라 정보·피해·위험 관리에만 적용됩니다." % [
		"긴급 엄호" if not _selected_public_skill_id.is_empty() else "없음",
		"신호 완충" if not _selected_module_ids.is_empty() else "없음",
		health,
		int(snapshot.get("deployment_risk", 0))
	]


func _research_text(snapshot: Dictionary) -> String:
	var manual := snapshot.get("manual_delta", {}) as Dictionary
	return "사건 결과: %s\n매뉴얼 지식 품질: %s\n위험 사례: %d건\n검증 상태와 잔향 자료가 충족되면 공용 보조 스킬을 연구할 수 있습니다." % [
		String((snapshot.get("incident_result", {}) as Dictionary).get("recovery_quality", "대기")),
		String(manual.get("status", "대기")),
		(manual.get("danger_cases", []) as Array).size()
	]


func _summary_text(snapshot: Dictionary) -> String:
	var summary := snapshot.get("quarter_summary", {}) as Dictionary
	if summary.is_empty():
		return "분기 결산 모형을 준비 중입니다."
	return "분기 결산 모형 — 최종 엔딩이 아닙니다.\n%d주 동안 권나래는 %s 역량을 중심으로 성장했습니다.\n출동 방식은 %s였습니다.\n회수 품질은 %s입니다.\n지식 품질은 %s이며 위험 사례 %d건이 기록됐습니다.\n오현의 보조는 %d회 발동했습니다.\n연구·장비·스킬 해금은 다음 분기 준비로 이어집니다.\n다음 연도 확장 시 이 결과는 중간 상태로 계승됩니다." % [
		int(summary.get("weeks_used", 0)),
		String(summary.get("competency_focus", "미정")),
		"긴급 출동" if bool(summary.get("forced_deployment", false)) else "자율 출동",
		String(summary.get("recovery_quality", "미정")),
		String(summary.get("knowledge_quality", "미정")),
		int(summary.get("danger_case_count", 0)),
		int(summary.get("support_trigger_count", 0))
	]
