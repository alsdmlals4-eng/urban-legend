# 저승역 매뉴얼 사례와 5개 판단 후보의 학습 계약을 검증한다.
extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")
const Catalog = preload("res://scripts/ui/afterlife_manual_catalog.gd")

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
	game_state.set_current_field_node_id("field_station_investigation")
	change_scene_to_file(game_state.SCENE_INVESTIGATION)
	for _frame in range(5):
		await process_frame
	var scene := current_scene
	var point := {
		"id": "point_platform_speaker",
		"label": "플랫폼 스피커",
		"clue_id": "clue_repeating_announcement",
		"result_text": "방송 원본의 목적지 구간이 비어 있음을 확인했다.",
		"method_options": [{"id": "legacy_method"}]
	}
	var definition := Catalog.judgment_for_point("point_platform_speaker")
	scene.call("_show_reasoning_options", point, definition)
	await process_frame
	_expect(_choice_cards(scene).size() == 5, "major judgment should show five candidates")

	var risk_before: int = game_state.get_anomaly_risk()
	var risk_choice := _find_choice(definition, "replay_field_broadcast")
	scene.call("_select_reasoning_choice", risk_choice)
	await process_frame
	_expect(_choice_cards(scene).size() == 5, "risk action should return to the same five-choice list")
	_expect(game_state.get_anomaly_risk() > risk_before, "designated risk action should record a risk effect")
	_expect(game_state.get_recovery_pattern_learning().has("afterlife_reasoning:point_platform_speaker"), "risk action should leave a comparison record")

	scene.call("_open_manual_case", "failure_c")
	scene.call("_open_manual_case", "failure_b")
	await process_frame
	var cards := _choice_cards(scene)
	var disabled_count := 0
	for card in cards:
		var button := card.find_child("ActionButton", true, false) as Button
		if button != null and button.disabled:
			disabled_count += 1
			var reason := card.find_child("EliminationReasonLabel", true, false) as Label
			_expect(reason != null and not reason.text.is_empty(), "eliminated candidate should keep its reason visible")
	_expect(cards.size() == 5, "eliminated candidates should remain visible")
	_expect(disabled_count == 3, "failure cases should eliminate the three explicit wrong candidates")
	_expect(cards.size() - disabled_count >= 2, "manual and support must leave at least two candidates")

	var correct_choice := _find_choice(definition, "inspect_original_silence")
	scene.call("_select_reasoning_choice", correct_choice)
	await process_frame
	_expect(game_state.has_collected_clue("clue_repeating_announcement"), "only the correct judgment should apply the underlying point clue")
	_finish()


func _choice_cards(scene: Node) -> Array:
	var box := scene.find_child("FieldChoiceBox", true, false)
	return box.get_children() if box != null else []


func _find_choice(definition: Dictionary, choice_id: String) -> Dictionary:
	for value in definition.get("choices", []):
		if typeof(value) == TYPE_DICTIONARY and String(value.get("id", "")) == choice_id:
			return (value as Dictionary).duplicate(true)
	return {}


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
		print("MVP043 REASONING UI: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
