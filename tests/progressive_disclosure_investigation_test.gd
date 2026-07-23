extends SceneTree

const AFTERLIFE_PATH := "res://data/episodes/episode_001_afterlife_station.json"

var _failed := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node("GameState")
	game_state.load_episode(AFTERLIFE_PATH)
	var scene: Node = load("res://scenes/investigation_scene.tscn").instantiate()
	root.add_child(scene)
	await process_frame
	await process_frame
	var manual := scene.find_child("ManualPanel", true, false) as Control
	var manual_button := scene.find_child("ManualToggleButton", true, false) as Button
	var record := scene.find_child("RecordDrawer", true, false) as Control
	var record_button := scene.find_child("RecordButton", true, false) as Button
	var dialogue := scene.find_child("DialogueDock", true, false) as Control
	var choices := scene.find_child("FieldChoiceBox", true, false) as Control
	_expect(dialogue != null and dialogue.visible, "현재 관측·대화 영역이 기본 표시된다")
	_expect(choices != null and choices.visible, "현재 선택 영역이 기본 표시된다")
	_expect(manual != null and not manual.visible, "괴이 매뉴얼은 기본 접힘 상태다")
	_expect(record != null and not record.visible, "과거 현장 기록은 기본 접힘 상태다")
	_expect(manual_button != null and manual_button.visible, "매뉴얼 명시적 열기 버튼이 보인다")
	manual_button.pressed.emit()
	await process_frame
	_expect(manual.visible, "매뉴얼 버튼으로 기록을 연다")
	_expect(not record.visible, "매뉴얼을 열 때 현장 기록은 겹치지 않는다")
	record_button.pressed.emit()
	await process_frame
	_expect(record.visible, "현장 기록 버튼으로 보조 기록을 연다")
	_expect(not manual.visible, "현장 기록을 열 때 매뉴얼은 자동으로 닫힌다")
	scene.queue_free()
	await process_frame
	if _failed == 0:
		print("PROGRESSIVE DISCLOSURE INVESTIGATION: PASS")
	quit(_failed)


func _expect(condition: bool, message: String) -> void:
	if condition:
		print("PASS: %s" % message)
	else:
		_failed += 1
		push_error("FAIL: %s" % message)
