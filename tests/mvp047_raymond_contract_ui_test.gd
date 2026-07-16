extends SceneTree

const TestSaveGuard = preload("res://tests/test_save_guard.gd")

var _guard := TestSaveGuard.new()
var _prepared := false
var _passed := 0
var _failed := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node("GameState")
	var guard_error := _guard.prepare(game_state.SAVE_FILE_PATH)
	if not guard_error.is_empty():
		_fail(guard_error)
		_finish()
		return
	_prepared = true
	game_state.reset_run_state()
	game_state.research_points = 5
	_expect(bool(game_state.complete_research_project("research_contract_protocol").get("successful", false)), "contract protocol setup completes")
	var preparation_script = load("res://scripts/scenes/preparation_scene.gd")
	_expect(preparation_script != null, "preparation scene script loads")
	if preparation_script == null:
		_finish()
		return
	var preparation: Node = preparation_script.new()
	root.add_child(preparation)
	await process_frame
	var contract_button := preparation.find_child("RaymondContractButton", true, false) as Button
	_expect(contract_button != null, "Raymond external contact exposes the one-event contract action")
	if contract_button != null:
		contract_button.emit_signal("pressed")
		await process_frame
	_expect(String(game_state.get_pending_mercenary_contract().get("id", "")) == "contract_raymond_kane", "contact action reserves Raymond through the actual HQ UI")
	preparation.queue_free()
	await process_frame
	await process_frame
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		_passed += 1
	else:
		_fail(message)


func _fail(message: String) -> void:
	_failed += 1
	push_error(message)


func _finish() -> void:
	if _prepared:
		var restore_error := _guard.restore()
		_prepared = false
		if not restore_error.is_empty():
			_fail(restore_error)
	if _failed == 0:
		print("MVP-047 Raymond contract UI: %d passed, 0 failed" % _passed)
		quit(0)
	else:
		push_error("MVP-047 Raymond contract UI: %d passed, %d failed" % [_passed, _failed])
		quit(1)
