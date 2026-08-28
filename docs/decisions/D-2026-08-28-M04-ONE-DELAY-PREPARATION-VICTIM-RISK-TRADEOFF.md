# D-2026-08-28 · M04 One-Delay Preparation ↔ Victim-Risk Trade-off

> Status: `USER_APPROVED / PLANNING_CANON / IMPLEMENTATION_NOT_AUTHORIZED`
> Issue: #325
> Scope: `M04_RED_UMBRELLA` release-near Vertical Slice only
> Owner: `CURRENT_PLANNING_CANON.md`, `current-planning-canon.json`, `CURRENT_DECISION_OVERLAY.md`, Notion `01 · Direction · Planning`

## Decision

M04의 출동 타이밍은 달력 숫자 관리가 아니라 **준비와 보호의 한 번짜리, 관측 가능한 교환**이다.

```text
즉시 출동
  → 지연 위험 +0, 준비 이득 없음

한 번만 준비 후 지연 출동
  → 선택 전에 보이는 준비 이득 1개
  → 피해자 위험 +15
  → 정답·히든 진실·자동 규칙 해금은 절대 제공하지 않음

4주차 강제 출동
  → 별도·가시적 escalation boundary, 피해자 위험 +30
```

## Player contract

- 플레이어는 `지금 보호를 우선할지`와 `준비 하나를 더 확보하고 위험을 감수할지`를 한 번만 선택한다.
- 준비 이득은 선택 전에 이름·효과·범위를 읽을 수 있어야 한다. 정확한 M04 이득 내용은 다음 별도 결정에서 정한다.
- 즉시 출동은 벌점이 아니라 피해자 안전을 지키는 유효한 선택이다.
- 지연의 +15와 4주차의 +30은 감추지 않는다. 값은 Human QA 이전까지 provisional이며, 의미·표시·결과 연결은 이 결정으로 고정한다.
- 시간 선택은 관측 사실, 경쟁 가설, 매뉴얼 정답, 구출 절차, 회수 전조의 정답을 자동으로 변경하거나 알려 주지 않는다.

## Result / feedback contract

Composite Result는 기존 추리·구출·회수 결과를 하나의 등급으로 덮지 않는다. 여기에 **출동 타이밍의 인과**를 별도 설명으로 남긴다.

- 즉시 출동: 보존한 피해자 안전 또는 피한 위험을 명확히 보인다.
- 한 번 지연: 획득한 준비 이득과 +15가 만든 피해자 상태/후속 비용을 명확히 보인다.
- 강제 출동: +30 escalation이 발생한 이유를 명확히 보인다.

이 설명은 사후 비난이나 숨은 정답 공개가 아니라 다음 시도의 판단 근거다.

## Boundaries

- M01 First Session에는 이 선택을 추가하지 않는다. M01은 낮은 복잡도의 온보딩/회귀 역할을 유지한다.
- 4주 전체의 다중 슬롯 편성 sandbox, 추가 사건, 새 전투 규칙, asset/UI 생산, save schema, Godot 구현은 이 결정의 범위 밖이다.
- 미래 구현은 소비처별 Issue와 acceptance, target-resolution runtime 검증, Human/new-player validation을 별도로 통과해야 한다.

## Acceptance for a later implementation task

1. M04에만 즉시 출동 또는 한 번 지연+준비의 두 선택이 보인다.
2. 지연 전 +15 위험과 준비 이득을 동시에 읽을 수 있다.
3. 4주차 +30 강제 출동은 별도로 예고·기록된다.
4. 어떤 준비 이득도 정답/미관측 패턴/히든 진실을 자동 제공하지 않는다.
5. Composite Result가 timing causality를 deduction/rescue/recovery와 분리해 설명한다.
6. Human QA 전까지 재미·명료성·균형·접근성 PASS를 주장하지 않는다.

## Reuse / Base promotion

기존 월간 cadence, `monthly_state`, Composite Result, M04 shared screen grammar를 재사용한다. 이 선택은 단일 프로젝트의 제품 의미 결정이므로 `NO_BASE_PROMOTION`이다.
