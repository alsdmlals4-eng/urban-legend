# 저승역 Canon v2 구현 이관 Design Spec

> 상태: `REVIEW_READY / DESIGN_ONLY / IMPLEMENTATION_NOT_AUTHORIZED`
> 작성일: `2026-08-05`
> 기준 main: `55721e905bf24fc3deb0de061a529ecb992aee80`
> 작업 브랜치: `agent/afterlife-station-canon-v2-migration-design`
> Draft PR: `#145`
> 제품 정본: `docs/CURRENT_AFTERLIFE_STATION_CANON.md`
> ID 이관표: `docs/planning/2026-08-05-afterlife-station-id-migration-matrix.md`

이 문서는 저승역 Batch 4 정본을 기존 Episode·PoC·Core Validation·본편 저장·Validation 저장에 안전하게 연결하기 위한 구현 전 설계다. 게임 코드·Scene·Episode JSON·저장 Schema·자산을 변경하지 않는다. 사용자 문서 검토 승인 후 implementation plan을 작성하며, 그 전에는 Codex 구현으로 넘어가지 않는다.

## 1. 목표

다음 네 조건을 동시에 만족한다.

1. 저승역을 새 사건으로 복제하지 않고 기존 사건 정체성을 유지한다.
2. 구형 콘텐츠 의미를 새 정본과 섞지 않는다.
3. `mvp-038`·`mvp-039`·`validation-save-v1` 기록을 손실 없이 판정한다.
4. 이관 실패 시 원본 파일·메모리·캠페인·경제·관계 상태를 변경하지 않는다.

```text
기존 사건 정체성 유지
+ Canon v2 콘텐츠 계약 분리
+ 명시적 ID migration
+ backup-first·fail-closed 저장 이관
= 구형 회귀와 새 정본을 동시에 보호
```

## 2. 결정 요약

### 채택

- 동일 Episode ID 유지: `episode_001_afterlife_station`
- 동일 victim stable ID 유지: `victim_afterlife_station_001`
- victim 표시 정본: `이하린`
- 새 콘텐츠 계약: `afterlife-station-canon-v2`
- 새 sidecar 예정 경로: `data/episodes/episode_001_afterlife_station_canon_v2.json`
- 본편 새 쓰기 버전: `mvp-040`
- Validation 새 쓰기 버전: `validation-save-v2`
- 진행 중 구형 구출·회수는 직접 의미 변환하지 않고 안전 재시작
- 미매핑 ID는 `orphan_legacy_ids`에 보존하고 런타임에는 적용하지 않는다.

### 기각

- 기존 Episode JSON 즉시 전면 교체
- `episode_001_afterlife_station_v2` 같은 새 사건 ID 생성
- 구형 `correct_response_id`를 새 매뉴얼·전투 정답으로 자동 승격
- 검은 승차권 접촉·파괴 해법의 자동 재사용
- 저장 실패 시 Legacy 저장으로 fallback

새 사건 ID를 만들지 않는다. 사건 보고서·캠페인 기록·피해자 결과·Validation 기록이 두 저승역으로 분리되는 것을 막기 위함이다.

## 3. 현행 구조와 위험

### 3.1 본편

- 기본 Episode: `episode_001_afterlife_station`
- 기본 데이터: `data/episodes/episode_001_afterlife_station.json`
- 본편 저장: `user://urban_legend_save.json`
- 현재 쓰기 버전: `mvp-039`
- `GameState.anomaly_manual_records`는 episode ID를 키로 사용한다.
- 완료 보고서와 보상도 episode ID를 기준으로 보존한다.

### 3.2 Core Validation overlay

`EpisodeLoader`는 기본 JSON 옆의 `_core_validation.json`을 자동 발견하고 최상위 키를 덮어쓴다.

위험:

- 구형 `recovery_patterns` 전체가 새 패턴을 덮거나 혼합될 수 있다.
- 파일명만 존재하면 활성화되므로 콘텐츠 계약 선택이 암묵적이다.
- overlay 출처와 실제 최종 소유자가 런타임 데이터에 남지 않는다.

### 3.3 Validation 저장

- 파일 계약: `validation-save-v1`
- Legacy 저장과 파일·숨은 메모리를 격리한다.
- `reasoning_state`, `route_state`, `recovery_progress`, `candidate_records`를 보유한다.

위험:

- v1의 `correct_response_id`와 구형 recovery 의미를 v2 정답으로 오인할 수 있다.
- 완료 기록과 진행 중 기록을 같은 방식으로 변환하면 과거 결과가 소급 수정된다.

## 4. 제품 정체성과 버전

```yaml
episode_id: episode_001_afterlife_station
victim_id: victim_afterlife_station_001
victim_display_name: 이하린
content_contract_id: afterlife-station-canon-v2
content_schema: 2
legacy_content_contract: afterlife-station-legacy-v1
```

- `episode_id`와 `victim_id`는 저장·캠페인·보고서 정체성이다.
- `content_contract_id`는 어떤 규칙·데이터 의미를 적용할지 식별한다.
- 표시 이름 변경은 stable ID 변경이 아니다.
- 구형 완료 결과는 당시 콘텐츠 계약을 함께 기록해야 한다.

## 5. 레이어 아키텍처

### 5.1 예정 파일

```text
data/episodes/episode_001_afterlife_station.json
  역할: base_episode / 기존 런타임 호환 입력

data/episodes/episode_001_afterlife_station_core_validation.json
  역할: legacy_core_validation / 역사·Validation 이관 입력

data/episodes/episode_001_afterlife_station_canon_v2.json
  역할: canonical_v2 / 새 제품 정본 콘텐츠
```

### 5.2 명시적 활성화

암묵적 파일명 추론만으로 Canon v2를 활성화하지 않는다.

Episode manifest 또는 명시적 loader 요청이 다음을 지정해야 한다.

```yaml
active_content_contract: afterlife-station-canon-v2
loaded_layers:
  - base_episode
  - legacy_core_validation
  - canonical_v2
```

`loaded_layers`는 결과 데이터의 provenance로 남긴다.

### 5.3 병합 규칙

레이어 병합은 key별 allowlist를 사용한다.

```yaml
base_episode:
  may_provide:
    - episode identity
    - agents
    - shared equipment and rewards
    - stable scene entry IDs

legacy_core_validation:
  may_provide:
    - historical hypothesis evidence
    - legacy ID provenance
    - validation migration inputs
  may_not_override:
    - canonical_v2 investigation_manual
    - canonical_v2 rescue_protocol
    - canonical_v2 recovery_encounters
    - canonical_v2 result_contract

canonical_v2:
  owns:
    - investigation_manual
    - rescue_protocol
    - recovery_encounters
    - result_contract
    - current victim profile
```

구형 recovery_patterns와 Canon v2 patterns를 혼합하지 않는다. Canon v2가 활성화되면 legacy recovery 배열은 `legacy_content_snapshot`으로만 보존하고 전투 런타임 목록에 포함하지 않는다.

### 5.4 충돌 처리

- 소유자가 다른 동일 key: `CONTENT_LAYER_CONFLICT`
- 허용되지 않은 override: `DISALLOWED_LAYER_OVERRIDE`
- 필수 Canon v2 block 누락: `INCOMPATIBLE_CONTENT_CONTRACT`
- target episode 불일치: `CONTENT_EPISODE_MISMATCH`

충돌 시 base-only 실행으로 조용히 fallback하지 않는다.

## 6. Canon v2 데이터 책임

```yaml
investigation_manual:
  pages: []
  slots: []
  evidence_records: []
  candidate_keywords: []
  semantic_relations: []

rescue_protocol:
  stages: []
  official_route_requirements: {}
  ticket_requirements: {}
  risk_states: []
  retreat_policy: {}

recovery_encounters:
  patterns: []
  telegraph_events: []
  response_outcomes: []

result_contract:
  first_run: {}
  normal_clear: {}
  s_rank: {}
  approved_retreat: {}
  partial_truth_reveal: {}
  replay_mastery: {}
```

기존 `clues`, `hints`, `recovery_patterns`, `correct_response_id`는 새 구조의 권위 원본이 아니다.

## 7. Stable ID 규칙

ID는 화면 순서·표시 문구·배열 index가 아니라 의미를 기준으로 한다.

### 7.1 매뉴얼 페이지

```text
manual_afterlife_page_01_destination_projection
manual_afterlife_page_02_boundary_reset
manual_afterlife_page_03_official_return
```

### 7.2 슬롯 예시

```text
slot_afterlife_p01_broadcast_blank
slot_afterlife_p01_listener_memory
slot_afterlife_p01_destination_mismatch
slot_afterlife_p01_official_absence

slot_afterlife_p02_announcement_window
slot_afterlife_p02_projected_direction
slot_afterlife_p02_boundary_crossing
slot_afterlife_p02_position_reset
slot_afterlife_p02_persistent_time_records

slot_afterlife_p03_real_return_route
slot_afterlife_p03_wait_until_end
slot_afterlife_p03_official_identifier
slot_afterlife_p03_matching_ticket
slot_afterlife_p03_joint_disembarkation
```

### 7.3 단서 `[기록]`

```text
record_afterlife_r1_broadcast_original
record_afterlife_r1_victim_phone_destination
record_afterlife_r1_concurrent_destination_mismatch
record_afterlife_official_operation_log
record_afterlife_r2_continuous_recording
record_afterlife_r2_phone_time_battery
record_afterlife_r2_object_position
record_afterlife_r2_directional_boundary_test
record_afterlife_r3_transit_history
record_afterlife_r3_official_route_map
record_afterlife_r3_station_identifier
record_afterlife_r3_ticket_comparison
record_afterlife_r3_boarding_disembarkation
```

공식 운행 기록처럼 여러 장에서 쓰는 증거는 하나의 canonical record와 복수 `usage_refs`를 사용한다.

```yaml
id: record_afterlife_official_operation_log
source_id: source_afterlife_control_log
usage_refs:
  - manual_afterlife_page_01_destination_projection
  - manual_afterlife_page_03_official_return
```

### 7.4 패턴과 대응

```text
pattern_afterlife_nonstop_farewell
pattern_afterlife_recurring_platform
pattern_afterlife_destination_chorus

response_afterlife_present_official_ticket
response_afterlife_anchor_persistent_trace
response_afterlife_insert_official_identifier
```

## 8. Migration Registry

Registry는 각 구형 ID를 다음 disposition 중 하나로 분류한다.

- `KEEP_ID`: 동일 정체성과 의미 유지
- `ALIAS`: 구형 ID를 새 단일 ID로 읽기 전용 변환
- `SPLIT`: 구형 ID 하나를 복수 새 기록으로 분리
- `MERGE`: 복수 구형 ID를 새 단일 기록으로 통합
- `HISTORICAL_ONLY`: 과거 보고서에만 보존, 새 런타임 미적용
- `DISCARD_SEMANTICS`: 문자열·ID 계보는 보존하되 현재 규칙으로 사용 금지

각 entry는 다음 필드를 가진다.

```yaml
legacy_id: string
disposition: KEEP_ID | ALIAS | SPLIT | MERGE | HISTORICAL_ONLY | DISCARD_SEMANTICS
target_ids: []
source_contract: string
target_contract: afterlife-station-canon-v2
reason: string
effect_id: string
runtime_apply: bool
preserve_in_history: bool
```

`effect_id`는 이관 효과의 apply-once 키다. 동일 migration을 두 번 적용해도 중복 효과가 없다.

미매핑 ID:

```yaml
orphan_legacy_ids:
  - id: string
    source_contract: string
    source_location: string
    raw_value: optional
    reason: UNMAPPED_LEGACY_ID
```

미매핑 ID는 런타임에는 적용하지 않는다.

## 9. 본편 저장 이관

### 9.1 버전 정책

```yaml
readable_versions:
  - mvp-038
  - mvp-039
new_write_version: mvp-040
```

### 9.2 저장 순서

1. `user://urban_legend_save.json` 원본 저장 bytes를 먼저 backup한다.
2. 현재 메모리의 보호 대상 snapshot을 생성한다.
3. source version·episode ID·content contract·진행 단계를 inspect한다.
4. migration을 별도 메모리 payload에서 실행한다.
5. v2 validator와 ID registry validation을 실행한다.
6. temp 파일에 `mvp-040`을 작성하고 재읽기 검증한다.
7. 검증 성공 후에만 primary를 교체한다.
8. 실패 시 기존 파일과 메모리 모두 변경하지 않는다.
9. migration 실패를 Legacy 저장으로 fallback하지 않는다.

### 9.3 단계별 처리

#### 사건 미시작·준비 단계

- 기존 캠페인·경제·관계·해금 유지
- 저승역 진입 시 Canon v2 신규 run 생성
- 과거 clue·pattern을 자동 획득 처리하지 않음

#### 조사 진행 중

- 구형 clue를 Migration Matrix에 따라 보수적으로 `[기록]`으로 변환
- SPLIT entry는 source record를 보존하고 target 기록을 `migrated_unverified`로 생성
- 새 매뉴얼의 정답 슬롯은 자동으로 채우지 않는다.
- manual state는 `draft_active`
- 기존 위험·조사 로그는 `legacy_migration_notes`에 보존
- 안전한 조사 진입 checkpoint에서 재개

#### 구출·회수 진행 중

구형 대응 정답과 새 절차의 의미가 달라 직접 변환하지 않는다.

- 캠페인·경제·관계·장기 해금 보존
- 진행 중 저승역 run은 `LEGACY_CASE_RESTART_REQUIRED`
- 원본 save backup 유지
- Canon v2 사건 시작 또는 안전 조사 진입 checkpoint로 재시작
- 재시작으로 등급·보상·위험 페널티를 추가하지 않음
- 구형 선택은 역사 note로만 보존

#### 사건 완료 상태

- 과거 결과를 `legacy_resolution_snapshot`으로 보존
- 새 S 랭크·새 매뉴얼 정답으로 소급 변환하지 않음
- Canon v2 첫 도전은 별도 `first_v2_investigation`으로 기록
- 과거 보상을 다시 지급하지 않는다.
- 기존 캠페인 해결 여부는 제거하지 않되 제품 보고서에 콘텐츠 계약을 표시

## 10. Validation 저장 이관

### 10.1 버전 정책

```yaml
readable_versions:
  - validation-save-v1
new_write_version: validation-save-v2
```

### 10.2 완료 기록

완료된 v1 기록은 읽기 전용 역사 결과로 유지한다.

- 당시 flow stage·result axes·candidate records 보존
- 구형 correct_response_id를 새 정답으로 사용하지 않는다.
- 새 S 랭크나 Canon v2 매뉴얼 완료로 승격하지 않음

### 10.3 active·suspended v1

active·suspended v1은 안전 조사 checkpoint로 변환한다.

- `reasoning_state`의 구형 clue·hypothesis를 migration note로 변환
- `route_state`의 구형 경로 정답을 자동 적용하지 않음
- `recovery_progress`는 완료 이력이 아니라 역사 snapshot으로 이동
- 새 매뉴얼 슬롯 자동 채움 금지
- Validation 저장 실패 시 Legacy 파일로 fallback 금지
- Validation 작업 전후 Legacy 파일·숨은 메모리는 동일해야 한다.

## 11. 오류와 결과 코드

```text
EXACT_V2
MIGRATED_FROM_MVP_038
MIGRATED_FROM_MVP_039
MIGRATED_FROM_VALIDATION_V1
LEGACY_CASE_RESTART_REQUIRED
UNMAPPED_LEGACY_ID
AMBIGUOUS_SPLIT_MAPPING
CONTENT_LAYER_CONFLICT
DISALLOWED_LAYER_OVERRIDE
INCOMPATIBLE_CONTENT_CONTRACT
CONTENT_EPISODE_MISMATCH
CORRUPT_MIGRATION_SOURCE
MIGRATION_VALIDATION_FAILED
ROLLBACK_RESTORED
```

### Fail-closed 원칙

- unknown ID를 삭제하지 않음
- unknown ID를 실행하지 않음
- 불완전 target을 primary로 쓰지 않음
- 구형 정답을 추정하여 새 정답으로 만들지 않음
- 오류 발생 후 반쪽 migration 상태로 게임을 계속하지 않음

## 12. 원자성·롤백

보호 대상:

- 원본 본편 저장 bytes
- Validation primary·backup bytes
- campaign schedule·operation·resolved cases
- economy·inventory·equipment
- faction·relationship·long-term unlock
- completed reports·reward claim IDs
- ANNUAL·PoC state

migration 적용 전후 semantic snapshot을 비교한다. 허용된 target 필드 외 차이가 있으면 `MIGRATION_VALIDATION_FAILED` 후 원상 복구하고 `ROLLBACK_RESTORED`를 반환한다.

## 13. 컴포넌트 경계

Package A 구현 계획에서 다룰 예정 단위:

1. `AfterlifeCanonV2Loader`
   - sidecar parse·schema validate·allowlist layer merge
2. `AfterlifeIdMigrationRegistry`
   - ID disposition lookup·effect_id·orphan 기록
3. `AfterlifeLegacySaveInspector`
   - source version·진행 단계·content contract 판정
4. `AfterlifeMainSaveMigrator`
   - mvp-038/039 → mvp-040 memory migration
5. `AfterlifeValidationSaveMigrator`
   - validation-save-v1 → v2 memory migration
6. `AfterlifeMigrationTransaction`
   - backup·temp write·validation·replace·rollback 조정

각 단위는 파일 I/O와 의미 변환을 동시에 소유하지 않는다. Inspector는 읽기 전용이고 Registry는 파일을 쓰지 않으며 Transaction만 교체를 조정한다.

## 14. 테스트 설계

구현은 다음 RED부터 시작해야 한다.

### 콘텐츠·레이어

- Episode ID와 victim ID 유지
- Canon v2 sidecar 미지정 시 기존 실행 경로 변화 없음
- manifest가 v2를 명시할 때만 활성화
- layer allowlist 외 override 거부
- 구형 recovery pattern과 v2 pattern 혼합 금지
- provenance `loaded_layers` 보존

### 본편 저장

- mvp-039 원본 파일 bytes 보호
- migration 실패 시 파일·메모리 롤백
- 조사 중 clue의 보수적 기록 이관
- 정답 슬롯 자동 채움 금지
- 전투 중 저장의 `LEGACY_CASE_RESTART_REQUIRED`
- 완료 보고서 소급 S 랭크 금지
- 과거 보상 중복 지급 금지

### ID 의미

- 검은 승차권 패턴의 자동 정답 변환 금지
- `poc001_clue_reset_timing`의 같은 시각 의미 폐기
- SPLIT source provenance 보존
- orphan legacy ID 보존·런타임 미적용
- 동일 migration을 두 번 적용해도 중복 효과가 없다.

### Validation

- Validation v1 완료 기록 read-only 유지
- active·suspended v1 안전 checkpoint 변환
- Validation migration 중 Legacy file bytes 무변경
- Legacy 숨은 메모리 무변경
- Validation 실패 후 Legacy fallback 금지

## 15. 적대적 검토

### 위험 1 — sidecar가 새 진실과 구형 진실을 혼합

대응: block 소유권과 allowlist를 강제하고 recovery list 혼합을 금지한다.

### 위험 2 — SPLIT가 정답을 자동 제공

대응: split target은 `migrated_unverified`; 매뉴얼 슬롯 자동 배치 금지.

### 위험 3 — 완료 플레이어가 보상을 다시 획득

대응: 기존 reward claim·resolved state 유지, Canon v2 결과와 별도 contract provenance 기록.

### 위험 4 — 진행 중 전투를 억지로 변환해 불가능 상태 생성

대응: `LEGACY_CASE_RESTART_REQUIRED`; 진행 외 메타 상태 보존, 무페널티 안전 재시작.

### 위험 5 — Validation 이관이 본편 저장을 오염

대응: 기존 Validation isolation과 hidden-state guard를 그대로 유지한다.

### 위험 6 — 새 victim ID 생성으로 과거 기록 분리

대응: stable ID 유지, display profile만 v2에서 정본화한다.

## 16. 범위 경계

### In scope

- 구현 이관 아키텍처
- Canon v2 sidecar 계약
- ID Migration Matrix
- 본편·Validation 저장 호환과 롤백 정책
- 구현 계획을 위한 테스트 목록

### Out of scope

- 실제 `episode_001_afterlife_station_canon_v2.json` 작성
- loader·migrator·registry 코드
- `mvp-040`·`validation-save-v2` 실제 Schema 변경
- 매뉴얼·구출·회수 UI
- 피해량·턴 수·취약 수치
- Scene·자산·이미지
- Human QA 실행
- PR 병합

게임 코드·Scene·Episode JSON·저장 Schema·자산을 변경하지 않는다.

## 17. 다음 Gate

1. 사용자 문서 검토 승인
2. `docs/superpowers/plans/2026-08-05-afterlife-station-canon-v2-migration-implementation-plan.md` 작성
3. 계획 자체 적대적 검토
4. 별도 구현 승인
5. 승인 후 Codex TDD 구현

사용자 문서 검토 승인 후 implementation plan으로 전환한다. 현재 구현·Human QA·이미지·자산 제작은 `NOT_AUTHORIZED / NOT_RUN / NOT_STARTED`다.
