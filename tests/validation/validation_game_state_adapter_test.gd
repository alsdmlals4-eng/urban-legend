extends SceneTree

const Support = preload("res://tests/validation/validation_test_support.gd")
const GameStateScript = preload("res://scripts/core/validation_game_state.gd")

var _failures: Array[String] = []


func _init() -> void:
	var state = GameStateScript.new()
	var clone = GameStateScript.new()
	_expect(state.load_episode(), "source state must load the default episode")
	_expect(clone.load_episode(), "clone state must load the default episode")

	_expect(state.has_method("export_validation_runtime_snapshot"), "adapter must expose export_validation_runtime_snapshot")
	_expect(state.has_method("restore_validation_runtime_snapshot"), "adapter must expose restore_validation_runtime_snapshot")
	_expect(state.has_method("snapshot_hidden_legacy_state_for_test"), "adapter must expose snapshot_hidden_legacy_state_for_test")
	if not state.has_method("snapshot_hidden_legacy_state_for_test"):
		state.free()
		clone.free()
		_finish()
		return

	state.current_scene_path = "res://scenes/investigation_scene.tscn"
	state.current_dialogue_node_id = "dialogue_test"
	state.current_field_node_id = "field_test"
	state.current_minigame_id = "minigame_frequency_sync"
	state.selected_agent_ids = ["agent_kwon_narae"]
	state.flags = ["validation_flag"]
	state.echo_fragments = 777
	state.faction_relations = {"rumor_market": 42}
	state.completed_case_reports = [{"episode_id": "legacy-report"}]

	var hidden_before: Dictionary = state.snapshot_hidden_legacy_state_for_test()
	var clone_hidden_before: Dictionary = clone.snapshot_hidden_legacy_state_for_test()
	var snapshot: Dictionary = state.export_validation_runtime_snapshot()
	for required in ["episode_id", "episode_path", "scene_path", "dialogue_node_id", "field_node_id", "minigame_id", "selected_agent_ids", "flags", "collected_clue_ids", "seen_hint_ids", "method_results", "minigame_results", "resolution", "recovery", "agent_case_states", "victim_state"]:
		_expect(snapshot.has(required), "snapshot must include %s" % required)
	for forbidden in ["campaign_state", "echo_fragments", "faction_relations", "completed_case_reports", "anomaly_manual_records", "agent_trust"]:
		_expect(not snapshot.has(forbidden), "snapshot must exclude %s" % forbidden)

	var restored: Dictionary = clone.restore_validation_runtime_snapshot(snapshot)
	_expect(String(restored.get("code", "")) == "OK", "valid snapshot should restore")
	_expect(Support.semantic_equal(clone.export_validation_runtime_snapshot(), snapshot), "restored snapshot should match the source")
	_expect(Support.semantic_equal(clone.snapshot_hidden_legacy_state_for_test(), clone_hidden_before), "restore must preserve clone hidden state")
	_expect(Support.semantic_equal(state.snapshot_hidden_legacy_state_for_test(), hidden_before), "export must not mutate source hidden state")

	var before_invalid: Dictionary = clone.export_validation_runtime_snapshot()
	var invalid_episode := snapshot.duplicate(true)
	invalid_episode["episode_id"] = "unknown_episode"
	_expect(String(clone.restore_validation_runtime_snapshot(invalid_episode).get("code", "")) == "INVALID_EPISODE", "unknown episode should fail")
	_expect(Support.semantic_equal(clone.export_validation_runtime_snapshot(), before_invalid), "failed episode restore must not partially apply")

	var invalid_type := snapshot.duplicate(true)
	invalid_type["flags"] = "not-an-array"
	_expect(String(clone.restore_validation_runtime_snapshot(invalid_type).get("code", "")) == "INVALID_PAYLOAD", "wrong field type should fail")
	_expect(Support.semantic_equal(clone.export_validation_runtime_snapshot(), before_invalid), "failed type restore must not partially apply")

	state.free()
	clone.free()
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("VALIDATION GAME STATE ADAPTER: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
