extends SceneTree

## Guards the player-facing M04 contract: collected records alone must not
## bypass the player-authored manual. The authored rule is intentionally not
## semantically graded here; recovery remains the place where a bad inference
## becomes an observable danger case.

const TestSaveGuard := preload("res://tests/test_save_guard.gd")
const M04_EPISODE_ID := "episode_002_red_umbrella_alley"
const M04_EPISODE_PATH := "res://data/episodes/episode_002_red_umbrella_alley.json"
const RULE_ID := "rule_m04_victim_tether"
const SLOT_FABRIC := "slot_m04_victim_tether_fabric"
const SLOT_SIGN := "slot_m04_victim_tether_sign"
const CANDIDATE_FABRIC := "kw_m04_tether_fabric_inner_dry"
const CANDIDATE_SIGN := "kw_m04_tether_sign_reverse_route"

var _guard := TestSaveGuard.new()
var _prepared := false
var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node_or_null("GameState")
	_expect(game_state != null, "GameState autoload missing")
	if game_state == null:
		_finish()
		return
	var guard_error := _guard.prepare(game_state.get_save_file_path())
	_expect(guard_error.is_empty(), guard_error)
	if not guard_error.is_empty():
		_finish()
		return
	_prepared = true
	game_state.reset_run_state()
	_expect(game_state.load_episode(M04_EPISODE_PATH), "M04 episode failed to load")
	var episode: Dictionary = game_state.get_current_episode()
	var manual_value: Variant = episode.get("investigation_manual", {})
	_expect(manual_value is Dictionary, "M04 investigation manual missing")
	if not manual_value is Dictionary:
		_finish()
		return
	var manual := manual_value as Dictionary
	_expect(game_state.collect_clue("clue_red_umbrella_fabric"), "M04 fabric record fixture could not be earned")
	_expect(game_state.collect_clue("clue_repeating_alley_sign"), "M04 sign record fixture could not be earned")
	_expect(not game_state.can_enter_resolution_phase(), "two M04 records without an authored rule must not unlock recovery")

	var earned: Array = game_state.get_collected_clue_ids()
	var fabric_placement: Dictionary = game_state.set_manual_draft_slot(manual, RULE_ID, SLOT_FABRIC, CANDIDATE_FABRIC, earned, M04_EPISODE_ID)
	_expect(bool(fabric_placement.get("ok", false)), "M04 fabric candidate could not be authored into its source-gated slot")
	var sign_placement: Dictionary = game_state.set_manual_draft_slot(manual, RULE_ID, SLOT_SIGN, CANDIDATE_SIGN, earned, M04_EPISODE_ID)
	_expect(bool(sign_placement.get("ok", false)), "M04 sign candidate could not be authored into its source-gated slot")
	_expect(game_state.can_enter_resolution_phase(), "two M04 records plus one completed authored rule must unlock recovery")

	var clear_result: Dictionary = game_state.clear_manual_draft_slot(manual, SLOT_SIGN, M04_EPISODE_ID)
	_expect(bool(clear_result.get("ok", false)), "M04 authored slot fixture could not be cleared")
	_expect(not game_state.can_enter_resolution_phase(), "removing a required authored slot must close the M04 recovery gate again")
	_finish()


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
		print("M04 RESCUE MANUAL GATE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
