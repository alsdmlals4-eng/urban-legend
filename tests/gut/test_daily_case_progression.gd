extends GutTest

const Campaign = preload("res://scripts/core/campaign_state.gd")
var campaign

func before_each() -> void:
	campaign = Campaign.new()

func test_result_returns_to_daily_without_calendar_or_second_case_lock() -> void:
	assert_true(campaign.set_planned_case(Campaign.AFTERLIFE))
	assert_true(campaign.begin_operation(Campaign.AFTERLIFE))
	assert_false(campaign.set_planned_case(Campaign.RED_UMBRELLA))
	assert_true(campaign.complete_current_slot({"kind": "investigation"}))
	campaign.acknowledge_slot_result()
	assert_eq(campaign.get_current_slot(), "morning", "Result acknowledgement must not spend a half-day")
	assert_true(campaign.set_planned_case(Campaign.RED_UMBRELLA), "Completed operation cannot lock another incident behind a cycle")
	assert_false(bool(campaign.acknowledge_slot_result().get("advanced", false)))

func test_legacy_day_advance_does_not_raise_risk_or_expire_campaign() -> void:
	for index in range(25):
		campaign.advance_day()
	var snapshot: Dictionary = campaign.get_snapshot()
	assert_eq(int(snapshot.day), 1)
	assert_false(bool(snapshot.demo_ended))
	assert_eq(int(snapshot.cases[Campaign.AFTERLIFE].risk), 0)

func test_unique_daily_content_keeps_cap_without_date_lock() -> void:
	assert_eq(campaign.grant_daily_understanding(Campaign.AFTERLIFE, "first_view", "a"), 2)
	assert_eq(campaign.grant_daily_understanding(Campaign.AFTERLIFE, "first_view", "b"), 2)
	assert_eq(campaign.grant_daily_understanding(Campaign.AFTERLIFE, "first_view", "a"), 0)
	for content in ["c", "d", "e"]:
		assert_eq(campaign.grant_daily_understanding(Campaign.AFTERLIFE, "first_view", content), 2)
	assert_eq(campaign.grant_daily_understanding(Campaign.AFTERLIFE, "first_view", "f"), 0)

func test_expired_legacy_save_can_start_without_schedule() -> void:
	campaign.load_save_data({"day": 10, "demo_ended": true, "cycle_main_case_id": Campaign.AFTERLIFE})
	assert_true(campaign.set_planned_case(Campaign.RED_UMBRELLA))
	assert_true(campaign.begin_operation(Campaign.RED_UMBRELLA))

func test_mismatched_legacy_date_preserves_suspended_operation() -> void:
	campaign.load_save_data({"day": 10, "active_operation": {"day": 3, "case_id": Campaign.RED_UMBRELLA, "status": "suspended"}})
	assert_eq(String(campaign.get_active_operation().get("case_id", "")), Campaign.RED_UMBRELLA)
	assert_true(campaign.resume_operation())
	var restored = Campaign.new()
	restored.load_save_data(campaign.to_save_data())
	assert_eq(String(restored.get_active_operation().get("status", "")), "in_progress")

func test_m04_default_support_has_no_calendar_dispatch_claim() -> void:
	campaign.set_planned_case(Campaign.RED_UMBRELLA)
	campaign.begin_operation(Campaign.RED_UMBRELLA)
	var context: Dictionary = campaign.get_active_operation().get("dispatch_context", {})
	assert_eq(int(context.get("m04_preparation_capacity", 0)), 1)
	assert_false(context.has("dispatch_day"))
	assert_false(context.has("dispatch_kind"))
