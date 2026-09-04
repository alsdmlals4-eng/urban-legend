# 보호 의무 후속 조사·재진입·보상·평가 연결 적대적 검토

> Decision ID: `DEC-20260806-123-CANON-V2-PROTECTION-OBLIGATION-FOLLOW-UP-REENTRY-REWARD-AND-EVALUATION-LINKAGE`
> 상태: `APPROVED_DESIGN_CONTRACT`
> 사용자 승인: 2026-08-06 10:48 KST
> GrillMe: Batch 3 `8_OF_10`
> 구현: `IMPLEMENTATION_NOT_AUTHORIZED`
> Human QA: `HUMAN_QA_NOT_RUN`
> UI·접근성 QA: `UI_ACCESSIBILITY_NOT_RUN`
> 병합: `MERGE_NOT_AUTHORIZED`
> Draft PR: #151 / 기반 PR: PR #149

## 1. 검토 질문

보호 의무의 `completed`, `transferred`, `deferred_with_owner`, `breached`, `unresolved`를 후속 조사·재진입·보상·평가에 연결할 때 다음 왜곡이 생길 수 있는가?

- 사건이 끝나지 않고 무한 업무로 늘어남
- 원래 피해가 후속 성공으로 삭제됨
- 피해나 breach를 일부러 만들어 보상을 파밍함
- 단일 평판 점수가 현상 통제와 보호 책임을 덮음
- 재진입이 자동 강제되거나 핵심 진행을 막음
- 접근성 사용자에게 불리한 평가가 생김

## 2. 검토 결론

권장안은 다음 분리를 유지할 때만 안전하다.

```text
incident-end canon
≠ current follow-up state
≠ reentry eligibility
≠ mastery evaluation
≠ reward claim
```

각 데이터는 출처를 공유하지만 서로 덮어쓰지 않는다. 후속 기록은 append-only이며 원래 구출 결과·회수 결과·보호 의무 이력을 덮어쓰지 않는다.

## 3. P0 위험

### P0-1. 원래 사건 결과 소급 삭제

공격 시나리오:
- 피해자 사망 또는 중대한 breach 발생
- 이후 짧은 후속 임무 완료
- 결과 패킷이 `completed` 하나로 합쳐져 원래 breach가 사라짐

차단:
- `case_canon_reference`로 incident-end snapshot 고정
- `incident_end_snapshot`과 `current_follow_up_state` 분리
- 후속 성공은 `mitigated after breach`로 기록
- `원래 breach를 성공으로 소급 변경하지 않는다`

### P0-2. 피해·위반 보상 파밍

공격 시나리오:
- 일부러 보호 의무 위반
- 복구 후 표창·보상 획득
- 기록 재현 또는 저장 재개로 반복

차단:
- `dedupe_key`와 `reward_claim_state` 1회 판정
- 의도적 breach 자체는 보상 생성 조건이 아님
- 캠페인 보상은 사건 기록·표창·비필수 부록·코스메틱·기록 재현 전용으로 제한
- 피해·위반을 반복 생성해 보상을 파밍 금지
- 사망이나 피해가 유리한 보상 경로가 되지 않는다

### P0-3. 무한 재조사·무한 재진입

공격 시나리오:
- unresolved가 새 follow-up 생성
- 실패가 새 unresolved 생성
- 매번 새 재진입 임무를 만들며 끝나지 않음

차단:
- 하나의 활성 루트 후속 기록
- 사건별 저작된 단계 상한
- `step_limit` 초과 시 새 현장 단계 금지
- `escalated_once`는 한 번만 허용
- `accepted_residual_risk`, `closed_no_action`, `failed_with_record` 종결 제공
- 핵심 캠페인 진행을 영구 차단하지 않는다

### P0-4. 자동 재진입과 소프트락

공격 시나리오:
- breached 또는 unresolved이면 자동으로 현장 복귀
- 안전 경로·권한·장비가 없어도 강제
- 다른 핵심 사건 진행 불가

차단:
- reentry_eligibility 별도 평가
- actionable_reason, hazard_state, route_state, authority_state, capability_state 요구
- 재진입은 자동 생성하지 않는다
- 부적격이면 대체 후속 경로 제공
- 재진입 자격과 보호 의무 상태를 같은 값으로 취급하지 않는다

## 4. P1 위험

### P1-1. 단일 종합 점수의 책임 은폐

문제:
- 회수 성공 + 보호 breach + 좋은 증거를 하나의 82점으로 합침
- 무엇이 잘못됐는지 알 수 없음

차단:
- 현상 통제 축
- 보호 책임 축
- 증거·기록 무결성 축
- 후속 실행 축
- 숙련 평가 축

단일 종합 점수는 사용하지 않고 축은 서로 덮어쓰지 않는다.

### P1-2. 모든 미완료 의무의 S 랭크 자동 차단

문제:
- 유효한 인계·책임 있는 연기·비회피적 손실까지 실패 취급
- 플레이어가 모든 책임을 직접 해결해야 하는 영웅 독점 구조

차단:
- 사건별 숙련 상한은 회피 가능하고 중대한 breach에만 허용
- 사전 저작과 사전 표시 필요
- 결과 화면에서 근거 공개
- 모든 미완료 의무가 자동으로 S 랭크를 차단하지 않는다
- 정확한 랭크 임계값은 미승인

### P1-3. 형식적 책임 이관

문제:
- owner 이름만 넣고 실제 수락·수단·후속 조건이 없음
- 책임을 문구로만 제거

차단:
- transferred는 인계 수락과 책임 주체를 검증한다
- accountable_owner, capability, acceptance evidence, follow-up condition 필수
- 결손 시 unresolved 유지

### P1-4. 연기 상태의 즉시 퀘스트화

문제:
- deferred_with_owner가 설정되자마자 활성 임무 생성
- trigger 의미가 사라짐

차단:
- deferred_with_owner는 trigger_condition이 성립할 때만 활성화한다
- trigger 전에는 감시·대기 상태
- 활성 임무 슬롯을 차지하지 않음

### P1-5. 완료 의무 재작업

문제:
- completed 상태를 매주 확인하게 함
- 콘텐츠 부피와 피로만 증가

차단:
- completed는 기본적으로 재작업을 요구하지 않는다
- 명시적 감시·기록 확인만 선택적 생성
- 동일 완료 반복 보상 금지

## 5. P2 위험

### P2-1. 후속 목록 과밀

문제:
- 작은 watch 의무까지 모두 개별 카드 생성
- 중요한 책임이 묻힘

완화:
- 상태별 후속 의미 구분
- actionable reason 없는 기록은 감시·대기 묶음으로 표시
- critical/urgent/watch 정렬은 Decision 122를 재사용
- 동일 원인 dedupe

### P2-2. 결과 화면 정보 과부하

문제:
- 다축 평가가 너무 많은 텍스트를 한 화면에 노출

완화:
- 헤드라인: incident end와 current follow-up 비교
- 축별 요약 후 근거 펼치기
- blocking·non-blocking·owner·trigger를 구조화
- 색·음향 단독 전달 금지

### P2-3. 비현장 경로의 하위 선택 인식

문제:
- 재진입만 진짜 콘텐츠처럼 보이고 원격 감시·자료 분석은 실패처럼 보임

완화:
- 재진입 자격과 책임 성과 분리
- 대체 후속 경로도 동등한 인과·평가 구조 사용
- 현장 복귀 여부가 보상이나 숙련의 자동 우위가 아님

## 6. 상태별 적대적 검증

### Completed

- 기본: 종료
- 예외: 저작된 감시·기록 확인
- 금지: 완료 반복 파밍

필수 문구: `completed는 기본적으로 재작업을 요구하지 않는다`.

### Transferred

- owner 실재성
- 수락 근거
- 수행 수단
- 후속 조건

필수 문구: `transferred는 인계 수락과 책임 주체를 검증한다`.

### Deferred with owner

- trigger가 성립하기 전 비활성
- owner 없는 연기는 unresolved

필수 문구: `deferred_with_owner는 trigger_condition이 성립할 때만 활성화한다`.

### Breached

- 원래 결과 보존
- 추가 피해 완화
- 책임 인정·지원·기록

필수 문구: `breached는 복구가 아니라 추가 피해 완화와 책임 이행을 다룬다`.

### Unresolved

- 무근거 완료 금지
- actionable reason 있을 때만 후속 후보

필수 문구: `unresolved는 조용히 완료 처리하지 않는다`.

상태들은 자동으로 같은 후속 임무를 생성하지 않는다.

## 7. 저장·마이그레이션 공격

### 중복 생성

- 결과 화면 재열기
- 저장 직후 로드
- 장면 이동
- 캠페인 재개

모두 같은 dedupe_key를 중복 생성하지 않는다.

### Legacy 허위 추정

기존 bool·단일 결과에서 다음을 추정하지 않는다.

- breach
- completed
- owner
- trigger
- reentry eligibility
- mastery ceiling

legacy provenance를 보존하고 `legacy_unknown_follow_up`로 둔다. 과거 저장에서 breach나 완료를 추정하지 않는다.

### 원자성

follow-up 생성, 평가, reward claim은 원자적·rollback-safe·idempotent해야 한다. 일부만 저장되면 전체 트랜잭션을 복구 전 상태로 되돌린다.

## 8. 보상 적대적 검토

기존 `D-2026-08-03-MASTERY-REWARD-SCOPE-AND-CAMPAIGN-NEUTRALITY`와 충돌하지 않아야 한다.

허용:
- 사건 기록
- 표창
- 비필수 부록
- 코스메틱
- 전시품
- 기록 재현 전용 도전

금지:
- 영구 능력치
- 필수 스킬
- 최고 성능 캠페인 장비
- 필수 기관 지원
- 필수 동료
- 핵심 엔딩
- 필수 세계관 진실
- 접근성 기능

후속 미완료로 기본 진행 보상을 박탈하지 않는다. 보상은 캠페인 필수 전력과 분리한다.

## 9. 접근성 적대적 검토

접근성 대체 입력과 시간 완화는 다음에 영향을 주지 않는다.

- follow-up activation
- reentry eligibility
- mastery ceiling
- reward claim
- evaluation axis

평가·보상·재진입 자격 불이익 금지다. 화면은 키보드·게임패드·스크린리더로 같은 원인·owner·trigger·대체 경로를 확인할 수 있어야 한다.

## 10. 검증 매트릭스

| 사례 | 기대 결과 |
|---|---|
| completed + 감시 저작 없음 | 후속 루트 미생성 |
| transferred + 유효 owner | owner 확인 또는 종료, 플레이어 재작업 강제 없음 |
| transferred + owner 수락 근거 없음 | unresolved 유지 |
| deferred + trigger 미성립 | 비활성 감시 상태 |
| breached + 후속 완화 성공 | 원래 breach 보존 + mitigated 이력 |
| unresolved + actionable reason 없음 | 자동 재진입 없음 |
| unresolved + 안전·권한·수단 있음 | 재진입 후보 표시 |
| 재진입 부적격 | 대체 후속 경로 표시 |
| step limit 도달 | 새 현장 단계 금지 + 책임 있는 종결 |
| 같은 저장 재개 두 번 | follow-up·reward 중복 없음 |
| 기록 재현 후속 성공 | 활성 캠페인 정본 미변경 |
| 접근성 시간 완화 사용 | 평가·보상·자격 동일 |

## 11. 남은 미확정

- 사건별 단계 상한
- 재진입 비용·기간·지원 수치
- 후속 UI 배치
- 사건별 숙련 상한 데이터
- 실제 보상 목록
- Human QA 표본과 기준

이 항목들은 구현 승인 전까지 미확정이며 현재 runtime·Scene·Episode JSON·save schema는 변경하지 않는다.

## 12. 최종 판정

`APPROVED_DESIGN_WITH_BOUNDED_APPEND_ONLY_FOLLOW_UP_AND_CAMPAIGN_NEUTRAL_REWARD_LINKAGE`

차단된 핵심 위험:

- 원래 사건 결과 소급 삭제
- 피해·위반 보상 파밍
- 자동 재진입
- 무한 재조사·무한 재진입
- 단일 종합 점수
- 영구 캠페인 차단
- 형식적 인계
- 숨은 숙련 상한
- legacy 허위 추정
- 접근성 불이익

구현·Human QA·UI 접근성 QA·병합은 각각 `IMPLEMENTATION_NOT_AUTHORIZED`, `HUMAN_QA_NOT_RUN`, `UI_ACCESSIBILITY_NOT_RUN`, `MERGE_NOT_AUTHORIZED`다.
