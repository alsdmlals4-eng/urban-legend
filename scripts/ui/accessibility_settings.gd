class_name AccessibilitySettings
extends RefCounted

const PATH := "user://accessibility.cfg"
const SECTION := "effects"
const DEFAULTS := {"screen_shake": 1.0, "flash": 1.0, "horror_distortion": 1.0, "cutin_motion": 1.0, "text_speed": 1.0}

var _config := ConfigFile.new()


func _init() -> void:
	if FileAccess.file_exists(PATH) and _config.load(PATH) != OK:
		_config = ConfigFile.new()


func get_strength(effect_id: String) -> float:
	return clampf(float(_config.get_value(SECTION, effect_id, DEFAULTS.get(effect_id, 1.0))), 0.0, 1.0)


func set_strength(effect_id: String, value: float) -> Error:
	if not DEFAULTS.has(effect_id):
		return ERR_INVALID_PARAMETER
	_config.set_value(SECTION, effect_id, clampf(value, 0.0, 1.0))
	return _config.save(PATH)
