# 괴이기록국 Validation Target Canon

> 문서 역할: `CURRENT_VALIDATION_ROUTER`
> 상태: `CURRENT / PLANNING_COMPLETE / IMPLEMENTATION_GATE / HUMAN_NOT_RUN`
> 현재 제품 기획: `docs/CURRENT_PLANNING_CANON.md` + `docs/current-planning-canon.json`
> 현재 mutable decision: `docs/CURRENT_DECISION_OVERLAY.md`
> predecessor 원문: `docs/archive/history/VALIDATION_TARGET_CANON_PRE_MONTHLY_2026-08-21.md`

이 문서는 **현재 어떤 플레이 경험을 어떤 목적으로 검증해야 하는지**를 라우팅한다. 과거 단일 저승역 Validation Cut을 현재 제품 전체 Vertical Slice로 사용하지 않는다.

## 1. Evidence ceiling

```yaml
planning: COMPLETE
user_final_planning_declaration: APPROVED
plan_lock: RELEASED_TO_IMPLEMENTATION_GATE
implementation_reality_gate: HANDOFF_READY_WITH_KNOWN_REALIGNMENT
runtime_implementation_authorized: false
canonical_root_runtime_receipt: NOT_RUN
human_qa: NOT_RUN
new_player_validation: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

기획 완료는 Human/runtime 증거가 생겼다는 뜻이 아니다. 문서·자동 테스트·과거 runtime 증거가 있어도 **현재 월간 제품 기준 Human QA를 대신하지 않는다.** 실행하지 않은 Runtime·Human·device 검증은 PASS로 승격하지 않는다.

## 2. 현재 Validation 책임 분리

| Route | 역할 | 핵심 질문 | 현재 상태 |
|---|---|---|---|
| `M01_FIRST_SESSION` | 첫 세션·온보딩·회귀 | 처음 보는 플레이어가 조사→추리→구출→회수의 인과와 기록국 역할을 이해하는가? | `IMPLEMENTATION_HANDOFF_READY / HUMAN_NOT_RUN` |
| `M04_RELEASE_NEAR_VERTICAL_SLICE` | release-near 제품 경험 | 실제 사용 후보 UI/UX·아트·연출·Audio/VFX·핵심 시스템·콘텐츠가 연결됐을 때 이 게임을 사고 싶게 만드는 경험과 차별점이 전달되는가? | `SYSTEM_PREP_READY / PRODUCT_REFERENCE_ASSET_PENDING / HUMAN_NOT_RUN` |

M01은 M04의 제품 완성도·판매 포인트 검증을 대신하지 않는다. M04는 M01의 첫 세션 학습 책임을 대신하지 않는다.

## 3. M01_FIRST_SESSION

### 목적

M01 저승역은 첫 세션·온보딩·회귀 사건이다.

플레이어가 설명서를 외우는 것이 아니라 다음 인과를 **플레이로 이해**해야 한다.

```text
관측 가능한 기록
→ 경쟁 가설
→ 지지·반박·미해결 분리
→ 피해자 구출 절차
→ 전조 기반 안정화·회수
→ 성공·실패·미확정이 기록과 매뉴얼로 남음
```

### 고정 콘텐츠 책임

- 사건: M01 저승역.
- 상세 규칙: `docs/CURRENT_AFTERLIFE_STATION_CANON.md`.
- 조사 패킷: `docs/M01_INVESTIGATION_SCENE_PACKET.md`.
- 추리 패킷: `docs/M01_DEDUCTION_SCENE_PACKET.md`.
- 구출 패킷: `docs/M01_RESCUE_SCENE_PACKET.md`.
- 회수 패킷: `docs/M01_RECOVERY_SCENE_PACKET.md`.

첫 추리는 다음 4후보를 보존한다.

1. 공식 원본 목적지설
2. 단일 가짜 목적지설
3. 개인 기억 투영설
4. 검은 승차권 원인설

필수 경계:

- 관측과 해석을 분리한다.
- 검은 승차권이 없는 동시 청취자 기록을 포함한 독립 근거로 오답을 약화할 수 있어야 한다.
- 검은 승차권 접촉·파괴는 피해자 구출의 정답이 아니다.
- 피해자는 현실 교통 기록과 공식 승차권을 대조하고 지정 역에서 동반 하차하는 절차로 구출한다.
- 단일 RNG 성공이 필수 진실을 잠그지 않는다.
- 요원·성장·장비·아카는 정답 가설이나 미관측 패턴을 대신 제공하지 않는다.
- `SERIAL_EXAM_FATIGUE_GUARD`: 구출·회수는 조사/추리와 무관한 새 정답 시험이 아니라 이미 확보한 규칙의 적용/실행이어야 한다.

### 플레이어 경험 검증 질문

Human 세션에서는 최소한 다음을 행동과 설명으로 분리해 관찰한다.

- 기록국 요원의 역할을 “괴이를 죽이는 사람”이 아니라 규칙을 조사·검증하고 피해자를 구출·안정화하는 사람으로 이해하는가?
- 사실·증언·가설·반박·미확인을 구분하는가?
- 왜 가설을 제거하거나 유지했는지 관측 근거로 설명하는가?
- 구출 절차가 가설 확인과 어떻게 연결되는지 설명하는가?
- 회수 전조에 어떤 조사 기록을 적용해야 하는지 이해하는가?
- 단계가 연속된 독립 시험처럼 피로하게 느껴지는가, 하나의 규칙을 점점 더 깊게 사용하는 것으로 느껴지는가?
- 실패가 단순 초기화가 아니라 위험 사례·후속 조사·매뉴얼로 남는다는 것을 이해하는가?
- 결과 화면에서 구출 결과와 회수 결과를 별도 축으로 이해하는가?

### 구현 Reality Gate — 완료된 판단

2026-08-22 fresh-main Reality Gate에서 다음을 확인했다.

- `EXISTING_CANON_V2_RUNTIME_REUSE`: loader/save migrator/transaction/active runtime wrapper가 이미 current main에 존재.
- 기존 ID/save migration matrix를 새로 만들지 않고 재사용.
- `COMPOSITE_RESULT_RUNTIME_SUCCESSOR_PRESENT`.
- `LEGACY_S_RANK_CONTRACT_REALIGNMENT_REQUIRED`.
- `MONTHLY_STATE_NOT_IMPLEMENTED`.

현재 implementation owner:
- `docs/superpowers/specs/2026-08-22-post-planning-runtime-reconciliation-design.md`
- `docs/superpowers/plans/2026-08-22-post-planning-runtime-reconciliation-implementation-plan.md`

즉 M01은 기획을 다시 여는 상태가 아니라 **기존 runtime 재사용 + 의미 정합화 + First Session orchestration 구현 대기**다.

## 4. M04_RELEASE_NEAR_VERTICAL_SLICE

### 목적

M04 빨간 우산은 약 30~45분 **release-near player-experience Vertical Slice**다.

이 Route는 “기능이 존재한다”를 확인하는 테스트가 아니라 다음 질문을 검증한다.

> 실제 Steam 데모 후보에 가까운 화면·소리·연출·콘텐츠를 연결했을 때, 플레이어가 괴이기록국의 핵심 재미와 차별점을 느끼고 계속 플레이하고 싶어 하는가?

### 필수 포함 범위

- 실제 사용 후보 UI/UX.
- 승인된 product-reference 기반 아트 또는 명시적으로 placeholder 처리된 개발 자산.
- 핵심 Audio/VFX·피드백 방향.
- 조사 → Deduction/괴이 매뉴얼 → Victim Rescue → Recovery → Composite Result 전체 인과.
- 요원·관계·준비 요소가 핵심 정답을 대신하지 않고 선택 이유를 만드는지 확인.
- 기록·매뉴얼·실패 전진이 다음 판단으로 환류하는지 확인.
- 1280×720 / 1920×1080에서 PC 16:9 정보 위계와 한국어 가독성.

### 제품 경험 검증 질문

- 첫 몇 분 안에 “무슨 게임인지” 설명 없이 이해되는가?
- 조사에서 무엇을 보고 왜 선택하는지 명확한가?
- 추리가 체크리스트가 아니라 실제 고민과 가설 경쟁으로 느껴지는가?
- 구출과 회수에서 앞선 조사 지식을 다시 쓰는 만족감이 있는가?
- 괴이가 일반 HP 적이 아니라 규칙을 이해해야 하는 현상으로 느껴지는가?
- 선택·실패·관계·연구가 다음 사건을 기대하게 만드는가?
- 비주얼·Audio·연출이 오컬트 조사 분위기와 정보 가독성을 동시에 지키는가?
- 데모 종료 시 기억에 남는 장면·판단·판매 포인트가 무엇인지 플레이어가 자기 말로 설명하는가?

### 구현·Human Gate

기획은 완료됐다. 남은 Gate는 구현·asset·증거다.

1. fresh-main Reality Gate — 완료.
2. 단일 implementation contract — `READY`.
3. runtime implementation 실행 권한 — `NOT_AUTHORIZED`.
4. 공용 code/data/state plumbing 및 M04 validation baseline 구현.
5. concrete product-reference asset — `PENDING`.
6. product-reference 승인 뒤 release-near visual/audio/VFX 구현.
7. exact-head 자동 회귀 + actual runtime capture/input 검증.
8. 사전등록 Human session.

`PRODUCT_REFERENCE_ASSET_PENDING` 상태에서 code/data shared system은 준비할 수 있지만 release-near visual experience PASS를 선언하지 않는다.

## 5. M02와 기타 사건의 역할

현재 primary Validation Route는 M01과 M04다.

M02 등 Standard 사건은 월간 공용 화면 문법·save/결과 orchestration·사건별 차별화의 **회귀·연속성 보조 샘플**로 사용할 수 있다. 그러나 이 Router는 M02의 개별 콘텐츠 Spec을 새로 확정하지 않는다.

## 6. 공통 Human QA 원칙

### 행동과 자기보고 분리

- 진행자가 답을 유도하지 않는다.
- 먼저 실제 행동·막힘·되돌아감·잘못된 해석을 기록한다.
- 세션 뒤 자기보고·만족도·기억에 남은 요소를 별도 기록한다.

### Evidence identity

각 유효 세션은 최소한 다음을 연결한다.

- repository commit SHA
- build/runtime 환경
- 해상도와 입력 방식
- save 시작 조건
- 세션 역할(M01 또는 M04)
- 재현 가능한 finding

### Fail-closed

- 저장 손실·진행 불가·복귀 불일치가 있으면 release-near 통과로 선언하지 않는다.
- 자동 테스트 성공을 사람 이해 증거로 대체하지 않는다.
- screenshot 존재를 입력·접근성 PASS로 대체하지 않는다.
- 표본이 부족하면 `NOT_RUN` 또는 `REPEAT_VALIDATION`을 유지한다.

## 7. Legacy Validation disposition

2026-08-02의 저승역 단일 35~50분 Validation Target은 중요한 역사지만 current execution authority가 아니다.

- 원문 보존: `docs/archive/history/VALIDATION_TARGET_CANON_PRE_MONTHLY_2026-08-21.md`
- 현재 M01 상세 규칙: `docs/CURRENT_AFTERLIFE_STATION_CANON.md`
- 현재 M01/M04 역할: `docs/M01_M04_VERTICAL_SLICE_FLOW.md`
- current plan/gate: `docs/CURRENT_PLANNING_CANON.md`

과거 Issue #92·#105 같은 predecessor Human QA 작업을 current Route로 그대로 재실행하지 않는다. 해당 Issue가 닫혀도 **Human QA 자체는 완료되지 않았고 현재 상태는 `NOT_RUN`**이다.

## 8. 현재 실행 순서

```text
current implementation handoff readback
→ runtime implementation 명시 실행 권한
→ COMPOSITE_RESULT semantic realignment
→ legacy save/grade compatibility 검증
→ additive monthly_state
→ M01 First Session orchestration
→ M01 current runtime evidence + Human QA
→ M04 shared-system/baseline 준비
→ product-reference asset 승인
→ M04 release-near Vertical Slice 구현
→ exact-head 자동/actual runtime 검증
→ M04 Human QA
→ finding 교정·재검증
→ POC/production gate 별도 판정
```

현재는 planning lock이 아니라 **runtime implementation authorization**이 mutation 경계다.
