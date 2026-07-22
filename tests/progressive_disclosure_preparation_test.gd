# 첫 사건 준비에서 핵심 탭만 먼저 보이고 보조 시스템을 명시적으로 펼칠 수 있는지 검증한다.
extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")
const SECONDARY_TOOLS_HINT_ID := "preparation_secondary_tools_opened"

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

	var tabs := current_scene.find_child("PreparationTabs", true, false) as TabContainer
	var dashboard := current_scene.find_child("ProtagonistDashboard", true, false) as Control
	var reveal_button := current_scene.find_child("RevealSecondaryToolsButton", true, false) as Button
	var external_button := current_scene.find_child("ExternalRequestButton", true, false) as Button
	if tabs == null or dashboard == null or reveal_button == null or external_button == null:
		_fail("progressive disclosure controls are missing")
		return
	if tabs.get_tab_count() != 5:
		_fail("preparation tab contract changed unexpectedly")
		return
	if tabs.is_tab_hidden(0) or tabs.is_tab_hidden(1):
		_fail("case and formation tabs must always remain visible")
		return
	for tab_index in range(2, tabs.get_tab_count()):
		if not tabs.is_tab_hidden(tab_index):
			_fail("secondary preparation tabs must start collapsed before the first case")
			return
	if not reveal_button.visible or external_button.visible:
		_fail("collapsed state must show the reveal action instead of the external request shortcut")
		return
	var viewport_height := float(root.get_viewport().get_visible_rect().size.y)
	if dashboard.position.y + dashboard.size.y > viewport_height or tabs.position.y + tabs.size.y > viewport_height:
		_fail("preparation layout exceeds the visible viewport")
		return

	reveal_button.pressed.emit()
	await process_frame
	for tab_index in range(2, tabs.get_tab_count()):
		if tabs.is_tab_hidden(tab_index):
			_fail("revealing secondary tools did not restore every existing tab")
			return
	if not external_button.visible or reveal_button.visible:
		_fail("revealed state did not restore the external request shortcut")
		return
	if not game_state.has_seen_hint(SECONDARY_TOOLS_HINT_ID):
		_fail("secondary tool reveal was not persisted through the existing hint state")
		return

	if change_scene_to_file("res://scenes/preparation_scene.tscn") != OK:
		_fail("preparation scene failed to reload")
		return
	for _frame in range(5):
		await process_frame
	tabs = current_scene.find_child("PreparationTabs", true, false) as TabContainer
	if tabs == null:
		_fail("reloaded preparation tabs are missing")
		return
	for tab_index in range(2, tabs.get_tab_count()):
		if tabs.is_tab_hidden(tab_index):
			_fail("explicitly revealed tools must remain available on later visits")
			return

	var restore_error := _guard.restore()
	_guard_prepared = false
	if not restore_error.is_empty():
		_fail(restore_error)
		return
	print("progressive_disclosure_preparation_test: PASS")
	quit(0)


func _fail(message: String) -> void:
	if _guard_prepared:
		_guard.restore()
		_guard_prepared = false
	push_error(message)
	quit(1)
