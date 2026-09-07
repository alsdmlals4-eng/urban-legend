extends SceneTree

const SIDECAR_PATH := "res://data/episodes/episode_001_afterlife_station_canon_v2.json"
const POLICY_PATH := "res://scripts/core/manual_keyword_composition_policy.gd"

var _failures: Array[String] = []


func _init() -> void:
	_expect(FileAccess.file_exists(SIDECAR_PATH), "M01 Canon V2 sidecar missing")
	_expect(FileAccess.file_exists(POLICY_PATH), "manual composition policy missing")
	if FileAccess.file_exists(SIDECAR_PATH) and FileAccess.file_exists(POLICY_PATH):
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(SIDECAR_PATH))
		_expect(typeof(parsed) == TYPE_DICTIONARY, "M01 Canon V2 sidecar did not parse")
		var script_value: Variant = load(POLICY_PATH)
		_expect(script_value is Script, "manual composition policy failed to load")
		if typeof(parsed) == TYPE_DICTIONARY and script_value is Script:
			_test_player_authored_manual_contract(parsed as Dictionary, (script_value as Script).new())
	_finish()


func _test_player_authored_manual_contract(sidecar: Dictionary, policy: Object) -> void:
	var canonical_value: Variant = sidecar.get("canonical_v2")
	_expect(typeof(canonical_value) == TYPE_DICTIONARY, "canonical_v2 missing")
	if typeof(canonical_value) != TYPE_DICTIONARY:
		return
	var canonical := canonical_value as Dictionary
	var manual_value: Variant = canonical.get("investigation_manual")
	_expect(typeof(manual_value) == TYPE_DICTIONARY, "investigation manual missing")
	if typeof(manual_value) != TYPE_DICTIONARY:
		return
	var manual := manual_value as Dictionary
	var validation: Dictionary = policy.validate_manual(manual)
	_expect(bool(validation.get("ok", false)), "M01 manual is structurally invalid")
	var candidates_value: Variant = manual.get("candidate_keywords")
	_expect(typeof(candidates_value) == TYPE_ARRAY and not (candidates_value as Array).is_empty(), "M01 manual has no player-visible candidates")
	var candidates_per_page := _candidate_count_by_page(candidates_value)
	for page_value in manual.get("pages", []) as Array:
		if typeof(page_value) != TYPE_DICTIONARY:
			continue
		var page := page_value as Dictionary
		var page_id := String(page.get("id", ""))
		_expect(int(candidates_per_page.get(page_id, 0)) >= 2, "manual page lacks a player choice pool: %s" % page_id)
		var segments_value: Variant = page.get("deduction_segments")
		_expect(typeof(segments_value) == TYPE_ARRAY and not (segments_value as Array).is_empty(), "manual page lacks deduction segments: %s" % page_id)
		if typeof(segments_value) == TYPE_ARRAY:
			var segment_slots := _slot_ids_from_segments(segments_value as Array)
			for slot_value in page.get("slot_ids", []) as Array:
				_expect(segment_slots.has(String(slot_value)), "manual sentence does not expose declared slot: %s" % String(slot_value))
	var normal_clear_value: Variant = (canonical.get("result_contract", {}) as Dictionary).get("normal_clear", {})
	_expect(typeof(normal_clear_value) == TYPE_DICTIONARY, "normal clear contract missing")
	if typeof(normal_clear_value) == TYPE_DICTIONARY:
		_expect(not bool((normal_clear_value as Dictionary).get("reveal_complete_manual", true)), "normal clear still reveals an unwritten complete manual")


func _candidate_count_by_page(value: Variant) -> Dictionary:
	var counts: Dictionary = {}
	if typeof(value) != TYPE_ARRAY:
		return counts
	for candidate_value in value as Array:
		if typeof(candidate_value) != TYPE_DICTIONARY:
			continue
		var page_id := String((candidate_value as Dictionary).get("page_id", ""))
		counts[page_id] = int(counts.get(page_id, 0)) + 1
	return counts


func _slot_ids_from_segments(segments: Array) -> Dictionary:
	var slot_ids: Dictionary = {}
	for segment_value in segments:
		if typeof(segment_value) != TYPE_DICTIONARY:
			continue
		var segment := segment_value as Dictionary
		if String(segment.get("kind", "")) == "slot":
			var slot_id := String(segment.get("slot_id", ""))
			if not slot_id.is_empty():
				slot_ids[slot_id] = true
	return slot_ids


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("M01 MANUAL CANON CONTRACT: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
