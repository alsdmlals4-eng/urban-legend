extends "res://scripts/poc/annual_mvp_001/annual_mvp_001_scene.gd"

const ThemeFactory = preload("res://scripts/ui/ui_theme_factory.gd")

const PHASE_LABELS := {
	"BOOT": "초기화",
	"WEEK_PLANNING": "주간 계획",
	"WEEK_RESULT": "주간 결과",
	"DEPLOYMENT_DECISION": "출동 결정",
	"PREPARATION": "출동 준비",
	"INCIDENT_ACTIVE": "사건 조사·회수",
	"INCIDENT_RESULT": "사건 결과",
	"POST_INCIDENT_RESEARCH": "사후 연구",
	"QUARTER_SUMMARY": "분기 결산",
	"COMPLETE": "분기 완료"
}
const ACTIVITY_LABELS := {
	"annual001_activity_observation_drill": "관측 훈련",
	"annual001_activity_analysis_desk": "기록 분석",
	"annual001_activity_field_training": "현장 대응 훈련",
	"annual001_activity_interview_duty": "증언 면담 업무",
	"annual001_activity_signal_research": "신호 현상 연구",
	"annual001_activity_companion_drill": "오현 협업 훈련",
	"annual001_activity_rest": "휴식"
}
const COMPETENCY_LABELS := {
	"observation": "관찰",
	"analysis": "분석",
	"field_response": "현장 대응",
	"interpersonal": "대인 대응"
}
const RECOVERY_LABELS := {
	"normal_capture": "정상 회수",
	"costly_capture": "대가를 치른 회수",
	"emergency_capture": "긴급 회수",
	"pending": "판정 대기",
	"unknown": "미정"
}
const KNOWLEDGE_LABELS := {
	"verified": "검증 완료",
	"candidate": "후보 기록",
	"pending": "판정 대기",
	"unknown": "미정"
}


func _ready() -> void:
	theme = ThemeFactory.create_theme()
	_add_background()
	super()
	var incident_host := find_child("IncidentHost", true, false) as Control
	if incident_host != null:
		incident_host.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		incident_host.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_localize_rendered_text()


func _render() -> void:
	super()
	_localize_rendered_text()


func _start_incident() -> void:
	super()
	var incident_host := find_child("IncidentHost", true, false) as Control
	if incident_host == null:
		return
	incident_host.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	incident_host.size_flags_vertical = Control.SIZE_EXPAND_FILL
	for child in incident_host.get_children():
		if child is Control:
			var incident := child as Control
			incident.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			incident.size_flags_vertical = Control.SIZE_EXPAND_FILL
			var investigation_panel := incident.find_child("InvestigationPanel", true, false) as Control
			if investigation_panel != null:
				investigation_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				investigation_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL


func _week_result_text(snapshot: Dictionary) -> String:
	var result := snapshot.get("last_week_result", {}) as Dictionary
	if result.is_empty():
		return "주간 결과가 없습니다."
	var activity_names: Array[String] = []
	for value in result.get("activity_ids", []) as Array:
		var activity_id := String(value)
		activity_names.append(String(ACTIVITY_LABELS.get(activity_id, activity_id)))
	return "%d주차 결과\n활동: %s\n피로·역량·기관 지원·신뢰 변화가 다음 출동 준비에 반영됩니다." % [
		int(result.get("week", 0)),
		", ".join(activity_names)
	]


func _research_text(snapshot: Dictionary) -> String:
	var manual := snapshot.get("manual_delta", {}) as Dictionary
	var recovery_id := String((snapshot.get("incident_result", {}) as Dictionary).get("recovery_quality", "pending"))
	var knowledge_id := String(manual.get("status", "pending"))
	return "사건 결과: %s\n매뉴얼 지식 품질: %s\n위험 사례: %d건\n검증 상태와 잔향 자료가 충족되면 공용 보조 스킬을 연구할 수 있습니다." % [
		String(RECOVERY_LABELS.get(recovery_id, recovery_id)),
		String(KNOWLEDGE_LABELS.get(knowledge_id, knowledge_id)),
		(manual.get("danger_cases", []) as Array).size()
	]


func _summary_text(snapshot: Dictionary) -> String:
	var summary := snapshot.get("quarter_summary", {}) as Dictionary
	if summary.is_empty():
		return "분기 결산 모형을 준비 중입니다."
	var competency_id := String(summary.get("competency_focus", "unknown"))
	var recovery_id := String(summary.get("recovery_quality", "unknown"))
	var knowledge_id := String(summary.get("knowledge_quality", "unknown"))
	return "분기 결산 모형 — 최종 엔딩이 아닙니다.\n%d주 동안 권나래는 %s 역량을 중심으로 성장했습니다.\n출동 방식은 %s였습니다.\n회수 품질은 %s입니다.\n지식 품질은 %s이며 위험 사례 %d건이 기록됐습니다.\n오현의 보조는 %d회 발동했습니다.\n연구·장비·스킬 해금은 다음 분기 준비로 이어집니다.\n다음 연도 확장 시 이 결과는 중간 상태로 계승됩니다." % [
		int(summary.get("weeks_used", 0)),
		String(COMPETENCY_LABELS.get(competency_id, competency_id)),
		"긴급 출동" if bool(summary.get("forced_deployment", false)) else "자율 출동",
		String(RECOVERY_LABELS.get(recovery_id, recovery_id)),
		String(KNOWLEDGE_LABELS.get(knowledge_id, knowledge_id)),
		int(summary.get("danger_case_count", 0)),
		int(summary.get("support_trigger_count", 0))
	]


func _add_background() -> void:
	var background := ColorRect.new()
	background.name = "Background"
	background.color = Color("090d13")
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)


func _localize_rendered_text() -> void:
	var phase_label := find_child("PhaseLabel", true, false) as Label
	if phase_label == null:
		return
	var phase := String((debug_snapshot() as Dictionary).get("phase", "BOOT"))
	phase_label.text = "현재 단계: %s" % String(PHASE_LABELS.get(phase, phase))
