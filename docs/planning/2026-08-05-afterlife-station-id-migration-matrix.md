# 저승역 Canon v2 ID Migration Matrix

> 상태: `REVIEW_READY / DESIGN_ONLY / IMPLEMENTATION_NOT_AUTHORIZED`
> 작성일: `2026-08-05`
> 기준 Design Spec: `docs/superpowers/specs/2026-08-05-afterlife-station-canon-v2-migration-design.md`
> 대상 콘텐츠 계약: `afterlife-station-canon-v2`
> 구현: `NOT_AUTHORIZED`

이 문서는 구형 저승역 ID를 Canon v2의 정본 ID와 연결하는 권위 표다. 이 표는 구현 전 설계이며 게임 코드·Scene·Episode JSON·저장 Schema·자산을 변경하지 않는다.

## 1. Migration disposition

- `KEEP_ID`: 사건·피해자·보고서 정체성이 같아 ID를 유지한다.
- `ALIAS`: 구형 ID 하나를 새 단일 ID로 읽기 전용 변환한다.
- `SPLIT`: 구형 ID 하나의 복합 의미를 새 복수 기록으로 분리한다.
- `MERGE`: 구형 복수 ID의 중복 출처를 새 단일 기록으로 통합한다.
- `HISTORICAL_ONLY`: 과거 보고서·QA·저장 이력에만 보존하며 새 런타임에는 적용하지 않는다.
- `DISCARD_SEMANTICS`: ID·원문·계보는 역사로 보존하지만 현재 제품 규칙·정답·해법으로 재사용하지 않는다.

모든 entry는 `effect_id`를 가지며, 동일 migration을 두 번 적용해도 중복 효과가 없다.

```yaml
legacy_id: string
disposition: KEEP_ID | ALIAS | SPLIT | MERGE | HISTORICAL_ONLY | DISCARD_SEMANTICS
target_ids: []
source_contract: string
target_contract: afterlife-station-canon-v2
runtime_apply: bool
preserve_in_history: bool
effect_id: string
```

## 2. 사건·피해자 정체성

| 구형 ID | 분류 | Canon v2 대상 | 런타임 적용 | 보존 정책 |
|---|---|---|---|---|
| `episode_001_afterlife_station` | `KEEP_ID` | `episode_001_afterlife_station` | 예 | 사건 보고서·캠페인·저장 정체성 유지. 새 사건 ID를 만들지 않는다. |
| `victim_afterlife_station_001` | `KEEP_ID` | `victim_afterlife_station_001` | 예 | stable ID 유지, 표시 정본은 `이하린`. 과거 피해자 결과와 분리하지 않는다. |

예상 apply-once key:

```text
migration:afterlife:v2:identity:episode
migration:afterlife:v2:identity:victim-profile
```

## 3. 구형 본편 clue → Canon v2 `[기록]`

| 구형 ID | 분류 | Canon v2 대상 | 정책 |
|---|---|---|---|
| `clue_repeating_announcement` | `SPLIT` | `record_afterlife_r1_broadcast_original`, `record_afterlife_r1_concurrent_destination_mismatch` | 방송 반복과 목적지 불일치를 분리한다. 두 target은 `migrated_unverified`이며 정답 슬롯은 자동으로 채우지 않는다. |
| `clue_missing_terminal_sign` | `ALIAS` | `record_afterlife_r1_concurrent_destination_mismatch` | 동시간대 전광판·관찰 기록의 provenance로 변환한다. |
| `clue_staff_room_log` | `ALIAS` | `record_afterlife_official_operation_log` | 공식 운행 기록의 출처로 변환한다. 1장·3장의 복수 `usage_refs`를 허용한다. |
| `clue_last_message` | `SPLIT` | `record_afterlife_r1_victim_phone_destination`, `record_afterlife_r2_phone_time_battery` | 피해자의 귀환 목적지 증언과 시간 기록을 분리한다. 자동으로 규칙을 확정하지 않는다. |
| `clue_black_ticket` | `HISTORICAL_ONLY` | 없음 | 검은 승차권 접촉·각인 계보를 역사 기록에만 보존한다. Canon v2 공식 승차권 정답으로 자동 정답 변환 금지. |

### MERGE 후보

구형 `clue_staff_room_log`와 PoC의 `poc001_clue_official_identifier`가 동일 공식 운행 출처를 가리키는 경우:

```yaml
disposition: MERGE
target_id: record_afterlife_official_operation_log
source_ids:
  - clue_staff_room_log
  - poc001_clue_official_identifier
preserve_source_refs: true
```

MERGE는 원본 두 ID를 지우지 않고 `source_refs[]`로 보존한다.

## 4. 구형 recovery pattern → Canon v2 패턴

| 구형 ID | 분류 | Canon v2 대상 | 정책 |
|---|---|---|---|
| `pattern_station_false_terminal` | `ALIAS` | `pattern_afterlife_destination_chorus` | 목적지 충돌 계보만 연결한다. 구형 `correct_response_id`는 새 정답으로 사용하지 않는다. |
| `pattern_station_boundary_collapse` | `ALIAS` | `pattern_afterlife_recurring_platform` | 경계·공간 반복 계보만 연결한다. 새 패턴은 시간·좌표·지속 흔적 비교를 별도 요구한다. |
| `pattern_station_ticket_imprint` | `DISCARD_SEMANTICS` | 없음 | 검은 승차권 접촉이 핵심 위험이고 격리가 정답이라는 의미를 폐기한다. 자동 정답 변환 금지. |
| `pattern_station_gaze_lure` | `HISTORICAL_ONLY` | 없음 | 과거 전투·QA 기록에만 보존한다. 새 대표 패턴으로 승격하지 않는다. |

새 정본 패턴:

```text
pattern_afterlife_nonstop_farewell
pattern_afterlife_recurring_platform
pattern_afterlife_destination_chorus
```

새 정본 대응:

```text
response_afterlife_present_official_ticket
response_afterlife_anchor_persistent_trace
response_afterlife_insert_official_identifier
```

구형 pattern ID를 ALIAS해도 구형 response·damage·turn sequence를 함께 가져오지 않는다.

## 5. 구형 response ID

| 구형 ID | 분류 | 대상 | 정책 |
|---|---|---|---|
| `cut_false_broadcast` | `HISTORICAL_ONLY` | 없음 | 과거 목적지 충돌 대응의 기록으로만 유지. 공식 식별음 삽입 대응으로 자동 변환하지 않는다. |
| `follow_terminal` | `HISTORICAL_ONLY` | 없음 | 과거 오답 선택 이력만 유지. |
| `answer_broadcast` | `HISTORICAL_ONLY` | 없음 | 과거 오답 선택 이력만 유지. |
| `restore_platform_boundary` | `HISTORICAL_ONLY` | 없음 | 새 `지속 흔적 고정`과 의미가 달라 자동 변환하지 않는다. |
| `isolate_ticket` | `DISCARD_SEMANTICS` | 없음 | 검은 승차권 접촉 차단 해법은 현재 정답으로 재사용하지 않는다. |
| `punch_ticket` | `DISCARD_SEMANTICS` | 없음 | 검은 승차권 개찰 해법을 폐기한다. |
| `carry_ticket` | `DISCARD_SEMANTICS` | 없음 | 검은 승차권 직접 소지 해법을 폐기한다. |

새 response ID에는 구형 `correct_response_id`를 자동 매핑하지 않는다.

## 6. PoC clue·manual·hypothesis

| 구형 ID | 분류 | Canon v2 대상 | 정책 |
|---|---|---|---|
| `poc001_clue_broadcast_blank` | `ALIAS` | `record_afterlife_r1_broadcast_original` | 방송 원본 공백 출처로 보수적 변환. |
| `poc001_clue_reset_timing` | `DISCARD_SEMANTICS` | 없음 | 원문의 `같은 시각으로 되돌아왔다`는 의미를 폐기한다. Canon v2는 시간·녹음·배터리·기록 유지와 위치만 초기화다. |
| `poc001_clue_official_identifier` | `ALIAS` | `record_afterlife_r3_station_identifier` | 공식 역 식별음 출처로 변환. 공식 운행 기록과 MERGE할 경우 source provenance 유지. |
| `poc001_clue_display_mismatch` | `ALIAS` | `record_afterlife_r1_concurrent_destination_mismatch` | 동시간대 목적지 불일치 기록으로 변환. |
| `poc001_clue_passenger_count` | `HISTORICAL_ONLY` | 없음 | 구형 가설 반증 계보로만 보존. |
| `poc001_question_ticket_trigger` | `DISCARD_SEMANTICS` | 없음 | 검은 승차권 접촉 조건을 사건 핵심 미해결로 취급하지 않는다. |
| `poc001_manual_early_movement_reset` | `SPLIT` | `record_afterlife_r2_continuous_recording`, `record_afterlife_r2_directional_boundary_test` | 모든 이동 금지가 아니라 투영 목적지 방향 경계 통과라는 새 조건으로 재검증 필요. |
| `poc001_manual_personal_destination` | `ALIAS` | `record_afterlife_r1_concurrent_destination_mismatch` | 개인별 목적지 불일치 근거로만 변환. |
| `poc001_manual_ticket_contact_danger` | `DISCARD_SEMANTICS` | 없음 | 검은 승차권 접촉 위험을 핵심 금지 행동으로 재사용하지 않는다. |
| `poc001_hypothesis_display_route` | `HISTORICAL_ONLY` | 없음 | 과거 오답 가설로 보존. |
| `poc001_hypothesis_broadcast_blank` | `HISTORICAL_ONLY` | 없음 | 일부 근거는 재사용 가능하지만 완성 규칙·안전 절차가 달라 hypothesis 자체는 승격하지 않는다. |

## 7. PoC recovery pattern·action

| 구형 ID | 분류 | Canon v2 대상 | 정책 |
|---|---|---|---|
| `poc001_pattern_false_terminal` | `HISTORICAL_ONLY` | 없음 | 구형 고정 시퀀스와 action 조건을 재사용하지 않는다. |
| `poc001_pattern_boundary_fold` | `HISTORICAL_ONLY` | 없음 | 과거 패턴 계보만 보존. |
| `poc001_pattern_ticket_imprint` | `DISCARD_SEMANTICS` | 없음 | 검은 승차권 접촉·각인 대응을 제품 패턴으로 변환하지 않는다. 자동 정답 변환 금지. |
| `poc001_action_hold_position` | `HISTORICAL_ONLY` | 없음 | 모든 이동 정지 해법으로 승격하지 않는다. |
| `poc001_action_fix_boundary` | `HISTORICAL_ONLY` | 없음 | 새 지속 흔적 좌표 고정과 의미가 달라 자동 매핑하지 않는다. |
| `poc001_action_isolate_ticket` | `DISCARD_SEMANTICS` | 없음 | 검은 승차권 접촉 차단 정답 의미 폐기. |
| `poc001_action_capture` | `HISTORICAL_ONLY` | 없음 | 범용 회수 action 계보로만 보존. |

## 8. 피해자·보고서·보상

### 피해자

```yaml
legacy_id: victim_afterlife_station_001
disposition: KEEP_ID
target_id: victim_afterlife_station_001
profile_contract: afterlife-station-canon-v2
display_name: 이하린
```

과거 익명 표시 이름은 `legacy_display_name`으로 역사 기록에 남길 수 있지만 런타임 표시 정본으로 사용하지 않는다.

### 완료 보고서

구형 완료 보고서는 다음처럼 보존한다.

```yaml
legacy_resolution_snapshot:
  episode_id: episode_001_afterlife_station
  source_save_version: mvp-038 | mvp-039
  source_content_contract: afterlife-station-legacy-v1
  original_grade: string
  original_result: dictionary
  original_reward_claim_ids: []
```

- 새 S 랭크로 소급 변환하지 않는다.
- 과거 보상을 다시 지급하지 않는다.
- Canon v2 첫 도전은 `first_v2_investigation`으로 별도 기록한다.

## 9. 조사 진행 중 이관

구형 clue가 새 `[기록]`으로 변환돼도 다음을 지킨다.

- target record 상태: `migrated_unverified`
- 새 매뉴얼 state: `draft_active`
- 정답 슬롯은 자동으로 채우지 않는다.
- SPLIT target은 원본 하나에서 파생됐다는 provenance를 공유한다.
- 직접 관찰하지 않은 target을 verified로 표시하지 않는다.
- `[변조]` 정상/오답 여부를 migration이 노출하지 않는다.

## 10. 진행 중 구출·회수 이관

구형 구출·회수 상태는 새 규칙과 직접 등가가 아니다.

```yaml
migration_result: LEGACY_CASE_RESTART_REQUIRED
preserve:
  - campaign
  - economy
  - relationships
  - inventory
  - reports
  - reward_claim_ids
  - legacy_run_snapshot
restart_target: canonical_v2_safe_investigation_checkpoint
penalty: none
```

구형 pattern·response 선택은 history에 남기지만 새 매뉴얼 정답·구출 성공·패턴 파훼로 적용하지 않는다.

## 11. 미매핑·모호한 ID

### 미매핑

```yaml
orphan_legacy_ids:
  - id: unknown_legacy_id
    source_contract: afterlife-station-legacy-v1
    source_location: string
    reason: UNMAPPED_LEGACY_ID
    runtime_apply: false
```

미매핑 ID는 런타임에는 적용하지 않는다. 삭제하지 않고 진단·향후 migration 보완을 위해 보존한다.

### 모호한 SPLIT

구형 source 하나가 여러 target으로 분리되지만 source 내용만으로 어느 target을 획득했는지 판정할 수 없으면:

```text
AMBIGUOUS_SPLIT_MAPPING
```

- target을 verified로 만들지 않음
- source를 migration note에 보존
- 사용자 저장을 손상된 것으로 오인하지 않음
- 안전 조사 checkpoint에서 재획득 가능하게 함

## 12. effect_id와 멱등성

예시:

```text
migration:afterlife:v2:clue:clue_repeating_announcement
migration:afterlife:v2:pattern:pattern_station_false_terminal
migration:afterlife:v2:save:mvp-039
migration:afterlife:v2:validation:validation-save-v1
```

- apply 전 `applied_migration_effect_ids` 확인
- 이미 적용된 `effect_id`는 결과를 중복 추가하지 않음
- 동일 migration을 두 번 적용해도 중복 효과가 없다.
- 부분 적용 뒤 실패하면 transaction 전체를 롤백하고 `ROLLBACK_RESTORED`를 기록

## 13. 금지사항

- `clue_black_ticket`을 공식 승차권 정답으로 승격 금지
- `pattern_station_ticket_imprint`·`poc001_pattern_ticket_imprint` 자동 정답 변환 금지
- `poc001_clue_reset_timing`의 `같은 시각` 의미 재사용 금지
- 구형 `correct_response_id`를 새 response ID로 자동 승격 금지
- 미매핑 ID 삭제 금지
- 구형 보상 재지급 금지
- migration 완료 전 구형 JSON·Scene·스크립트·테스트 삭제 금지

## 14. 구현 전 Gate

1. Design Spec과 이 Matrix 사용자 검토 승인
2. implementation plan 작성
3. Registry fixture와 save fixture 목록 확정
4. RED 테스트 작성
5. 별도 구현 승인
6. Codex 실행

Human QA·UI·수치·이미지·게임 자산은 이 Matrix에서 승인하지 않는다.
