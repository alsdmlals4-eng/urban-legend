extends SceneTree

const ADAPTER_PATH := "res://scripts/ui/case01_device_data_adapter.gd"

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var exists := ResourceLoader.exists(ADAPTER_PATH)
	_expect(exists, "CASE-01 device adapter must exist")
	if not exists:
		_finish()
		return

	var script_value: Variant = load(ADAPTER_PATH)
	_expect(script_value is Script, "CASE-01 device adapter must load as Script")
	if script_value is Script:
		var adapter = (script_value as Script).new()
		_expect(adapter != null, "CASE-01 device adapter must instantiate")
		if adapter != null:
			_expect(adapter.has_method("bind_game_state"), "device adapter must expose bind_game_state")
			_expect(adapter.has_method("is_supported"), "device adapter must expose is_supported")
			_expect(adapter.has_method("get_shell_snapshot"), "device adapter must expose get_shell_snapshot")
			_expect(adapter.has_method("get_records_snapshot"), "device adapter must expose get_records_snapshot")
			_expect(adapter.has_method("get_manual_snapshot"), "device adapter must expose get_manual_snapshot")
			_expect(adapter.has_method("get_map_snapshot"), "device adapter must expose get_map_snapshot")
			_expect(adapter.has_method("request_manual_slot_assignment"), "device adapter must expose manual assignment intent")
			_expect(adapter.has_method("request_manual_slot_clear"), "device adapter must expose manual clear intent")
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("CASE01 DEVICE MODEL: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
