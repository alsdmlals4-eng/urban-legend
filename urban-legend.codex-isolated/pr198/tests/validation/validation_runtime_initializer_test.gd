extends SceneTree

const GameStateScript = preload("res://scripts/core/validation_game_state.gd")
const Support = preload("res://tests/validation/validation_test_support.gd")
const LEGACY_PATH := "user://urban_legend_save.json"
var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	Support.write_text(LEGACY_PATH, "PACKAGE-2-LEGACY-SENTINEL")
	var legacy_before := Support.read_bytes(LEGACY_PATH)
	var state = GameStateScript.new()
	state.name = "Package2InitializerState"
	get_root().add_child(state)
	await process_frame

	state.echo_fragments = 777
	state.agent_trust = {"agent_kwon_narae": 3}
	state.unlocked_records = ["legacy-record"]
	state.faction_relations = {"rumor_market": 9}
	state.consumable_inventory = {"legacy-item": 4}
	var hidden_before: Dictionary = state.snapshot_hidden_legacy_state_for_test()

	_expect(state.has_method("initialize_validation_runtime"), "initializer API must exist")
	if not state.has_method("initialize_validation_runtime"):
		_cleanup(state)
		_finish()
		return

	var result: Dictionary = state.initialize_validation_runtime(
		"episode_001_afterlife_station",
		["agent_oh_hyun", "agent_kwon_narae", "agent_kang_ijun"]
	)
	_expect(result.get("code") == "OK", "valid initializer must succeed")
	_expect(Support.semantic_equal(state.snapshot_hidden_legacy_state_for_test(), hidden_before), "hidden Legacy state must not change")
	_expect(Support.read_bytes(LEGACY_PATH) == legacy_before, "Legacy bytes must not change")
	_expect(state.get_current_episode_id() == "episode_001_afterlife_station", "episode must initialize")
	_expect(state.get_current_scene_path() == state.SCENE_DIALOGUE, "Validation must begin at dialogue")
	_expect(state.selected_agent_ids.size() == 3, "approved tutorial team must initialize")
	_expect(state.flags.is_empty(), "flags must reset")
	_expect(state.get_collected_clue_ids().is_empty(), "clues must reset")
	_expect(state.seen_hint_ids.is_empty(), "hints must reset")
	_expect(state.method_results.is_empty(), "method results must reset")
	_expect(state.minigame_results.is_empty(), "minigame results must reset")
	_expect(state.selected_resolution_grade.is_empty(), "resolution grade must reset")
	_expect(state.recovery_result_status.is_empty(), "recovery status must reset")
	_expect(state.agent_case_states.is_empty(), "agent case state must reset")
	_expect(state.victim_state.is_empty(), "victim state must reset")

	var invalid: Dictionary = state.initialize_validation_runtime("episode_unknown", [])
	_expect(invalid.get("code") == "INVALID_EPISODE", "unknown episode must fail")
	_expect(Support.semantic_equal(state.snapshot_hidden_legacy_state_for_test(), hidden_before), "invalid call must preserve hidden state")
	_expect(Support.read_bytes(LEGACY_PATH) == legacy_before, "invalid call must preserve Legacy bytes")
	_cleanup(state)
	_finish()


func _cleanup(state: Node) -> void:
	state.queue_free()
	Support.remove_path(LEGACY_PATH)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("VALIDATION RUNTIME INITIALIZER: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
