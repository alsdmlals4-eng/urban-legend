# Urban Legend 시작 지점

새 채팅·새 GPT·새 Codex·새 작업자가 괴이기록국을 **현재 정본과 실제 main**에서 안전하게 시작하는 최상위 라우터다.

## 기본 읽기

```text
최신 사용자 지시
→ START_HERE.md
→ AGENTS.md
→ GitHub latest main ref + open PR/Issue 상태
→ docs/OPERATING_MODEL.md
→ docs/WORK_MODE_AND_SKILL_ROUTING.md
→ Notion 괴이기록국 프로젝트 홈
→ docs/CURRENT_PLANNING_CANON.md
→ docs/current-planning-canon.json
→ docs/CURRENT_DECISION_OVERLAY.md
→ docs/CURRENT_HANDOFF.md
→ docs/DOCUMENTATION_MAP.md
→ skills/SKILL_REGISTRY.json
→ 실제 main 코드·데이터·Scene·테스트
→ 작업에 필요한 조건부 원본만 추가
```

2026-08-22 Reality Gate / Design / Implementation Plan은 **PR #224로 실행 완료된 구현 provenance**다. 새 작업을 Task 1부터 다시 시작하지 않는다.

- Reality Gate: `docs/audits/2026-08-22-final-planning-implementation-reality-gate.md`
- Design: `docs/superpowers/specs/2026-08-22-post-planning-runtime-reconciliation-design.md`
- Plan: `docs/superpowers/plans/2026-08-22-post-planning-runtime-reconciliation-implementation-plan.md`

Validation·저승역·장기 구현 Ledger·승인 역사처럼 작업 주제가 요구할 때만 다음을 추가한다.

- Validation: `docs/VALIDATION_TARGET_CANON.md`
- 저승역 상세 규칙: `docs/CURRENT_AFTERLIFE_STATION_CANON.md`
- 장기 구현·검증 이력/evidence ceiling: `docs/CURRENT_STATUS.md`
- 상세 승인·대체 역사: `docs/CURRENT_CONFIRMED_DECISIONS.md`
- 과거 Validation 인수인계: `docs/CURRENT_HANDOFF_VALIDATION.md`

## 현재 권위 구분

```text
GitHub latest main ref
= 현재 정확한 commit과 실제 구현 기준

Notion 프로젝트 홈
= 사람이 보는 전체 그림·Flow·비교표·현재 승인 방향

docs/CURRENT_PLANNING_CANON.md + docs/current-planning-canon.json
= 월 1사건 제품 구조·M01/M04 역할·현재 Planning/Implementation Gate 정본

docs/CURRENT_DECISION_OVERLAY.md
= current mutable decision·verified successor state

docs/CURRENT_HANDOFF.md
= 현재 continuation router

docs/CURRENT_STATUS.md
= 장기 구현·검증·ANNUAL/CORE 계보와 evidence ceiling을 보존하는 조건부 Ledger

실제 main 코드·테스트
= 구현 사실
```

같은 질문에 여러 문서가 다른 시대의 상태를 말하면 **최신 사용자 지시 → GitHub latest main → Notion current planning → CURRENT_PLANNING_CANON/current-planning-canon.json → CURRENT_DECISION_OVERLAY → CURRENT_HANDOFF → 분야별 current canon → 실제 code/test → 조건부 역사 ledger** 순서로 판정한다.

## 현재 제품·Gate Snapshot

```yaml
product_cadence: ONE_MAIN_CASE_PER_MONTH
initial_slate: M01_TO_M12
continuous_after_m12: true
first_session: M01_AFTERLIFE_STATION
release_near_vertical_slice: M04_RED_UMBRELLA
PLANNING_COMPLETE: true
USER_FINAL_PLANNING_DECLARATION_APPROVED: true
non_visual_planning: COMPLETE
visual_planning: COMPLETE
product_reference_asset: PENDING
overall_plan: COMPLETE
planning_lock: RELEASED_TO_IMPLEMENTATION_GATE
runtime_implementation: MERGED_MAIN
runtime_merge_commit: 8d303f0f9414950273be934fd28c8fb1b3a21e18
automated_exact_head: GREEN
human_qa: NOT_RUN
new_player_validation: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
base_adapter_baseline_reconciliation: REQUIRED
```

- M01 저승역은 첫 세션·온보딩·회귀 사건이다.
- M04 빨간 우산은 약 30~45분 release-near player-experience Vertical Slice다.
- runtime reconciliation은 PR #224로 main에 병합됐다.
- concrete product-reference asset은 별도 `PENDING`이다.
- Human QA는 자동화와 별개로 `NOT_RUN`이다.
- `ANNUAL-MVP-001/002`는 current cadence가 아니라 병합된 runtime/history ID다.

## Verified successor와 미완료를 구분한다

### Canon v2 runtime / save migration

```text
EXISTING_CANON_V2_RUNTIME_REUSE
```

기존 loader, ID registry, save migrator, transaction, active GameState를 유지한다. 2026-08-05 migration plan을 다시 구현하지 않는다.

### Composite Result

```text
COMPOSITE_RESULT = CURRENT_RESULT_AUTHORITY
LEGACY_S_RANK = HISTORY_MASTERY_COMPATIBILITY_ONLY
```

PR #224에서 stale S-rank ownership을 realign했다. 단일 등급은 현재 사건의 피해자·통제·증거·보호·잔향·후속 축을 덮어쓰지 않는다.

### monthly_state

```text
IMPLEMENTED_ADDITIVE_OPTIONAL
```

월간 orchestration만 소유한다. case truth 저장, legacy report 기반 month-complete 추론, 같은 달 두 번째 main case 생성은 금지된다.

### M01 First Session

```text
IMPLEMENTED / AUTOMATED_REGRESSION_GREEN / HUMAN_NOT_RUN
```

10단계 causal orchestration과 `SERIAL_EXAM_FATIGUE_GUARD`를 사용한다. 조사에서 얻은 같은 기록/규칙을 추리→구출→회수에 재사용하며 orchestrator는 별도 hidden answer owner가 아니다.

### 조사·회수 UI hierarchy

PR #180은 predecessor UI successor로 이미 main에 병합되어 있다. 요청형 manual/progressive disclosure, 조사 focus/pointer-through 보정, contextual cut-in은 PR #224 구현이 재사용한다. **PR #180 병합 완료**는 predecessor history이며 current truth는 latest main이다.

### 메인 메뉴 Ver 4.3

```text
IMPLEMENTED / ISSUE_181_CLOSED
```

- `scripts/core/product_version.gd`가 중앙 `Ver 4.3` owner다.
- 관제실형 3-rail UI가 구현됐다.
- Legacy / Validation route와 save isolation을 유지한다.
- keyboard focus 계약을 유지한다.
- Human/UI usability는 `NOT_RUN`이다.

Issue #181의 과거 `DEFERRED_VALID / PLAN_LOCK` 및 `CURRENT_VALID / IMPLEMENTATION_GATE`는 predecessor history다. Issue open/closed 상태만으로 구현 권한이나 current truth를 만들지 않는다.

### M04 release-near preparation

```text
SHARED_SYSTEM_BASELINE_IMPLEMENTED
PRODUCT_REFERENCE_ASSET_PENDING
HUMAN_NOT_RUN
```

M04-specific IDs를 shared Investigation/Manual/Rescue/Recovery/Composite Result grammar에 연결했다. 최종 시각·Audio/VFX 및 Human player-experience PASS는 아직 선언하지 않는다.

## Validation Router

현재 Validation 책임은 `docs/VALIDATION_TARGET_CANON.md`가 소유한다.

```text
M01_FIRST_SESSION
→ runtime 구현/자동회귀 완료
→ 실제 첫 세션 이해·입력·피로 Human QA 남음

M04_RELEASE_NEAR_VERTICAL_SLICE
→ shared-system baseline 구현 완료
→ product-reference asset 승인
→ release-near visual/audio 구현 및 Human QA 남음
```

## GitHub Issue·PR 규칙

GitHub의 `open` 상태만으로 구현 권한을 만들지 않는다.

```text
current canon / current overlay
→ 실제 main 구현·검증
→ Issue disposition
→ 과거 Issue 본문
```

- 작업 시작 때 open PR과 open Issue를 다시 조회한다.
- 진행 중 unrelated PR은 읽기 전용으로 존중한다.
- 병합·종료된 작업은 main에서 successor가 실제 존재하는지 확인한다.
- 완료·대체 Issue를 open 상태로 방치하지 않는다.
- 병합 뒤 open Issue + merge-linked Issue를 successor freshness로 재검사한다.

## Base 권위

프로젝트가 실제 채택한 Base 릴리스와 pin은:
- `docs/BASE_RULES_VERSION.md`
- `skills/PROJECT_BASE_ADAPTER.json`

이 소유한다. Base remote latest를 자동 채택하지 않는다.

현재 PR #224의 protected runtime 변경 뒤 `PROJECT_BASE_ADAPTER` protected baseline reconciliation이 남아 있다. 이 후속은 공식 Base generator로 adapter + generated views를 함께 갱신해야 하며 수동 해시 편집으로 완료 처리하지 않는다.
