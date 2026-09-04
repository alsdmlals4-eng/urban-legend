extends "res://scripts/poc/core_mvp_001/core_mvp_001_scene.gd"

const PHASE_LABELS := {
	"ELIMINATION": "조사·배제",
	"HYPOTHESIS_AUTHORING": "가설 작성",
	"HYPOTHESIS_REFRESH": "가설 보완",
	"FIELD_TEST": "현장 검증",
	"RECOVERY_READY": "회수 준비",
	"EMERGENCY_RECOVERY": "긴급 회수 준비",
	"RECOVERY_TURN_START": "회수 턴 시작",
	"OMEN_READ": "전조 해석",
	"RECOVERY_ACTION": "대응 선택",
	"CAPTURE_WINDOW": "포획 창",
	"EMERGENCY_CAPTURE": "긴급 포획",
	"RESULT_COMPARE": "결과 비교",
	"MANUAL_PROMOTION": "매뉴얼 반영",
	"COMPLETE": "기록 완료"
}
const UNDERSTANDING_LABELS := {
	"unknown": "미확인",
	"clue": "단서 확보",
	"likely": "유력",
	"understood": "규칙 이해"
}


func _render() -> void:
	super()
	var snapshot: Dictionary = debug_snapshot()
	var phase_label := find_child("PhaseLabel", true, false) as Label
	var understanding_label := find_child("UnderstandingLabel", true, false) as Label
	var phase := String(snapshot.get("phase", ""))
	var understanding := String(snapshot.get("understanding", "unknown"))
	if phase_label != null:
		phase_label.text = "단계: %s" % String(PHASE_LABELS.get(phase, phase))
	if understanding_label != null:
		understanding_label.text = "이해도: %s" % String(UNDERSTANDING_LABELS.get(understanding, understanding))
