class_name CanonV2OperationOverlay
extends Control

const ObligationPolicyScript := preload("res://scripts/core/protection_obligation_policy.gd")
const RecoveryClockScript := preload("res://scripts/ui/recovery_clock.gd")

var _runtime_state: Dictionary = {}
var _mode := "recovery"
var _manual_detail_panel: PanelContainer
var _rule_summary_label: Label
var _recovery_clock_cluster: HBoxContainer
var _stability_clock
var _danger_clock
var _stability_clock_label: Label
var _danger_clock_label: Label
var _detail_stack: VBoxContainer
var _detail_toggle_button: Button
var _detail_stack_open := false
var _priority_label: Label
var _obligation_list_label: Label
var _termination_title_label: Label
var _termination_detail_label: Label
var _recovery_support_panel: PanelContainer
var _recovery_support_content: VBoxContainer
var _follow_up_label: Label
var _mode_label: Label
var _confirmation_layer: CenterContainer
var _confirmation_panel: PanelContainer
var _confirmation_detail_label: Label
var _confirm_button: Button
var _cancel_button: Button
var _pending_confirm: Callable
var _pending_cancel: Callable
var _previous_focus: Control


func _ready() -> void:
	_ensure_ui()
	_refresh()


func configure_for_test(runtime_state: Dictionary, mode: String) -> void:
	configure(runtime_state, mode)


func configure(runtime_state: Dictionary, mode: String) -> void:
	_runtime_state = runtime_state.duplicate(true)
	_mode = mode
	_ensure_ui()
	_refresh()


func set_recovery_clock_presentation(state: Dictionary) -> void:
	_runtime_state["recovery_clock"] = state.duplicate(true)
	_ensure_ui()
	_refresh_recovery_clocks()


func set_recovery_clock_feedback(kind: String) -> void:
	if _recovery_clock_cluster == null:
		return
	if kind in ["danger", "surge"]:
		_danger_clock.play_feedback(kind)
	elif kind in ["stability", "relief"]:
		_stability_clock.play_feedback("relief")


func open_manual_from_quick_action() -> void:
	_ensure_ui()
	if _mode != "recovery" or _manual_detail_panel.visible:
		return
	_toggle_manual_detail()


func set_rule_strip_top_inset(top_inset: int) -> void:
	_ensure_ui()
	var safe_area := get_node_or_null("SafeArea") as MarginContainer
	if safe_area != null:
		safe_area.add_theme_constant_override("margin_top", top_inset)


func request_action_confirmation(
	preview: Dictionary,
	on_confirm: Callable,
	on_cancel: Callable = Callable()
) -> void:
	_ensure_ui()
	_pending_confirm = on_confirm
	_pending_cancel = on_cancel
	_previous_focus = get_viewport().gui_get_focus_owner()
	_confirmation_detail_label.text = _build_confirmation_text(preview)
	_confirmation_layer.mouse_filter = Control.MOUSE_FILTER_STOP
	_confirmation_layer.visible = true
	_confirmation_panel.visible = true
	_confirm_button.disabled = not bool(preview.get("allowed", true))
	_confirm_button.grab_focus()


func close_action_confirmation() -> void:
	_hide_confirmation(true)


func _ensure_ui() -> void:
	if get_node_or_null("SafeArea") != null:
		return
	name = "CanonV2OperationOverlay"
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	z_index = 90

	var safe_area := MarginContainer.new()
	safe_area.name = "SafeArea"
	safe_area.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	safe_area.add_theme_constant_override("margin_left", 18)
	safe_area.add_theme_constant_override("margin_top", 14)
	safe_area.add_theme_constant_override("margin_right", 18)
	safe_area.add_theme_constant_override("margin_bottom", 14)
	safe_area.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(safe_area)

	var root_layout := VBoxContainer.new()
	root_layout.name = "RootLayout"
	root_layout.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root_layout.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root_layout.add_theme_constant_override("separation", 8)
	root_layout.mouse_filter = Control.MOUSE_FILTER_IGNORE
	safe_area.add_child(root_layout)

	var rule_strip_panel := PanelContainer.new()
	rule_strip_panel.name = "RuleStripPanel"
	rule_strip_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rule_strip_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	rule_strip_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.07, 0.075, 0.09, 0.94), Color(0.45, 0.67, 0.72, 0.9)))
	root_layout.add_child(rule_strip_panel)

	var rule_strip := HBoxContainer.new()
	rule_strip.name = "RuleStrip"
	rule_strip.add_theme_constant_override("separation", 10)
	rule_strip_panel.add_child(rule_strip)

	_mode_label = Label.new()
	_mode_label.name = "ModeLabel"
	_mode_label.custom_minimum_size = Vector2(112, 0)
	_mode_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_mode_label.add_theme_font_size_override("font_size", 15)
	rule_strip.add_child(_mode_label)

	_rule_summary_label = Label.new()
	_rule_summary_label.name = "RuleSummaryLabel"
	_rule_summary_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_rule_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_rule_summary_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_rule_summary_label.add_theme_font_size_override("font_size", 15)
	rule_strip.add_child(_rule_summary_label)

	_recovery_clock_cluster = HBoxContainer.new()
	_recovery_clock_cluster.name = "RecoveryClockCluster"
	_recovery_clock_cluster.add_theme_constant_override("separation", 6)
	rule_strip.add_child(_recovery_clock_cluster)

	_stability_clock = RecoveryClockScript.new()
	_stability_clock.name = "StabilityClock"
	_stability_clock.total_segments = 8
	_stability_clock.active_color = Color("76c7b0")
	_recovery_clock_cluster.add_child(_stability_clock)
	_stability_clock_label = Label.new()
	_stability_clock_label.name = "StabilityClockLabel"
	_stability_clock_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_stability_clock_label.add_theme_font_size_override("font_size", 13)
	_recovery_clock_cluster.add_child(_stability_clock_label)

	_danger_clock = RecoveryClockScript.new()
	_danger_clock.name = "DangerClock"
	_danger_clock.total_segments = 6
	_danger_clock.active_color = Color("c99a61")
	_recovery_clock_cluster.add_child(_danger_clock)
	_danger_clock_label = Label.new()
	_danger_clock_label.name = "DangerClockLabel"
	_danger_clock_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_danger_clock_label.add_theme_font_size_override("font_size", 13)
	_recovery_clock_cluster.add_child(_danger_clock_label)

	_detail_toggle_button = Button.new()
	_detail_toggle_button.name = "DetailToggleButton"
	_detail_toggle_button.text = "작전 상태 열기"
	_detail_toggle_button.focus_mode = Control.FOCUS_ALL
	_detail_toggle_button.tooltip_text = "보호 의무와 종결 판단을 확인합니다."
	_detail_toggle_button.pressed.connect(_toggle_detail_stack)
	rule_strip.add_child(_detail_toggle_button)

	_manual_detail_panel = PanelContainer.new()
	_manual_detail_panel.name = "ManualDetailPanel"
	_manual_detail_panel.visible = false
	_manual_detail_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	_manual_detail_panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_manual_detail_panel.anchor_left = 0.58
	_manual_detail_panel.anchor_top = 0.10
	_manual_detail_panel.anchor_right = 0.985
	_manual_detail_panel.anchor_bottom = 0.58
	_manual_detail_panel.z_index = 120
	_manual_detail_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.055, 0.06, 0.075, 0.97), Color(0.34, 0.46, 0.54, 0.85)))
	add_child(_manual_detail_panel)
	var manual_content := VBoxContainer.new()
	manual_content.name = "ManualContent"
	manual_content.add_theme_constant_override("separation", 6)
	_manual_detail_panel.add_child(manual_content)
	var manual_header := HBoxContainer.new()
	manual_header.name = "ManualHeader"
	manual_content.add_child(manual_header)
	var manual_title := Label.new()
	manual_title.name = "ManualTitle"
	manual_title.text = "괴이 매뉴얼 · 현장 참조"
	manual_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	manual_title.add_theme_font_size_override("font_size", 16)
	manual_header.add_child(manual_title)
	var manual_close := Button.new()
	manual_close.name = "ManualCloseButton"
	manual_close.text = "닫기"
	manual_close.focus_mode = Control.FOCUS_ALL
	manual_close.pressed.connect(_toggle_manual_detail)
	manual_header.add_child(manual_close)
	var manual_text := RichTextLabel.new()
	manual_text.name = "ManualText"
	manual_text.custom_minimum_size = Vector2(0, 190)
	manual_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	manual_text.fit_content = false
	manual_text.bbcode_enabled = true
	manual_text.scroll_active = true
	manual_text.focus_mode = Control.FOCUS_ALL
	manual_content.add_child(manual_text)

	var spacer := Control.new()
	spacer.name = "FlexibleSpacer"
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root_layout.add_child(spacer)

	_detail_stack = VBoxContainer.new()
	_detail_stack.name = "DetailStack"
	_detail_stack.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_detail_stack.add_theme_constant_override("separation", 6)
	root_layout.add_child(_detail_stack)

	var obligation_panel := _make_detail_panel("ObligationPanel", Color(0.72, 0.43, 0.33, 0.95))
	_detail_stack.add_child(obligation_panel)
	var obligation_content := VBoxContainer.new()
	obligation_content.name = "ObligationContent"
	obligation_panel.add_child(obligation_content)
	_priority_label = Label.new()
	_priority_label.name = "PriorityLabel"
	_priority_label.add_theme_font_size_override("font_size", 15)
	obligation_content.add_child(_priority_label)
	_obligation_list_label = Label.new()
	_obligation_list_label.name = "ObligationListLabel"
	_obligation_list_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	obligation_content.add_child(_obligation_list_label)

	var termination_panel := _make_detail_panel("TerminationPreviewPanel", Color(0.49, 0.53, 0.72, 0.95))
	_detail_stack.add_child(termination_panel)
	var termination_content := VBoxContainer.new()
	termination_content.name = "TerminationContent"
	termination_panel.add_child(termination_content)
	_termination_title_label = Label.new()
	_termination_title_label.name = "TerminationTitleLabel"
	_termination_title_label.add_theme_font_size_override("font_size", 15)
	termination_content.add_child(_termination_title_label)
	_termination_detail_label = Label.new()
	_termination_detail_label.name = "TerminationDetailLabel"
	_termination_detail_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	termination_content.add_child(_termination_detail_label)

	_recovery_support_panel = _make_detail_panel("RecoverySupportPanel", Color(0.34, 0.62, 0.62, 0.95))
	_detail_stack.add_child(_recovery_support_panel)
	_detail_stack.move_child(_recovery_support_panel, 1)
	_recovery_support_content = VBoxContainer.new()
	_recovery_support_content.name = "RecoverySupportContent"
	_recovery_support_content.add_theme_constant_override("separation", 6)
	_recovery_support_panel.add_child(_recovery_support_content)

	var follow_up_panel := _make_detail_panel("FollowUpPanel", Color(0.42, 0.61, 0.51, 0.95))
	_detail_stack.add_child(follow_up_panel)
	var follow_up_content := VBoxContainer.new()
	follow_up_content.name = "FollowUpContent"
	follow_up_panel.add_child(follow_up_content)
	var follow_up_title := Label.new()
	follow_up_title.name = "FollowUpTitleLabel"
	follow_up_title.text = "후속 조사·재진입"
	follow_up_title.add_theme_font_size_override("font_size", 15)
	follow_up_content.add_child(follow_up_title)
	_follow_up_label = Label.new()
	_follow_up_label.name = "FollowUpListLabel"
	_follow_up_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	follow_up_content.add_child(_follow_up_label)

	_build_confirmation_layer()


func _build_confirmation_layer() -> void:
	_confirmation_layer = CenterContainer.new()
	_confirmation_layer.name = "ConfirmationLayer"
	_confirmation_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_confirmation_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_confirmation_layer.visible = false
	_confirmation_layer.z_index = 200
	add_child(_confirmation_layer)

	var backdrop := ColorRect.new()
	backdrop.name = "Backdrop"
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.color = Color(0.0, 0.0, 0.0, 0.72)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	_confirmation_layer.add_child(backdrop)

	_confirmation_panel = PanelContainer.new()
	_confirmation_panel.name = "ConfirmationPanel"
	_confirmation_panel.custom_minimum_size = Vector2(520, 0)
	_confirmation_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.055, 0.06, 0.075, 0.99), Color(0.82, 0.55, 0.38, 0.98)))
	_confirmation_layer.add_child(_confirmation_panel)

	var content := VBoxContainer.new()
	content.name = "ConfirmationContent"
	content.add_theme_constant_override("separation", 10)
	_confirmation_panel.add_child(content)

	var title := Label.new()
	title.name = "ConfirmationTitleLabel"
	title.text = "보호 의무 결과 확인"
	title.add_theme_font_size_override("font_size", 19)
	content.add_child(title)

	_confirmation_detail_label = Label.new()
	_confirmation_detail_label.name = "ConfirmationDetailLabel"
	_confirmation_detail_label.custom_minimum_size = Vector2(0, 130)
	_confirmation_detail_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(_confirmation_detail_label)

	var buttons := HBoxContainer.new()
	buttons.name = "ConfirmationButtons"
	buttons.alignment = BoxContainer.ALIGNMENT_END
	buttons.add_theme_constant_override("separation", 8)
	content.add_child(buttons)

	_cancel_button = Button.new()
	_cancel_button.name = "CancelButton"
	_cancel_button.text = "취소"
	_cancel_button.focus_mode = Control.FOCUS_ALL
	_cancel_button.pressed.connect(_on_confirmation_cancelled)
	buttons.add_child(_cancel_button)

	_confirm_button = Button.new()
	_confirm_button.name = "ConfirmButton"
	_confirm_button.text = "결과를 확인하고 실행"
	_confirm_button.focus_mode = Control.FOCUS_ALL
	_confirm_button.pressed.connect(_on_confirmation_confirmed)
	buttons.add_child(_confirm_button)


func _refresh() -> void:
	if _rule_summary_label == null:
		return
	_mode_label.text = _mode_title(_mode)
	_rule_summary_label.text = _make_rule_summary()
	_refresh_recovery_clocks()
	_refresh_manual_detail()
	_refresh_obligations()
	_refresh_termination()
	_refresh_recovery_supports()
	_refresh_follow_up()
	_apply_mode_visibility()


func _refresh_manual_detail() -> void:
	var manual_text := _manual_detail_panel.get_node("ManualContent/ManualText") as RichTextLabel
	var manual_state := _dictionary_copy(_runtime_state.get("manual_state"))
	var pages := _array_copy(manual_state.get("pages"))
	var active_ids := _string_array(manual_state.get("active_rule_ids"))
	var lines: Array[String] = ["[b]현재 괴이 매뉴얼[/b]"]
	if pages.is_empty():
		lines.append("검증된 현행 규칙이 없습니다. 조사 기록과 후보 가설을 확인하세요.")
	else:
		for page_value in pages:
			if typeof(page_value) != TYPE_DICTIONARY:
				continue
			var page := page_value as Dictionary
			var page_id := String(page.get("id", ""))
			var marker := "[현행]" if page_id in active_ids else "[후보]"
			lines.append("%s %s" % [marker, String(page.get("title", "제목 없는 규칙"))])
	lines.append("")
	lines.append("이 패널은 플레이어가 확보한 가설과 근거만 보여 주며 공식 정답을 자동 공개하지 않습니다.")
	manual_text.text = "\n".join(lines)


func _refresh_recovery_clocks() -> void:
	if _recovery_clock_cluster == null:
		return
	var clock := _dictionary_copy(_runtime_state.get("recovery_clock"))
	var stability_total := maxi(1, int(clock.get("stability_total", 8)))
	var danger_total := maxi(1, int(clock.get("danger_total", 6)))
	var stability_segments := clampi(int(clock.get("stability_segments", 0)), 0, stability_total)
	var danger_segments := clampi(int(clock.get("danger_segments", 0)), 0, danger_total)
	var danger_urgent := bool(clock.get("danger_urgent", false))
	_stability_clock.set_clock(stability_segments, stability_total, false)
	_danger_clock.set_clock(danger_segments, danger_total, danger_urgent)
	_stability_clock_label.text = "안정도 %d/%d" % [stability_segments, stability_total]
	_danger_clock_label.text = "위험도 %d/%d" % [danger_segments, danger_total]


func _refresh_obligations() -> void:
	var obligations := ObligationPolicyScript.new().sort_obligations(_array_copy(_runtime_state.get("active_protection_obligations")))
	if obligations.is_empty():
		_priority_label.text = "보호 의무 · 없음"
		_obligation_list_label.text = "현재 확인된 보호 책임이 없습니다."
		return
	var first := obligations[0] as Dictionary
	_priority_label.text = "보호 의무 · %s" % String(first.get("priority_class", "watch"))
	var lines: Array[String] = []
	for obligation_value in obligations:
		var obligation := obligation_value as Dictionary
		lines.append("[%s] %s · %s · %s" % [
			String(obligation.get("priority_class", "watch")),
			_responsibility_label(String(obligation.get("responsibility_type", "protection"))),
			String(obligation.get("status", "unresolved")),
			String(obligation.get("priority_reason", obligation.get("source_reason", "이유 미기록")))
		])
	_obligation_list_label.text = "\n".join(lines)


func _refresh_termination() -> void:
	var preview := _dictionary_copy(_runtime_state.get("termination_preview"))
	if preview.is_empty():
		_termination_title_label.text = "종결 판단 · 미리보기 없음"
		_termination_detail_label.text = "종결 후보를 선택하면 차단 이유와 비차단 결과를 확정 전에 표시합니다."
		return
	var candidate := String(preview.get("termination_candidate", "unknown"))
	var eligible := bool(preview.get("eligible", false))
	_termination_title_label.text = "종결 판단 · %s · %s" % [candidate, "가능" if eligible else "조건 미충족"]
	var lines: Array[String] = []
	for reason_value in _array_copy(preview.get("blocking_reasons")):
		lines.append("차단: %s" % _reason_text(reason_value))
	for consequence_value in _array_copy(preview.get("non_blocking_consequences")):
		lines.append("남는 결과: %s" % _reason_text(consequence_value))
	if not eligible and bool(preview.get("retreat_selectable", true)):
		lines.append("후퇴 선택은 유지됩니다. 예상 결과: %s" % String(preview.get("fallback_outcome", "상황에 따른 강제 퇴각")))
	_termination_detail_label.text = "\n".join(lines) if not lines.is_empty() else "추가 차단 또는 비차단 결과가 없습니다."


func _refresh_recovery_supports() -> void:
	if _recovery_support_content == null:
		return
	for child in _recovery_support_content.get_children():
		_recovery_support_content.remove_child(child)
		child.queue_free()

	var title := Label.new()
	title.name = "RecoverySupportTitleLabel"
	title.text = "요원 지원"
	title.add_theme_font_size_override("font_size", 15)
	_recovery_support_content.add_child(title)

	var supports := _array_copy(_runtime_state.get("recovery_supports"))
	if supports.is_empty():
		var empty_label := Label.new()
		empty_label.name = "RecoverySupportEmptyLabel"
		empty_label.text = "현재 편성에 사용할 수 있는 요원 지원이 없습니다."
		empty_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_recovery_support_content.add_child(empty_label)
		return

	for support_value in supports:
		if typeof(support_value) != TYPE_DICTIONARY:
			continue
		var support: Dictionary = (support_value as Dictionary).duplicate(true)
		var available := bool(support.get("available", true))
		var used := bool(support.get("used", false))
		var support_id := String(support.get("id", "support"))
		var support_row := VBoxContainer.new()
		support_row.name = "RecoverySupportRow_%s" % support_id
		support_row.add_theme_constant_override("separation", 2)
		_recovery_support_content.add_child(support_row)
		var button := Button.new()
		button.name = "RecoverySupportButton_%s" % support_id
		button.text = "%s [%s] · %s" % [
			String(support.get("agent_name", "요원")),
			String(support.get("temperament_label", "지원")),
			String(support.get("label", "지원"))
		]
		button.disabled = not available or used
		button.focus_mode = Control.FOCUS_ALL
		button.tooltip_text = "이미 사용한 요원 지원입니다." if used else String(support.get("unavailable_reason", "")) if not available else String(support.get("description", ""))
		button.pressed.connect(_activate_recovery_support.bind(support, button))
		support_row.add_child(button)
		var status_label := Label.new()
		status_label.name = "RecoverySupportStatus_%s" % support_id
		status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		status_label.add_theme_font_size_override("font_size", 13)
		if used:
			status_label.text = "사용 완료 · 이번 회수에서 이미 사용한 요원 지원입니다."
		elif not available:
			status_label.text = "잠김 이유 · %s" % String(support.get("unavailable_reason", "조건이 충족되지 않았습니다."))
		else:
			status_label.text = "사용 가능 · %s" % String(support.get("description", "현재 회수 단계에서 사용할 수 있습니다."))
		support_row.add_child(status_label)


func _activate_recovery_support(support: Dictionary, button: Button) -> void:
	if not bool(support.get("available", true)) or bool(support.get("used", false)):
		return
	var host := get_parent()
	if host != null and host.has_method("_use_agent_recovery_support"):
		host.call("_use_agent_recovery_support", support, button)


func mark_recovery_support_used(support_id: String) -> void:
	var supports := _array_copy(_runtime_state.get("recovery_supports"))
	for index in range(supports.size()):
		if typeof(supports[index]) != TYPE_DICTIONARY:
			continue
		var support: Dictionary = (supports[index] as Dictionary).duplicate(true)
		if String(support.get("id", "")) != support_id:
			continue
		support["used"] = true
		supports[index] = support
		_runtime_state["recovery_supports"] = supports
		_refresh_recovery_supports()
		return


func _refresh_follow_up() -> void:
	var records := _array_copy(_runtime_state.get("follow_up_records"))
	if records.is_empty():
		_follow_up_label.text = "현재 활성 후속 기록이 없습니다."
		return
	var lines: Array[String] = []
	for record_value in records:
		if typeof(record_value) != TYPE_DICTIONARY:
			continue
		var record := record_value as Dictionary
		lines.append("[%s] %s · %s" % [
			String(record.get("source_status", "unknown")),
			_reason_text(record.get("actionable_reason", record.get("source_reason", "후속 이유 미기록"))),
			String(record.get("resolution_state", "open"))
		])
	_follow_up_label.text = "\n".join(lines)


func _apply_mode_visibility() -> void:
	(_detail_stack.get_node("ObligationPanel") as PanelContainer).visible = _mode in ["rescue", "recovery", "result"]
	(_detail_stack.get_node("TerminationPreviewPanel") as PanelContainer).visible = _mode in ["recovery", "result"]
	_recovery_support_panel.visible = _mode == "recovery"
	(_detail_stack.get_node("FollowUpPanel") as PanelContainer).visible = _mode == "result"
	_detail_toggle_button.visible = _mode in ["rescue", "recovery", "result"]
	_detail_stack.visible = _detail_stack_open and _detail_toggle_button.visible
	_detail_toggle_button.text = "작전 상태 닫기" if _detail_stack.visible else "작전 상태 열기"
	_set_legacy_action_dock_visible(not _detail_stack.visible)
	_recovery_clock_cluster.visible = _mode == "recovery"
	if _mode != "recovery":
		_manual_detail_panel.visible = false


func _toggle_manual_detail() -> void:
	_manual_detail_panel.visible = not _manual_detail_panel.visible
	if _manual_detail_panel.visible:
		(_manual_detail_panel.get_node("ManualContent/ManualText") as RichTextLabel).grab_focus()


func _toggle_detail_stack() -> void:
	_detail_stack_open = not _detail_stack_open
	_apply_mode_visibility()
	if _detail_stack.visible:
		_detail_toggle_button.grab_focus()


func _set_legacy_action_dock_visible(is_visible: bool) -> void:
	var host := get_parent()
	if host == null:
		return
	var action_dock := host.get_node_or_null("ActionDock") as Control
	if action_dock != null:
		action_dock.visible = is_visible


func _on_confirmation_confirmed() -> void:
	var callback := _pending_confirm
	_hide_confirmation(false)
	if callback.is_valid():
		callback.call()


func _on_confirmation_cancelled() -> void:
	var callback := _pending_cancel
	_hide_confirmation(true)
	if callback.is_valid():
		callback.call()


func _hide_confirmation(restore_focus: bool) -> void:
	_confirmation_layer.visible = false
	_confirmation_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_confirmation_panel.visible = false
	_pending_confirm = Callable()
	_pending_cancel = Callable()
	if restore_focus and is_instance_valid(_previous_focus):
		_previous_focus.grab_focus()
	_previous_focus = null


func _build_confirmation_text(preview: Dictionary) -> String:
	var lines: Array[String] = []
	var preview_text := String(preview.get("preview_text", ""))
	if not preview_text.is_empty():
		lines.append(preview_text)
	for risk_value in _array_copy(preview.get("risk_changes")):
		if typeof(risk_value) != TYPE_DICTIONARY:
			continue
		var risk := risk_value as Dictionary
		var target := String(risk.get("target", "보호 대상"))
		var consequence := String(risk.get("consequence", "보호 의무가 악화될 수 있습니다."))
		lines.append("예상 피해·위험 — %s: %s" % [target, consequence])
	var alternatives := _array_copy(preview.get("alternatives"))
	if not alternatives.is_empty():
		var labels: Array[String] = []
		for alternative_value in alternatives:
			if typeof(alternative_value) == TYPE_DICTIONARY:
				labels.append(String((alternative_value as Dictionary).get("label", (alternative_value as Dictionary).get("action_id", "대안"))))
			else:
				labels.append(String(alternative_value))
		lines.append("대안 — %s" % " / ".join(labels))
	if lines.is_empty():
		lines.append("이 행동의 보호 의무 결과를 확인한 뒤 실행합니다.")
	return "\n".join(lines)


func _make_rule_summary() -> String:
	var manual_state := _dictionary_copy(_runtime_state.get("manual_state"))
	var active_ids := _string_array(manual_state.get("active_rule_ids"))
	var pages := _array_copy(manual_state.get("pages"))
	if active_ids.is_empty():
		return "현행 규칙 없음 · 후보 가설과 근거를 직접 확인하세요."
	var titles: Array[String] = []
	for page_value in pages:
		if typeof(page_value) != TYPE_DICTIONARY:
			continue
		var page := page_value as Dictionary
		if String(page.get("id", "")) in active_ids:
			titles.append(String(page.get("title", "현행 규칙")))
	if titles.is_empty():
		return "현행 규칙 %d개 · 전체 근거는 매뉴얼에서 확인" % active_ids.size()
	return "현행 규칙 · %s" % " / ".join(titles)


func _make_detail_panel(panel_name: String, border_color: Color) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.name = panel_name
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	panel.add_theme_stylebox_override("panel", _panel_style(Color(0.045, 0.05, 0.065, 0.94), border_color))
	return panel


func _panel_style(background: Color, border: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(1)
	style.set_corner_radius_all(6)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 9
	style.content_margin_bottom = 9
	return style


func _mode_title(mode: String) -> String:
	return {
		"investigation": "조사·보고",
		"rescue": "피해자 구출",
		"recovery": "현상 회수",
		"result": "사건 결과"
	}.get(mode, "작전 규칙")


func _responsibility_label(value: String) -> String:
	return {
		"treatment": "치료",
		"tether_monitoring": "잔여 연결 감시",
		"protection": "보호",
		"emergency_protection": "긴급 보호",
		"harm_minimization": "피해 최소화",
		"identity_record_preservation": "신원·기록 보존",
		"accounting_and_search": "소재 확인"
	}.get(value, value)


func _reason_text(value: Variant) -> String:
	if typeof(value) == TYPE_DICTIONARY:
		var dictionary := value as Dictionary
		return String(dictionary.get("source_reason", dictionary.get("reason", dictionary.get("status", "상세 기록"))))
	return String(value)


func _dictionary_copy(value: Variant) -> Dictionary:
	return (value as Dictionary).duplicate(true) if typeof(value) == TYPE_DICTIONARY else {}


func _array_copy(value: Variant) -> Array:
	return (value as Array).duplicate(true) if typeof(value) == TYPE_ARRAY else []


func _string_array(value: Variant) -> Array[String]:
	var result: Array[String] = []
	if typeof(value) != TYPE_ARRAY:
		return result
	for item in value as Array:
		result.append(String(item))
	return result
