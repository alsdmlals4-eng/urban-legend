extends Node

const TestSaveGuard = preload("res://tests/test_save_guard.gd")
const EpisodeLoaderScript = preload("res://scripts/data/episode_loader.gd")
const EPISODES := [
	"res://data/episodes/episode_001_afterlife_station.json",
	"res://data/episodes/episode_002_red_umbrella_alley.json"
]

var _guard := TestSaveGuard.new()
var _passed := 0
var _failed := 0


func _ready() -> void:
	var error := _guard.prepare(GameState.SAVE_FILE_PATH)
	if not error.is_empty():
		push_error(error)
		get_tree().quit(1)
		return
	_run_tests()
	_guard.restore()
	print("MVP-033: %d passed, %d failed" % [_passed, _failed])
	get_tree().quit(0 if _failed == 0 else 1)


func _run_tests() -> void:
	_test_episode_schema()
	_test_prediction_fairness()
	_test_legacy_field_mapping()
	_test_pattern_order_and_learning()
	_test_auto_action_chance()
	_test_save_round_trip()


func _test_episode_schema() -> void:
	for path in EPISODES:
		var data: Dictionary = EpisodeLoaderScript.new().load_episode(path)
		_check(data.get("field_nodes", []).size() >= 2, "%s field nodes" % path)
		var patterns: Array = data.get("recovery_patterns", [])
		_check(patterns.size() == 4, "%s has four recovery patterns" % path)
		for pattern in patterns:
			_check(not String(pattern.get("telegraph", "")).is_empty(), "pattern telegraph")
			_check(pattern.get("responses", []).size() >= 3, "pattern contextual responses")


func _test_prediction_fairness() -> void:
	GameState.reset_run_state()
	GameState.set_anomaly_understanding_for_test(50)
	GameState.reset_prediction_decay()
	_check(is_equal_approx(GameState.get_current_prediction_rate(), 50.0), "prediction base")
	GameState.apply_prediction_result(true)
	_check(is_equal_approx(GameState.get_current_prediction_rate(), 35.0), "success suppresses next prediction")
	GameState.apply_prediction_result(false)
	_check(is_equal_approx(GameState.get_current_prediction_rate(), 60.0), "failure grants recovery")
	var streaks := GameState.get_prediction_streaks()
	_check(int(streaks.success) == 0 and int(streaks.failure) == 1, "opposite streak resets")


func _test_legacy_field_mapping() -> void:
	GameState.load_episode(EPISODES[0])
	var field_id := GameState.map_legacy_dialogue_node_to_field_node("dialogue_intro")
	_check(field_id == "dialogue_intro", "legacy dialogue maps to same field id")
	GameState.set_current_field_node_id(field_id)
	_check(GameState.get_current_field_node().get("id", "") == field_id, "current field resolves")


func _test_pattern_order_and_learning() -> void:
	GameState.load_episode(EPISODES[0])
	GameState.reset_recovery_pattern_state()
	var first := GameState.select_next_recovery_pattern()
	var second := GameState.select_next_recovery_pattern()
	_check(first.get("order", -1) == 0 and second.get("order", -1) == 1, "first pattern appearances are ordered")
	_check(first.get("id", "") != second.get("id", ""), "consecutive patterns differ")
	GameState.record_recovery_pattern_outcome(String(first.id), "wrong", false, "시선을 따르면 동선이 흐려진다.")
	_check(GameState.get_recovery_pattern_learning().has(String(first.id)), "wrong response leaves learning")


func _test_auto_action_chance() -> void:
	GameState.load_episode(EPISODES[0])
	GameState.set_selected_agent_ids(["agent_kang_ijun", "agent_kwon_narae"])
	var chance := GameState.get_agent_auto_action_chance("agent_kang_ijun", "suppression")
	_check(chance >= 15.0 and chance <= 70.0, "auto action chance is clamped")
	GameState.change_agent_mental("agent_kang_ijun", -999)
	_check(GameState.get_agent_auto_action_chance("agent_kang_ijun", "suppression") == 0.0, "inactive agent cannot proc")


func _test_save_round_trip() -> void:
	GameState.load_episode(EPISODES[1])
	GameState.set_current_field_node_id("dialogue_intro")
	GameState.change_anomaly_stability(37 - GameState.get_anomaly_stability())
	GameState.apply_prediction_result(false)
	GameState.record_recovery_pattern_outcome("pattern_red_rain_rewind", "wait", true, "세 번째 박자를 넘겼다.")
	_check(GameState.save_game(), "save mvp033 state")
	GameState.reset_run_state()
	_check(GameState.load_game(), "load mvp033 state")
	_check(GameState.get_current_field_node_id() == "dialogue_intro", "field node round trip")
	_check(GameState.get_anomaly_stability() == 37, "stability round trip")
	_check(int(GameState.get_prediction_streaks().failure) == 1, "failure streak round trip")


func _check(condition: bool, label: String) -> void:
	if condition:
		_passed += 1
		print("  PASS: %s" % label)
	else:
		_failed += 1
		push_error("  FAIL: %s" % label)
