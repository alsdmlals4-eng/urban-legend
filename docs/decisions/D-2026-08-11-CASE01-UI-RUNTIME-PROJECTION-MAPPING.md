# D-2026-08-11-CASE01-UI-RUNTIME-PROJECTION-MAPPING

## Decision

사용자는 2026-08-11 KST에 CASE-01 조사 디바이스 구현 계획의 Pre-code Gate A 권장 매핑에 대해 `권장안 승인,연속작업 진행해`라고 승인했다.

```yaml
decision_id: D-2026-08-11-CASE01-UI-RUNTIME-PROJECTION-MAPPING
classification: USER_APPROVED_RUNTIME_PROJECTION_MAPPING
approved_choice: RECOMMENDED_MAPPING_AS_WRITTEN
scope: CASE-01_AFTERLIFE_STATION_INVESTIGATION_UI_PRESENTATION_PROJECTION
planning_package: PR_197
planning_complete_declaration: NOT_RECEIVED_EXACT_PHRASE
phase_c_persistent_build: BLOCKED_PENDING_EXACT_기획_완료_DECLARATION
product_asset_promotion: BLOCKED_BY_VISUAL_REQUIREMENT_GATE
```

이 Decision은 UI 표현용 매핑을 확정한다. 사건 정답, 조사 판정, 구조·회수 규칙, 기존 3장 4/5/5 슬롯 수, 저장 버전, 기존 Canon v2 truth를 변경하지 않는다.

## 1. Five-section slot projection

플레이어-facing 5개 섹션은 기존 Canon v2 3장 로직 위에 다음과 같이 투영한다.

```text
section_afterlife_occurrence_condition / 발생 조건
  slot_afterlife_p01_broadcast_blank
  slot_afterlife_p01_official_absence

section_afterlife_victim_link / 피해자 연결
  slot_afterlife_p01_listener_memory
  slot_afterlife_p01_destination_mismatch

section_afterlife_forbidden_action / 금지 행동
  all 5 slot_afterlife_p02_*

section_afterlife_rescue_procedure / 구출 절차
  all 5 slot_afterlife_p03_*

section_afterlife_recovery_response / 회수 대응
  editable slots: none
  read-only links: existing three Canon v2 recovery patterns
```

섹션 1과 2는 Canon v2 1장의 동일 후보 풀을 공유한다. 섹션 분할은 슬롯 수, 장 완료 판정, 조사 종료→구출 진입 Gate를 추가하거나 변경하지 않는다.

## 2. Stable presentation keyword IDs

### Page 1 — sections 1–2 shared pool

```text
kw_afterlife_p01_destination_silence                 = 목적지 구간의 무음 공백
kw_afterlife_p01_listener_return_memory              = 듣는 사람의 귀환 기억
kw_afterlife_p01_concurrent_destination_mismatch     = 동시간대 목적지 불일치
kw_afterlife_p01_official_route_absence              = 공식 노선에 없는 추가 목적지
kw_afterlife_p01_original_testimony_mismatch         = 원본과 증언의 불일치
kw_afterlife_p01_personal_memory_projection          = 개인별 기억 투영
kw_afterlife_p01_mutated_start_silence               = [변조] 방송 시작 구간의 무음 공백
kw_afterlife_p01_mutated_same_destination            = [변조] 모두가 같은 목적지를 들음
```

### Page 2 — section 3

```text
kw_afterlife_p02_before_announcement_end             = 안내 종료 전
kw_afterlife_p02_projected_destination_direction     = 자신이 들은 목적지 방향
kw_afterlife_p02_directional_boundary                = 승차선·계단·출구 경계
kw_afterlife_p02_position_only_reset                 = 위치만 초기화
kw_afterlife_p02_time_record_persistence             = 시간·기록 유지
kw_afterlife_p02_internal_movement_safe              = 승강장 내부 이동은 안전
kw_afterlife_p02_victim_link_deepens                 = 반복할수록 피해자 연결 심화
kw_afterlife_p02_mutated_after_announcement_end      = [변조] 안내 종료 후
kw_afterlife_p02_mutated_time_and_position_reset     = [변조] 시간과 위치가 함께 초기화
```

### Page 3 — section 4

```text
kw_afterlife_p03_real_return_route                   = 현실 귀환 경로
kw_afterlife_p03_wait_for_announcement_end           = 안내 종료 대기
kw_afterlife_p03_official_station_identifier         = 공식 역 식별음
kw_afterlife_p03_matching_ticket                     = 노선색·노선명·역 코드 일치 승차권
kw_afterlife_p03_joint_boarding_and_disembarkation   = 피해자 동행 탑승·표 보관·지정 역 하차
kw_afterlife_p03_projected_destination_not_real      = 투영된 목적지는 현실 노선이 아님
kw_afterlife_p03_multichannel_ticket_verification    = 색상 외 문양·텍스트 교차 확인
kw_afterlife_p03_mutated_desired_ticket              = [변조] 개인의 바람에 맞는 승차권
kw_afterlife_p03_mutated_early_disembark             = [변조] 한 정거장 앞 하차
kw_afterlife_p03_mutated_victim_solo_boarding        = [변조] 피해자 단독 탑승
```

이 ID들은 안정적인 presentation/save-reference ID이며, 플레이어-facing 스타일에서 정답 여부를 암시하지 않는다.

## 3. Unlock and provenance

- 핵심 키워드는 직접 지지하는 Canon v2 record가 플레이어의 manual/evidence record set에 존재할 때 해금한다.
- 비교·보조 키워드는 해당 비교에 필요한 record가 모두 존재할 때만 해금한다.
- `[변조]` 후보는 정상 후보 하나에서 파생하며 정상 후보보다 먼저 해금하지 않는다.
- `[변조]`에 독립 가짜 evidence source를 만들지 않는다.
- UI catalog는 `source_record_ids`와 필요한 경우 `source_keyword_id`를 저장할 수 있으나, presentation이 소비하는 `correct` boolean을 두지 않는다.
- 페이지/섹션 필터는 슬롯 적합도·정답 가능성으로 후보 풀을 축소하지 않는다.

## 4. Presentation location projection

새 `field_node_id`를 만들지 않는다. 이동은 기존 investigation point를 플레이어-facing 장소로 그룹화해 현재 표시 대상을 전환한다.

```text
location_afterlife_platform / 승강장
  point_victim_phone
  point_platform_speaker
  point_frequency_terminal
  point_terminal_sign

location_afterlife_ticket_gate / 개찰구
  point_black_ticket

location_afterlife_staff_room / 역무원실
  point_staff_room_door
  point_staff_room_log
```

기존 condition으로 잠긴 조사 포인트는 기존 locked-text/condition 계약을 그대로 따른다. 이동은 잠금을 우회하지 않는다.

## 5. Preserved boundaries

- `scripts/core/game_state.gd`: 이 Decision으로 변경하지 않음
- `project.godot`: 이 Decision으로 변경하지 않음
- `data/episodes/**`: 이 Decision으로 변경하지 않음
- save version: 변경하지 않음
- Canon v2 truth/correctness: UI catalog가 소유하지 않음
- 독립 `[로그]`/`AI 로그` 탭: 만들지 않음
- 실제 오디오 파일/player/waveform: 만들지 않음
- 루메 제품 이미지: Visual Requirement Gate 승인 전 runtime product asset으로 바인딩하지 않음

## 6. Work-instruction gate

현행 v4.5-r2의 `planning_completion_trigger`는 `USER_EXPLICIT_PLANNING_COMPLETE_DECLARATION`이다. 이번 사용자 문구는 이 Decision의 권장 매핑 승인과 연속 planning 진행 승인이지만, 정확한 `기획 완료` 선언으로 대체하지 않는다.

따라서 이 Decision을 GitHub·Sheet에 동기화하고 planning PR을 검수·병합 준비하는 작업은 진행할 수 있으나, persistent Phase C 제품 BUILD는 정확한 `기획 완료` 수신 전 시작하지 않는다.
