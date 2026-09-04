# 저승역 조사 화면에서만 사용하는 표시용 매뉴얼·판단 카탈로그다.
# 사건 JSON과 저장 구조를 소유하지 않으며 플레이어에게 보일 비교 근거만 제공한다.
class_name AfterlifeManualCatalog
extends RefCounted


static func pages() -> Array[Dictionary]:
	return [
		{
			"id": "repeating_announcement",
			"title": "반복 안내",
			"observation": "같은 방송을 들은 승객들이 서로 다른 목적지를 기억한다. 원본에는 목적지 구간의 무음이 남아 있다.",
			"procedure": "현장 재생보다 원본 기록을 우선하고, 공백 전후의 공식 식별음을 분리해 확인한다.",
			"success_case_id": "success_c",
			"failure_case_id": "failure_c"
		},
		{
			"id": "destination_confusion",
			"title": "목적지 혼선",
			"observation": "피해자 진술과 전광판 표기는 관찰자마다 달라진다. 개인 목적지는 객관 기준이 아니다.",
			"procedure": "개인 목적지 표기를 배제하고 공식 운행 기록과 식별 번호를 비교한다.",
			"success_case_id": "success_b",
			"failure_case_id": "failure_b"
		},
		{
			"id": "spatial_reset",
			"title": "공간 초기화",
			"observation": "안내가 끝나기 전에 이동하면 시간은 흐르지만 위치만 처음 승강장으로 돌아간다.",
			"procedure": "안내 종료 식별음을 확인할 때까지 대기하고, 그 뒤에만 경로를 적용한다.",
			"success_case_id": "success_a",
			"failure_case_id": "failure_a"
		},
		{
			"id": "safe_route_restore",
			"title": "안전 노선 복원",
			"observation": "변동 표기와 개인 목적지를 제외하면 공식 번호·방향·종료 식별음으로 하나의 안전 노선을 복원할 수 있다.",
			"procedure": "공식 기록 확인 → 종료 식별음 대조 → 개인 목적지 배제 → 경로 복원 → 안내 종료 후 이동.",
			"success_case_id": "success_b",
			"failure_case_id": "failure_b"
		}
	]


static func cases() -> Dictionary:
	return {
		"success_a": {
			"title": "성공 A · 폐쇄 승강장 구조 기록",
			"phenomenon": "승객이 같은 승강장으로 반복 귀환했다.",
			"observation": "안내 종료 식별음 뒤에는 위치 초기화가 발생하지 않았다.",
			"response": "방송이 완전히 끝날 때까지 이동을 보류했다.",
			"result": "폐쇄 구간을 벗어나 공식 연결 통로에 진입했다.",
			"tags": ["안내 종료 뒤 이동", "대기", "공식 식별음"]
		},
		"success_b": {
			"title": "성공 B · 차량기지 연결 통로 기록",
			"phenomenon": "각 요원이 서로 다른 종착지를 들었다.",
			"observation": "공식 식별 번호만 전원에게 동일하게 관측됐다.",
			"response": "개인 목적지를 버리고 공식 번호로 경로를 고정했다.",
			"result": "폐쇄 순환 없이 연결 통로를 확보했다.",
			"tags": ["공식 기록", "개인 목적지 배제", "노선 고정"]
		},
		"success_c": {
			"title": "성공 C · 환승 통로 반복 기록",
			"phenomenon": "전광판과 방송 문구가 주기적으로 변했다.",
			"observation": "원본 기록의 무음과 종료 식별음은 변하지 않았다.",
			"response": "변동 표기가 멈춘 뒤 원본 기록부터 비교했다.",
			"result": "현장 재생 없이 방송의 공백 규칙을 확인했다.",
			"tags": ["원본 우선", "변동 표기 배제", "공백 확인"]
		},
		"failure_a": {
			"title": "실패 A · 조기 이동",
			"phenomenon": "안내 도중 승강장을 벗어나려 했다.",
			"observation": "시계는 진행했지만 위치만 처음으로 돌아갔다.",
			"response": "종료 식별음을 확인하지 않고 이동했다.",
			"result": "공간 초기화가 반복되고 대원의 정신력이 소모됐다.",
			"tags": ["조기 이동", "공간 초기화", "대기 필요"]
		},
		"failure_b": {
			"title": "실패 B · 개인 목적지 확정",
			"phenomenon": "피해자가 들었다는 목적지를 실제 노선에 적용했다.",
			"observation": "요원마다 적용 경로가 달라졌다.",
			"response": "개인 진술을 공식 목적지처럼 사용했다.",
			"result": "경로가 폐쇄 순환으로 굳어졌다.",
			"tags": ["개인 목적지", "폐쇄 순환", "객관 기준 부재"]
		},
		"failure_c": {
			"title": "실패 C · 미검증 방송 증폭",
			"phenomenon": "현장 스피커의 방송을 다시 재생했다.",
			"observation": "재생할 때마다 목적지 혼선 범위가 넓어졌다.",
			"response": "원본 확인 전에 괴이 방송을 증폭했다.",
			"result": "추가 승객까지 개인 목적지를 듣기 시작했다.",
			"tags": ["현장 재생", "혼선 확대", "원본 우선"]
		}
	}


static func judgment_for_point(point_id: String) -> Dictionary:
	var common_choices := [
		{"id": "inspect_original_silence", "title": "원본 녹음의 무음 구간을 확인한다", "kind": "objective"},
		{"id": "replay_field_broadcast", "title": "현장 방송을 다시 재생한다", "kind": "risk", "failure_case_id": "failure_c"},
		{"id": "record_personal_destination", "title": "피해자가 들었다는 목적지를 기록에 적용한다", "kind": "wrong", "failure_case_id": "failure_b"},
		{"id": "register_display_destination", "title": "전광판의 목적지를 공식 목적지로 등록한다", "kind": "wrong", "failure_case_id": "failure_b"},
		{"id": "compare_end_tone", "title": "방송 종료 식별음을 공식 운행 기록과 대조한다", "kind": "objective"}
	]
	var definitions := {
		"point_platform_speaker": {
			"title": "플랫폼 스피커 · 방송 원본 확인",
			"observation": "목적지 구간만 짧게 비어 있고, 공백 전후의 종료 식별음은 남아 있다.",
			"correct_id": "inspect_original_silence",
			"manual_page": 0
		},
		"point_frequency_terminal": {
			"title": "공식 운행 기록 · 식별 정보 대조",
			"observation": "현장 표기는 계속 바뀌지만 운행 기록의 종료 식별 번호는 고정돼 있다.",
			"correct_id": "compare_end_tone",
			"manual_page": 1
		},
		"point_terminal_sign": {
			"title": "전광판 · 개인 목적지 배제",
			"observation": "같은 전광판을 본 세 사람이 서로 다른 목적지를 읽었다.",
			"correct_id": "compare_end_tone",
			"manual_page": 1
		},
		"point_staff_room_log": {
			"title": "최종 이동 시점 · 공간 초기화 대조",
			"observation": "초기화가 멈춘 기록은 모두 방송 종료 식별음 뒤에 이동했다.",
			"correct_id": "compare_end_tone",
			"manual_page": 2
		}
	}
	if not definitions.has(point_id):
		return {}
	var result: Dictionary = (definitions[point_id] as Dictionary).duplicate(true)
	result["choices"] = common_choices.duplicate(true)
	return result


static func case_text(case_id: String) -> String:
	var data: Dictionary = cases().get(case_id, {})
	if data.is_empty():
		return "기록을 불러올 수 없습니다."
	return "현상\n%s\n\n관찰\n%s\n\n대응\n%s\n\n결과\n%s\n\n비교 태그 · %s" % [
		String(data.get("phenomenon", "")),
		String(data.get("observation", "")),
		String(data.get("response", "")),
		String(data.get("result", "")),
		" / ".join(data.get("tags", []))
	]
