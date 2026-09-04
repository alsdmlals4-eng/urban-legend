extends SceneTree

const REGISTRY_PATH := "res://data/migrations/afterlife_station_canon_v2_id_migration.json"
const SCRIPT_PATH := "res://scripts/data/afterlife_id_migration_registry.gd"

var _failures: Array[String] = []


func _init() -> void:
	_expect(FileAccess.file_exists(REGISTRY_PATH), "ID migration registry JSON missing")
	_expect(FileAccess.file_exists(SCRIPT_PATH), "ID migration registry script missing")
	if FileAccess.file_exists(REGISTRY_PATH) and FileAccess.file_exists(SCRIPT_PATH):
		var script_value: Variant = load(SCRIPT_PATH)
		_expect(script_value is Script, "ID migration registry script failed to load")
		if script_value is Script:
			_test_registry((script_value as Script).new())
	_finish()


func _test_registry(registry: Object) -> void:
	var loaded: Dictionary = registry.load_registry(REGISTRY_PATH)
	_expect(String(loaded.get("code", "")) == "EXACT", "registry must validate exactly")
	var checksum := String(loaded.get("registry_checksum", ""))
	_expect(checksum.length() == 64, "registry checksum must be SHA-256")
	_expect(int(loaded.get("entry_count", 0)) >= 20, "registry coverage is too small")

	var split: Dictionary = registry.map_value(
		"clue_repeating_announcement",
		"unlocked_records",
		true
	)
	_expect(String(split.get("code", "")) == "MAPPED", "split mapping failed")
	_expect(String(split.get("disposition", "")) == "SPLIT", "split disposition missing")
	_expect((split.get("target_ids", []) as Array).size() == 2, "split target count mismatch")
	for target_value in split.get("targets", []) as Array:
		_expect(typeof(target_value) == TYPE_DICTIONARY, "split target must be Dictionary")
		if typeof(target_value) == TYPE_DICTIONARY:
			var target := target_value as Dictionary
			_expect(String(target.get("state", "")) == "migrated_unverified", "split leaked correctness")

	var ticket: Dictionary = registry.map_value("clue_black_ticket", "clues", true)
	_expect(String(ticket.get("disposition", "")) == "HISTORICAL_ONLY", "black ticket must remain historical")
	_expect(not bool(ticket.get("runtime_apply", true)), "historical black ticket executed")

	var discarded: Dictionary = registry.map_value("pattern_station_ticket_imprint", "recovery", {})
	_expect(String(discarded.get("disposition", "")) == "DISCARD_SEMANTICS", "ticket pattern semantics revived")
	_expect((discarded.get("target_ids", []) as Array).is_empty(), "discarded semantics received targets")

	var unknown: Dictionary = registry.map_value("unknown_legacy_id", "flags", true)
	_expect(String(unknown.get("code", "")) == "UNMAPPED_LEGACY_ID", "unknown ID must be preserved")
	_expect(not bool(unknown.get("runtime_apply", true)), "unknown ID executed")
	var orphan := unknown.get("orphan", {}) as Dictionary
	_expect(String(orphan.get("id", "")) == "unknown_legacy_id", "orphan ID lost")
	_expect(String(orphan.get("source_location", "")) == "flags", "orphan provenance lost")

	var first: Dictionary = registry.map_value("clue_staff_room_log", "clues", true)
	var effect_id := String(first.get("effect_id", ""))
	_expect(not effect_id.is_empty(), "effect_id missing")
	var second: Dictionary = registry.map_value(
		"clue_staff_room_log",
		"clues",
		true,
		{effect_id: true}
	)
	_expect(String(second.get("code", "")) == "ALREADY_APPLIED", "effect applied twice")
	_expect(not bool(second.get("runtime_apply", true)), "duplicate effect executed")

	var history: Dictionary = registry.make_history_entry("mvp-039", "mvp-040", [effect_id])
	_expect(String(history.get("migration_id", "")) == "afterlife-station-canon-v2-001", "migration ID mismatch")
	_expect(String(history.get("registry_checksum", "")) == checksum, "history checksum mismatch")
	_expect(String(history.get("source_version", "")) == "mvp-039", "history source missing")
	_expect(String(history.get("target_version", "")) == "mvp-040", "history target missing")
	_expect((history.get("effect_ids", []) as Array) == [effect_id], "history effect IDs mismatch")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("AFTERLIFE ID MIGRATION REGISTRY: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
