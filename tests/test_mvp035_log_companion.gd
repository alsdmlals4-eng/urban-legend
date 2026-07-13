extends Node

const TestSaveGuard = preload("res://tests/test_save_guard.gd")
const LogGuide = preload("res://scripts/ui/log_guide.gd")
const LogTutorialCatalog = preload("res://scripts/ui/log_tutorial_catalog.gd")
const AssetCatalog = preload("res://scripts/ui/ui_asset_catalog.gd")

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
	_run_component_tests()
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


func _run_component_tests() -> void:
	var guide := LogGuide.new()
	add_child(guide)
	guide.present_lines([
		{"text": "접속 완료", "expression": "normal"},
		{"text": "기록 대조 중", "expression": "focus"}
	], "normal", false)
	_check(guide.get_current_text() == "접속 완료", "guide presents first line")
	_check(guide.get_current_expression() == "normal", "guide presents normal expression")
	guide.advance()
	_check(guide.get_current_text() == "기록 대조 중", "guide advances sequence")
	_check(guide.get_current_expression() == "focus", "guide changes expression")
	_check(guide.make_signature_stream("normal").data.size() > 0, "normal signature waveform exists")
	_check(guide.make_signature_stream("focus").data.size() > 0, "focus signature waveform exists")
	_check(guide.make_signature_stream("warning").data.size() > 0, "warning signature waveform exists")
	_check(not LogTutorialCatalog.get_entry("main_welcome").is_empty(), "tutorial catalog entry exists")
	_check(LogTutorialCatalog.get_entry("unknown").is_empty(), "unknown tutorial is safe")
	_check(LogTutorialCatalog.get_repeat_hint("main_welcome").length() > 0, "repeat hint exists")
	var catalog := AssetCatalog.new()
	_check(catalog.get_asset_path("log_normal").ends_with("log_normal.png"), "normal Log asset path registered")
	_check(catalog.get_asset_path("log_focus").ends_with("log_focus.png"), "focus Log asset path registered")
	_check(catalog.get_asset_path("log_warning").ends_with("log_warning.png"), "warning Log asset path registered")
	guide.queue_free()


func _check(condition: bool, label: String) -> void:
	if condition:
		_passed += 1
	else:
		_failed += 1
		push_error("FAIL: %s" % label)
