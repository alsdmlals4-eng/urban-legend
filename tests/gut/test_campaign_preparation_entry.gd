extends GutTest

var state: Node
var guard = preload("res://tests/test_save_guard.gd").new()


func before_all() -> void:
	state = get_tree().root.get_node("GameState")
	assert_eq(guard.prepare(state.get_save_file_path()), "")


func after_all() -> void:
	assert_eq(guard.restore(), "")


func test_new_campaign_enters_unassigned_preparation_and_roundtrips() -> void:
	assert_true(state.has_method("begin_campaign_case_selection"), "Main menu entry must have a callable receiver")
	if not state.has_method("begin_campaign_case_selection"):
		return
	state.set_campaign_planned_case("episode_002_red_umbrella_alley")
	state.begin_campaign_operation("episode_002_red_umbrella_alley")
	assert_true(state.call("begin_campaign_case_selection", ["agent_kwon_narae", "agent_oh_hyun", "agent_kang_ijun"]))
	assert_eq(state.get_current_scene_path(), "res://scenes/preparation_scene.tscn")
	assert_eq(state.get_campaign_planned_case(), "", "No incident selected before the player chooses")
	assert_eq(String(state.get_campaign_snapshot().get("cycle_main_case_id", "")), "")
	assert_eq(state.get_selected_agent_ids(), ["agent_kwon_narae", "agent_oh_hyun", "agent_kang_ijun"])
	assert_true(state.save_game())
	state.set_current_scene_path("res://scenes/main_menu.tscn")
	assert_true(state.load_game())
	assert_eq(state.get_current_scene_path(), "res://scenes/preparation_scene.tscn")


func test_default_entry_retains_protagonist_and_m01_opening_remains_separate() -> void:
	assert_true(state.has_method("begin_campaign_case_selection"))
	if not state.has_method("begin_campaign_case_selection"):
		return
	assert_true(state.call("begin_campaign_case_selection"))
	assert_true(state.get_selected_agent_ids().has("agent_kwon_narae"))
	assert_true(state.restart_afterlife_station_flow())
	assert_eq(state.get_current_scene_path(), "res://scenes/dialogue_scene.tscn")
