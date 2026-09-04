extends SceneTree

const GAME_STATE_PATH := "res://scripts/core/afterlife_migrating_game_state.gd"
const REQUIRED_METHOD := "apply_afterlife_manual_draft"

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var script_value: Variant = load(GAME_STATE_PATH)
	_expect(script_value is Script, "AfterlifeMigratingGameState must load")
	if script_value is Script:
		var game_state = (script_value as Script).new()
		_expect(game_state != null, "AfterlifeMigratingGameState must instantiate")
		if game_state != null:
			_expect(game_state.has_method(REQUIRED_METHOD), "AfterlifeMigratingGameState must expose apply_afterlife_manual_draft")
			if game_state.has_method(REQUIRED_METHOD):
				var inactive_result: Dictionary = game_state.call(REQUIRED_METHOD, {"filled_slots": {}})
				_expect(not bool(inactive_result.get("ok", false)), "manual draft API must fail closed before the Canon v2 contract is active")
			game_state.free()
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("CASE01 MANUAL DRAFT STATE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
