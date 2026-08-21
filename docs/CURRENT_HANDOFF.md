# 괴이기록국 Current Handoff

> 상태: `PLANNING_COMPLETE / USER_FINAL_PLANNING_DECLARATION_APPROVED / IMPLEMENTATION_HANDOFF_READY`
> 정확한 main·PR·CI: 재개 시 GitHub에서 다시 조회
> 사람용 정본: Notion 괴이기록국 프로젝트 홈
> 구조화 정본: `docs/CURRENT_PLANNING_CANON.md`, `docs/current-planning-canon.json`

이 문서는 다음 GPT/Codex가 과거 annual next-step, 오래된 migration PR 상태, final-planning 대기 문구를 현재 권한으로 오인하지 않도록 하는 continuation router다.

```yaml
status: IMPLEMENTATION_HANDOFF_READY
planning: COMPLETE
user_final_planning_declaration: APPROVED
plan_lock: RELEASED_TO_IMPLEMENTATION_GATE
implementation_reality_gate: HANDOFF_READY_WITH_KNOWN_REALIGNMENT
implementation_contract: READY
runtime_implementation: NOT_AUTHORIZED
product_reference_asset: PENDING
human_qa: NOT_RUN
poc_passed: NOT_DECLARED
```

## 1. 재개 순서

```text
최신 사용자 지시
→ GitHub latest main + open PR/Issue + exact-head CI
→ Notion Project Home
→ docs/CURRENT_PLANNING_CANON.md
→ docs/current-planning-canon.json
→ docs/CURRENT_DECISION_OVERLAY.md
→ docs/audits/2026-08-22-final-planning-implementation-reality-gate.md
→ docs/superpowers/specs/2026-08-22-post-planning-runtime-reconciliation-design.md
→ docs/superpowers/plans/2026-08-22-post-planning-runtime-reconciliation-implementation-plan.md
→ 실제 current code/data/Scene/test
→ 필요한 조건부 역사 Ledger
```

현재 main의 실제 구현이 문서상 과거 상태보다 우선한다.

## 2. 최종 제품 계약

```yaml
cadence: ONE_MAIN_CASE_PER_MONTH
initial_slate: M01_TO_M12
continuous_after_m12: true
signature_cases: M01_M04_M07_M10
first_session: M01_AFTERLIFE_STATION
release_near_vertical_slice: M04_RED_UMBRELLA
core_flow: INVESTIGATION_DEDUCTION_MANUAL_RESCUE_RECOVERY_COMPOSITE_RESULT
visual_treatment: SOFT_ANIME_NOIR_LOCKED
presentation_language: DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM
planning: COMPLETE
product_reference_asset: PENDING
```

M01과 M04는 서로 대체하지 않는다.
- M01 = First Session / onboarding / regression.
- M04 = 30~45분 release-near player-experience validation.

## 3. Fresh-main Reality Gate 핵심

### REUSE_EXISTING_CANON_V2_RUNTIME

현재 main에는 Canon v2 loader, ID registry, save migrator, transaction, active migrating GameState/ValidationSession, runtime state/result policies가 이미 있다. 과거 migration plan을 다시 Task 1부터 구현하지 않는다.

### COMPOSITE_RESULT

현재 runtime에는 independent result axes successor가 존재한다. 새 결과 시스템을 만들지 않는다.

보정 필요:
- Canon v2 sidecar의 current-like `owns_first_s_rank` / `s_rank` authority를 legacy/mastery compatibility로 내린다.
- current product result는 `COMPOSITE_RESULT`가 소유한다.

### monthly_state

runtime에서 아직 확인되지 않았다. 다음 구현에서 top-level optional orchestration block으로 추가한다.

금지:
- 기존 ID rename
- legacy report만 보고 month completion 추론
- monthly state에 case truth 저장
- 같은 달 해결 뒤 두 번째 main case 생성

## 4. 현재 단일 구현 계약

Design:
`docs/superpowers/specs/2026-08-22-post-planning-runtime-reconciliation-design.md`

Implementation plan:
`docs/superpowers/plans/2026-08-22-post-planning-runtime-reconciliation-implementation-plan.md`

계획 순서:
1. `COMPOSITE_RESULT` sidecar 의미 정합화.
2. legacy grade/save compatibility 검증.
3. additive `monthly_state`.
4. `M01_FIRST_SESSION` orchestration + `SERIAL_EXAM_FATIGUE_GUARD`.
5. #181 기존 plan으로 main menu / Ver 4.3 구현.
6. M04 shared-system 준비; `PRODUCT_REFERENCE_ASSET_PENDING`에서 final visual production 중지.

## 5. #181 successor state

Planning 완료로 #181의 이전 `DEFERRED_VALID / PLAN_LOCK` 보류 사유는 끝났다.

현재 의미:

```text
CURRENT_VALID / IMPLEMENTATION_GATE
```

실제 `Ver 4.2` hardcode가 남아 있으므로 Issue는 닫지 않는다. 기존 2026-08-09 design/implementation plan을 재사용한다.

## 6. 구현 권한 경계

이 handoff가 준비됐다는 사실과 actual mutation authorization은 별개다.

현재:
```yaml
runtime_implementation: NOT_AUTHORIZED
```

따라서 이 문서/PR에서는 `data/`, `scripts/`, `scenes/`, `assets/`, `addons/`, `project.godot`, save bytes를 바꾸지 않는다.

실제 Codex/agent 실행이 승인되면 fresh-main에서 계획의 RED부터 시작한다.

## 7. Product reference / Human gate

`PRODUCT_REFERENCE_ASSET_PENDING` 유지:
- concrete M01/M04 이미지/레이어
- rights/source approval
- 1280×720 / 1920×1080 최종 가독성
- release-near M04 visual/audio/VFX polish

Human QA 유지:
- M01 첫 세션 이해도
- serial-exam fatigue 체감
- M04 재미/첫인상/차별화
- 접근성·실제 입력 체감

실행 전에는 모두 `NOT_RUN`이다.

## 8. 완료·병합 기준

```text
TDD RED
→ minimal GREEN
→ focused regression
→ full relevant regression
→ 최소 5회 whole-scope adversarial loop
→ exact-head CI
→ expected-head merge
→ new main readback
→ open PR + Issue successor freshness
→ merge-linked Issue readback
→ GitHub + Notion destination sync/readback
→ Human/runtime evidence ceiling 보존
```

현재 기획 단계의 REQUIRED_WORK_REMAINING은 0이다. 다음 남은 범위는 **runtime implementation execution**이며 이 handoff 자체는 실행 권한을 자동 부여하지 않는다.
