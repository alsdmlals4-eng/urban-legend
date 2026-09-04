class_name AnomalyManualDrawer
extends PanelContainer

## Presentation-only drawer for optional case detail. Scene owners supply text and own all game state.
signal drawer_opened
signal drawer_closed

var _title_label: Label
var _close_button: Button
var _scroll: ScrollContainer
var _content: VBoxContainer
var _toggle_button: Button
var _has_unread_entries := false


func _ready() -> void:
	name = "AnomalyManualDrawer"
	visible = false
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_anchors_preset(Control.PRESET_TOP_RIGHT)
	anchor_left = 0.66
	anchor_top = 0.12
	anchor_right = 0.985
	anchor_bottom = 0.60
	add_theme_stylebox_override("panel", _make_style())

	var frame := VBoxContainer.new()
	frame.add_theme_constant_override("separation", 8)
	add_child(frame)
	var header := HBoxContainer.new()
	frame.add_child(header)
	_title_label = Label.new()
	_title_label.text = "괴이 매뉴얼"
	_title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_title_label.add_theme_font_size_override("font_size", 18)
	header.add_child(_title_label)
	_close_button = Button.new()
	_close_button.text = "닫기"
	_close_button.pressed.connect(close_drawer)
	header.add_child(_close_button)
	_scroll = ScrollContainer.new()
	_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	frame.add_child(_scroll)
	_content = VBoxContainer.new()
	_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_content.add_theme_constant_override("separation", 10)
	_scroll.add_child(_content)


func bind_toggle_button(button: Button) -> void:
	_toggle_button = button
	_toggle_button.pressed.connect(toggle)
	_refresh_toggle_button()


func set_sections(sections: Array) -> void:
	if _content == null:
		return
	_clear_content()
	for value in sections:
		if typeof(value) != TYPE_DICTIONARY:
			continue
		var section: Dictionary = value
		var heading := Label.new()
		heading.text = String(section.get("title", "기록"))
		heading.add_theme_font_size_override("font_size", 15)
		heading.add_theme_color_override("font_color", Color(0.72, 0.57, 0.86))
		_content.add_child(heading)
		var body := Label.new()
		body.text = String(section.get("text", "기록이 없습니다."))
		body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_content.add_child(body)


func add_detail_control(control: Control) -> void:
	if _content != null:
		_content.add_child(control)


func mark_new_entries() -> void:
	if visible:
		return
	_has_unread_entries = true
	_refresh_toggle_button()


func open_drawer() -> void:
	visible = true
	_has_unread_entries = false
	_refresh_toggle_button()
	_close_button.grab_focus()
	drawer_opened.emit()


func close_drawer() -> void:
	visible = false
	_refresh_toggle_button()
	if _toggle_button != null:
		_toggle_button.grab_focus()
	drawer_closed.emit()


func toggle() -> void:
	if visible:
		close_drawer()
	else:
		open_drawer()


func is_open() -> bool:
	return visible


func _refresh_toggle_button() -> void:
	if _toggle_button == null:
		return
	if visible:
		_toggle_button.text = "괴이 매뉴얼 닫기"
	elif _has_unread_entries:
		_toggle_button.text = "괴이 매뉴얼 · 새 기록"
	else:
		_toggle_button.text = "괴이 매뉴얼"


func _clear_content() -> void:
	for child in _content.get_children():
		_content.remove_child(child)
		child.queue_free()


func _make_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.025, 0.045, 0.06, 0.96)
	style.border_color = Color(0.18, 0.64, 0.70, 0.95)
	style.set_border_width_all(1)
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 14
	style.content_margin_top = 12
	style.content_margin_right = 14
	style.content_margin_bottom = 12
	return style
