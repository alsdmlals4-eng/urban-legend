# 저승역 코어 검증 1B의 가설 → 근거 → 대응 흐름과 비대상 사건 폴백을 검증한다.
extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")
const AFTERLIFE_PATH := "res://data/episodes/episode_001_afterlife_station.json"
const RED_UMBRELLA_PATH := "res://data/episodes/episode_002_red_umbrella_alley.json"
const TEAM := ["agent_kang_ijun", "agent_kwon_narae", "agent_oh_hyun"]

var _guard := TestSaveGuard.new()
var _failures: Array[String] = []
var _game_state: Node


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_game_state = root.get_node_or_null("GameState")
	if _game_state == null:
		_failures.append("GameState autoload is unavailable")
		_finish()
		return
	var guard_error := _guard.prepare(_game_state.get_save_file_path())
	if not guard_error.is_empty():
		_failures.append(guard_error)
		_finish()
		return
	await _test_afterlife_guided_flow()
	await _test_non_target_direct_fallback()
	_finish()


func _test_afterlife_guided_flow() -> void:
	_game_state.reset_run_state()
	_expect(_game_state.load_episode(AFTERLIFE_PATH), "afterlife station loads")
	_game_state.set_selected_agent_ids(TEAM)
	_expect(_game_state.set_clue_collected("clue_repeating_announcement", true), "first linked clue is collected")
	_expect(_game_state.set_clue_collected("clue_missing_terminal_sign", true), "second linked clue is collected")
	if change_scene_to_file(_game_state.SCENE_BATTLE) != OK:
		_failures.append("guided recovery scene failed to load")
		return
	for _frame in range(6):
		await process_frame
	var battle := current_scene
	var pattern: Dictionary = battle.get("_current_pattern")
	_expect(not pattern.is_empty(), "guided recovery exposes a pattern")
	_expect(bool(battle.call("_uses_guided_decision_flow")), "afterlife overlay enables guided decision flow")
	_expect(int(battle.get("_decision_step")) == 1, "guided flow starts at hypothesis step")
	var progress := battle.find_child("DecisionProgressLabel", true, false) as Label
	var instruction := battle.find_child("DecisionInstructionLabel", true, false) as Label
	_expect(progress != null and progress.text.contains("1 가설"), "hypothesis step is visibly numbered")
	_expect(instruction != null and instruction.text == String(pattern.get("question", "")), "neutral authored question is visible")
	_expect(_action_card_count(battle) == Array(pattern.get("responses", [])).size(), "one hypothesis card is shown per response")
	_expect(not _visible_meta_contains_agent_or_score(battle), "hypothesis cards do not expose best-agent scores")
	_expect(_hypothesis_tooltips_are_neutral(battle, pattern), "hypothesis tooltips do not reveal supporting or contradicted evidence")
	_expect(root.gui_get_focus_owner() is Button, "keyboard focus enters the first hypothesis card")

	var correct_response := _find_response(pattern, String(pattern.get("correct_response_id", "")))
	_expect(not correct_response.is_empty(), "correct response fixture exists")
	battle.call("_select_hypothesis", correct_response)
	await process_frame
	_expect(int(battle.get("_decision_step")) == 2, "hypothesis selection advances to evidence")
	var cancel_event := InputEventAction.new()
	cancel_event.action = "ui_cancel"
	cancel_event.pressed = true
	battle.call("_unhandled_input", cancel_event)
	await process_frame
	_expect(int(battle.get("_decision_step")) == 1, "Esc returns from evidence to hypothesis")
	battle.call("_select_hypothesis", correct_response)
	await process_frame
	var confirm := battle.find_child("DecisionConfirmButton", true, false) as Button
	_expect(confirm != null and confirm.visible and confirm.disabled, "evidence confirmation waits for a selected record")
	battle.call("_toggle_evidence", "clue_repeating_announcement")
	await process_frame
	_expect(not confirm.disabled, "selecting a collected record enables confirmation")
	battle.call("_confirm_evidence_step")
	await process_frame
	_expect(int(battle.get("_decision_step")) == 3, "evidence confirmation advances to response")
	battle.call("_unhandled_input", cancel_event)
	await process_frame
	_expect(int(battle.get("_decision_step")) == 2, "Esc returns from response to evidence without losing the selected record")
	_expect(Array(battle.get("_selected_evidence_ids")).has("clue_repeating_announcement"), "back navigation preserves selected evidence")
	battle.call("_confirm_evidence_step")
	await process_frame
	_expect(_response_meta_is_non_numeric(battle), "response cards show execution role without ability scores or hypothesis-match answers")
	_expect(_response_tooltips_are_neutral(battle, pattern), "response tooltips do not reveal authored reasoning before selection")
	var partial_evaluation: Dictionary = battle.call("_evaluate_guided_decision", correct_response, true)
	_expect(not bool(partial_evaluation.get("verified", true)), "one of two authored supports remains provisional")
	_expect(String(partial_evaluation.get("verification_label", "")).contains("근거 일부"), "partial support is labelled without weakening the correct field response")
	battle.call("_unhandled_input", cancel_event)
	await process_frame
	battle.call("_toggle_evidence", "clue_missing_terminal_sign")
	await process_frame
	battle.call("_confirm_evidence_step")
	await process_frame
	var evaluation: Dictionary = battle.call("_evaluate_guided_decision", correct_response, true)
	_expect(bool(evaluation.get("verified", false)), "matching hypothesis, every authored support, and response verify the manual candidate")
	battle.call("_select_pattern_response", correct_response)
	await process_frame
	var learning_value: Variant = _game_state.get_recovery_pattern_learning().get(String(pattern.get("id", "")), {})
	var learning: Dictionary = learning_value if typeof(learning_value) == TYPE_DICTIONARY else {}
	_expect(bool(learning.get("correct", false)), "correct response remains correct")
	_expect(String(learning.get("reason", "")).contains("검증 완료"), "verified reasoning is preserved in the existing learning record")
	var manual: Dictionary = _game_state.get_current_anomaly_manual_record()
	_expect(Dictionary(manual.get("verified_rules", {})).has(String(pattern.get("id", ""))), "verified guided decision is promoted to the persistent anomaly manual")
	_expect(Array(manual.get("danger_cases", [])).is_empty(), "verified path does not create a danger case")


func _test_non_target_direct_fallback() -> void:
	_game_state.reset_run_state()
	_expect(_game_state.load_episode(RED_UMBRELLA_PATH), "non-target episode loads")
	_game_state.set_selected_agent_ids(TEAM)
	if change_scene_to_file(_game_state.SCENE_BATTLE) != OK:
		_failures.append("fallback recovery scene failed to load")
		return
	for _frame in range(6):
		await process_frame
	var battle := current_scene
	_expect(not bool(battle.call("_uses_guided_decision_flow")), "non-target episode does not require missing hypothesis data")
	_expect(int(battle.get("_decision_step")) == 0, "non-target episode keeps direct response flow")
	var pattern: Dictionary = battle.get("_current_pattern")
	_expect(_action_card_count(battle) == Array(pattern.get("responses", [])).size(), "direct fallback keeps all authored responses")


func _find_response(pattern: Dictionary, response_id: String) -> Dictionary:
	for response_value in pattern.get("responses", []):
		if typeof(response_value) == TYPE_DICTIONARY and String(response_value.get("id", "")) == response_id:
			return Dictionary(response_value).duplicate(true)
	return {}


func _action_card_count(node: Node) -> int:
	var count := 0
	for child in node.find_children("*", "ActionChoiceCard", true, false):
		if child.is_visible_in_tree():
			count += 1
	return count


func _visible_meta_contains_agent_or_score(node: Node) -> bool:
	for label_value in node.find_children("MetaLabel", "Label", true, false):
		var label := label_value as Label
		if not label.is_visible_in_tree():
			continue
		if label.text.contains("강이준") or label.text.contains("권나래") or label.text.contains("오현"):
			return true
		for ability in ["분석", "제압", "방호", "치료", "교감"]:
			for digit in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]:
				if label.text.contains("%s %s" % [ability, digit]):
					return true
	return false


func _hypothesis_tooltips_are_neutral(node: Node, pattern: Dictionary) -> bool:
	var forbidden: Array[String] = ["반증 후보", "근거 후보"]
	for response_value in pattern.get("responses", []):
		if typeof(response_value) != TYPE_DICTIONARY:
			continue
		var response: Dictionary = response_value
		forbidden.append(String(response.get("summary", "")))
		forbidden.append(String(response.get("reasoning", "")))
	return _visible_card_tooltips_exclude(node, forbidden)


func _response_tooltips_are_neutral(node: Node, pattern: Dictionary) -> bool:
	var forbidden: Array[String] = []
	for response_value in pattern.get("responses", []):
		if typeof(response_value) != TYPE_DICTIONARY:
			continue
		var response: Dictionary = response_value
		forbidden.append(String(response.get("summary", "")))
		forbidden.append(String(response.get("reasoning", "")))
	return _visible_card_tooltips_exclude(node, forbidden)


func _visible_card_tooltips_exclude(node: Node, forbidden: Array[String]) -> bool:
	for card_value in node.find_children("*", "ActionChoiceCard", true, false):
		var card := card_value as Control
		if not card.is_visible_in_tree():
			continue
		var tooltip := card.tooltip_text.strip_edges()
		if tooltip.is_empty():
			return false
		for text in forbidden:
			var candidate := text.strip_edges()
			if not candidate.is_empty() and tooltip.contains(candidate):
				return false
	return true


func _response_meta_is_non_numeric(node: Node) -> bool:
	for label_value in node.find_children("MetaLabel", "Label", true, false):
		var label := label_value as Label
		if not label.is_visible_in_tree():
			continue
		if not label.text.contains("실행 보조"):
			return false
		if label.text.contains("가설과 일치") or label.text.contains("가설과 불일치"):
			return false
		for digit in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]:
			if label.text.contains(digit):
				return false
	return true


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	var restore_error := _guard.restore()
	if not restore_error.is_empty():
		_failures.append(restore_error)
	if _failures.is_empty():
		print("CORE VALIDATION GUIDED FLOW: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
