# 도시괴이담 프로젝트의 초기 데이터와 섹션 정의를 보관한다.
extends Node

const SECTIONS: Array[Dictionary] = [
	{
		"id": "overview",
		"title": "프로젝트 개요",
		"summary": "도시괴담 기록국 데이터 편집기를 Godot 비주얼노벨 기반으로 이관한다.",
		"items": [
			"비주얼노벨 / 호러 미스터리",
			"도시괴담 기록국, 주요 세력, 요원, 장비, 기술, 에피소드 데이터 중심",
			"HTML 편집기 구조를 Godot UI와 데이터 구조로 재해석"
		]
	},
	{
		"id": "factions",
		"title": "주요 세력",
		"summary": "기록국, 소문시장, 마도회, 퇴마사 계열 세력을 관리한다.",
		"items": [
			"목표, 사상, 관계, 보유 요원, 장비, 기술을 연결한다.",
			"요원 ID 카드와 장비/기술 카드의 상위 컨테이너 역할을 한다."
		]
	},
	{
		"id": "horror_episodes",
		"title": "호러 에피소드",
		"summary": "괴담 중심 사건, 타임라인, 분기, 대화문, 미니게임을 관리한다.",
		"items": [
			"자정의 우회로",
			"네 번째 알림",
			"엘리베이터의 미소",
			"홍실 매듭",
			"폐주파수"
		]
	},
	{
		"id": "daily_episodes",
		"title": "일상 에피소드",
		"summary": "호러 사건 사이의 관계, 회복, 단서 정리, 잠금 해제를 담당한다.",
		"items": [
			"관계 변화",
			"일상 대화",
			"해금 조건",
			"다음 사건의 감정 기반"
		]
	},
	{
		"id": "agents",
		"title": "요원",
		"summary": "기관 ID 카드형 화면으로 표현할 캐릭터와 능력 정보를 관리한다.",
		"items": [
			"강이준: 분석형 / 디지털 포렌식 담당",
			"권나래: 공감형 / 기억 상담 담당",
			"오현: 돌파형 / 현장 정리반"
		]
	},
	{
		"id": "equipment",
		"title": "장비",
		"summary": "괴담 조사와 분기 보정에 쓰이는 장비 카드 데이터를 관리한다.",
		"items": [
			"기록국 단말기",
			"임시 봉인지",
			"기억 표찰",
			"현장 은폐 키트",
			"은제 나침반"
		]
	},
	{
		"id": "skills",
		"title": "기술",
		"summary": "현대 요원술, 동양 퇴마술, 서양 마법, 수집 괴담 기술을 정리한다.",
		"items": [
			"현장 은폐",
			"부적 봉인",
			"잔향 읽기",
			"문장 교정",
			"잡음 가림"
		]
	},
	{
		"id": "quality",
		"title": "제작 점검",
		"summary": "타임라인, 분기, 대화, 조건, 미니게임, 사운드 큐 누락을 점검한다.",
		"items": [
			"타임라인 단계 존재 여부",
			"2차 분기 포함 여부",
			"조건부 대화 존재 여부",
			"미니게임 성공/실패 연결 여부",
			"BGM/SFX 큐 존재 여부"
		]
	}
]


## Returns every database section.
func get_sections() -> Array[Dictionary]:
	return SECTIONS


## Finds one section by id.
func get_section(section_id: String) -> Dictionary:
	for section in SECTIONS:
		if section.get("id", "") == section_id:
			return section
	return SECTIONS[0]
