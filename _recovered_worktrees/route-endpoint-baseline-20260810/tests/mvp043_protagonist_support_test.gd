# selected_agent_ids 순서 기반 주인공·서포트 호환과 지원 재추첨 방지를 검증한다.
extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")
const Catalog = preload("res://scripts/ui/afterlife_manual_catalog.gd")

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
	game_state.set_selected_agent_ids(["agent_oh_hyun", "agent_kwon_narae", "agent_kang_ijun"])
	_expect(game_state.get_protagonist_agent_id() == "agent_kwon_narae", "Kwon Narae should be the fixed protagonist")
	_expect(game_state.get_support_agent_ids() == ["agent_oh_hyun", "agent_kang_ijun"], "the remaining two agents should be supports")
	_expect(game_state.can_start_mission_with_agents(), "one protagonist should satisfy the formation minimum")
	_expect(not game_state.set_protagonist_agent_id("agent_oh_hyun"), "another agent cannot replace the fixed protagonist")
	_expect(game_state.get_agents().size() == 5, "the shared catalog should expose five initial agents")
	_expect(not game_state.get_agent_by_id("agent_yoon_seoha").is_empty() and not game_state.get_agent_by_id("agent_han_yuri").is_empty(), "Yoon Seoha and Han Yuri should be formation candidates")

	var forced_success: Dictionary = game_state.roll_agent_auto_action("agent_kwon_narae", "analysis", 0.0, 20.0, 90.0)
	_expect(bool(forced_success.get("triggered", false)), "optional zero roll should make support tests deterministic")
	_expect(float(forced_success.get("chance", 100.0)) < 100.0, "tutorial support chance should remain below 100 percent")

	var legacy_save: Dictionary = game_state.call("_make_save_data")
	legacy_save["selected_agent_ids"] = ["agent_oh_hyun", "agent_kwon_narae", "agent_kang_ijun"]
	legacy_save["used_agent_supports"] = ["mvp043_analysis:point_platform_speaker", "mvp043_analysis:point_platform_speaker:success:record_personal_destination", "mvp043_protection:first_risk"]
	var campaign: Dictionary = legacy_save.get("campaign_state", {})
	campaign["schedules"] = {"1": {"agent_oh_hyun": {"morning": "investigation"}}}
	legacy_save["campaign_state"] = campaign
	var save_file := FileAccess.open(game_state.get_save_file_path(), FileAccess.WRITE)
	save_file.store_string(JSON.stringify(legacy_save, "\t"))
	save_file.close()
	game_state.load_game()
	_expect(game_state.get_selected_agent_ids() == ["agent_kwon_narae", "agent_oh_hyun", "agent_kang_ijun"], "legacy saves should promote Kwon without resetting the operation team")
	_expect(String(game_state.get_campaign_agent_schedule("agent_kwon_narae").get("morning", "")) == "investigation", "the previous protagonist current-slot schedule should be copied to Kwon")
	_expect(String(game_state.get_campaign_agent_schedule("agent_oh_hyun").get("morning", "")) == "investigation", "the previous protagonist schedule should remain intact")
	_expect(game_state.has_used_agent_support("mvp043_official_comparison:point_platform_speaker"), "legacy analysis attempts should alias to official comparison")
	_expect(game_state.has_used_agent_support("mvp043_safety_line:first_risk"), "legacy protection attempts should alias to safety line")

	game_state.set_current_field_node_id("field_station_investigation")
	change_scene_to_file(game_state.SCENE_INVESTIGATION)
	for _frame in range(5):
		await process_frame
	var scene := current_scene
	var point := {"id": "point_platform_speaker", "label": "플랫폼 스피커", "clue_id": "clue_repeating_announcement", "method_options": [{"id": "legacy"}]}
	var definition := Catalog.judgment_for_point("point_platform_speaker")
	scene.call("_show_reasoning_options", point, definition, 0.0)
	await process_frame
	_expect(game_state.has_used_agent_support("mvp043_official_comparison:point_platform_speaker"), "official comparison should record the attempted judgment id")
	_expect(game_state.has_used_agent_support("mvp043_official_comparison:point_platform_speaker:success:record_personal_destination"), "successful support should persist its deterministic eliminated candidate")
	var disabled_before := _disabled_choice_count(scene)
	scene.call("_show_reasoning_options", point, definition, 100.0)
	await process_frame
	_expect(_disabled_choice_count(scene) == disabled_before and disabled_before == 1, "re-entry should restore the successful support result without rerolling or solving the choice")
	_finish()


func _disabled_choice_count(scene: Node) -> int:
	var count := 0
	var box := scene.find_child("FieldChoiceBox", true, false)
	if box == null:
		return 0
	for card in box.get_children():
		var button := card.find_child("ActionButton", true, false) as Button
		if button != null and button.disabled:
			count += 1
	return count


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
		print("MVP043 PROTAGONIST SUPPORT: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
