extends SceneTree

const GameStateScript := preload("res://scripts/core/afterlife_migrating_game_state.gd")
const TransactionScript := preload("res://scripts/core/afterlife_migration_transaction.gd")

var _failures: Array[String] = []


func _init() -> void:
	var primary := OS.get_environment("AFTERLIFE_QA_PRIMARY")
	var source_checksum := OS.get_environment("AFTERLIFE_QA_EXPECTED_HASH").to_lower()
	_expect(GameStateScript is Script, "afterlife_migrating_game_state.gd failed to load")
	_expect(not primary.is_empty(), "locked primary path missing")
	_expect(not source_checksum.is_empty(), "locked source_checksum missing")
	if primary.is_empty() or source_checksum.is_empty():
		_finish()
		return

	var result: Dictionary = TransactionScript.new().prepare(
		primary,
		{"source_checksum": source_checksum},
		_target_payload(),
		Callable(self, "_validate_target")
	)
	var code := String(result.get("code", ""))
	var allowed_codes := [
		"MIGRATION_VALIDATION_FAILED",
		"SOURCE_CHANGED",
		"WRITE_FAILED",
		"REPLACE_FAILED"
	]
	_expect(code in allowed_codes, "locked source unexpectedly entered migration: %s" % code)
	_expect(String(result.get("state", "NEW")) not in ["PREPARED", "COMMITTED_PENDING_RUNTIME_APPLY"], "locked source created an active transaction")
	print("AFTERLIFE WINDOWS LOCKED FILE: %s" % code)
	_finish()


func _target_payload() -> Dictionary:
	return {
		"save_version": "mvp-040",
		"episode_id": "episode_001_afterlife_station",
		"content_contract_id": "afterlife-station-canon-v2",
		"afterlife_canon_v2": {"manual": {"filled_slots": {}, "evidence_records": []}},
		"migration_history": [{"migration_id": "afterlife-station-canon-v2-001"}]
	}


func _validate_target(payload: Dictionary) -> bool:
	return (
		String(payload.get("save_version", "")) == "mvp-040"
		and String(payload.get("content_contract_id", "")) == "afterlife-station-canon-v2"
	)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("AFTERLIFE WINDOWS LOCKED FILE: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
