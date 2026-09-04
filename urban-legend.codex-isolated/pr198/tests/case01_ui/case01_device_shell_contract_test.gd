extends SceneTree

const SHELL_SCENE_PATH := "res://scenes/ui/case01_investigative_device_shell.tscn"

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var exists := ResourceLoader.exists(SHELL_SCENE_PATH)
	_expect(exists, "CASE-01 investigative device shell scene must exist")
	if not exists:
		_finish()
		return

	var scene_value: Variant = load(SHELL_SCENE_PATH)
	_expect(scene_value is PackedScene, "CASE-01 device shell must load as PackedScene")
	if scene_value is PackedScene:
		var shell := (scene_value as PackedScene).instantiate()
		root.add_child(shell)
		await process_frame
		_expect(shell.find_child("RecordsTabButton", true, false) is Button, "shell must expose RecordsTabButton")
		_expect(shell.find_child("ManualTabButton", true, false) is Button, "shell must expose ManualTabButton")
		_expect(shell.find_child("MapTabButton", true, false) is Button, "shell must expose MapTabButton")
		_expect(shell.find_child("ReturnToFieldButton", true, false) is Button, "shell must expose ReturnToFieldButton")
		_expect(shell.find_child("RecordsHost", true, false) is Control, "shell must expose RecordsHost")
		_expect(shell.find_child("ManualHost", true, false) is Control, "shell must expose ManualHost")
		_expect(shell.find_child("MapHost", true, false) is Control, "shell must expose MapHost")
		_expect(shell.find_child("LogTabButton", true, false) == null, "shell must not expose a player-facing log tab")
		_expect(shell.find_child("AiLogTabButton", true, false) == null, "shell must not expose a player-facing AI log tab")
		_expect(shell.has_method("open"), "shell controller must expose open")
		_expect(shell.has_method("close"), "shell controller must expose close")
		_expect(shell.has_method("switch_tab"), "shell controller must expose switch_tab")
		_expect(shell.has_method("capture_ui_state"), "shell controller must expose capture_ui_state")
		_expect(shell.has_method("restore_ui_state"), "shell controller must expose restore_ui_state")
		shell.queue_free()
		await process_frame
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("CASE01 DEVICE SHELL CONTRACT: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
