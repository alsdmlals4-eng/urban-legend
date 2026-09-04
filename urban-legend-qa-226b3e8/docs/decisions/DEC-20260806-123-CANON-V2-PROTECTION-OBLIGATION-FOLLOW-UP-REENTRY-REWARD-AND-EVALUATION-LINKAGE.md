# DEC-20260806-123-CANON-V2-PROTECTION-OBLIGATION-FOLLOW-UP-REENTRY-REWARD-AND-EVALUATION-LINKAGE

> 상태: `APPROVED_DESIGN_CONTRACT`
> 사용자 승인: 2026-08-06 10:48 KST — `권장안대로 진행`
> GrillMe: Batch 3 `8_OF_10`
> 적용 범위: 보호 의무 상태의 후속 조사·재진입·보상·평가 연결과 그 상한
> 선행 Decision: `DEC-20260806-120-CANON-V2-RECOVERY-OUTCOME-STATES-AND-INDEPENDENT-RESULT-PACKET`, `DEC-20260806-121-CANON-V2-RESCUE-RESULT-HANDOFF-TO-RECOVERY-INITIAL-CONDITIONS-AND-ACTION-CONSTRAINTS`, `DEC-20260806-122-CANON-V2-PROTECTION-OBLIGATION-COST-PRIORITY-AND-RECOVERY-TERMINATION-ELIGIBILITY`
> 관련 기존 결정: `D-2026-08-03-MASTERY-REWARD-SCOPE-AND-CAMPAIGN-NEUTRALITY`
> 철회 이력: `DEC-20260806-118-CANON-V2-FOUR-TURN-TELEGRAPH-PATTERN-CYCLE`는 `RETRACTED / NON_COUNTING`
> Draft PR: #151
> 기반 PR: PR #149
> 구현: `IMPLEMENTATION_NOT_AUTHORIZED`
> 사람 검증: `HUMAN_QA_NOT_RUN`
> UI·접근성 검증: `UI_ACCESSIBILITY_NOT_RUN`
> 배치 병합: `BATCH_MERGE_NOT_STARTED`
> 병합: `MERGE_NOT_AUTHORIZED`

## 1. 결정

보호 의무의 `completed`, `transferred`, `deferred_with_owner`, `breached`, `unresolved` 상태는 사건 종결 뒤의 책임을 설명하고 필요한 후속 작업을 생성할 수 있다. 그러나 상태 하나를 단일 평판 점수나 자동 재진입 명령, 영구 캠페인 페널티, 보상 파밍 장치로 사용하지 않는다.

권장 흐름은 다음과 같다.

```text
protection obligation terminal/current state
→ 상태별 후속 의미 해석
→ 추적 가능한 follow-up record 생성 또는 종료
→ 재진입 자격을 별도 평가
→ 후속 실행과 결과를 append-only 기록
→ 현상 통제·보호 책임·증거 무결성·후속 실행·숙련 평가를 분리 보고
→ 캠페인 중립 보상 또는 후속 책임으로 연결
```

핵심 원칙은 다음과 같다.

1. 상태별 후속 의미를 구분한다.
2. 모든 상태가 자동으로 같은 후속 임무를 생성하지 않는다.
3. 후속 기록은 원래 사건의 사실과 결과를 덮어쓰지 않는 `append-only` 이력이다.
4. 재진입 자격과 보호 의무 상태를 같은 값으로 취급하지 않는다.
5. 후속 조사와 재진입은 저작된 범위 안에서 끝나며 무한 재작업을 만들지 않는다.
6. 평가와 보상은 캠페인 필수 전력과 분리하고 피해·위반 파밍을 금지한다.

## 2. 후속 기록 계약

후속 작업은 다음 최소 구조를 가진다.

```text
follow_up_id
source_obligation_id
source_status
source_reason
case_canon_reference
dedupe_key
accountable_owner
trigger_condition
actionable_reason
reentry_eligibility
resolution_state
causal_history
```

- `follow_up_id`: 후속 기록의 안정 ID
- `source_obligation_id`: 원인이 된 보호 의무
- `source_status`: 생성 시점의 `completed`·`transferred`·`deferred_with_owner`·`breached`·`unresolved`
- `source_reason`: 인명·매개체·기록·노출·안전 경로 등 후속 필요의 인과 근거
- `case_canon_reference`: 원래 구출·회수 결과 패킷과 보호 이력을 가리키는 불변 참조
- `dedupe_key`: 같은 원인에서 중복 루트 기록이 생성되는 것을 막는 키
- `accountable_owner`: 기록국 팀·의료기관·지원팀·외부 기관 등 실제 책임 주체
- `trigger_condition`: 연기된 후속이 활성화되는 조건
- `actionable_reason`: 지금 조사·지원·재진입을 수행할 실질 이유
- `reentry_eligibility`: 재진입 가능 여부의 별도 판정 패킷
- `resolution_state`: 후속 기록의 현재 종결 상태
- `causal_history`: 생성·인계·활성화·실행·완화·실패·종결의 인과 이력

후속 기록은 `원래 구출 결과·회수 결과·보호 의무 이력을 덮어쓰지 않는다`. 후속 성공은 원래 `breached`를 성공으로 소급 변경하지 않는다. 대신 추가 피해 방지, 책임 수행, 현재 상태 개선을 새 이력으로 남긴다.

## 3. 상태별 후속 의미

### `completed`

- `completed는 기본적으로 재작업을 요구하지 않는다`.
- 사건이 저작한 감시 기간, 기록 보존 확인, 비필수 후일담이 있을 때만 선택적 확인 기록을 만들 수 있다.
- 이미 완료된 의무를 반복 수행해 보상을 얻는 루프를 금지한다.

### `transferred`

- `transferred는 인계 수락과 책임 주체를 검증한다`.
- `accountable_owner`, 수락 근거, 보유 수단, 후속 조건이 모두 있어야 한다.
- 플레이어가 인계한 책임을 같은 사건에서 다시 전부 수행하도록 강제하지 않는다.
- 인계 실패가 확인되면 원래 인계 사실은 보존하고 별도 후속 기록으로 상태를 갱신한다.

### `deferred_with_owner`

- `deferred_with_owner는 trigger_condition이 성립할 때만 활성화한다`.
- 기한·증상 악화·노출 재발·지원팀 준비 완료처럼 저작된 조건이 성립하지 않으면 활성 임무로 표시하지 않는다.
- 책임 주체와 조건이 없는 형식적 연기는 `unresolved`로 남긴다.

### `breached`

- `breached는 복구가 아니라 추가 피해 완화와 책임 이행을 다룬다`.
- 사망·오염·노출·기록 손실 등 이미 일어난 결과를 되돌리지 않는다.
- 후속 성공은 잔여 피해 감소, 추가 노출 차단, 기록 보존, 책임 인정, 지원 제공을 기록한다.
- `사망이나 피해가 유리한 보상 경로가 되지 않는다`.

### `unresolved`

- `unresolved는 조용히 완료 처리하지 않는다`.
- 후속 책임, 미확인 대상, 자료 부족, 인계 실패 이유를 결과 패킷과 후속 목록에 남긴다.
- 실행 가능한 근거가 있으면 후속 조사 후보가 되지만, 모든 미해결 의무가 즉시 재진입 임무가 되는 것은 아니다.

상태별 후속 의미는 다르며 `자동으로 같은 후속 임무를 생성하지 않는다`.

## 4. 후속 작업의 상한과 종결

하나의 `source_obligation_id + source_reason` 조합에는 `dedupe_key` 기준으로 **하나의 활성 루트 후속 기록**만 허용한다.

각 사건은 후속 작업에 다음을 저작한다.

- 허용 단계와 `저작된 단계 상한`
- 활성화 조건
- 대체 후속 경로
- 성공·부분 완화·실패·책임 이관·잔여 위험 수용의 종결 조건
- 재진입이 불가능하거나 부적절할 때의 비현장 처리 경로

대표 `resolution_state`는 다음을 포함한다.

- `completed`
- `mitigated`
- `transferred`
- `deferred_with_owner`
- `accepted_residual_risk`
- `closed_no_action`
- `escalated_once`
- `failed_with_record`

동일 원인에서 `escalated_once` 뒤에 다시 무한 단계가 생성되지 않는다. 후속 실패는 기록된 잔여 위험, 다른 책임 주체로의 인계, `accepted_residual_risk`, `closed_no_action` 중 사건에 맞는 종결을 제공한다.

`무한 재조사`와 `무한 재진입`을 금지한다. 후속 상태는 핵심 캠페인 진행을 영구 차단하지 않는다. 필요한 세계관 정보, 필수 동료, 핵심 엔딩, 다음 핵심 사건은 후속 의무 완벽 달성을 요구하지 않는다.

## 5. 재진입 자격

`reentry_eligibility`는 보호 의무 상태에서 직접 복사하지 않고 다음을 별도 평가한다.

```text
eligible
actionable_reason
hazard_state
route_state
authority_state
capability_state
blocking_reasons
alternative_follow_up
```

- `actionable_reason`: 현장에 다시 들어가야만 해결 가능한 현재 이유
- `hazard_state`: 현장 위험과 재발 상태
- `route_state`: 안전 진입·철수 경로
- `authority_state`: 기록국 또는 협력 기관의 법적·조직적 승인
- `capability_state`: 필요한 인력·장비·정보·지원 확보 여부

`재진입은 자동 생성하지 않는다`. `completed`, `transferred`, `deferred_with_owner`, `breached`, `unresolved` 중 어느 상태도 단독으로 재진입을 확정하지 않는다.

재진입이 부적격이면 원격 감시, 자료 분석, 책임 기관 확인, 의료·심리 지원, 매개체 추적, 기록 보존 같은 `대체 후속 경로`를 제시한다. 재진입 부적격은 후속 책임 삭제를 뜻하지 않는다.

## 6. 다축 평가

사건 종결과 후속 결과는 다음 축을 분리한다.

1. `현상 통제 축`: 회수 대표 결과와 잔여 위험
2. `보호 책임 축`: 완료·유효 인계·책임 있는 연기·위반·미해결
3. `증거·기록 무결성 축`: 매뉴얼·증거·기록·위험 사례의 보존 품질
4. `후속 실행 축`: 활성 후속을 얼마나 책임 있게 실행·완화·인계했는가
5. `숙련 평가 축`: 사건별 사전 저작 조건에 따른 대응 숙련도

이 축들을 `단일 종합 점수`로 합쳐 원인을 숨기지 않는다. 각 축은 서로 덮어쓰지 않는다. 현상 통제 성공은 보호 위반을 지우지 않고, 후속 성공은 원래 breach를 성공으로 소급 변경하지 않는다.

결과 화면과 보고서는 다음을 함께 보여 준다.

- 원래 사건 종결 당시 상태
- 현재 후속 상태
- 개선되거나 악화된 항목과 원인
- 책임 주체와 다음 조건
- 사건별 숙련 평가에 영향을 준 저작 규칙

## 7. 숙련 평가 영향의 상한

보호 의무는 사건별 숙련 평가에 영향을 줄 수 있으나 다음 조건을 모두 요구한다.

- `회피 가능하고 중대한 breach` 또는 사건이 명시한 핵심 보호 책임이어야 한다.
- 사건 데이터에 `사전 저작`되어야 한다.
- 행동 전 또는 결과 조건 안내에서 평가 가능성을 알 수 있어야 한다.
- `결과 화면에서 근거 공개`가 되어야 한다.
- 현재 캠페인 정본과 기록 재현 결과를 구분해야 한다.

이 조건을 충족한 경우에만 `사건별 숙련 상한`을 제한할 수 있다. 그러나 `모든 미완료 의무가 자동으로 S 랭크를 차단하지 않는다`. 유효한 `transferred`, `deferred_with_owner`, 비회피적 손실, 정보 부족으로 판정할 수 없었던 결과는 자동 실패로 취급하지 않는다.

`정확한 랭크 임계값은 미승인`이다. 사건별 수치·등급 상한·치명적 조건은 구현 승인과 별도 밸런싱 뒤 정한다.

숙련 평가는 핵심 엔딩·필수 동료·필수 세계관 진실을 잠그지 않는다.

## 8. 보상 연결과 캠페인 중립성

후속 조사·책임 이행 보상은 기존 숙련 보상 원칙에 따라 `캠페인 필수 전력과 분리`한다.

허용 가능한 보상 예시는 다음과 같다.

- 사건 기록과 후속 보고서
- 비전투 `표창`
- 비필수 부록
- 코스메틱과 사무실 전시품
- 매뉴얼 문서 테마
- `기록 재현 전용` 도전 프리셋이나 변칙

후속 미완료나 위반만을 이유로 `기본 진행 보상을 박탈하지 않는다`. 영구 능력치, 필수 스킬, 최고 성능 캠페인 장비, 필수 기관 지원, 필수 동료, 핵심 엔딩, 접근성 기능은 후속 완벽 달성 보상으로 잠그지 않는다.

`피해·위반을 반복 생성해 보상을 파밍`하는 구조를 금지한다. 같은 `dedupe_key`와 사건 정본에서는 후속 보상을 한 번만 판정한다. `completed` 의무 반복 확인, 일부러 발생시킨 breach의 복구 반복, 기록 재현 결과로 캠페인 정본을 덮어쓰는 방식은 보상을 생성하지 않는다.

## 9. 저장·이관·접근성

후속 기록과 평가 이력은 저장·불러오기에서 원자적·rollback-safe·idempotent해야 한다.

- 같은 `dedupe_key를 중복 생성하지 않는다`.
- 같은 후속 보상과 평가 이벤트를 두 번 적용하지 않는다.
- 원래 사건 결과, 보호 의무 상태, 후속 현재 상태를 분리 저장한다.
- legacy 저장은 `legacy provenance`를 보존한다.
- `과거 저장에서 breach나 완료를 추정하지 않는다`.
- 근거가 부족하면 `legacy_unknown_follow_up`로 남기고 임의의 후속 임무나 평가 상한을 만들지 않는다.

`접근성 대체 입력과 시간 완화`는 후속 실행의 책임·결과를 대신하지 않는 한 동등하다. 접근성 사용을 이유로 평가·보상·재진입 자격 불이익 금지를 적용한다.

## 10. 금지 사항

- 보호 의무 상태를 단일 평판·도덕 점수로 축소
- 모든 미해결 의무의 자동 재진입 변환
- 후속 성공으로 원래 사망·위반·통제 실패 소급 삭제
- 같은 원인의 무한 후속·무한 재진입
- 후속 완벽 달성으로 필수 캠페인 콘텐츠 잠금
- 피해자 손실·위반·재복구를 이용한 보상 파밍
- 기록 재현 결과로 활성 캠페인 정본 변경
- 숨은 숙련 상한과 사후 규칙 추가
- 접근성 사용에 대한 평가·보상·자격 불이익

## 11. 열린 범위

다음은 이 승인에 포함되지 않는다.

- 사건별 정확한 후속 단계 수와 시간
- 재진입 자원·비용·쿨다운 수치
- 사건별 `actionable_reason`과 권한 주체
- 정확한 랭크 임계값과 S 랭크 상한 조건
- 실제 보상 목록과 제작 수량
- runtime·UI·save schema 구현
- 사건별 Episode JSON 저작
- Human QA와 접근성 플레이테스트

## 12. 검증 상태

- 기획 계약: `APPROVED_DESIGN_CONTRACT`
- 구현: `IMPLEMENTATION_NOT_AUTHORIZED`
- 사람 검증: `HUMAN_QA_NOT_RUN`
- UI·접근성 검증: `UI_ACCESSIBILITY_NOT_RUN`
- 배치 병합: `BATCH_MERGE_NOT_STARTED`
- 병합: `MERGE_NOT_AUTHORIZED`
