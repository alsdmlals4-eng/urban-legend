# D-2026-08-28 · M04 Sequential Narrative Result Vignettes

> Status: `USER_APPROVED / PLANNING_CANON / IMPLEMENTATION_NOT_AUTHORIZED`
> Decision ID: `D-2026-08-28-M04-SEQUENTIAL-NARRATIVE-RESULT-VIGNETTES`
> Issue: #333
> Scope: `M04_RED_UMBRELLA` Composite Result presentation only
> Owner: `CURRENT_PLANNING_CANON.md`, `current-planning-canon.json`, `CURRENT_DECISION_OVERLAY.md`, `CURRENT_HANDOFF.md`, `M01_M04_VERTICAL_SLICE_FLOW.md`, Notion `괴이기록국 · Home` and `01 · Direction · Planning`
> Timing successor: `D-2026-08-28-TEN-DAY-HALF-DAY-CASE-CADENCE`

## Decision

M04의 복합 결과는 한 화면에서 점수·카드·목록으로 모두 나열하지 않는다. 플레이어는 사건이 끝난 뒤 **하나의 결과 원인당 하나의 짧은 이야기 페이지**를 순서대로 읽는다. 여기서 페이지는 별도의 Godot Scene 확정을 뜻하지 않는 논리적 결과 단계다.

```text
피해자
→ 잔향
→ 귀가 기억
→ 기록국
```

각 페이지는 제목, 현재 사건에서 사실로 확인된 한 가지 결과, 1~3문장의 짧은 후일담, 다음 페이지로 가는 명시적 입력만 가진다. 복수 등급·보상·수치를 같은 대시보드에 압축하지 않는다.

## Page contract

| order / id | one causal result | story payload | must not do |
| --- | --- | --- | --- |
| 1 `VIGNETTE_VICTIM_RESCUE` | 피해자 구출 결과 | 기존 `victim_rescue_result`와 `after_story`가 말하는 사람의 현재 상태 | 회수 등급이나 출동 시점을 이 결과로 환산하지 않음 |
| 2 `VIGNETTE_RESONANCE_RECOVERY` | 잔향 회수 결과 | 기존 회수 설명·상태가 말하는 현상의 현재 상태 | 피해자 구출 결과를 덮어쓰지 않음 |
| 3 `VIGNETTE_ROUTE_MEMORY` | 출동 타이밍과 실제 지원 사용 | 조기(Day 1~9) / 정규(Day 10), 실제 해결일, 권나래 지원 사용 여부와 실제 runtime 효과의 인과 | Day 10을 벌점·강제 출동으로 서술하거나 지원 미사용을 숨은 실패로 취급하지 않음. 옛 `0/15/30`, `0/+4/+8`은 표시하지 않음 |
| 4 `VIGNETTE_CASE_RECORD` | 기록·연구·다음 행동 | 기존 기록물·연구 보상·다음 조사 연결을 짧은 기록국 후일담으로 제시 | 새 보상·단서·정답·관계 상태를 발명하지 않음 |

`VIGNETTE_ROUTE_MEMORY`는 하나의 준비-결과 인과이므로, 타이밍과 그 타이밍에서 플레이어가 실제로 사용한 권나래 지원을 한 이야기 안에 연결한다. 지원을 쓰지 않았으면 해당 사실만 중립적으로 기록하며 빈 페이지나 자동 패널을 만들지 않는다.

## Player contract

- 결과는 **사람 → 현상 → 선택의 여파 → 기록** 순서로 읽혀야 한다.
- 한 페이지를 읽은 뒤 다음으로 가는 단일 명시적 입력을 제공한다. 진행 표시는 `1 / 4`처럼 현재 위치만 알려 주며, 점수판이나 결과 비교표가 아니다.
- 빠른 읽기를 위해 제목·핵심 사실·짧은 서술의 위계를 유지한다. 수치가 필요한 경우에도 해당 원인의 기록으로만 작게 보이고 다른 축과 경쟁하지 않는다.
- 기존 Composite Result 원칙을 유지한다. 구출·회수·추리·기록·출동 타이밍은 여전히 독립 결과이며, 이 결정은 그것들을 한 점수로 합치지 않는다.
- M01의 첫 세션 결과 흐름과 기존 사건의 결과 표현은 변경하지 않는다.

## Rationale and alternatives

| option | disposition | player / production consequence |
| --- | --- | --- |
| M04 결과 축을 짧은 순차 후일담 페이지로 전개 | `ADOPT` | 선택의 인과를 기억 가능한 사건 결말로 남기며 복합 결과의 의미를 유지한다. |
| 한 화면의 독립 카드·표로 모든 결과를 병렬 표시 | `REJECT` | 정보는 빠르지만 선택의 여파가 점수판처럼 읽히며 사용자 승인과 충돌한다. |
| 출동 타이밍을 구출·회수 등급에 합산 | `REJECT` | 4주차 정규 출동을 사실상 지연 벌점으로 되돌리고 기존 결과 의미를 오염한다. |
| 수치만 보이는 출동 텔레메트리 | `REJECT` | 플레이어가 선택의 사람·현상적 결과를 이해하거나 기억하기 어렵다. |

## Actual evidence and implementation boundary

- 현재 `scripts/scenes/result_scene.gd`는 하나의 `ScrollContainer` 안에서 결과·판단 근거·사건 보고서·저장·보상·다음 연결을 구성한다. 이 결정은 그 구조가 새 M04 결과 경험에 맞지 않는다는 planning finding이다.
- `monthly_state.dispatch_risk`는 현재 2/3/4주 `0/15/30` 문법만 보유하고 M04의 live consumer가 없다. 이는 historical generic policy이며 새 10일 timing을 대신하지 않는다.
- 후속 통합 구현 계약은 M04 한정 logical-page state, skip/continue input, save round-trip, Korean copy, 1280×720·1920×1080 가독성, mouse/keyboard, M01 회귀, Human/new-player QA를 함께 명시해야 한다.
- 이번 결정은 code/data/Scene/UI, save schema, asset, exact runtime copy, balance, runtime/Human QA PASS를 승인하지 않는다.

## Project Incident / Solution / Lesson

- **Incident:** 기존 결과 화면은 독립 결과를 한 scroll surface에 묶어, M04의 출동 타이밍·지원 사용·사람과 현상의 다른 여파를 점수표처럼 읽게 만들 수 있었다.
- **Solution:** M04에만 인과 순서의 narrative vignette contract를 두고, 각 결과를 한 페이지씩 짧은 이야기로 제시한다.
- **Lesson:** 복합 결과는 축을 더 많이 표시하는 것으로 이해되지 않는다. 플레이어가 각 원인과 여파를 순서대로 연결할 수 있어야 한다. 이 교훈은 M04의 결과 UX와 사건 의미에 묶여 있으므로 `NO_BASE_PROMOTION`이다.
