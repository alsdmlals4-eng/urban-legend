# Canon v2 Rescue Result Handoff to Recovery Initial Conditions and Action Constraints Design

> Decision: `DEC-20260806-121-CANON-V2-RESCUE-RESULT-HANDOFF-TO-RECOVERY-INITIAL-CONDITIONS-AND-ACTION-CONSTRAINTS`
> 상태: `APPROVED_DESIGN_CONTRACT`
> GrillMe: Batch 3 `6_OF_10`
> Draft PR: #151
> 기반 PR: PR #149
> 구현: `IMPLEMENTATION_NOT_AUTHORIZED`
> 사람 검증: `HUMAN_QA_NOT_RUN`
> UI·접근성 검증: `UI_ACCESSIBILITY_NOT_RUN`
> 병합: `MERGE_NOT_AUTHORIZED`

## 1. 목표

구출 결과가 회수 플레이에 실제 영향을 주되 다음 왜곡을 만들지 않는 공용 인계 구조를 설계한다.

- 구출 성공/실패가 회수 대표 결과를 자동 결정하지 않는다.
- 피해자를 숫자 보너스·패널티로만 취급하지 않는다.
- 회수에서 같은 구출 퍼즐을 다시 풀게 하지 않는다.
- 회수 중 변화가 구출 종료 당시 사실을 덮어쓰지 않는다.
- 보호 의무는 플레이어 선택을 가능한 한 보존하면서 책임과 인과를 명확히 한다.
- 저장·불러오기·legacy migration이 중복 효과나 결과 발명을 만들지 않는다.

## 2. 설계 비교

### 접근 A — 숫자 보정 중심

구출 성공/실패를 시작 안정도, 회수 기준, 피해량, 행동 비용에 직접 환산한다.

- 장점: 현행 `battle_scene.gd`에 붙이기 쉽다.
- 단점: 생존·분리·후유증·보호 책임의 의미가 사라진다.
- 단점: 숨은 보정과 죽음의 나선이 발생하기 쉽다.
- 판정: `LEGACY_NUMERIC_HANDOFF`로만 보존한다.

### 접근 B — 강제 행동 잠금 중심

보호 의무가 끝날 때까지 공격·봉쇄·회수 행동을 막는다.

- 장점: 책임 위반을 강하게 방지한다.
- 단점: 같은 구출 퍼즐을 회수 안에서 반복할 위험이 높다.
- 단점: 구출 결과가 회수 승패를 사실상 결정한다.
- 판정: 물리적 불가능과 확인된 괴이 규칙 직접 위반에만 제한한다.

### 접근 C — 불변 스냅샷 + 의미 기반 어댑터 + 보호 의무

구출 사실, 회수 시작 조건, 가변 보호 책임, 인과 이력을 분리한다.

- 장점: 구출과 회수의 책임을 독립적으로 보존한다.
- 장점: 사건별 변주와 공용 저장·검증을 함께 지원한다.
- 장점: 행동 사전 경고와 fail-forward를 구현할 수 있다.
- 비용: 새 Schema·정책 객체·UI 소비 구조가 필요하다.
- 판정: 승인안.

## 3. 아키텍처

```text
Rescue scene / case adapter
  └─ finalize rescue facts
       └─ rescue_outcome_snapshot (immutable)
            └─ RescueRecoveryHandoffPolicy.derive()
                 ├─ recovery_handoff_state
                 └─ active_protection_obligations
                      └─ Battle action preview/evaluation
                           ├─ action allowed / blocked
                           ├─ forewarning and alternatives
                           └─ protection_history event
                                └─ result packet + save/load
```

각 단위의 책임은 다음과 같다.

### `rescue_outcome_snapshot`

구출 종료 당시 사실만 담는다. 회수 중 변경하지 않는다.

### `RescueRecoveryHandoffPolicy`

불변 스냅샷을 읽어 회수 시작 조건과 보호 의무를 결정하는 순수 정책 단위다. 사건별 adapter가 제공하는 규칙을 소비하되 저장이나 UI를 직접 조작하지 않는다.

### `recovery_handoff_state`

회수 시작 시점의 파생 상태다. 활성 보호 대상, 잔존 연결, 치료·격리·대피 필요, 안전 경로, 노출 위험, 중요 기록·매개체, 지원·대체 경로를 담는다.

### `active_protection_obligations`

회수 중 변하는 책임의 현재 상태다. `obligation_id`를 안정 키로 사용한다.

### `protection_history`

모든 의무 변화와 행동 인과를 append-only로 기록한다.

## 4. 구출 스냅샷 의미 계약

권장 의미 키는 구현 단계에서 정확한 enum 이름으로 확정하되 다음 축을 유지한다.

```text
survival_state
separation_state
aftereffects
last_risk_stage
observed_failure_reasons
new_evidence
contradictions
danger_cases
irreversible_results
remaining_protection_obligations
provenance
finalized_at
```

필수 불변식:

- `rescue_outcome_snapshot`은 구출 종료 후 불변이다.
- 확정 시점과 출처가 없는 필드는 권위 상태로 승격하지 않는다.
- 회수 중 개선·악화는 별도 현재 상태와 `protection_history`에 기록한다.
- 구출 종료 당시 사실과 회수 중 변화를 결과 화면에서 구분한다.
- 과거를 다시 쓰지 않는다.

## 5. 생존·분리·후유증 도출 규칙

### 생존 상태

| 입력 | 파생 책임 |
|---|---|
| 생존·안정 | 잔존 후유증·연결이 있을 때만 제한된 의무 생성 |
| 생존·위중 | 치료·방호·대피, 재표적·피해 전이 위험 표시 |
| 피해자 상실 | 시신·신원·기록 보존, 오염 격리, 2차 노출 차단 |
| 생존 불명·실종 | 수색·노출 차단·안전 경로·재진입 책임과 승인 철수 자격 확인 |

### 분리 상태

| 입력 | 파생 책임 |
|---|---|
| 완전 분리 | 직접 연결 위험 제거, 후유증·대피 책임만 유지 |
| 부분 분리 | 연결 감시, 매개체 분리, 재표적·오염·피해 전이 위험 |
| 분리 실패 | 강한 보호 책임, 긴급 봉쇄·승인 철수 판단 경로 |
| 비가역 연결 | 재구출 퍼즐 대신 피해 최소화·봉쇄·기록·후속 치료 |

### 후유증

- 부상 → 치료·이동·대피
- 기억 손상 → 기록 보존·진술 신뢰도·후속 치료
- 오염 → 격리·접촉 제한·매개체 추적
- 관계 손실 → 보호자·기관 인계·후속 지원
- 괴이 역할 잔존 → 연결 감시·역할 전이 차단

구출 결과가 회수 대표 결과를 자동 결정하지 않는다. 구출 실패가 회수 실패를 자동으로 만들지 않는다.

## 6. 보호 의무 데이터 계약

```text
obligation_id
target
responsibility_type
source_reason
urgency
affected_actions
completion_condition
breach_consequence
status
resolution_reason
```

권장 상태 흐름:

```text
ACTIVE
→ PARTIALLY_FULFILLED
→ FULFILLED
```

또는

```text
ACTIVE
→ BREACHED
→ MITIGATED | FAILED
```

대표 책임 유형:

- 대피
- 방호
- 치료
- 격리
- 연결 감시
- 2차 노출 차단
- 신원·기록 보존
- 매개체 분리
- 안전 경로 유지

불변식:

- 모든 의무는 `source_reason`으로 원인에 추적 가능하다.
- 같은 의미의 의무는 안정적인 `obligation_id`로 중복 생성하지 않는다.
- 의무 완료가 구출 스냅샷을 수정하지 않는다.
- 의무 위반이 곧바로 대표 회수 결과를 자동 실패로 바꾸지는 않으며 Decision 120의 종결 조건이 별도로 판정한다.

## 7. 행동 평가 흐름

```text
플레이어가 행동 선택
→ 관련 affected_actions 조회
→ 물리 가능성·괴이 규칙 위반 확인
→ 보호 의무 충돌과 예상 결과 계산
→ 선택 전에 경고·대안 표시
→ 플레이어 확정
→ 행동과 현상 판정 실행
→ 의무 상태와 protection_history 갱신
```

기본적으로 행동을 잠그지 않는다.

행동 완전 잠금 허용 조건:

1. 물리적으로 실행 불가능
2. 확인된 괴이 규칙을 직접 위반해 행동 자체가 성립하지 않음

표시해야 할 정보:

- 충돌하는 의무
- 예상 결과
- 위험 대상
- 책임 악화 가능성
- 도구·지원·대체 경로

관찰·괴이 매뉴얼 열람은 차단하지 않는다. 접근성 대체 입력과 시간 압박 완화는 불이익이 아니다.

## 8. 패턴 권위 보호

인계 정책은 다음을 읽거나 변경하는 권한이 없다.

- `pattern_id`
- `correct_response_id`
- 전조의 객관적 의미
- 패턴 후보 선택 순서와 가중치
- 같은 패턴의 규칙·정답

인계 상태는 행동의 책임 결과와 보호 상태에만 관여한다. 같은 구출 퍼즐을 반복하지 않는다. 전역 고정 턴 수를 도입하지 않는다.

## 9. fail-forward와 공정성

- 숨은 보정 금지
- 단일 구출 등급으로 모든 수치를 일괄 변경하지 않는다.
- 의미 상태에서 파생된 숫자는 선택 전에 설명 가능해야 한다.
- 구출 결과가 불리해도 최소 하나의 의미 있는 회수 행동 또는 승인 철수 판단 경로를 유지한다.
- 위험이 큰 상태에는 사건이 허용하는 도구·지원·대체 경로 중 하나 이상을 명시한다.
- 비가역 결과는 복구하지 않지만 남은 책임을 수행할 선택은 남긴다.
- 죽음의 나선을 만드는 누적 패널티 묶음을 금지한다.

정확한 수치와 도구 수량은 구현 승인 후 별도 밸런싱한다.

## 10. 저장과 이관

저장 단위:

```text
rescue_outcome_snapshot
recovery_handoff_state
active_protection_obligations
protection_history
```

요구사항:

- 초기 도출은 한 번만 수행한다.
- 불러오기 시 초기 조건을 다시 적용하지 않는다.
- 동일 `obligation_id`를 중복 생성하지 않는다.
- 원자적, rollback-safe, idempotent 이관을 사용한다.
- 필수 필드 누락·출처 불명·상호 모순 시 `handoff_validation_failed`를 기록하고 회수 진입을 중단한다.
- 부분 커밋을 허용하지 않는다.

legacy migration:

- 현행 성공/실패 bool과 회수 기준·시작 안정도 증감은 `LEGACY_NUMERIC_HANDOFF`다.
- legacy bool 원본과 출처를 보존한다.
- 완전 구출을 추정하지 않는다.
- 생존·완전 분리·후유증 없음·보호 의무 없음 상태를 발명하지 않는다.

## 11. UI·접근성 계약

행동 확정 전 최소 표시:

```text
행동
충돌 의무
예상 결과
위험 대상
대안
```

- 색상·음향만으로 충돌과 위험을 전달하지 않는다.
- 화면 낭독 가능한 텍스트와 포커스 순서를 제공한다.
- 경고 확인에 반사 신경을 요구하지 않는다.
- 매뉴얼 열람·일시정지·시간 압박 완화는 결과·보상·랭크를 낮추지 않는다.
- 최종 배치와 카피는 runtime 구현 뒤 Human QA와 UI·접근성 검증 대상이다.

## 12. 오류 처리

| 오류 | 처리 |
|---|---|
| 스냅샷 필수 축 누락 | `handoff_validation_failed`, 회수 진입 중단, 원본 보존 |
| 출처 없는 의무 | 생성 거부, 감사 로그 기록 |
| 중복 `obligation_id` | 동일 의미면 기존 상태 재사용, 충돌 의미면 검증 실패 |
| 저장 중 일부만 기록 | 전체 rollback |
| 패턴 진실 변경 시도 | 정책 경계 위반으로 거부 |
| legacy bool만 존재 | 원본 보존, 최소 legacy handoff, 완전 구출 추정 금지 |

## 13. 테스트 전략

### 정책 단위 테스트

- 생존·분리·후유증 조합에서 예상 의무가 도출되는지 검증
- `source_reason`과 `obligation_id` 안정성 검증
- 패턴 권위 비변경 검증
- 제한적 hard lock 검증

### 저장·이관 테스트

- save/load 후 초기 조건 재적용 없음
- 의무 중복 생성 없음
- 원자성·rollback·idempotent 검증
- legacy bool에서 완전 구출을 발명하지 않음

### 장면 통합 테스트

- 구출 종료 → 회수 진입 인계
- 행동 선택 전 예상 결과·대안 표시
- 의무 이행·위반 → `protection_history`
- 결과 화면에서 구출 당시 사실과 회수 중 변화 분리

### Human QA

- 책임 정보가 이해 가능한지
- 경고가 선택을 과도하게 방해하지 않는지
- 죽음의 나선이나 사실상 강제 선택이 없는지
- 접근성 대체 입력과 시간 완화가 중립인지

## 14. 범위 밖

- runtime·Scene·Episode JSON·save schema 실제 변경
- 정확한 enum 이름·수치·비용·도구 수량 확정
- 최종 UI 와이어프레임·이미지·애니메이션·HX·오디오
- PR #149·PR #151 병합
- Human QA 또는 UI·접근성 통과 선언

현재 상태는 `IMPLEMENTATION_NOT_AUTHORIZED / HUMAN_QA_NOT_RUN / UI_ACCESSIBILITY_NOT_RUN / MERGE_NOT_AUTHORIZED`다.
