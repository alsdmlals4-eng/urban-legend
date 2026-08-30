extends Control

## Presentation-only player-authored manual workbench.
## The owning scene supplies earned candidates and persists the emitted draft intent.

signal draft_slot_requested(slot_id: String, candidate_id: String)
signal draft_slot_clear_requested(slot_id: String)
signal dismiss_requested

const LUME_AFTERLIFE_TEXTURE := preload("res://assets/ui/guides/lume_afterlife_station.png")

const COLOR_INK := Color("#090d0f")
const COLOR_PANEL := Color("#111719")
const COLOR_PANEL_DEEP := Color("#0b1012")
const COLOR_GOLD := Color("#b18a47")
const COLOR_GOLD_MUTED := Color("#6d5730")
const COLOR_TEXT := Color("#ddd0ae")
const COLOR_SUBTEXT := Color("#9f9681")
const COLOR_TEAL := Color("#69b7ad")
const COLOR_SELECTED := Color("#1b3738")

var _view_model: Dictionary = {}
var _draft_slots: Dictionary = {}
var _candidate_by_id: Dictionary = {}
var _selected_page_id := ""
var _active_slot_id := ""
var _selected_candidate_id := ""
var _opener: Control

var _manual_index: VBoxContainer
var _deduction_content: VBoxContainer
var _candidate_grid: GridContainer
var _lume_name_label: Label
var _lume_message_label: Label
var _guide_panel: PanelContainer
var _guide_portrait: TextureRect
var _selection_status_label: Label
var _slot_buttons: Dictionary = {}


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	visible = false
	_build_shell()
	_render()


func set_view_model(model: Dictionary) -> void:
	_view_model = model.duplicate(true)
	_draft_slots = _dictionary_copy(_view_model.get("draft_slots", {}))
	_selected_page_id = String(_view_model.get("selected_page_id", ""))
	if _selected_page_id.is_empty():
		_selected_page_id = _first_page_id()
	_rebuild_candidate_lookup()
	if is_node_ready():
		_render()


func open_workbench(opener: Control = null) -> void:
	if opener != null:
		_opener = opener
	visible = true
	_active_slot_id = ""
	_selected_candidate_id = ""
	_render()
	call_deferred("_focus_first_slot")


func dismiss() -> void:
	if not visible:
		return
	visible = false
	_active_slot_id = ""
	_selected_candidate_id = ""
	dismiss_requested.emit()
	if is_instance_valid(_opener):
		_opener.call_deferred("grab_focus")


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	var is_escape_key: bool = event is InputEventKey and event.pressed and (event as InputEventKey).keycode == KEY_ESCAPE
	if event.is_action_pressed("ui_cancel") or is_escape_key:
		dismiss()
		var viewport := get_viewport()
		if viewport != null:
			viewport.set_input_as_handled()


func _build_shell() -> void:
	var dimmer := ColorRect.new()
	dimmer.name = "DossierDimmer"
	dimmer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dimmer.color = Color(0.0, 0.0, 0.0, 0.76)
	dimmer.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(dimmer)

	var safe_margin := MarginContainer.new()
	safe_margin.name = "SafeFrame"
	safe_margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	safe_margin.add_theme_constant_override("margin_left", 30)
	safe_margin.add_theme_constant_override("margin_top", 24)
	safe_margin.add_theme_constant_override("margin_right", 30)
	safe_margin.add_theme_constant_override("margin_bottom", 24)
	add_child(safe_margin)

	var dossier := PanelContainer.new()
	dossier.name = "DossierFrame"
	dossier.add_theme_stylebox_override("panel", _panel_style(COLOR_INK, COLOR_GOLD, 2, 10))
	safe_margin.add_child(dossier)

	var dossier_margin := MarginContainer.new()
	dossier_margin.add_theme_constant_override("margin_left", 18)
	dossier_margin.add_theme_constant_override("margin_top", 14)
	dossier_margin.add_theme_constant_override("margin_right", 18)
	dossier_margin.add_theme_constant_override("margin_bottom", 14)
	dossier.add_child(dossier_margin)

	var frame_stack := VBoxContainer.new()
	frame_stack.add_theme_constant_override("separation", 10)
	dossier_margin.add_child(frame_stack)
	frame_stack.add_child(_build_header())

	var divider := HSeparator.new()
	divider.add_theme_stylebox_override("separator", _line_style(COLOR_GOLD_MUTED, 1))
	frame_stack.add_child(divider)

	var columns := HBoxContainer.new()
	columns.size_flags_vertical = Control.SIZE_EXPAND_FILL
	columns.add_theme_constant_override("separation", 12)
	frame_stack.add_child(columns)

	var index_panel := PanelContainer.new()
	index_panel.name = "ManualIndex"
	index_panel.custom_minimum_size = Vector2(190, 0)
	index_panel.add_theme_stylebox_override("panel", _panel_style(COLOR_PANEL_DEEP, COLOR_GOLD_MUTED, 1, 6))
	columns.add_child(index_panel)
	var index_margin := MarginContainer.new()
	index_margin.add_theme_constant_override("margin_left", 10)
	index_margin.add_theme_constant_override("margin_top", 10)
	index_margin.add_theme_constant_override("margin_right", 10)
	index_margin.add_theme_constant_override("margin_bottom", 10)
	index_panel.add_child(index_margin)
	_manual_index = VBoxContainer.new()
	_manual_index.add_theme_constant_override("separation", 8)
	index_margin.add_child(_manual_index)

	var center_panel := PanelContainer.new()
	center_panel.name = "DeductionPanel"
	center_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center_panel.add_theme_stylebox_override("panel", _panel_style(COLOR_PANEL, COLOR_GOLD_MUTED, 1, 6))
	columns.add_child(center_panel)
	var center_margin := MarginContainer.new()
	center_margin.add_theme_constant_override("margin_left", 16)
	center_margin.add_theme_constant_override("margin_top", 12)
	center_margin.add_theme_constant_override("margin_right", 16)
	center_margin.add_theme_constant_override("margin_bottom", 12)
	center_panel.add_child(center_margin)
	var deduction_scroll := ScrollContainer.new()
	deduction_scroll.name = "DeductionScroll"
	deduction_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	deduction_scroll.follow_focus = true
	center_margin.add_child(deduction_scroll)
	_deduction_content = VBoxContainer.new()
	_deduction_content.name = "DeductionContent"
	_deduction_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_deduction_content.add_theme_constant_override("separation", 12)
	deduction_scroll.add_child(_deduction_content)

	var right_panel := PanelContainer.new()
	right_panel.name = "SourceAndGuidePanel"
	right_panel.custom_minimum_size = Vector2(314, 0)
	right_panel.add_theme_stylebox_override("panel", _panel_style(COLOR_PANEL_DEEP, COLOR_GOLD_MUTED, 1, 6))
	columns.add_child(right_panel)
	var right_margin := MarginContainer.new()
	right_margin.add_theme_constant_override("margin_left", 10)
	right_margin.add_theme_constant_override("margin_top", 10)
	right_margin.add_theme_constant_override("margin_right", 10)
	right_margin.add_theme_constant_override("margin_bottom", 10)
	right_panel.add_child(right_margin)
	var right_stack := VBoxContainer.new()
	right_stack.add_theme_constant_override("separation", 10)
	right_margin.add_child(right_stack)
	right_stack.add_child(_label("후보 키워드", 19, COLOR_GOLD))
	right_stack.add_child(_label("확보한 기록의 후보만 표시됩니다. 판단은 현장 대응에서 확인됩니다.", 12, COLOR_SUBTEXT))
	_candidate_grid = GridContainer.new()
	_candidate_grid.name = "CandidateGrid"
	_candidate_grid.columns = 2
	_candidate_grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_candidate_grid.add_theme_constant_override("h_separation", 6)
	_candidate_grid.add_theme_constant_override("v_separation", 6)
	right_stack.add_child(_candidate_grid)
	_selection_status_label = _label("빈칸을 먼저 선택하면 후보를 넣을 수 있습니다.", 12, COLOR_TEAL)
	_selection_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	right_stack.add_child(_selection_status_label)
	right_stack.add_child(_build_lume_panel())


func _build_header() -> Control:
	var header := HBoxContainer.new()
	header.custom_minimum_size = Vector2(0, 42)
	header.add_theme_constant_override("separation", 14)
	var bureau := _label("괴이기록국", 23, COLOR_GOLD)
	bureau.custom_minimum_size = Vector2(166, 0)
	header.add_child(bureau)
	var case_label := _label(String(_view_model.get("case_label", "CASE-01")), 16, COLOR_TEXT)
	case_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(case_label)
	var title := _label(String(_view_model.get("title", "괴이 매뉴얼")), 20, COLOR_GOLD)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title)
	var close_button := Button.new()
	close_button.name = "CloseWorkbenchButton"
	close_button.text = "← 현장으로 돌아가기"
	close_button.tooltip_text = "Esc"
	close_button.focus_mode = Control.FOCUS_ALL
	close_button.add_theme_font_size_override("font_size", 14)
	close_button.add_theme_stylebox_override("normal", _panel_style(COLOR_PANEL, COLOR_GOLD_MUTED, 1, 4))
	close_button.add_theme_stylebox_override("focus", _panel_style(COLOR_SELECTED, COLOR_TEAL, 2, 4))
	close_button.pressed.connect(dismiss)
	header.add_child(close_button)
	return header


func _build_lume_panel() -> Control:
	var lume_panel := PanelContainer.new()
	lume_panel.name = "LumeGuidePanel"
	lume_panel.custom_minimum_size = Vector2(0, 184)
	lume_panel.add_theme_stylebox_override("panel", _panel_style(Color("#171713"), COLOR_GOLD, 1, 5))
	_guide_panel = lume_panel
	var lume_row := HBoxContainer.new()
	lume_row.add_theme_constant_override("separation", 8)
	lume_panel.add_child(lume_row)
	var portrait := TextureRect.new()
	portrait.name = "LumePortrait"
	portrait.texture = LUME_AFTERLIFE_TEXTURE
	portrait.custom_minimum_size = Vector2(86, 160)
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	lume_row.add_child(portrait)
	_guide_portrait = portrait
	var text_stack := VBoxContainer.new()
	text_stack.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_stack.add_theme_constant_override("separation", 5)
	lume_row.add_child(text_stack)
	_lume_name_label = _label("루메", 18, COLOR_GOLD)
	text_stack.add_child(_lume_name_label)
	_lume_message_label = _label("출처 기록과 문장을 함께 비교해 보세요.", 14, COLOR_TEXT)
	_lume_message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_lume_message_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	text_stack.add_child(_lume_message_label)
	return lume_panel


func _render() -> void:
	if not is_instance_valid(_manual_index):
		return
	_render_manual_index()
	_render_deduction()
	_render_candidates()
	_render_lume()
	_render_selection_status()


func _render_manual_index() -> void:
	_clear_children(_manual_index)
	_manual_index.add_child(_label("괴이 매뉴얼 INDEX", 17, COLOR_GOLD))
	_manual_index.add_child(_label("확보 기록을 연결해 빈칸을 작성합니다.", 12, COLOR_SUBTEXT))
	for page_value in _pages():
		if not page_value is Dictionary:
			continue
		var page: Dictionary = page_value
		var page_id := String(page.get("id", ""))
		var button := Button.new()
		button.name = "Page_%s" % page_id
		button.text = String(page.get("title", page_id))
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.custom_minimum_size = Vector2(0, 58)
		button.focus_mode = Control.FOCUS_ALL
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.add_theme_font_size_override("font_size", 15)
		var selected := page_id == _selected_page_id
		button.add_theme_stylebox_override("normal", _panel_style(COLOR_SELECTED if selected else COLOR_PANEL, COLOR_GOLD if selected else COLOR_GOLD_MUTED, 1, 4))
		button.add_theme_stylebox_override("focus", _panel_style(COLOR_SELECTED, COLOR_TEAL, 2, 4))
		button.pressed.connect(_on_page_pressed.bind(page_id))
		_manual_index.add_child(button)


func _render_deduction() -> void:
	_clear_children(_deduction_content)
	_slot_buttons.clear()
	var page := _current_page()
	if page.is_empty():
		_deduction_content.add_child(_label("표시할 매뉴얼 페이지가 없습니다.", 16, COLOR_SUBTEXT))
		return
	_deduction_content.add_child(_label(String(page.get("title", "추리문")), 25, COLOR_GOLD))
	_deduction_content.add_child(_label("기록과 후보 키워드를 대조해 빈칸을 작성하세요. 이 화면은 결과를 확정하지 않습니다.", 14, COLOR_SUBTEXT))
	var divider := HSeparator.new()
	divider.add_theme_stylebox_override("separator", _line_style(COLOR_GOLD_MUTED, 1))
	_deduction_content.add_child(divider)
	var line := HFlowContainer.new()
	line.name = "DeductionLine"
	line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	line.add_theme_constant_override("h_separation", 5)
	line.add_theme_constant_override("v_separation", 7)
	_deduction_content.add_child(line)
	var segments_value: Variant = page.get("deduction_segments", [])
	if segments_value is Array:
		for segment_value in segments_value:
			if not segment_value is Dictionary:
				continue
			var segment: Dictionary = segment_value
			if String(segment.get("kind", "text")) == "slot":
				var slot_id := String(segment.get("slot_id", ""))
				if not slot_id.is_empty():
					line.add_child(_slot_button(slot_id))
			else:
				line.add_child(_body_label(String(segment.get("text", ""))))
	var lower_divider := HSeparator.new()
	lower_divider.add_theme_stylebox_override("separator", _line_style(COLOR_GOLD_MUTED, 1))
	_deduction_content.add_child(lower_divider)
	_deduction_content.add_child(_label("작성 원칙", 16, COLOR_GOLD))
	_deduction_content.add_child(_label("후보는 출처 기록을 기준으로만 열립니다. 선택 자체는 확정이나 성공을 뜻하지 않습니다.", 13, COLOR_SUBTEXT))


func _render_candidates() -> void:
	_clear_children(_candidate_grid)
	var candidates := _current_page_candidates()
	if candidates.is_empty():
		_candidate_grid.add_child(_label("이 페이지에서 확보한 후보가 없습니다.", 12, COLOR_SUBTEXT))
		return
	for candidate_value in candidates:
		if not candidate_value is Dictionary:
			continue
		var candidate: Dictionary = candidate_value
		var candidate_id := String(candidate.get("id", ""))
		if candidate_id.is_empty():
			continue
		var button := Button.new()
		button.name = "Candidate_%s" % candidate_id
		button.text = "%s\n%s" % [String(candidate.get("display_label", candidate_id)), String(candidate.get("source_label", "출처 기록"))]
		button.tooltip_text = String(candidate.get("source_label", "출처 기록"))
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.custom_minimum_size = Vector2(138, 60)
		button.focus_mode = Control.FOCUS_ALL
		button.add_theme_font_size_override("font_size", 13)
		var selected := candidate_id == _selected_candidate_id
		button.add_theme_stylebox_override("normal", _panel_style(COLOR_SELECTED if selected else COLOR_PANEL, COLOR_TEAL if selected else COLOR_GOLD_MUTED, 1, 4))
		button.add_theme_stylebox_override("focus", _panel_style(COLOR_SELECTED, COLOR_TEAL, 2, 4))
		button.pressed.connect(_on_candidate_pressed.bind(candidate_id))
		_candidate_grid.add_child(button)


func _render_lume() -> void:
	var guide := _guide_view_model()
	_lume_name_label.text = String(guide.get("name", "루메"))
	_lume_message_label.text = String(guide.get("message", "출처 기록과 문장을 함께 비교해 보세요."))
	var portrait_visible := bool(guide.get("portrait_visible", true))
	if is_instance_valid(_guide_portrait):
		_guide_portrait.visible = portrait_visible
	if is_instance_valid(_guide_panel):
		_guide_panel.custom_minimum_size = Vector2(0, 184 if portrait_visible else 96)


func _guide_view_model() -> Dictionary:
	var guide_value: Variant = _view_model.get("guide", _view_model.get("lume", {}))
	if guide_value is Dictionary:
		return (guide_value as Dictionary).duplicate(true)
	return {
		"name": "루메",
		"message": "출처 기록과 문장을 함께 비교해 보세요.",
		"portrait_visible": true
	}


func _render_selection_status() -> void:
	if not is_instance_valid(_selection_status_label):
		return
	if not _active_slot_id.is_empty():
		_selection_status_label.text = "선택한 빈칸: %s — 후보를 선택하세요." % _active_slot_id
	elif not _selected_candidate_id.is_empty():
		_selection_status_label.text = "후보를 선택했습니다. 넣을 빈칸을 선택하세요."
	else:
		_selection_status_label.text = "빈칸을 먼저 선택하면 후보를 넣을 수 있습니다."


func _slot_button(slot_id: String) -> Button:
	var button := Button.new()
	button.name = "Slot_%s" % slot_id
	button.custom_minimum_size = Vector2(146, 38)
	button.focus_mode = Control.FOCUS_ALL
	button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	button.tooltip_text = "기록 후보를 넣거나 현재 선택을 지웁니다."
	button.add_theme_font_size_override("font_size", 14)
	_set_slot_button_text(button, slot_id)
	button.add_theme_stylebox_override("normal", _panel_style(COLOR_SELECTED if slot_id == _active_slot_id else COLOR_PANEL_DEEP, COLOR_TEAL if slot_id == _active_slot_id else COLOR_GOLD, 1, 4))
	button.add_theme_stylebox_override("focus", _panel_style(COLOR_SELECTED, COLOR_TEAL, 2, 4))
	button.pressed.connect(_on_slot_pressed.bind(slot_id))
	_slot_buttons[slot_id] = button
	return button


func _set_slot_button_text(button: Button, slot_id: String) -> void:
	var candidate_id := String(_draft_slots.get(slot_id, ""))
	if candidate_id.is_empty():
		button.text = "[ 기록 선택 ]"
		return
	var candidate_value: Variant = _candidate_by_id.get(candidate_id, {})
	if candidate_value is Dictionary:
		button.text = String((candidate_value as Dictionary).get("display_label", candidate_id))
	else:
		button.text = "[ 이전 기록 ]"


func _on_page_pressed(page_id: String) -> void:
	_selected_page_id = page_id
	_active_slot_id = ""
	_selected_candidate_id = ""
	_render()
	call_deferred("_focus_first_slot")


func _on_slot_pressed(slot_id: String) -> void:
	var current_candidate := String(_draft_slots.get(slot_id, ""))
	if not _selected_candidate_id.is_empty():
		_assign_candidate(slot_id, _selected_candidate_id)
		return
	if not current_candidate.is_empty():
		_draft_slots.erase(slot_id)
		draft_slot_clear_requested.emit(slot_id)
		var current_button := _slot_buttons.get(slot_id, null) as Button
		if current_button != null:
			_set_slot_button_text(current_button, slot_id)
		_render_selection_status()
		return
	_active_slot_id = slot_id
	_render_selection_status()


func _on_candidate_pressed(candidate_id: String) -> void:
	_selected_candidate_id = candidate_id
	if not _active_slot_id.is_empty():
		_assign_candidate(_active_slot_id, candidate_id)
		return
	_render_candidates()
	_render_selection_status()


func _assign_candidate(slot_id: String, candidate_id: String) -> void:
	_draft_slots[slot_id] = candidate_id
	draft_slot_requested.emit(slot_id, candidate_id)
	var current_button := _slot_buttons.get(slot_id, null) as Button
	if current_button != null:
		_set_slot_button_text(current_button, slot_id)
	_active_slot_id = ""
	_selected_candidate_id = ""
	_render_selection_status()


func _focus_first_slot() -> void:
	if not visible:
		return
	for slot_button_value in _slot_buttons.values():
		var slot_button := slot_button_value as Button
		if slot_button != null and is_instance_valid(slot_button) and slot_button.visible:
			slot_button.grab_focus()
			return
	for candidate_button_value in _candidate_grid.get_children():
		var candidate_button := candidate_button_value as Button
		if candidate_button != null and candidate_button.visible:
			candidate_button.grab_focus()
			return


func _pages() -> Array:
	var pages_value: Variant = _view_model.get("pages", [])
	return pages_value if pages_value is Array else []


func _first_page_id() -> String:
	for page_value in _pages():
		if page_value is Dictionary:
			var page_id := String((page_value as Dictionary).get("id", ""))
			if not page_id.is_empty():
				return page_id
	return ""


func _current_page() -> Dictionary:
	for page_value in _pages():
		if page_value is Dictionary:
			var page: Dictionary = page_value
			if String(page.get("id", "")) == _selected_page_id:
				return page
	return {}


func _current_page_candidates() -> Array:
	var candidates_value: Variant = _view_model.get("candidate_keywords", [])
	if not candidates_value is Array:
		return []
	var result: Array = []
	for candidate_value in candidates_value:
		if candidate_value is Dictionary and String((candidate_value as Dictionary).get("page_id", "")) == _selected_page_id:
			result.append(candidate_value)
	return result


func _rebuild_candidate_lookup() -> void:
	_candidate_by_id.clear()
	var candidates_value: Variant = _view_model.get("candidate_keywords", [])
	if candidates_value is Array:
		for candidate_value in candidates_value:
			if candidate_value is Dictionary:
				var candidate: Dictionary = candidate_value
				var candidate_id := String(candidate.get("id", ""))
				if not candidate_id.is_empty():
					_candidate_by_id[candidate_id] = candidate


func _clear_children(container: Node) -> void:
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()


func _label(text_value: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text_value
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label


func _body_label(text_value: String) -> Label:
	var label := _label(text_value, 17, COLOR_TEXT)
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	return label


func _panel_style(background: Color, border: Color, border_width: int, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(border_width)
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	style.content_margin_left = 8
	style.content_margin_top = 6
	style.content_margin_right = 8
	style.content_margin_bottom = 6
	return style


func _line_style(color: Color, height: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.content_margin_top = height
	style.content_margin_bottom = 0
	return style


func _dictionary_copy(value: Variant) -> Dictionary:
	return value.duplicate(true) if value is Dictionary else {}
