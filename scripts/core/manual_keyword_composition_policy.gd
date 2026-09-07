class_name ManualKeywordCompositionPolicy
extends RefCounted

## Validates only structural player-authoring constraints for a case manual.
## It deliberately does not decide whether a candidate is semantically correct.

const FORBIDDEN_CANDIDATE_FIELDS := [
	"answer",
	"answer_id",
	"correct",
	"correct_id",
	"correct_answer_id",
	"true",
	"true_answer_id",
	"mutated",
	"mutation",
	"recommended",
	"recommendation",
	"compatibility_score"
]


func validate_manual(manual: Dictionary) -> Dictionary:
	var pages_value: Variant = manual.get("pages")
	var slots_value: Variant = manual.get("slots")
	var records_value: Variant = manual.get("evidence_records")
	var candidates_value: Variant = manual.get("candidate_keywords")
	if typeof(pages_value) != TYPE_ARRAY or typeof(slots_value) != TYPE_ARRAY:
		return {"ok": false, "code": "PAGES_AND_SLOTS_REQUIRED"}
	if typeof(records_value) != TYPE_ARRAY or typeof(candidates_value) != TYPE_ARRAY:
		return {"ok": false, "code": "EVIDENCE_AND_CANDIDATES_REQUIRED"}

	var page_ids: Dictionary = {}
	for page_value in pages_value as Array:
		if typeof(page_value) != TYPE_DICTIONARY:
			return {"ok": false, "code": "INVALID_PAGE"}
		var page := page_value as Dictionary
		var page_id := String(page.get("id", ""))
		if page_id.is_empty() or page_ids.has(page_id):
			return {"ok": false, "code": "DUPLICATE_OR_MISSING_PAGE_ID", "page_id": page_id}
		page_ids[page_id] = true

	var slot_pages: Dictionary = {}
	for slot_value in slots_value as Array:
		if typeof(slot_value) != TYPE_DICTIONARY:
			return {"ok": false, "code": "INVALID_SLOT"}
		var slot := slot_value as Dictionary
		var slot_id := String(slot.get("id", ""))
		var slot_page_id := String(slot.get("page_id", ""))
		if slot_id.is_empty() or slot_pages.has(slot_id):
			return {"ok": false, "code": "DUPLICATE_OR_MISSING_SLOT_ID", "slot_id": slot_id}
		if not page_ids.has(slot_page_id):
			return {"ok": false, "code": "UNKNOWN_SLOT_PAGE", "slot_id": slot_id}
		slot_pages[slot_id] = slot_page_id

	var record_ids: Dictionary = {}
	for record_value in records_value as Array:
		if typeof(record_value) != TYPE_DICTIONARY:
			return {"ok": false, "code": "INVALID_EVIDENCE_RECORD"}
		var record_id := String((record_value as Dictionary).get("id", ""))
		if record_id.is_empty() or record_ids.has(record_id):
			return {"ok": false, "code": "DUPLICATE_OR_MISSING_RECORD_ID", "record_id": record_id}
		record_ids[record_id] = true

	var candidate_ids: Dictionary = {}
	var candidate_pages: Dictionary = {}
	var candidate_sources: Dictionary = {}
	for candidate_value in candidates_value as Array:
		if typeof(candidate_value) != TYPE_DICTIONARY:
			return {"ok": false, "code": "INVALID_CANDIDATE"}
		var candidate := candidate_value as Dictionary
		var forbidden_field := _find_forbidden_candidate_field(candidate)
		if not forbidden_field.is_empty():
			return {"ok": false, "code": "FORBIDDEN_CANDIDATE_FIELD", "field": forbidden_field}
		var candidate_id := String(candidate.get("id", ""))
		var candidate_page_id := String(candidate.get("page_id", ""))
		var source_record_id := String(candidate.get("source_record_id", ""))
		if candidate_id.is_empty() or candidate_ids.has(candidate_id):
			return {"ok": false, "code": "DUPLICATE_OR_MISSING_CANDIDATE_ID", "candidate_id": candidate_id}
		if not page_ids.has(candidate_page_id):
			return {"ok": false, "code": "UNKNOWN_CANDIDATE_PAGE", "candidate_id": candidate_id}
		if not record_ids.has(source_record_id):
			return {
				"ok": false,
				"code": "UNKNOWN_CANDIDATE_SOURCE_RECORD",
				"candidate_id": candidate_id,
				"source_record_id": source_record_id
			}
		candidate_ids[candidate_id] = true
		candidate_pages[candidate_id] = candidate_page_id
		candidate_sources[candidate_id] = source_record_id

	return {
		"ok": true,
		"code": "VALID_MANUAL",
		"page_ids": page_ids,
		"slot_pages": slot_pages,
		"record_ids": record_ids,
		"candidate_ids": candidate_ids,
		"candidate_pages": candidate_pages,
		"candidate_sources": candidate_sources
	}


func available_candidates(manual: Dictionary, page_id: String, earned_record_ids_value: Variant) -> Dictionary:
	var validation := validate_manual(manual)
	if not bool(validation.get("ok", false)):
		return validation
	if not (validation.get("page_ids", {}) as Dictionary).has(page_id):
		return {"ok": false, "code": "UNKNOWN_PAGE", "page_id": page_id}
	var earned := _unique_string_set(earned_record_ids_value)
	var available: Array[Dictionary] = []
	for candidate_value in manual.get("candidate_keywords", []) as Array:
		var candidate := candidate_value as Dictionary
		if String(candidate.get("page_id", "")) != page_id:
			continue
		if not earned.has(String(candidate.get("source_record_id", ""))):
			continue
		available.append(candidate.duplicate(true))
	return {"ok": true, "code": "CANDIDATES_AVAILABLE", "candidates": available}


func validate_draft_slot(
	manual: Dictionary,
	page_id: String,
	slot_id: String,
	candidate_id: String,
	earned_record_ids_value: Variant,
	draft_slots_value: Variant
) -> Dictionary:
	var validation := validate_manual(manual)
	if not bool(validation.get("ok", false)):
		return validation
	var slot_pages := validation.get("slot_pages", {}) as Dictionary
	if not slot_pages.has(slot_id):
		return {"ok": false, "code": "UNKNOWN_SLOT", "slot_id": slot_id}
	if String(slot_pages.get(slot_id, "")) != page_id:
		return {"ok": false, "code": "SLOT_PAGE_MISMATCH", "slot_id": slot_id}
	var candidate_pages := validation.get("candidate_pages", {}) as Dictionary
	if not candidate_pages.has(candidate_id):
		return {"ok": false, "code": "UNKNOWN_CANDIDATE", "candidate_id": candidate_id}
	if String(candidate_pages.get(candidate_id, "")) != page_id:
		return {"ok": false, "code": "CANDIDATE_PAGE_MISMATCH", "candidate_id": candidate_id}
	var candidate_sources := validation.get("candidate_sources", {}) as Dictionary
	var source_record_id := String(candidate_sources.get(candidate_id, ""))
	if not _unique_string_set(earned_record_ids_value).has(source_record_id):
		return {
			"ok": false,
			"code": "SOURCE_RECORD_NOT_EARNED",
			"candidate_id": candidate_id,
			"source_record_id": source_record_id
		}
	if typeof(draft_slots_value) != TYPE_DICTIONARY:
		return {"ok": false, "code": "INVALID_DRAFT_SLOTS"}
	for existing_slot_value in (draft_slots_value as Dictionary).keys():
		var existing_slot_id := String(existing_slot_value)
		if existing_slot_id == slot_id:
			continue
		if String(slot_pages.get(existing_slot_id, "")) != page_id:
			continue
		if String((draft_slots_value as Dictionary).get(existing_slot_value, "")) == candidate_id:
			return {"ok": false, "code": "DUPLICATE_CANDIDATE_ON_PAGE", "candidate_id": candidate_id}
	return {"ok": true, "code": "VALID_PLACEMENT", "source_record_id": source_record_id}


func filter_known_draft_slots(manual: Dictionary, draft_slots_value: Variant) -> Dictionary:
	var validation := validate_manual(manual)
	if not bool(validation.get("ok", false)):
		return validation
	if typeof(draft_slots_value) != TYPE_DICTIONARY:
		return {"ok": true, "code": "DRAFTS_FILTERED", "draft_slots": {}}
	var slot_pages := validation.get("slot_pages", {}) as Dictionary
	var candidate_pages := validation.get("candidate_pages", {}) as Dictionary
	var normalized: Dictionary = {}
	var used_by_page: Dictionary = {}
	for slot_value in (draft_slots_value as Dictionary).keys():
		var slot_id := String(slot_value)
		var candidate_id := String((draft_slots_value as Dictionary).get(slot_value, ""))
		if not slot_pages.has(slot_id) or not candidate_pages.has(candidate_id):
			continue
		var page_id := String(slot_pages.get(slot_id, ""))
		if String(candidate_pages.get(candidate_id, "")) != page_id:
			continue
		var used_candidates: Dictionary = used_by_page.get(page_id, {}) as Dictionary
		if used_candidates.has(candidate_id):
			continue
		used_candidates[candidate_id] = true
		used_by_page[page_id] = used_candidates
		normalized[slot_id] = candidate_id
	return {"ok": true, "code": "DRAFTS_FILTERED", "draft_slots": normalized}


func _find_forbidden_candidate_field(value: Variant) -> String:
	match typeof(value):
		TYPE_DICTIONARY:
			for key_value in (value as Dictionary).keys():
				var key := String(key_value)
				if key in FORBIDDEN_CANDIDATE_FIELDS:
					return key
				var nested := _find_forbidden_candidate_field((value as Dictionary).get(key_value))
				if not nested.is_empty():
					return nested
		TYPE_ARRAY:
			for child in value as Array:
				var nested := _find_forbidden_candidate_field(child)
				if not nested.is_empty():
					return nested
	return ""


func _unique_string_set(value: Variant) -> Dictionary:
	var result: Dictionary = {}
	if typeof(value) != TYPE_ARRAY:
		return result
	for item in value as Array:
		var text := String(item)
		if not text.is_empty():
			result[text] = true
	return result
