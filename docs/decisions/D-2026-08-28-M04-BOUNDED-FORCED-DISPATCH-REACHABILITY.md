# D-2026-08-28 · M04 Bounded Forced-Dispatch Reachability

> Status: `SUPERSEDED_BY_D-2026-08-28-M04-EARLY-DISPATCH-REGULAR-WEEK4-CADENCE / HISTORICAL_DECISION`
> Decision ID: `D-2026-08-28-M04-BOUNDED-FORCED-DISPATCH-REACHABILITY`
> Issue: #329
> Scope: `M04_RED_UMBRELLA`의 출동 전 M04 전용 timing flow만
> Owner: `CURRENT_PLANNING_CANON.md`, `current-planning-canon.json`, `CURRENT_DECISION_OVERLAY.md`, `M01_M04_VERTICAL_SLICE_FLOW.md`, Notion `01 · Direction · Planning`
> Depends on: `D-2026-08-28-M04-ONE-DELAY-PREPARATION-VICTIM-RISK-TRADEOFF`, `D-2026-08-28-M04-ROUTE-MEMORY-ANCHOR-PREPARATION-BENEFIT`

## Decision

M04의 승인된 출동 타이밍은 범용 연간 달력이 아니라 **M04 전용의 짧고 닫힌 2→3→4주 dispatch docket**으로 실제 도달 가능하게 한다.

```text
2주차 · 조기 출동
  → 지금 출동: 피해자 위험 +0, 준비 modifier 없음, M04 시작
  → 한 번 준비: +15 위험과 “귀가 기억 고정 강화”를 먼저 읽고 3주차로 이동

3주차 · 지연 출동
  → 출동: 피해자 위험 +15, 권나래의 기존 능동형 귀가 기억 고정은 공포 -24, M04 시작
  → 출동 보류: 추가 준비 이득 없이 즉시 4주차 강제 출동으로 escalation

4주차 · 강제 출동
  → 피해자 위험 +30을 가시적으로 고지
  → 준비 modifier 없음
  → 확인 후 M04를 반드시 시작
```

3주차의 `출동 보류`는 두 번째 준비 선택이나 보상 획득이 아니다. 이미 한 번 받은 준비 이득을 추가·갱신하지 않고, 승인된 4주차 escalation을 실제 플레이 결과로 만든다.

## Player contract

- 플레이어는 M04 시작 전에 지금 보호할지, 한 번 준비해 피해자 위험을 감수할지를 읽고 결정한다.
- 한 번 준비한 뒤에는 강화 효과를 이용해 출동하거나, 더 기다린 결과로 강화 없이 강제 출동하게 된다.
- 4주차는 숨은 패널티나 테스트 전용 상태가 아니다. 원인(`출동 보류`)·위험 `+30`·준비 이득 상실을 읽은 뒤 확인하는 가시적 escalation이다.
- 이 흐름은 M01, 다른 사건, 범용 주간 일정 UI, 추가 main case 생성으로 확장하지 않는다.
- 피해자 위험 `+15`/`+30`이 향후 runtime에서 어떤 피해 상태·수치·보고서 문장으로 소비되는지는 이 결정이 정하지 않는다. 그 consumer mapping은 하나의 후속 통합 구현 계약에서 existing M04 state를 먼저 읽고 정한다.

## Rationale and alternatives

| option | disposition | player / production consequence |
| --- | --- | --- |
| M04 전용 2→3→4주 flow | `ADOPT` | 승인된 +0/+15/+30의 원인과 결과가 실제로 보인다. 범용 calendar를 만들지 않는 중간 비용의 bounded flow다. |
| 2→3주차까지만 구현하고 4주차 제거 | `REJECT` | 비용은 낮지만 이미 승인된 강제 escalation과 결과 학습을 제거한다. |
| 4주차를 import/test-only 상태로 유지 | `REJECT` | 내부 검증은 가능해도 플레이어의 선택 결과나 판매 포인트로 정직하게 제시할 수 없다. |
| 전체 연도/달력 consumer를 먼저 일반화 | `REJECT` | M04 Slice에 비해 범위·저장·M01 회귀 위험이 과도하다. |

## Actual implementation evidence

- 현재 `preparation_scene.gd`는 선택한 episode를 즉시 `GameState.start_episode_from_preparation`으로 시작한다.
- `monthly_state_policy.gd`는 2/3/4주차와 `0/15/30` risk, `ADVANCE_WEEK`를 표현하지만 M04 player consumer는 없다.
- M01 전용 runtime sync만 존재하며, 현재 M04 monthly evidence는 persistence fixture다. 플레이 가능한 timing flow 증거는 없다.

## Later unified implementation contract boundary

후속 계약은 M04 전용으로 다음을 함께 다뤄야 한다.

1. Preparation의 M04 dispatch docket과 2→3→4주 state transition.
2. 한 번 준비한 경우에만 유지되는 transient route-memory modifier와 기존 `support_kwon_return_route`의 능동 소비.
3. 3주차 보류 시 modifier를 제거한 4주차 `+30` forced state와 확인 흐름.
4. Composite Result의 `immediate / delayed-used / delayed-unused / forced` timing causality.
5. 기존 save 호환, M01 회귀, 월간 policy idempotency, 1280×720 및 1920×1080 한글 가독성, mouse/keyboard, Human/new-player QA.

이 결정만으로 새 save schema, M04 data/Scene/UI mutation, 피해자 위험의 구체 수치 소비, asset 생산, Audio/VFX, balance PASS, runtime PASS, Human QA PASS를 승인하지 않는다.

## Reuse / Base promotion

`monthly_state_policy`의 2/3/4주차 risk grammar, `preparation_scene`의 사건 선택 surface, 기존 Recovery support, Composite Result를 `ADAPT`한다. M01 전용 sync와 ANNUAL POC의 범용 schedule UI는 M04 actual consumer가 아니므로 `REJECT`한다. 이 흐름은 M04 사건·권나래 지원·현재 slice의 연출에 결박되므로 `NO_BASE_PROMOTION`이다.
