# Canon v2 Protection Obligation Cost, Priority, and Recovery Termination Eligibility Design

> Decision: `DEC-20260806-122-CANON-V2-PROTECTION-OBLIGATION-COST-PRIORITY-AND-RECOVERY-TERMINATION-ELIGIBILITY`
> 상태: `APPROVED_DESIGN_CONTRACT`
> GrillMe Batch 3: `7_OF_10`
> 구현: `IMPLEMENTATION_NOT_AUTHORIZED`
> Human QA: `HUMAN_QA_NOT_RUN`
> UI·접근성: `UI_ACCESSIBILITY_NOT_RUN`
> 병합: `MERGE_NOT_AUTHORIZED`

## 1. 목적

Decision 121은 구출 결과를 불변 스냅샷, 회수 인계 상태, 가변 보호 의무, 인과 이력으로 분리했다. 이번 설계는 그 보호 의무가 실제 회수 플레이에 영향을 주는 범위를 정한다.

핵심 문제는 두 극단을 피하는 것이다.

- 페널티 과잉: 구출 손실이 모든 회수 행동 비용과 종결 결과를 악화시켜 죽음의 나선을 만든다.
- 서사 전용: 보호 의무가 결과 문구에만 남아 구출 선택이 회수 플레이에 영향을 주지 않는다.

권장안은 세 채널을 서로 분리하는 혼합형이다.

```text
행동 비용
표시 우선순위
종결 자격
```

`단일 의무 점수`나 자동 승패는 사용하지 않는다.

## 2. 검토한 접근

### A. 전면 페널티형

모든 미완료 의무가 회수 시작 안정도, 행동 비용, 성공률, 종결 등급을 함께 낮춘다.

- 장점: 구출 결과의 영향이 강하게 느껴진다.
- 문제: 숨은 보정, 단일 실패 등급, 회복 불가능한 연쇄 손실, 승인 철수 악용·오판이 발생한다.
- 판정: 기각.

### B. 책임 채널 분리형 — 권장

의무와 직접 관련된 행동에만 표시 가능한 비용을 붙이고, 우선순위는 정보 정렬로 사용하며, 종결 자격은 각 결과의 의미 조건에 따라 별도 평가한다.

- 장점: 구출 선택의 책임이 실제 플레이에 남는다.
- 장점: 현상 통제 축과 보호 축을 독립 보존한다.
- 장점: 플레이어가 비용과 결과를 확인하고 선택할 수 있다.
- 단점: 의무·비용·종결 평가의 출처와 저장 구조가 필요하다.
- 판정: 승인.

### C. 서사 전용형

보호 의무를 결과 보고서와 대사에만 사용한다.

- 장점: 구현이 단순하다.
- 문제: 구출 결과가 회수 의사결정에 실질적으로 연결되지 않는다.
- 판정: 기각.

## 3. 구성 요소

### 3.1 Protection Obligation Policy

보호 의무의 비용 조정과 표시 우선순위를 계산한다.

입력:

- `active_protection_obligations`
- 선택 중인 행동
- 현재 자원·지원·안전 경로
- 이미 적용된 `cost_adjustment_id`

출력:

- 관련 비용 조정
- 우선순위 정렬
- 충돌 의무
- 위험 대상
- 사용할 수 있는 대안

### 3.2 Recovery Termination Eligibility

Decision 120의 대표 회수 결과 후보가 현재 상태에서 성립하는지 평가한다.

입력:

- 현상 통제 상태
- 안전 철수 경로
- 보호 의무 상태
- 책임 이관·연기 정보
- 기록·보호 대상 확인 상태

출력:

```text
termination_candidate
eligible
blocking_reasons
non_blocking_consequences
accountable_transfer
```

### 3.3 Game State Persistence

다음을 분리 저장한다.

- 보호 의무 원본
- `cost_adjustment_id`와 `applied_once`
- `priority_class`, `priority_reason`, `created_order`
- `completed`, `transferred`, `deferred_with_owner`, `breached`, `unresolved`
- `accountable_owner`, `follow_up_condition`
- 종결 후보 평가 이력

### 3.4 Battle Presentation

행동이나 종결을 확정하기 전에 다음을 표시한다.

- `base cost`
- `additional cost`
- 비용 출처
- 충돌 의무와 위험 대상
- 우선순위 이유
- 대체 행동·도구·지원·책임 이관·책임 있는 연기
- 종결 후보의 차단 이유와 비차단 결과

## 4. 행동 비용 규칙

### 4.1 허용되는 비용 채널

새 전역 화폐를 만들지 않고 현재 게임이 이미 사용하는 선택 비용 채널만 사용한다.

- 행동 기회
- 시간 또는 순서 지연
- 장비·지원 자원
- 노출 위험
- 사건이 명시적으로 제공한 기타 채널

### 4.2 인과 조건

비용은 관련 행동에만 적용한다.

예시:

- 위중한 피해자 이동 중 공격: 방호 없이 공격할 경우 피해 전이 위험
- 오염된 매개체 운반 중 봉쇄: 추가 격리 장비 또는 지원 필요
- 안전 경로 유지 의무 중 무리한 진입: 철수 경로 악화 위험

다음은 금지한다.

- 구출 실패 bool 하나로 모든 행동 비용 증가
- 모든 공격·관찰·장비·후퇴에 같은 추가 비용
- 설명 없는 시작 안정도 감소
- 같은 원인에서 생성된 의무와 비용의 중복 적용

### 4.3 비용 상한

정확한 숫자는 승인하지 않지만 의미적 상한은 고정한다.

- 모든 의미 있는 행동을 불가능하게 만들지 않는다.
- 현재 자원으로 비용을 감당할 수 없다면 적어도 하나의 책임 보존 대안을 제시한다.
- 관찰·괴이 매뉴얼·결과 미리보기는 비용을 부과하지 않는다.
- 접근성 대체 입력과 시간 압박 완화는 비용이 아니다.
- 비용을 지불하지 못했다는 이유만으로 패턴 정답이나 전조 의미를 바꾸지 않는다.

## 5. 우선순위 규칙

`priority_class`는 행동 명령이 아니라 주의 순서다.

- `critical`: 다음 관련 행동 또는 종결 전에 확인해야 할 비가역 위험
- `urgent`: 악화 중이나 지원·보호·대안으로 회복 가능한 위험
- `watch`: 즉시 강제하지 않는 감시·기록·후속 책임

각 항목은 `priority_reason`을 표시한다.

우선순위는 다음을 하지 않는다.

- 자동 실행하지 않는다.
- 강제 대상 선택을 하지 않는다.
- 숨은 성공률 보정을 하지 않는다.
- 행동 버튼을 순위만으로 잠그지 않는다.

동일 우선순위는 `created_order`, 그다음 `obligation_id`로 결정적 순서를 만든다.

## 6. 의무 상태와 책임 이관

### `completed`

완료 조건을 충족했다.

### `transferred`

책임을 수행할 자격과 수단이 있는 `accountable_owner`가 명시적으로 수락했다.

필수 정보:

- 인계 대상
- 수락 근거
- 대상·기록·자원의 현재 상태
- 후속 책임

### `deferred_with_owner`

즉시 완료하지 못했지만 책임자와 `follow_up_condition`을 확정했다.

예:

- 지원팀 도착 뒤 격리
- 안전 경로 확보 뒤 재진입
- 의료기관 인계 뒤 후유증 추적

### `breached`

보호 의무 위반 결과가 발생했다. 위반은 숨기지 않지만 모든 회수 결과를 자동 실패로 만들지는 않는다.

### `unresolved`

완료, 유효 이관, 책임 있는 연기 어느 것도 성립하지 않았다.

## 7. 종결 자격

### 7.1 현상 통제 결과

다음 결과는 현상 통제 상태에 따라 판정하며, 미완료 보호 의무만으로 대표 회수 결과를 자동 강등하지 않는다.

- `residue_recovered`
- `containment_complete`
- `stabilization_complete`
- `emergency_containment`

보호 의무의 위반·미완료는 보호 축과 비차단 결과에 기록한다.

### 7.2 승인 철수

`approved_withdrawal`은 책임 있는 종료이므로 추가 게이트가 필요하다.

허용 가능:

- `completed`
- 유효한 `transferred`
- 유효한 `deferred_with_owner`
- 위반 사실을 기록하고 안전 철수·후속 책임이 성립하는 `breached`

차단:

- 중대 보호 의무가 책임 있게 인계되지 않은 상태
- 보호 대상이나 중요 기록이 확인되지 않았고 추적 계획도 없음
- 안전 경로가 없고 붕괴 전 의도적 종료가 성립하지 않음

차단돼도 후퇴 선택 자체를 숨기거나 잠그지 않는다. 결과 미리보기에서 `approved_withdrawal`이 아닌 강제 퇴각 또는 `control_failure`가 되는 이유를 보여 준다.

## 8. 결과 미리보기

### 행동 미리보기

```text
선택 행동: 공격
base cost: 행동 1회
additional cost: 방호 지원 1회 또는 피해 전이 위험
source_reason: 부분 분리 상태의 피해자 연결
위험 대상: victim_001
대안: 보호 / 방호 장비 / 다른 규칙 대응
```

정확한 수치는 예시이며 구현 승인 대상이 아니다.

### 종결 미리보기

```text
termination_candidate: approved_withdrawal
eligible: false
blocking_reasons:
- critical 의무 obligation_victim_evacuation이 unresolved
non_blocking_consequences:
- 기록 보존 의무는 deferred_with_owner
accountable_transfer:
- records_team / 재진입 조건 확정
```

종결 확정 전에 상위 결과가 성립하지 않는 이유와 미완료 의무와 후속 책임을 표시한다.

## 9. 실패 전진

- 최소 하나의 의미 있는 회수 행동 또는 책임 있는 종결 판단을 남긴다.
- 보호 행동, 도구·지원, 책임 이관, 후속 책임이 명시된 연기, 승인 철수 판단 중 하나 이상을 제시한다.
- 모든 의무를 먼저 처리해야만 회수를 진행하는 전역 게이트를 금지한다.
- 같은 구출 퍼즐을 반복하지 않는다.
- 비가역 결과는 복구하지 않지만 남은 책임을 수행할 선택은 제공한다.

## 10. 패턴·접근성 경계

비용·우선순위·종결 평가는 다음을 변경하지 않는다.

- `pattern_id`
- `correct_response_id`
- 전조의 객관적 의미
- 사건의 유효 후보 계산

관찰과 괴이 매뉴얼 열람은 무료다. 접근성 기능에는 랭크·보상·종결 자격 불이익 금지를 적용한다.

## 11. 저장과 호환

- 같은 cost_adjustment_id를 중복 적용하지 않는다.
- 비용·의무 상태·종결 평가를 원자적으로 저장한다.
- 실패 시 rollback한다.
- 저장·불러오기는 idempotent하다.
- `created_order`와 `obligation_id`로 우선순위를 재현한다.
- `LEGACY_NUMERIC_HANDOFF`의 원본과 출처를 보존한다.
- 기존 시작 안정도 보정을 보호 의무 비용으로 소급 해석하지 않는다.

## 12. 오류 처리

다음은 조용히 보정하지 않고 검증 실패로 기록한다.

- 출처 없는 비용 조정
- 존재하지 않는 obligation_id 참조
- base cost 또는 additional cost의 표시 불가
- 같은 cost_adjustment_id의 상충 데이터
- transferred인데 accountable_owner가 없음
- deferred_with_owner인데 follow_up_condition이 없음
- approved_withdrawal 평가에 차단 이유가 누락됨
- 우선순위 순서가 저장·재개 후 바뀜

오류 발생 시 해당 비용·상태 전이를 적용하지 않고 이전 원자적 상태로 rollback한다.

## 13. 테스트 전략

### 계약 테스트

- 세 채널 분리
- 비용의 인과·가시성·상한
- 우선순위의 비강제성·결정적 정렬
- 현상 통제 결과와 보호 축 독립
- 승인 철수 책임 게이트
- 종결 미리보기
- 저장·불러오기 중복 방지
- 접근성 중립

### Godot 단위 테스트

- 관련 행동에만 비용 조정
- 중복 원인 정규화
- 최소 의미 행동 보존
- 우선순위 정렬 재현
- 유효·무효 책임 이관
- 승인 철수와 강제 퇴각 구분
- 저장 재개 시 applied_once 유지

### Human QA

- 비용과 출처를 선택 전에 이해하는가
- 높은 우선순위를 강제 명령으로 오해하지 않는가
- 보호 의무가 있어도 의미 있는 선택이 남는가
- 승인 철수 차단 이유를 납득하는가
- 현상 통제 성과와 보호 위반을 동시에 기억하는가
- 접근성 대체 입력에서 정보와 결과가 동등한가

## 14. 승인 경계

이 설계는 기획 계약만 승인한다.

- `IMPLEMENTATION_NOT_AUTHORIZED`
- `HUMAN_QA_NOT_RUN`
- `UI_ACCESSIBILITY_NOT_RUN`
- `BATCH_MERGE_NOT_STARTED`
- `MERGE_NOT_AUTHORIZED`
- PR #149와 PR #151은 병합하지 않는다.
