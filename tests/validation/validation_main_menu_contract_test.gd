extends SceneTree

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
	var packed := load("res://scenes/main_menu.tscn") as PackedScene
	_expect(packed != null, "main menu scene must load")
	if packed == null:
		_finish()
		return
	var menu := packed.instantiate()
	_expect(menu != null, "main menu scene must instantiate")
	if menu == null:
		_finish()
		return
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

	for node_name in [
		"MenuShell", "IdentityRail", "ActionRail", "IntelligenceRail",
		"VersionLabel", "PrimaryActionHint", "CurrentCaseTitle",
		"CurrentCaseMeta", "CurrentCaseSummary", "CurrentCasePreview",
		"LegacyIntelStatus", "ValidationIntelStatus",
		"SettingsButton", "SettingsPanel", "ExitButton"
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
	var legacy_new_button := menu.find_child("LegacyNewCampaignButton", true, false) as Button
	var validation_button := menu.find_child("ValidationPrimaryButton", true, false) as Button
	var validation_secondary := menu.find_child("ValidationSecondaryButton", true, false) as Button
	var validation_status := menu.find_child("ValidationStatusLabel", true, false) as Label
	var db_button := menu.find_child("DatabaseButton", true, false) as Button
	for required_control in [badge, legacy_button, legacy_new_button, validation_button, validation_secondary, validation_status, db_button]:
		if required_control == null:
			_expect(false, "all named controls must have expected types")
			_cleanup(menu)
			_finish()
			return

	var version_label := menu.find_child("VersionLabel", true, false) as Label
	var primary_hint := menu.find_child("PrimaryActionHint", true, false) as Label
	var current_case_title := menu.find_child("CurrentCaseTitle", true, false) as Label
	var settings_button := menu.find_child("SettingsButton", true, false) as Button
	var settings_panel := menu.find_child("SettingsPanel", true, false) as Control
	var exit_button := menu.find_child("ExitButton", true, false) as Button

	_expect(version_label != null and version_label.text == "Ver 4.3", "menu must display canonical Ver 4.3")
	_expect(primary_hint != null and "새 캠페인 시작" in primary_hint.text, "no-save state must name new campaign as primary")
	_expect(current_case_title != null and "저승역" in current_case_title.text, "current case must use loaded canonical episode data")
	_expect(settings_button != null and settings_button.focus_mode == Control.FOCUS_ALL, "settings must accept keyboard focus")
	_expect(settings_panel != null and not settings_panel.visible, "settings panel must start collapsed")
	_expect(exit_button != null and exit_button.focus_mode == Control.FOCUS_ALL, "exit must accept keyboard focus")
	_expect(menu.find_children("*", "ScrollContainer", true, false).is_empty(), "main menu must not contain a document-wall ScrollContainer")

	await process_frame
	_expect(root.gui_get_focus_owner() == legacy_new_button, "no-save initial focus must match the primary new-campaign action")
	_expect(_inside_viewport(version_label), "Ver 4.3 must fit inside 1280x720")
	_expect(_inside_viewport(legacy_new_button), "primary Legacy action must fit inside 1280x720")

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
	_expect(legacy_button.focus_neighbor_bottom == legacy_button.get_path_to(legacy_new_button), "Legacy focus must move to new campaign")
	_expect(db_button.focus_mode == Control.FOCUS_ALL, "Database must remain keyboard accessible")

	settings_button.pressed.emit()
	_expect(settings_panel.visible, "settings must expose the existing accessibility surface")
	settings_button.pressed.emit()
	_expect(not settings_panel.visible, "settings must collapse the accessibility surface")

	var case_preview := menu.find_child("CurrentCasePreview", true, false) as Control
	var case_summary := menu.find_child("CurrentCaseSummary", true, false) as Control
	_expect(case_preview != null and not case_preview.visible, "1280x720 must compact secondary preview first")
	_expect(case_summary != null and not case_summary.visible, "1280x720 must compact secondary summary first")

	root.size = Vector2i(1920, 1080)
	menu.size = Vector2(1920, 1080)
	await process_frame
	await process_frame
	_expect(case_preview.visible, "1920x1080 may expose the existing case preview")
	_expect(case_summary.visible, "1920x1080 may expose the existing case summary")

	_cleanup(menu)
	_finish()


func _inside_viewport(control: Control) -> bool:
	if control == null:
		return false
	return Rect2(Vector2.ZERO, Vector2(root.size)).encloses(control.get_global_rect())


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
