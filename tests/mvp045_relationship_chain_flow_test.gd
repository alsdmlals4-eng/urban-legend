extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")

var _guard := TestSaveGuard.new()
var _prepared := false
var _passed := 0
var _failed := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node("GameState")
	var guard_error := _guard.prepare(game_state.SAVE_FILE_PATH)
	if not guard_error.is_empty():
		_fail(guard_error)
		_finish()
		return
	_prepared = true
	var chains: Array = game_state.get_relationship_chains()
	_expect(chains.size() == 12, "all twelve relationship chains are registered")
	for chain_value in chains:
		if typeof(chain_value) != TYPE_DICTIONARY:
			_fail("relationship chain has invalid data")
			continue
		_run_chain(game_state, chain_value as Dictionary)
	_finish()


func _run_chain(game_state, chain: Dictionary) -> void:
	game_state.reset_run_state()
	game_state.resolve_campaign_case("episode_001_afterlife_station", "standard")
	var start: Array = chain.get("start", [])
	if start.is_empty():
		_fail("%s has no start requirement" % String(chain.get("id", "relationship chain")))
		return
	game_state.completed_daily_episode_records.append({"episode_id": String(start[0])})
	var scenes: Array = chain.get("scenes", [])
	_expect(not scenes.is_empty(), "%s has scenes" % String(chain.get("id", "relationship chain")))
	for scene_value in scenes:
		if typeof(scene_value) != TYPE_DICTIONARY:
			_fail("%s has invalid scene data" % String(chain.get("id", "relationship chain")))
			continue
		var scene: Dictionary = scene_value
		var scene_id := String(scene.get("id", ""))
		_expect(not String(scene.get("intro", "")).strip_edges().is_empty(), "%s has player-facing relationship context" % scene_id)
		_expect(not String(scene.get("agent_name", "")).strip_edges().is_empty(), "%s identifies its participants" % scene_id)
		_expect(not String(scene.get("case_title", "")).strip_edges().is_empty(), "%s identifies its location" % scene_id)
		var started: Dictionary = game_state.begin_relationship_scene(scene_id)
		_expect(bool(started.get("successful", false)), "%s starts through the actual unlock flow" % scene_id)
		var choices: Array = scene.get("choices", [])
		_expect(choices.size() >= 2, "%s keeps player-facing choices" % scene_id)
		if choices.is_empty() or typeof(choices[0]) != TYPE_DICTIONARY:
			continue
		var choice_id := String((choices[0] as Dictionary).get("id", ""))
		var resolved: Dictionary = game_state.resolve_relationship_choice(choice_id)
		_expect(bool(resolved.get("successful", false)), "%s stores one selected memory" % scene_id)
	var progress: Dictionary = game_state.get_relationship_chain_progress(String(chain.get("id", "")))
	_expect(int(progress.get("completed", 0)) == scenes.size(), "%s completes every scene in order" % String(chain.get("id", "relationship chain")))
	var tags: Array = game_state.get_relationship_tags(String(chain.get("pair_key", "")))
	_expect(tags.size() == 2, "%s derives two display-only tags from its final memory" % String(chain.get("id", "relationship chain")))


func _expect(condition: bool, message: String) -> void:
	if condition:
		_passed += 1
	else:
		_fail(message)


func _fail(message: String) -> void:
	_failed += 1
	push_error(message)


func _finish() -> void:
	if _prepared:
		var restore_error := _guard.restore()
		_prepared = false
		if not restore_error.is_empty():
			_fail(restore_error)
	if _failed == 0:
		print("MVP-045 relationship chain flow: %d passed, 0 failed" % _passed)
		quit(0)
	else:
		push_error("MVP-045 relationship chain flow: %d passed, %d failed" % [_passed, _failed])
		quit(1)
