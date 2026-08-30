extends SceneTree

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	if OS.get_name() == "Windows":
		var appdata := _normalized(OS.get_environment("APPDATA"))
		var localappdata := _normalized(OS.get_environment("LOCALAPPDATA"))
		var user_profile := _normalized(OS.get_environment("USERPROFILE"))
		var user_data_dir := _normalized(OS.get_user_data_dir())
		_expect(not appdata.is_empty(), "Windows test process must receive APPDATA")
		_expect(not localappdata.is_empty(), "Windows test process must receive LOCALAPPDATA")
		_expect(not user_profile.is_empty(), "Windows test process must receive USERPROFILE")
		if not user_profile.is_empty():
			var live_appdata_root := user_profile + "/appdata/"
			_expect(
				not appdata.begins_with(live_appdata_root),
				"test process APPDATA must not resolve under the live user profile"
			)
			_expect(
				not localappdata.begins_with(live_appdata_root),
				"test process LOCALAPPDATA must not resolve under the live user profile"
			)
			_expect(
				not user_data_dir.begins_with(live_appdata_root),
				"Godot user:// must not resolve under the live user profile"
			)
	_finish()


func _normalized(value: String) -> String:
	return value.replace("\\", "/").trim_suffix("/").to_lower()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("WINDOWS USER DATA ISOLATION: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
