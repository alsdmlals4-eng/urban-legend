extends SceneTree

const GAME_STATE_PATH := "res://scripts/core/afterlife_migrating_game_state.gd"

var _failures: Array[String] = []


func _init() -> void:
	var script_value: Variant = load(GAME_STATE_PATH)
	_expect(script_value is Script, "migrating GameState failed to load")
	if script_value is Script:
		var game_state = (script_value as Script).new()
		_expect(game_state.has_method("activate_afterlife_content_contract_for_migration"), "Validation cannot activate Canon v2 content contract")
		if game_state.has_method("activate_afterlife_content_contract_for_migration"):
			_expect(bool(game_state.activate_afterlife_content_contract_for_migration("afterlife-station-canon-v2")), "Canon v2 contract activation failed")
			_expect(game_state.load_episode(), "Canon v2 episode load failed after activation")
			var episode: Dictionary = game_state.get_current_episode()
			_expect(typeof(episode.get("recovery_encounters")) == TYPE_DICTIONARY, "Validation restored legacy episode instead of Canon v2")
			_expect(not episode.has("recovery_patterns"), "Validation mixed legacy and Canon v2 recovery patterns")
		game_state.free()
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("AFTERLIFE VALIDATION CANON ACTIVATION: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
