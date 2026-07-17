# 메인 화면의 기록국 레이아웃과 로컬 화면 설정 계약을 확인한다.
extends SceneTree

const DisplaySettingsScript = preload("res://scripts/ui/display_settings.gd")
const AfterlifeTheme = preload("res://scripts/ui/afterlife_station_theme.gd")
const TestSaveGuard = preload("res://tests/test_save_guard.gd")

var _guard := TestSaveGuard.new()
var _prepared := false
var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node("GameState")
	var guard_error := _guard.prepare(game_state.get_save_file_path())
	if not guard_error.is_empty():
		_failures.append(guard_error)
		_finish()
		return
	_prepared = true
	_test_display_preferences()
	if change_scene_to_file("res://scenes/main_menu.tscn") != OK:
		_failures.append("main menu failed to load")
		_finish()
		return
	for _frame in range(4):
		await process_frame
	for viewport_size in [Vector2i(1280, 720), Vector2i(1920, 1080)]:
		root.size = viewport_size
		await process_frame
		_verify_menu_layout(current_scene, viewport_size)
	var log_guide := current_scene.find_child("LogGuide", true, false) as PanelContainer
	var guide_panel := log_guide.get_theme_stylebox("panel") as StyleBoxFlat if log_guide != null else null
	_expect(guide_panel != null and guide_panel.border_color.is_equal_approx(AfterlifeTheme.GOLD), "main menu guide should use the afterlife gold frame")
	var settings_button := current_scene.find_child("DisplaySettingsButton", true, false) as Button
	_expect(settings_button != null, "main menu should expose one display settings button")
	if settings_button != null:
		settings_button.emit_signal("pressed")
		await process_frame
		var dialog: AcceptDialog
		for child in current_scene.get_children():
			if child is AcceptDialog and child.has_meta("game_settings_dialog"):
				dialog = child as AcceptDialog
				break
		_expect(dialog != null and dialog.visible, "display settings should open from main menu")
		_expect(dialog != null and _tree_contains_text(dialog, "1280 × 720") and _tree_contains_text(dialog, "1920 × 1080"), "settings should list both approved resolutions")
		_expect(dialog != null and _tree_contains_text(dialog, "창 모드") and _tree_contains_text(dialog, "전체 화면"), "settings should expose windowed and fullscreen modes")
	_finish()


func _test_display_preferences() -> void:
	var path := "user://main_menu_display_settings_test.cfg"
	var settings := DisplaySettingsScript.new(path)
	_expect(settings.save_preferences(Vector2i(1920, 1080), DisplaySettingsScript.FULLSCREEN) == OK, "display preferences should save valid fullscreen selection")
	var loaded := DisplaySettingsScript.new(path)
	_expect(loaded.get_resolution() == Vector2i(1920, 1080), "display preferences should reload 1920x1080")
	_expect(loaded.get_window_mode() == DisplaySettingsScript.FULLSCREEN, "display preferences should reload fullscreen mode")
	_expect(loaded.save_preferences(Vector2i(1600, 900), DisplaySettingsScript.WINDOWED) == ERR_INVALID_PARAMETER, "unsupported resolution should be rejected")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _verify_menu_layout(scene: Node, viewport_size: Vector2i) -> void:
	var viewport_rect := Rect2(Vector2.ZERO, Vector2(viewport_size))
	for node_name in ["MainMenuHeader", "MainMenuColumns", "FieldPreviewPanel", "CampaignPanel", "ArchivePanel"]:
		var control := scene.find_child(node_name, true, false) as Control
		_expect(control != null and control.is_visible_in_tree() and viewport_rect.encloses(control.get_global_rect()), "%s should fit the %s menu frame" % [node_name, viewport_size])
	_expect(scene.find_child("ScrollContainer", true, false) == null, "main menu should not use a full-screen scrolling card stack")


func _tree_contains_text(node: Node, needle: String) -> bool:
	for child in node.find_children("*", "Label", true, false) + node.find_children("*", "Button", true, false) + node.find_children("*", "OptionButton", true, false):
		if child is Button or child is Label:
			if String(child.get("text")).contains(needle):
				return true
		if child is OptionButton:
			var option := child as OptionButton
			for index in option.item_count:
				if option.get_item_text(index).contains(needle):
					return true
	return false


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _prepared:
		var restore_error := _guard.restore()
		if not restore_error.is_empty():
			_failures.append(restore_error)
		_prepared = false
	if _failures.is_empty():
		print("main_menu_display_settings_test: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
