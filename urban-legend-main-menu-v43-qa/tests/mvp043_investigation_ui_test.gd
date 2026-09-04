# MVP-043 저승역 조사 UI가 지원 해상도에서 화면 안에 남고 교착되지 않는지 검증한다.
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
	game_state.set_current_field_node_id("field_station_investigation")
	if change_scene_to_file(game_state.SCENE_INVESTIGATION) != OK:
		_failures.append("investigation scene failed to load")
		_finish()
		return
	for _frame in range(5):
		await process_frame

	for viewport_size in [Vector2i(1280, 720), Vector2i(1920, 1080), Vector2i(1918, 943)]:
		root.size = viewport_size
		for _frame in range(3):
			await process_frame
		_verify_layout(current_scene, viewport_size)

	var field_choice_box := current_scene.find_child("FieldChoiceBox", true, false) as Container
	_expect(field_choice_box != null and field_choice_box.get_child_count() == 0, "POINT_PICKER must not duplicate the left location list in the center")
	var team_button := current_scene.find_child("TeamStatusButton", true, false) as Button
	_expect(team_button != null, "afterlife investigation should expose the shared team status button")
	if team_button != null:
		team_button.emit_signal("pressed")
		await process_frame
		var popover := current_scene.find_child("TeamStatusPopover", true, false) as Control
		_expect(popover != null and popover.visible, "team status should open a popover")
		if popover != null:
			var member_list := popover.find_child("MemberList", true, false) as Container
			_expect(member_list != null and member_list.get_child_count() == maxi(1, game_state.get_selected_agents().size()), "team status should list every deployed protagonist/support or an explicit empty state")
			popover.call("close")
	_expect(not _visible_text_contains(current_scene, "LOG") and not _visible_text_contains(current_scene, "로그"), "player-facing investigation UI should use Aka instead of LOG/log")

	var return_field_button := current_scene.find_child("ReturnFieldButton", true, false) as Button
	_expect(return_field_button != null and return_field_button.visible, "afterlife point picker should always offer a return path")
	if return_field_button != null:
		return_field_button.emit_signal("pressed")
		await process_frame
		_expect(game_state.get_current_field_node_id() == "dialogue_intro", "returning should reopen the first investigation choice")
		_expect(game_state.get_collected_clue_count() == 0, "returning should not invent or discard investigation evidence")
	_finish()


func _verify_layout(scene: Node, viewport_size: Vector2i) -> void:
	var viewport_rect := Rect2(Vector2.ZERO, Vector2(viewport_size))
	var top_hud := scene.find_child("TopHud", true, false) as Control
	var point_dock := scene.find_child("PointMethodDock", true, false) as Control
	var dialogue_dock := scene.find_child("DialogueDock", true, false) as Control
	var manual_panel := scene.find_child("ManualPanel", true, false) as Control
	var points_box := scene.find_child("PointsBox", true, false) as Container
	_expect(_inside_viewport(top_hud, viewport_rect), "%s top HUD should fit the viewport" % viewport_size)
	_expect(_inside_viewport(point_dock, viewport_rect), "%s location panel should fit the viewport" % viewport_size)
	_expect(_inside_viewport(dialogue_dock, viewport_rect), "%s narrative panel should fit the viewport" % viewport_size)
	_expect(_inside_viewport(manual_panel, viewport_rect), "%s manual panel should fit the viewport" % viewport_size)
	_expect(point_dock != null and point_dock.visible, "POINT_PICKER should show the location panel")
	_expect(dialogue_dock != null and dialogue_dock.visible, "POINT_PICKER should keep the investigation text visible")
	_expect(manual_panel != null and manual_panel.visible, "afterlife investigation should keep the page manual visible")
	_expect(points_box != null and points_box.get_child_count() > 0, "POINT_PICKER should render investigation cards")
	if points_box != null and points_box.get_child_count() > 0:
		var action_button := points_box.get_child(0).find_child("ActionButton", true, false) as Button
		_expect(action_button != null and not action_button.disabled, "the first investigation card should be selectable")
		_expect(action_button != null and action_button.focus_mode != Control.FOCUS_NONE, "investigation cards should support keyboard focus")
		_expect(_inside_viewport(action_button, viewport_rect), "%s first investigation card should be on screen" % viewport_size)


func _inside_viewport(control: Control, viewport_rect: Rect2) -> bool:
	if control == null or not control.is_visible_in_tree():
		return false
	var rect := control.get_global_rect()
	return rect.size.x > 0.0 and rect.size.y > 0.0 and viewport_rect.encloses(rect)


func _visible_text_contains(node: Node, needle: String) -> bool:
	for child in node.find_children("*", "Label", true, false) + node.find_children("*", "Button", true, false):
		if child is Control and (child as Control).is_visible_in_tree() and String(child.get("text")).contains(needle):
			return true
	return false


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
		print("MVP043 INVESTIGATION UI: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
