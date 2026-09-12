extends SceneTree

var failures: Array[String] = []

func _init() -> void:
	call_deferred("run")

func check(value: bool, message: String) -> void:
	if not value:
		failures.append(message)

func labels(node: Node) -> String:
	var text := ""
	if node is Label:
		text += node.text + "\n"
	if node is RichTextLabel:
		text += node.get_parsed_text() + "\n"
	for child in node.get_children():
		text += labels(child)
	return text

func run() -> void:
	var state := root.get_node("GameState")
	var guard = load("res://tests/test_save_guard.gd").new()
	if not guard.prepare(state.get_save_file_path()).is_empty():
		quit(1)
		return
	state.reset_run_state()
	state.start_episode_from_preparation("res://data/episodes/episode_002_red_umbrella_alley.json")
	check(state.set_campaign_planned_case("episode_002_red_umbrella_alley"), "prepare M04 as the selected case")
	check(state.begin_campaign_operation("episode_002_red_umbrella_alley"), "record the actual daily-case dispatch context")
	state.collect_clue("clue_repeating_alley_sign")
	var manual: Dictionary = state.get_current_episode().investigation_manual
	var page: Dictionary = manual.pages[0]
	var slot := ""
	for segment in page.deduction_segments:
		if segment.get("kind") == "slot":
			slot = segment.slot_id
			break
	check(state.set_manual_draft_slot(manual, page.id, slot, "kw_m04_rain_sign_actual_exit", state.get_collected_clue_ids()).get("ok", false), "write alternate interpretation")
	change_scene_to_file("res://scenes/battle_scene.tscn")
	for i in range(6):
		await process_frame
	var battle := current_scene
	var pattern: Dictionary = state.get_current_episode().recovery_patterns[0]
	battle.set("_current_pattern", pattern)
	battle.set("_turn_locked", false)
	battle.call("_select_pattern_response", pattern.responses[1])
	var trial: Dictionary = state.get_recovery_pattern_learning().get(pattern.id, {})
	check(not trial.get("correct", true), "actual wrong response remains a failed response")
	check(str(trial.get("authored_draft_lines", [])).contains("실제 출구 방향을 표시함"), "actual response captures the player's draft even in direct-response M04")
	check(str(trial.get("reason", "")).contains("되감긴다"), "authored observable consequence survives")
	check(state.set_manual_draft_slot(manual, page.id, slot, "kw_m04_rain_sign_reverse_route", state.get_collected_clue_ids()).get("ok", false), "revise interpretation after feedback")
	check(state.load_game(), "reload revised draft and previous trial")
	trial = state.get_recovery_pattern_learning().get(pattern.id, {})
	check(str(trial.get("authored_draft_lines", [])).contains("실제 출구 방향을 표시함"), "editing and reloading cannot rewrite the past trial")
	check(not str(trial.get("authored_draft_lines", [])).contains("피해자가 지나간 순서를 거꾸로 표시함"), "past trial must not acquire the later revision")
	battle.set("_current_pattern", pattern)
	var feedback: String = battle.call("_make_recovery_evidence_text")
	check(feedback.contains("실제 출구 방향을 표시함"), "repeat telegraph exposes the interpretation used at the last attempt")
	check(feedback.contains("세 번째 빗소리에 맞춰 다음 모퉁이로 이동한다"), "repeat telegraph exposes the actual action")
	check(state.get_current_anomaly_manual_record().get("verified_rules", {}).is_empty(), "a recorded draft is not automatically verified")
	state.save_recovery_result(false, "control_failure", 0)
	change_scene_to_file("res://scenes/result_scene.tscn")
	for i in range(6):
		await process_frame
	check(labels(current_scene).contains("실제 출구 방향을 표시함"), "failed result exposes historical interpretation")
	check(labels(current_scene).contains("되감긴다"), "failed result exposes counterevidence")
	# The formatter distinguishes pre-feature saves from explicitly unwritten drafts.
	var formatter = load("res://scripts/ui/recovery_learning_formatter.gd")
	check(formatter.format_trial({"response_id": "wait"}).contains("이전 기록"), "old records retain an explicit unknown draft instead of today's draft")
	check(formatter.format_trial({"authored_draft_lines": []}).contains("작성한 해석 없음"), "empty drafts are not reconstructed as selected answers")
	# Success preserves the same trial in the existing completed report.
	state.save_recovery_result(true, "core_recovered", 100)
	check(state.record_current_case_report(), "save completed report with historical trial")
	check(state.load_game(), "completed report round trip")
	var reports: Array = state.get_completed_case_reports()
	check(not reports.is_empty(), "completed report remains available")
	if not reports.is_empty():
		var report: Dictionary = reports.back()
		var report_trials: Dictionary = report.get("recovery_pattern_learning", {})
		check(str(report_trials).contains("실제 출구 방향을 표시함"), "report freezes the trial rather than the revised draft")
		var database = load("res://scripts/ui/database_view.gd").new()
		var detail := VBoxContainer.new()
		root.add_child(detail)
		database.call("_show_completed_case_report", report, detail)
		check(labels(detail).contains("실제 출구 방향을 표시함"), "archived report UI consumes the stored trial")
		detail.queue_free()
		database.free()
	var pages: Array = current_scene.call("_make_m04_vignette_pages")
	check(str(pages.back()).contains("실제 출구 방향을 표시함"), "successful M04 sequence includes historical trial after the four narrative pages")
	change_scene_to_file("res://scenes/result_scene.tscn")
	for i in range(6):
		await process_frame
	var next := current_scene.find_child("ContinueButton", true, false) as Button
	check(next != null, "success opens the real sequential M04 result")
	if next != null:
		root.get_node("CanonV2RuntimeBridge").call("_sync_current_scene")
		for i in range(3):
			await process_frame
		var strip := current_scene.find_child("RuleStripPanel", true, false) as Control
		var case_title := current_scene.get_node("M04NarrativeResult").get_child(0) as Control
		check(strip != null and not strip.get_global_rect().intersects(case_title.get_global_rect()), "case heading must not sit underneath the operation strip")
		for i in range(4):
			next.pressed.emit()
			await process_frame
			if i == 2:
				var return_button := current_scene.find_child("PreparationButton", true, false) as Button
				check(return_button != null and return_button.visible, "trial review is optional after the original four narrative pages")
		var body := current_scene.find_child("VignetteBody", true, false) as Label
		check(body != null and body.text.contains("실제 출구 방향을 표시함"), "next-record inputs reach the actual historical draft page")
		var scroll := current_scene.find_child("VignetteBodyScroll", true, false) as ScrollContainer
		check(scroll != null and scroll.size.y > 0, "long trial records have a usable scrolling viewport")
		if "--capture" in OS.get_cmdline_user_args():
			await RenderingServer.frame_post_draw
			var path := ProjectSettings.globalize_path("res://.artifacts/daily-case-20260912/manual-trial-feedback.png")
			check(root.get_texture().get_image().save_png(path) == OK, "capture actual success trial review")
		if body != null and scroll != null:
			body.text = body.text.repeat(12)
			for i in range(4):
				await process_frame
			scroll.scroll_vertical = 100000
			await process_frame
			check(scroll.scroll_vertical > 0, "oversized trial content remains scrollable instead of clipped")
			var return_button := current_scene.find_child("PreparationButton", true, false) as Control
			check(return_button.get_global_rect().end.y <= root.size.y, "long content cannot push the return action off screen")
	# Additive metadata must not be required to load older trial records.
	state.recovery_pattern_learning = {"pattern_red_rain_rewind": {"pattern_id": "pattern_red_rain_rewind", "response_id": "wait", "correct": true, "reason": "legacy", "attempts": 2}}
	check(state.save_game() and state.load_game(), "old-shape trial round trip remains loadable")
	var legacy: Dictionary = state.get_recovery_pattern_learning().get("pattern_red_rain_rewind", {})
	check(not legacy.has("authored_draft_lines") and int(legacy.get("attempts", 0)) == 2, "legacy load does not fabricate historical draft metadata")
	check(state.start_episode_from_preparation("res://data/episodes/episode_001_afterlife_station.json"), "start another case without sharing current learning")
	check(state.get_recovery_pattern_learning().is_empty(), "new case does not inherit M04 trial records")
	check(str(state.get_completed_case_reports()).contains("실제 출구 방향을 표시함"), "completed M04 archive survives changing cases")
	current_scene.queue_free()
	for i in range(3):
		await process_frame
	check(guard.restore().is_empty(), "restore isolated save")
	for message in failures:
		push_error(message)
	print("Manual trial feedback: ", failures.size(), " failures")
	quit(0 if failures.is_empty() else 1)
