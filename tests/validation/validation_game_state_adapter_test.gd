extends SceneTree

var _failures: Array[String] = []


func _init() -> void:
	var script: Script = load("res://scripts/core/validation_game_state.gd")
	_expect(script != null, "validation GameState wrapper must exist before adapter tests can run")
	if script == null:
		_finish()
		return

	var state = script.new()
	_expect(state.has_method("export_validation_runtime_snapshot"), "GameState wrapper must expose export_validation_runtime_snapshot")
	_expect(state.has_method("restore_validation_runtime_snapshot"), "GameState wrapper must expose restore_validation_runtime_snapshot")
	_expect(state.has_method("capture_validation_hidden_state_guard"), "GameState wrapper must expose capture_validation_hidden_state_guard")
	_expect(state.has_method("validation_hidden_state_matches"), "GameState wrapper must expose validation_hidden_state_matches")
	if not state.has_method("export_validation_runtime_snapshot"):
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

	var guard: Dictionary = state.capture_validation_hidden_state_guard()
	var snapshot: Dictionary = state.export_validation_runtime_snapshot()
	_expect(snapshot.has("current_scene_path"), "runtime snapshot must include current_scene_path")
	_expect(snapshot.has("selected_agent_ids"), "runtime snapshot must include selected agents")
	_expect(snapshot.has("flags"), "runtime snapshot must include per-run flags")
	_expect(not snapshot.has("echo_fragments"), "runtime snapshot must exclude economy")
	_expect(not snapshot.has("faction_relations"), "runtime snapshot must exclude faction relationships")
	_expect(not snapshot.has("completed_case_reports"), "runtime snapshot must exclude Legacy reports")

	state.current_scene_path = "res://scenes/dialogue_scene.tscn"
	var restore_result: Dictionary = state.restore_validation_runtime_snapshot(snapshot)
	_expect(bool(restore_result.get("ok", false)), "valid runtime snapshot must restore")
	_expect(state.current_scene_path == "res://scenes/investigation_scene.tscn", "restore must recover current_scene_path")
	_expect(state.echo_fragments == 777, "restore must not mutate economy")
	_expect(int(state.faction_relations.get("rumor_market", 0)) == 42, "restore must not mutate faction relationships")
	_expect(state.validation_hidden_state_matches(guard), "hidden-state guard must remain equal after restore")
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
