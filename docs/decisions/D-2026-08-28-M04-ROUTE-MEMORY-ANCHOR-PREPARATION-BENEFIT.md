# D-2026-08-28 · M04 Route-Memory Anchor Preparation Benefit

> Status: `USER_APPROVED / PLANNING_CANON / IMPLEMENTATION_NOT_AUTHORIZED`
> Issue: #327
> Scope: `M04_RED_UMBRELLA`의 한 번 지연 출동만
> Owner: `CURRENT_PLANNING_CANON.md`, `current-planning-canon.json`, `CURRENT_DECISION_OVERLAY.md`, Notion `01 · Direction · Planning`
> Depends on: `D-2026-08-28-M04-ONE-DELAY-PREPARATION-VICTIM-RISK-TRADEOFF`

## Decision

M04에서 플레이어가 한 번 지연 출동을 택하면, 준비 이득은 **귀가 기억 고정 강화**다.

```text
한 번 지연 출동을 확정하기 전
  → “귀가 기억 고정 강화”
  → 회수에서 권나래가 기존 지원을 직접 사용할 때 피해자 공포 -24
  → 기본 귀가 기억 고정의 -16보다 추가 -8
  → 기존 회수 임계치 +2와 안정화 변화 0은 바꾸지 않음

회수 중
  → 플레이어가 기존 support_kwon_return_route 버튼을 한 번 직접 선택
  → 그 한 번에만 강화 수치를 적용
```

이 이득은 M04의 피해자 보호 고민을 강화하는 준비이며, 추리·단서·정답을 미리 주는 보너스가 아니다.

## Player contract

- 즉시 출동은 기존 `귀가 기억 고정`의 공포 `-16`과 임계치 `+2`를 가진 정상 선택이다.
- 한 번 지연은 피해자 위험 `+15`와 교환해, 같은 능동형 지원의 공포 감소를 `-24`로 강화한다.
- 강화 상태는 출동 확정 전에 이름·대상·효과·`+15` 위험을 함께 읽을 수 있어야 한다.
- 플레이어가 권나래 지원을 누르지 않으면 강화 이득은 발생하지 않는다. 자동 발동·추가 사용 횟수·무료 재시도는 없다.
- 강이준·오현의 M04 회수 지원과 기존 `threshold_delta`·`stability_delta`는 이 결정으로 변경하지 않는다.
- 준비는 단서, 힌트, 경쟁 가설, 매뉴얼 정답, 구출 절차, 전조의 정답을 공개하거나 바꾸지 않는다.

## Result / feedback contract

Composite Result의 timing axis는 지연의 `+15`와 준비한 기억 고정의 실제 사용 여부·보호 효과를 추리·구출·회수 결과와 분리해 설명한다.

- 지연 후 지원을 사용한 경우: 강화한 공포 감소와 지연 위험의 실제 결과를 모두 남긴다.
- 지연 후 지원을 사용하지 않은 경우: 준비 이득이 자동 보상으로 처리되지 않았음을 숨기지 않는다.
- 즉시 출동 또는 4주차 강제 출동은 이 modifier를 얻지 않는다.

## Implementation boundary

- 실제 소비처는 current M04 `battle_scene`의 `support_kwon_return_route` 단일 사용 버튼이다.
- 향후 구현은 M04 한 operation의 transient modifier와 pre-confirmation/Recovery/Composite Result 표시만 다룬다.
- 새 save schema, 기존 support ID 변경, 새 회수 규칙, 새 character/visual asset, 이미지 생성, balance PASS, Human QA PASS는 이 결정의 범위 밖이다.
- 수치 `-24`와 지연 위험 `+15`의 재미·명료성·균형은 target-resolution runtime 및 Human/new-player QA 전까지 `NOT_RUN`이다.

## Acceptance for a later unified implementation contract

1. M04 지연 확인 전 `+15` 위험과 `귀가 기억 고정 강화: 공포 -24`가 동시에 보인다.
2. 지연 없이 M04를 시작하면 권나래 지원은 기존 공포 `-16`이다.
3. 지연 후에도 플레이어가 권나래 지원을 직접 선택할 때만 공포 `-24`가 한 번 적용된다.
4. 강화는 임계치 `+2`, 안정화 변화 `0`, 타 요원 지원, 단서/힌트/정답에 영향을 주지 않는다.
5. Composite Result가 시간 위험, 강화 사용 여부, 보호 결과를 다른 결과 축과 분리해 설명한다.
6. 저장 호환, 1280×720 및 1920×1080 한글 가독성, 키보드/마우스 입력, M01 회귀, Human/new-player validation을 별도로 검증한다.

## Reuse / Base promotion

기존 `support_kwon_return_route`, `battle_scene` 단일-use 소비 문법, `monthly_state`, Composite Result를 `ADAPT`한다. ANNUAL POC의 준비도·확률 지원은 M04 actual consumer가 아니므로 `REJECT`한다. 이 선택은 M04의 제품 의미와 권나래 고유 지원에 묶이므로 `NO_BASE_PROMOTION`이다.
