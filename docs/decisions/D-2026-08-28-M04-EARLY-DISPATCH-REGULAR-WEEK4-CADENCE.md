# D-2026-08-28 · M04 Early Dispatch / Regular Week-4 Cadence

> Status: `USER_APPROVED / PLANNING_CANON / IMPLEMENTATION_NOT_AUTHORIZED`
> Decision ID: `D-2026-08-28-M04-EARLY-DISPATCH-REGULAR-WEEK4-CADENCE`
> Issue: #331
> Scope: `M04_RED_UMBRELLA`의 출동 전 timing, 권나래 지원의 M04 전용 준비 tier, Composite Result timing axis
> Owner: `CURRENT_PLANNING_CANON.md`, `current-planning-canon.json`, `CURRENT_DECISION_OVERLAY.md`, `CURRENT_HANDOFF.md`, `M01_M04_VERTICAL_SLICE_FLOW.md`, Notion `01 · Direction · Planning`
> Supersedes current authority of: `D-2026-08-28-M04-ONE-DELAY-PREPARATION-VICTIM-RISK-TRADEOFF`, `D-2026-08-28-M04-ROUTE-MEMORY-ANCHOR-PREPARATION-BENEFIT`, `D-2026-08-28-M04-BOUNDED-FORCED-DISPATCH-REACHABILITY`

## Decision

M04의 기준 출동일은 **4주차 정규 출동**이다. 4주차를 지연·강제·modifier 상실로 표현하지 않는다. 플레이어는 2주차 또는 3주차에 더 이른 보호를 위해 조기 출동할 수 있다.

```text
2주차 · 조기 출동 I
  → 피해자 귀가 기억 노출 +0
  → 준비 tier 0: 권나래 지원은 기존 공포 -16 / 임계치 +2 / 안정화 +0

3주차 · 조기 출동 II
  → 피해자 귀가 기억 노출 +15
  → 준비 tier 1: 같은 능동형 권나래 지원을 실제로 사용할 때 안정화 +4

4주차 · 정규 출동
  → 피해자 귀가 기억 노출 +30
  → 준비 tier 2: 같은 능동형 권나래 지원을 실제로 사용할 때 안정화 +8
```

`+15`와 `+30`은 “출동을 지연해서 부과된 벌점”이 아니라 조기 보호 기회를 사용하지 않았을 때 M04 피해자의 귀가 기억이 현상에 더 오래 노출된 결과다. 4주차 출동은 플레이어에게 숨은 강제 확인이나 벌칙으로 제시되지 않는다.

## Player contract

- 2주차에는 가장 빠르게 피해자를 보호하지만 M04 전용 준비 강화는 없다.
- 3주차에는 일부 노출을 감수하고, 플레이어가 권나래의 기존 한 번짜리 지원을 직접 사용할 때만 안정화 `+4`를 얻는다.
- 4주차는 정규 출동이며, 가장 큰 노출과 교환해 같은 능동형 지원의 안정화 `+8`을 얻을 수 있다.
- 안정화 이득은 자동 발동·추가 사용·무료 재시도가 아니다. 권나래를 편성하고 해당 지원을 직접 선택해야 한다.
- 기존 기본 효과인 공포 `-16`, 임계치 `+2`, 타 요원 지원은 바꾸지 않는다. 이전의 지연 전용 공포 `-24`는 current authority가 아니다.
- 추리, 단서, 힌트, 경쟁 가설, 정답, 구출 절차, M01에는 영향을 주지 않는다.

## Result / feedback contract

- M04 전용 `victim_route_memory_exposure`는 `0 / 15 / 30`을 보존하고, Composite Result에서 추리·구출·회수 등급과 독립적으로 설명한다.
- Result는 `WEEK_2_EARLY`, `WEEK_3_EARLY`, `WEEK_4_REGULAR`과 권나래 지원의 실제 사용 여부 및 `0 / +4 / +8` 안정화 효과를 함께 보여야 한다.
- 이 축은 기존 `battle_scene`의 공포 bar, `victim_understanding`, `investigation_risk`, resolution grade를 재정의하지 않는다.

## Rationale and alternatives

| option | disposition | player / production consequence |
| --- | --- | --- |
| 2·3주차 조기 / 4주차 정규 3-tier cadence | `ADOPT` | 피해자 보호와 현장 준비의 교환을 유지하면서 4주차를 정직한 기본 출동일로 만든다. |
| 기존 2→3→4주차 지연·강제 flow 유지 | `REJECT` | 4주차를 지연 처벌로 잘못 설명하며, 실제 공포 수치가 피해자 결과를 뜻한다는 오류를 남긴다. |
| `investigation_risk` 또는 `victim_understanding`을 재사용 | `REJECT` | 각각 괴이 랜덤 사건/정보량이며 피해자 귀가 기억 노출이 아니다. 의미와 밸런스가 오염된다. |
| 결과 라벨만 추가하고 준비 이득을 공포 -24로 유지 | `REJECT` | 시간 선택의 효과와 준비 이득이 실제 결과·회수 조건에 연결되지 않는다. |

## Later unified implementation contract boundary

후속 통합 구현 계약은 M04 한정으로 다음을 함께 다룬다.

1. Preparation에서 2·3주차 조기 출동 및 4주차 정규 출동을 읽을 수 있는 docket.
2. M04의 transient/persisted timing record와 `victim_route_memory_exposure`의 save round-trip.
3. 기존 `support_kwon_return_route` 한 번 사용에만 적용되는 tier 0/1/2 안정화 `0/+4/+8`.
4. Recovery와 Composite Result의 timing/exposure/support-use 피드백.
5. M01 회귀, monthly policy idempotency, target-resolution 한글 가독성, mouse/keyboard, Human/new-player QA.

이 결정은 코드·data·Scene·asset·save schema·runtime UI·test·balance PASS·Human QA PASS를 승인하지 않는다.

## Project Incident / Solution / Lesson

- **Incident:** predecessor 문서는 4주차를 지연의 강제 벌점으로, 권나래의 공포 수치를 피해자 결과에 닿는 준비 이득으로 서술했다. actual `battle_scene`에서 공포는 팀 정신력에서 파생되는 현장 표시이며 회수 가능 조건·피해자 결과의 consumer가 아니다.
- **Solution:** 4주차를 정규 출동일로 바로잡고, 2·3주차만 조기 보호 창으로 둔다. 피해자 귀가 기억 노출은 독립 Composite Result axis, 준비 이득은 실제 한 번 사용형 안정화 `0/+4/+8`로 분리한다.
- **Lesson:** 기획 수치·라벨은 실제 state consumer와 outcome gate를 대조한 뒤에만 player consequence로 표현한다. 이 교훈은 M04 사건·지원·노출 축에 묶여 있어 `NO_BASE_PROMOTION`이다.

## Reuse / Base promotion

기존 `monthly_state_policy`의 2/3/4주차 및 `0/15/30` 값, `preparation_scene`의 사건 선택, `support_kwon_return_route`의 한 번 사용, Composite Result를 `ADAPT`한다. 현재 공포 bar와 M01 전용 monthly sync는 `REJECT`한다. M04 피해자·권나래·출동 cadence에 결박된 결정이므로 `NO_BASE_PROMOTION`이다.
