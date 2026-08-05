extends SceneTree

const GAME_STATE_PATH := "res://scripts/core/afterlife_migrating_game_state.gd"
const CANONICAL_PATTERN_PREFIX := "pattern_afterlife_"
const LEGACY_PATTERN_PREFIX := "pattern_station_"
const CANONICAL_RECORD_PREFIX := "record_afterlife_"

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
			_expect(String(episode.get("recovery_pattern_source", "")) == "canonical_v2_projection", "Validation did not activate canonical recovery projection")
			_expect(String(episode.get("clue_source", "")) == "canonical_v2_projection", "Validation did not activate canonical record projection")
			var patterns_value: Variant = episode.get("recovery_patterns")
			_expect(typeof(patterns_value) == TYPE_ARRAY, "Validation runtime recovery projection missing")
			if typeof(patterns_value) == TYPE_ARRAY:
				for pattern_value in patterns_value as Array:
					if typeof(pattern_value) != TYPE_DICTIONARY:
						_failures.append("Validation projected a non-Dictionary recovery pattern")
						continue
					var pattern_id := String((pattern_value as Dictionary).get("id", ""))
					_expect(pattern_id.begins_with(CANONICAL_PATTERN_PREFIX), "Validation projected a non-canonical recovery pattern")
					_expect(not pattern_id.begins_with(LEGACY_PATTERN_PREFIX), "Validation mixed a legacy recovery pattern")
			var clues_value: Variant = episode.get("clues")
			_expect(typeof(clues_value) == TYPE_ARRAY, "Validation runtime record projection missing")
			if typeof(clues_value) == TYPE_ARRAY:
				for clue_value in clues_value as Array:
					if typeof(clue_value) != TYPE_DICTIONARY:
						_failures.append("Validation projected a non-Dictionary record")
						continue
					_expect(String((clue_value as Dictionary).get("id", "")).begins_with(CANONICAL_RECORD_PREFIX), "Validation mixed a legacy clue into Canon v2")
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
