# 저승역 정본 Source Map과 구형 자료 상태

- 감사 ID: `AUDIT-2026-08-04-AFTERLIFE-STATION-CANONICALIZATION`
- 상태: `CANONICAL_SOURCE_MAP / BATCH_4_COMPLETE / IMPLEMENTATION_MIGRATION_NOT_AUTHORIZED`
- 정본 Batch: `GRILLME_BATCH_4_10_OF_10`
- Draft PR: `#143`

이 문서는 저승역 관련 파일의 권위와 대체 관계를 강제한다. 아래 상태 표시는 각 파일 상단에 직접 적힌 배너와 동일한 권위를 가진다. 런타임 JSON·Scene·스크립트는 저장·회귀 호환성을 보호하기 위해 이번 Design PR에서 직접 변경하지 않으며, 이 표를 통해 현재 제품 정본으로 오인하지 못하게 한다.

## 상태 정의

- `[정본]`: 현재 제품 기획의 권위 원본. 충돌 시 우선한다.
- `[대체됨]`: 역사·근거로 보존하되 현재 제품 규칙으로 참조하지 않는다.
- `[보류]`: 구현·회귀·이관 입력으로 유지하지만 현행 설계와 일치한다고 간주하지 않는다.
- `[폐기]`: 제품 규칙·해법·정답으로 재사용하지 않는다. 역사적 테스트 ID 보존만 가능하다.
- `[유지]`: 범용 런타임·로더·테스트 기반이며 새 정본과 직접 충돌하지 않는다.

## 1. 현재 정본

### 통합 권위

- `[정본] docs/planning/2026-08-04-afterlife-station-complete-case-batch-4.md`
- `[정본] docs/GRILLME_BATCH_4_LEDGER.md`
- `[정본] docs/planning/2026-08-04-afterlife-station-canonical-source-map-and-legacy-disposition.md`
- `[정본] docs/audits/2026-08-04-afterlife-station-batch-4-canonicalization-audit.md`

### 제품 Decision

1. `[정본] docs/decisions/D-2026-08-04-AFTERLIFE-STATION-PERSONAL-DESTINATION-PROJECTION.md`
2. `[정본] docs/decisions/D-2026-08-04-AFTERLIFE-STATION-DESTINATION-BOUNDARY-RESET.md`
3. `[정본] docs/decisions/D-2026-08-04-AFTERLIFE-STATION-OFFICIAL-ROUTE-TICKET-AND-CORRECT-DISEMBARKATION.md`
4. `[정본] docs/decisions/D-2026-08-04-AFTERLIFE-STATION-NONSTOP-FAREWELL-TICKET-COUNTER.md`
5. `[정본] docs/decisions/D-2026-08-04-AFTERLIFE-STATION-RECURRING-PLATFORM-PERSISTENT-TRACE-ANCHOR.md`
6. `[정본] docs/decisions/D-2026-08-04-AFTERLIFE-STATION-DESTINATION-CHORUS-SILENCE-COUNTER.md`
7. `[정본] docs/decisions/D-2026-08-04-AFTERLIFE-STATION-THREE-CHAPTER-MANUAL-AND-CANDIDATE-POOLS.md`
8. `[정본] docs/decisions/D-2026-08-04-AFTERLIFE-STATION-FIRST-TEN-MINUTES-INVESTIGATION-PACING.md`
9. `[정본] docs/decisions/D-2026-08-04-AFTERLIFE-STATION-OUTCOME-GRADE-AND-REINVESTIGATION.md`
10. `[정본] docs/decisions/D-2026-08-04-AFTERLIFE-STATION-VISUAL-ART-AND-INFORMATION-LANGUAGE.md`

### 책임 Section

- `[정본] docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-01-personal-destination-projection.md`
- `[정본] docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-02-destination-boundary-reset.md`
- `[정본] docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-03-official-route-ticket-and-correct-disembarkation.md`
- `[정본] docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-04-nonstop-farewell-ticket-counter.md`
- `[정본] docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-05-recurring-platform-persistent-trace-anchor.md`
- `[정본] docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-06-destination-chorus-silence-counter.md`
- `[정본] docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-07-three-chapter-manual-and-candidate-pools.md`
- `[정본] docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-08-first-ten-minutes-investigation-pacing.md`
- `[정본] docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-09-outcome-grade-and-reinvestigation.md`
- `[정본] docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-10-visual-art-and-information-language.md`

## 2. 구형 제품 데이터

### `data/episodes/episode_001_afterlife_station.json`

상태: `[보류] 구현 호환 입력 / 저승역 의미 규칙은 [대체됨]`

보존 이유:

- 현재 본편 Episode ID와 기존 저장·Scene·테스트가 참조할 수 있다.
- Codex 이관 전 삭제·이름 변경·ID 변경을 금지한다.

대체 관계:

- `[대체됨] episode.anomaly_core = 저승역 반복 안내 잔향이 각인된 검은 승차권`
  - 새 정본: 괴이 핵심은 목적지 공백에 개인 귀환 기억이 투영되고 성급한 경계 통과를 붙잡는 현상이다.
- `[대체됨] 안내 종료 전 이동하면 위치가 초기화된다`
  - 새 정본: 모든 이동이 아니라 자신이 들은 목적지를 향한 승차선·계단·출구 경계 통과가 조건이다.
- `[대체됨] 익명 피해자·구형 단서·힌트·구출·회수 패턴 문구`
  - 새 정본: 피해자 이하린, 3장 매뉴얼, 장별 후보 풀, 공식 승차권 구출, 대표 패턴 3종.

### `data/episodes/episode_001_afterlife_station_core_validation.json`

상태: `[보류] CORE-VALIDATION 회귀·이관 입력 / 회수 패턴 의미는 [대체됨]`

- 기존 pattern/response ID는 저장·테스트 이관표 작성 전 삭제하지 않는다.
- 기존 4개 회수 패턴과 정답 대응은 새 대표 패턴 3종의 제품 정본이 아니다.
- 구형 가설·근거 UI의 원문은 역사적 검증 근거로만 사용한다.
- 새 정본 회수 패턴:
  - `[무정차 환송]`
  - `[회귀 승강장]`
  - `[목적지 합창]`

### `data/poc/core_mvp_001/afterlife_station_poc.json`

상태: `[보류] 독립 PoC 회귀 입력 / 사건 콘텐츠는 [대체됨]`

필드 단위 폐기:

- `[폐기] poc001_clue_reset_timing.text의 같은 시각으로 되돌아왔다`
  - 새 정본은 시간·녹음·배터리·기록이 계속 진행되고 위치만 초기화된다.
- `[폐기] poc001_question_ticket_trigger를 사건 핵심 미해결로 취급`
- `[폐기] poc001_manual_ticket_contact_danger를 핵심 금지 행동으로 취급`
- `[폐기] 검은 승차권 접촉·파괴가 구출 또는 회수의 기본 정답이라는 해석`
- `[폐기] 고정 5턴·자동 예측 중심 회수 구조를 향후 제품 기준으로 사용하는 것`

보존 가능:

- 독립 상태 머신·로그·회귀 실행의 기술 구조
- 기존 ID를 새 ID로 이관하기 위한 비교 자료
- 과거 자동 검증 증거

## 3. 구형 PoC 런타임과 테스트

다음 경로는 모두 `[보류] IMPLEMENTATION_MIGRATION_INPUT`이다.

- `scenes/poc/core_mvp_001/core_mvp_001_scene.tscn`
- `scripts/poc/core_mvp_001/core_mvp_001_case_data.gd`
- `scripts/poc/core_mvp_001/core_mvp_001_playtest_log.gd`
- `scripts/poc/core_mvp_001/core_mvp_001_scene.gd`
- `scripts/poc/core_mvp_001/core_mvp_001_state.gd`
- `tests/core_mvp_001_case_data_test.gd`
- `tests/core_mvp_001_playtest_log_test.gd`
- `tests/core_mvp_001_scene_test.gd`
- `tests/core_mvp_001_state_test.gd`
- `tests/test_core_mvp_001_data_contract.py`
- `tests/test_core_mvp_001_static_contract.py`

규칙:

- 현재 제품 정본으로 참조하지 않는다.
- 기존 회귀를 유지하되 새 정본 구현 시 별도 migration Decision과 Codex 계획이 필요하다.
- 이관 완료 전 삭제하지 않는다.
- 이관 뒤에도 저장 호환·회귀 증거가 필요하면 archive로 이동하고 `[대체됨]` 상태를 유지한다.

## 4. 구형 문서와 연구 Artifact

### `[대체됨] 제품 규칙 / [보류] 역사·QA 증거`

완료된 QA 문서의 정확한 경로는 활성 Planning 문서에서 직접 링크하지 않고, `docs/audits/2026-08-04-afterlife-station-batch-4-canonicalization-audit.md`의 Legacy Evidence 부록이 소유한다.

다음 역사적 기획·연구 Artifact는 제품 규칙이 `[대체됨]`이며 이관 근거로 `[보류]`한다.

- `docs/superpowers/plans/2026-07-23-core-mvp-001-implementation-plan.md`
- `docs/superpowers/plans/2026-07-23-project-core-mvp-rebase.md`
- `docs/superpowers/specs/2026-07-23-project-core-finalization-design.md`
- `docs/superpowers/specs/2026-07-23-project-core-integrated-spec.md`
- `docs/superpowers/plans/2026-07-29-hypothesis-board-human-validation-artifact.md`

이 문서들의 PoC·가설 보드·고정 회수 규칙은 새 저승역 제품 정본을 정의하지 않는다. 테스트 방법·과거 Finding·ID 계보만 역사 증거로 유지한다.

### `[보류] 범용 프로젝트 문서`

- `docs/CURRENT_CONFIRMED_DECISIONS.md`
- `docs/CURRENT_HANDOFF_VALIDATION.md`
- `docs/VALIDATION_TARGET_CANON.md`
- `docs/PROJECT_CORE.md`
- `docs/GAME_DESIGN_DOCUMENT.md`

이 문서의 프로젝트 전체 원칙은 유지한다. 다만 저승역 상세 규칙이나 `GRILLME_BATCH_3_OPEN` 같은 이전 상태가 이 Source Map과 충돌하면 해당 부분은 `[대체됨]`이며 Batch 3 merge `830b0ac41f5f0f549d34cd703194db2a6e7e63b0`과 Batch 4 정본을 우선한다.

## 5. 유지되는 범용 구현

다음은 `[유지]`이며 새 저승역 콘텐츠 구현 시 재사용 가능 여부를 Codex가 검토한다.

- `scripts/data/episode_loader.gd`
- `scripts/scenes/investigation_scene.gd`
- `scripts/scenes/battle_scene.gd`
- `scripts/scenes/result_scene.gd`
- `scripts/core/game_state.gd`
- `scenes/battle_scene.tscn`

`[유지]`는 새 정본 구현 완료를 뜻하지 않는다. 제품 데이터와 상태 전이의 실제 적합성은 `NOT_RUN`이다.

## 6. 구현 이관 Gate

Codex 작업 전 필수 산출물:

1. 구형 ID → 새 매뉴얼·기록·패턴 ID migration matrix
2. save `mvp-039` 및 Validation 저장 호환 정책
3. 구형 패턴 4개 → 새 패턴 3개 이관·archive 정책
4. 이하린 피해자 데이터와 기존 victim ID 처리
5. Episode JSON·PoC JSON·core-validation overlay의 권위 통합안
6. RED/GREEN 계약 테스트
7. 사람 콘텐츠 공정성·첫 10분·접근성 QA 계획

사용자 별도 구현 승인 전 게임 코드·Scene·JSON·자산을 변경하지 않는다.
