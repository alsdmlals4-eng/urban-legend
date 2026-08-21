# Post-Planning Runtime Reconciliation Design

> 상태: `APPROVED_PLANNING_HANDOFF / DESIGN_READY / RUNTIME_IMPLEMENTATION_NOT_AUTHORIZED`
> 사용자 제품 Gate: `기획완료` · 2026-08-22 KST
> Fresh-main 기준: `7f9e714e5aac65a826b4fd66d5219df8ed2dfb3e`
> Reality Gate: `docs/audits/2026-08-22-final-planning-implementation-reality-gate.md`

## 1. Goal

최종 기획을 실제 main에 연결하되 이미 검증된 저승역 Canon v2 runtime/save migration을 버리지 않는다.

핵심 전략은 **`REUSE_EXISTING_CANON_V2_RUNTIME`**이다.

```text
기존 Canon v2 loader/save/migration/runtime state 재사용
→ current COMPOSITE_RESULT와 충돌하는 legacy grade authority 제거
→ additive monthly_state 추가
→ M01_FIRST_SESSION을 existing runtime 위에 orchestration
→ #181 기존 main-menu 계획 재사용
→ M04_RELEASE_NEAR_VERTICAL_SLICE는 공용 시스템 준비 후 asset Gate
```

이 설계는 구현 방향 정본이며 이 문서 자체는 `data/`, `scripts/`, `scenes/`, save, product asset mutation을 승인하지 않는다.

## 2. Non-negotiable current product contract

- cadence: `ONE_MAIN_CASE_PER_MONTH`.
- First Session: `M01_FIRST_SESSION / M01_AFTERLIFE_STATION`.
- release-near player-experience Vertical Slice: `M04_RELEASE_NEAR_VERTICAL_SLICE / M04_RED_UMBRELLA`.
- core flow: `INVESTIGATION → DEDUCTION → ANOMALY_MANUAL → VICTIM_RESCUE → RECOVERY → COMPOSITE_RESULT`.
- result authority: `COMPOSITE_RESULT`; 단일 S/A/B/S-rank가 피해자·통제·증거·보호·후속 축을 덮어쓰지 않는다.
- `SERIAL_EXAM_FATIGUE_GUARD`: 같은 규칙을 관측→해석→적용→실행으로 재사용한다.
- existing Episode/save/report/ANNUAL IDs를 current naming 때문에 rename하지 않는다.
- 필수 진실·정답은 성장/동료/장비/자동행동이 제공하지 않는다.
- `PRODUCT_REFERENCE_ASSET_PENDING`은 planning 완료와 독립된 production asset Gate다.
- Human QA는 실제 실행 전 `NOT_RUN`.

## 3. Existing implementation inventory — reuse, do not rebuild

### 3.1 Canon v2 content and loader

Reuse:
- `data/episodes/episode_001_afterlife_station_canon_v2.json`
- `data/episodes/episode_001_afterlife_station_canon_v2_runtime_projection.json`
- `scripts/data/afterlife_canon_v2_loader.gd`
- `scripts/data/episode_loader.gd`

Preserve:
- explicit contract activation
- computed layer provenance/checksum
- legacy core validation as history/provenance only
- canonical record/pattern/response projection generated from Canon v2 IDs

### 3.2 ID and save migration

Reuse:
- `data/migrations/afterlife_station_canon_v2_id_migration.json`
- `docs/planning/2026-08-05-afterlife-station-id-migration-matrix.md`
- `scripts/core/afterlife_legacy_save_inspector.gd`
- `scripts/core/afterlife_main_save_migrator.gd`
- `scripts/core/afterlife_validation_save_migrator.gd`
- `scripts/core/afterlife_migration_transaction.gd`

Preserve:
- stable `episode_001_afterlife_station`
- stable `victim_afterlife_station_001`
- `mvp-038/039 → mvp-040` bounded migration
- `validation-save-v1 → validation-save-v2`
- `migrated_unverified`
- `orphan_legacy_ids`
- `effect_id` idempotence
- backup/checksum/rollback
- `LEGACY_CASE_RESTART_REQUIRED`
- completed legacy result snapshot/history

Do not globally replace base `GameState.SAVE_VERSION` merely because the Afterlife wrapper supports `mvp-040`.

### 3.3 Current runtime result successor

Reuse:
- `scripts/core/recovery_outcome_policy.gd`
- `scripts/core/afterlife_migrating_game_state.gd`
- `scripts/ui/canon_v2_result_axes_bridge.gd`

These already support independent result/evaluation axes and are the correct base for current **`COMPOSITE_RESULT`**.

## 4. Reconciliation Unit A — Composite Result authority

### Problem

`episode_001_afterlife_station_canon_v2.json` still declares current-like `owns_first_s_rank` / `s_rank`, while final planning says single rank cannot own the product result.

### Target

Canon v2 result contract becomes explicitly axis-first:

```json
{
  "result_contract": {
    "authority": "composite_result",
    "axes": [
      "victim_outcome",
      "control_or_stabilization",
      "evidence_integrity",
      "protection_responsibility",
      "residual_anomaly",
      "unresolved_and_follow_up"
    ],
    "legacy_mastery": {
      "grade_history_preserved": true,
      "may_overwrite_composite_result": false
    }
  }
}
```

Exact serialized field names may follow existing runtime naming where doing so avoids another adapter layer, but the semantics above are fixed.

### Compatibility boundary

- old `selected_resolution_grade`, `s_rank_awarded`, prior grade reports may remain as **legacy/mastery/history metadata**.
- no code path may use them as the sole current incident outcome.
- old save bytes are not rewritten merely to delete historical grade data.
- reward duplication remains forbidden.

## 5. Reconciliation Unit B — monthly_state

### Responsibility

`monthly_state` owns monthly orchestration, not case truth.

Recommended bounded schema:

```yaml
monthly_state:
  schema_version: 1
  month_index: integer >= 1
  week_index: 1..4
  active_main_case_id: string | ""
  main_case_status: DORMANT | DISPATCHABLE | ACTIVE | RESOLVED | AFTERMATH
  dispatch_risk: 0 | 15 | 30
  resolved_this_month: bool
  aftermath_available: bool
  last_month_result_ref: string | ""
```

### Invariants

1. block is top-level and optional.
2. old saves without the block load successfully with a deterministic default.
3. migration does **not** infer `resolved_this_month=true` from old reports alone.
4. no existing Episode/report/ANNUAL ID rename.
5. `monthly_state` never stores true hypothesis/answer IDs.
6. if `resolved_this_month=true`, a second main case cannot spawn in the same month.
7. 2주차/3주차/4주차 dispatch risk is currently `0/15/30`; values remain provisional until Human QA.
8. early resolution routes remaining weeks to aftermath/research/relationship/preparation.

### Architecture

Prefer a focused policy/state class rather than expanding base `game_state.gd`.

Recommended owner:
- create `scripts/core/monthly_state_policy.gd` for pure validation/default/transition logic.
- integrate through active `afterlife_migrating_game_state.gd` and the existing schedule/orchestration boundary.

Base `game_state.gd` should receive only the minimum serialization/integration hook if unavoidable.

## 6. Reconciliation Unit C — M01 First Session orchestration

M01 must use the existing Canon v2 runtime rather than a parallel tutorial runtime.

Required end-to-end sequence:

```text
Opening Record
→ first bureau task
→ restricted first weekly schedule
→ M01 becomes DISPATCHABLE
→ Investigation
→ Deduction / Manual
→ Victim Rescue
→ Recovery
→ COMPOSITE_RESULT
→ remaining-week aftermath
```

### Progressive disclosure

First session exposes only the minimum necessary systems.

- schedule: 관측 훈련 / 기록 분석 / 휴식 중심.
- deduction: 4 competing hypotheses, first two eliminated, H3/H4 compared.
- manual: first meaning slots progressively unlock rather than five simultaneous answer fields.
- recovery: one telegraph relationship taught, later patterns reuse the same visual/decision grammar.

### SERIAL_EXAM_FATIGUE_GUARD

Acceptance rules:
- new phase cannot introduce an unrelated hidden answer required for progress.
- rescue uses rules already earned in investigation/deduction.
- recovery uses records/rules already learned, changing the **application form**, not the truth.
- failure feedback distinguishes observation/interpretation/application/timing errors.

## 7. Reconciliation Unit D — #181 main menu / Ver 4.3

After final planning approval, #181 is `CURRENT_VALID / IMPLEMENTATION_GATE`.

Reuse, do not duplicate:
- `docs/superpowers/specs/2026-08-09-main-menu-control-room-versioning-design.md`
- `docs/superpowers/plans/2026-08-09-main-menu-control-room-versioning-implementation-plan.md`

Required result:
- central product-version owner starts at `Ver 4.3`.
- remove direct `GAME_VERSION := "Ver 4.2"` ownership from main menu.
- preserve Legacy / Validation entry separation and save isolation.
- preserve keyboard focus/accessibility contracts.
- right-side intelligence modules may show only canonical runtime-derived data.

This implementation remains a separate task boundary because reviewers can approve/reject it independently from monthly orchestration.

## 8. Reconciliation Unit E — M04 release-near preparation

Shared systems can be prepared from the final planning contract:
- common Investigation / Manual / Rescue / Recovery / Composite Result grammar
- M04 validation baseline save/state
- red-umbrella case-specific rule data and deterministic test fixtures
- 1280×720 / 1920×1080 screen contracts

But final player-experience implementation is two-tiered.

### Tier 1 — allowed after runtime implementation authorization

- code/data/state plumbing
- shared screen grammar
- validation baseline
- automated regression

### Tier 2 — blocked by PRODUCT_REFERENCE_ASSET_PENDING

- final or release-near M04 background/character/cut-in/VFX production reference promotion
- rights/source approval
- final visual readability evidence
- Audio/VFX polish that is part of the release-near experience claim
- Human player-experience PASS

No automation can promote Tier 2.

## 9. Error and failure handling

### Save/migration

- unknown legacy state → fail closed or preserve as orphan/history; never guess current truth.
- migration source changed after inspect → checksum mismatch, no primary overwrite.
- runtime apply failure → rollback file + memory.

### monthly_state

- invalid week/month/status → validation failure; do not coerce into a resolved state.
- missing block → deterministic default, not migration failure.
- legacy completed report without monthly evidence → does not imply current month resolved.

### result contract

- missing structured result packet → display “not recorded/unknown”; do not infer S/A/B equivalent.
- legacy mastery metadata may be shown only in secondary/historical surfaces.

## 10. Testing strategy

### Contract tests

- current sidecar has no current `owns_first_s_rank` authority.
- legacy grade remains preserved in migration fixtures/history.
- result axes remain independent.
- `monthly_state` old-save default and idempotent serialization.
- no second main case after resolved state.
- no case truth inside `monthly_state`.

### Runtime focused tests

- Canon v2 loader/migration focused suite.
- M01 first-session orchestration.
- recovery result axes.
- main-menu route/version preservation.

### Full regression

- full Godot regression.
- Windows/Ubuntu Python contract matrix.
- existing Validation Package / ANNUAL / save isolation suites.

### Evidence ceiling

Automation may prove structural/runtime contracts. It may not prove:
- first-session comprehension
- serial-exam fatigue reduction
- M04 selling-point strength
- final visual readability
- accessibility usability
- fun/immersion.

Those remain Human QA.

## 11. Implementation order

1. current result-contract semantic RED → realignment.
2. save/migration compatibility regression around the realignment.
3. additive `monthly_state`.
4. M01 First Session orchestration.
5. #181 main menu / Ver 4.3 using the existing plan.
6. M04 shared-system preparation; stop at product-reference asset Gate.
7. exact-head automation + runtime evidence.
8. M01 Human QA.
9. product reference approval and M04 release-near implementation/Human QA.

## 12. Completion definition for the next implementation phase

The next runtime implementation phase is complete only when:

- current product result authority is COMPOSITE_RESULT end-to-end.
- legacy grades survive only as compatibility/history/mastery metadata.
- monthly_state is additive, validated, and save-compatible.
- M01 First Session uses the existing Canon v2 runtime without duplicate truth systems.
- #181 is implemented without breaking Legacy/Validation routes.
- all exact-head automated regressions pass.
- runtime evidence is recorded separately from Human evidence.
- M04 visual product-reference work is not overclaimed while `PRODUCT_REFERENCE_ASSET_PENDING` remains.

Human QA and production expansion remain separate gates after this implementation phase.
