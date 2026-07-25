extends SceneTree

const Data = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_data.gd")
const State = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_state.gd")
const SaveData = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_save_data.gd")
const Adapter = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_incident_adapter.gd")

class FakeCoreState:
	extends RefCounted
	var calls: Array[Dictionary] = []
	func apply_external_support(source_id: String, event_key: String, effect: Dictionary) -> Dictionary:
		calls.append({"source_id": source_id, "event_key": event_key, "effect": effect.duplicate(true)})
		return {"ok": true, "state_changed": true, "events": [], "snapshot": {}}

func _init() -> void:
	var config: Dictionary = Data.load_config("res://data/poc/annual_mvp_001/spring_vertical_slice.json")
	var state := State.new()
	assert(state.start(config, 4444)["ok"])
	assert(state.commit_week([
		"annual001_activity_signal_research",
		"annual001_activity_signal_research",
		"annual001_activity_field_training"
	])["ok"])
	assert(state.acknowledge_week_result()["ok"])
	assert(state.commit_week([
		"annual001_activity_companion_drill",
		"annual001_activity_companion_drill",
		"annual001_activity_rest"
	])["ok"])
	assert(state.acknowledge_week_result()["ok"])
	assert(state.choose_deployment_decision("annual001_decision_deploy")["ok"])
	assert(state.complete_research_project("annual001_research_signal_buffer")["ok"])
	assert(state.configure_loadout(
		"annual001_companion_oh_hyun",
		"annual001_skill_emergency_cover",
		["annual001_module_signal_buffer"]
	)["ok"])

	var payload: Dictionary = state.build_save_payload()
	assert(payload["save_version"] == "annual-mvp-001-save-v1")
	assert(payload["state"]["phase"] == "PREPARATION")
	assert(payload["state"]["run_seed"] == 4444)
	var path := "user://annual_mvp_001_test.json"
	SaveData.delete_payload(path)
	assert(SaveData.write_payload(payload, path) == OK)
	assert(SaveData.read_payload(path) == payload)

	var first := State.new()
	var second := State.new()
	assert(first.restore(config, SaveData.read_payload(path))["ok"])
	assert(second.restore(config, SaveData.read_payload(path))["ok"])
	assert(first.get_snapshot() == state.get_snapshot())
	assert(second.get_snapshot() == state.get_snapshot())

	var adapter_a := Adapter.new()
	var adapter_b := Adapter.new()
	assert(adapter_a.configure(config, first.get_snapshot(), int(first.get_snapshot()["run_seed"]))["ok"])
	assert(adapter_b.configure(config, second.get_snapshot(), int(second.get_snapshot()["run_seed"]))["ok"])
	var fake_a := FakeCoreState.new()
	var fake_b := FakeCoreState.new()
	var before := {"turn": 1, "current_pattern_id": "poc001_pattern_false_terminal", "observed_pattern_ids": []}
	var decision_a: Array[Dictionary] = adapter_a.after_omen(fake_a, before, {"success": false})
	var decision_b: Array[Dictionary] = adapter_b.after_omen(fake_b, before, {"success": false})
	assert(decision_a == decision_b)
	assert(adapter_a.get_status_lines() == adapter_b.get_status_lines())

	assert(state.begin_incident()["ok"])
	assert(state.build_save_payload().is_empty())
	assert(SaveData.delete_payload(path) == OK)
	assert(SaveData.read_payload(path).is_empty())
	print("ANNUAL MVP 001 SAVE: PASS")
	quit()
