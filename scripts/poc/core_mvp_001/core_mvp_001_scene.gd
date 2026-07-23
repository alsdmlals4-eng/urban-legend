class_name CoreMvp001Scene
extends Control

const CaseData = preload("res://scripts/poc/core_mvp_001/core_mvp_001_case_data.gd")
const CoreState = preload("res://scripts/poc/core_mvp_001/core_mvp_001_state.gd")
const PlaytestLog = preload("res://scripts/poc/core_mvp_001/core_mvp_001_playtest_log.gd")

var _data: Dictionary = {}
var _state := CoreState.new()
var _log := PlaytestLog.new()
var _selected_record_id := ""
var _selected_hypothesis_id := ""
var _selected_support_ids: Array[String] = []
var _selected_contradiction_ids: Array[String] = []
var _selected_unresolved_ids: Array[String] = []
var _phase_label: Label
var _understanding_label: Label
var _health_label: Label
var _risk_label: Label
var _feedback_label: Label
var _choice_grid: VBoxContainer
var _manual_list: VBoxContainer
var _hypothesis_summary: Label
var _evidence_list: VBoxContainer
var _recovery_action_grid: VBoxContainer
var _omen_label: Label
var _capture_marks_label: Label
var _result_label: Label
var _investigation_panel: Control
var _hypothesis_panel: Control
var _recovery_panel: Control
var _result_panel: Control
var _confirm_button: Button


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_data = CaseData.load_case("res://data/poc/core_mvp_001/afterlife_station_poc.json")
	var started := _state.start(_data, 1001)
	_log.start_session("local-%s" % Time.get_unix_time_from_system(), "core-mvp-001", 1001)
	_build_ui()
	if not started.get("ok", false):
		_feedback_label.text = String(started.get("error", "PoC 초기화 실패"))
	_render()
	call_deferred("_focus_first_button")


func _build_ui() -> void:
	var safe_frame := MarginContainer.new()
	safe_frame.name = "SafeFrame"
	safe_frame.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	safe_frame.add_theme_constant_override("margin_left", 24)
	safe_frame.add_theme_constant_override("margin_top", 20)
	safe_frame.add_theme_constant_override("margin_right", 24)
	safe_frame.add_theme_constant_override("margin_bottom", 20)
	add_child(safe_frame)

	var root_column := VBoxContainer.new()
	root_column.name = "RootColumn"
	root_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root_column.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root_column.add_theme_constant_override("separation", 10)
	safe_frame.add_child(root_column)

	var header := HBoxContainer.new()
	header.name = "Header"
	header.add_theme_constant_override("separation", 14)
	root_column.add_child(header)
	_phase_label = _add_header_label(header, "PhaseLabel")
	_understanding_label = _add_header_label(header, "UnderstandingLabel")
	_health_label = _add_header_label(header, "HealthLabel")
	_risk_label = _add_header_label(header, "RiskLabel")

	var work_scroll := ScrollContainer.new()
	work_scroll.name = "WorkScroll"
	work_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	work_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root_column.add_child(work_scroll)
	var work_stack := VBoxContainer.new()
	work_stack.name = "WorkStack"
	work_stack.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	work_scroll.add_child(work_stack)

	_investigation_panel = _build_investigation_panel()
	_hypothesis_panel = _build_hypothesis_panel()
	_recovery_panel = _build_recovery_panel()
	_result_panel = _build_result_panel()
	work_stack.add_child(_investigation_panel)
	work_stack.add_child(_hypothesis_panel)
	work_stack.add_child(_recovery_panel)
	work_stack.add_child(_result_panel)

	_feedback_label = Label.new()
	_feedback_label.name = "FeedbackLabel"
	_feedback_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_feedback_label.custom_minimum_size.y = 42
	root_column.add_child(_feedback_label)

	var footer := HBoxContainer.new()
	footer.name = "Footer"
	footer.alignment = BoxContainer.ALIGNMENT_END
	footer.add_theme_constant_override("separation", 10)
	root_column.add_child(footer)
	var back_button := Button.new()
	back_button.name = "BackButton"
	back_button.text = "뒤로"
	back_button.pressed.connect(_on_back_pressed)
	footer.add_child(back_button)
	_confirm_button = Button.new()
	_confirm_button.name = "ConfirmButton"
	_confirm_button.text = "확인"
	_confirm_button.pressed.connect(_on_confirm_pressed)
	footer.add_child(_confirm_button)
	var export_button := Button.new()
	export_button.name = "ExportLogButton"
	export_button.text = "로그 내보내기"
	export_button.pressed.connect(_on_export_log)
	footer.add_child(export_button)


func _build_investigation_panel() -> Control:
	var panel := PanelContainer.new()
	panel.name = "InvestigationPanel"
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 8)
	panel.add_child(column)
	var situation := Label.new()
	situation.name = "SituationLabel"
	situation.text = "세 기록 지점을 조사했다. 매뉴얼 기록을 선택지에 연결해 모순되는 두 가능성을 배제한다."
	situation.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(situation)
	var split := HBoxContainer.new()
	split.name = "MainSplit"
	split.add_theme_constant_override("separation", 16)
	column.add_child(split)
	_choice_grid = VBoxContainer.new()
	_choice_grid.name = "ChoiceGrid"
	_choice_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	split.add_child(_choice_grid)
	_manual_list = VBoxContainer.new()
	_manual_list.name = "ManualList"
	_manual_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	split.add_child(_manual_list)
	return panel


func _build_hypothesis_panel() -> Control:
	var panel := PanelContainer.new()
	panel.name = "HypothesisPanel"
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 8)
	panel.add_child(column)
	_hypothesis_summary = Label.new()
	_hypothesis_summary.name = "HypothesisSummary"
	_hypothesis_summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(_hypothesis_summary)
	var hypothesis_buttons := HBoxContainer.new()
	hypothesis_buttons.name = "HypothesisButtons"
	column.add_child(hypothesis_buttons)
	for value in _data.get("hypotheses", []):
		var hypothesis := value as Dictionary
		var button := Button.new()
		button.text = String(hypothesis.get("rule_text", "가설"))
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.pressed.connect(_select_hypothesis.bind(String(hypothesis["id"])))
		hypothesis_buttons.add_child(button)
	_evidence_list = VBoxContainer.new()
	_evidence_list.name = "EvidenceList"
	column.add_child(_evidence_list)
	return panel


func _build_recovery_panel() -> Control:
	var panel := PanelContainer.new()
	panel.name = "RecoveryPanel"
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 8)
	panel.add_child(column)
	_omen_label = Label.new()
	_omen_label.name = "OmenLabel"
	_omen_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(_omen_label)
	_capture_marks_label = Label.new()
	_capture_marks_label.name = "CaptureMarksLabel"
	column.add_child(_capture_marks_label)
	_recovery_action_grid = VBoxContainer.new()
	_recovery_action_grid.name = "RecoveryActionGrid"
	column.add_child(_recovery_action_grid)
	return panel


func _build_result_panel() -> Control:
	var panel := PanelContainer.new()
	panel.name = "ResultPanel"
	_result_label = Label.new()
	_result_label.name = "ResultLabel"
	_result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(_result_label)
	return panel


func _add_header_label(parent: Control, node_name: String) -> Label:
	var label := Label.new()
	label.name = node_name
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(label)
	return label


func _render() -> void:
	var snapshot := _state.get_snapshot()
	_phase_label.text = "단계: %s" % String(snapshot.get("phase", ""))
	_understanding_label.text = "이해도: %s" % String(snapshot.get("understanding", ""))
	_health_label.text = "체력: %d" % int(snapshot.get("health", 0))
	_risk_label.text = "위험: %d" % int(snapshot.get("risk", 0))
	var phase := String(snapshot.get("phase", ""))
	_investigation_panel.visible = phase == "ELIMINATION"
	_hypothesis_panel.visible = phase in ["HYPOTHESIS_AUTHORING", "HYPOTHESIS_REFRESH", "FIELD_TEST"]
	_recovery_panel.visible = phase in ["RECOVERY_READY", "RECOVERY_TURN_START", "OMEN_READ", "RESPONSE_SELECTION", "CAPTURE_WINDOW", "EMERGENCY_CAPTURE"]
	_result_panel.visible = phase in ["RESULT_COMPARE", "COMPLETE"]
	_render_investigation(snapshot)
	_render_hypothesis(snapshot)
	_render_recovery(snapshot)
	_render_result(snapshot)
	call_deferred("_focus_first_button")


func _render_investigation(snapshot: Dictionary) -> void:
	_clear_children(_choice_grid)
	for value in _data.get("choices", []):
		var choice := value as Dictionary
		var choice_id := String(choice["id"])
		var button := Button.new()
		button.text = String(choice.get("label", choice_id))
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.disabled = (snapshot.get("eliminated_choice_ids", []) as Array).has(choice_id)
		button.pressed.connect(_on_choice_pressed.bind(choice_id))
		_choice_grid.add_child(button)
	_clear_children(_manual_list)
	for value in _data.get("manual_records", []):
		var record := value as Dictionary
		var button := Button.new()
		button.text = "%s\n%s" % [record.get("title", "기록"), record.get("statement", "")]
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.pressed.connect(_on_record_pressed.bind(String(record["id"])))
		_manual_list.add_child(button)
	_confirm_button.text = "가설 작성으로"
	_confirm_button.disabled = (snapshot.get("eliminated_choice_ids", []) as Array).size() != 2


func _render_hypothesis(snapshot: Dictionary) -> void:
	_hypothesis_summary.text = "선택 가설: %s\n지지 %d / 반박 %d / 미해결 %d" % [
		_selected_hypothesis_id,
		_selected_support_ids.size(),
		_selected_contradiction_ids.size(),
		_selected_unresolved_ids.size()
	]
	_clear_children(_evidence_list)
	for value in _data.get("clues", []):
		var clue := value as Dictionary
		var clue_id := String(clue["id"])
		var toggle := CheckButton.new()
		toggle.text = "[%s] %s" % [clue.get("role", ""), clue.get("title", clue_id)]
		toggle.button_pressed = _is_evidence_selected(clue_id, String(clue.get("role", "")))
		toggle.toggled.connect(_toggle_evidence.bind(clue_id, String(clue.get("role", ""))))
		_evidence_list.add_child(toggle)
	if String(snapshot.get("phase", "")) == "FIELD_TEST":
		_confirm_button.text = "현장 검증"
		_confirm_button.disabled = false
	else:
		_confirm_button.text = "가설 제출"
		_confirm_button.disabled = _selected_hypothesis_id.is_empty() or _selected_support_ids.is_empty()


func _render_recovery(snapshot: Dictionary) -> void:
	_clear_children(_recovery_action_grid)
	var phase := String(snapshot.get("phase", ""))
	_capture_marks_label.text = "포획 표식: %s" % ", ".join(snapshot.get("capture_marks", []))
	if phase in ["RECOVERY_READY", "RECOVERY_TURN_START"]:
		_state.begin_recovery_turn()
		snapshot = _state.get_snapshot()
		phase = String(snapshot.get("phase", ""))
	if phase == "OMEN_READ":
		_omen_label.text = "전조가 나타났다. 현재 이해도로 해석한다."
		_confirm_button.text = "전조 해석"
		_confirm_button.disabled = false
	elif phase == "RESPONSE_SELECTION":
		_omen_label.text = "전조 해석 완료. 대응을 선택한다."
		for value in _data.get("recovery_actions", []):
			var action := value as Dictionary
			if String(action.get("category", "")) == "capture":
				continue
			var button := Button.new()
			button.text = String(action.get("label", action.get("id", "행동")))
			button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			button.pressed.connect(_on_recovery_action.bind(String(action["id"])))
			_recovery_action_grid.add_child(button)
		_confirm_button.text = "대응 선택"
		_confirm_button.disabled = true
	elif phase in ["CAPTURE_WINDOW", "EMERGENCY_CAPTURE"]:
		_omen_label.text = "포획 창이 열렸다. 잔향을 봉쇄한다."
		_confirm_button.text = "포획 실행"
		_confirm_button.disabled = false


func _render_result(snapshot: Dictionary) -> void:
	if String(snapshot.get("phase", "")) not in ["RESULT_COMPARE", "COMPLETE"]:
		return
	var result := _state.build_result()
	var delta := _state.build_manual_delta()
	_result_label.text = "결과: %s\n피해: %s\n지식 품질: %s\n위험 사례: %d" % [
		result.get("outcome_id", ""),
		result.get("damage", 0),
		delta.get("status", "candidate"),
		(delta.get("danger_cases", []) as Array).size()
	]
	_confirm_button.text = "매뉴얼 반영"
	_confirm_button.disabled = String(snapshot.get("phase", "")) == "COMPLETE"


func _on_record_pressed(record_id: String) -> void:
	_selected_record_id = record_id
	_feedback_label.text = "기록 선택: %s" % record_id


func _on_choice_pressed(choice_id: String) -> void:
	if _selected_record_id.is_empty():
		_feedback_label.text = "먼저 관련 매뉴얼 기록을 선택한다."
		return
	debug_link_record_to_choice(_selected_record_id, choice_id)


func debug_link_record_to_choice(record_id: String, choice_id: String) -> Dictionary:
	var result := _state.link_record_to_choice(record_id, choice_id)
	_log.record("manual_record_linked", {"record_id": record_id, "choice_id": choice_id, "valid": result.get("ok", false)})
	_feedback_label.text = String(result.get("feedback", result.get("error", "")))
	_render()
	return result


func debug_snapshot() -> Dictionary:
	return _state.get_snapshot()


func _select_hypothesis(hypothesis_id: String) -> void:
	_selected_hypothesis_id = hypothesis_id
	_feedback_label.text = "가설 선택: %s" % hypothesis_id
	_render()


func _toggle_evidence(enabled: bool, clue_id: String, role: String) -> void:
	var target: Array[String]
	match role:
		"support": target = _selected_support_ids
		"contradiction": target = _selected_contradiction_ids
		_: target = _selected_unresolved_ids
	if enabled and not target.has(clue_id):
		target.append(clue_id)
	elif not enabled:
		target.erase(clue_id)
	_render()


func _is_evidence_selected(clue_id: String, role: String) -> bool:
	match role:
		"support": return _selected_support_ids.has(clue_id)
		"contradiction": return _selected_contradiction_ids.has(clue_id)
		_: return _selected_unresolved_ids.has(clue_id)


func _on_confirm_pressed() -> void:
	var phase := String(_state.get_snapshot().get("phase", ""))
	var result: Dictionary = {}
	match phase:
		"ELIMINATION":
			result = _state.advance_to_hypothesis()
		"HYPOTHESIS_AUTHORING", "HYPOTHESIS_REFRESH":
			result = _state.submit_hypothesis(_selected_hypothesis_id, _selected_support_ids, _selected_contradiction_ids, _selected_unresolved_ids)
		"FIELD_TEST":
			var hypothesis := CaseData.index_by_id(_data["hypotheses"]).get(_selected_hypothesis_id, {}) as Dictionary
			result = _state.resolve_field_test(String(hypothesis.get("field_test_id", "")))
		"OMEN_READ":
			result = _state.read_current_omen()
		"CAPTURE_WINDOW", "EMERGENCY_CAPTURE":
			result = _state.execute_capture()
		"RESULT_COMPARE":
			result = _state.confirm_manual_promotion()
	if not result.is_empty():
		_feedback_label.text = String(result.get("error", ""))
	_render()


func _on_recovery_action(action_id: String) -> void:
	var result := _state.resolve_recovery_action(action_id)
	_log.record("recovery_action_resolved", {"action_id": action_id, "valid": result.get("valid", false), "damage": result.get("damage", 0)})
	_feedback_label.text = "대응 %s / 피해 %s" % ["성공" if result.get("valid", false) else "실패", result.get("damage", 0)]
	_render()


func _on_export_log() -> void:
	var error := _log.write_jsonl("user://core_mvp_001_playtest.jsonl")
	_feedback_label.text = "로그 저장 완료" if error == OK else "로그 저장 실패: %s" % error


func _on_back_pressed() -> void:
	_feedback_label.text = "선택한 근거를 유지한다. 이전 단계의 확정 상태는 되돌리지 않는다."
	_focus_first_button()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_back_pressed()
		get_viewport().set_input_as_handled()


func _focus_first_button() -> void:
	var buttons := find_children("*", "Button", true, false)
	for node in buttons:
		var button := node as Button
		if button.visible and not button.disabled:
			button.grab_focus()
			return


func _clear_children(parent: Node) -> void:
	for child in parent.get_children():
		child.queue_free()
