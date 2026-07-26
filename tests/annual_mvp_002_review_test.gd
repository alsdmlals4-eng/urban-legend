extends SceneTree

const BaseData = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_data.gd")
const ExtensionData = preload("res://scripts/poc/annual_mvp_002/annual_mvp_002_data.gd")
const State = preload("res://scripts/poc/annual_mvp_002/annual_mvp_002_state.gd")
const Adapter = preload("res://scripts/poc/annual_mvp_002/annual_mvp_002_incident_adapter.gd")
const AnnualScene = preload("res://scenes/poc/annual_mvp_002/annual_mvp_002_scene.tscn")

var _failures: Array[String] = []
var _base_config: Dictionary = {}
var _extension_config: Dictionary = {}


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_base_config = BaseData.load_config("res://data/poc/annual_mvp_001/spring_vertical_slice.json")
	_extension_config = ExtensionData.load_config("res://data/poc/annual_mvp_002/companion_equipment_research.json")
	_test_runtime_support_contract()
	_test_preparation_bonus_uses_schedule_history()
	_test_readiness_returns_to_state()
	_test_restore_sanitizes_loadout()
	_test_extension_incident_does_not_invent_base_companion()
	_test_actual_main_menu_references()
	await _test_runtime_scene_controls()
	_finish()


func _new_state(seed: int = 9101) -> RefCounted:
	var state: RefCounted = State.new()
	var started: Dictionary = state.start(_base_config.duplicate(true), seed)
	_expect(bool(started.get("ok", false)), "state should start")
	return state


func _strings(values: Array) -> Array[String]:
	var result: Array[String] = []
	for value in values:
		result.append(String(value))
	return result


func _test_runtime_support_contract() -> void:
	var active_ids: Array[String] = []
	var disabled_ids: Array[String] = []
	for value in _extension_config.get("support_skills", []) as Array:
		var skill := value as Dictionary
		var status := String(skill.get("runtime_status", ""))
		if status == "ACTIVE":
			active_ids.append(String(skill.get("id", "")))
			_expect(not (skill.get("preparation_activity_ids", []) as Array).is_empty(), "active support requires schedule preparation source")
		else:
			_expect(status == "DISABLED_PENDING_CORE_HOOK", "unsupported support must be explicitly disabled")
			disabled_ids.append(String(skill.get("id", "")))
	_expect(active_ids.size() == 2, "exactly two damage/risk supports should be active")
	_expect(disabled_ids.size() == 4, "four unsupported effects should remain as disabled data")

	var state: RefCounted = _new_state()
	var disabled_selection: Dictionary = state.configure_loadout_v2(
		_strings(["annual002_companion_han_serin"]),
		{"annual002_companion_han_serin": "annual002_support_second_read"},
		"",
		_strings([])
	)
	_expect(not bool(disabled_selection.get("ok", false)), "disabled support must not be selectable")
	_expect(String(disabled_selection.get("error", "")).contains("후속 CORE hook"), "disabled support rejection should explain why")


func _test_preparation_bonus_uses_schedule_history() -> void:
	var state: RefCounted = _new_state(9102)
	_expect(bool(state.configure_loadout_v2(
		_strings(["annual002_companion_ohyun"]),
		{"annual002_companion_ohyun": "annual002_support_damage_buffer"},
		"",
		_strings([])
	).get("ok", false)), "active support should configure")
	var snapshot: Dictionary = state.get_snapshot()
	var no_prep := Adapter.new()
	_expect(bool(no_prep.configure(_base_config, snapshot, 9102).get("ok", false)), "adapter should configure without prep")
	_expect(_chance_for(no_prep.get_status_lines(), "충격 완화") == 35, "equipping a skill alone must not grant preparation bonus")

	var prepared_snapshot := snapshot.duplicate(true)
	prepared_snapshot["last_week_result"] = {
		"planned_activity_ids": ["annual001_activity_field_training"]
	}
	var prepared := Adapter.new()
	_expect(bool(prepared.configure(_base_config, prepared_snapshot, 9102).get("ok", false)), "adapter should configure with prep history")
	_expect(_chance_for(prepared.get_status_lines(), "충격 완화") == 45, "matching schedule activity should grant +10 percentage points")


func _chance_for(lines: Array[String], label: String) -> int:
	for line in lines:
		if not line.contains(label):
			continue
		var marker := "확률 "
		var start := line.find(marker)
		if start < 0:
			return -1
		var suffix := line.substr(start + marker.length())
		return int(suffix.get_slice("%", 0))
	return -1


func _test_readiness_returns_to_state() -> void:
	var state: RefCounted = _new_state(9103)
	if not state.has_method("apply_support_readiness_snapshot"):
		_expect(false, "state requires apply_support_readiness_snapshot")
		return
	var applied: Dictionary = state.call("apply_support_readiness_snapshot", {
		"annual002_support_damage_buffer": 60,
	})
	_expect(bool(applied.get("ok", false)), "known readiness should apply")
	var readiness := ((state.get_snapshot().get("annual_mvp_002", {}) as Dictionary).get("readiness_by_skill", {}) as Dictionary)
	_expect(int(readiness.get("annual002_support_damage_buffer", 0)) == 60, "readiness should persist in annual state")
	var before: Dictionary = state.get_snapshot()
	var rejected: Dictionary = state.call("apply_support_readiness_snapshot", {"annual002_support_removed": 40})
	_expect(not bool(rejected.get("ok", false)), "unknown readiness id should be rejected")
	_expect(state.get_snapshot() == before, "rejected readiness must not mutate state")


func _test_restore_sanitizes_loadout() -> void:
	var state: RefCounted = _new_state(9104)
	var payload: Dictionary = state.build_save_payload()
	var extension := (payload.get("state", {}) as Dictionary).get("annual_mvp_002", {}) as Dictionary
	extension["owned_equipment_ids"] = ["annual002_equipment_field_coat"]
	extension["selected_equipment_id"] = "annual002_equipment_echo_recorder"
	extension["installed_module_ids"] = ["annual002_module_noise_filter", "annual002_module_impact_gel"]
	extension["last_loadout"] = {
		"selected_equipment_id": "annual002_equipment_echo_recorder",
		"installed_module_ids": ["annual002_module_noise_filter"],
	}
	var restored: RefCounted = _new_state(9105)
	_expect(bool(restored.restore(_base_config.duplicate(true), payload).get("ok", false)), "tampered compatible-version save should restore safely")
	var restored_extension := restored.get_snapshot().get("annual_mvp_002", {}) as Dictionary
	_expect(String(restored_extension.get("selected_equipment_id", "")).is_empty(), "unowned selected equipment must be cleared")
	_expect((restored_extension.get("installed_module_ids", []) as Array).is_empty(), "modules must clear when selected equipment is invalid")
	_expect(String((restored_extension.get("last_loadout", {}) as Dictionary).get("selected_equipment_id", "")).is_empty(), "last loadout must be rebuilt from sanitized state")


func _test_extension_incident_does_not_invent_base_companion() -> void:
	var state: RefCounted = _new_state(9106)
	var seven_rest: Array[String] = []
	for _day in range(7):
		seven_rest.append("annual001_activity_rest")
	_expect(bool(state.commit_week(seven_rest).get("ok", false)), "week one should commit")
	_expect(bool(state.acknowledge_week_result().get("ok", false)), "week one result should advance")
	_expect(bool(state.commit_week(seven_rest).get("ok", false)), "week two should commit")
	_expect(bool(state.acknowledge_week_result().get("ok", false)), "week two result should reach deployment decision")
	_expect(bool(state.choose_deployment_decision("annual001_decision_deploy").get("ok", false)), "week two deployment should reach preparation")
	_expect(bool(state.configure_loadout_v2(
		_strings(["annual002_companion_han_serin"]), {}, "", _strings([])
	).get("ok", false)), "Han-only loadout should configure without public support")
	var begun: Dictionary = state.begin_incident()
	_expect(bool(begun.get("ok", false)), "extension incident should start without mutating base companion gate")
	var snapshot: Dictionary = state.get_snapshot()
	_expect(String(snapshot.get("selected_companion_id", "")).is_empty(), "base selected companion must remain empty")
	var selected := (snapshot.get("annual_mvp_002", {}) as Dictionary).get("selected_companion_ids", []) as Array
	_expect(selected == ["annual002_companion_han_serin"], "extension selection must remain authoritative")


func _test_actual_main_menu_references() -> void:
	var project_text := _read_text("res://project.godot")
	var scene_text := _read_text("res://scenes/main_menu.tscn")
	var script_text := _read_text("res://scripts/ui/main_menu.gd")
	_expect(project_text.contains('run/main_scene="res://scenes/main_menu.tscn"'), "project main scene must remain scenes/main_menu.tscn")
	_expect(scene_text.contains('path="res://scripts/ui/main_menu.gd"'), "actual main scene must use scripts/ui/main_menu.gd")
	_expect(script_text.contains('annual_mvp_002_button.name = "AnnualMvp002Button"'), "actual main menu script must create the named ANNUAL-MVP-002 button")
	_expect(script_text.contains('res://scenes/poc/annual_mvp_002/annual_mvp_002_scene.tscn'), "actual main menu button must target the ANNUAL-MVP-002 scene")
	_expect(FileAccess.file_exists("res://tests/annual_mvp_002_main_menu_runtime_qa.gd"), "normal-project runtime menu QA must exist")


func _read_text(path: String) -> String:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return ""
	return file.get_as_text()


func _test_runtime_scene_controls() -> void:
	var scene := AnnualScene.instantiate() as Control
	root.add_child(scene)
	await process_frame
	await process_frame
	for node_name in [
		"SaveRunButton", "LoadRunButton", "ResearchNodeOption",
		"StartResearchButton", "AdvanceResearchButton", "CancelResearchButton",
	]:
		_expect(scene.find_child(node_name, true, false) != null, "missing runtime control: %s" % node_name)
	for method_name in [
		"debug_save_run", "debug_load_run", "debug_award_research_resources",
		"debug_start_research", "debug_advance_research", "debug_cancel_research",
	]:
		_expect(scene.has_method(method_name), "missing runtime method: %s" % method_name)
	if scene.has_method("debug_award_research_resources") and scene.has_method("debug_start_research") and scene.has_method("debug_advance_research"):
		_expect(bool(scene.call("debug_award_research_resources", {"annual002_resource_records": 3}).get("ok", false)), "runtime should accept research reward")
		_expect(bool(scene.call("debug_start_research", "annual002_research_field_records").get("ok", false)), "runtime should start research")
		_expect(bool(scene.call("debug_advance_research", "annual002_research_field_records", 2).get("ok", false)), "runtime should complete research")
		var completed := ((scene.debug_snapshot().get("annual_mvp_002", {}) as Dictionary).get("completed_research_ids", []) as Array)
		_expect(completed.has("annual002_research_field_records"), "runtime research completion should reach state")
	if scene.has_method("debug_save_run") and scene.has_method("debug_load_run"):
		var path := "user://annual_mvp_002_review_test.json"
		_expect(bool(scene.call("debug_save_run", path).get("ok", false)), "runtime save should succeed")
		_expect(bool(scene.call("debug_load_run", path).get("ok", false)), "runtime load should succeed")
	if is_instance_valid(scene):
		scene.queue_free()
	await process_frame


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("ANNUAL MVP 002 REVIEW: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
