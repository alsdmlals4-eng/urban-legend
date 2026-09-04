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
	await _frames(4)
	var daily_list := current_scene.find_child("DailyEpisodeList", true, false) as VBoxContainer
	if daily_list == null:
		_fail("HQ daily episode list is missing")
		return
	var start_button := current_scene.find_child("DailyEpisodeButton_daily_afterlife_sign_blanks", true, false) as Button
	if start_button == null:
		_fail("available afterlife daily episode button is missing")
		return
	start_button.pressed.emit()
	await _frames(4)
	if current_scene.scene_file_path != "res://scenes/daily_episode_scene.tscn":
		_fail("daily episode button did not open the daily scene")
		return
	var choice_box := current_scene.find_child("DailyEpisodeChoices", true, false) as VBoxContainer
	if choice_box == null or choice_box.get_child_count() != 2:
		_fail("daily scene must show exactly two choices")
		return
	var first_choice := current_scene.find_child("DailyChoice_preserve_order", true, false) as Button
	if first_choice == null:
		_fail("daily scene first choice is missing")
		return
	first_choice.pressed.emit()
	await _frames(2)
	var result_box := current_scene.find_child("DailyEpisodeResult", true, false) as VBoxContainer
	if result_box == null or result_box.get_child_count() < 3:
		_fail("daily choice did not reveal immediate result and return action")
		return
	var return_button := current_scene.find_child("ReturnToPreparationButton", true, false) as Button
	if return_button == null:
		_fail("daily result return button is missing")
		return
	return_button.pressed.emit()
	await _frames(4)
	if current_scene.scene_file_path != "res://scenes/preparation_scene.tscn":
		_fail("daily result did not return to HQ preparation")
		return
	if change_scene_to_file("res://scenes/database_view.tscn") != OK:
		_fail("database view failed to load")
		return
	await _frames(3)
	var records_button := _find_button("일상 에피소드 기록")
	if records_button == null:
		_fail("database daily record section is missing")
		return
	records_button.pressed.emit()
	await process_frame
	var detail_title := current_scene.get("_detail_title") as Label
	if detail_title == null or detail_title.text != "일상 에피소드 기록":
		_fail("database did not open daily episode records")
		return
	_finish()


func _find_button(expected_text: String) -> Button:
	for value in current_scene.find_children("*", "Button", true, false):
		var button := value as Button
		if button.text == expected_text:
			return button
	return null


func _frames(count: int) -> void:
	for _index in range(count):
		await process_frame


func _finish() -> void:
	var restore_error := _guard.restore()
	_guard_prepared = false
	if not restore_error.is_empty():
		_fail(restore_error)
		return
	print("daily_episode_ui_test: PASS")
	quit(0)


func _fail(message: String) -> void:
	if _guard_prepared:
		_guard.restore()
		_guard_prepared = false
	push_error(message)
	quit(1)
