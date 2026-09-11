extends GutTest

const Campaign = preload("res://scripts/core/campaign_state.gd")

func test_orphaned_in_progress_save_returns_to_daily_without_erasing_case_notes() -> void:
	var campaign = Campaign.new()
	campaign.load_save_data({"slot_phase": "in_progress", "active_operation": {},
		"cases": {Campaign.AFTERLIFE: {"rewarded_daily_content_ids": ["observed_record"]}}})
	assert_true(campaign.set_planned_case(Campaign.RED_UMBRELLA))
	assert_true(campaign.begin_operation(Campaign.RED_UMBRELLA))
	assert_eq(campaign.get_snapshot().cases[Campaign.AFTERLIFE].rewarded_daily_content_ids, ["observed_record"])

func test_unknown_operation_status_can_resume_without_replacing_the_case() -> void:
	var campaign = Campaign.new()
	campaign.load_save_data({"active_operation": {"case_id": Campaign.RED_UMBRELLA, "status": "obsolete_status"}})
	assert_true(campaign.resume_operation())
	assert_eq(campaign.get_active_operation().case_id, Campaign.RED_UMBRELLA)
	assert_false(campaign.set_planned_case(Campaign.AFTERLIFE))

func test_completed_result_round_trip_is_acknowledged_once() -> void:
	var campaign = Campaign.new()
	campaign.set_planned_case(Campaign.AFTERLIFE)
	campaign.begin_operation(Campaign.AFTERLIFE)
	campaign.complete_current_slot({"protected_victims": 2})
	var restored = Campaign.new()
	restored.load_save_data(campaign.to_save_data())
	assert_eq(restored.get_slot_result().protected_victims, 2)
	assert_eq(restored.get_slot_phase(), "result")
	assert_true(restored.acknowledge_slot_result().advanced)
	assert_false(restored.acknowledge_slot_result().advanced)
	assert_true(restored.set_planned_case(Campaign.RED_UMBRELLA))
