extends SceneTree

const PlaytestLog = preload("res://scripts/poc/core_mvp_001/core_mvp_001_playtest_log.gd")

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var log := PlaytestLog.new()
	log.start_session("session-test", "core-mvp-001-test", 1001)
	var events := log.get_events()
	_expect(events.size() == 1, "start_session should record poc_started")
	_expect(events[0].get("event") == "poc_started", "first event should be poc_started")
	_expect(events[0].get("sequence") == 1, "sequence should start at one")

	var payload := {"choice_id": "poc001_choice_move_before_end", "valid": false}
	log.record("manual_record_linked", payload)
	payload["valid"] = true
	events = log.get_events()
	_expect(events.size() == 2, "record should append an event")
	_expect(events[1].get("sequence") == 2, "sequence should increment")
	_expect(events[1].get("payload", {}).get("valid") == false, "payload should be deep-copied")

	var path := "user://core_mvp_001_playtest_test.jsonl"
	var error := log.write_jsonl(path)
	_expect(error == OK, "JSONL export should succeed")
	var file := FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "JSONL export should be readable")
	if file != null:
		var lines: Array[String] = []
		while not file.eof_reached():
			var line := file.get_line()
			if not line.is_empty():
				lines.append(line)
		_expect(lines.size() == 2, "JSONL should contain one object per event")
		for line in lines:
			_expect(typeof(JSON.parse_string(line)) == TYPE_DICTIONARY, "each JSONL line should be an object")
	file = null
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("CORE MVP 001 PLAYTEST LOG: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
