# CASE-01 조사 디바이스의 승인된 presentation projection을 제공한다.
# 사건 truth/correctness를 소유하지 않으며, 내부 ID와 플레이어-facing 문구만 노출한다.
class_name Case01DeviceCatalog
extends RefCounted

const CASE_ID := "episode_001_afterlife_station"
const CONTRACT_ID := "afterlife-station-canon-v2"

const TABS := [
	{"id": "records", "label": "기록"},
	{"id": "manual", "label": "괴이 매뉴얼"},
	{"id": "map", "label": "지도"}
]

const MANUAL_SECTIONS := [
	{
		"id": "section_afterlife_occurrence_condition",
		"label": "발생 조건",
		"page_id": "manual_afterlife_page_01_destination_projection",
		"slot_ids": [
			"slot_afterlife_p01_broadcast_blank",
			"slot_afterlife_p01_official_absence"
		]
	},
	{
		"id": "section_afterlife_victim_link",
		"label": "피해자 연결",
		"page_id": "manual_afterlife_page_01_destination_projection",
		"slot_ids": [
			"slot_afterlife_p01_listener_memory",
			"slot_afterlife_p01_destination_mismatch"
		]
	},
	{
		"id": "section_afterlife_forbidden_action",
		"label": "금지 행동",
		"page_id": "manual_afterlife_page_02_boundary_reset",
		"slot_ids": [
			"slot_afterlife_p02_announcement_window",
			"slot_afterlife_p02_projected_direction",
			"slot_afterlife_p02_boundary_crossing",
			"slot_afterlife_p02_position_reset",
			"slot_afterlife_p02_persistent_time_records"
		]
	},
	{
		"id": "section_afterlife_rescue_procedure",
		"label": "구출 절차",
		"page_id": "manual_afterlife_page_03_official_return",
		"slot_ids": [
			"slot_afterlife_p03_real_return_route",
			"slot_afterlife_p03_wait_until_end",
			"slot_afterlife_p03_official_identifier",
			"slot_afterlife_p03_matching_ticket",
			"slot_afterlife_p03_joint_disembarkation"
		]
	},
	{
		"id": "section_afterlife_recovery_response",
		"label": "회수 대응",
		"page_id": "",
		"slot_ids": [],
		"recovery_pattern_ids": [
			"pattern_afterlife_destination_chorus",
			"pattern_afterlife_recurring_platform",
			"pattern_afterlife_nonstop_farewell"
		]
	}
]

const KEYWORDS := [
	# Page 1 / sections 1-2
	{
		"id": "kw_afterlife_p01_destination_silence",
		"label": "목적지 구간의 무음 공백",
		"page_id": "manual_afterlife_page_01_destination_projection",
		"source_record_ids": ["record_afterlife_r1_broadcast_original"]
	},
	{
		"id": "kw_afterlife_p01_listener_return_memory",
		"label": "듣는 사람의 귀환 기억",
		"page_id": "manual_afterlife_page_01_destination_projection",
		"source_record_ids": ["record_afterlife_r1_victim_phone_destination"]
	},
	{
		"id": "kw_afterlife_p01_concurrent_destination_mismatch",
		"label": "동시간대 목적지 불일치",
		"page_id": "manual_afterlife_page_01_destination_projection",
		"source_record_ids": ["record_afterlife_r1_concurrent_destination_mismatch"]
	},
	{
		"id": "kw_afterlife_p01_official_route_absence",
		"label": "공식 노선에 없는 추가 목적지",
		"page_id": "manual_afterlife_page_01_destination_projection",
		"source_record_ids": ["record_afterlife_official_operation_log"]
	},
	{
		"id": "kw_afterlife_p01_original_testimony_mismatch",
		"label": "원본과 증언의 불일치",
		"page_id": "manual_afterlife_page_01_destination_projection",
		"source_record_ids": [
			"record_afterlife_r1_broadcast_original",
			"record_afterlife_r1_victim_phone_destination"
		]
	},
	{
		"id": "kw_afterlife_p01_personal_memory_projection",
		"label": "개인별 기억 투영",
		"page_id": "manual_afterlife_page_01_destination_projection",
		"source_record_ids": [
			"record_afterlife_r1_victim_phone_destination",
			"record_afterlife_r1_concurrent_destination_mismatch"
		]
	},
	{
		"id": "kw_afterlife_p01_mutated_start_silence",
		"label": "방송 시작 구간의 무음 공백",
		"page_id": "manual_afterlife_page_01_destination_projection",
		"source_keyword_id": "kw_afterlife_p01_destination_silence"
	},
	{
		"id": "kw_afterlife_p01_mutated_same_destination",
		"label": "모두가 같은 목적지를 들음",
		"page_id": "manual_afterlife_page_01_destination_projection",
		"source_keyword_id": "kw_afterlife_p01_concurrent_destination_mismatch"
	},
	# Page 2 / section 3
	{
		"id": "kw_afterlife_p02_before_announcement_end",
		"label": "안내 종료 전",
		"page_id": "manual_afterlife_page_02_boundary_reset",
		"source_record_ids": ["record_afterlife_r2_continuous_recording"]
	},
	{
		"id": "kw_afterlife_p02_projected_destination_direction",
		"label": "자신이 들은 목적지 방향",
		"page_id": "manual_afterlife_page_02_boundary_reset",
		"source_record_ids": ["record_afterlife_r2_directional_boundary_test"]
	},
	{
		"id": "kw_afterlife_p02_directional_boundary",
		"label": "승차선·계단·출구 경계",
		"page_id": "manual_afterlife_page_02_boundary_reset",
		"source_record_ids": ["record_afterlife_r2_directional_boundary_test"]
	},
	{
		"id": "kw_afterlife_p02_position_only_reset",
		"label": "위치만 초기화",
		"page_id": "manual_afterlife_page_02_boundary_reset",
		"source_record_ids": ["record_afterlife_r2_object_position"]
	},
	{
		"id": "kw_afterlife_p02_time_record_persistence",
		"label": "시간·기록 유지",
		"page_id": "manual_afterlife_page_02_boundary_reset",
		"source_record_ids": [
			"record_afterlife_r2_continuous_recording",
			"record_afterlife_r2_phone_time_battery"
		]
	},
	{
		"id": "kw_afterlife_p02_internal_movement_safe",
		"label": "승강장 내부 이동은 안전",
		"page_id": "manual_afterlife_page_02_boundary_reset",
		"source_record_ids": ["record_afterlife_r2_directional_boundary_test"]
	},
	{
		"id": "kw_afterlife_p02_victim_link_deepens",
		"label": "반복할수록 피해자 연결 심화",
		"page_id": "manual_afterlife_page_02_boundary_reset",
		"source_record_ids": [
			"record_afterlife_r2_continuous_recording",
			"record_afterlife_r2_phone_time_battery"
		]
	},
	{
		"id": "kw_afterlife_p02_mutated_after_announcement_end",
		"label": "안내 종료 후",
		"page_id": "manual_afterlife_page_02_boundary_reset",
		"source_keyword_id": "kw_afterlife_p02_before_announcement_end"
	},
	{
		"id": "kw_afterlife_p02_mutated_time_and_position_reset",
		"label": "시간과 위치가 함께 초기화",
		"page_id": "manual_afterlife_page_02_boundary_reset",
		"source_keyword_id": "kw_afterlife_p02_position_only_reset"
	},
	# Page 3 / section 4
	{
		"id": "kw_afterlife_p03_real_return_route",
		"label": "현실 귀환 경로",
		"page_id": "manual_afterlife_page_03_official_return",
		"source_record_ids": [
			"record_afterlife_r3_transit_history",
			"record_afterlife_r3_official_route_map"
		]
	},
	{
		"id": "kw_afterlife_p03_wait_for_announcement_end",
		"label": "안내 종료 대기",
		"page_id": "manual_afterlife_page_03_official_return",
		"source_record_ids": [
			"record_afterlife_r3_transit_history",
			"record_afterlife_official_operation_log"
		]
	},
	{
		"id": "kw_afterlife_p03_official_station_identifier",
		"label": "공식 역 식별음",
		"page_id": "manual_afterlife_page_03_official_return",
		"source_record_ids": ["record_afterlife_r3_station_identifier"]
	},
	{
		"id": "kw_afterlife_p03_matching_ticket",
		"label": "노선색·노선명·역 코드 일치 승차권",
		"page_id": "manual_afterlife_page_03_official_return",
		"source_record_ids": ["record_afterlife_r3_ticket_comparison"]
	},
	{
		"id": "kw_afterlife_p03_joint_boarding_and_disembarkation",
		"label": "피해자 동행 탑승·표 보관·지정 역 하차",
		"page_id": "manual_afterlife_page_03_official_return",
		"source_record_ids": ["record_afterlife_r3_boarding_disembarkation"]
	},
	{
		"id": "kw_afterlife_p03_projected_destination_not_real",
		"label": "투영된 목적지는 현실 노선이 아님",
		"page_id": "manual_afterlife_page_03_official_return",
		"source_record_ids": [
			"record_afterlife_r1_concurrent_destination_mismatch",
			"record_afterlife_r3_official_route_map"
		]
	},
	{
		"id": "kw_afterlife_p03_multichannel_ticket_verification",
		"label": "색상 외 문양·텍스트 교차 확인",
		"page_id": "manual_afterlife_page_03_official_return",
		"source_record_ids": ["record_afterlife_r3_ticket_comparison"]
	},
	{
		"id": "kw_afterlife_p03_mutated_desired_ticket",
		"label": "개인의 바람에 맞는 승차권",
		"page_id": "manual_afterlife_page_03_official_return",
		"source_keyword_id": "kw_afterlife_p03_matching_ticket"
	},
	{
		"id": "kw_afterlife_p03_mutated_early_disembark",
		"label": "한 정거장 앞 하차",
		"page_id": "manual_afterlife_page_03_official_return",
		"source_keyword_id": "kw_afterlife_p03_joint_boarding_and_disembarkation"
	},
	{
		"id": "kw_afterlife_p03_mutated_victim_solo_boarding",
		"label": "피해자 단독 탑승",
		"page_id": "manual_afterlife_page_03_official_return",
		"source_keyword_id": "kw_afterlife_p03_joint_boarding_and_disembarkation"
	}
]

const LOCATIONS := [
	{
		"id": "location_afterlife_platform",
		"label": "승강장",
		"point_ids": [
			"point_victim_phone",
			"point_platform_speaker",
			"point_frequency_terminal",
			"point_terminal_sign"
		]
	},
	{
		"id": "location_afterlife_ticket_gate",
		"label": "개찰구",
		"point_ids": ["point_black_ticket"]
	},
	{
		"id": "location_afterlife_staff_room",
		"label": "역무원실",
		"point_ids": ["point_staff_room_door", "point_staff_room_log"]
	}
]

const RECORD_CATEGORIES := [
	{"id": "all", "label": "전체"},
	{"id": "field", "label": "현장 기록"},
	{"id": "evidence", "label": "증거"},
	{"id": "testimony", "label": "증언"},
	{"id": "transmission", "label": "통신·방송 기록"}
]

const LUME_COPY := {
	"records": "기록의 출처와 서로 충돌하는 관측을 먼저 비교하세요.",
	"manual": "후보 키워드는 정답 표시가 아닙니다. 확보한 기록과 맞는 문장을 직접 구성하세요.",
	"map": "장소 선택은 이동 확정이 아닙니다. 상세를 확인한 뒤 이동을 요청하세요.",
	"field": "새 관측을 얻으면 기록과 추리문을 다시 비교할 수 있습니다."
}


func get_tabs() -> Array:
	return TABS.duplicate(true)


func get_manual_sections() -> Array:
	return MANUAL_SECTIONS.duplicate(true)


func get_keywords() -> Array:
	return KEYWORDS.duplicate(true)


func get_locations() -> Array:
	return LOCATIONS.duplicate(true)


func get_record_categories() -> Array:
	return RECORD_CATEGORIES.duplicate(true)


func get_lume_copy(context_id: String) -> String:
	return String(LUME_COPY.get(context_id, ""))


func find_section(section_id: String) -> Dictionary:
	for section_value in MANUAL_SECTIONS:
		if typeof(section_value) == TYPE_DICTIONARY and String((section_value as Dictionary).get("id", "")) == section_id:
			return (section_value as Dictionary).duplicate(true)
	return {}


func find_keyword(keyword_id: String) -> Dictionary:
	for keyword_value in KEYWORDS:
		if typeof(keyword_value) == TYPE_DICTIONARY and String((keyword_value as Dictionary).get("id", "")) == keyword_id:
			return (keyword_value as Dictionary).duplicate(true)
	return {}


func find_location(location_id: String) -> Dictionary:
	for location_value in LOCATIONS:
		if typeof(location_value) == TYPE_DICTIONARY and String((location_value as Dictionary).get("id", "")) == location_id:
			return (location_value as Dictionary).duplicate(true)
	return {}
