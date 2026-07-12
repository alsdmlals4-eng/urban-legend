# 런타임 UI 레이아웃과 문구 override 저장 규칙을 검증한다.
extends SceneTree

const LayoutStore = preload("res://scripts/ui/ui_layout_store.gd")

var _failures: Array[String] = []


func _init() -> void:
	var layout_backup: Variant = _backup_file(LayoutStore.LAYOUT_PATH)
	var content_backup: Variant = _backup_file(LayoutStore.CONTENT_PATH)
	var store := LayoutStore.new()
	_expect(store.profile_for_size(Vector2(1280, 720)) == "16_9", "1280x720 should use the 16:9 profile")
	_expect(store.profile_for_size(Vector2(1920, 1200)) == "16_10", "1920x1200 should use the 16:10 profile")
	_expect(store.profile_for_size(Vector2(2560, 1080)) == "ultrawide", "2560x1080 should use the ultrawide profile")
	_expect(store.snap_value(13.0) == 16.0, "layout values should snap to an 8px grid")

	var clamped := store.clamp_rect(Rect2(-30, 690, 80, 80), Rect2(0, 0, 1280, 720), Vector2(120, 72))
	_expect(clamped.position.x >= 0.0 and clamped.end.y <= 720.0, "editable rectangles should stay inside the safe area")
	_expect(clamped.size.x >= 120.0 and clamped.size.y >= 72.0, "editable rectangles should keep minimum size")

	var normalized := store.normalize_rect(Rect2(128, 72, 640, 360), Vector2(1280, 720))
	var restored := store.denormalize_rect(normalized, Vector2(1920, 1080))
	_expect(restored.is_equal_approx(Rect2(192, 108, 960, 540)), "normalized layouts should scale across matching aspect ratios")

	store.set_content_override("episode_001_afterlife_station/dialogue/dialogue_intro/line_0/text", "수정된 대사")
	_expect(store.get_content_override("episode_001_afterlife_station/dialogue/dialogue_intro/line_0/text", "원문") == "수정된 대사", "content overrides should replace editable story copy")
	_expect(store.get_content_override("missing", "원문") == "원문", "missing overrides should fall back to source text")
	store.reset_content_override("episode_001_afterlife_station/dialogue/dialogue_intro/line_0/text")
	_expect(store.get_content_override("episode_001_afterlife_station/dialogue/dialogue_intro/line_0/text", "원문") == "원문", "reset should restore source text")

	store.set_layout_property("dialogue", "dialogue_panel", Vector2(1280, 720), "font_size", 22)
	_expect(store.get_layout_property("dialogue", "dialogue_panel", Vector2(1280, 720), "font_size", 17) == 22, "visual properties should be stored per layout profile")
	store.reset_layout("dialogue", Vector2(1280, 720), "dialogue_panel")
	_expect(store.get_layout_property("dialogue", "dialogue_panel", Vector2(1280, 720), "font_size", 17) == 17, "element reset should clear visual properties")

	var saved_rect := Rect2(96, 80, 640, 200)
	store.set_layout_rect("dialogue", "dialogue_panel", Vector2(1280, 720), saved_rect)
	store.set_content_override("test/persistence", "재시작 후 복원")
	_expect(store.save_layout() == OK, "layout file should save")
	_expect(store.save_content_overrides() == OK, "content override file should save")
	var reloaded := LayoutStore.new()
	_expect(reloaded.get_layout_rect("dialogue", "dialogue_panel", Vector2(1280, 720), Rect2()).is_equal_approx(saved_rect), "saved layout should restore in a new store")
	_expect(reloaded.get_content_override("test/persistence", "원문") == "재시작 후 복원", "saved copy should restore in a new store")

	var invalid_layout := ConfigFile.new()
	invalid_layout.set_value("16_9/dialogue", "dialogue_panel", "outside-screen")
	invalid_layout.save(LayoutStore.LAYOUT_PATH)
	var invalid_content := FileAccess.open(LayoutStore.CONTENT_PATH, FileAccess.WRITE)
	invalid_content.store_string("{ broken json")
	var fallback_store := LayoutStore.new()
	var fallback_rect := Rect2(10, 20, 300, 120)
	_expect(fallback_store.get_layout_rect("dialogue", "dialogue_panel", Vector2(1280, 720), fallback_rect) == fallback_rect, "invalid layout values should fall back")
	_expect(fallback_store.get_content_override("test/persistence", "원문") == "원문", "invalid content JSON should fall back")

	_restore_file(LayoutStore.LAYOUT_PATH, layout_backup)
	_restore_file(LayoutStore.CONTENT_PATH, content_backup)

	if _failures.is_empty():
		print("UI LAYOUT STORE: all assertions passed")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _backup_file(path: String) -> Variant:
	if not FileAccess.file_exists(path):
		return null
	return FileAccess.get_file_as_bytes(path)


func _restore_file(path: String, backup: Variant) -> void:
	if backup == null:
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
		return
	var file := FileAccess.open(path, FileAccess.WRITE)
	file.store_buffer(backup)
