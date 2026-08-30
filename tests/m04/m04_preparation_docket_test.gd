# 준비실이 한 cycle 한 메인 사건의 배정 상태를 플레이어에게 설명하는지 검증한다.
extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")
const M04_ID := "episode_002_red_umbrella_alley"

var _guard := TestSaveGuard.new()
var _prepared := false
var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node_or_null("GameState")
	if game_state == null:
		_failures.append("GameState autoload is unavailable")
		_finish()
		return
	var guard_error := _guard.prepare(game_state.get_save_file_path())
	if not guard_error.is_empty():
		_failures.append(guard_error)
		_finish()
		return
	_prepared = true
	game_state.reset_run_state()
	_expect(game_state.load_episode("res://data/episodes/episode_002_red_umbrella_alley.json"), "M04 episode data loads for the active docket")
	game_state.set_selected_agent_ids([game_state.get_protagonist_agent_id()])
	_expect(game_state.set_campaign_planned_case(M04_ID), "M04 can be planned before the cycle begins")
	_expect(game_state.begin_campaign_operation(M04_ID), "M04 first dispatch locks the cycle")
	_expect(game_state.complete_campaign_slot({"kind": "investigation", "episode_id": M04_ID}), "M04 operation reaches its result state")
	_expect(bool(game_state.acknowledge_campaign_slot_result().get("advanced", false)), "M04 result returns to preparation")
	_expect(change_scene_to_file(game_state.SCENE_PREPARATION) == OK, "Preparation scene loads after the M04 dispatch")
	for _frame in range(6):
		await process_frame
	var day_label := current_scene.find_child("CampaignDayLabel", true, false) as Label
	_expect(day_label != null and day_label.text.contains("이번 10일 cycle 메인 사건"), "Preparation explains the one-main-case rule")
	_expect(day_label != null and day_label.text.contains("비 오는 골목의 빨간 우산"), "Preparation names the active M04 docket")
	_expect(day_label != null and day_label.text.contains("현장 준비 0/1"), "Preparation shows the current M04 preparation capacity before the next dispatch")
	_expect(day_label != null and day_label.text.contains("귀가 기억 고정"), "Preparation explains what the M04 capacity controls without implying a stat bonus")
	var waiting_button := _find_button("저승역")
	_expect(waiting_button != null and waiting_button.disabled and waiting_button.text.contains("다음 cycle 대기"), "Preparation disables another main case with a next-cycle explanation")
	_finish()


func _find_button(title_fragment: String) -> Button:
	for node in current_scene.find_children("*", "Button", true, false):
		var button := node as Button
		if button != null and button.text.contains(title_fragment):
			return button
	return null


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
		print("M04 PREPARATION DOCKET: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
