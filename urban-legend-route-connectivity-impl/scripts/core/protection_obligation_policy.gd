class_name ProtectionObligationPolicy
extends RefCounted

const PRIORITY_ORDER := {
	"critical": 0,
	"urgent": 1,
	"watch": 2
}

const INFORMATION_ACTIONS := [
	"observe",
	"open_manual",
	"preview_result",
	"cancel",
	"move_focus"
]


func evaluate_action(obligations: Array, action: Dictionary, context: Dictionary = {}) -> Dictionary:
	var action_id := String(action.get("action_id", ""))
	var base_cost := int(action.get("base_cost", 0))
	if action_id in INFORMATION_ACTIONS:
		return {
			"action_id": action_id,
			"allowed": true,
			"base_cost": base_cost,
			"additional_cost": 0,
			"cost_adjustments": [],
			"risk_changes": [],
			"alternatives": [],
			"preview_text": "정보 확인 행동은 추가 비용 없이 사용할 수 있습니다."
		}

	var related := _related_obligations(obligations, action_id)
	var adjustments: Array = []
	var risk_changes: Array = []
	var seen_causes: Dictionary = {}
	var additional_cost := 0
	for obligation_value in related:
		var obligation := obligation_value as Dictionary
		var cause_key := "%s|%s" % [
			String(obligation.get("source_reason", "")),
			String(obligation.get("target", ""))
		]
		if seen_causes.has(cause_key):
			continue
		seen_causes[cause_key] = true

		var action_cost_rule := _action_cost_rule(obligation, action_id)
		if not action_cost_rule.is_empty():
			var cost_channel := String(action_cost_rule.get("cost_channel", "action_opportunity"))
			var authored_additional_cost := maxi(0, int(action_cost_rule.get("additional_cost", 0)))
			var adjustment_id := _make_adjustment_id(
				String(obligation.get("obligation_id", "")),
				action_id,
				cost_channel
			)
			adjustments.append({
				"cost_adjustment_id": adjustment_id,
				"obligation_id": String(obligation.get("obligation_id", "")),
				"affected_action": action_id,
				"cost_channel": cost_channel,
				"base_cost": base_cost,
				"additional_cost": authored_additional_cost,
				"source_reason": String(obligation.get("source_reason", "")),
				"preview_text": String(action_cost_rule.get("preview_text", obligation.get("priority_reason", "보호 의무와 충돌합니다."))),
				"applied_once": false
			})
			additional_cost += authored_additional_cost

		risk_changes.append({
			"obligation_id": String(obligation.get("obligation_id", "")),
			"target": String(obligation.get("target", "")),
			"source_reason": String(obligation.get("source_reason", "")),
			"consequence": String(obligation.get("breach_consequence", "보호 의무가 악화될 수 있습니다."))
		})

	var normalized := normalize_cost_adjustments(adjustments)
	if not bool(normalized.get("ok", false)):
		return {
			"action_id": action_id,
			"allowed": false,
			"base_cost": base_cost,
			"additional_cost": 0,
			"cost_adjustments": [],
			"risk_changes": risk_changes,
			"alternatives": _make_alternatives(related, context),
			"validation_errors": _array_copy(normalized.get("validation_errors")),
			"preview_text": "상충하는 보호 의무 비용 기록을 확인해야 합니다."
		}

	return {
		"action_id": action_id,
		"allowed": true,
		"base_cost": base_cost,
		"additional_cost": additional_cost,
		"cost_adjustments": _array_copy(normalized.get("adjustments")),
		"risk_changes": risk_changes,
		"alternatives": _make_alternatives(related, context),
		"preview_text": _make_preview_text(base_cost, additional_cost, related, adjustments)
	}


func sort_obligations(obligations: Array) -> Array:
	var copied: Array = []
	for obligation_value in obligations:
		if typeof(obligation_value) == TYPE_DICTIONARY:
			copied.append((obligation_value as Dictionary).duplicate(true))
	copied.sort_custom(func(left: Dictionary, right: Dictionary) -> bool:
		var left_priority := int(PRIORITY_ORDER.get(String(left.get("priority_class", "watch")), 2))
		var right_priority := int(PRIORITY_ORDER.get(String(right.get("priority_class", "watch")), 2))
		if left_priority != right_priority:
			return left_priority < right_priority
		var left_order := int(left.get("created_order", 0))
		var right_order := int(right.get("created_order", 0))
		if left_order != right_order:
			return left_order < right_order
		return String(left.get("obligation_id", "")) < String(right.get("obligation_id", ""))
	)
	return copied


func validate_transfer(obligation: Dictionary, transfer: Dictionary) -> Dictionary:
	var owner := String(transfer.get("accountable_owner", ""))
	var accepted := bool(transfer.get("accepted", false))
	var follow_up_condition := String(transfer.get("follow_up_condition", ""))
	if owner.is_empty():
		return {"ok": false, "error": "missing_accountable_owner"}
	if not accepted:
		return {"ok": false, "error": "transfer_not_accepted"}
	if follow_up_condition.is_empty():
		return {"ok": false, "error": "missing_follow_up_condition"}
	var updated := obligation.duplicate(true)
	updated["status"] = "transferred"
	updated["accountable_owner"] = owner
	updated["follow_up_condition"] = follow_up_condition
	updated["transfer_provenance"] = transfer.duplicate(true)
	return {"ok": true, "obligation": updated}


func normalize_cost_adjustments(adjustments: Array) -> Dictionary:
	var by_id: Dictionary = {}
	var normalized: Array = []
	var errors: Array = []
	for adjustment_value in adjustments:
		if typeof(adjustment_value) != TYPE_DICTIONARY:
			continue
		var adjustment := adjustment_value as Dictionary
		var adjustment_id := String(adjustment.get("cost_adjustment_id", ""))
		if adjustment_id.is_empty():
			errors.append("missing_cost_adjustment_id")
			continue
		if not by_id.has(adjustment_id):
			by_id[adjustment_id] = adjustment.duplicate(true)
			normalized.append(adjustment.duplicate(true))
			continue
		if JSON.stringify(by_id[adjustment_id]) != JSON.stringify(adjustment):
			errors.append("conflicting_cost_adjustment:%s" % adjustment_id)
	return {
		"ok": errors.is_empty(),
		"adjustments": [] if not errors.is_empty() else normalized,
		"validation_errors": errors
	}


func _related_obligations(obligations: Array, action_id: String) -> Array:
	var result: Array = []
	for obligation_value in obligations:
		if typeof(obligation_value) != TYPE_DICTIONARY:
			continue
		var obligation := obligation_value as Dictionary
		if String(obligation.get("status", "unresolved")) in ["completed", "transferred", "deferred_with_owner"]:
			continue
		if action_id in _string_array(obligation.get("affected_actions", [])):
			result.append(obligation)
	return sort_obligations(result)


func _action_cost_rule(obligation: Dictionary, action_id: String) -> Dictionary:
	var cost_rules := _dictionary_copy(obligation.get("cost_rules"))
	return _dictionary_copy(cost_rules.get(action_id))


func _make_adjustment_id(obligation_id: String, action_id: String, cost_channel: String) -> String:
	return "%s:%s:%s" % [obligation_id, action_id, cost_channel]


func _make_alternatives(related: Array, context: Dictionary) -> Array:
	if related.is_empty():
		return []
	var alternatives: Array = [
		{"action_id": "protect", "label": "보호 행동"},
		{"action_id": "observe", "label": "관찰"},
		{"action_id": "open_manual", "label": "괴이 매뉴얼"}
	]
	if not _array_copy(context.get("available_supports")).is_empty():
		alternatives.append({"action_id": "use_support", "label": "도구·지원 사용"})
	alternatives.append({"action_id": "transfer_responsibility", "label": "책임 이관 검토"})
	if bool(context.get("safe_route", false)):
		alternatives.append({"action_id": "evaluate_withdrawal", "label": "승인 철수 판단"})
	return alternatives


func _make_preview_text(base_cost: int, additional_cost: int, related: Array, adjustments: Array) -> String:
	if related.is_empty():
		return "기본 비용 %d · 추가 보호 비용 없음" % base_cost
	var first := related[0] as Dictionary
	var reason := String(first.get("priority_reason", first.get("source_reason", "보호 의무")))
	if adjustments.is_empty():
		return "기본 비용 %d · 저작된 추가 수치 비용 없음 · 보호 위험: %s" % [base_cost, reason]
	return "기본 비용 %d · 저작된 추가 비용 %d · 원인: %s" % [base_cost, additional_cost, reason]


func _dictionary_copy(value: Variant) -> Dictionary:
	return (value as Dictionary).duplicate(true) if typeof(value) == TYPE_DICTIONARY else {}


func _array_copy(value: Variant) -> Array:
	return (value as Array).duplicate(true) if typeof(value) == TYPE_ARRAY else []


func _string_array(value: Variant) -> Array[String]:
	var result: Array[String] = []
	if typeof(value) != TYPE_ARRAY:
		return result
	for item in value as Array:
		result.append(String(item))
	return result
