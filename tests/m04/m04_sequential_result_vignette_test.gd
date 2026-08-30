# M04만 결과를 네 개의 원인별 순차 후일담으로 표시하는지 검증한다.
extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")
const M04_EPISODE_PATH := "res://data/episodes/episode_002_red_umbrella_alley.json"
const M04_ID := "episode_002_red_umbrella_alley"

var _guard := TestSaveGuard.new()
var _game_state: Node
var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_game_state = root.get_node_or_null("GameState")
	if _game_state == null:
		_failures.append("GameState autoload is unavailable")
		_finish()
		return
	var guard_error := _guard.prepare(_game_state.get_save_file_path())
	if not guard_error.is_empty():
		_failures.append(guard_error)
		_finish()
		return

	_game_state.reset_run_state()
	_expect(_game_state.load_episode(M04_EPISODE_PATH), "M04 case data loads for the sequential-result path")
	_game_state.set_selected_agent_ids(["agent_kwon_narae"])
	_expect(_game_state.set_campaign_planned_case(M04_ID), "M04 is planned for the sequential-result path")
	_expect(_game_state.begin_campaign_operation(M04_ID), "M04 operation begins before recovery")
	_game_state.mark_agent_support_used("support_kwon_return_route")
	_game_state.save_recovery_result(true, "core_recovered", 100)
	_expect(change_scene_to_file("res://scenes/result_scene.tscn") == OK, "M04 result scene loads")
	for _frame in range(3):
		await process_frame

	var root_panel := current_scene.get_node_or_null("M04NarrativeResult") as Control
	_expect(root_panel != null, "M04 result uses its dedicated sequential narrative surface")
	var progress := current_scene.get_node_or_null("M04NarrativeResult/PageProgress") as Label
	var title := current_scene.get_node_or_null("M04NarrativeResult/VignetteTitle") as Label
	var body := current_scene.get_node_or_null("M04NarrativeResult/VignetteBody") as Label
	var reasoning_summary := current_scene.get_node_or_null("M04NarrativeResult/ReasoningSummary") as Label
	var continue_button := current_scene.get_node_or_null("M04NarrativeResult/ContinueButton") as Button
	_expect(progress != null and progress.text == "1 / 4", "M04 begins at the first causal page")
	_expect(title != null and title.text == "피해자", "M04 first page is the victim result")
	_expect(reasoning_summary != null and reasoning_summary.text.contains("이번 판단의 근거"), "M04 keeps the reasoning summary on its narrative result surface")
	_expect(continue_button != null and continue_button.text == "다음 기록", "M04 exposes one explicit next-record input")
	if continue_button != null:
		continue_button.emit_signal("pressed")
		await process_frame
	_expect(progress != null and progress.text == "2 / 4", "next input advances exactly one page")
	_expect(title != null and title.text == "잔향", "M04 second page is the resonance result")
	if continue_button != null:
		continue_button.emit_signal("pressed")
		await process_frame
	_expect(progress != null and progress.text == "3 / 4", "M04 reaches the route-memory page in order")
	_expect(title != null and title.text == "귀가 기억", "M04 third page explains the dispatch context")
	_expect(body != null and body.text.contains("조기 해결") and body.text.contains("귀가 기억 고정"), "route-memory page uses actual timing and Kwon support facts")
	if continue_button != null:
		continue_button.emit_signal("pressed")
		await process_frame
	_expect(progress != null and progress.text == "4 / 4", "M04 reaches the case-record page last")
	_expect(title != null and title.text == "기록국", "M04 final page is the bureau record")
	_expect(continue_button != null and not continue_button.visible, "last M04 page does not create a fifth narrative page")
	await _validate_m04_without_dispatch_context_uses_legacy_result_surface()

	var restore_error := _guard.restore()
	if not restore_error.is_empty():
		_failures.append(restore_error)
	_finish()


func _validate_m04_without_dispatch_context_uses_legacy_result_surface() -> void:
	_game_state.reset_run_state()
	_expect(_game_state.load_episode(M04_EPISODE_PATH), "M04 can load without a campaign operation for compatibility coverage")
	_game_state.save_recovery_result(true, "core_recovered", 100)
	_expect(change_scene_to_file("res://scenes/result_scene.tscn") == OK, "legacy-context M04 result scene loads")
	for _frame in range(3):
		await process_frame
	_expect(current_scene.get_node_or_null("M04NarrativeResult") == null, "M04 without a recorded dispatch context keeps the existing result surface")
	_expect(current_scene.find_child("ReasoningSummary", true, false) != null, "legacy-context M04 keeps the existing reasoning summary surface")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("M04 SEQUENTIAL RESULT VIGNETTE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
