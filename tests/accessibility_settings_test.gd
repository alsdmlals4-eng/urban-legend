extends SceneTree

const Settings = preload("res://scripts/ui/accessibility_settings.gd")


func _init() -> void:
	var settings := Settings.new()
	var original_shake := settings.get_strength("screen_shake")
	var original_flash := settings.get_strength("flash")
	assert(settings.set_strength("screen_shake", 2.0) == OK)
	assert(settings.get_strength("screen_shake") == 1.0)
	assert(settings.set_strength("flash", -1.0) == OK)
	assert(settings.get_strength("flash") == 0.0)
	assert(settings.set_strength("unknown", 0.5) == ERR_INVALID_PARAMETER)
	settings.set_strength("screen_shake", original_shake)
	settings.set_strength("flash", original_flash)
	print("accessibility_settings_test: PASS")
	quit()
