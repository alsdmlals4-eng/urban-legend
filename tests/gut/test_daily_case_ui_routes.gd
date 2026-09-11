extends GutTest

var state: Node
var guard = preload("res://tests/test_save_guard.gd").new()

func before_all() -> void:
	state = get_tree().root.get_node("GameState")
	assert_eq(guard.prepare(state.get_save_file_path()), "")

func before_each() -> void:
	state.reset_run_state()
	state.start_episode_from_preparation("res://data/episodes/episode_002_red_umbrella_alley.json")
	state.set_campaign_planned_case("episode_002_red_umbrella_alley")

func after_all() -> void:
	assert_eq(guard.restore(), "")

func test_daily_hub_exposes_dialogue_and_ready_dispatch_without_schedule() -> void:
	var scene = load("res://scenes/preparation_scene.tscn").instantiate()
	add_child_autofree(scene)
	assert_false(scene.get("_start_button").disabled)
	assert_not_null(scene.get("_daily_episode_list"))
	assert_gt(scene.get("_daily_episode_list").get_child_count(), 0)
	assert_null(scene.find_child("ScheduleList", true, false))

func test_legacy_m04_without_rest_keeps_default_support() -> void:
	state.campaign_state.load_save_data({"active_operation": {"case_id": "episode_002_red_umbrella_alley", "day": 1, "status": "in_progress", "dispatch_context": {"m04_preparation_capacity": 0}}})
	assert_true(bool(state.call("_get_recovery_support_availability", "support_kwon_return_route").get("available", false)))
	state.mark_agent_support_used("support_kwon_return_route")
	assert_true(state.has_used_agent_support("support_kwon_return_route"))
	assert_true(state.save_game())
	assert_true(state.load_game())
	assert_true(state.has_used_agent_support("support_kwon_return_route"))

func test_m04_return_memory_reports_actions_not_calendar() -> void:
	state.begin_campaign_operation("episode_002_red_umbrella_alley")
	var scene = load("res://scripts/scenes/result_scene.gd").new()
	var pages: Array = scene.call("_make_m04_vignette_pages")
	var memory: String = pages[2].body
	assert_false(memory.contains("일차"))
	assert_false(memory.contains("대기·회복"))
	assert_true(memory.contains("귀가 기억 고정"))
	scene.free()
