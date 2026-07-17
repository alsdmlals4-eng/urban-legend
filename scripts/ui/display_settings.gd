## 게임 진행 저장과 분리된 로컬 화면 설정이다.
class_name DisplaySettings
extends RefCounted

const DEFAULT_PATH := "user://display_settings.cfg"
const SECTION := "display"
const RESOLUTIONS := [Vector2i(1280, 720), Vector2i(1920, 1080)]
const WINDOWED := "windowed"
const FULLSCREEN := "fullscreen"

var _path := DEFAULT_PATH
var _config := ConfigFile.new()


func _init(path_override: String = DEFAULT_PATH) -> void:
	_path = path_override
	if FileAccess.file_exists(_path):
		_config.load(_path)


func get_resolution() -> Vector2i:
	var value := String(_config.get_value(SECTION, "resolution", "1280x720"))
	for resolution in RESOLUTIONS:
		if value == resolution_to_id(resolution):
			return resolution
	return RESOLUTIONS[0]


func get_window_mode() -> String:
	var mode := String(_config.get_value(SECTION, "window_mode", WINDOWED))
	return mode if mode in [WINDOWED, FULLSCREEN] else WINDOWED


func save_preferences(resolution: Vector2i, window_mode: String) -> Error:
	if resolution not in RESOLUTIONS or window_mode not in [WINDOWED, FULLSCREEN]:
		return ERR_INVALID_PARAMETER
	_config.set_value(SECTION, "resolution", resolution_to_id(resolution))
	_config.set_value(SECTION, "window_mode", window_mode)
	return _config.save(_path)


func apply_preferences(resolution: Vector2i, window_mode: String) -> Error:
	var error := save_preferences(resolution, window_mode)
	if error != OK or DisplayServer.get_name() == "headless":
		return error
	if window_mode == FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		return OK
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(resolution)
	var screen_size := DisplayServer.screen_get_usable_rect().size
	DisplayServer.window_set_position(Vector2i(maxi(0, (screen_size.x - resolution.x) / 2), maxi(0, (screen_size.y - resolution.y) / 2)))
	return OK


func apply_saved_preferences() -> Error:
	return apply_preferences(get_resolution(), get_window_mode())


static func resolution_to_id(resolution: Vector2i) -> String:
	return "%dx%d" % [resolution.x, resolution.y]
