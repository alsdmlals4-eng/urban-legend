# M04의 10일·반일 출동 맥락과 한 cycle 한 메인 사건 lock을 독립적으로 검증한다.
extends SceneTree

const CampaignStateScript = preload("res://scripts/core/campaign_state.gd")

const AFTERLIFE := "episode_001_afterlife_station"
const RED_UMBRELLA := "episode_002_red_umbrella_alley"

var _failures: Array[String] = []


func _init() -> void:
	_test_early_dispatch_locks_one_case_and_persists_context()
	_test_legacy_active_operation_reconstructs_its_cycle_context()
	_test_day_ten_dispatch_is_regular_without_a_numeric_effect()
	_test_m01_remains_a_valid_first_cycle_case()
	_finish()


func _test_early_dispatch_locks_one_case_and_persists_context() -> void:
	var state = CampaignStateScript.new()
	_expect(state.set_planned_case(RED_UMBRELLA), "M04 can be planned before the operation starts")
	_expect(state.begin_operation(RED_UMBRELLA), "M04 begins from the planned case")
	var snapshot: Dictionary = state.get_snapshot()
	_expect(String(snapshot.get("cycle_main_case_id", "")) == RED_UMBRELLA, "first started operation locks the cycle main case")
	var operation: Dictionary = state.get_active_operation()
	var dispatch: Dictionary = operation.get("dispatch_context", {})
	_expect(String(dispatch.get("dispatch_kind", "")) == "EARLY", "Day 1 M04 dispatch is early")
	_expect(int(dispatch.get("dispatch_day", 0)) == 1 and String(dispatch.get("dispatch_slot", "")) == "morning", "early context preserves the actual day and slot")
	_expect(not state.set_planned_case(AFTERLIFE), "another main case cannot replace the cycle lock")
	_expect(state.resolve_case(RED_UMBRELLA, "standard"), "M04 resolution is recorded")
	snapshot = state.get_snapshot()
	var resolved_case: Dictionary = (snapshot.get("cases", {}) as Dictionary).get(RED_UMBRELLA, {})
	var resolution_context: Dictionary = resolved_case.get("resolution_context", {})
	_expect(String(resolution_context.get("dispatch_kind", "")) == "EARLY", "resolved M04 retains its early dispatch context")
	var restored = CampaignStateScript.new()
	restored.load_save_data(state.to_save_data())
	var restored_case: Dictionary = (restored.get_snapshot().get("cases", {}) as Dictionary).get(RED_UMBRELLA, {})
	_expect(String(restored_case.get("resolution_context", {}).get("dispatch_kind", "")) == "EARLY", "dispatch context survives a campaign save round trip")
	_expect(String(restored.get_snapshot().get("cycle_main_case_id", "")) == RED_UMBRELLA, "cycle lock survives a campaign save round trip")


func _test_legacy_active_operation_reconstructs_its_cycle_context() -> void:
	var state = CampaignStateScript.new()
	_expect(state.set_planned_case(RED_UMBRELLA), "M04 can prepare a legacy-active-operation fixture")
	_expect(state.begin_operation(RED_UMBRELLA), "M04 legacy fixture begins an operation")
	var legacy_save: Dictionary = state.to_save_data()
	legacy_save.erase("cycle_main_case_id")
	var legacy_operation: Dictionary = legacy_save.get("active_operation", {}).duplicate(true)
	legacy_operation.erase("dispatch_context")
	legacy_save["active_operation"] = legacy_operation
	var restored = CampaignStateScript.new()
	restored.load_save_data(legacy_save)
	var dispatch: Dictionary = restored.get_active_operation().get("dispatch_context", {})
	_expect(String(dispatch.get("dispatch_kind", "")) == "EARLY" and int(dispatch.get("dispatch_day", 0)) == 1 and String(dispatch.get("dispatch_slot", "")) == "morning", "legacy active operation reconstructs its actual dispatch context")
	_expect(String(restored.get_cycle_main_case_id()) == RED_UMBRELLA, "legacy active operation reconstructs its cycle main-case lock")
	_expect(restored.resolve_case(RED_UMBRELLA, "standard"), "restored legacy operation can resolve normally")
	_expect(restored.complete_current_slot({"kind": "investigation"}), "restored legacy operation completes its current slot")
	restored.acknowledge_slot_result()
	_expect(not restored.set_planned_case(AFTERLIFE), "legacy cycle lock still rejects a second main case after resolution")


func _test_day_ten_dispatch_is_regular_without_a_numeric_effect() -> void:
	var state = CampaignStateScript.new()
	for _index in range(9):
		state.advance_day(false)
	_expect(int(state.get_snapshot().get("day", 0)) == 10, "campaign reaches playable Day 10")
	_expect(state.set_planned_case(RED_UMBRELLA), "M04 can be planned on Day 10")
	_expect(state.begin_operation(RED_UMBRELLA), "M04 begins on Day 10")
	var dispatch: Dictionary = state.get_active_operation().get("dispatch_context", {})
	_expect(String(dispatch.get("dispatch_kind", "")) == "REGULAR", "Day 10 M04 dispatch is regular, not forced")
	_expect(not dispatch.has("numeric_effect"), "dispatch context does not invent a balance value")


func _test_m01_remains_a_valid_first_cycle_case() -> void:
	var state = CampaignStateScript.new()
	_expect(state.set_planned_case(AFTERLIFE), "M01 remains selectable before a cycle begins")
	_expect(state.begin_operation(AFTERLIFE), "M01 remains a valid first-cycle operation")
	_expect(String(state.get_active_operation().get("dispatch_context", {}).get("dispatch_kind", "")) == "EARLY", "M01 retains the existing Day 1 operation semantics")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("M04 CURRENT CAMPAIGN CADENCE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
