extends SceneTree

## Runs the player-facing M04 vertical slice through real scene controls:
## main menu -> preparation schedule -> case choice -> field investigation ->
## authored manual -> recovery. It catches a broken entry route, a disabled
## case button, a missing manual gate, or a recovery scene that cannot open.

const TestSaveGuard := preload("res://tests/test_save_guard.gd")
const M04_EPISODE_ID := "episode_002_red_umbrella_alley"

var _guard := TestSaveGuard.new()
var _prepared := false
var _game_state: Node
var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_game_state = root.get_node_or_null("GameState")
	_expect(_game_state != null, "GameState autoload missing")
	if _game_state == null:
		_finish()
		return
	var guard_error := _guard.prepare(_game_state.get_save_file_path())
	_expect(guard_error.is_empty(), guard_error)
	if not guard_error.is_empty():
		_finish()
		return
	_prepared = true
	if change_scene_to_file("res://scenes/main_menu.tscn") != OK:
		_expect(false, "main menu scene failed to load")
		_finish()
		return
	await _wait_frames(5)

	var m04_entry := current_scene.find_child("M04CampaignEntryButton", true, false) as Button
	_expect(m04_entry != null and not m04_entry.disabled, "main menu must expose an enabled M04 field-record entry")
	if m04_entry == null or m04_entry.disabled:
		_finish()
		return
	m04_entry.pressed.emit()
	await _wait_frames(5)
	_expect(current_scene.scene_file_path == _game_state.SCENE_PREPARATION, "M04 field-record entry must open the real preparation scene")
	if current_scene.scene_file_path != _game_state.SCENE_PREPARATION:
		_finish()
		return

	_expect(await _choose_schedule_activity("rest"), "preparation UI must let the player schedule the initial rest")
	_expect(await _press_current_schedule_action(), "preparation UI must resolve the scheduled rest through its action button")
	await _wait_frames(5)
	_expect(current_scene.scene_file_path == _game_state.SCENE_PREPARATION and _game_state.get_campaign_slot_phase() == "result", "completed rest must show the player its schedule result before advancing")
	_expect(await _press_current_schedule_action(), "preparation UI must let the player acknowledge the completed rest result")
	await _wait_frames(5)
	_expect(current_scene.scene_file_path == _game_state.SCENE_PREPARATION and _game_state.get_campaign_slot_phase() == "planning", "acknowledged rest must return to planning for the next half-day")
	_expect(await _choose_schedule_activity("investigation"), "preparation UI must let the player schedule an investigation")

	var episode_button := _find_enabled_button(current_scene, "빨간 우산")
	_expect(episode_button != null, "M04 must become selectable after the player schedules an investigation")
	if episode_button == null:
		_finish()
		return
	episode_button.pressed.emit()
	await _wait_frames(5)
	_expect(_game_state.get_current_episode_id() == M04_EPISODE_ID, "M04 case selection must load the red-umbrella episode data")
	_expect(await _press_current_schedule_action(), "preparation UI must dispatch the chosen M04 operation")
	await _wait_frames(6)
	_expect(current_scene.scene_file_path == _game_state.SCENE_INVESTIGATION, "M04 dispatch must open the investigation scene")
	if current_scene.scene_file_path != _game_state.SCENE_INVESTIGATION:
		_finish()
		return

	var field_choice_box := current_scene.find_child("FieldChoiceBox", true, false) as Container
	var opening_choice := _find_enabled_button(field_choice_box, "배수구")
	_expect(opening_choice != null, "M04 investigation must expose its opening field choice")
	if opening_choice == null:
		_finish()
		return
	opening_choice.pressed.emit()
	await _wait_frames(2)
	var next_field := current_scene.find_child("FieldNextButton", true, false) as Button
	_expect(next_field != null and next_field.visible, "M04 opening choice must offer the next field transition")
	if next_field == null:
		_finish()
		return
	next_field.pressed.emit()
	await _wait_frames(3)

	_expect(await _collect_clue_through_actual_cards("빗속에 마른", "clue_red_umbrella_fabric", 2), "M04 field cards must let the player earn the umbrella-fabric record")
	_expect(await _collect_clue_through_actual_cards("세 박자마다", "clue_repeating_alley_sign", 2), "M04 field cards must let the player earn the repeating-sign record")
	var recovery_button := current_scene.find_child("ResolutionAttemptButton", true, false) as Button
	_expect(recovery_button != null and recovery_button.disabled, "M04 recovery must stay closed until the player authors the declared manual rule")
	if recovery_button == null:
		_finish()
		return

	var manual_toggle := current_scene.find_child("ManualToggleButton", true, false) as Button
	_expect(manual_toggle != null and manual_toggle.visible, "M04 investigation must expose the scenario-specific Lume manual entry")
	if manual_toggle == null:
		_finish()
		return
	manual_toggle.pressed.emit()
	await _wait_frames(2)
	var workbench := current_scene.find_child("ManualDeductionWorkbench", true, false) as Control
	_expect(workbench != null and workbench.visible, "M04 manual entry must open the authored workbench")
	if workbench == null:
		_finish()
		return
	_expect(await _author_victim_tether_rule(workbench), "M04 workbench must persist a source-gated authored rule from actual controls")
	var close_workbench := workbench.find_child("CloseWorkbenchButton", true, false) as Button
	if close_workbench != null:
		close_workbench.pressed.emit()
	await _wait_frames(2)
	recovery_button = current_scene.find_child("ResolutionAttemptButton", true, false) as Button
	_expect(recovery_button != null and not recovery_button.disabled, "M04 recovery must open after two records and one completed authored rule")
	if recovery_button == null or recovery_button.disabled:
		_finish()
		return
	recovery_button.pressed.emit()
	await _wait_frames(2)
	var enter_recovery := current_scene.find_child("EnterRecoveryButton", true, false) as Button
	_expect(enter_recovery != null and enter_recovery.visible, "M04 resolution confirmation must expose the recovery entry button")
	if enter_recovery == null:
		_finish()
		return
	enter_recovery.pressed.emit()
	await _wait_frames(6)
	_expect(current_scene.scene_file_path == _game_state.SCENE_BATTLE, "M04 authored recovery confirmation must open the real recovery scene")
	_expect(current_scene.find_child("TelegraphLabel", true, false) != null, "M04 recovery scene must render a live anomaly telegraph")
	var overlay := current_scene.get_node_or_null("CanonV2OperationOverlay") as Control
	var clock_cluster := overlay.get_node_or_null("SafeArea/RootLayout/RuleStripPanel/RuleStrip/RecoveryClockCluster") if overlay != null else null
	var stability_clock := clock_cluster.get_node_or_null("StabilityClock") if clock_cluster != null else null
	var danger_clock := clock_cluster.get_node_or_null("DangerClock") if clock_cluster != null else null
	_expect(stability_clock != null and stability_clock.has_method("set_clock"), "M04 recovery must render the live stability clock in its actual overlay")
	_expect(danger_clock != null and danger_clock.has_method("set_clock"), "M04 recovery must render the live danger clock in its actual overlay")
	_expect(current_scene.get_node_or_null("ActionDock/Content/Footer/ManualQuickButton") != null, "M04 recovery must place the manual in the lower-right footer")
	_expect(current_scene.find_child("RepresentativeSwitchButton", true, false) == null, "M04 recovery must keep Kwon Narae as the direct lead")
	_expect(current_scene.find_child("RecoverButton", true, false) == null, "M04 recovery must not expose a separate recover execution button")
	_expect(bool(current_scene.call("_uses_guided_decision_flow")), "M04 recovery must turn the player-authored manual into the shared hypothesis-evidence-response field procedure")
	if not bool(current_scene.call("_uses_guided_decision_flow")):
		_finish()
		return
	for turn_index in range(4):
		if current_scene.scene_file_path == _game_state.SCENE_RESULT:
			break
		_expect(await _complete_current_guided_recovery_turn(current_scene), "M04 recovery turn %d must be completable through visible hypothesis, evidence, and response controls" % (turn_index + 1))
		await _wait_frames(5)
		var clock_state: Dictionary = _game_state.get_recovery_clock_state()
		_expect(int(clock_state.get("danger", 7)) <= 1, "M04 correct field response must offset danger before the next telegraph (turn %d, danger %d)" % [turn_index + 1, int(clock_state.get("danger", 7))])
	_expect(current_scene.scene_file_path == _game_state.SCENE_RESULT, "M04 completed recovery must automatically open the composite result scene")
	_expect(await _advance_m04_narrative_result(), "M04 completed recovery must let the player advance through the four causal result records")
	_finish()


func _choose_schedule_activity(activity_id: String) -> bool:
	var schedule_list := current_scene.find_child("ScheduleList", true, false) as Container
	if schedule_list == null:
		return false
	var options := schedule_list.find_children("*", "OptionButton", true, false)
	if options.size() != 1:
		return false
	var picker := options[0] as OptionButton
	for index in range(picker.item_count):
		if String(picker.get_item_metadata(index)) == activity_id:
			picker.item_selected.emit(index)
			await _wait_frames(2)
			return true
	return false


func _press_current_schedule_action() -> bool:
	var action := _find_enabled_button(current_scene, "현재 일정 실행")
	if action == null:
		action = _find_enabled_button(current_scene, "결과 확인 후 다음 일정으로")
	if action == null:
		return false
	action.pressed.emit()
	await _wait_frames(3)
	return true


func _collect_clue_through_actual_cards(point_text: String, clue_id: String, random_seed: int) -> bool:
	var points_box := current_scene.find_child("PointsBox", true, false) as Container
	var point_button := _find_enabled_button(points_box, point_text)
	if point_button == null:
		return false
	point_button.pressed.emit()
	await _wait_frames(2)
	var method_box := current_scene.find_child("MethodButtonBox", true, false) as Container
	var analysis_button := _find_enabled_button(method_box, "분석한다")
	if analysis_button == null:
		return false
	seed(random_seed)
	analysis_button.pressed.emit()
	await _wait_frames(2)
	if not _game_state.has_collected_clue(clue_id):
		return false
	var next_button := current_scene.find_child("ResultNextButton", true, false) as Button
	if next_button == null:
		return false
	next_button.pressed.emit()
	await _wait_frames(2)
	return true


func _author_victim_tether_rule(workbench: Control) -> bool:
	var page_button := workbench.find_child("Page_rule_m04_victim_tether", true, false) as Button
	if page_button == null:
		return false
	page_button.pressed.emit()
	await _wait_frames(1)
	for placement in [
		{"slot": "Slot_slot_m04_victim_tether_fabric", "candidate": "Candidate_kw_m04_tether_fabric_inner_dry"},
		{"slot": "Slot_slot_m04_victim_tether_sign", "candidate": "Candidate_kw_m04_tether_sign_reverse_route"}
	]:
		var slot := workbench.find_child(String(placement.slot), true, false) as Button
		var candidate := workbench.find_child(String(placement.candidate), true, false) as Button
		if slot == null or candidate == null:
			return false
		slot.pressed.emit()
		candidate.pressed.emit()
		await _wait_frames(2)
	return true


func _complete_current_guided_recovery_turn(recovery_scene: Node) -> bool:
	if recovery_scene == null or not bool(recovery_scene.call("_uses_guided_decision_flow")):
		return false
	var pattern_value: Variant = recovery_scene.get("_current_pattern")
	if not pattern_value is Dictionary:
		return false
	var pattern := pattern_value as Dictionary
	var correct_response := _find_response(pattern, String(pattern.get("correct_response_id", "")))
	if correct_response.is_empty():
		return false
	var response_grid := recovery_scene.find_child("ResponseGrid", true, false) as Container
	var hypothesis_button := _find_enabled_button(response_grid, String(correct_response.get("hypothesis", "")))
	if hypothesis_button == null:
		return false
	hypothesis_button.pressed.emit()
	await _wait_frames(2)

	for clue_id_value in pattern.get("related_clue_ids", []):
		var clue_id := String(clue_id_value)
		if not _game_state.has_collected_clue(clue_id):
			continue
		response_grid = recovery_scene.find_child("ResponseGrid", true, false) as Container
		var evidence_button := _find_enabled_button(response_grid, _clue_title(clue_id))
		if evidence_button == null:
			return false
		evidence_button.pressed.emit()
		await _wait_frames(2)

	var confirm := recovery_scene.find_child("DecisionConfirmButton", true, false) as Button
	if confirm == null or not confirm.visible or confirm.disabled:
		return false
	confirm.pressed.emit()
	await _wait_frames(2)
	response_grid = recovery_scene.find_child("ResponseGrid", true, false) as Container
	var response_button := _find_enabled_button(response_grid, String(correct_response.get("label", "")))
	if response_button == null:
		return false
	response_button.pressed.emit()
	await _wait_frames(2)
	return true


func _advance_m04_narrative_result() -> bool:
	var narrative_root := current_scene.get_node_or_null("M04NarrativeResult") as Control
	var title := current_scene.get_node_or_null("M04NarrativeResult/VignetteTitle") as Label
	var continue_button := current_scene.get_node_or_null("M04NarrativeResult/ContinueButton") as Button
	if narrative_root == null or title == null or continue_button == null or title.text != "피해자":
		return false
	for expected_title in ["잔향", "귀가 기억", "기록국"]:
		if not continue_button.visible:
			return false
		continue_button.pressed.emit()
		await _wait_frames(2)
		if title.text != expected_title:
			return false
	return not continue_button.visible


func _find_response(pattern: Dictionary, response_id: String) -> Dictionary:
	for response_value in pattern.get("responses", []):
		if typeof(response_value) != TYPE_DICTIONARY:
			continue
		var response := response_value as Dictionary
		if String(response.get("id", "")) == response_id:
			return response.duplicate(true)
	return {}


func _clue_title(clue_id: String) -> String:
	for clue_value in _game_state.get_clues():
		if typeof(clue_value) != TYPE_DICTIONARY:
			continue
		var clue := clue_value as Dictionary
		if String(clue.get("id", "")) == clue_id:
			return String(clue.get("title", ""))
	return ""


func _find_enabled_button(scope: Node, text_fragment: String) -> Button:
	if scope == null:
		return null
	for node in scope.find_children("*", "Button", true, false):
		var button := node as Button
		if button != null and button.visible and not button.disabled and button.text.contains(text_fragment):
			return button
	return null


func _wait_frames(count: int) -> void:
	for _frame in range(count):
		await process_frame


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
		print("M04 PLAYABLE INVESTIGATION TO RECOVERY ROUTE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
