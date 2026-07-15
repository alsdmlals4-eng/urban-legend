# 장면 중심 조사·회수 UI의 공용 컴포넌트와 안정 노드 계약을 검증한다.
extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")

const ACTION_CARD_PATH := "res://scenes/ui/action_choice_card.tscn"
const TEAM_CHIP_PATH := "res://scenes/ui/team_status_chip.tscn"

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

	if not await _test_action_card():
		return
	if not await _test_team_chip():
		return
	if not await _test_scene_contract("res://scenes/investigation_scene.tscn", [
		"CinematicStage", "TeamHud", "RecordButton", "DialogueDock",
		"PointMethodDock", "PointScroll", "MethodScroll", "ResultToast",
		"AgentReactionBox", "ReturnHqButton", "LogUtilityButton", "SettingsButton"
	]):
		return
	if current_scene.find_child("UtilityLabel", true, false) != null:
		_fail("inert LOG/AUTO/SKIP/settings label must be removed")
		return
	var record_drawer := current_scene.get_node("%RecordDrawer") as Control
	(current_scene.get_node("%LogUtilityButton") as Button).pressed.emit()
	if not record_drawer.visible:
		_fail("LOG utility button must open the record drawer")
		return
	(current_scene.get_node("%SettingsButton") as Button).pressed.emit()
	var settings_dialog := current_scene.find_child("@AcceptDialog@*", true, false)
	if settings_dialog == null:
		for child in current_scene.get_children():
			if child is AcceptDialog:
				settings_dialog = child
				break
	if settings_dialog == null or not (settings_dialog as AcceptDialog).visible:
		_fail("settings utility button must open the accessibility dialog")
		return
	(settings_dialog as AcceptDialog).hide()
	if not _test_situation_choice_presentation():
		return
	var dialogue_dock := current_scene.get_node("%DialogueDock") as Control
	var workspace_width := (current_scene.find_child("Workspace", true, false) as Control).size.x
	var dialogue_ratio := dialogue_dock.size.x / maxf(1.0, workspace_width)
	if dialogue_ratio < 0.38 or dialogue_ratio > 0.48:
		_fail("afterlife field record column must keep the approved compact middle-column ratio")
		return
	if not await _test_method_picker():
		return
	if not _test_investigation_decision_context():
		return
	if not await _test_scene_contract("res://scenes/battle_scene.tscn", [
		"CinematicStage", "RecoveryHud", "RepresentativeVisual", "AnomalyVisual",
		"ClueDrawer", "ActionDock", "ResponseGrid", "RepresentativeSwitchButton"
	]):
		return
	if not _test_recovery_decision_context():
		return

	var restore_error := _guard.restore()
	_guard_prepared = false
	if not restore_error.is_empty():
		_fail(restore_error)
		return
	print("cinematic_ui_redesign_test: PASS")
	quit(0)


func _test_action_card() -> bool:
	if not ResourceLoader.exists(ACTION_CARD_PATH):
		_fail("action choice card scene is missing")
		return false
	var card := (load(ACTION_CARD_PATH) as PackedScene).instantiate()
	root.add_child(card)
	var requests: Array[String] = []
	card.action_requested.connect(func(action_id: String) -> void: requests.append(action_id))
	if not card.configure({
		"id": "inspect_signal",
		"title": "기록 신호를 분석한다",
		"description": "긴 한국어 설명도 카드 안에서 자연스럽게 여러 줄로 표시합니다.",
		"meta": "분석 · 난이도 6",
		"enabled": true,
		"critical": false
	}):
		_fail("valid action card data was rejected")
		return false
	var button := card.get_node("%ActionButton") as Button
	if button.text != "기록 신호를 분석한다" or button.disabled:
		_fail("action card did not render its title and enabled state")
		return false
	(button as Button).pressed.emit()
	if requests != ["inspect_signal"]:
		_fail("action card did not emit its action id")
		return false
	if card.configure({"id": ""}):
		_fail("action card accepted an empty id")
		return false
	card.queue_free()
	return true


func _test_team_chip() -> bool:
	if not ResourceLoader.exists(TEAM_CHIP_PATH):
		_fail("team status chip scene is missing")
		return false
	var chip := (load(TEAM_CHIP_PATH) as PackedScene).instantiate()
	root.add_child(chip)
	if not chip.configure({"id": "agent_test", "name": "긴 이름의 현장 분석 요원"}, {
		"hp": 72, "max_hp": 90, "mental": 61, "max_mental": 80,
		"active": true, "representative": true
	}):
		_fail("valid team chip data was rejected")
		return false
	if not (chip.get_node("%RepresentativeBadge") as Label).visible:
		_fail("representative badge is not visible")
		return false
	if not (chip.get_node("%NameLabel") as Label).text.contains("현장 분석 요원"):
		_fail("team chip did not render the agent name")
		return false
	chip.queue_free()
	return true


func _test_scene_contract(scene_path: String, required_nodes: Array[String]) -> bool:
	if change_scene_to_file(scene_path) != OK:
		_fail("scene failed to load: %s" % scene_path)
		return false
	for _frame in range(5):
		await process_frame
	if current_scene.get_script() == null:
		_fail("scene script failed to load: %s" % scene_path)
		return false
	for node_name in required_nodes:
		if current_scene.find_child(node_name, true, false) == null:
			_fail("%s is missing stable node %s" % [scene_path, node_name])
			return false
	if current_scene is ScrollContainer:
		_fail("scene root must not be a ScrollContainer: %s" % scene_path)
		return false
	return true


func _test_investigation_decision_context() -> bool:
	var context_text := String(current_scene.call("_make_method_result_text", {
		"result_text": "현장 기록이 시간을 가리킵니다.",
		"method_label": "시간표를 대조한다",
		"successful": true,
		"result_grade": "success",
		"player_stat": 3,
		"helper_agent_name": "강이준",
		"helper_stat": 4,
		"total": 7,
		"difficulty": 5,
		"chance": 70,
		"dice": 42,
		"new_clue_ids": [],
		"hint_texts": [],
		"case_status": {}
	}))
	if not (context_text.contains("현재 상황") and context_text.contains("확보 근거") and context_text.contains("추론 방향") and context_text.contains("다음 판단")):
		_fail("investigation result must separate situation, evidence, inference direction, and next decision")
		return false
	return true


func _test_recovery_decision_context() -> bool:
	var evidence_text := String(current_scene.call("_make_recovery_evidence_text"))
	if not (evidence_text.contains("전조") and evidence_text.contains("연결 단서") and evidence_text.contains("오대응 학습") and evidence_text.contains("다음 판단")):
		_fail("recovery evidence must separate telegraph, linked clues, learning, and next decision")
		return false
	return true


func _test_method_picker() -> bool:
	var points: Array = current_scene.call("_get_investigation_points")
	for point in points:
		if typeof(point) == TYPE_DICTIONARY and not Array(point.get("method_options", [])).is_empty():
			current_scene.call("_show_method_options", point)
			for _frame in range(2):
				await process_frame
			var points_box := current_scene.get_node("%PointsBox") as Control
			var method_box := current_scene.get_node("%MethodButtonBox") as Control
			if not points_box.visible or points_box.get_child_count() == 0 or method_box.get_child_count() < 2:
				_fail("method picker must show both point and method cards")
				return false
			return true
	_fail("episode fixture has no method picker point")
	return false


func _test_situation_choice_presentation() -> bool:
	var agent_stage := current_scene.get_node("%AgentStage") as Control
	var situation_label := current_scene.get_node("%FieldDialogueLabel") as Label
	var choice_scroll := current_scene.get_node("%FieldChoiceScroll") as Control
	var next_button := current_scene.get_node("%FieldNextButton") as Button
	var reaction_box := current_scene.get_node("%AgentReactionBox") as Control
	if agent_stage.visible:
		_fail("investigation must not keep full-body agent standees visible")
		return false
	if not situation_label.visible or situation_label.text.strip_edges().is_empty():
		_fail("investigation must show a situation description")
		return false
	if not choice_scroll.visible or next_button.visible:
		_fail("situation and choices must be visible without a dialogue advance step")
		return false
	if reaction_box.visible or reaction_box.get_child_count() != 0:
		_fail("the lightweight investigation layout must not render agent dialogue rows")
		return false
	return true


func _fail(message: String) -> void:
	if _guard_prepared:
		_guard.restore()
		_guard_prepared = false
	push_error(message)
	quit(1)
