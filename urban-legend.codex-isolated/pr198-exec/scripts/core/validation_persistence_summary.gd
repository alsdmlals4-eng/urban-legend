class_name ValidationPersistenceSummary
extends RefCounted

const EPISODE_TITLES := {
	"episode_001_afterlife_station": "저승역"
}

const BLOCKED_COPY := {
	"RECOVERABLE_BACKUP": ["복구 가능한 기록", "복구 가능한 Validation 기록이 있습니다. 이 버전에서는 자동 복구하지 않습니다."],
	"INTERRUPTED_WRITE": ["저장 중단 흔적", "저장이 완료되지 않은 흔적이 있습니다. 기록을 자동 변경하지 않았습니다."],
	"INCOMPATIBLE_NEWER": ["최신 버전 기록", "더 최신 버전에서 만든 Validation 기록입니다."],
	"INCOMPATIBLE_OLDER": ["이전 버전 기록", "이 버전에서 직접 열 수 없는 Validation 기록입니다."],
	"CORRUPT_JSON": ["손상된 기록", "손상된 Validation 기록을 보존했습니다."],
	"CORRUPT_SCHEMA": ["손상된 기록", "손상된 Validation 기록을 보존했습니다."],
	"READ_FAILED": ["읽기 실패", "Validation 기록을 읽을 수 없습니다. 기존 캠페인은 계속 이용할 수 있습니다."]
}


static func build(inspected: Dictionary) -> Dictionary:
	var code := String(inspected.get("code", "UNKNOWN"))
	var summary := _base(code)
	if code == "EMPTY":
		summary["ok"] = true
		summary["can_start"] = true
		summary["status_label"] = "기록 없음"
		summary["status_message"] = "새 Validation 기록을 시작할 수 있습니다."
		return summary
	if code != "EXACT":
		_apply_blocked_copy(summary, code)
		return summary

	var payload_value: Variant = inspected.get("payload")
	if typeof(payload_value) != TYPE_DICTIONARY:
		return _schema_failure()
	var payload := payload_value as Dictionary
	var session_value: Variant = payload.get("session")
	var timestamps_value: Variant = payload.get("timestamps")
	if typeof(session_value) != TYPE_DICTIONARY or typeof(timestamps_value) != TYPE_DICTIONARY:
		return _schema_failure()

	var session := session_value as Dictionary
	var timestamps := timestamps_value as Dictionary
	var lifecycle := String(session.get("lifecycle", ""))
	var episode_id := String(session.get("episode_id", ""))
	if lifecycle not in ["active", "suspended", "completed"]:
		return _schema_failure()
	if not EPISODE_TITLES.has(episode_id):
		return _schema_failure()

	summary["ok"] = true
	summary["lifecycle"] = lifecycle
	summary["episode_id"] = episode_id
	summary["episode_title"] = String(EPISODE_TITLES[episode_id])
	summary["flow_stage"] = String(session.get("flow_stage", ""))
	summary["checkpoint_id"] = String(session.get("checkpoint_id", ""))
	summary["updated_at_utc"] = String(timestamps.get("updated_at_utc", ""))
	summary["completed_at_utc"] = String(timestamps.get("completed_at_utc", ""))
	summary["requires_replace_confirmation"] = true
	if lifecycle in ["active", "suspended"]:
		summary["can_continue"] = true
		summary["status_label"] = "진행 중"
		summary["status_message"] = "%s · %s" % [summary["episode_title"], summary["flow_stage"]]
	else:
		summary["can_view_completed"] = true
		summary["status_label"] = "완료 기록"
		summary["status_message"] = "%s · 완료" % summary["episode_title"]
	return summary


static func _base(code: String) -> Dictionary:
	return {
		"ok": false,
		"repository_code": code,
		"lifecycle": "",
		"episode_id": "",
		"episode_title": "",
		"flow_stage": "",
		"checkpoint_id": "",
		"updated_at_utc": "",
		"completed_at_utc": "",
		"can_start": false,
		"can_continue": false,
		"can_view_completed": false,
		"requires_replace_confirmation": false,
		"status_label": "상태 확인 필요",
		"status_message": "Validation 기록 상태를 확인할 수 없습니다."
	}


static func _apply_blocked_copy(summary: Dictionary, code: String) -> void:
	var copy: Array = BLOCKED_COPY.get(code, ["알 수 없는 상태", "Validation 기록 상태를 확인할 수 없습니다."])
	summary["status_label"] = String(copy[0])
	summary["status_message"] = String(copy[1])


static func _schema_failure() -> Dictionary:
	var summary := _base("CORRUPT_SCHEMA")
	summary["status_label"] = "손상된 기록"
	summary["status_message"] = "손상된 Validation 기록을 보존했습니다."
	return summary
