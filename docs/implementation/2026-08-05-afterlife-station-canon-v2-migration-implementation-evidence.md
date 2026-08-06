# 저승역 Canon v2 Migration 구현 증거

- 책임 Decision: `D-2026-08-05-AFTERLIFE-STATION-CANON-V2-MIGRATION-DESIGN`
- 운영 Decision: `D-2026-08-05-WORKFLOW-BENCHMARK-TDD-AND-CHECKPOINT-POLICY`
- 상태: `IMPLEMENTATION_COMPLETE / AUTOMATED_QA_GREEN / HUMAN_QA_NOT_RUN / MERGE_NOT_AUTHORIZED`
- 구현 승인: `2026-08-05 KST / 사용자 명시 승인`
- Design·Plan PR: `PR #145 / Draft / 미병합`
- 구현 PR: `PR #146 / Draft / 미병합`
- 검증된 제품 구현 HEAD: `1e2473889b68b4a714300133da180f1eb1a08414`
- 이미지·게임 자산 변경 없음

## 1. 구현 범위

승인된 구현 계획의 `Task 1~9`를 TDD로 수행했다.

1. Canon v2 sidecar·Schema 계약
2. 명시적 Loader와 계산된 provenance
3. ID Migration Registry·checksum·apply-once 이력
4. 읽기 전용 Legacy Save Inspector
5. 본편 `mvp-038/039 → mvp-040` 메모리 Migrator
6. Validation `validation-save-v1 → validation-save-v2` Migrator
7. 2단계 atomic transaction과 파일·메모리 rollback
8. GameState·ValidationSession 통합
9. focused runner·전체 회귀·런타임 호환 투영

구현은 기존 사건·피해자 stable ID를 유지한다.

```text
episode_001_afterlife_station
victim_afterlife_station_001
```

새 콘텐츠 계약은 명시적으로만 활성화된다.

```text
afterlife-station-canon-v2
content_schema: 2
```

## 2. 핵심 구현 결과

### 콘텐츠와 Loader

- Canon v2 권위 데이터: `data/episodes/episode_001_afterlife_station_canon_v2.json`
- 런타임 호환 투영: `data/episodes/episode_001_afterlife_station_canon_v2_runtime_projection.json`
- ID Registry: `data/migrations/afterlife_station_canon_v2_id_migration.json`
- 기본 `load_episode()` 경로는 Legacy 동작을 유지한다.
- `load_episode_contract()`만 Canon v2를 명시 활성화한다.
- `loaded_layers`와 layer checksum은 Loader가 실제 입력으로 계산하며 sidecar가 주장할 수 없다.

### 구형·신규 콘텐츠 분리

Canon v2의 권위 구조는 `investigation_manual`, `rescue_protocol`, `recovery_encounters`, `result_contract`다.

기존 전투 UI가 요구하는 `clues`와 `recovery_patterns`는 구형 데이터를 재사용하지 않고 Canon v2 ID에서만 생성한 `canonical_v2_projection`이다.

- projected record ID: `record_afterlife_*`
- projected pattern ID: `pattern_afterlife_*`
- projected response ID: `response_afterlife_*`
- 구형 `pattern_station_*`와 `clue_*`는 실행 상태에서 배제한다.
- 구형 Core Validation 내용은 `legacy_content_snapshot`에만 보존한다.
- runtime projection은 별도 checksum으로 추적하고 Canon v2 record·pattern·response ID와 교차검증한다.

### 저장 이관

- 본편 readable: `mvp-038`, `mvp-039`
- 본편 new write: `mvp-040`
- Validation readable: `validation-save-v1`
- Validation new write: `validation-save-v2`
- SPLIT 결과는 `migrated_unverified`이며 매뉴얼 정답 슬롯을 자동 완성하지 않는다.
- 진행 중 구형 구출·회수는 `LEGACY_CASE_RESTART_REQUIRED`로 안전 조사 checkpoint에서 무페널티 재시작한다.
- 완료된 구형 결과는 `legacy_resolution_snapshot`으로 보존하며 새 등급·보상을 소급 지급하지 않는다.
- 미매핑 ID는 `orphan_legacy_ids`에 보존하고 실행하지 않는다.

### Transaction

```text
PREPARED
→ COMMITTED_PENDING_RUNTIME_APPLY
→ FINALIZED
```

- inspect 시점과 commit 직전 `source_checksum`을 비교한다.
- temp write·readback·validator·backup·promote를 분리한다.
- runtime apply 실패 시 원래 메모리와 원본 파일을 함께 복구한다.
- crash journal을 사용해 `PREPARED`·`COMMITTED_PENDING_RUNTIME_APPLY` 상태를 복구한다.
- 동일 `effect_id` 재적용은 중복 효과 없이 차단한다.

## 3. TDD RED → GREEN 증거

각 Task는 실패 계약을 먼저 실행한 뒤 최소 구현과 GREEN 검증을 수행했다.

### 런타임 투영 조기 체크포인트

- RED run `30972203323`
  - 기존 7개 focused 계약 PASS
  - Canon v2 runtime recovery projection 부재로 새 계약 FAIL
- 확장 RED run `30972503634`
  - recovery pattern과 record/clue projection provenance 부재 검출
- GREEN 제품 구현 HEAD `1e2473889b68b4a714300133da180f1eb1a08414`
  - Canon v2 pattern·record 호환 투영과 legacy 실행 데이터 배제 확인

### 최종 자동 검증

- Canon v2 Migration run `30973078497`: SUCCESS
  - Validation Canon activation: PASS
  - focused 8/8: PASS
  - full Godot regression: PASS
- CORE-MVP-001 run `30973078429`: SUCCESS
  - Validation Package 1: PASS
  - Validation Package 2: PASS
  - CORE focused: PASS
  - full Godot regression: PASS
- ANNUAL-MVP-001 run `30973078408`: SUCCESS
  - Validation Package 1·2: PASS
  - CORE·ANNUAL-MVP-001·ANNUAL-MVP-002 focused: PASS
  - Canon v2 focused 8/8: PASS
  - full Godot regression: PASS

## 4. 적대적 검토에서 발견·교정한 문제

### provenance 위조 위험

sidecar가 `loaded_layers`를 직접 선언할 수 있던 위험을 제거했다. Loader가 실제로 읽고 검증한 세 권위 레이어와 checksum만 반환한다.

### 반쪽 이관 위험

파일 교체 후 live memory 적용이 실패하면 파일만 v2가 되는 문제를 2단계 transaction과 rollback으로 차단했다.

### Godot checksum API 오류

존재하지 않는 정적 checksum API 가정을 저장소의 인스턴스형 `HashingContext.start/update/finish` 패턴으로 교정했다.

### 다른 사건 저장 오염

저승역 전용 `mvp-040` validator가 붉은 우산 골목 등 다른 사건 저장까지 막던 범위를 축소했다. 저승역만 Canon v2 write path를 사용하고 다른 사건은 기존 `super.save_game()` 경로를 유지한다.

### Validation Autoload 격리 계약

Autoload를 migration wrapper로 전환하되 기존 `validation_session.gd`와 `validation_game_state.gd`의 공개 계약·저장 격리를 상속하고 검증한다.

### 기존 전투 인터페이스 충돌

`recovery_encounters`만 제공하면 기존 전투 UI가 비어 버리는 문제를 발견했다. 구형 `recovery_patterns`를 다시 섞지 않고 Canon v2 원본 ID에서만 런타임 호환 뷰를 생성했다.

## 5. 변경 범위

변경됨:

- Canon v2 Episode sidecar와 runtime projection
- ID migration registry
- Loader·Inspector·Migrator·Transaction
- GameState·ValidationSession migration wrapper
- Autoload 경로
- focused runner·CI·회귀 계약
- 구현 테스트·증거 문서

변경하지 않음:

- Scene 구조
- 이미지·게임 자산
- 기존 Episode·PoC·Core Validation 원본 삭제
- 구형 저장 원본의 강제 삭제
- Human QA 판정
- PR 병합

## 6. 남은 Gate

현재 자동화 수준의 구현과 회귀는 GREEN이지만 다음은 별도다.

- `HUMAN_QA_NOT_RUN`
- 실제 플레이에서 구형 저장 fixture 복원 확인
- 플랫폼별 파일 잠금·강제 종료·디스크 오류 시나리오
- UI에서 Canon v2 record·pattern 문구와 접근성 확인
- 결과·보상 중복 여부의 실제 캠페인 플레이 확인
- PR #145 문서 정본 병합 여부 결정
- PR #146 구현 결과 승인
- 별도 merge approval

따라서 현재 상태는 `IMPLEMENTATION_COMPLETE / AUTOMATED_QA_GREEN`이며 출시·Human QA·병합 완료를 의미하지 않는다. `MERGE_NOT_AUTHORIZED`를 유지한다.
