# M04 조사 화면이 현장 배경을 가리지 않고 기록 패널 아래에 남기는지 검증한다.
extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")
const M01_EPISODE_PATH := "res://data/episodes/episode_001_afterlife_station.json"
const M04_EPISODE_PATH := "res://data/episodes/episode_002_red_umbrella_alley.json"

var _guard := TestSaveGuard.new()
var _prepared := false
var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node("GameState")
	var guard_error := _guard.prepare(game_state.get_save_file_path())
	if not guard_error.is_empty():
		_failures.append(guard_error)
		_finish()
		return
	_prepared = true
	game_state.load_episode(M04_EPISODE_PATH)
	if change_scene_to_file(game_state.SCENE_INVESTIGATION) != OK:
		_failures.append("M04 investigation scene failed to load")
		_finish()
		return
	for _frame in range(5):
		await process_frame
	var shade := current_scene.get_node_or_null("ArtLayer/Shade") as ColorRect
	_expect(shade != null and shade.color.a <= 0.45, "M04 investigation shade must preserve the environment behind the investigation UI")
	for dock_name in ["PointMethodDock", "DialogueDock"]:
		var dock := current_scene.find_child(dock_name, true, false) as PanelContainer
		var panel_style := dock.get_theme_stylebox("panel") if dock != null else null
		_expect(panel_style is StyleBoxFlat and (panel_style as StyleBoxFlat).bg_color.a <= 0.82, "%s must remain translucent for M04 environmental evidence" % dock_name)
	game_state.load_episode(M01_EPISODE_PATH)
	if change_scene_to_file(game_state.SCENE_INVESTIGATION) != OK:
		_failures.append("M01 investigation scene failed to load")
		_finish()
		return
	for _frame in range(5):
		await process_frame
	var m01_shade := current_scene.get_node_or_null("ArtLayer/Shade") as ColorRect
	_expect(m01_shade != null and is_equal_approx(m01_shade.color.a, 0.72), "M01 investigation shade must retain the existing dossier treatment")
	for dock_name in ["PointMethodDock", "DialogueDock"]:
		var dock := current_scene.find_child(dock_name, true, false) as PanelContainer
		var panel_style := dock.get_theme_stylebox("panel") if dock != null else null
		_expect(panel_style is StyleBoxFlat and (panel_style as StyleBoxFlat).bg_color.a >= 0.94, "%s must retain the existing M01 dossier opacity" % dock_name)
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
		print("M04 INVESTIGATION BACKGROUND READABILITY: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
