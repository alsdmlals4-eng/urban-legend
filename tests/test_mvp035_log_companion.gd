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
	_run_state_tests()
	_guard.restore()
	print("MVP-035: %d passed, %d failed" % [_passed, _failed])
	get_tree().quit(0 if _failed == 0 else 1)


func _run_state_tests() -> void:
	GameState.reset_run_state()
	_check(GameState.SAVE_VERSION == "mvp-035", "save version is mvp035")
	_check(not GameState.has_seen_log_tutorial("main_welcome"), "tutorial starts unseen")
	_check(GameState.claim_log_tutorial("main_welcome", false), "first claim succeeds")
	_check(not GameState.claim_log_tutorial("main_welcome", false), "duplicate claim is rejected")
	_check(GameState.get_seen_log_tutorial_ids() == ["main_welcome"], "claimed ids are readable")
	_check(not GameState.claim_log_tutorial("", false), "empty tutorial id is rejected")

	GameState.save_game()
	GameState.reset_run_state()
	_check(GameState.load_game(), "mvp035 save loads")
	_check(GameState.has_seen_log_tutorial("main_welcome"), "tutorial state round trip")

	var legacy_file := FileAccess.open(GameState.SAVE_FILE_PATH, FileAccess.WRITE)
	legacy_file.store_string(JSON.stringify({
		"save_version": "mvp-034",
		"episode_path": GameState.DEFAULT_EPISODE_PATH
	}))
	legacy_file.close()
	_check(GameState.load_game(), "mvp034 save migrates")
	_check(GameState.get_seen_log_tutorial_ids().is_empty(), "legacy save receives empty tutorial state")


func _check(condition: bool, label: String) -> void:
	if condition:
		_passed += 1
	else:
		_failed += 1
		push_error("FAIL: %s" % label)
