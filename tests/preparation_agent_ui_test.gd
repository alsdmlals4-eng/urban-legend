# 준비 화면이 요원 카드 신호를 기존 GameState 선택 흐름에 연결하는지 검증한다.
extends SceneTree

const AgentSelectionCardScript = preload("res://scripts/ui/agent_selection_card.gd")
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
	game_state.load_episode("res://data/episodes/episode_001_afterlife_station.json")
	game_state.set_selected_agent_ids(["agent_kang_ijun", "agent_kwon_narae"])
	if change_scene_to_file("res://scenes/preparation_scene.tscn") != OK:
		_fail("preparation scene failed to load")
		return
	for _frame in range(5):
		await process_frame

	var agent_list := current_scene.find_child("AgentList", true, false)
	var detail_panel := current_scene.find_child("AgentDetailPanel", true, false) as PanelContainer
	if agent_list == null or detail_panel == null:
		_fail("agent UI does not expose inspectable list and detail nodes")
		return

	var cards := _get_cards(agent_list)
	if cards.size() != game_state.get_agents().size():
		_fail("agent list did not create one card per agent")
		return

	var selected_card: Control
	for card in cards:
		var button := card.get_node("%SelectionButton") as Button
		var name_label := card.get_node("%NameLabel") as Label
		if button.text == "해제" and name_label.text.contains("강이준"):
			selected_card = card
			break
	if selected_card == null:
		_fail("expected one selected agent card")
		return

	(selected_card.get_node("%DetailButton") as Button).pressed.emit()
	await process_frame
	if not detail_panel.visible:
		_fail("detail request did not open the existing detail panel")
		return

	(selected_card.get_node("%SelectionButton") as Button).pressed.emit()
	await process_frame
	await process_frame
	if game_state.get_selected_agent_ids().size() != 1:
		_fail("deselection request was not handled by the preparation scene")
		return

	cards = _get_cards(agent_list)
	var deselected_card: Control
	for card in cards:
		var name_label := card.get_node("%NameLabel") as Label
		if name_label.text.contains("강이준"):
			deselected_card = card
			break
	if deselected_card == null:
		_fail("refreshed agent card was not found")
		return
	(deselected_card.get_node("%SelectionButton") as Button).pressed.emit()
	await process_frame
	await process_frame
	if game_state.get_selected_agent_ids().size() != 2:
		_fail("selection request was not handled by the preparation scene")
		return

	var restore_error := _guard.restore()
	_guard_prepared = false
	if not restore_error.is_empty():
		_fail(restore_error)
		return
	print("preparation_agent_ui_test: PASS")
	quit(0)


func _get_cards(agent_list: Node) -> Array[Node]:
	var cards: Array[Node] = []
	for child in agent_list.get_children():
		if child.get_script() == AgentSelectionCardScript:
			cards.append(child)
	return cards


func _fail(message: String) -> void:
	if _guard_prepared:
		_guard.restore()
		_guard_prepared = false
	push_error(message)
	quit(1)
