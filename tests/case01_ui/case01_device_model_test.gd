extends SceneTree

const CATALOG_PATH := "res://scripts/ui/case01_device_catalog.gd"
const ADAPTER_PATH := "res://scripts/ui/case01_device_data_adapter.gd"

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var catalog_script: Variant = load(CATALOG_PATH)
	var adapter_script: Variant = load(ADAPTER_PATH)
	_expect(catalog_script is Script, "CASE-01 device catalog must exist")
	_expect(adapter_script is Script, "CASE-01 device adapter must exist")

	if catalog_script is Script:
		var catalog = (catalog_script as Script).new()
		var tabs: Array = catalog.get_tabs()
		_expect(tabs.map(func(item): return String(item.get("id", ""))) == ["records", "manual", "map"], "shell tabs must be records/manual/map only")
		var sections: Array = catalog.get_manual_sections()
		_expect(sections.map(func(item): return String(item.get("id", ""))) == [
			"section_afterlife_occurrence_condition",
			"section_afterlife_victim_link",
			"section_afterlife_forbidden_action",
			"section_afterlife_rescue_procedure",
			"section_afterlife_recovery_response"
		], "manual section order must match approved five-section projection")
		var editable_slot_total := 0
		for section_value in sections:
			if typeof(section_value) == TYPE_DICTIONARY:
				editable_slot_total += (section_value as Dictionary).get("slot_ids", []).size()
		_expect(editable_slot_total == 14, "five-section projection must preserve Canon v2 4/5/5 editable slots")
		_expect((sections[4] as Dictionary).get("slot_ids", []).is_empty(), "recovery response section must be read-only")
		var keywords: Array = catalog.get_keywords()
		_expect(keywords.size() == 27, "CASE-01 presentation catalog must expose the approved 27 keyword candidates")
		var keyword_ids: Dictionary = {}
		for keyword_value in keywords:
			if typeof(keyword_value) != TYPE_DICTIONARY:
				continue
			var keyword := keyword_value as Dictionary
			var keyword_id := String(keyword.get("id", ""))
			_expect(not keyword_ids.has(keyword_id), "keyword IDs must be unique: %s" % keyword_id)
			keyword_ids[keyword_id] = true
			_expect(not String(keyword.get("label", "")).contains("[변조]"), "pre-reveal display labels must not expose mutation lineage")
			_expect(not keyword.has("correct"), "presentation keyword catalog must not own correctness")
			_expect(not keyword.has("fitness"), "presentation keyword catalog must not own slot fitness")
		var locations: Array = catalog.get_locations()
		_expect(locations.size() == 3, "CASE-01 presentation travel must reuse exactly three approved location groups")
		catalog.free()

	if adapter_script is Script:
		var adapter = (adapter_script as Script).new()
		for method_name in [
			"bind_game_state",
			"is_supported",
			"get_shell_snapshot",
			"get_records_snapshot",
			"get_manual_snapshot",
			"get_map_snapshot",
			"request_manual_slot_assignment",
			"request_manual_slot_clear"
		]:
			_expect(adapter.has_method(method_name), "device adapter missing public API: %s" % method_name)
		adapter.free()

	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("CASE01 DEVICE MODEL: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
