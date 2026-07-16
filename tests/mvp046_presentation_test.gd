extends SceneTree


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var registry_script = load("res://scripts/ui/presentation_registry.gd")
	var registry = registry_script.new()
	var failures: Array[String] = []
	if registry.get_expression("agent_kwon_narae", "focus").is_empty():
		failures.append("Kwon Narae focus expression has a fallback")
	if registry.get_expression("unknown_agent", "focus").is_empty():
		failures.append("unknown expression has a fallback")
	if registry.get_expression_index("agent_kwon_narae", "focus") != 1:
		failures.append("focus expression resolves to the focused atlas frame")
	if registry.get_expression_index("agent_kwon_narae", "serious") != 2:
		failures.append("serious expression resolves to the serious atlas frame")
	if registry.get_cutins().size() != 6:
		failures.append("six cut-in definitions are available")
	if registry.get_relationship_cutin("REL-P01-01") != "emotion_closeup":
		failures.append("relationship scene resolves its transient cut-in")
	if registry.get_cutin_label("emotion_closeup").is_empty():
		failures.append("cut-in label is available to the scene")
	var stage_script = load("res://scripts/ui/presentation_stage.gd")
	var stage = stage_script.new()
	stage.present_line({"speaker": "로그", "text": "비교 기록을 확인하세요.", "expression": "focus"})
	if stage.get_display_speaker() != "기록관 아카 · 괴이 기록국 관제 AI":
		failures.append("presentation remaps Log display name without changing source data")
	if stage.get_display_text().is_empty():
		failures.append("presentation keeps dialogue text available")
	if failures.is_empty():
		print("MVP-046 presentation: 9 passed, 0 failed")
		quit(0)
		return
	for failure in failures:
		push_error(failure)
	quit(1)
