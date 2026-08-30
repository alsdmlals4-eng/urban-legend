# M04의 준비 용량은 완료한 대기·회복 반일에서만 생기며, 구 save는 0으로 복원한다.
extends SceneTree

const CampaignStateScript = preload("res://scripts/core/campaign_state.gd")
const M04_ID := "episode_002_red_umbrella_alley"

var _failures: Array[String] = []


func _init() -> void:
	_test_completed_rest_creates_one_bounded_preparation_capacity()
	_test_planned_but_incomplete_rest_does_not_create_capacity()
	_test_legacy_save_without_preparation_ledger_defaults_to_zero()
	_finish()


func _test_completed_rest_creates_one_bounded_preparation_capacity() -> void:
	var state = CampaignStateScript.new()
	_expect(state.set_schedule("agent_kwon_narae", "morning", "rest"), "a rest activity can be scheduled for the current slot")
	_expect(state.complete_current_slot({"kind": "schedule", "results": [{"agent_id": "agent_kwon_narae", "activity": "rest"}]}), "completed rest writes a schedule result")
	_expect(bool(state.acknowledge_slot_result().get("advanced", false)), "completed rest advances to the next half-day")
	_expect(state.set_planned_case(M04_ID), "M04 can be planned after a completed rest")
	_expect(state.begin_operation(M04_ID), "M04 starts from the planned case")
	var dispatch: Dictionary = state.get_active_operation().get("dispatch_context", {})
	_expect(dispatch.has("m04_preparation_capacity"), "M04 dispatch explicitly records preparation capacity")
	_expect(int(dispatch.get("m04_preparation_capacity", -1)) == 1, "one completed rest grants exactly one M04 preparation capacity")
	_expect(dispatch.get("m04_preparation_provenance", []) == [{"day": 1, "time_slot": "morning", "activity": "rest"}], "M04 dispatch records the completed rest provenance")


func _test_planned_but_incomplete_rest_does_not_create_capacity() -> void:
	var state = CampaignStateScript.new()
	_expect(state.set_schedule("agent_kwon_narae", "morning", "rest"), "a rest activity can be staged without completing it")
	_expect(state.set_planned_case(M04_ID), "M04 remains plannable before the staged rest is completed")
	_expect(state.begin_operation(M04_ID), "M04 can dispatch before a staged rest completes")
	var dispatch: Dictionary = state.get_active_operation().get("dispatch_context", {})
	_expect(dispatch.has("m04_preparation_capacity"), "M04 dispatch explicitly represents zero preparation capacity")
	_expect(int(dispatch.get("m04_preparation_capacity", -1)) == 0, "an incomplete rest does not grant M04 preparation capacity")
	_expect((dispatch.get("m04_preparation_provenance", []) as Array).is_empty(), "an incomplete rest leaves no preparation provenance")


func _test_legacy_save_without_preparation_ledger_defaults_to_zero() -> void:
	var state = CampaignStateScript.new()
	var legacy_save: Dictionary = state.to_save_data()
	legacy_save.erase("preparation_ledger")
	var restored = CampaignStateScript.new()
	restored.load_save_data(legacy_save)
	_expect(restored.set_planned_case(M04_ID), "M04 is plannable from a legacy campaign save")
	_expect(restored.begin_operation(M04_ID), "M04 starts from a legacy campaign save")
	var dispatch: Dictionary = restored.get_active_operation().get("dispatch_context", {})
	_expect(dispatch.has("m04_preparation_capacity"), "legacy dispatches receive an explicit preparation capacity field")
	_expect(int(dispatch.get("m04_preparation_capacity", -1)) == 0, "legacy campaign saves default to zero M04 preparation capacity")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("M04 BOUNDED PREPARATION CAPACITY: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
