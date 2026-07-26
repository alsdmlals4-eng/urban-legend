extends SceneTree

const BaseData = preload("res://scripts/poc/annual_mvp_001/annual_mvp_001_data.gd")
const State = preload("res://scripts/poc/annual_mvp_002/annual_mvp_002_state.gd")
const Scene = preload("res://scenes/poc/annual_mvp_002/annual_mvp_002_scene.tscn")

var _failures: Array[String] = []
var _base_config: Dictionary = {}


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_base_config = BaseData.load_config("res://data/poc/annual_mvp_001/spring_vertical_slice.json")
	_test_restore_sanitizes_active_research()
	await _test_visible_support_selection()
	_finish()


func _new_state(seed: int) -> RefCounted:
	var state: RefCounted = State.new()
	var started: Dictionary = state.start(_base_config.duplicate(true), seed)
	_expect(bool(started.get("ok", false)), "state should start")
	return state


func _test_restore_sanitizes_active_research() -> void:
	var state: RefCounted = _new_state(9201)
	var payload: Dictionary = state.build_save_payload()
	var extension := (payload.get("state", {}) as Dictionary).get("annual_mvp_002", {}) as Dictionary
	extension["completed_research_ids"] = ["annual002_research_field_records"]
	extension["active_research"] = {
		"annual002_research_field_records": {
			"progress": 1,
			"reserved_cost": {"annual002_resource_records": 999},
		},
		"annual002_research_damage_protocol": {
			"progress": -5,
			"reserved_cost": {"annual002_resource_risk_cases": 999},
		},
		"annual002_research_rest_quality": {
			"progress": 999,
			"reserved_cost": {"annual002_resource_risk_cases": 999},
		},
		"annual002_research_readiness_training": {
			"progress": 1,
			"reserved_cost": {"annual002_resource_institution": 999},
		},
	}
	var restored: RefCounted = _new_state(9202)
	_expect(bool(restored.restore(_base_config.duplicate(true), payload).get("ok", false)), "tampered active research save should restore safely")
	var restored_extension := restored.get_snapshot().get("annual_mvp_002", {}) as Dictionary
	var active := restored_extension.get("active_research", {}) as Dictionary
	_expect(active.size() <= 2, "restored active research must respect max two")
	_expect(not active.has("annual002_research_field_records"), "completed research must not remain active")
	if active.has("annual002_research_damage_protocol"):
		var damage := active["annual002_research_damage_protocol"] as Dictionary
		_expect(int(damage.get("progress", -1)) == 0, "negative progress must clamp to zero")
		_expect((damage.get("reserved_cost", {}) as Dictionary) == {"annual002_resource_risk_cases": 2}, "reserved cost must use canonical node cost")
	if active.has("annual002_research_rest_quality"):
		var rest := active["annual002_research_rest_quality"] as Dictionary
		_expect(int(rest.get("progress", -1)) == 1, "completed-or-higher progress must clamp below completion threshold")
		_expect((rest.get("reserved_cost", {}) as Dictionary) == {"annual002_resource_risk_cases": 2}, "rest reserved cost must use canonical node cost")


func _test_visible_support_selection() -> void:
	var scene := Scene.instantiate() as Control
	root.add_child(scene)
	await process_frame
	await process_frame
	scene.call("debug_force_preparation_phase")
	await process_frame
	_expect(bool((scene.call("debug_toggle_companion", "annual002_companion_ohyun", true) as Dictionary).get("ok", false)), "Ohyun should be selectable")
	var option := scene.find_child("SupportOption_annual002_companion_ohyun", true, false) as OptionButton
	_expect(option != null, "preparation UI must expose Ohyun support selector")
	if option != null:
		_expect(not option.disabled, "selected companion support selector must be enabled")
		var active_ids: Array[String] = []
		var disabled_ids: Array[String] = []
		for index in range(option.item_count):
			var support_id := String(option.get_item_metadata(index))
			if support_id.is_empty():
				continue
			if option.is_item_disabled(index):
				disabled_ids.append(support_id)
			else:
				active_ids.append(support_id)
		_expect(active_ids.has("annual002_support_damage_buffer"), "damage buffer must be selectable")
		_expect(active_ids.has("annual002_support_risk_dampening"), "risk dampening must be selectable")
		_expect(active_ids.size() == 2, "only two runtime-supported public skills may be enabled")
		_expect(bool((scene.call("debug_set_support", "annual002_companion_ohyun", "annual002_support_risk_dampening") as Dictionary).get("ok", false)), "visible selector path must support risk dampening")
		var snapshot := scene.call("debug_snapshot") as Dictionary
		var equipped := ((snapshot.get("annual_mvp_002", {}) as Dictionary).get("equipped_support_skills", {}) as Dictionary)
		_expect(String(equipped.get("annual002_companion_ohyun", "")) == "annual002_support_risk_dampening", "selected public support must reach state")
	if is_instance_valid(scene):
		scene.queue_free()
	await process_frame


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("ANNUAL MVP 002 REVIEW FOLLOW-UP: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
