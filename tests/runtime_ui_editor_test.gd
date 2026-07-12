# F2 편집기가 등록 영역과 편집 모드를 안전하게 관리하는지 검증한다.
extends SceneTree

const RuntimeEditor = preload("res://scripts/ui/runtime_ui_editor.gd")


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var root_control := Control.new()
	root_control.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_child(root_control)
	var layout := VBoxContainer.new()
	layout.position = Vector2(80, 64)
	layout.size = Vector2(640, 400)
	root_control.add_child(layout)
	var panel := PanelContainer.new()
	panel.position = Vector2(100, 100)
	panel.size = Vector2(320, 180)
	layout.add_child(panel)
	var label := Label.new()
	label.text = "원문"
	panel.add_child(label)

	var editor := RuntimeEditor.new()
	root_control.add_child(editor)
	editor.setup("test_scene", root_control)
	editor.register_element("dialogue", panel, {
		"minimum_size": Vector2(200, 100),
		"free_layout": true,
		"text_control": label,
		"content_key": "test/dialogue",
		"source_text": "원문"
	})
	editor.toggle_edit_mode(true)
	await process_frame
	await process_frame
	await process_frame
	await process_frame
	if panel.get_parent() != root_control:
		push_error("free-layout controls should detach from Container parents")
		quit(1)
		return
	var original_position := panel.position
	panel.position += Vector2(16, 8)
	await process_frame
	if panel.position != original_position + Vector2(16, 8):
		push_error("free-layout controls should keep edited positions")
		quit(1)
		return
	if not editor.is_edit_mode():
		push_error("runtime editor should enter edit mode in debug builds")
		quit(1)
		return
	editor.toggle_edit_mode(false)
	if editor.is_edit_mode():
		push_error("runtime editor should leave edit mode")
		quit(1)
		return
	print("RUNTIME UI EDITOR: assertions passed")
	quit(0)
