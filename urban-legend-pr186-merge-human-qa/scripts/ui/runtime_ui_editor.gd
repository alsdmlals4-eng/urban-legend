# F2 개발 모드에서 주요 UI 영역과 서술 문구를 편집한다.
class_name RuntimeUiEditor
extends CanvasLayer

signal risk_preview_changed(level: String)

const LayoutStore = preload("res://scripts/ui/ui_layout_store.gd")
const ThemeFactory = preload("res://scripts/ui/ui_theme_factory.gd")

class EditorSurface extends Control:
	var editor: RuntimeUiEditor

	func _draw() -> void:
		if editor != null:
			editor.draw_surface(self)

	func _gui_input(event: InputEvent) -> void:
		if editor != null:
			editor.handle_surface_input(event)


var _scene_id := ""
var _root_control: Control
var _store := LayoutStore.new()
var _elements: Dictionary = {}
var _selected_id := ""
var _dragging := false
var _resizing := false
var _drag_origin := Vector2.ZERO
var _rect_origin := Rect2()
var _undo_stack: Array[Dictionary] = []
var _edit_mode := false
var _surface: EditorSurface
var _toolbar: PanelContainer
var _debug_label: Label
var _text_popup: PopupPanel
var _text_editor: TextEdit
var _text_target_id := ""


func setup(scene_id: String, root_control: Control) -> void:
	_scene_id = scene_id
	_root_control = root_control
	layer = 100
	_build_overlay()
	set_process_input(true)


func register_element(element_id: String, control: Control, options: Dictionary = {}) -> void:
	if control == null:
		return
	var entry := {
		"control": control,
		"default_rect": _rect_in_root(control),
		"minimum_size": Vector2(options.get("minimum_size", Vector2(160, 80))),
		"text_control": options.get("text_control", null),
		"style_target": options.get("style_target", control),
		"image_target": options.get("image_target", null),
		"free_layout": bool(options.get("free_layout", false)),
		"content_key": String(options.get("content_key", "")),
		"source_text": String(options.get("source_text", ""))
	}
	_elements[element_id] = entry
	if bool(entry.get("free_layout", false)):
		call_deferred("_prepare_free_layout", element_id)
	else:
		_apply_saved_rect(element_id)
		_apply_saved_properties(element_id)
	var text_control: Control = entry.get("text_control")
	if text_control != null and not String(entry.get("content_key", "")).is_empty():
		text_control.set("text", _store.get_content_override(entry.get("content_key"), entry.get("source_text")))


func _prepare_free_layout(element_id: String) -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	if not _elements.has(element_id) or _root_control == null:
		return
	var entry: Dictionary = _elements[element_id]
	var control := entry.get("control") as Control
	if control == null:
		return
	var global_position := control.global_position
	var original_size := control.size
	if control.get_parent() is Container:
		control.reparent(_root_control, true)
	control.set_anchors_preset(Control.PRESET_TOP_LEFT)
	control.global_position = global_position
	control.size = original_size
	entry["default_rect"] = _rect_in_root(control)
	_elements[element_id] = entry
	_apply_saved_rect(element_id)
	_apply_saved_properties(element_id)


func update_text_binding(element_id: String, content_key: String, source_text: String) -> String:
	if not _elements.has(element_id):
		return _store.get_content_override(content_key, source_text)
	var entry: Dictionary = _elements[element_id]
	entry["content_key"] = content_key
	entry["source_text"] = source_text
	_elements[element_id] = entry
	return _store.get_content_override(content_key, source_text)


func is_edit_mode() -> bool:
	return _edit_mode


func get_element_rect(element_id: String) -> Rect2:
	if not _elements.has(element_id):
		return Rect2()
	var control := (_elements[element_id] as Dictionary).get("control") as Control
	return _rect_in_root(control) if control != null else Rect2()


func toggle_edit_mode(force_enabled: Variant = null) -> void:
	if not OS.is_debug_build():
		return
	_edit_mode = not _edit_mode if force_enabled == null else bool(force_enabled)
	_surface.visible = _edit_mode
	_toolbar.visible = _edit_mode
	if not _edit_mode:
		_selected_id = ""
		_dragging = false
		_resizing = false
	_surface.queue_redraw()


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		var key := event as InputEventKey
		if key.keycode == KEY_F2:
			toggle_edit_mode()
			get_viewport().set_input_as_handled()
			return
		if key.keycode == KEY_F1:
			_debug_label.visible = not _debug_label.visible
			get_viewport().set_input_as_handled()
			return
		if _edit_mode and key.ctrl_pressed and key.keycode == KEY_Z:
			_undo_last()
			get_viewport().set_input_as_handled()
			return
		if _edit_mode and key.keycode == KEY_R and not _selected_id.is_empty():
			_reset_element(_selected_id)
			get_viewport().set_input_as_handled()


func handle_surface_input(event: InputEvent) -> void:
	if not _edit_mode:
		return
	if event is InputEventMouseButton:
		var button := event as InputEventMouseButton
		if button.button_index != MOUSE_BUTTON_LEFT:
			return
		if button.pressed:
			_selected_id = _element_at(button.position)
			if _selected_id.is_empty():
				_surface.queue_redraw()
				return
			if button.double_click:
				_open_text_editor(_selected_id)
				return
			var entry: Dictionary = _elements[_selected_id]
			var control: Control = entry.get("control")
			_rect_origin = _rect_in_root(control)
			_push_undo(_selected_id, _rect_origin)
			_drag_origin = button.position
			_resizing = _resize_handle_rect(_rect_origin).has_point(button.position)
			_dragging = not _resizing
		else:
			_dragging = false
			_resizing = false
		_surface.queue_redraw()
	elif event is InputEventMouseMotion and (_dragging or _resizing) and not _selected_id.is_empty():
		var motion := event as InputEventMouseMotion
		var delta := motion.position - _drag_origin
		var next_rect := _rect_origin
		if _resizing:
			next_rect.size += delta
		else:
			next_rect.position += delta
		if not Input.is_key_pressed(KEY_SHIFT):
			next_rect = _store.snap_rect(next_rect)
		var entry: Dictionary = _elements[_selected_id]
		next_rect = _store.clamp_rect(next_rect, _safe_area(), entry.get("minimum_size"))
		_apply_rect(entry.get("control"), next_rect)
		_surface.queue_redraw()


func draw_surface(surface: Control) -> void:
	for element_id in _elements:
		var entry: Dictionary = _elements[element_id]
		var control: Control = entry.get("control")
		if control == null or not control.visible:
			continue
		var color := ThemeFactory.COLOR_AMBER if element_id == _selected_id else Color(0.31, 0.76, 0.71, 0.55)
		var rect := _rect_in_root(control)
		surface.draw_rect(rect, color, false, 2.0)
		if element_id == _selected_id:
			surface.draw_rect(_resize_handle_rect(rect), color, true)


func _build_overlay() -> void:
	_surface = EditorSurface.new()
	_surface.editor = self
	_surface.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_surface.mouse_filter = Control.MOUSE_FILTER_STOP
	_surface.visible = false
	add_child(_surface)

	_toolbar = PanelContainer.new()
	_toolbar.position = Vector2(16, 16)
	_toolbar.size = Vector2(760, 54)
	_toolbar.add_theme_stylebox_override("panel", ThemeFactory.panel_style(ThemeFactory.COLOR_AMBER, 0.98))
	_toolbar.visible = false
	add_child(_toolbar)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	_toolbar.add_child(row)
	_add_toolbar_button(row, "저장", _save_all)
	_add_toolbar_button(row, "선택 초기화", func() -> void: _reset_element(_selected_id))
	_add_toolbar_button(row, "전체 초기화", _reset_all)
	_add_toolbar_button(row, "문구 패치 내보내기", _export_patch)
	_add_toolbar_button(row, "글자-", func() -> void: _adjust_font_size(-1))
	_add_toolbar_button(row, "글자+", func() -> void: _adjust_font_size(1))
	_add_toolbar_button(row, "정렬", _cycle_alignment)
	_add_toolbar_button(row, "색", _cycle_text_color)
	_add_toolbar_button(row, "패널", _cycle_panel_alpha)
	_add_toolbar_button(row, "크롭", _cycle_image_crop)
	_add_toolbar_button(row, "표시", _toggle_visibility)
	var risk := OptionButton.new()
	risk.add_item("위험 B")
	risk.add_item("위험 C")
	risk.add_item("위험 D")
	risk.item_selected.connect(func(index: int) -> void: risk_preview_changed.emit(["B", "C", "D"][index]))
	row.add_child(risk)
	var help := Label.new()
	help.text = "드래그 이동 · 모서리 크기 · 더블클릭 문구 · Ctrl+Z"
	help.add_theme_color_override("font_color", ThemeFactory.COLOR_MUTED)
	row.add_child(help)

	_debug_label = Label.new()
	_debug_label.position = Vector2(16, 80)
	_debug_label.text = "F1 DEBUG\nscene: %s\nlayout: %s\ncontent: %s" % [_scene_id, LayoutStore.LAYOUT_PATH, LayoutStore.CONTENT_PATH]
	_debug_label.add_theme_color_override("font_color", ThemeFactory.COLOR_AMBER)
	_debug_label.visible = false
	add_child(_debug_label)

	_text_popup = PopupPanel.new()
	_text_popup.size = Vector2i(680, 360)
	add_child(_text_popup)
	var popup_content := VBoxContainer.new()
	popup_content.add_theme_constant_override("separation", 8)
	_text_popup.add_child(popup_content)
	var title := Label.new()
	title.text = "서술 문구 편집"
	popup_content.add_child(title)
	_text_editor = TextEdit.new()
	_text_editor.custom_minimum_size = Vector2(640, 250)
	_text_editor.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	popup_content.add_child(_text_editor)
	var buttons := HBoxContainer.new()
	popup_content.add_child(buttons)
	_add_toolbar_button(buttons, "적용", _apply_text_edit)
	_add_toolbar_button(buttons, "원문 복원", _reset_text_edit)
	_add_toolbar_button(buttons, "취소", _text_popup.hide)


func _add_toolbar_button(parent: Control, text: String, callback: Callable) -> void:
	var button := Button.new()
	button.text = text
	button.pressed.connect(callback)
	parent.add_child(button)


func _element_at(point: Vector2) -> String:
	var selected := ""
	var selected_area := INF
	for element_id in _elements:
		var entry: Dictionary = _elements[element_id]
		var control: Control = entry.get("control")
		var rect := _rect_in_root(control) if control != null else Rect2()
		var area := rect.size.x * rect.size.y
		if control != null and control.visible and rect.has_point(point) and area < selected_area:
			selected = String(element_id)
			selected_area = area
	return selected


func _resize_handle_rect(rect: Rect2) -> Rect2:
	return Rect2(rect.end - Vector2(18, 18), Vector2(18, 18))


func _safe_area() -> Rect2:
	var size := _root_control.get_viewport_rect().size
	if _store.profile_for_size(size) == "ultrawide":
		var safe_width := size.y * 16.0 / 9.0
		return Rect2((size.x - safe_width) * 0.5, 0, safe_width, size.y)
	return Rect2(Vector2.ZERO, size)


func _apply_saved_rect(element_id: String) -> void:
	var entry: Dictionary = _elements[element_id]
	var control: Control = entry.get("control")
	var fallback: Rect2 = entry.get("default_rect")
	var viewport_size := _root_control.get_viewport_rect().size
	var rect := _store.get_layout_rect(_scene_id, element_id, viewport_size, fallback)
	_apply_rect(control, _store.clamp_rect(rect, _safe_area(), entry.get("minimum_size")))


func _apply_saved_properties(element_id: String) -> void:
	var entry: Dictionary = _elements[element_id]
	var viewport_size := _root_control.get_viewport_rect().size
	var text_control := entry.get("text_control") as Control
	if text_control != null:
		var font_size := int(_store.get_layout_property(_scene_id, element_id, viewport_size, "font_size", 17))
		text_control.add_theme_font_size_override("font_size", font_size)
		text_control.modulate = _store.get_layout_property(_scene_id, element_id, viewport_size, "text_color", Color.WHITE)
		if text_control is Label:
			(text_control as Label).horizontal_alignment = int(_store.get_layout_property(_scene_id, element_id, viewport_size, "alignment", HORIZONTAL_ALIGNMENT_LEFT))
	var style_target := entry.get("style_target") as Control
	if style_target != null:
		style_target.modulate.a = float(_store.get_layout_property(_scene_id, element_id, viewport_size, "panel_alpha", 1.0))
	var image_target := entry.get("image_target") as TextureRect
	if image_target != null:
		image_target.stretch_mode = int(_store.get_layout_property(_scene_id, element_id, viewport_size, "crop_mode", TextureRect.STRETCH_KEEP_ASPECT_COVERED))


func _selected_entry() -> Dictionary:
	return _elements.get(_selected_id, {})


func _adjust_font_size(delta: int) -> void:
	var entry := _selected_entry()
	var text_control := entry.get("text_control") as Control
	if text_control == null:
		return
	var size := clampi(text_control.get_theme_font_size("font_size") + delta, 12, 42)
	text_control.add_theme_font_size_override("font_size", size)
	_store.set_layout_property(_scene_id, _selected_id, _root_control.get_viewport_rect().size, "font_size", size)


func _cycle_alignment() -> void:
	var label := _selected_entry().get("text_control") as Label
	if label == null:
		return
	label.horizontal_alignment = (int(label.horizontal_alignment) + 1) % 3
	_store.set_layout_property(_scene_id, _selected_id, _root_control.get_viewport_rect().size, "alignment", label.horizontal_alignment)


func _cycle_text_color() -> void:
	var text_control := _selected_entry().get("text_control") as Control
	if text_control == null:
		return
	var colors := [ThemeFactory.COLOR_INK, ThemeFactory.COLOR_AMBER, ThemeFactory.COLOR_TEAL]
	var index := colors.find(text_control.modulate)
	text_control.modulate = colors[(index + 1) % colors.size()]
	_store.set_layout_property(_scene_id, _selected_id, _root_control.get_viewport_rect().size, "text_color", text_control.modulate)


func _cycle_panel_alpha() -> void:
	var target := _selected_entry().get("style_target") as Control
	if target == null:
		return
	var values := [1.0, 0.85, 0.7, 0.5]
	var index := values.find(target.modulate.a)
	target.modulate.a = values[(index + 1) % values.size()]
	_store.set_layout_property(_scene_id, _selected_id, _root_control.get_viewport_rect().size, "panel_alpha", target.modulate.a)


func _cycle_image_crop() -> void:
	var image := _selected_entry().get("image_target") as TextureRect
	if image == null:
		return
	var modes := [TextureRect.STRETCH_KEEP_ASPECT_COVERED, TextureRect.STRETCH_KEEP_ASPECT_CENTERED, TextureRect.STRETCH_SCALE]
	var index := modes.find(image.stretch_mode)
	image.stretch_mode = modes[(index + 1) % modes.size()]
	_store.set_layout_property(_scene_id, _selected_id, _root_control.get_viewport_rect().size, "crop_mode", image.stretch_mode)


func _toggle_visibility() -> void:
	var control := _selected_entry().get("control") as Control
	if control != null:
		control.visible = not control.visible


func _apply_rect(control: Control, rect: Rect2) -> void:
	control.set_anchors_preset(Control.PRESET_TOP_LEFT)
	control.global_position = _root_control.global_position + rect.position
	control.size = rect.size


func _rect_in_root(control: Control) -> Rect2:
	return Rect2(control.global_position - _root_control.global_position, control.size)


func _push_undo(element_id: String, previous_rect: Rect2) -> void:
	_undo_stack.append({"id": element_id, "rect": previous_rect})
	if _undo_stack.size() > 30:
		_undo_stack.pop_front()


func _undo_last() -> void:
	if _undo_stack.is_empty():
		return
	var item: Dictionary = _undo_stack.pop_back()
	var element_id := String(item.get("id", ""))
	if _elements.has(element_id):
		_apply_rect(_elements[element_id].get("control"), item.get("rect"))
		_surface.queue_redraw()


func _save_all() -> void:
	var viewport_size := _root_control.get_viewport_rect().size
	for element_id in _elements:
		var control: Control = _elements[element_id].get("control")
		_store.set_layout_rect(_scene_id, element_id, viewport_size, _rect_in_root(control))
	_store.save_layout()
	_store.save_content_overrides()


func _reset_element(element_id: String) -> void:
	if element_id.is_empty() or not _elements.has(element_id):
		return
	var entry: Dictionary = _elements[element_id]
	_push_undo(element_id, _rect_in_root(entry.get("control")))
	_apply_rect(entry.get("control"), entry.get("default_rect"))
	_store.reset_layout(_scene_id, _root_control.get_viewport_rect().size, element_id)
	_surface.queue_redraw()


func _reset_all() -> void:
	for element_id in _elements:
		_apply_rect(_elements[element_id].get("control"), _elements[element_id].get("default_rect"))
	_store.reset_layout(_scene_id, _root_control.get_viewport_rect().size)
	_surface.queue_redraw()


func _open_text_editor(element_id: String) -> void:
	var entry: Dictionary = _elements[element_id]
	var text_control: Control = entry.get("text_control")
	if text_control == null or String(entry.get("content_key", "")).is_empty():
		return
	_text_target_id = element_id
	_text_editor.text = String(text_control.get("text"))
	_text_popup.popup_centered()
	_text_editor.grab_focus()


func _apply_text_edit() -> void:
	if _text_target_id.is_empty() or not _elements.has(_text_target_id):
		return
	var entry: Dictionary = _elements[_text_target_id]
	if not _store.set_content_override(entry.get("content_key"), _text_editor.text):
		return
	var text_control: Control = entry.get("text_control")
	text_control.set("text", _text_editor.text)
	_store.save_content_overrides()
	_text_popup.hide()


func _reset_text_edit() -> void:
	if _text_target_id.is_empty() or not _elements.has(_text_target_id):
		return
	var entry: Dictionary = _elements[_text_target_id]
	_store.reset_content_override(entry.get("content_key"))
	var text_control: Control = entry.get("text_control")
	text_control.set("text", entry.get("source_text"))
	_store.save_content_overrides()
	_text_popup.hide()


func _export_patch() -> void:
	_store.export_content_patch()
