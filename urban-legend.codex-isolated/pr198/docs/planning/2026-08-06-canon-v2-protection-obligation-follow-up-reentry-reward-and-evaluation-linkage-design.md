# Canon v2 보호 의무 후속 조사·재진입·보상·평가 연결 설계

> Decision ID: `DEC-20260806-123-CANON-V2-PROTECTION-OBLIGATION-FOLLOW-UP-REENTRY-REWARD-AND-EVALUATION-LINKAGE`
> 상태: `APPROVED_DESIGN_CONTRACT`
> 사용자 승인: 2026-08-06 10:48 KST — `권장안대로 진행`
> GrillMe: Batch 3 `8_OF_10`
> 구현: `IMPLEMENTATION_NOT_AUTHORIZED`
> Human QA: `HUMAN_QA_NOT_RUN`
> UI·접근성 QA: `UI_ACCESSIBILITY_NOT_RUN`
> 병합: `MERGE_NOT_AUTHORIZED`
> Draft PR: #151 / 기반 PR: PR #149

## 1. 설계 목적

Decision 121은 구출 결과를 불변 스냅샷과 보호 의무로 회수에 인계했고, Decision 122는 보호 의무가 회수 행동 비용·표시 우선순위·종결 자격에 미치는 범위를 분리했다. 이 설계는 사건 종결 뒤에도 남는 책임을 다음 네 영역으로 연결한다.

1. 후속 조사와 비현장 책임 수행
2. 필요할 때만 허용되는 재진입
3. 사건 결과를 지우지 않는 다축 평가
4. 캠페인 전력을 왜곡하지 않는 보상

핵심 문제는 책임의 연속성을 만들면서도 다음 실패를 피하는 것이다.

- 모든 미완료 의무가 재진입 퀘스트가 되는 구조
- breach를 복구하면 원래 피해가 없어진 것처럼 보이는 구조
- 반복 가능한 피해·복구 보상 파밍
- 후속 작업이 핵심 캠페인 진행을 영구 차단하는 구조
- 단일 평판 점수가 모든 결과를 덮는 구조

## 2. 권장 아키텍처

```text
recovery_result_packet
+ active_protection_obligations
+ protection_history
→ protection_follow_up_policy
→ follow_up_records
→ reentry_eligibility evaluator
→ optional field re-entry / remote follow-up / owner verification
→ follow_up causal history
→ independent evaluation axes
→ campaign-neutral rewards and visible mastery constraints
```

### 책임 분리

- `protection_obligation_policy`: 회수 중 의무의 상태와 비용·우선순위·종결 자격 담당
- `protection_follow_up_policy`: 종결 뒤 후속 기록 생성·활성화·중복 제거·종결 담당
- `recovery_outcome_policy`: 현상 통제 대표 결과 담당
- `mastery evaluation`: 사전 저작된 사건별 숙련 조건만 담당
- `reward policy`: 캠페인 중립 보상만 담당

한 모듈이 다른 축의 결과를 소급 수정하지 않는다.

## 3. 데이터 모델

### 3.1 Follow-up record

```text
follow_up_id: String
source_obligation_id: String
source_status: String
source_reason: String
case_canon_reference: String
dedupe_key: String
accountable_owner: Dictionary
trigger_condition: Dictionary
actionable_reason: Dictionary
reentry_eligibility: Dictionary
resolution_state: String
step_index: int
step_limit: int
reward_claim_state: String
created_order: int
causal_history: Array[Dictionary]
legacy_provenance: Dictionary
```

`case_canon_reference`는 다음을 참조한다.

- `rescue_outcome_snapshot`
- 대표 회수 결과
- 사건 종결 당시 보호 의무 상태
- 관련 증거·기록·노출·안전 경로 상태

참조 대상은 불변이다. 후속 기록은 새 현재 상태와 인과만 추가한다.

### 3.2 Dedupe key

권장 키는 다음 의미 조합이다.

```text
case_id + source_obligation_id + normalized_source_reason + campaign_canon_id
```

- 동일 원인에는 하나의 활성 루트 후속 기록만 둔다.
- 사건 저작자가 다른 책임을 분리하려면 별도 `source_obligation_id` 또는 명시적 variant reason을 사용한다.
- 저장 재개, 장면 재입장, 결과 화면 재열기에서 같은 키를 다시 생성하지 않는다.

### 3.3 Resolution states

| 상태 | 의미 |
|---|---|
| `completed` | 후속 완료 조건 충족 |
| `mitigated` | 원래 손실은 남지만 추가 위험을 의미 있게 낮춤 |
| `transferred` | 자격·수단·수락 근거가 있는 책임 주체에게 인계 |
| `deferred_with_owner` | 책임 주체와 trigger가 있는 책임 있는 연기 |
| `accepted_residual_risk` | 더 진행할 실익이나 안전성이 없고 잔여 위험을 명시적으로 수용 |
| `closed_no_action` | 조사 결과 추가 행동이 불필요함을 근거와 함께 종결 |
| `escalated_once` | 상위 기관·전문팀에 한 번만 격상 |
| `failed_with_record` | 후속 실패와 잔여 책임을 기록한 종결 |

`escalated_once`는 새 무한 체인의 시작이 아니다. 격상 대상의 수락 또는 거부 결과로 같은 루트 안에서 종결한다.

## 4. 상태별 생성 규칙

### 4.1 Completed

`completed는 기본적으로 재작업을 요구하지 않는다`.

생성 가능:
- 사건이 명시한 기간 감시
- 기록 보존 확인
- 비필수 피해자 근황 확인
- 매뉴얼 부록 검증

생성 금지:
- 완료 의무를 반복 실행하는 보상 루프
- 같은 완료를 다시 S 랭크 조건으로 요구

### 4.2 Transferred

`transferred는 인계 수락과 책임 주체를 검증한다`.

필수:
- owner identity
- owner capability
- acceptance evidence
- follow-up condition

검증 실패 시:
- 원래 인계 시도와 당시 정보는 보존
- 새 현재 상태를 `unresolved` 또는 별도 owner-failure 후속으로 갱신
- 플레이어가 이미 수행한 합리적 인계 행위를 사후 정보로 자동 breach 처리하지 않음

### 4.3 Deferred with owner

`deferred_with_owner는 trigger_condition이 성립할 때만 활성화한다`.

trigger 예:
- 증상 악화
- 봉쇄 압력 임계 초과
- 감시 신호 재발
- 의료팀·전문 장비 준비 완료
- 법적 권한 확보

trigger 전에는 알림·감시 상태로 유지하고 활성 임무 슬롯을 차지하지 않는다.

### 4.4 Breached

`breached는 복구가 아니라 추가 피해 완화와 책임 이행을 다룬다`.

가능한 목표:
- 2차 노출 차단
- 유가족·피해자 지원
- 오염된 매개체 추적
- 손실 기록 복원
- 기관 책임 보고
- 재발 방지 규칙 추가

금지:
- 사망·상실을 되돌리는 허위 복구
- breach 발생 자체를 보상 생성 조건으로 사용
- 의도적 breach→완화 반복 파밍

### 4.5 Unresolved

`unresolved는 조용히 완료 처리하지 않는다`.

후속 후보 조건:
- actionable evidence가 있음
- 책임 대상이나 위험이 식별됨
- 현장·원격 중 하나의 실행 가능한 경로가 있음

후속 미생성 조건:
- 근거 부족
- 위험과 대상 모두 불명
- 현재 할 수 있는 행동이 없음

이 경우 `closed_no_action`이 아니라 감시·증거 대기 상태로 남기고, 새로운 정보가 들어왔을 때만 trigger로 활성화한다.

상태별 후속 의미는 다르며 자동으로 같은 후속 임무를 생성하지 않는다.

## 5. 재진입 설계

### 5.1 별도 평가

```text
reentry_eligibility = evaluate(
  actionable_reason,
  hazard_state,
  route_state,
  authority_state,
  capability_state
)
```

보호 의무 상태는 입력 중 하나의 근거일 뿐 결과 자체가 아니다. 재진입 자격과 보호 의무 상태를 같은 값으로 취급하지 않는다.

### 5.2 자격 결과

```text
eligible
eligible_with_conditions
not_eligible_use_alternative
not_actionable
unsafe_hold
```

- `eligible`: 현장 행동이 필요하고 안전·권한·수단 확보
- `eligible_with_conditions`: 특정 장비·지원·경로 확보 후 가능
- `not_eligible_use_alternative`: 비현장 대체 경로 사용
- `not_actionable`: 현재 정보로 현장 행동 가치 없음
- `unsafe_hold`: 위험이 높아 감시·봉쇄·지원 대기

재진입은 자동 생성하지 않는다. 플레이어가 재진입을 선택할 때 이유·위험·대체 경로를 표시한다.

### 5.3 대체 후속 경로

- 원격 센서 감시
- 자료·영상·기록 분석
- 의료·심리 지원 확인
- 외부 책임 기관의 수락 검증
- 매개체 이동 추적
- 공공 노출 차단
- 후속 위험 사례·매뉴얼 업데이트

재진입을 할 수 없다는 이유로 책임을 삭제하거나 핵심 캠페인을 막지 않는다.

## 6. 단계 상한과 실패 전진

각 후속 루트는 `step_limit`를 사건 데이터에 명시한다. 정확한 공통 숫자는 승인하지 않지만, 런타임은 무제한 증가를 허용하지 않는다.

- `step_index >= step_limit`이면 새 현장 단계를 만들지 않는다.
- 남은 책임은 `transferred`, `accepted_residual_risk`, `failed_with_record`, `closed_no_action` 중 근거 있는 종결로 이동한다.
- 같은 원인의 재진입 실패는 한 번의 `escalated_once`만 허용한다.
- 새 증거가 실제로 다른 책임을 만들면 별도 obligation과 dedupe key를 사용한다.

이 구조는 무한 재조사·무한 재진입을 차단하면서 사건의 잔여 위험은 지우지 않는다.

## 7. 평가 모델

### 7.1 평가 패킷

```text
control_axis
protection_responsibility_axis
evidence_integrity_axis
follow_up_execution_axis
mastery_axis
```

각 축은 다음 필드를 가진다.

```text
status
reasons
evidence_refs
excluded_higher_states
current_vs_incident_end
```

- 현상 통제 축: Decision 120 대표 결과
- 보호 책임 축: 종결 당시와 현재 의무 상태
- 증거·기록 무결성 축: 확보·손실·모순·매뉴얼 반영
- 후속 실행 축: 활성화된 책임에 대한 실행·완화·인계
- 숙련 평가 축: 사건별 사전 저작된 플레이 숙련 기준

단일 종합 점수는 사용하지 않는다. UI는 축별 이유와 제외된 상위 상태를 보여 준다.

### 7.2 원래 결과 보존

후속 결과는 다음 두 시점을 나란히 보존한다.

```text
incident_end_snapshot
current_follow_up_state
```

- 원래 breach는 계속 breach로 남는다.
- 이후 완화는 `mitigated after breach`로 기록한다.
- 피해자 상실은 되돌리지 않는다.
- 후속 실패가 원래 회수 대표 결과를 소급 강등하지 않는다.

## 8. 숙련과 랭크

숙련 상한 영향은 사건별 사전 저작 규칙으로만 허용한다.

```text
mastery_constraint_id
source_obligation_id
avoidable
severity
preview_rule
ceiling_effect
result_reason
```

허용 조건:
- 회피 가능하고 중대한 breach
- 플레이어가 판단할 수 있는 근거가 있었음
- 규칙이 사전 저작되고 표시 가능
- 결과 화면에서 근거 공개

자동 상한 금지:
- 유효한 transferred
- 책임 있는 deferred_with_owner
- 비회피적 상실
- 불충분한 정보
- 접근성 대체 입력
- 모든 단순 미완료 의무

정확한 랭크 임계값은 미승인이다. 사건별 숙련 상한은 핵심 엔딩·필수 동료·필수 세계관 진실·필수 장비를 잠그지 않는다.

## 9. 보상 모델

### 허용

- 사건 기록
- 표창
- 비필수 부록
- 코스메틱
- 사무실 전시품
- 매뉴얼 문서 테마
- 기록 재현 전용 변칙·도전 프리셋

### 금지

- 영구 능력치
- 필수 스킬
- 최고 성능 캠페인 장비
- 필수 기관 지원
- 필수 동료
- 핵심 엔딩
- 접근성·기본 편의 기능

기본 진행 보상을 박탈하지 않는다. 후속 성공 보상은 `reward_claim_state`와 `dedupe_key`로 1회 판정한다. 피해·위반을 반복 생성해 보상을 파밍하지 못하게 한다.

캠페인 정본 후속과 기록 재현 후속은 별도 namespace를 사용한다. 기록 재현 전용 보상은 캠페인 정본과 전력을 바꾸지 않는다.

## 10. 저장·마이그레이션

권장 저장 구조:

```text
protection_follow_up_records
protection_follow_up_history
protection_evaluation_packet
follow_up_reward_claims
```

원칙:
- 원자적 commit
- rollback-safe
- idempotent
- 같은 dedupe_key 중복 금지
- 같은 reward claim 중복 금지
- legacy provenance 보존
- 과거 bool에서 완료·breach·owner를 추정하지 않음

근거 부족 legacy 데이터는 `legacy_unknown_follow_up`로 유지한다.

## 11. 오류 처리

다음은 자동 보정하지 않고 검증 오류로 기록한다.

- source obligation 부재
- case canon reference 불일치
- owner가 필요한데 owner 없음
- trigger가 필요한데 trigger 없음
- step_limit 음수 또는 초과
- 동일 dedupe key의 복수 활성 루트
- 후속 성공이 원래 사건 결과를 변경하려는 패킷
- 캠페인 보상에 금지된 전력 항목 포함

오류 상태에서도 원본 사건 기록은 보존한다.

## 12. UI·접근성

결과와 후속 목록은 다음을 제공한다.

- 사건 종결 당시 상태와 현재 상태 비교
- 후속 발생 이유
- 책임 주체와 trigger
- 재진입 가능·조건부·부적격 이유
- 대체 후속 경로
- 평가 축별 이유
- 숙련 상한 근거
- 보상 1회 수령 상태

색·음향만으로 상태를 전달하지 않는다. 키보드·게임패드·스크린리더·시간 완화 사용은 평가·보상·재진입 자격 불이익 금지다.

## 13. 사람 검증 목표

- 후속 성공이 원래 피해를 지웠다고 오해하지 않는가
- 모든 미완료 상태가 강제 재진입이라고 느끼지 않는가
- 재진입 부적격 이유와 대체 경로를 이해하는가
- 다축 평가가 단일 성패보다 책임 인과를 잘 전달하는가
- breach 복구 파밍 동기가 생기지 않는가
- 후속 목록이 무한 업무처럼 느껴지지 않는가
- 접근성 사용자에게 동등한 정보와 결과가 제공되는가

실행 전까지 `HUMAN_QA_NOT_RUN`, `UI_ACCESSIBILITY_NOT_RUN`이다.

## 14. 구현 경계

현재 승인은 설계·감사·계약 테스트·구현 계획만 허용한다.

- runtime GDScript: 미변경
- Scene: 미변경
- Episode JSON: 미변경
- save schema: 미변경
- 정확한 수치·랭크 임계값·보상 목록: 미승인
- 구현: `IMPLEMENTATION_NOT_AUTHORIZED`
- 병합: `MERGE_NOT_AUTHORIZED`
