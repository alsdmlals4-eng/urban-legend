# 괴이기록국 Validation Target Canon

> 문서 역할: `CURRENT_VALIDATION_ROUTER`
> 상태: `CURRENT / RUNTIME_IMPLEMENTED / HUMAN_NOT_RUN`
> 현재 제품 기획: `docs/CURRENT_PLANNING_CANON.md` + `docs/current-planning-canon.json`
> 현재 mutable decision: `docs/CURRENT_DECISION_OVERLAY.md`
> predecessor 원문: `docs/archive/history/VALIDATION_TARGET_CANON_PRE_MONTHLY_2026-08-21.md`

이 문서는 **현재 어떤 플레이 경험을 어떤 목적으로 검증해야 하는지**를 라우팅한다. 과거 구현 전 handoff와 단일 저승역 Validation Cut을 current 실행 상태로 사용하지 않는다.

## 1. Evidence ceiling

```yaml
planning: COMPLETE
user_final_planning_declaration: APPROVED
plan_lock: RELEASED_TO_IMPLEMENTATION_GATE
runtime_implementation: MERGED_MAIN
runtime_merge_commit: 8d303f0f9414950273be934fd28c8fb1b3a21e18
canonical_root_runtime_receipt: AUTOMATED_EXACT_HEAD_GREEN
human_qa: NOT_RUN
new_player_validation: NOT_RUN
product_reference_asset: PENDING
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
base_adapter_baseline_reconciliation: COMPLETE
```

자동 테스트 성공은 사람 이해·재미·입력·접근성 증거를 대신하지 않는다. 실행하지 않은 Human 검증은 PASS로 승격하지 않는다.

## 2. 현재 Validation 책임 분리

| Route | 역할 | 핵심 질문 | 현재 상태 |
|---|---|---|---|
| `M01_FIRST_SESSION` | 첫 세션·온보딩·회귀 | 처음 보는 플레이어가 조사→추리→구출→회수의 인과와 기록국 역할을 이해하는가? | `RUNTIME_IMPLEMENTED / AUTOMATED_GREEN / HUMAN_NOT_RUN` |
| `M04_RELEASE_NEAR_VERTICAL_SLICE` | release-near 제품 경험 | 실제 사용 후보 UI/UX·아트·연출·Audio/VFX·핵심 시스템·콘텐츠가 연결됐을 때 차별점과 판매 포인트가 전달되는가? | `SHARED_SYSTEM_BASELINE_IMPLEMENTED / PRODUCT_REFERENCE_ASSET_PENDING / HUMAN_NOT_RUN` |

M01은 M04의 판매 포인트 검증을 대신하지 않고, M04는 M01의 첫 세션 학습 책임을 대신하지 않는다.

## 3. M01_FIRST_SESSION

M01 저승역은 첫 세션·온보딩·회귀 사건이다. 현재 runtime에는 additive `monthly_state`, M01 10단계 causal orchestrator, 기존 Canon v2 investigation/rescue/recovery/result 연결이 구현되어 있다.

```text
OPENING_RECORD
→ BUREAU_FIRST_TASK
→ RESTRICTED_SCHEDULE
→ M01_DISPATCHABLE
→ M01_INVESTIGATION
→ M01_DEDUCTION
→ M01_RESCUE
→ M01_RECOVERY
→ M01_COMPOSITE_RESULT
→ MONTHLY_AFTERMATH
```

고정 경계:
- 관측과 해석을 분리한다.
- 첫 추리는 공식 원본 목적지설 / 단일 가짜 목적지설 / 개인 기억 투영설 / 검은 승차권 원인설의 4후보를 보존한다.
- 검은 승차권 접촉·파괴는 구출 정답이 아니다.
- 필수 진실을 단일 RNG에 잠그지 않는다.
- 요원·성장·장비·아카는 정답이나 미관측 패턴을 대신 제공하지 않는다.
- `SERIAL_EXAM_FATIGUE_GUARD`: 조사에서 얻은 같은 규칙을 추리→구출→회수에서 적용 방식만 바꿔 재사용한다.
- orchestrator는 `correct_response_id` 같은 별도 hidden truth owner가 아니다.

Human 세션에서는 다음을 확인한다.
- 기록국 역할을 화력 처치가 아닌 규칙 조사·피해자 구출·안정화로 이해하는가.
- 사실·증언·가설·반박·미확인을 구분하는가.
- 가설 유지/배제 이유를 관측 근거로 설명하는가.
- 구출과 회수에서 앞선 조사 규칙을 다시 쓰는 인과를 이해하는가.
- 단계가 연속 시험이 아니라 하나의 규칙을 깊게 적용하는 경험으로 느껴지는가.
- 결과 화면에서 구출 결과와 회수 결과를 독립 축으로 이해하는가.

현재 판정:

```text
RUNTIME_IMPLEMENTED
AUTOMATED_REGRESSION_GREEN
HUMAN_COMPREHENSION_NOT_RUN
```

## 4. M04_RELEASE_NEAR_VERTICAL_SLICE

M04 빨간 우산은 약 30~45분 release-near player-experience Vertical Slice다.

PR #224에서 다음 shared-system baseline이 구현됐다.
- M04-specific record/investigation/minigame/recovery IDs.
- 공용 Investigation / Manual / Rescue / Recovery / Composite Result grammar.
- deterministic validation baseline.
- M01 truth ID를 M04 current truth로 재사용하지 않는 경계.
- `PRODUCT_REFERENCE_ASSET_PENDING`이면 `RELEASE_NEAR_VISUAL_READY` 승격을 차단하는 Gate.

아직 남은 제품 경험 Gate:
1. concrete product-reference asset 승인 및 rights/source 확인.
2. release-near background/character/cut-in/VFX/Audio 구현·폴리싱.
3. 1280×720 / 1920×1080 실제 가독성·입력 검증.
4. Human player-experience session.

Human 세션에서는 첫인상, 추리 고민, 지식 재사용 만족감, 괴이의 규칙 문제로서의 차별성, 다음 사건 기대, 기억에 남는 장면·판단·판매 포인트를 확인한다.

현재 판정:

```text
SHARED_SYSTEM_BASELINE_IMPLEMENTED
PRODUCT_REFERENCE_ASSET_PENDING
RELEASE_NEAR_VISUAL_READY: BLOCKED_BY_ASSET_GATE
HUMAN_PLAYER_EXPERIENCE: NOT_RUN
```

## 5. 2026-08-22 predecessor Reality Gate와 2026-08-24 successor

2026-08-22에는 다음이 정확한 finding이었다.
- `EXISTING_CANON_V2_RUNTIME_REUSE`
- `COMPOSITE_RESULT_RUNTIME_SUCCESSOR_PRESENT`
- `LEGACY_S_RANK_CONTRACT_REALIGNMENT_REQUIRED`
- `MONTHLY_STATE_NOT_IMPLEMENTED`
- #181 `CURRENT_VALID / IMPLEMENTATION_GATE`
- `runtime_implementation: NOT_AUTHORIZED`

PR #224 merge 뒤 successor는 다음과 같다.
- Canon v2 runtime reuse 유지.
- legacy S-rank authority realignment 완료.
- `monthly_state` 구현 완료.
- M01 First Session orchestration 구현 완료.
- #181 main menu / Ver 4.3 구현 및 Issue closed.
- M04 shared-system baseline 구현 완료.

따라서 2026-08-22 Design/Plan은 **실행 완료 provenance**이며 current next-step owner가 아니다.

## 6. 공통 Human QA 원칙

- 진행자가 답을 유도하지 않는다.
- 실제 행동·막힘·되돌아감·잘못된 해석과 세션 뒤 자기보고를 분리한다.
- 각 세션은 repository SHA, build/runtime 환경, 해상도, 입력 방식, save 시작 조건, M01/M04 역할, 재현 finding을 연결한다.
- 저장 손실·진행 불가·복귀 불일치가 있으면 release-near PASS로 선언하지 않는다.
- screenshot 존재를 입력·접근성 PASS로 대체하지 않는다.
- 표본이 부족하면 `NOT_RUN` 또는 `REPEAT_VALIDATION`을 유지한다.

## 7. Legacy Validation disposition

2026-08-02 저승역 단일 Validation Target과 2026-08-22 구현 전 handoff는 역사 자료다.

- 원문: `docs/archive/history/VALIDATION_TARGET_CANON_PRE_MONTHLY_2026-08-21.md`
- 현재 M01 상세 규칙: `docs/CURRENT_AFTERLIFE_STATION_CANON.md`
- 현재 M01/M04 역할: `docs/M01_M04_VERTICAL_SLICE_FLOW.md`
- current product/runtime state: `docs/CURRENT_PLANNING_CANON.md`, `docs/CURRENT_DECISION_OVERLAY.md`, 실제 latest main.

과거 Human QA Issue를 그대로 재실행했다고 간주하지 않는다. 현재 Human QA는 `NOT_RUN`이다.

## 8. 현재 실행 순서

```text
M01 current merged runtime으로 actual First Session Human QA
→ finding 교정·재검증

product-reference asset 승인
→ M04 release-near visual/audio/VFX 구현
→ exact-head 자동 + actual runtime/input 검증
→ M04 Human QA
→ finding 교정·재검증
→ POC/production gate 별도 판정
```

Base adapter reconciliation은 PR #226으로 완료됐다. 남은 Gate는 실제 Human QA와 product-reference asset/후속 release-near 구현이며, 자동화 성공을 Human PASS로 대체하지 않는다.
