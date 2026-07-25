extends SceneTree

const Data = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_data.gd")
const State = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_state_v2.gd")
const SaveData = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_save_data.gd")
const Adapter = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_incident_adapter.gd")

var _failures: Array[String] = []

class FakeCoreState:
	extends RefCounted
	var calls: Array[Dictionary] = []
	func apply_external_support(source_id: String, event_key: String, effect: Dictionary) -> Dictionary:
		calls.append({"source_id": source_id, "event_key": event_key, "effect": effect.duplicate(true)})
		return {"ok": true, "state_changed": true, "events": [], "snapshot": {}}

func _init() -> void:
	var config: Dictionary = Data.load_config("res://data/poc/annual_mvp_001/spring_vertical_slice.json")
	var state := State.new()
	_expect(state.start(config, 4444)["ok"], "state should start")
	_expect(state.commit_week([
		"annual001_activity_signal_research",
		"annual001_activity_signal_research",
		"annual001_activity_field_training"
	])["ok"], "week one should commit")
	_expect(state.acknowledge_week_result()["ok"], "week one result should acknowledge")
	_expect(state.commit_week([
		"annual001_activity_companion_drill",
		"annual001_activity_companion_drill",
		"annual001_activity_rest"
	])["ok"], "week two should commit")
	_expect(state.acknowledge_week_result()["ok"], "week two result should acknowledge")
	_expect(state.choose_deployment_decision("annual001_decision_deploy")["ok"], "deployment should be selected")
	_expect(state.complete_research_project("annual001_research_signal_buffer")["ok"], "pre-incident research should complete")
	_expect(state.configure_loadout(
		"annual001_companion_oh_hyun",
		"annual001_skill_emergency_cover",
		["annual001_module_signal_buffer"]
	)["ok"], "loadout should configure")

	var payload: Dictionary = state.build_save_payload()
	_expect(not payload.is_empty(), "preparation should build a save payload")
	if not payload.is_empty():
		_expect(payload.get("save_version") == "annual-mvp-001-save-v1", "save version should match")
		var saved_state := payload.get("state", {}) as Dictionary
		_expect(saved_state.get("phase") == "PREPARATION", "saved phase should be preparation")
		_expect(saved_state.get("run_seed") == 4444, "saved seed should be preserved")

	var path := "user://annual_mvp_001_test.json"
	SaveData.delete_payload(path)
	_expect(SaveData.write_payload(payload, path) == OK, "payload should write atomically")
	var read_payload: Dictionary = SaveData.read_payload(path)
	_expect(_semantic_equal(read_payload, payload), "read payload should equal written values")

	var first := State.new()
	var second := State.new()
	var first_restore: Dictionary = first.restore(config, read_payload)
	var second_restore: Dictionary = second.restore(config, read_payload)
	_expect(first_restore.get("ok", false), "first state should restore")
	_expect(second_restore.get("ok", false), "second state should restore")
	if bool(first_restore.get("ok", false)) and bool(second_restore.get("ok", false)):
		_expect(_semantic_equal(first.get_snapshot(), state.get_snapshot()), "first restored snapshot should match source values")
		_expect(_semantic_equal(second.get_snapshot(), state.get_snapshot()), "second restored snapshot should match source values")
		var adapter_a := Adapter.new()
		var adapter_b := Adapter.new()
		_expect(adapter_a.configure(config, first.get_snapshot(), int(first.get_snapshot()["run_seed"]))["ok"], "first adapter should configure")
		_expect(adapter_b.configure(config, second.get_snapshot(), int(second.get_snapshot()["run_seed"]))["ok"], "second adapter should configure")
		var fake_a := FakeCoreState.new()
		var fake_b := FakeCoreState.new()
		var before := {"turn": 1, "current_pattern_id": "poc001_pattern_false_terminal", "observed_pattern_ids": []}
		var decision_a: Array[Dictionary] = adapter_a.after_omen(fake_a, before, {"success": false})
		var decision_b: Array[Dictionary] = adapter_b.after_omen(fake_b, before, {"success": false})
		_expect(decision_a == decision_b, "same saved seed should reproduce support decision")
		_expect(adapter_a.get_status_lines() == adapter_b.get_status_lines(), "same saved seed should reproduce support status")

	_expect(state.begin_incident()["ok"], "incident should begin")
	_expect(state.build_save_payload().is_empty(), "incident active phase must not save")
	_expect(SaveData.delete_payload(path) == OK, "test save should delete")
	_expect(SaveData.read_payload(path).is_empty(), "deleted save should read empty")
	_finish()

func _semantic_equal(left: Variant, right: Variant) -> bool:
	var left_type := typeof(left)
	var right_type := typeof(right)
	if left_type in [TYPE_INT, TYPE_FLOAT] and right_type in [TYPE_INT, TYPE_FLOAT]:
		return is_equal_approx(float(left), float(right))
	if left_type == TYPE_DICTIONARY and right_type == TYPE_DICTIONARY:
		var left_dict := left as Dictionary
		var right_dict := right as Dictionary
		if left_dict.size() != right_dict.size():
			return false
		for key in left_dict.keys():
			if not right_dict.has(key) or not _semantic_equal(left_dict[key], right_dict[key]):
				return false
		return true
	if left_type == TYPE_ARRAY and right_type == TYPE_ARRAY:
		var left_array := left as Array
		var right_array := right as Array
		if left_array.size() != right_array.size():
			return false
		for index in range(left_array.size()):
			if not _semantic_equal(left_array[index], right_array[index]):
				return false
		return true
	return left == right

func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)

func _finish() -> void:
	if _failures.is_empty():
		print("ANNUAL MVP 001 SAVE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
