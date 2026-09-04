# 런타임 UI 배치와 서술 문구 override를 게임 저장과 분리해 관리한다.
class_name UiLayoutStore
extends RefCounted

const LAYOUT_PATH := "user://ui_layout.cfg"
const CONTENT_PATH := "user://content_overrides.json"
const EXPORT_PATH := "user://content_overrides_patch.json"
const GRID_SIZE := 8.0

var _layout := ConfigFile.new()
var _content_overrides: Dictionary = {}


func _init() -> void:
	load_files()


func load_files() -> void:
	_layout = ConfigFile.new()
	if FileAccess.file_exists(LAYOUT_PATH):
		var layout_error := _layout.load(LAYOUT_PATH)
		if layout_error != OK:
			_layout = ConfigFile.new()
	_content_overrides = {}
	if not FileAccess.file_exists(CONTENT_PATH):
		return
	var file := FileAccess.open(CONTENT_PATH, FileAccess.READ)
	if file == null:
		return
	var parser := JSON.new()
	if parser.parse(file.get_as_text()) != OK:
		return
	var parsed: Variant = parser.data
	if typeof(parsed) == TYPE_DICTIONARY:
		_content_overrides = parsed


func profile_for_size(viewport_size: Vector2) -> String:
	if viewport_size.y <= 0.0:
		return "16_9"
	var ratio := viewport_size.x / viewport_size.y
	if ratio >= 2.0:
		return "ultrawide"
	if absf(ratio - 1.6) <= 0.06:
		return "16_10"
	return "16_9"


func snap_value(value: float) -> float:
	return roundf(value / GRID_SIZE) * GRID_SIZE


func snap_rect(rect: Rect2) -> Rect2:
	return Rect2(
		snap_value(rect.position.x),
		snap_value(rect.position.y),
		snap_value(rect.size.x),
		snap_value(rect.size.y)
	)


func clamp_rect(rect: Rect2, safe_area: Rect2, minimum_size: Vector2) -> Rect2:
	var result := rect
	result.size.x = clampf(result.size.x, minimum_size.x, safe_area.size.x)
	result.size.y = clampf(result.size.y, minimum_size.y, safe_area.size.y)
	result.position.x = clampf(result.position.x, safe_area.position.x, safe_area.end.x - result.size.x)
	result.position.y = clampf(result.position.y, safe_area.position.y, safe_area.end.y - result.size.y)
	return result


func normalize_rect(rect: Rect2, viewport_size: Vector2) -> Rect2:
	if viewport_size.x <= 0.0 or viewport_size.y <= 0.0:
		return Rect2()
	return Rect2(rect.position / viewport_size, rect.size / viewport_size)


func denormalize_rect(rect: Rect2, viewport_size: Vector2) -> Rect2:
	return Rect2(rect.position * viewport_size, rect.size * viewport_size)


func get_layout_rect(scene_id: String, element_id: String, viewport_size: Vector2, fallback: Rect2) -> Rect2:
	var section := "%s/%s" % [profile_for_size(viewport_size), scene_id]
	if not _layout.has_section_key(section, element_id):
		return fallback
	var value: Variant = _layout.get_value(section, element_id)
	if typeof(value) != TYPE_PACKED_FLOAT32_ARRAY:
		return fallback
	var values := value as PackedFloat32Array
	if values.size() != 4:
		return fallback
	return denormalize_rect(Rect2(values[0], values[1], values[2], values[3]), viewport_size)


func set_layout_rect(scene_id: String, element_id: String, viewport_size: Vector2, rect: Rect2) -> void:
	var section := "%s/%s" % [profile_for_size(viewport_size), scene_id]
	var normalized := normalize_rect(rect, viewport_size)
	_layout.set_value(section, element_id, PackedFloat32Array([
		normalized.position.x,
		normalized.position.y,
		normalized.size.x,
		normalized.size.y
	]))


func get_layout_property(scene_id: String, element_id: String, viewport_size: Vector2, property_name: String, fallback: Variant) -> Variant:
	var section := "%s/%s" % [profile_for_size(viewport_size), scene_id]
	return _layout.get_value(section, "%s:%s" % [element_id, property_name], fallback)


func set_layout_property(scene_id: String, element_id: String, viewport_size: Vector2, property_name: String, value: Variant) -> void:
	var section := "%s/%s" % [profile_for_size(viewport_size), scene_id]
	_layout.set_value(section, "%s:%s" % [element_id, property_name], value)


func reset_layout(scene_id: String, viewport_size: Vector2, element_id: String = "") -> void:
	var section := "%s/%s" % [profile_for_size(viewport_size), scene_id]
	if element_id.is_empty():
		_layout.erase_section(section)
	else:
		if _layout.has_section_key(section, element_id):
			_layout.erase_section_key(section, element_id)
		for key in _layout.get_section_keys(section):
			if String(key).begins_with("%s:" % element_id):
				_layout.erase_section_key(section, key)


func save_layout() -> Error:
	return _layout.save(LAYOUT_PATH)


func get_content_override(key: String, fallback: String) -> String:
	var value: Variant = _content_overrides.get(key, fallback)
	return String(value) if typeof(value) == TYPE_STRING else fallback


func set_content_override(key: String, value: String) -> bool:
	var trimmed := value.strip_edges()
	if trimmed.is_empty():
		return false
	_content_overrides[key] = value
	return true


func reset_content_override(key: String) -> void:
	_content_overrides.erase(key)


func reset_all_content_overrides() -> void:
	_content_overrides.clear()


func save_content_overrides() -> Error:
	var file := FileAccess.open(CONTENT_PATH, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string(JSON.stringify(_content_overrides, "\t"))
	return OK


func export_content_patch() -> Error:
	var file := FileAccess.open(EXPORT_PATH, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string(JSON.stringify({
		"format": "urban-legend-content-override-v1",
		"overrides": _content_overrides
	}, "\t"))
	return OK


func get_export_path() -> String:
	return EXPORT_PATH
