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
	game_state.reset_run_state()
	_expect(game_state.get_relationship_chains().size() == 12, "registry exposes twelve relationship chains")
	_expect(game_state.get_relationship_scene_count() == 30, "registry exposes thirty relationship scenes")
	_expect(game_state.get_relationship_records().is_empty(), "mvp-039 state migrates with no fabricated relationship records")
	_expect(game_state.resolve_campaign_case("episode_001_afterlife_station", "standard"), "afterlife resolution unlocks the first relation chain")
	_expect(bool(game_state.begin_daily_episode("AFTER-02").get("successful", false)), "AFTER-02 opens through the optional narrative flow")
	_expect(bool(game_state.resolve_daily_episode_choice("after02_compare_structures").get("successful", false)), "AFTER-02 completion creates its prerequisite record")
	_expect(game_state.get_available_relationship_scenes().any(func(value): return String(value.get("id", "")) == "REL-P01-01"), "AFTER-02-backed relation scene becomes available")
	var started: Dictionary = game_state.begin_relationship_scene("REL-P01-01")
	_expect(bool(started.get("successful", false)), "relationship scene starts without consuming schedule")
	var resolved: Dictionary = game_state.resolve_relationship_choice("observe_then_burn")
	_expect(bool(resolved.get("successful", false)), "relationship choice resolves once")
	_expect(String((resolved.get("record", {}) as Dictionary).get("memory_effect", "")) == "기록을_믿음", "choice memory is persisted as text, not a stat")
	_expect(game_state.get_relationship_records().size() == 1, "relationship record is stored once")
	_expect(game_state.has_method("get_relationship_memories"), "relationship memories are available by pair for DB and later scenes")
	_expect(game_state.has_method("get_relationship_chain_progress"), "relationship chain exposes completed progress without a hidden affinity score")
	_expect(game_state.has_method("get_relationship_tags"), "relationship tags are derived without a hidden affinity score")
	if game_state.has_method("get_relationship_memories"):
		_expect(game_state.get_relationship_memories("agent_kwon_narae::agent_yoon_seoha").has("기록을_믿음"), "selected relationship memory is retrievable by pair")
	if game_state.has_method("get_relationship_chain_progress"):
		_expect(game_state.get_relationship_chain_progress("REL-P01").get("completed", 0) == 1, "relationship chain reports completed progress")
	if game_state.has_method("get_relationship_tags"):
		_expect(game_state.get_relationship_tags("agent_kwon_narae::agent_yoon_seoha").is_empty(), "one memory alone does not fabricate a relationship tag")
	_finish()


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
		print("MVP-045 relationship: %d passed, 0 failed" % _passed)
		quit(0)
	else:
		push_error("MVP-045 relationship: %d passed, %d failed" % [_passed, _failed])
		quit(1)
