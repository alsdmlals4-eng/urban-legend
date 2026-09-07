# M04 준비 용량이 기존 권나래 귀가 지원만 gate하고 다른 사건의 지원을 건드리지 않는지 검증한다.
extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")
const M01_ID := "episode_001_afterlife_station"
const M04_ID := "episode_002_red_umbrella_alley"
const M01_PATH := "res://data/episodes/episode_001_afterlife_station.json"
const M04_PATH := "res://data/episodes/episode_002_red_umbrella_alley.json"
const KWON_SUPPORT_ID := "support_kwon_return_route"

var _guard := TestSaveGuard.new()
var _prepared := false
var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node_or_null("GameState")
	if game_state == null:
		_failures.append("GameState autoload is unavailable")
		_finish()
		return
	var guard_error := _guard.prepare(game_state.get_save_file_path())
	if not guard_error.is_empty():
		_failures.append(guard_error)
		_finish()
		return
	_prepared = true
	_test_m04_without_completed_rest_locks_only_kwon_support(game_state)
	_test_m04_completed_rest_unlocks_existing_kwon_support(game_state)
	_test_m01_supports_remain_available_without_m04_preparation(game_state)
	_finish()


func _test_m04_without_completed_rest_locks_only_kwon_support(game_state) -> void:
	_prepare_episode(game_state, M04_PATH)
	_expect(game_state.set_campaign_planned_case(M04_ID), "M04 can be planned without a rest slot")
	_expect(game_state.begin_campaign_operation(M04_ID), "M04 begins without a completed rest slot")
	var support := _find_support(game_state.get_selected_recovery_supports(), KWON_SUPPORT_ID)
	_expect(not support.is_empty(), "M04 exposes Kwon's existing return-route support")
	_expect(support.has("available"), "recovery support exposes its current availability")
	_expect(not bool(support.get("available", true)), "M04 locks Kwon support when preparation capacity is zero")
	_expect(not String(support.get("unavailable_reason", "")).is_empty(), "locked M04 support explains the missing preparation")


func _test_m04_completed_rest_unlocks_existing_kwon_support(game_state) -> void:
	_prepare_episode(game_state, M04_PATH)
	var protagonist_id := String(game_state.get_protagonist_agent_id())
	_expect(game_state.set_campaign_schedule(protagonist_id, "morning", "rest"), "Kwon can schedule an M04 preparation rest")
	_expect(bool(game_state.resolve_non_investigation_campaign_slot([protagonist_id]).get("successful", false)), "the M04 preparation rest completes")
	_expect(bool(game_state.acknowledge_campaign_slot_result().get("advanced", false)), "the completed M04 rest advances the half-day")
	_expect(game_state.set_campaign_planned_case(M04_ID), "M04 can be planned after a completed rest")
	_expect(game_state.begin_campaign_operation(M04_ID), "M04 begins after a completed rest")
	var support := _find_support(game_state.get_selected_recovery_supports(), KWON_SUPPORT_ID)
	_expect(not support.is_empty(), "M04 keeps the same Kwon support after preparation")
	_expect(bool(support.get("available", false)), "one completed rest unlocks the existing M04 Kwon support")
	_expect(String(support.get("unavailable_reason", "")).is_empty(), "unlocked M04 support has no blocking reason")
	game_state.mark_agent_support_used(KWON_SUPPORT_ID)
	var used_support := _find_support(game_state.get_selected_recovery_supports(), KWON_SUPPORT_ID)
	_expect(bool(used_support.get("used", false)), "the overlay data retains the existing one-use recovery support state")


func _test_m01_supports_remain_available_without_m04_preparation(game_state) -> void:
	_prepare_episode(game_state, M01_PATH)
	_expect(game_state.set_campaign_planned_case(M01_ID), "M01 remains plannable without M04 preparation")
	_expect(game_state.begin_campaign_operation(M01_ID), "M01 starts without M04 preparation")
	var supports: Array = game_state.get_selected_recovery_supports()
	_expect(not supports.is_empty(), "M01 retains its existing recovery support list")
	for support_value in supports:
		if typeof(support_value) != TYPE_DICTIONARY:
			continue
		var support: Dictionary = support_value
		_expect(support.has("available") and bool(support.get("available", false)), "M01 support remains available because the M04 gate is case-specific")


func _prepare_episode(game_state, path: String) -> void:
	game_state.reset_run_state()
	_expect(game_state.load_episode(path), "episode data loads for preparation-gate coverage")
	game_state.set_selected_agent_ids([game_state.get_protagonist_agent_id()])


func _find_support(supports: Array, support_id: String) -> Dictionary:
	for support_value in supports:
		if typeof(support_value) == TYPE_DICTIONARY and String(support_value.get("id", "")) == support_id:
			return support_value.duplicate(true)
	return {}


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
		print("M04 PREPARATION SUPPORT GATE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
