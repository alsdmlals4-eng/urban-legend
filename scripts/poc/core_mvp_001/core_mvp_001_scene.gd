class_name CoreMvp001Scene
extends Control

const CaseData = preload("res://scripts/poc/core_mvp_001/core_mvp_001_case_data.gd")
const CoreState = preload("res://scripts/poc/core_mvp_001/core_mvp_001_state.gd")
const PlaytestLog = preload("res://scripts/poc/core_mvp_001/core_mvp_001_playtest_log.gd")
const ThemeFactory = preload("res://scripts/ui/ui_theme_factory.gd")

const PANEL_ORDER := ["investigation", "hypothesis", "field_test", "recovery", "result"]

var _data: Dictionary = {}
var _state := CoreState.new()
var _log := PlaytestLog.new()
var _selected_record_id := ""
var _selected_hypothesis_id := ""
var _selected_support_ids: Array[String] = []
var _selected_contradiction_ids: Array[String] = []
var _selected_unresolved_ids: Array[String] = []
var _hypothesis_drafts: Dictionary = {}
var _review_panel_key := ""
var _last_action_feedback := ""

var _phase_label: Label
var _understanding_label: Label
var _health_label: Label
var _risk_label: Label
var _feedback_label: Label
var _choice_grid: VBoxContainer
var _manual_list: VBoxContainer
var _hypothesis_summary: Label
var _hypothesis_buttons: VBoxContainer
var _evidence_list: VBoxContainer
var _field_test_label: Label
var _recovery_action_grid: VBoxContainer
var _omen_label: Label
var _last_action_label: Label
var _capture_marks_label: Label
var _result_label: Label
var _phase_host: Control
var _investigation_panel: Control
var _hypothesis_panel: Control
var _field_test_panel: Control
var _recovery_panel: Control
var _result_panel: Control
var _back_button: Button
var _confirm_button: Button


func _ready() -> void:
	theme = ThemeFactory.create_theme()
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_data = CaseData.load_case("res://data/poc/core_mvp_001/afterlife_station_poc.json")
	var started := _state.start(_data, 1001)
	_log.start_session("local-%s" % Time.get_unix_time_from_system(), "core-mvp-001", 1001)
	_build_ui()
	_record_state_events(started)
	_log.record("investigation_scene_viewed", {"scene_count": (_data.get("investigation_scenes", []) as Array).size()})
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

	_phase_host = Control.new()
	_phase_host.name = "PhaseHost"
	_phase_host.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_phase_host.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_phase_host.clip_contents = true
	root_column.add_child(_phase_host)

	_investigation_panel = _build_investigation_panel()
	_hypothesis_panel = _build_hypothesis_panel()
	_field_test_panel = _build_field_test_panel()
	_recovery_panel = _build_recovery_panel()
	_result_panel = _build_result_panel()

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
	_back_button = Button.new()
	_back_button.name = "BackButton"
	_back_button.text = "뒤로"
	_back_button.pressed.connect(_on_back_pressed)
	footer.add_child(_back_button)
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


func _create_phase_panel(panel_name: String, scroll_name: String) -> Dictionary:
	var panel := PanelContainer.new()
	panel.name = panel_name
	panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.visible = false
	_phase_host.add_child(panel)
	var scroll := ScrollContainer.new()
	scroll.name = scroll_name
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_child(scroll)
	var content := VBoxContainer.new()
	content.name = "%sContent" % panel_name
	content.custom_minimum_size = Vector2(900, 0)
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 10)
	scroll.add_child(content)
	return {"panel": panel, "content": content}


func _build_investigation_panel() -> Control:
	var parts := _create_phase_panel("InvestigationPanel", "InvestigationScroll")
	var panel := parts["panel"] as Control
	var column := parts["content"] as VBoxContainer
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
	_choice_grid.add_theme_constant_override("separation", 8)
	split.add_child(_choice_grid)
	_manual_list = VBoxContainer.new()
	_manual_list.name = "ManualList"
	_manual_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_manual_list.add_theme_constant_override("separation", 8)
	split.add_child(_manual_list)
	return panel


func _build_hypothesis_panel() -> Control:
	var parts := _create_phase_panel("HypothesisPanel", "HypothesisScroll")
	var panel := parts["panel"] as Control
	var column := parts["content"] as VBoxContainer
	_hypothesis_summary = Label.new()
	_hypothesis_summary.name = "HypothesisSummary"
	_hypothesis_summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(_hypothesis_summary)
	_hypothesis_buttons = VBoxContainer.new()
	_hypothesis_buttons.name = "HypothesisButtons"
	_hypothesis_buttons.add_theme_constant_override("separation", 8)
	column.add_child(_hypothesis_buttons)
	_evidence_list = VBoxContainer.new()
	_evidence_list.name = "EvidenceList"
	_evidence_list.add_theme_constant_override("separation", 6)
	column.add_child(_evidence_list)
	return panel


func _build_field_test_panel() -> Control:
	var parts := _create_phase_panel("FieldTestPanel", "FieldTestScroll")
	var panel := parts["panel"] as Control
	var column := parts["content"] as VBoxContainer
	_field_test_label = Label.new()
	_field_test_label.name = "FieldTestLabel"
	_field_test_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(_field_test_label)
	return panel


func _build_recovery_panel() -> Control:
	var parts := _create_phase_panel("RecoveryPanel", "RecoveryScroll")
	var panel := parts["panel"] as Control
	var column := parts["content"] as VBoxContainer
	_omen_label = Label.new()
	_omen_label.name = "OmenLabel"
	_omen_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(_omen_label)
	_last_action_label = Label.new()
	_last_action_label.name = "LastActionLabel"
	_last_action_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(_last_action_label)
	_capture_marks_label = Label.new()
	_capture_marks_label.name = "CaptureMarksLabel"
	_capture_marks_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(_capture_marks_label)
	_recovery_action_grid = VBoxContainer.new()
	_recovery_action_grid.name = "RecoveryActionGrid"
	_recovery_action_grid.add_theme_constant_override("separation", 8)
	column.add_child(_recovery_action_grid)
	return panel


func _build_result_panel() -> Control:
	var parts := _create_phase_panel("ResultPanel", "ResultScroll")
	var panel := parts["panel"] as Control
	var column := parts["content"] as VBoxContainer
	_result_label = Label.new()
	_result_label.name = "ResultLabel"
	_result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(_result_label)
	return panel


func _add_header_label(parent: Control, node_name: String) -> Label:
	var label := Label.new()
	label.name = node_name
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(label)
	return label


func _render() -> void:
	var snapshot := _state.get_snapshot()
	var actual_phase := String(snapshot.get("phase", ""))
	var actual_panel_key := _panel_for_phase(actual_phase)
	var visible_panel_key := _review_panel_key if not _review_panel_key.is_empty() else actual_panel_key
	_phase_label.text = "단계: %s%s" % [actual_phase, " · 이전 단계 검토" if not _review_panel_key.is_empty() else ""]
	_understanding_label.text = "이해도: %s" % String(snapshot.get("understanding", ""))
	_health_label.text = "체력: %d" % int(snapshot.get("health", 0))
	_risk_label.text = "위험: %d" % int(snapshot.get("risk", 0))
	_set_visible_panel(visible_panel_key)
	_render_investigation(snapshot)
	_render_hypothesis(snapshot)
	_render_field_test(snapshot)
	_render_recovery(snapshot)
	_render_result(snapshot)
	if not _review_panel_key.is_empty():
		_confirm_button.text = "현재 단계로 돌아가기"
		_confirm_button.disabled = false
	_back_button.text = "이전 단계" if actual_panel_key != "investigation" else "메인 메뉴"
	call_deferred("_focus_first_button")


func _set_visible_panel(panel_key: String) -> void:
	_investigation_panel.visible = panel_key == "investigation"
	_hypothesis_panel.visible = panel_key == "hypothesis"
	_field_test_panel.visible = panel_key == "field_test"
	_recovery_panel.visible = panel_key == "recovery"
	_result_panel.visible = panel_key == "result"


func _panel_for_phase(phase: String) -> String:
	match phase:
		"ELIMINATION": return "investigation"
		"HYPOTHESIS_AUTHORING", "HYPOTHESIS_REFRESH": return "hypothesis"
		"FIELD_TEST": return "field_test"
		"RECOVERY_READY", "EMERGENCY_RECOVERY", "RECOVERY_TURN_START", "OMEN_READ", "RESPONSE_SELECTION", "CAPTURE_WINDOW", "EMERGENCY_CAPTURE": return "recovery"
		"RESULT_COMPARE", "MANUAL_PROMOTION", "COMPLETE": return "result"
		_: return "investigation"


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
		var record_id := String(record["id"])
		var button := Button.new()
		button.text = "%s%s\n%s" % ["● " if record_id == _selected_record_id else "", record.get("title", "기록"), record.get("statement", "")]
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.pressed.connect(_on_record_pressed.bind(record_id))
		_manual_list.add_child(button)
	if _review_panel_key.is_empty() and String(snapshot.get("phase", "")) == "ELIMINATION":
		_confirm_button.text = "가설 작성으로"
		_confirm_button.disabled = (snapshot.get("eliminated_choice_ids", []) as Array).size() != 2


func _render_hypothesis(snapshot: Dictionary) -> void:
	var active_ids := snapshot.get("active_hypothesis_ids", []) as Array
	if not _selected_hypothesis_id.is_empty() and not active_ids.has(_selected_hypothesis_id):
		_store_current_draft()
		_selected_hypothesis_id = ""
		_selected_support_ids.clear()
		_selected_contradiction_ids.clear()
		_selected_unresolved_ids.clear()
	_hypothesis_summary.text = "선택 가설: %s\n지지 %d / 반박 %d / 미해결 %d" % [
		_selected_hypothesis_id if not _selected_hypothesis_id.is_empty() else "선택하지 않음",
		_selected_support_ids.size(),
		_selected_contradiction_ids.size(),
		_selected_unresolved_ids.size()
	]
	_clear_children(_hypothesis_buttons)
	var hypothesis_index := CaseData.index_by_id(_data.get("hypotheses", []) as Array)
	for hypothesis_id_value in active_ids:
		var hypothesis_id := String(hypothesis_id_value)
		if not hypothesis_index.has(hypothesis_id):
			continue
		var hypothesis := hypothesis_index[hypothesis_id] as Dictionary
		var button := Button.new()
		button.text = "%s%s" % ["● " if hypothesis_id == _selected_hypothesis_id else "", String(hypothesis.get("rule_text", "가설"))]
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.pressed.connect(_select_hypothesis.bind(hypothesis_id))
		_hypothesis_buttons.add_child(button)
	_clear_children(_evidence_list)
	for value in _data.get("clues", []):
		var clue := value as Dictionary
		var clue_id := String(clue["id"])
		var role := String(clue.get("role", ""))
		var toggle := CheckButton.new()
		toggle.text = "[%s] %s" % [role, clue.get("title", clue_id)]
		toggle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		toggle.button_pressed = _is_evidence_selected(clue_id, role)
		toggle.toggled.connect(_toggle_evidence.bind(clue_id, role))
		_evidence_list.add_child(toggle)
	if _review_panel_key.is_empty() and String(snapshot.get("phase", "")) in ["HYPOTHESIS_AUTHORING", "HYPOTHESIS_REFRESH"]:
		_confirm_button.text = "가설 제출"
		_confirm_button.disabled = _selected_hypothesis_id.is_empty() or _selected_support_ids.is_empty()


func _render_field_test(snapshot: Dictionary) -> void:
	var hypothesis_index := CaseData.index_by_id(_data.get("hypotheses", []) as Array)
	var hypothesis := hypothesis_index.get(_selected_hypothesis_id, {}) as Dictionary
	_field_test_label.text = "현장 검증 가설\n%s\n\n불완전한 조건에서 실제 반응을 확인한다. 실패해도 정답을 자동 공개하지 않고 반응 단서·피해·위험 사례를 남긴다." % String(hypothesis.get("rule_text", "선택한 가설이 없다."))
	if _review_panel_key.is_empty() and String(snapshot.get("phase", "")) == "FIELD_TEST":
		_confirm_button.text = "현장 검증 실행"
		_confirm_button.disabled = _selected_hypothesis_id.is_empty()


func _render_recovery(snapshot: Dictionary) -> void:
	_clear_children(_recovery_action_grid)
	var phase := String(snapshot.get("phase", ""))
	var marks := snapshot.get("capture_marks", []) as Array
	_capture_marks_label.text = "포획 표식 %d/3: %s" % [marks.size(), ", ".join(marks)]
	_last_action_label.text = _last_action_feedback
	var omen := snapshot.get("omen_result", {}) as Dictionary
	if phase in ["RECOVERY_READY", "EMERGENCY_RECOVERY", "RECOVERY_TURN_START"]:
		_omen_label.text = "조사에서 만든 이해를 회수 전투의 전조 해석에 적용한다. 턴을 시작하면 패턴이 먼저 잠긴다."
		if _review_panel_key.is_empty():
			_confirm_button.text = "회수 턴 시작"
			_confirm_button.disabled = false
	elif phase == "OMEN_READ":
		_omen_label.text = "전조가 나타났다. 현재 이해도로 행동명을 해석한다."
		if _review_panel_key.is_empty():
			_confirm_button.text = "전조 해석"
			_confirm_button.disabled = false
	elif phase == "RESPONSE_SELECTION":
		_omen_label.text = String(omen.get("text", "놈은 무언가 하려 한다."))
		for field_name in omen.get("revealed_fields", []):
			_omen_label.text += "\n%s: %s" % [field_name, omen.get(field_name, "")]
		for value in _data.get("recovery_actions", []):
			var action := value as Dictionary
			if String(action.get("category", "")) == "capture":
				continue
			var button := Button.new()
			button.text = String(action.get("label", action.get("id", "행동")))
			button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			button.pressed.connect(_on_recovery_action.bind(String(action["id"])))
			_recovery_action_grid.add_child(button)
		if _review_panel_key.is_empty():
			_confirm_button.text = "대응을 선택한다"
			_confirm_button.disabled = true
	elif phase in ["CAPTURE_WINDOW", "EMERGENCY_CAPTURE"]:
		_omen_label.text = "포획 창이 열렸다. 잔향을 봉쇄한다.%s" % (" 긴급 회수는 최고 품질을 받을 수 없다." if phase == "EMERGENCY_CAPTURE" else "")
		if _review_panel_key.is_empty():
			_confirm_button.text = "포획 실행"
			_confirm_button.disabled = false


func _render_result(snapshot: Dictionary) -> void:
	if String(snapshot.get("phase", "")) not in ["RESULT_COMPARE", "MANUAL_PROMOTION", "COMPLETE"]:
		return
	var result := _state.build_result()
	var delta := _state.build_manual_delta()
	_result_label.text = "회수 품질: %s\n피해 관리: %s (피해 %s)\n지식 품질: %s\n규칙: %s\n위험 사례: %d" % [
		result.get("recovery_quality", "pending"),
		result.get("damage_management", "pending"),
		result.get("damage", 0),
		delta.get("status", "candidate"),
		delta.get("rule_text", ""),
		(delta.get("danger_cases", []) as Array).size()
	]
	if _review_panel_key.is_empty():
		_confirm_button.text = "매뉴얼 반영"
		_confirm_button.disabled = String(snapshot.get("phase", "")) == "COMPLETE"


func _on_record_pressed(record_id: String) -> void:
	_selected_record_id = record_id
	_feedback_label.text = "기록 선택: %s" % record_id
	_render()


func _on_choice_pressed(choice_id: String) -> void:
	if _selected_record_id.is_empty():
		_feedback_label.text = "먼저 관련 매뉴얼 기록을 선택한다."
		return
	debug_link_record_to_choice(_selected_record_id, choice_id)


func debug_link_record_to_choice(record_id: String, choice_id: String) -> Dictionary:
	_log.record("manual_record_linked", {"record_id": record_id, "choice_id": choice_id})
	var result := _state.link_record_to_choice(record_id, choice_id)
	_record_state_events(result)
	_feedback_label.text = String(result.get("feedback", result.get("error", "")))
	_render()
	return result


func debug_snapshot() -> Dictionary:
	return _state.get_snapshot()


func debug_confirm_current_step() -> void:
	_on_confirm_pressed()


func debug_review_previous_panel() -> void:
	_review_previous_panel()


func debug_return_to_current_panel() -> void:
	_review_panel_key = ""
	_render()


func _select_hypothesis(hypothesis_id: String) -> void:
	_store_current_draft()
	_selected_hypothesis_id = hypothesis_id
	_load_draft(hypothesis_id)
	_feedback_label.text = "가설 선택: %s" % hypothesis_id
	_render()


func _store_current_draft() -> void:
	if _selected_hypothesis_id.is_empty():
		return
	_hypothesis_drafts[_selected_hypothesis_id] = {
		"support": _selected_support_ids.duplicate(),
		"contradiction": _selected_contradiction_ids.duplicate(),
		"unresolved": _selected_unresolved_ids.duplicate()
	}


func _load_draft(hypothesis_id: String) -> void:
	_selected_support_ids.clear()
	_selected_contradiction_ids.clear()
	_selected_unresolved_ids.clear()
	if not _hypothesis_drafts.has(hypothesis_id):
		return
	var draft := _hypothesis_drafts[hypothesis_id] as Dictionary
	_selected_support_ids.assign(draft.get("support", []) as Array)
	_selected_contradiction_ids.assign(draft.get("contradiction", []) as Array)
	_selected_unresolved_ids.assign(draft.get("unresolved", []) as Array)


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
	_store_current_draft()
	_render()


func _is_evidence_selected(clue_id: String, role: String) -> bool:
	match role:
		"support": return _selected_support_ids.has(clue_id)
		"contradiction": return _selected_contradiction_ids.has(clue_id)
		_: return _selected_unresolved_ids.has(clue_id)


func _on_confirm_pressed() -> void:
	if not _review_panel_key.is_empty():
		_review_panel_key = ""
		_feedback_label.text = "현재 진행 단계로 돌아왔다."
		_render()
		return
	var phase := String(_state.get_snapshot().get("phase", ""))
	var result: Dictionary = {}
	match phase:
		"ELIMINATION":
			result = _state.advance_to_hypothesis()
		"HYPOTHESIS_AUTHORING", "HYPOTHESIS_REFRESH":
			_store_current_draft()
			result = _state.submit_hypothesis(_selected_hypothesis_id, _selected_support_ids, _selected_contradiction_ids, _selected_unresolved_ids)
		"FIELD_TEST":
			var hypothesis := CaseData.index_by_id(_data["hypotheses"]).get(_selected_hypothesis_id, {}) as Dictionary
			result = _state.resolve_field_test(String(hypothesis.get("field_test_id", "")))
		"RECOVERY_READY", "EMERGENCY_RECOVERY", "RECOVERY_TURN_START":
			result = _state.begin_recovery_turn()
		"OMEN_READ":
			result = _state.read_current_omen()
		"CAPTURE_WINDOW", "EMERGENCY_CAPTURE":
			result = _state.execute_capture()
		"RESULT_COMPARE":
			result = _state.confirm_manual_promotion()
	_record_state_events(result)
	if not result.is_empty():
		_feedback_label.text = _feedback_for_result(result)
	_render()


func _feedback_for_result(result: Dictionary) -> String:
	if not result.get("ok", false):
		return String(result.get("error", "명령을 실행하지 못했다."))
	if result.has("correct"):
		if result.get("correct", false):
			return "가설이 현장 반응과 일치했다. 회수 준비로 전환한다."
		return "가설이 현장 반응과 맞지 않았다. 반응 단서 %s와 위험 사례를 기록했다." % String(result.get("reaction_clue_id", ""))
	if result.has("success"):
		return String(result.get("text", "전조 해석을 마쳤다."))
	return "단계를 진행했다."


func _on_recovery_action(action_id: String) -> void:
	var result := _state.resolve_recovery_action(action_id)
	_record_state_events(result)
	_last_action_feedback = "직전 대응: %s / 피해 %s / 위험 +%s" % [
		"성공" if result.get("valid", false) else "실패",
		result.get("damage", 0),
		result.get("risk_delta", 0)
	]
	_feedback_label.text = _last_action_feedback
	_render()


func _record_state_events(result: Dictionary) -> void:
	for value in result.get("events", []):
		if typeof(value) != TYPE_DICTIONARY:
			continue
		var event := (value as Dictionary).duplicate(true)
		var event_name := String(event.get("event", ""))
		event.erase("event")
		if not event_name.is_empty():
			_log.record(event_name, event)


func _on_export_log() -> void:
	var error := _log.write_jsonl("user://core_mvp_001_playtest.jsonl")
	_feedback_label.text = "로그 저장 완료" if error == OK else "로그 저장 실패: %s" % error


func _on_back_pressed() -> void:
	_review_previous_panel()


func _review_previous_panel() -> void:
	var actual_panel := _panel_for_phase(String(_state.get_snapshot().get("phase", "")))
	var current_index := PANEL_ORDER.find(actual_panel)
	if current_index <= 0:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		return
	_review_panel_key = String(PANEL_ORDER[current_index - 1])
	_feedback_label.text = "이전 단계 내용을 검토한다. 선택한 근거와 가설은 유지된다."
	_render()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_back_pressed()
		get_viewport().set_input_as_handled()


func _focus_first_button() -> void:
	var panel := _panel_for_key(_review_panel_key if not _review_panel_key.is_empty() else _panel_for_phase(String(_state.get_snapshot().get("phase", ""))))
	if panel != null:
		for node in panel.find_children("*", "Button", true, false):
			var button := node as Button
			if button.visible and not button.disabled:
				button.grab_focus()
				return
	if _confirm_button != null and not _confirm_button.disabled:
		_confirm_button.grab_focus()
	elif _back_button != null:
		_back_button.grab_focus()


func _panel_for_key(panel_key: String) -> Control:
	match panel_key:
		"investigation": return _investigation_panel
		"hypothesis": return _hypothesis_panel
		"field_test": return _field_test_panel
		"recovery": return _recovery_panel
		"result": return _result_panel
		_: return null


func _clear_children(parent: Node) -> void:
	for child in parent.get_children():
		parent.remove_child(child)
		child.queue_free()
