# 저승역 사실·의미·정체성 PoC의 사건 맥락 콜백 계약을 검증한다.
extends SceneTree

const GameStateScript := preload("res://scripts/core/game_state.gd")
const OH_EVENT_ID := "agent_event_oh_breakthrough_warning_01"
const KANG_EVENT_ID := "agent_event_kang_pattern_note_01"
const MATCHING_CONTEXT := {
	"point_id": "point_staff_room_door",
	"method_type": "destruction",
	"successful": true
}

var _failures: Array[String] = []


func _init() -> void:
	_test_existing_trust_event_stays_trust_gated()
	if _test_incident_context_api_contract():
		_test_oh_event_rejects_nonmatching_contexts()
		_test_oh_event_requires_selected_agent()
		_test_oh_event_triggers_without_numeric_trust_on_matching_incident()
		_test_oh_event_is_one_time_and_preserves_authored_copy()
	_finish()


func _new_state(agent_ids: Array) -> Node:
	var state := GameStateScript.new()
	state.load_episode()
	state.set_selected_agent_ids(agent_ids)
	return state


func _test_existing_trust_event_stays_trust_gated() -> void:
	var state := _new_state(["agent_kang_ijun"])
	var before: Array = state._try_trigger_agent_trust_events()
	_expect(before.is_empty(), "legacy trust event triggered below threshold")
	state.agent_trust["agent_kang_ijun"] = 2
	var after: Array = state._try_trigger_agent_trust_events()
	_expect(after.size() == 1, "legacy trust event no longer triggers at threshold")
	_expect(state.get_triggered_agent_event_ids().has(KANG_EVENT_ID), "legacy trust event id missing")


func _test_incident_context_api_contract() -> bool:
	var state := _new_state(["agent_oh_hyun"])
	for method_value in state.get_method_list():
		if typeof(method_value) != TYPE_DICTIONARY:
			continue
		var method := method_value as Dictionary
		if String(method.get("name", "")) != "_try_trigger_agent_trust_events":
			continue
		var arguments := method.get("args", []) as Array
		var supports_context := arguments.size() == 1
		_expect(supports_context, "incident context API must accept one context dictionary")
		return supports_context
	_expect(false, "incident context API is missing")
	return false


func _test_oh_event_rejects_nonmatching_contexts() -> void:
	var contexts := [
		{"point_id": "point_platform_sign", "method_type": "destruction", "successful": true},
		{"point_id": "point_staff_room_door", "method_type": "observation", "successful": true},
		{"point_id": "point_staff_room_door", "method_type": "analysis", "successful": true},
		{"point_id": "point_staff_room_door", "method_type": "destruction", "successful": false}
	]
	for context_value in contexts:
		var state := _new_state(["agent_oh_hyun"])
		var triggered: Array = state._try_trigger_agent_trust_events(context_value as Dictionary)
		_expect(triggered.is_empty(), "Oh Hyun callback triggered for nonmatching context: %s" % context_value)
		_expect(not state.get_triggered_agent_event_ids().has(OH_EVENT_ID), "Oh Hyun event persisted from nonmatching context")


func _test_oh_event_requires_selected_agent() -> void:
	var state := _new_state(["agent_kwon_narae"])
	var triggered: Array = state._try_trigger_agent_trust_events(MATCHING_CONTEXT)
	_expect(triggered.is_empty(), "Oh Hyun callback triggered when Oh Hyun was not selected")


func _test_oh_event_triggers_without_numeric_trust_on_matching_incident() -> void:
	var state := _new_state(["agent_oh_hyun"])
	_expect(state.get_agent_trust("agent_oh_hyun") == 0, "test precondition requires zero Oh Hyun trust")
	var triggered: Array = state._try_trigger_agent_trust_events(MATCHING_CONTEXT)
	_expect(triggered.size() == 1, "matching staff-room incident did not trigger Oh Hyun callback")
	_expect(state.get_triggered_agent_event_ids().has(OH_EVENT_ID), "matching incident did not persist stable Oh Hyun event id")
	_expect(state.get_agent_trust("agent_oh_hyun") == 0, "incident callback must not invent trust delta")


func _test_oh_event_is_one_time_and_preserves_authored_copy() -> void:
	var state := _new_state(["agent_oh_hyun"])
	state._try_trigger_agent_trust_events(MATCHING_CONTEXT)
	var repeated: Array = state._try_trigger_agent_trust_events(MATCHING_CONTEXT)
	_expect(repeated.is_empty(), "Oh Hyun incident callback triggered more than once")
	_expect(state.get_agent_trust_support_texts().has("오현의 돌파 경고: 다음 조사 또는 회수 판단에서 진입 경로를 참고할 수 있습니다."), "existing Oh Hyun support copy changed")
	var entries: Array = state._get_triggered_agent_event_entries()
	_expect(entries.size() == 1, "expected one triggered Oh Hyun event entry")
	if entries.size() == 1:
		var event := entries[0] as Dictionary
		_expect(String(event.get("title", "")) == "오현의 돌파 경고", "existing Oh Hyun event title changed")
		_expect(String(event.get("text", "")) == "오현: 길을 열었으면 바로 빠져나갈 경로도 확보해야 합니다. 다음 회수 판단 때는 제가 앞을 보겠습니다.", "existing Oh Hyun event text changed")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("FACT MEANING IDENTITY POC: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
