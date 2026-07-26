extends SceneTree

const BaseData = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_data.gd")
const ExtensionData = preload("res://scripts/poc/annual_mvp_002/annual_mvp_002_data.gd")
const State = preload("res://scripts/poc/annual_mvp_002/annual_mvp_002_state.gd")
const Adapter = preload("res://scripts/poc/annual_mvp_002/annual_mvp_002_incident_adapter.gd")
const Scene = preload("res://scenes/poc/annual_mvp_002/annual_mvp_002_scene.tscn")

var _failures: Array[String] = []
var _base_config: Dictionary = {}
var _extension_config: Dictionary = {}


class FakeCoreState:
	extends RefCounted
	var calls: Array[Dictionary] = []

	func apply_external_support(source_id: String, event_key: String, effect: Dictionary) -> Dictionary:
		calls.append({
			"source_id": source_id,
			"event_key": event_key,
			"effect": effect.duplicate(true),
		})
		return {"ok": true, "state_changed": true, "events": [], "snapshot": {}}


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_base_config = BaseData.load_config("res://data/poc/annual_mvp_001/spring_vertical_slice.json")
	_extension_config = ExtensionData.load_config("res://data/poc/annual_mvp_002/companion_equipment_research.json")
	_test_data_marks_cross_index_disabled()
	_test_adapter_excludes_cross_index()
	await _test_scene_explains_disabled_cross_index()
	_finish()


func _test_data_marks_cross_index_disabled() -> void:
	var cross_index: Dictionary = {}
	for value in _extension_config.get("unique_skills", []) as Array:
		var skill := value as Dictionary
		if String(skill.get("id", "")) == "annual002_unique_han_cross_index":
			cross_index = skill
			break
	_expect(not cross_index.is_empty(), "cross-index data must remain present")
	_expect(
		String(cross_index.get("runtime_status", "")) == "DISABLED_PENDING_HYPOTHESIS_BOARD_HOOK",
		"cross-index must be disabled until the hypothesis-board hook exists"
	)


func _test_adapter_excludes_cross_index() -> void:
	var state: RefCounted = State.new()
	_expect(bool(state.start(_base_config.duplicate(true), 9301).get("ok", false)), "state should start")
	_expect(bool(state.configure_loadout_v2(
		_strings(["annual002_companion_han_serin"]), {}, "", _strings([])
	).get("ok", false)), "Han-only loadout should remain valid")
	var snapshot: Dictionary = state.get_snapshot()
	var adapter: RefCounted = Adapter.new()
	_expect(bool(adapter.configure(_base_config, snapshot, 9301).get("ok", false)), "adapter should configure safely")
	for line in adapter.get_status_lines():
		_expect(not line.contains("교차 색인"), "disabled cross-index must not enter resolver status")
	var fake := FakeCoreState.new()
	var decisions: Array = adapter.after_omen(fake, {
		"turn": 1,
		"current_pattern_id": "poc001_pattern_false_terminal",
		"clue_count": 3,
	}, {"success": true})
	for decision_value in decisions:
		var decision := decision_value as Dictionary
		_expect(String(decision.get("skill_id", "")) != "annual002_unique_han_cross_index", "disabled cross-index must not produce a decision")
	for log_value in adapter.get_support_log():
		var entry := log_value as Dictionary
		_expect(String(entry.get("skill_id", "")) != "annual002_unique_han_cross_index", "disabled cross-index must not produce a success log")
	_expect(fake.calls.is_empty(), "disabled cross-index must not call the CORE support hook")


func _test_scene_explains_disabled_cross_index() -> void:
	var scene := Scene.instantiate() as Control
	root.add_child(scene)
	await process_frame
	await process_frame
	scene.call("debug_force_preparation_phase")
	await process_frame
	_expect(bool((scene.call("debug_toggle_companion", "annual002_companion_han_serin", true) as Dictionary).get("ok", false)), "Han should remain selectable")
	await process_frame
	var label := scene.find_child("SupportStatusLabel", true, false) as Label
	_expect(label != null, "preparation UI must expose support status")
	if label != null:
		_expect(label.text.contains("교차 색인"), "UI must preserve the disabled unique skill name")
		_expect(label.text.contains("관측·가설 보드 hook 필요"), "UI must explain the missing hypothesis-board hook")
	if is_instance_valid(scene):
		scene.queue_free()
	await process_frame


func _strings(values: Array) -> Array[String]:
	var result: Array[String] = []
	for value in values:
		result.append(String(value))
	return result


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("ANNUAL MVP 002 DISABLED UNIQUE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
