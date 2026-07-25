extends "res://scripts/poc/annual_mvp_001/annual_mvp_001_scene.gd"

const ThemeFactory = preload("res://scripts/ui/ui_theme_factory.gd")
const AnnualCaseData = preload("res://scripts/poc/core_mvp_001/core_mvp_001_case_data.gd")
const LocalizedCoreScene = preload("res://scenes/poc/annual_mvp_001/annual_mvp_001_core_scene.tscn")
const FourWeekState = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_state_v2.gd")

const PHASE_LABELS := {
	"BOOT": "초기화",
	"WEEK_PLANNING": "주간 계획",
	"WEEK_RESULT": "주간 결과",
	"DEPLOYMENT_DECISION": "출동 결정",
	"PREPARATION": "출동 준비",
	"INCIDENT_ACTIVE": "사건 조사·회수",
	"INCIDENT_RESULT": "사건 결과",
	"POST_INCIDENT_RESEARCH": "사후 연구",
	"QUARTER_SUMMARY": "분기 결산",
	"COMPLETE": "분기 완료"
}
const ACTIVITY_LABELS := {
	"annual001_activity_observation_drill": "관측 훈련",
	"annual001_activity_analysis_desk": "기록 분석",
	"annual001_activity_field_training": "현장 대응 훈련",
	"annual001_activity_interview_duty": "증언 면담 업무",
	"annual001_activity_signal_research": "신호 현상 연구",
	"annual001_activity_companion_drill": "오현 협업 훈련",
	"annual001_activity_rest": "휴식"
}
const COMPETENCY_LABELS := {
	"observation": "관찰",
	"analysis": "분석",
	"field_response": "현장 대응",
	"interpersonal": "대인 대응"
}
const RECOVERY_LABELS := {
	"normal_capture": "정상 회수",
	"costly_capture": "대가를 치른 회수",
	"emergency_capture": "긴급 회수",
	"pending": "판정 대기",
	"unknown": "미정"
}
const KNOWLEDGE_LABELS := {
	"verified": "검증 완료",
	"candidate": "후보 기록",
	"pending": "판정 대기",
	"unknown": "미정"
}


func _ready() -> void:
	_state = FourWeekState.new()
	theme = ThemeFactory.create_theme()
	_add_background()
	super()
	_replace_module_toggle_handler()
	var incident_host := find_child("IncidentHost", true, false) as Control
	if incident_host != null:
		incident_host.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		incident_host.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_localize_rendered_text()
	call_deferred("_focus_current_panel")


func _render() -> void:
	super()
	var snapshot := _state.get_snapshot()
	var max_weeks := int((_config.get("campaign", {}) as Dictionary).get("max_weeks", 4))
	if _week_label != null:
		_week_label.text = "주차: %d / %d" % [int(snapshot.get("week", 0)), max_weeks]
	_localize_rendered_text()
	call_deferred("_focus_current_panel")


func _apply_command(result: Dictionary) -> void:
	super(result)
	for value in result.get("events", []) as Array:
		var event := value as Dictionary
		if String(event.get("event", "")) == "annual_forced_deployment":
			_feedback_label.text = "4주차 활동 결과를 확인했습니다. 월말 기한에 따라 긴급 강제 출동으로 전환됩니다. 시작 위험 +30."
			return


func _deployment_text(snapshot: Dictionary) -> String:
	if int(snapshot.get("week", 0)) == 2:
		return "지금 출동하면 추가 위험이 없습니다. 1주 더 준비하면 역량을 보완할 수 있습니다."
	return "3주차입니다. 지금 출동하면 위험 +15. 지연하면 4주차 활동 3개를 모두 수행한 뒤 긴급 출동으로 전환되어 위험 +30입니다."


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
	var base_case := AnnualCaseData.load_case(String((_config.get("campaign", {}) as Dictionary).get("incident_case_path", "")))
	var override := _adapter.build_case_override(base_case)
	var incident := LocalizedCoreScene.instantiate() as Control
	incident.configure_session(override, int(snapshot.get("run_seed", 2001)), _adapter)
	incident.session_completed.connect(_on_incident_completed)
	incident.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	incident.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_incident_host.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_incident_host.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_incident_host.add_child(incident)
	var investigation_panel := incident.find_child("InvestigationPanel", true, false) as Control
	if investigation_panel != null:
		investigation_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		investigation_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_render()


func _week_result_text(snapshot: Dictionary) -> String:
	var result := snapshot.get("last_week_result", {}) as Dictionary
	if result.is_empty():
		return "주간 결과가 없습니다."
	var activity_names: Array[String] = []
	for value in result.get("activity_ids", []) as Array:
		var activity_id := String(value)
		activity_names.append(String(ACTIVITY_LABELS.get(activity_id, activity_id)))
	return "%d주차 결과\n활동: %s\n피로·역량·기관 지원·신뢰 변화가 다음 출동 준비에 반영됩니다." % [
		int(result.get("week", 0)),
		", ".join(activity_names)
	]


func _research_text(snapshot: Dictionary) -> String:
	var manual := snapshot.get("manual_delta", {}) as Dictionary
	var recovery_id := String((snapshot.get("incident_result", {}) as Dictionary).get("recovery_quality", "pending"))
	var knowledge_id := String(manual.get("status", "pending"))
	return "사건 결과: %s\n매뉴얼 지식 품질: %s\n위험 사례: %d건\n검증 상태와 잔향 자료가 충족되면 공용 보조 스킬을 연구할 수 있습니다." % [
		String(RECOVERY_LABELS.get(recovery_id, recovery_id)),
		String(KNOWLEDGE_LABELS.get(knowledge_id, knowledge_id)),
		(manual.get("danger_cases", []) as Array).size()
	]


func _summary_text(snapshot: Dictionary) -> String:
	var summary := snapshot.get("quarter_summary", {}) as Dictionary
	if summary.is_empty():
		return "분기 결산 모형을 준비 중입니다."
	var competency_id := String(summary.get("competency_focus", "unknown"))
	var recovery_id := String(summary.get("recovery_quality", "unknown"))
	var knowledge_id := String(summary.get("knowledge_quality", "unknown"))
	return "분기 결산 모형 — 최종 엔딩이 아닙니다.\n%d주 동안 권나래는 %s 역량을 중심으로 성장했습니다.\n출동 방식은 %s였습니다.\n회수 품질은 %s입니다.\n지식 품질은 %s이며 위험 사례 %d건이 기록됐습니다.\n오현의 보조는 %d회 발동했습니다.\n연구·장비·스킬 해금은 다음 분기 준비로 이어집니다.\n다음 연도 확장 시 이 결과는 중간 상태로 계승됩니다." % [
		int(summary.get("weeks_used", 0)),
		String(COMPETENCY_LABELS.get(competency_id, competency_id)),
		"긴급 출동" if bool(summary.get("forced_deployment", false)) else "자율 출동",
		String(RECOVERY_LABELS.get(recovery_id, recovery_id)),
		String(KNOWLEDGE_LABELS.get(knowledge_id, knowledge_id)),
		int(summary.get("danger_case_count", 0)),
		int(summary.get("support_trigger_count", 0))
	]


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("ui_cancel"):
		return
	var phase := String((debug_snapshot() as Dictionary).get("phase", "BOOT"))
	if phase != "WEEK_PLANNING":
		return
	_on_back_pressed()
	get_viewport().set_input_as_handled()
	call_deferred("_focus_current_panel")


func _replace_module_toggle_handler() -> void:
	var module_toggle := _find_button_by_text(self, "모듈: 신호 완충") as CheckButton
	if module_toggle == null:
		return
	for connection in module_toggle.toggled.get_connections():
		var callback := connection.get("callable", Callable()) as Callable
		if callback.is_valid() and module_toggle.toggled.is_connected(callback):
			module_toggle.toggled.disconnect(callback)
	module_toggle.toggled.connect(_on_module_toggle_changed)


func _on_module_toggle_changed(enabled: bool) -> void:
	_selected_module_ids.clear()
	if enabled:
		_selected_module_ids.append("annual001_module_signal_buffer")
	_render()


func _find_button_by_text(node: Node, text: String) -> BaseButton:
	if node is BaseButton and (node as BaseButton).text == text:
		return node as BaseButton
	for child in node.get_children():
		var found := _find_button_by_text(child, text)
		if found != null:
			return found
	return null


func _add_background() -> void:
	var background := ColorRect.new()
	background.name = "Background"
	background.color = Color("090d13")
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)


func _localize_rendered_text() -> void:
	var phase_label := find_child("PhaseLabel", true, false) as Label
	if phase_label == null:
		return
	var phase := String((debug_snapshot() as Dictionary).get("phase", "BOOT"))
	phase_label.text = "현재 단계: %s" % String(PHASE_LABELS.get(phase, phase))


func _focus_current_panel() -> void:
	var current := get_viewport().gui_get_focus_owner()
	if current is Control:
		var current_control := current as Control
		if current_control.is_visible_in_tree() and (not current_control is BaseButton or not (current_control as BaseButton).disabled):
			return
	var panel_name := debug_visible_panel()
	var panel := find_child(panel_name, true, false)
	var first_button := _first_enabled_button(panel)
	if first_button != null:
		first_button.grab_focus()
		return
	if _confirm_button != null and not _confirm_button.disabled:
		_confirm_button.grab_focus()
	elif _back_button != null and not _back_button.disabled:
		_back_button.grab_focus()


func _first_enabled_button(node: Node) -> BaseButton:
	if node == null:
		return null
	if node is BaseButton:
		var button := node as BaseButton
		if button.is_visible_in_tree() and not button.disabled:
			return button
	for child in node.get_children():
		var found := _first_enabled_button(child)
		if found != null:
			return found
	return null
