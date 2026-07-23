extends SceneTree

const HINT_ID := "preparation_secondary_tools_opened"

var _failed := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_game_state().reset_campaign_state()
	_game_state().clear_seen_hint_ids()
	var scene: Node = load("res://scenes/preparation_scene.tscn").instantiate()
	root.add_child(scene)
	await process_frame
	await process_frame
	var tabs := scene.find_child("PreparationTabs", true, false) as TabContainer
	var reveal := scene.find_child("SecondaryToolsButton", true, false) as Button
	_expect(tabs != null, "준비 탭이 존재한다")
	_expect(reveal != null and reveal.visible, "신규 상태에서 보조 준비 도구 버튼이 보인다")
	_expect(_tab_hidden(tabs, "장비"), "신규 상태에서 장비 탭이 접힌다")
	_expect(_tab_hidden(tabs, "외부 접점"), "신규 상태에서 외부 접점 탭이 접힌다")
	_expect(_tab_hidden(tabs, "기록"), "신규 상태에서 기록 탭이 접힌다")
	_expect(not _tab_hidden(tabs, "사건"), "사건 탭은 항상 보인다")
	_expect(not _tab_hidden(tabs, "편성"), "편성 탭은 항상 보인다")
	reveal.pressed.emit()
	await process_frame
	_expect(_game_state().has_seen_hint(HINT_ID), "공개 선택이 기존 힌트 저장에 기록된다")
	_expect(not _tab_hidden(tabs, "장비"), "공개 후 장비 탭이 복원된다")
	_expect(not _tab_hidden(tabs, "외부 접점"), "공개 후 외부 접점 탭이 복원된다")
	_expect(not _tab_hidden(tabs, "기록"), "공개 후 기록 탭이 복원된다")
	_expect(not reveal.visible, "공개 후 버튼은 사라진다")
	scene.queue_free()
	await process_frame
	if _failed == 0:
		print("PROGRESSIVE DISCLOSURE PREPARATION: PASS")
	quit(_failed)


func _tab_hidden(tabs: TabContainer, title: String) -> bool:
	for index in range(tabs.get_tab_count()):
		if tabs.get_tab_title(index) == title:
			return tabs.is_tab_hidden(index)
	return true


func _expect(condition: bool, message: String) -> void:
	if condition:
		print("PASS: %s" % message)
	else:
		_failed += 1
		push_error("FAIL: %s" % message)


func _game_state() -> Node:
	return root.get_node("GameState")
