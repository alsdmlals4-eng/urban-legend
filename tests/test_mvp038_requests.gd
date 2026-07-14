extends Node

const TestSaveGuard = preload("res://tests/test_save_guard.gd")

var _guard := TestSaveGuard.new()
var _passed := 0
var _failed := 0


func _ready() -> void:
	var error := _guard.prepare(GameState.SAVE_FILE_PATH)
	if not error.is_empty():
		push_error(error)
		get_tree().quit(1)
		return
	_run_tests()
	var restore_error := _guard.restore()
	if not restore_error.is_empty():
		push_error(restore_error)
		_failed += 1
	print("MVP-038 requests: %d passed, %d failed" % [_passed, _failed])
	get_tree().quit(0 if _failed == 0 else 1)


func _run_tests() -> void:
	_test_percentile_boundaries()
	_test_board_accept_cancel_and_persistence()
	_test_request_rewards_are_idempotent()


func _test_percentile_boundaries() -> void:
	var critical: Dictionary = GameState.resolve_percentile_check(5, 5, 5)
	var success: Dictionary = GameState.resolve_percentile_check(5, 5, 50)
	var partial: Dictionary = GameState.resolve_percentile_check(5, 5, 60)
	var failure: Dictionary = GameState.resolve_percentile_check(5, 5, 80)
	_expect(String(critical.get("grade", "")) == "critical", "natural 5 inside chance is critical")
	_expect(String(success.get("grade", "")) == "success", "roll at chance succeeds")
	_expect(String(partial.get("grade", "")) == "partial", "roll within +15 is partial")
	_expect(String(failure.get("grade", "")) == "failure", "roll beyond partial range fails")
	_expect(int(GameState.resolve_percentile_check(99, 0, 50).get("chance", 0)) == 95, "chance has a 95 cap")
	_expect(int(GameState.resolve_percentile_check(0, 99, 50).get("chance", 0)) == 5, "chance has a 5 floor")


func _test_board_accept_cancel_and_persistence() -> void:
	GameState.reset_run_state()
	var board := GameState.get_faction_request_board()
	_expect(board.size() == 3, "campaign starts with three request slots")
	var first: Dictionary = board[0]
	var instance_id := String(first.get("instance_id", ""))
	var faction_id := String(first.get("faction_id", ""))
	_expect(GameState.accept_faction_request(instance_id), "offered request can be accepted")
	GameState.complete_campaign_slot({"kind": "schedule"})
	GameState.acknowledge_campaign_slot_result()
	_expect(String(GameState.get_faction_request_board()[0].get("instance_id", "")) == instance_id, "accepted request survives half-day refresh")
	var before_relation := GameState.get_faction_relation(faction_id)
	_expect(GameState.cancel_faction_request(instance_id), "accepted request can be canceled")
	_expect(GameState.get_faction_relation(faction_id) == before_relation - 1, "cancel costs one faction relation")
	_expect(GameState.save_game() and GameState.load_game(), "request board save round trip succeeds")
	_expect((GameState.get_faction_request_board() as Array).size() == 3, "request board restores three slots")


func _test_request_rewards_are_idempotent() -> void:
	GameState.reset_run_state()
	var request: Dictionary = GameState.get_faction_request_board()[0]
	var instance_id := String(request.get("instance_id", ""))
	_expect(GameState.accept_faction_request(instance_id), "request accepted for reward test")
	var before_fragments := GameState.get_echo_fragments()
	var result := GameState.resolve_faction_request(instance_id, "agent_kwon_narae", 1)
	_expect(not result.has("error") and String(result.get("check", {}).get("grade", "")) == "critical", "fixed roll produces critical request result")
	_expect(GameState.get_echo_fragments() == before_fragments + 12, "critical request grants 12 fragments")
	var repeated := GameState.resolve_faction_request(instance_id, "agent_kwon_narae", 1)
	_expect(repeated.has("error") and GameState.get_echo_fragments() == before_fragments + 12, "completed request cannot pay twice")


func _expect(condition: bool, label: String) -> void:
	if condition:
		_passed += 1
		print("  PASS: %s" % label)
	else:
		_failed += 1
		push_error("  FAIL: %s" % label)
