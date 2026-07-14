# 준비 화면이 현재 반일 일정만 순차적으로 노출하는지 검증한다.
extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")

var _guard := TestSaveGuard.new()
var _guard_prepared := false


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node("GameState")
	var guard_error := _guard.prepare(game_state.SAVE_FILE_PATH)
	if not guard_error.is_empty():
		_fail(guard_error)
		return
	_guard_prepared = true
	game_state.reset_run_state()
	if change_scene_to_file("res://scenes/preparation_scene.tscn") != OK:
		_fail("preparation scene failed to load")
		return
	for _frame in range(5):
		await process_frame

	var day_label := current_scene.find_child("CampaignDayLabel", true, false) as Label
	var schedule_list := current_scene.find_child("ScheduleList", true, false) as VBoxContainer
	if day_label == null or schedule_list == null:
		_fail("campaign day and schedule nodes are missing")
		return
	if not day_label.text.contains("1일차") or not day_label.text.contains("10일"):
		_fail("campaign day label does not explain the demo deadline")
		return

	var options := schedule_list.find_children("*", "OptionButton", true, false)
	if options.size() != game_state.get_agents().size():
		_fail("each agent must expose only the current half-day assignment control")
		return

	var first_agent: Dictionary = game_state.get_agents()[0]
	var agent_id := String(first_agent.get("id", ""))
	(options[0] as OptionButton).item_selected.emit(_find_metadata_index(options[0], "rest"))
	await process_frame
	var schedule: Dictionary = game_state.get_campaign_agent_schedule(agent_id)
	if String(schedule.get("morning", "")) != "rest" or schedule.has("afternoon"):
		_fail("schedule UI did not persist only the morning assignment")
		return

	var restore_error := _guard.restore()
	_guard_prepared = false
	if not restore_error.is_empty():
		_fail(restore_error)
		return
	print("preparation_schedule_ui_test: PASS")
	quit(0)


func _find_metadata_index(picker: OptionButton, expected: String) -> int:
	for index in range(picker.item_count):
		if String(picker.get_item_metadata(index)) == expected:
			return index
	return -1


func _fail(message: String) -> void:
	if _guard_prepared:
		_guard.restore()
		_guard_prepared = false
	push_error(message)
	quit(1)
