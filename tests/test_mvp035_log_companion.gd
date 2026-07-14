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
	await _run_component_tests()
	_run_scene_integration_tests()
	_guard.restore()
	print("MVP-035: %d passed, %d failed" % [_passed, _failed])
	get_tree().quit(0 if _failed == 0 else 1)


func _run_state_tests() -> void:
	GameState.reset_run_state()
	_check(GameState.SAVE_VERSION == "mvp-038", "save version is mvp038 after sequential campaign migration")
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
	guide.set_compact(true)
	await get_tree().process_frame
	var compact_height := guide.get_combined_minimum_size().y
	_check(compact_height <= 128.0, "compact guide limits vertical footprint (%.0f)" % compact_height)
	_check(guide.is_sequence_active(), "guide remains active on final line")
	guide.advance()
	_check(not guide.visible, "final action closes guide")
	_check(guide.make_signature_stream("normal").data.size() > 0, "normal signature waveform exists")
	_check(guide.make_signature_stream("focus").data.size() > 0, "focus signature waveform exists")
	_check(guide.make_signature_stream("warning").data.size() > 0, "warning signature waveform exists")
	_check(not LogTutorialCatalog.get_entry("main_welcome").is_empty(), "tutorial catalog entry exists")
	_check(not LogTutorialCatalog.get_entry("recovery_first_prediction").is_empty(), "prediction tutorial exists")
	_check(LogTutorialCatalog.get_entry("unknown").is_empty(), "unknown tutorial is safe")
	_check(LogTutorialCatalog.get_repeat_hint("main_welcome").length() > 0, "repeat hint exists")
	var catalog := AssetCatalog.new()
	_check(catalog.get_asset_path("log_normal").ends_with("log_normal.png"), "normal Log asset path registered")
	_check(catalog.get_asset_path("log_focus").ends_with("log_focus.png"), "focus Log asset path registered")
	_check(catalog.get_asset_path("log_warning").ends_with("log_warning.png"), "warning Log asset path registered")
	guide.queue_free()


func _run_scene_integration_tests() -> void:
	_check(_episode_has_log_speaker(GameState.DEFAULT_EPISODE_PATH), "afterlife field nodes include Log")
	_check(_episode_has_log_speaker(GameState.RED_UMBRELLA_ALLEY_EPISODE_PATH), "umbrella field nodes include Log")

	GameState.reset_run_state()
	GameState.set_selected_agent_ids(["agent_kang_ijun", "agent_kwon_narae"])
	var investigation: Node = load("res://scenes/investigation_scene.tscn").instantiate()
	add_child(investigation)
	var investigation_guides := investigation.find_children("*", "LogGuide", true, false)
	_check(not investigation_guides.is_empty(), "investigation contains Log guide")
	if not investigation_guides.is_empty():
		_check((investigation_guides[0] as LogGuide).get_signature_play_count() == 1, "first field Log line plays one signature")
	investigation.queue_free()

	var battle: Node = load("res://scenes/battle_scene.tscn").instantiate()
	add_child(battle)
	_check(not battle.find_children("*", "LogGuide", true, false).is_empty(), "recovery contains Log guide")
	battle.queue_free()

	var recovery_text := JSON.stringify(LogTutorialCatalog.TUTORIALS)
	for pattern in GameState.get_recovery_patterns():
		if typeof(pattern) != TYPE_DICTIONARY:
			continue
		_check(not recovery_text.contains(String(pattern.get("correct_response_id", ""))), "telegraph guide hides response id")

	GameState.clear_save_file()
	_check_scene_claims_tutorial("res://scenes/main_menu.tscn", "main_welcome")
	_check_scene_claims_tutorial("res://scenes/preparation_scene.tscn", "preparation_agents")
	_check_scene_claims_tutorial("res://scenes/market_scene.tscn", "market_first_visit")
	_check_scene_claims_tutorial("res://scenes/result_scene.tscn", "result_first_case")
	GameState.clear_save_file()
	_check_scene_claims_tutorial("res://scenes/database_view.tscn", "database_first_visit")


func _check_scene_claims_tutorial(scene_path: String, tutorial_id: String) -> void:
	GameState.seen_log_tutorial_ids.erase(tutorial_id)
	var scene: Node = load(scene_path).instantiate()
	add_child(scene)
	var guides := scene.find_children("*", "LogGuide", true, false)
	_check(not guides.is_empty(), "%s contains Log guide" % scene_path.get_file())
	_check(not GameState.has_seen_log_tutorial(tutorial_id), "%s waits for tutorial acknowledgement" % scene_path.get_file())
	if not guides.is_empty():
		var guide: LogGuide = guides[0]
		for _step in range(4):
			if not guide.visible:
				break
			guide.advance()
	_check(GameState.has_seen_log_tutorial(tutorial_id), "%s claims %s after close" % [scene_path.get_file(), tutorial_id])
	if scene_path.ends_with("main_menu.tscn"):
		_check(_node_has_text(scene, "Ver 3.7"), "main menu displays current Ver 3.7")
		_check(not GameState.has_save_file(), "main tutorial does not create a fake continue save")
	if scene_path.ends_with("database_view.tscn"):
		_check(not GameState.has_save_file(), "database tutorial does not create a fake continue save")
	scene.queue_free()


func _node_has_text(node: Node, expected: String) -> bool:
	if node is Label and expected in String((node as Label).text):
		return true
	for child in node.get_children():
		if _node_has_text(child, expected):
			return true
	return false


func _episode_has_log_speaker(path: String) -> bool:
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	if typeof(parsed) != TYPE_DICTIONARY:
		return false
	for node in parsed.get("field_nodes", []):
		if typeof(node) != TYPE_DICTIONARY:
			continue
		if _lines_have_log(node.get("opening_dialogue", [])):
			return true
		for choice in node.get("choices", []):
			if typeof(choice) == TYPE_DICTIONARY and _lines_have_log(choice.get("after_dialogue", [])):
				return true
	return false


func _lines_have_log(lines: Array) -> bool:
	for line in lines:
		if typeof(line) == TYPE_DICTIONARY and String(line.get("speaker", "")) == "로그":
			return true
	return false


func _check(condition: bool, label: String) -> void:
	if condition:
		_passed += 1
	else:
		_failed += 1
		push_error("FAIL: %s" % label)
