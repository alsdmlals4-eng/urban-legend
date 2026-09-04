extends Node

const SYNC_INTERVAL_SECONDS := 0.25

var _elapsed := 0.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process(true)
	call_deferred("_sync_current_result_scene")


func _process(delta: float) -> void:
	_elapsed += delta
	if _elapsed < SYNC_INTERVAL_SECONDS:
		return
	_elapsed = 0.0
	_sync_current_result_scene()


func attach_result_axes_for_test(overlay: Node, evaluation_packet: Dictionary) -> PanelContainer:
	return _attach_result_axes(overlay, evaluation_packet)


func _sync_current_result_scene() -> void:
	var tree := get_tree()
	if tree == null or tree.current_scene == null:
		return
	var scene_path := tree.current_scene.scene_file_path.to_lower()
	if not scene_path.contains("result"):
		return
	var overlay := tree.current_scene.get_node_or_null("CanonV2OperationOverlay")
	if overlay == null:
		return
	var packet: Dictionary = {}
	var game_state := get_node_or_null("/root/GameState")
	if game_state != null and game_state.has_method("get_canon_v2_runtime_state"):
		var runtime: Dictionary = game_state.get_canon_v2_runtime_state()
		packet = _dictionary_copy(runtime.get("evaluation_packet"))
	_attach_result_axes(overlay, packet)


func _attach_result_axes(overlay: Node, evaluation_packet: Dictionary) -> PanelContainer:
	if overlay == null:
		return null
	var detail_stack := overlay.get_node_or_null("SafeArea/RootLayout/DetailStack") as VBoxContainer
	if detail_stack == null:
		return null
	var existing := detail_stack.get_node_or_null("ResultAxesPanel") as PanelContainer
	if existing != null:
		_update_result_axes(existing, evaluation_packet)
		existing.visible = true
		return existing

	var panel := PanelContainer.new()
	panel.name = "ResultAxesPanel"
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	panel.add_theme_stylebox_override("panel", _panel_style())
	detail_stack.add_child(panel)

	var content := VBoxContainer.new()
	content.name = "ResultAxesContent"
	content.add_theme_constant_override("separation", 6)
	panel.add_child(content)

	var title := Label.new()
	title.name = "ResultAxesTitleLabel"
	title.text = "사건 결과 · 독립 평가 축"
	title.add_theme_font_size_override("font_size", 16)
	content.add_child(title)

	var label := Label.new()
	label.name = "ResultAxesLabel"
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.focus_mode = Control.FOCUS_ALL
	label.tooltip_text = "현상 통제, 보호 책임, 증거, 후속 실행, 숙련 평가를 서로 덮어쓰지 않고 보여 줍니다."
	content.add_child(label)

	_update_result_axes(panel, evaluation_packet)
	panel.visible = true
	return panel


func _update_result_axes(panel: PanelContainer, evaluation_packet: Dictionary) -> void:
	var label := panel.get_node_or_null("ResultAxesContent/ResultAxesLabel") as Label
	if label == null:
		return
	if evaluation_packet.is_empty():
		label.text = "구조화된 결과 패킷이 아직 없습니다. 기존 결과는 보존되며 자동으로 완전 성공을 추정하지 않습니다."
		return

	var control := _dictionary_copy(evaluation_packet.get("control_axis"))
	var protection := _dictionary_copy(evaluation_packet.get("protection_responsibility_axis"))
	var evidence := _dictionary_copy(evaluation_packet.get("evidence_integrity_axis"))
	var follow_up := _dictionary_copy(evaluation_packet.get("follow_up_execution_axis"))
	var mastery := _dictionary_copy(evaluation_packet.get("mastery_axis"))
	var incident_protection := String(protection.get("incident_end", "unknown"))
	var current_protection := String(protection.get("current", incident_protection))
	var evidence_status := String(evidence.get("status", "not_recorded"))
	var follow_up_status := String(follow_up.get("current", "not_started"))
	var mastery_status := "사전 저작 상한 적용" if bool(mastery.get("ceiling_applied", false)) else "독립 유지"
	label.text = "\n".join([
		"현상 통제 · %s" % String(control.get("status", "unknown")),
		"보호 책임 · 사건 종료 %s / 현재 %s" % [incident_protection, current_protection],
		"증거·기록 무결성 · %s" % evidence_status,
		"후속 실행 · %s" % follow_up_status,
		"숙련 평가 · %s" % mastery_status
	])


func _panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.045, 0.05, 0.065, 0.96)
	style.border_color = Color(0.61, 0.48, 0.76, 0.96)
	style.set_border_width_all(1)
	style.set_corner_radius_all(6)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 9
	style.content_margin_bottom = 9
	return style


func _dictionary_copy(value: Variant) -> Dictionary:
	return (value as Dictionary).duplicate(true) if typeof(value) == TYPE_DICTIONARY else {}
