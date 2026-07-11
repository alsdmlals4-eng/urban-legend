# 액션 판정 결과가 저장 payload와 사건 보고서 요약까지 이어지는지 검증한다.
extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")

var _failures: Array[String] = []
var _save_guard := TestSaveGuard.new()


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node("GameState")
	var prepare_error := _save_guard.prepare(game_state.get_save_file_path())
	if not prepare_error.is_empty():
		_failures.append(prepare_error)
		_report_failures_and_quit()
		return
	game_state.reset_run_state()
	game_state.set_current_minigame_id("minigame_frequency_sync")
	game_state.save_minigame_result("minigame_frequency_sync", true, {
		"game_type": "rhythm_timing",
		"input_summary": "5박자 중 4회 동기화",
		"effect_summary": "위험도 -5"
	})
	_assert_pipeline(game_state, "minigame_frequency_sync", "rhythm_timing", true)
	await _assert_completed_game_does_not_reapply(game_state, "rhythm_timing_game.gd")

	game_state.start_episode_from_preparation("res://data/episodes/episode_002_red_umbrella_alley.json")
	game_state.set_current_minigame_id("minigame_rain_sync")
	game_state.save_minigame_result("minigame_rain_sync", false, {
		"game_type": "rain_dodge",
		"input_summary": "8.4초 생존 / 충돌 3회",
		"effect_summary": "위험도 +10"
	})
	_assert_pipeline(game_state, "minigame_rain_sync", "rain_dodge", false)
	await _assert_completed_game_does_not_reapply(game_state, "rain_dodge_game.gd")
	_assert_save_payload(game_state.get_save_file_path(), "minigame_rain_sync", "rain_dodge")
	var restore_error := _save_guard.restore()
	if not restore_error.is_empty():
		_failures.append(restore_error)

	if _failures.is_empty():
		print("MINIGAME PIPELINE: save and report assertions passed")
		quit(0)
		return
	_report_failures_and_quit()


func _report_failures_and_quit() -> void:
	for failure in _failures:
		push_error(failure)
	quit(1)


func _assert_pipeline(game_state: Node, minigame_id: String, game_type: String, successful: bool) -> void:
	var result: Dictionary = game_state.get_minigame_result(minigame_id)
	_expect(String(result.get("game_type", "")) == game_type, "%s should persist its game type" % minigame_id)
	_expect(bool(result.get("successful", not successful)) == successful, "%s should persist its outcome" % minigame_id)
	_expect(not String(result.get("input_summary", "")).is_empty(), "%s should persist its play summary" % minigame_id)
	var report: Dictionary = game_state.get_case_report_summary()
	var report_results: Dictionary = report.get("minigame_results", {})
	_expect(report_results.has(minigame_id), "%s should appear in the case report summary" % minigame_id)


func _assert_save_payload(save_path: String, minigame_id: String, game_type: String) -> void:
	var file := FileAccess.open(save_path, FileAccess.READ)
	_expect(file != null, "save payload should be written")
	if file == null:
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	_expect(typeof(parsed) == TYPE_DICTIONARY, "save payload should contain valid JSON")
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	var results: Dictionary = parsed.get("minigame_results", {})
	var result: Dictionary = results.get(minigame_id, {})
	_expect(String(result.get("game_type", "")) == game_type, "save payload should preserve game-specific details")


func _assert_completed_game_does_not_reapply(game_state: Node, game_script_name: String) -> void:
	var risk_before := int(game_state.get_anomaly_risk())
	var packed_scene: PackedScene = load("res://scenes/minigame_scene.tscn")
	var scene: Node = packed_scene.instantiate()
	root.add_child(scene)
	await process_frame
	await process_frame
	_expect(int(game_state.get_anomaly_risk()) == risk_before, "re-entering a completed minigame should not apply its effects again")
	_expect(not _has_script_name(scene, game_script_name), "re-entering a completed minigame should show its saved record instead of restarting gameplay")
	scene.queue_free()
	await process_frame


func _has_script_name(node: Node, script_name: String) -> bool:
	var script: Script = node.get_script()
	if script != null and script.resource_path.get_file() == script_name:
		return true
	for child in node.get_children():
		if _has_script_name(child, script_name):
			return true
	return false


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
