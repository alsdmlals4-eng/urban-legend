extends SceneTree

const Scene = preload("res://scenes/poc/annual_mvp_002/annual_mvp_002_scene.tscn")

var _failures: Array[String] = []
var _scene: Control


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_scene = Scene.instantiate() as Control
	root.add_child(_scene)
	await process_frame
	await process_frame
	_test_named_controls_and_preview()
	_test_undo_clear_copy_and_templates()
	_test_week_causal_summary()
	_test_companion_limit_and_support_transparency()
	_test_equipment_family_validation()
	_finish()


func _test_named_controls_and_preview() -> void:
	for node_name in (
		[
			"ActivityPreviewLabel",
			"CopyLastWeekButton",
			"UndoPlanButton",
			"ClearPlanButton",
			"Template1SaveButton",
			"Template1ApplyButton",
			"WeekCausalSummaryLabel",
			"SupportStatusLabel",
			"EquipmentOption",
			"ModuleOption",
			"CompanionCard_annual002_companion_ohyun",
			"CompanionCard_annual002_companion_han_serin",
			"CompanionCard_annual002_companion_park_doyun",
		]
	):
		_expect(_scene.find_child(String(node_name), true, false) != null, "missing control: %s" % node_name)
	var result: Dictionary = _scene.debug_set_plan([
		"annual001_activity_observation_drill",
		"annual001_activity_interview_duty",
	])
	_expect(result.get("ok", false), "valid preview plan should apply")
	var preview := _scene.find_child("ActivityPreviewLabel", true, false) as Label
	_expect(preview.text.contains("사용 4/7일"), "preview should show used days")
	_expect(preview.text.contains("남은 3일"), "preview should show remaining days")
	_expect(preview.text.contains("피로"), "preview should show aggregate fatigue")
	_expect(preview.text.contains("기관 지원"), "preview should show institution effect")


func _test_undo_clear_copy_and_templates() -> void:
	_expect(_scene.debug_save_template(1).get("ok", false), "template 1 should save")
	_expect(_scene.debug_clear_plan().get("ok", false), "plan should clear")
	_expect((_scene.debug_plan_ids() as Array).is_empty(), "clear should empty plan")
	_expect(_scene.debug_apply_template(1).get("ok", false), "template 1 should apply")
	_expect((_scene.debug_plan_ids() as Array).size() == 2, "template should restore two activities")
	_expect(_scene.debug_undo_plan().get("ok", false), "template apply should be undoable")
	_expect((_scene.debug_plan_ids() as Array).is_empty(), "undo should restore cleared plan")
	var missing_copy: Dictionary = _scene.debug_copy_last_week()
	_expect(not missing_copy.get("ok", false), "copy should explain when no prior week exists")


func _test_week_causal_summary() -> void:
	_expect(_scene.debug_set_plan([
		"annual001_activity_field_training",
		"annual001_activity_observation_drill",
		"annual001_activity_rest",
		"annual001_activity_rest",
	]).get("ok", false), "seven-day plan should apply")
	_scene.debug_confirm()
	await process_frame
	var snapshot: Dictionary = _scene.debug_snapshot()
	_expect(snapshot.get("phase", "") == "WEEK_RESULT", "confirming seven days should reach week result")
	var summary := _scene.find_child("WeekCausalSummaryLabel", true, false) as Label
	_expect(summary.text.contains("무엇이 변했는가"), "summary should explain changed values")
	_expect(summary.text.contains("왜 변했는가"), "summary should explain causes")
	_expect(summary.text.contains("다음 주 영향"), "summary should explain future meaning")
	_expect(summary.text.contains("현장 대응 훈련 3일"), "summary should link effect to source activity")


func _test_companion_limit_and_support_transparency() -> void:
	_scene.debug_force_preparation_phase()
	await process_frame
	_expect(_scene.debug_toggle_companion("annual002_companion_ohyun", true).get("ok", false), "Ohyun should select")
	_expect(_scene.debug_toggle_companion("annual002_companion_han_serin", true).get("ok", false), "Han Serin should select")
	var third: Dictionary = _scene.debug_toggle_companion("annual002_companion_park_doyun", true)
	_expect(not third.get("ok", false), "third companion should be rejected")
	_expect((_scene.debug_selected_companions() as Array).size() == 2, "selection should remain at two companions")
	_expect(_scene.debug_set_support("annual002_companion_ohyun", "annual002_support_damage_buffer").get("ok", false), "Ohyun support should set")
	_expect(_scene.debug_set_support("annual002_companion_han_serin", "annual002_support_second_read").get("ok", false), "Han support should set")
	var label := _scene.find_child("SupportStatusLabel", true, false) as Label
	_expect(label.text.contains("확률"), "support status should show probability")
	_expect(label.text.contains("준비도"), "support status should show readiness")
	_expect(label.text.contains("보장"), "support status should show guarantee distance")
	_expect(label.text.contains("비적격") or label.text.contains("적격"), "support status should show eligibility")
	_expect(label.text.contains("정답 가설"), "support status should show fairness boundary")


func _test_equipment_family_validation() -> void:
	_expect(_scene.debug_set_equipment("annual002_equipment_echo_recorder").get("ok", false), "observation equipment should set")
	_expect(_scene.debug_set_module("annual002_module_noise_filter").get("ok", false), "compatible module should set")
	var before: Dictionary = _scene.debug_loadout_snapshot()
	var mismatch: Dictionary = _scene.debug_set_module("annual002_module_impact_gel")
	_expect(not mismatch.get("ok", false), "incompatible module should be rejected")
	_expect(_scene.debug_loadout_snapshot() == before, "rejected module must not mutate loadout")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if is_instance_valid(_scene):
		_scene.queue_free()
	if _failures.is_empty():
		print("ANNUAL MVP 002 SCENE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
