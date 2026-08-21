# M01 저승역 Recovery Scene Packet

Status: `PLAN_LOCK / CANON_V2_ALIGNED / IMPLEMENTATION_NOT_AUTHORIZED`
Parent canon: `docs/CURRENT_PLANNING_CANON.md`
Incident canon: `docs/CURRENT_AFTERLIFE_STATION_CANON.md`
Planning closure: `docs/planning/2026-08-21-visual-ui-planning-closure.md`

## Purpose

피해자 구출 뒤 남은 저승역 잔향을 **전조를 읽고 규칙을 적용해 안정화·회수**하는 M01 마지막 실행 Phase를 정의한다. 구출 성공은 회수 승리를 자동 보장하지 않으며, 회수 실패도 이미 구출한 피해자를 소급 삭제하지 않는다.

## Flow

Investigation
→ Deduction / Anomaly Manual
→ Victim Rescue
→ Recovery
→ `COMPOSITE_RESULT`

## Screen priority

1. 괴이 현상/잔향.
2. 다음 전조와 예상 영향.
3. 현재 보호 대상/봉쇄 상태.
4. 현재 참조 가능한 조사 기록/매뉴얼 규칙.
5. `보호 / 관찰 / 대응 / 공격 / 장비 / 봉쇄 / 후퇴` 행동군.
6. 동료 지원 상태.

공격 수치나 HP가 전조·보호·봉쇄 조건보다 시각적으로 우선하지 않는다.

## Three Canon v2 patterns

### 1. 목적지 합창

Evidence skill:
- 서로 다른 목적지 기록에서 **공통 무음 구간**을 찾는다.

Telegraph:
- 복수 안내가 겹치지만 특정 구간에서 동일한 공백/정적이 반복된다.

Counter:
- 최종 대응 시 공식 역 식별음을 공백에 삽입해 개인 목적지 투영을 붕괴시킨다.

Result language:
- `개인 목적지 투영 약화 / 기억 매듭 노출 / 봉쇄창 생성`처럼 규칙 효과를 보여준다.

### 2. 회귀 승강장

Evidence skill:
- 시간·좌표·기록이 반복될 때 **주기마다 남는 지속 흔적**을 비교한다.

Telegraph:
- 공간은 초기화되지만 일부 흔적/기록이 동일 좌표 또는 연속성으로 남는다.

Counter:
- 복수 주기의 지속 흔적을 비교해 실제 잔향 좌표를 고정하고 봉쇄 대상으로 지정한다.

Result language:
- `좌표 고정 / 반복 경로 분리 / 잔향 노출`을 보여준다.

### 3. 무정차 환송

Evidence skill:
- 개인 기억의 투영 노선과 **공식 귀환 노선/승차권**을 구분한다.

Telegraph:
- 개인 목적지 방향의 환송 경로가 열리거나 하차 판단을 유도한다.

Counter:
- 현실 귀환 경로와 일치하는 공식 승차권·역 식별을 사용해 투영 노선을 파훼한다.

Result language:
- `투영 노선 차단 / 공식 경로 유지 / 회수 가능`처럼 인과를 보여준다.

## First-session teaching order

M01은 세 패턴을 동등한 난이도의 연속 시험으로 제시하지 않는다.

1. 첫 패턴: telegraph와 대응 관계를 명시적으로 가르친다.
2. 두 번째 패턴: 같은 화면 문법을 사용하되 필요한 조사 기록을 플레이어가 스스로 고르게 한다.
3. 세 번째 패턴: 앞선 조사·구출에서 이미 사용한 규칙을 회수 행동으로 다시 적용한다.

`SERIAL_EXAM_FATIGUE_GUARD`:
- 회수 Phase에서 새로운 별도 정답 체계를 추가하지 않는다.
- 이전 조사/추리에서 이미 확보한 규칙을 실행 방식으로 재사용한다.
- 실패는 `전조 해석 오류 / 규칙 적용 오류 / 입력 지연`을 구분한다.
- 첫 실패는 학습 가능한 기록을 남기며 즉시 전체 사건 리셋으로 보내지 않는다.

## Character presentation

- 일반 상태: 작은 Portrait/상태/지원 조건.
- 스킬 발동: 짧은 Cut-in 허용.
- Cut-in은 다음 전조·보호 대상·봉쇄 조건을 가리지 않는다.
- 캐릭터보다 괴이 현상과 관측 정보가 화면 우선순위가 높다.

## Recovery → Composite Result

회수 종료 시 최소 다음을 독립적으로 남긴다.

- victim outcome.
- confirmed rules.
- recovery/stabilization state.
- danger cases.
- residual anomaly.
- unresolved questions.

현재 제품은 단일 S/A/B 등급을 결과 정본으로 사용하지 않는다. 성과 요약이 필요해도 위 복합 축을 덮어쓰지 않는다.

## Guardrails

- 공격 반복만으로 승리 금지.
- 매뉴얼/접근성 기능이 정답 대응·좌표·타이밍을 자동 표시하지 않음.
- 색상·음향 하나에만 전조 정보를 의존하지 않음.
- 구출 성공과 회수 성공을 같은 bool로 덮어쓰지 않음.
- Human QA 전 패턴 수치·허용 시간·피해량은 provisional.
- runtime/code/data/Scene/save 변경 권한 없음.
