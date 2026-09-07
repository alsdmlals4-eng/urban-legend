extends SceneTree

const POLICY_PATH := "res://scripts/core/manual_keyword_composition_policy.gd"

var _failures: Array[String] = []


func _init() -> void:
	_expect(FileAccess.file_exists(POLICY_PATH), "manual keyword composition policy missing")
	if FileAccess.file_exists(POLICY_PATH):
		var script_value: Variant = load(POLICY_PATH)
		_expect(script_value is Script, "manual keyword composition policy failed to load")
		if script_value is Script:
			var policy = (script_value as Script).new()
			_test_earned_candidate_can_be_placed(policy)
			_test_unearned_and_other_page_candidates_are_rejected(policy)
			_test_duplicate_candidate_is_rejected_without_semantic_judgment(policy)
			_test_stale_saved_drafts_are_filtered_without_source_judgment(policy)
	_finish()


func _test_earned_candidate_can_be_placed(policy: Object) -> void:
	var manual := _manual_fixture()
	var validation: Dictionary = policy.validate_manual(manual)
	_expect(bool(validation.get("ok", false)), "valid manual fixture was rejected")
	var available: Dictionary = policy.available_candidates(manual, "page_a", ["record_a"])
	_expect(bool(available.get("ok", false)), "earned candidate pool could not be read")
	_expect(_candidate_ids(available.get("candidates", [])).has("candidate_a"), "earned page candidate was not available")
	var placement: Dictionary = policy.validate_draft_slot(
		manual,
		"page_a",
		"slot_a",
		"candidate_a",
		["record_a"],
		{}
	)
	_expect(bool(placement.get("ok", false)), "earned candidate should be placeable")
	_expect(String(placement.get("code", "")) == "VALID_PLACEMENT", "earned placement code mismatch")


func _test_unearned_and_other_page_candidates_are_rejected(policy: Object) -> void:
	var manual := _manual_fixture()
	var unavailable: Dictionary = policy.validate_draft_slot(
		manual,
		"page_a",
		"slot_a",
		"candidate_a",
		[],
		{}
	)
	_expect(not bool(unavailable.get("ok", true)), "unearned source candidate was accepted")
	_expect(String(unavailable.get("code", "")) == "SOURCE_RECORD_NOT_EARNED", "unearned source rejection code mismatch")
	var foreign_page: Dictionary = policy.validate_draft_slot(
		manual,
		"page_a",
		"slot_a",
		"candidate_b",
		["record_b"],
		{}
	)
	_expect(not bool(foreign_page.get("ok", true)), "other page candidate was accepted")
	_expect(String(foreign_page.get("code", "")) == "CANDIDATE_PAGE_MISMATCH", "other page rejection code mismatch")


func _test_duplicate_candidate_is_rejected_without_semantic_judgment(policy: Object) -> void:
	var manual := _manual_fixture()
	var duplicate: Dictionary = policy.validate_draft_slot(
		manual,
		"page_a",
		"slot_b",
		"candidate_a",
		["record_a"],
		{"slot_a": "candidate_a"}
	)
	_expect(not bool(duplicate.get("ok", true)), "duplicate candidate was accepted")
	_expect(String(duplicate.get("code", "")) == "DUPLICATE_CANDIDATE_ON_PAGE", "duplicate candidate rejection code mismatch")
	var alternative: Dictionary = policy.validate_draft_slot(
		manual,
		"page_a",
		"slot_b",
		"candidate_c",
		["record_c"],
		{}
	)
	_expect(bool(alternative.get("ok", false)), "earned alternate candidate was semantically rejected")
	_expect(String(alternative.get("code", "")) == "VALID_PLACEMENT", "alternate placement code mismatch")


func _test_stale_saved_drafts_are_filtered_without_source_judgment(policy: Object) -> void:
	_expect(policy.has_method("filter_known_draft_slots"), "manual policy cannot filter stale saved drafts")
	if not policy.has_method("filter_known_draft_slots"):
		return
	var filtered: Dictionary = policy.call("filter_known_draft_slots",
		_manual_fixture(),
		{
			"slot_a": "candidate_a",
			"slot_b": "candidate_a",
			"slot_c": "candidate_b",
			"removed_slot": "candidate_c",
			"slot_a_old": "removed_candidate"
		}
	)
	_expect(bool(filtered.get("ok", false)), "known draft filter failed")
	var drafts := filtered.get("draft_slots", {}) as Dictionary
	_expect(String(drafts.get("slot_a", "")) == "candidate_a", "valid saved draft was dropped")
	_expect(String(drafts.get("slot_c", "")) == "candidate_b", "valid second-page saved draft was dropped")
	_expect(not drafts.has("slot_b"), "same-page duplicate saved draft should be dropped")
	_expect(not drafts.has("removed_slot") and not drafts.has("slot_a_old"), "stale saved ids should be dropped")


func _manual_fixture() -> Dictionary:
	return {
		"pages": [
			{"id": "page_a", "slot_ids": ["slot_a", "slot_b"]},
			{"id": "page_b", "slot_ids": ["slot_c"]}
		],
		"slots": [
			{"id": "slot_a", "page_id": "page_a"},
			{"id": "slot_b", "page_id": "page_a"},
			{"id": "slot_c", "page_id": "page_b"}
		],
		"evidence_records": [
			{"id": "record_a"},
			{"id": "record_b"},
			{"id": "record_c"}
		],
		"candidate_keywords": [
			{"id": "candidate_a", "page_id": "page_a", "source_record_id": "record_a"},
			{"id": "candidate_b", "page_id": "page_b", "source_record_id": "record_b"},
			{
				"id": "candidate_c",
				"page_id": "page_a",
				"source_record_id": "record_c",
				"derived_from_candidate_id": "candidate_a"
			}
		]
	}


func _candidate_ids(value: Variant) -> Array[String]:
	var ids: Array[String] = []
	if typeof(value) != TYPE_ARRAY:
		return ids
	for candidate_value in value as Array:
		if typeof(candidate_value) != TYPE_DICTIONARY:
			continue
		var candidate := candidate_value as Dictionary
		ids.append(String(candidate.get("id", "")))
	return ids


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("MANUAL KEYWORD COMPOSITION POLICY: PASS")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	quit(1)
