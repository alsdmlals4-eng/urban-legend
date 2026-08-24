extends SceneTree

const GAME_STATE_PATH := "res://scripts/core/afterlife_migrating_game_state.gd"
const CONTRACT_ID := "afterlife-station-canon-v2"
const VALID_SLOT := "slot_afterlife_p01_broadcast_blank"
const VALID_KEYWORD := "kw_afterlife_p01_destination_silence"

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_script: Variant = load(GAME_STATE_PATH)
	_expect(game_script is Script, "afterlife migrating GameState must load")
	if not (game_script is Script):
		_finish()
		return

	var game_state = (game_script as Script).new()
	_expect(game_state.has_method("apply_afterlife_manual_draft"), "GameState must expose narrow manual draft update API")
	if game_state.has_method("apply_afterlife_manual_draft"):
		game_state.activate_afterlife_content_contract_for_migration(CONTRACT_ID)
		game_state.set("current_episode_data", {
			"id": "episode_001_afterlife_station",
			"investigation_manual": {
				"slots": [
					{"id": VALID_SLOT},
					{"id": "slot_afterlife_p01_listener_memory"}
				]
			}
		})
		game_state.set("_afterlife_v2_state", {
			"manual": {
				"state": "in_progress",
				"filled_slots": {},
				"evidence_records": ["record_afterlife_r1_broadcast_original"]
			},
			"sentinel": {"preserve": true}
		})
		var before_state: Dictionary = (game_state.get("_afterlife_v2_state") as Dictionary).duplicate(true)
		var applied: Dictionary = game_state.apply_afterlife_manual_draft({
			"filled_slots": {VALID_SLOT: VALID_KEYWORD}
		})
		_expect(bool(applied.get("ok", false)), "valid existing slot draft should apply in memory")
		var manual: Dictionary = game_state.get_afterlife_manual_state()
		_expect(String((manual.get("filled_slots", {}) as Dictionary).get(VALID_SLOT, "")) == VALID_KEYWORD, "valid draft assignment must be retained")
		_expect(manual.get("evidence_records", []) == ["record_afterlife_r1_broadcast_original"], "draft update must preserve evidence records")
		_expect((game_state.get("_afterlife_v2_state") as Dictionary).get("sentinel", {}) == before_state.get("sentinel", {}), "draft update must not mutate unrelated Canon v2 state")

		var before_invalid: Dictionary = game_state.get_afterlife_manual_state()
		var unknown_slot: Dictionary = game_state.apply_afterlife_manual_draft({
			"filled_slots": {"slot_unknown": VALID_KEYWORD}
		})
		_expect(not bool(unknown_slot.get("ok", false)), "unknown slot must fail closed")
		_expect(String(unknown_slot.get("reason", "")) == "unknown_manual_slot", "unknown slot failure reason must be explicit")
		_expect(game_state.get_afterlife_manual_state() == before_invalid, "failed draft must not mutate manual state")

		var invalid_reference: Dictionary = game_state.apply_afterlife_manual_draft({
			"filled_slots": {VALID_SLOT: 42}
		})
		_expect(not bool(invalid_reference.get("ok", false)), "non-string keyword reference must fail closed")
		_expect(String(invalid_reference.get("reason", "")) == "invalid_keyword_reference", "invalid keyword failure reason must be explicit")

		var cleared: Dictionary = game_state.apply_afterlife_manual_draft({"filled_slots": {}})
		_expect(bool(cleared.get("ok", false)), "clearing a draft must be allowed")
		_expect(not (game_state.get_afterlife_manual_state().get("filled_slots", {}) as Dictionary).has(VALID_SLOT), "clear must remove slot key rather than storing an empty truth value")
	game_state.free()
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("CASE01 MANUAL DRAFT STATE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
