extends SceneTree

const MainMenuScript = preload("res://scripts/ui/main_menu.gd")
const Support = preload("res://tests/validation/validation_test_support.gd")
const TEST_PRIMARY := "user://validation_package_2_main_menu_test.json"
const LEGACY_PATH := "user://urban_legend_save.json"
var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(1280, 720)
	Support.remove_path(TEST_PRIMARY)
	Support.remove_path(LEGACY_PATH)
	var menu = MainMenuScript.new()
	root.add_child(menu)
	await process_frame
	await process_frame

	for node_name in [
		"EntryCards", "LegacyContinueButton", "LegacyNewCampaignButton",
		"ValidationPrimaryButton", "ValidationSecondaryButton",
		"DatabaseButton", "LegacyStatusLabel", "ValidationStatusLabel",
		"ValidationBadgeLabel", "ValidationStatusDialog",
		"ValidationReplaceDialog", "ValidationCompletedDialog"
	]:
		_expect(menu.find_child(node_name, true, false) != null, "%s must exist" % node_name)

	if not menu.has_method("configure_validation_repository_path_for_test") or not menu.has_method("refresh_entry_cards_for_test"):
		_expect(false, "main menu must expose isolated refresh test facade")
		_cleanup(menu)
		_finish()
		return

	menu.configure_validation_repository_path_for_test(TEST_PRIMARY)
	menu.refresh_entry_cards_for_test()
	var badge := menu.find_child("ValidationBadgeLabel", true, false) as Label
	var legacy_button := menu.find_child("LegacyContinueButton", true, false) as Button
	var validation_button := menu.find_child("ValidationPrimaryButton", true, false) as Button
	var validation_secondary := menu.find_child("ValidationSecondaryButton", true, false) as Button
	var validation_status := menu.find_child("ValidationStatusLabel", true, false) as Label
	_expect("별도 기록" in badge.text, "Validation badge must explain persistence separation")
	_expect(legacy_button.focus_mode == Control.FOCUS_ALL, "Legacy primary must accept keyboard focus")
	_expect(validation_button.focus_mode == Control.FOCUS_ALL, "Validation primary must accept keyboard focus")
	_expect(validation_button.text == "새 기록 시작", "EMPTY must offer new Validation")
	_expect(not validation_button.disabled, "EMPTY primary must be enabled")
	_expect(not validation_secondary.visible, "EMPTY must hide secondary")

	Support.write_text(LEGACY_PATH, "LEGACY-MENU-SENTINEL")
	_write_payload("active", "SIT-004")
	menu.refresh_entry_cards_for_test()
	_expect(not legacy_button.disabled, "active Validation must not disable Legacy continue")
	_expect(validation_button.text == "이어하기", "active must offer continue")
	_expect(validation_secondary.visible and validation_secondary.text == "새 기록 시작", "active must offer explicit replacement")
	_expect("저승역" in validation_status.text, "active status must name episode")

	_write_payload("completed", "SIT-008")
	menu.refresh_entry_cards_for_test()
	_expect(validation_button.text == "완료 기록 보기", "completed must offer read-only record")
	_expect(validation_secondary.visible, "completed must offer replacement secondary")

	Support.write_text(TEST_PRIMARY, "{ broken")
	menu.refresh_entry_cards_for_test()
	_expect(validation_button.text == "상태 상세", "corrupt record must expose status only")
	_expect(not validation_secondary.visible, "corrupt record must not expose replacement")
	_expect(not legacy_button.disabled, "corrupt Validation must preserve Legacy continue")

	var db_button := menu.find_child("DatabaseButton", true, false) as Button
	_expect(legacy_button.focus_neighbor_bottom == legacy_button.get_path_to(menu.find_child("LegacyNewCampaignButton", true, false)), "Legacy focus must move to new campaign")
	_expect(db_button.focus_mode == Control.FOCUS_ALL, "Database must remain keyboard accessible")

	_cleanup(menu)
	_finish()


func _write_payload(lifecycle: String, flow_stage: String) -> void:
	var payload := {
		"format": "urban-legend-validation-save",
		"version": "validation-save-v1",
		"payload_schema": 1,
		"revision": 1,
		"session": {
			"token": "menu-token",
			"lifecycle": lifecycle,
			"episode_id": "episode_001_afterlife_station",
			"flow_stage": flow_stage,
			"checkpoint_id": "menu-checkpoint"
		},
		"snapshots": {"runtime": {}, "preparation": {}, "reasoning": {}, "route": {}, "recovery": {}},
		"result": {"axes": {}, "candidate_records": {}, "applied_effect_ids": {}},
		"timestamps": {
			"created_at_utc": "2026-08-02T08:00:00Z",
			"updated_at_utc": "2026-08-02T08:10:00Z",
			"completed_at_utc": "2026-08-02T08:20:00Z" if lifecycle == "completed" else ""
		},
		"integrity": {"content_episode_id": "episode_001_afterlife_station"}
	}
	Support.write_text(TEST_PRIMARY, JSON.stringify(payload))


func _cleanup(menu: Node) -> void:
	menu.queue_free()
	Support.remove_path(TEST_PRIMARY)
	Support.remove_path(LEGACY_PATH)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("VALIDATION MAIN MENU CONTRACT: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
