class_name AnomalyManualDrawer
extends PanelContainer

## Presentation-only anomaly manual. Scene owners provide text and retain all game state.
signal drawer_opened
signal drawer_closed

const BOOK_FRAME := preload("res://assets/ui/afterlife/manual_book_frame.png")

var _title_label: Label
var _close_button: Button
var _scroll: ScrollContainer
var _section_content: VBoxContainer
var _detail_content: VBoxContainer
var _toggle_button: Button
var _has_unread_entries := false
var _persistent_book := false
var _sections: Array = []


func set_persistent_book(enabled: bool = true) -> void:
	_persistent_book = enabled


func is_persistent_book() -> bool:
	return _persistent_book


func _ready() -> void:
	name = "AnomalyManualBook" if _persistent_book else "AnomalyManualDrawer"
	mouse_filter = Control.MOUSE_FILTER_STOP
	if _persistent_book:
		_build_persistent_book()
	else:
		_build_drawer()
	_render_sections()


func _build_drawer() -> void:
	visible = false
	set_anchors_preset(Control.PRESET_TOP_RIGHT)
	anchor_left = 0.66
	anchor_top = 0.12
	anchor_right = 0.985
	anchor_bottom = 0.60
	add_theme_stylebox_override("panel", _make_drawer_style())
	var frame := VBoxContainer.new()
	frame.add_theme_constant_override("separation", 8)
	add_child(frame)
	var header := HBoxContainer.new()
	frame.add_child(header)
	_title_label = Label.new()
	_title_label.text = "이상 매뉴얼"
	_title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_title_label.add_theme_font_size_override("font_size", 18)
	header.add_child(_title_label)
	_close_button = Button.new()
	_close_button.text = "닫기"
	_close_button.pressed.connect(close_drawer)
	header.add_child(_close_button)
	_add_scroll_content(frame, "ManualScroll")


func _build_persistent_book() -> void:
	visible = true
	clip_contents = true
	custom_minimum_size.x = 276
	add_theme_stylebox_override("panel", _make_book_style())
	var book_frame := TextureRect.new()
	book_frame.name = "BookFrame"
	book_frame.texture = BOOK_FRAME
	book_frame.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	book_frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	book_frame.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	book_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	book_frame.modulate = Color(1.0, 0.94, 0.82, 0.96)
	add_child(book_frame)
	var page_margin := MarginContainer.new()
	page_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	page_margin.anchor_left = 0.09
	page_margin.anchor_top = 0.10
	page_margin.anchor_right = 0.91
	page_margin.anchor_bottom = 0.90
	page_margin.add_theme_constant_override("margin_left", 10)
	page_margin.add_theme_constant_override("margin_top", 8)
	page_margin.add_theme_constant_override("margin_right", 10)
	page_margin.add_theme_constant_override("margin_bottom", 8)
	add_child(page_margin)
	var page := VBoxContainer.new()
	page.add_theme_constant_override("separation", 5)
	page_margin.add_child(page)
	var kicker := Label.new()
	kicker.text = "ANOMALY MANUAL"
	kicker.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	kicker.add_theme_font_size_override("font_size", 10)
	kicker.add_theme_color_override("font_color", Color("5e4636"))
	page.add_child(kicker)
	_title_label = Label.new()
	_title_label.text = "이상 매뉴얼"
	_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title_label.add_theme_font_size_override("font_size", 18)
	_title_label.add_theme_color_override("font_color", Color("38271e"))
	page.add_child(_title_label)
	_add_scroll_content(page, "BookScroll")


func _add_scroll_content(parent: Control, scroll_name: String) -> void:
	_scroll = ScrollContainer.new()
	_scroll.name = scroll_name
	_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	parent.add_child(_scroll)
	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 8)
	_scroll.add_child(content)
	_section_content = VBoxContainer.new()
	_section_content.name = "ManualSections"
	_section_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_section_content.add_theme_constant_override("separation", 7)
	content.add_child(_section_content)
	_detail_content = VBoxContainer.new()
	_detail_content.name = "ManualDetails"
	_detail_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_detail_content.add_theme_constant_override("separation", 8)
	content.add_child(_detail_content)


func bind_toggle_button(button: Button) -> void:
	_toggle_button = button
	_toggle_button.pressed.connect(toggle)
	_refresh_toggle_button()


func set_sections(sections: Array) -> void:
	_sections = sections.duplicate(true)
	_render_sections()


func add_detail_control(control: Control) -> void:
	if _detail_content != null:
		_detail_content.add_child(control)


func mark_new_entries() -> void:
	if visible:
		return
	_has_unread_entries = true
	_refresh_toggle_button()


func open_drawer() -> void:
	visible = true
	_has_unread_entries = false
	_refresh_toggle_button()
	if _close_button != null:
		_close_button.grab_focus()
	drawer_opened.emit()


func close_drawer() -> void:
	if _persistent_book:
		return
	visible = false
	_refresh_toggle_button()
	if _toggle_button != null:
		_toggle_button.grab_focus()
	drawer_closed.emit()


func toggle() -> void:
	if _persistent_book:
		open_drawer()
	elif visible:
		close_drawer()
	else:
		open_drawer()


func is_open() -> bool:
	return visible


func _render_sections() -> void:
	if _section_content == null:
		return
	_clear_sections()
	for value in _sections:
		if typeof(value) != TYPE_DICTIONARY:
			continue
		var section: Dictionary = value
		var heading := Label.new()
		heading.text = String(section.get("title", "기록"))
		heading.add_theme_font_size_override("font_size", 15 if not _persistent_book else 13)
		heading.add_theme_color_override("font_color", Color("72507f") if not _persistent_book else Color("57402d"))
		_section_content.add_child(heading)
		var body := Label.new()
		body.text = String(section.get("text", "기록이 없습니다."))
		body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		if _persistent_book:
			body.add_theme_font_size_override("font_size", 12)
			body.add_theme_color_override("font_color", Color("433126"))
		_section_content.add_child(body)


func _refresh_toggle_button() -> void:
	if _toggle_button == null:
		return
	if _persistent_book:
		_toggle_button.text = "이상 매뉴얼"
		return
	if visible:
		_toggle_button.text = "이상 매뉴얼 닫기"
	elif _has_unread_entries:
		_toggle_button.text = "이상 매뉴얼 · 새 기록"
	else:
		_toggle_button.text = "이상 매뉴얼"


func _clear_sections() -> void:
	for child in _section_content.get_children():
		_section_content.remove_child(child)
		child.queue_free()


func _make_drawer_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.025, 0.045, 0.06, 0.96)
	style.border_color = Color(0.18, 0.64, 0.70, 0.95)
	style.set_border_width_all(1)
	style.set_corner_radius_all(8)
	style.content_margin_left = 14
	style.content_margin_top = 12
	style.content_margin_right = 14
	style.content_margin_bottom = 12
	return style


func _make_book_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 0.18)
	style.border_color = Color("5a493d")
	style.set_border_width_all(1)
	return style
