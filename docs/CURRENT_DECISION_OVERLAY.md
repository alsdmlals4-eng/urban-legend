# 괴이기록국 Current Decision Overlay

> 문서 역할: `CURRENT_MUTABLE_DECISION_OVERLAY`
> 상태: `CURRENT / PLANNING_COMPLETE / IMPLEMENTATION_HANDOFF_READY`
> 갱신 기준: 2026-08-22 사용자 최종 `기획완료` 선언 + fresh-main Reality Gate
> 상세 역사 결정 원장: `docs/CURRENT_CONFIRMED_DECISIONS.md`

이 파일은 **현재 작업자가 즉시 판단해야 하는 mutable decision과 verified successor state만** 소유한다. 역사 원장이 current state와 충돌하면 최신 사용자 지시 → GitHub latest main → Notion current planning → `CURRENT_PLANNING_CANON.md` / `current-planning-canon.json` → 이 Overlay 순으로 해석한다.

## 1. 현재 제품 구조

```yaml
cadence: ONE_MAIN_CASE_PER_MONTH
initial_slate: M01_TO_M12
continuous_after_m12: true
signature_cases: [M01, M04, M07, M10]
first_session: M01_AFTERLIFE_STATION
release_near_vertical_slice: M04_RED_UMBRELLA
core_flow: INVESTIGATION_DEDUCTION_MANUAL_RESCUE_RECOVERY_COMPOSITE_RESULT
visual_treatment: SOFT_ANIME_NOIR_LOCKED
presentation_language: DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM
```

- M01 저승역 = First Session / onboarding / regression.
- M04 빨간 우산 = 약 30~45분 release-near player-experience Vertical Slice.
- `ANNUAL-MVP-001/002` = 병합된 runtime/history ID와 기술 자산; current cadence owner가 아님.

## 2. 현재 Gate

```yaml
PLANNING_COMPLETE: true
USER_FINAL_PLANNING_DECLARATION_APPROVED: true
non_visual_planning: COMPLETE
visual_planning: COMPLETE
product_reference_asset: PENDING
overall_plan: COMPLETE
user_final_planning_declaration: APPROVED
plan_lock: RELEASED_TO_IMPLEMENTATION_GATE
implementation_reality_gate: HANDOFF_READY_WITH_KNOWN_REALIGNMENT
implementation_contract: READY
runtime_implementation: NOT_AUTHORIZED
canonical_root_runtime_receipt: NOT_RUN
human_qa: NOT_RUN
new_player_validation: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

`RELEASED_TO_IMPLEMENTATION_GATE`는 기획 잠금이 종료됐다는 뜻이지 runtime mutation이 자동 승인됐다는 뜻이 아니다. **runtime_implementation: NOT_AUTHORIZED**를 유지한다.

Concrete M01/M04 이미지·레이어·권리·가독성 reference는 계속 `PRODUCT_REFERENCE_ASSET_PENDING`이다.

## 3. Fresh-main verified successor state

### Canon v2 runtime

현재 main에는 Canon v2 loader/save migration/transaction/runtime wrapper가 이미 존재하고 active autoload에 연결되어 있다.

판정: `EXISTING_CANON_V2_RUNTIME_REUSE`.

- 2026-08-05 migration 계획을 처음부터 재실행하지 않는다.
- stable Episode/victim IDs와 bounded mvp-040/validation-save-v2 migration을 보존한다.
- current base `GameState.SAVE_VERSION`을 증거 없이 전역 변경하지 않는다.

### Composite result

현재 runtime에는 independent result/evaluation axes와 `CanonV2ResultAxesBridge` successor가 존재한다.

판정: `COMPOSITE_RESULT_RUNTIME_SUCCESSOR_PRESENT`.

다만 current Canon v2 sidecar의 `owns_first_s_rank` / `s_rank`는 최종 정본과 충돌한다.

판정: `LEGACY_S_RANK_CONTRACT_REALIGNMENT_REQUIRED`.

Legacy grade/S-rank는 history/mastery compatibility로만 보존하고 current product result authority가 될 수 없다.

### monthly_state

Planning Canon의 top-level optional `monthly_state`는 fresh main runtime에서 확인되지 않았다.

판정: `MONTHLY_STATE_NOT_IMPLEMENTED`.

구현은 additive optional orchestration state로 하고, legacy report에서 month completion을 추론하지 않으며 case truth를 저장하지 않는다.

### 조사·회수 UI hierarchy

PR #180 successor 구현은 current main에 존재한다. 요청형 매뉴얼, focus 복귀, pointer-through 교정, contextual cut-in 등을 재사용한다. 전체 Human/UI/device validation은 계속 `NOT_RUN`이다.

### M01 Visual/UI / Recovery closure

- `docs/M01_RECOVERY_SCENE_PACKET.md`까지 First Session packet chain이 닫혀 있다.
- `SERIAL_EXAM_FATIGUE_GUARD`를 구현 acceptance로 유지한다.
- 같은 규칙을 관측→해석→적용→실행으로 재사용하고 단계마다 별도 정답 시험을 추가하지 않는다.

## 4. 메인 메뉴 Ver 4.3 — #181

Issue #181은 실제 main의 `Ver 4.2` hardcode가 남아 있어 여전히 미완료다. 그러나 최종 기획 완료로 기존 `DEFERRED_VALID / PLAN_LOCK`의 보류 사유는 해소됐다.

현재 판정:

```text
#181 = CURRENT_VALID / IMPLEMENTATION_GATE
```

기존 owner를 재사용한다.
- `docs/superpowers/specs/2026-08-09-main-menu-control-room-versioning-design.md`
- `docs/superpowers/plans/2026-08-09-main-menu-control-room-versioning-implementation-plan.md`

새 main-menu 계획을 만들지 않는다. 실제 변경은 runtime implementation 실행 단계에서 한다.

## 5. Workspace authority

- Notion: 사람이 보는 전체 그림, Flow, 비교표, 현재 승인 방향.
- Repository: 구조화 기획 계약, 구현, 테스트, runtime evidence.
- Google Sheet: migration-only legacy inventory.
- 의미 변경은 GitHub·Notion을 같은 범위에서 동기화하고 병합 뒤 양쪽 readback한다.

## 6. Base authority

프로젝트가 채택한 Base 릴리스·payload·trusted evidence·registry hash는 `docs/BASE_RULES_VERSION.md`와 `skills/PROJECT_BASE_ADAPTER.json`이 소유한다. remote latest를 자동 채택하지 않는다.

## 7. 현재 implementation handoff

Fresh-main Reality Gate:
- `docs/audits/2026-08-22-final-planning-implementation-reality-gate.md`

Current design:
- `docs/superpowers/specs/2026-08-22-post-planning-runtime-reconciliation-design.md`

Current implementation plan:
- `docs/superpowers/plans/2026-08-22-post-planning-runtime-reconciliation-implementation-plan.md`

이 세 문서가 현재 **`IMPLEMENTATION_HANDOFF_READY`** owner다.

## 8. Issue authority

GitHub Issue open/closed 상태만으로 구현 권한이나 완료를 만들지 않는다. current canon → actual main → evidence → Issue disposition 순으로 판정한다.

현재 open Issue는 #181 하나이며 planning handoff merge 뒤 `CURRENT_VALID / IMPLEMENTATION_GATE`로 successor freshness를 동기화한다.

## 9. 검증 진입점

- M01: `M01_FIRST_SESSION` — First Session/onboarding/regression comprehension.
- M04: `M04_RELEASE_NEAR_VERTICAL_SLICE` — release-near product experience.

실행하지 않은 Runtime·Human·device 검증은 PASS로 승격하지 않는다.
