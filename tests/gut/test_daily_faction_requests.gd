extends GutTest

const Campaign = preload("res://scripts/core/campaign_state.gd")
var state: Node
var guard = preload("res://tests/test_save_guard.gd").new()

func before_all() -> void:
	state = get_tree().root.get_node("GameState")
	assert_eq(guard.prepare(state.get_save_file_path()), "")

func after_all() -> void:
	assert_eq(guard.restore(), "")

func before_each() -> void:
	state.reset_run_state()
	state.start_episode_from_preparation("res://data/episodes/episode_002_red_umbrella_alley.json")

func test_first_case_resolution_refreshes_once_and_preserves_accepted_request() -> void:
	var campaign = Campaign.new()
	var before: Array = campaign.get_request_board()
	var accepted_id: String = before[0].instance_id
	campaign.accept_request(accepted_id)
	var sequence: int = campaign.get_snapshot().request_sequence
	campaign.resolve_case(Campaign.AFTERLIFE, "contained")
	assert_gt(int(campaign.get_snapshot().request_sequence), sequence)
	assert_eq(campaign.get_request(accepted_id).status, "accepted")
	var after: Array = campaign.get_request_board()
	campaign.resolve_case(Campaign.AFTERLIFE, "contained")
	assert_eq(campaign.get_request_board(), after)
	var restored = Campaign.new()
	restored.load_save_data(campaign.to_save_data())
	restored.resolve_case(Campaign.AFTERLIFE, "contained")
	assert_eq(restored.get_request_board(), after)

func test_daily_dispatch_resolves_once_without_advancing_calendar() -> void:
	assert_true(state.has_method("perform_daily_faction_request"))
	if not state.has_method("perform_daily_faction_request"):
		return
	var request: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/faction_requests.json")).requests[0].duplicate(true)
	request["instance_id"] = "daily-dispatch-fixture"
	request["status"] = "accepted"
	state.campaign_state.load_save_data({"request_board": [request]})
	var agent_id: String = state.get_protagonist_agent_id()
	var result: Dictionary = state.perform_daily_faction_request(request.instance_id, agent_id, 1)
	assert_false(result.has("error"))
	assert_true(result.has("check"))
	assert_eq(state.get_campaign_slot_phase(), "planning")
	assert_eq(int(state.get_campaign_snapshot().day), 1)
	assert_true(state.perform_daily_faction_request(request.instance_id, agent_id, 1).has("error"))
	assert_true(state.save_game())
	assert_true(state.load_game())
	assert_true(state.perform_daily_faction_request(request.instance_id, agent_id, 1).has("error"))

func test_daily_dispatch_rejects_recovery_requests_and_active_incidents() -> void:
	if not state.has_method("perform_daily_faction_request"):
		assert_true(false, "Daily dispatch entrypoint is missing")
		return
	var request: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/faction_requests.json")).requests[2].duplicate(true)
	request["instance_id"] = "recovery-fixture"
	request["status"] = "accepted"
	state.campaign_state.load_save_data({"request_board": [request]})
	assert_true(state.perform_daily_faction_request(request.instance_id, state.get_protagonist_agent_id()).has("error"))
	request["kind"] = "dispatch"
	state.campaign_state.load_save_data({"request_board": [request]})
	state.campaign_state.set_planned_case(Campaign.RED_UMBRELLA)
	state.campaign_state.begin_operation(Campaign.RED_UMBRELLA)
	assert_true(state.perform_daily_faction_request(request.instance_id, state.get_protagonist_agent_id()).has("error"))
	assert_eq(state.campaign_state.get_request(request.instance_id).status, "accepted")

func test_request_card_button_performs_accepted_dispatch() -> void:
	var request: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/faction_requests.json")).requests[0].duplicate(true)
	request["instance_id"] = "ui-dispatch-fixture"
	request["status"] = "accepted"
	state.campaign_state.load_save_data({"request_board": [request]})
	var scene = load("res://scenes/preparation_scene.tscn").instantiate()
	add_child_autofree(scene)
	var button = scene.find_child("PerformDailyRequest", true, false)
	assert_not_null(button)
	if button == null:
		return
	assert_false(button.disabled)
	button.pressed.emit()
	assert_true(state.campaign_state.get_request(request.instance_id).status in ["completed", "failed"])
	assert_eq(state.get_campaign_slot_phase(), "planning")
