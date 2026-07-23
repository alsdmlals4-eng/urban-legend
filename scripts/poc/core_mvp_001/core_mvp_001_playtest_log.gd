class_name CoreMvp001PlaytestLog
extends RefCounted

var _events: Array[Dictionary] = []
var _session_id := ""
var _build_label := ""
var _run_seed := 0


func start_session(session_id: String, build_label: String, run_seed: int) -> void:
	_events.clear()
	_session_id = session_id
	_build_label = build_label
	_run_seed = run_seed
	record("poc_started", {
		"session_id": session_id,
		"build_label": build_label,
		"run_seed": run_seed
	})


func record(event_name: String, payload: Dictionary = {}) -> void:
	if event_name == "poc_started" and not _events.is_empty():
		return
	_events.append({
		"sequence": _events.size() + 1,
		"event": event_name,
		"session_id": _session_id,
		"build_label": _build_label,
		"run_seed": _run_seed,
		"unix_time_msec": Time.get_unix_time_from_system() * 1000.0,
		"payload": payload.duplicate(true)
	})


func get_events() -> Array[Dictionary]:
	return _events.duplicate(true)


func write_jsonl(path: String) -> Error:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	for event in _events:
		file.store_line(JSON.stringify(event))
	file.flush()
	return OK
