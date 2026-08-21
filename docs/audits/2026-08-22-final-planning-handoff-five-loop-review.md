# 괴이기록국 · Final Planning Handoff Five-Loop Review

> 범위: 사용자 최종 `기획완료` 선언 → current authority propagation → fresh-main Reality Gate → implementation design/plan → Issue successor readiness
> 기준 completed main: `7f9e714e5aac65a826b4fd66d5219df8ed2dfb3e`
> PR: #222
> 제품/runtime 변경: `0`
> 최종 pre-CI 판정: `P0=0 / P1=0`

각 Loop는 한 관점 체크가 아니라 **전체 current state를 다시 공격**했다. finding이 나오면 수정하고 다음 Loop에서 전체 범위를 다시 읽었다.

## Loop 1 — Authority propagation / predecessor ceiling attack

### Attack

사용자 `기획완료` 선언을 `CURRENT_PLANNING_CANON` 한 곳에만 반영하면 다음 GPT/Codex가 다른 cold-start 문서의 `overall_plan: OPEN / PLAN_LOCK: ACTIVE`를 읽고 다시 기획 단계로 돌아갈 수 있는가?

### Findings

1. `AGENTS.md`가 `CURRENT_STATUS.md`를 기본 읽기에 두고 predecessor `OPEN / PLAN_LOCK`을 직접 고정하고 있었다.
2. `docs/DOCUMENTATION_MAP.md`도 `CURRENT_STATUS`를 current authority처럼 라우팅하고 old Gate를 보존하고 있었다.
3. Documentation Map 간결화 과정에서 `CORE-MVP-001 마일스톤 계약` 역사 라우팅까지 삭제돼 기존 active-reference regression이 실패했다.
4. `tests/test_current_authority_freshness.py`가 predecessor `PLAN_LOCK` literal을 current Validation 필수 계약으로 고정하고 있었다.
5. 같은 테스트가 PR #180 successor의 `병합 완료` 표현 계약을 요구했는데 Overlay 정리 과정에서 의미는 남고 literal이 빠졌다.

### Correction

- `START_HERE.md`, `AGENTS.md`, `DOCUMENTATION_MAP.md`를 current handoff 중심으로 재라우팅.
- `CURRENT_STATUS.md`는 삭제/축약하지 않고 conditional historical implementation/QA ledger로 보존.
- current authority를 `CURRENT_PLANNING_CANON → machine canon → CURRENT_DECISION_OVERLAY → CURRENT_HANDOFF → Reality Gate/Design/Plan`으로 고정.
- CORE-MVP-001 역사 마일스톤 보존 섹션 복구.
- freshness test를 `RELEASED_TO_IMPLEMENTATION_GATE + runtime_implementation_authorized: false` successor 계약으로 갱신.
- PR #180 실제 병합 successor 문구를 Overlay에 명시적으로 보존.

### Decision

`PLANNING_COMPLETE`가 모든 current consumer에 전파되면서 역사적 구현 증거는 삭제되지 않는다. **PASS**.

---

## Loop 2 — Evidence ceiling / false authorization attack

### Attack

`기획 완료`를 기록하는 과정에서 다음 중 하나가 거짓으로 승격되는가?

- product-reference asset approval
- runtime implementation authorization
- canonical-root runtime receipt
- Human/new-player QA
- POC PASS
- Production expansion

### Readback

Current machine/human Gate는 다음을 분리한다.

```yaml
planning: COMPLETE
user_final_planning_declaration: APPROVED
plan_lock: RELEASED_TO_IMPLEMENTATION_GATE
implementation_reality_gate: HANDOFF_READY_WITH_KNOWN_REALIGNMENT
implementation_contract: READY
runtime_implementation: NOT_AUTHORIZED
product_reference_asset: PENDING
canonical_root_runtime_receipt: NOT_RUN
human_qa: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

PR #222 changed-file inventory에는 `data/`, `scripts/`, `scenes/`, `assets/`, `addons/`, `project.godot`가 하나도 없다.

### Decision

Planning completion과 execution/evidence가 분리돼 있다. **PASS**.

---

## Loop 3 — Existing solution / duplicate runtime attack

### Attack

과거 문서의 `migration design / implementation plan`을 보고 이미 main에 존재하는 Canon v2 runtime을 처음부터 재구현하게 되는가?

### Fresh-main evidence

`project.godot` current main은 실제로 다음 autoload를 사용한다.

- `afterlife_migrating_validation_session.gd`
- `afterlife_migrating_game_state.gd`
- `canon_v2_runtime_bridge.gd`
- `canon_v2_result_axes_bridge.gd`

또한 main에는 Canon v2 sidecar, runtime projection, ID migration registry, save migrator, transaction, fixtures/tests가 존재한다.

판정:

```text
EXISTING_CANON_V2_RUNTIME_REUSE
COMPOSITE_RESULT_RUNTIME_SUCCESSOR_PRESENT
```

### Real current mismatch

Canon v2 sidecar `result_contract`에는 아직:
- `owns_first_s_rank: true`
- `s_rank`

가 current-like authority로 남아 있다.

따라서 필요한 것은 새 result/migration subsystem이 아니라:

```text
LEGACY_S_RANK_CONTRACT_REALIGNMENT_REQUIRED
```

이다.

### Correction

- 새 design/plan의 첫 원칙을 `REUSE_EXISTING_CANON_V2_RUNTIME`으로 고정.
- old 2026-08-05 migration plan 재실행 금지.
- existing `RecoveryOutcomePolicy` / `CanonV2ResultAxesBridge`를 `COMPOSITE_RESULT` successor로 사용.
- runtime reconciliation을 6개 reviewable Task로 축소.

### Decision

Existing Solution First와 current actual implementation이 일치한다. **PASS**.

---

## Loop 4 — Save/ID compatibility / destructive migration attack

### Attack

최종 기획에 맞춘다는 이유로 안정된 Episode/save/report ID나 전체 프로젝트 save version을 성급하게 바꾸는가?

### Fresh-main evidence

Current `afterlife_main_save_migrator.gd`는:

- target `mvp-040`
- supported source `mvp-038 / mvp-039`
- stable Afterlife Episode identity
- protected campaign/economy/inventory/reports
- `LEGACY_CASE_RESTART_REQUIRED`
- `legacy_resolution_snapshot`
- `orphan_legacy_ids`
- migration effect/history/idempotence

를 보존한다.

반면 base `scripts/core/game_state.gd`는 여전히 `SAVE_VERSION := "mvp-039"`다. 이것은 current Afterlife wrapper가 bounded migration을 제공한다는 이유만으로 전체 프로젝트 save version을 올려도 된다는 증거가 아니다.

### Correction / fixed contract

- existing Episode/victim/report/ANNUAL IDs rename 금지.
- existing ID/save migration matrix 재사용.
- base GameState 전역 save version bump 금지 unless cross-case evidence.
- `monthly_state`는 top-level optional additive block.
- legacy reports만 보고 month completion 추론 금지.
- `monthly_state`에 true hypothesis/correct response 같은 case truth 저장 금지.
- legacy grade는 `legacy_resolution_snapshot`/mastery/history로 보존하고 current composite result를 합성하지 않음.

### Decision

Migration risk is bounded and rollback-friendly. **PASS**.

---

## Loop 5 — Product roles / Issue successor / handoff duplication attack

### Attack

1. M01과 M04가 다시 하나의 Validation target으로 섞이는가?
2. product-reference image가 없는 상태를 기획 미완료로 되돌리는가?
3. #181의 기존 plan이 있는데 새 plan을 생성해 두 owner가 생기는가?
4. planning complete를 이유로 #181을 완료/close하는가?
5. handoff가 구현자에게 실제 파일/Task를 명확히 주는가?

### Readback

- M01 = `M01_FIRST_SESSION` / onboarding / regression.
- M04 = `M04_RELEASE_NEAR_VERTICAL_SLICE` / 30~45m release-near product experience.
- `PRODUCT_REFERENCE_ASSET_PENDING`은 별도 asset Gate다.
- M01 packet chain은 Investigation → Deduction → Rescue → Recovery → `COMPOSITE_RESULT`.
- `SERIAL_EXAM_FATIGUE_GUARD`가 current implementation acceptance에 포함된다.
- actual main `scripts/ui/main_menu.gd`는 `GAME_VERSION := "Ver 4.2"`를 유지하므로 #181은 실제 미완료다.
- 이미 승인된 2026-08-09 main-menu design/implementation plan이 존재한다.

### Correction / successor decision

```text
#181: DEFERRED_VALID / PLAN_LOCK
→ after planning-handoff merge
#181: CURRENT_VALID / IMPLEMENTATION_GATE
```

- Issue는 close하지 않는다.
- 기존 2026-08-09 main-menu plan을 재사용한다.
- 새 main-menu plan은 만들지 않는다.
- 새 implementation plan은 M01 first-session routing owner를 `scripts/core/m01_first_session_orchestrator.gd`로 명시해 실행 시점 placeholder를 제거했다.
- M04는 shared code/data/state 준비와 final asset/release-near production을 Tier로 분리한다.

### Decision

Product role, Issue lifecycle and handoff ownership are unambiguous. **PASS**.

---

# Final adversarial decision

## Fixed during review

- stale `AGENTS.md` planning Gate/default STATUS routing
- stale `DOCUMENTATION_MAP.md` planning Gate/default STATUS routing
- accidental CORE-MVP-001 historical routing deletion
- predecessor `PLAN_LOCK` regression expectation
- PR #180 successor merge literal propagation
- ambiguous execution-time M01 routing file ownership

## Preserved intentionally

- all product/runtime files unchanged
- current Canon v2 implementation and save transaction system
- historical `CURRENT_STATUS.md` implementation/QA lineage
- stable Episode/victim/report/ANNUAL IDs
- legacy grade/history compatibility
- M01/M04 distinct Validation responsibilities
- product-reference asset separate Gate
- Human/runtime evidence ceilings
- #181 open until actual implementation completes

## Final state before exact-head CI

```yaml
P0: 0
P1: 0
planning: COMPLETE
implementation_handoff: READY
runtime_implementation: NOT_AUTHORIZED
product_reference_asset: PENDING
human_qa: NOT_RUN
```

Exact final-head CI must still pass after this receipt is committed. A CI failure reopens the relevant finding; this document does not pre-authorize a merge.
