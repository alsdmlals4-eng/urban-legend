extends SceneTree

## Guards the player-facing M04 entry: a fresh campaign must reach the existing
## preparation screen, where the player can earn the one non-numeric preparation
## capacity before dispatching the real M04 investigation.

const TestSaveGuard = preload("res://tests/test_save_guard.gd")
const M04_ID := "episode_002_red_umbrella_alley"
const M04_PATH := "res://data/episodes/episode_002_red_umbrella_alley.json"
const TEAM := ["agent_kwon_narae", "agent_oh_hyun", "agent_kang_ijun"]

var _guard := TestSaveGuard.new()
var _game_state: Node
var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_game_state = root.get_node_or_null("GameState")
	if _game_state == null:
		push_error("GameState autoload is unavailable")
		quit(1)
		return
	var guard_error := _guard.prepare("user://urban_legend_save.json")
	if not guard_error.is_empty():
		push_error(guard_error)
		quit(1)
		return

	if not _game_state.has_method("begin_campaign_case_selection"):
		_check(false, "GameState exposes a player-facing case-selection campaign entry")
		_restore_and_finish()
		return
	_check(bool(_game_state.call("begin_campaign_case_selection", TEAM)), "a new campaign can begin from case selection instead of forcing M01")
	_check(_game_state.get_current_scene_path() == _game_state.SCENE_PREPARATION, "case-selection entry opens the real preparation scene")
	_check(_has_preparation_entry(M04_ID), "M04 is selectable in the first campaign cycle")

	_complete_morning_rest()
	_check(_game_state.set_campaign_planned_case(M04_ID), "M04 can be planned after the player completes one preparation half-day")
	_check(_game_state.start_episode_from_preparation(M04_PATH), "the planned M04 data loads through the production preparation consumer")
	_check(_game_state.begin_campaign_operation(M04_ID), "M04 dispatch begins through the production campaign gate")
	_check(_game_state.get_current_episode_id() == M04_ID, "the dispatched case is M04")
	var dispatch: Dictionary = _game_state.get_active_campaign_operation().get("dispatch_context", {})
	_check(int(dispatch.get("m04_preparation_capacity", 0)) == 1, "completed rest carries one preparation capacity into M04 dispatch")

	_restore_and_finish()


func _restore_and_finish() -> void:
	var restore_error := _guard.restore()
	if not restore_error.is_empty():
		push_error(restore_error)
		_failures.append(restore_error)
	_finish()


func _complete_morning_rest() -> void:
	for agent_id in TEAM:
		_check(_game_state.set_campaign_schedule(agent_id, "morning", "rest"), "%s can take the initial preparation rest" % agent_id)
	var result: Dictionary = _game_state.resolve_non_investigation_campaign_slot(TEAM)
	_check(not result.has("error"), "the initial rest slot resolves")
	var advance: Dictionary = _game_state.acknowledge_campaign_slot_result()
	_check(bool(advance.get("advanced", false)), "the completed rest advances to the afternoon dispatch slot")


func _has_preparation_entry(episode_id: String) -> bool:
	for entry in _game_state.get_preparation_episode_entries():
		if typeof(entry) == TYPE_DICTIONARY and String(entry.get("id", "")) == episode_id:
			return true
	return false


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("M04 CAMPAIGN ENTRY ROUTE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
