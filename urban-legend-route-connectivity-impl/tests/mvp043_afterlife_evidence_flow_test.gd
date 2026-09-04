# MVP-043 저승역의 일반 단서와 마지막 노선 검증 단서 경계를 검증한다.
extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")

var _guard := TestSaveGuard.new()
var _prepared := false
var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node("GameState")
	var error := _guard.prepare(game_state.get_save_file_path())
	if not error.is_empty():
		_failures.append(error)
		_finish()
		return
	_prepared = true
	game_state.reset_run_state()
	var ticket_point: Dictionary = game_state.get_investigation_point_by_id("point_black_ticket")
	game_state.apply_story_effects(ticket_point)
	_expect(not game_state.has_collected_clue("clue_black_ticket"), "the black ticket observation must not reveal the final route verification clue")

	game_state.resolve_field_choice("dialogue_intro", "field_begin_station_investigation")
	game_state.resolve_field_choice("dialogue_intro", "field_begin_broadcast_comparison")
	_expect(game_state.has_collected_clue("clue_staff_room_log"), "official operating records should provide a comparison clue")
	_expect(game_state.has_collected_clue("clue_repeating_announcement"), "broadcast original should provide a comparison clue")
	_expect(not game_state.has_collected_clue("clue_black_ticket"), "the final clue must remain unavailable before the route game")

	game_state.save_minigame_result("minigame_frequency_sync", true, {
		"game_type": "route_restore",
		"final_clue_title": "안전 노선 검증 기록",
		"clear_grade": "optimal"
	})
	_expect(game_state.has_collected_clue("clue_black_ticket"), "successful route verification should register the final clue")
	var result: Dictionary = game_state.get_minigame_result("minigame_frequency_sync")
	_expect(String(result.get("final_clue_title", "")) == "안전 노선 검증 기록", "route result should retain the final clue detail")
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _prepared:
		var restore_error := _guard.restore()
		if not restore_error.is_empty():
			_failures.append(restore_error)
		_prepared = false
	if _failures.is_empty():
		print("MVP043 AFTERLIFE EVIDENCE FLOW: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
