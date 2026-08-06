# Canon v2 회수 결과 상태·독립 결과 패킷 설계

> Decision ID: `DEC-20260806-120-CANON-V2-RECOVERY-OUTCOME-STATES-AND-INDEPENDENT-RESULT-PACKET`
> 상태: `APPROVED_DESIGN_CONTRACT / GRILLME_BATCH_3_5_OF_10`
> 사용자 승인: 2026-08-06 06:46 KST — `권장안대로 진행`
> 구현: `IMPLEMENTATION_NOT_AUTHORIZED`
> Human QA: `HUMAN_QA_NOT_RUN`
> UI·접근성 QA: `UI_ACCESSIBILITY_NOT_RUN`
> 병합: `MERGE_NOT_AUTHORIZED`
> 기반 Draft PR: PR #149
> 현재 Draft PR: PR #151

## 1. 설계 목표

현행 `core_recovered` 단일 종결을 다음 구조로 전환할 수 있는 구현 명세를 만든다.

```text
회수 페이즈 상태
→ 가능한 종결 후보 계산
→ 대표 회수 결과 선택
→ 독립 결과 패킷 구성
→ 구출 결과와 나란히 사건 보고서 저장
→ 보상·후속 분기 계산
```

이 설계는 회수 패턴 선택과 전조·가설·근거·대응·즉시 판정 구조를 바꾸지 않는다. Decision 119가 정의한 패턴 판단 이력을 종결 판정의 근거로 소비한다.

## 2. 핵심 설계 선택

### 선택 A — 점수 하나로 등급화

안정도·피해·증거를 한 점수로 합산해 S/A/B/C/실패를 정한다.

- 장점: 구현과 결과 화면이 단순하다.
- 치명적 단점: 승인 철수와 통제 실패, 긴급 봉쇄와 완전 봉쇄, 피해자와 현상 통제를 구분하지 못한다.
- 판정: 기각.

### 선택 B — 모든 결과를 축으로만 표시

대표 결과 없이 모든 축을 독립 상태로만 표시한다.

- 장점: 정보 손실이 가장 적다.
- 단점: 플레이어가 현상을 어디까지 통제했는지 즉시 이해하기 어렵다.
- 판정: 보조 구조로 사용하지만 단독 구조로는 기각.

### 선택 C — 대표 회수 결과 + 독립 결과 패킷

- 대표 회수 결과는 현상 통제 수준을 설명한다.
- 독립 결과 패킷은 사람·의무·손실·증거·후속 책임을 보존한다.
- 두 층은 서로를 덮어쓰지 않는다.
- 판정: 승인안.

## 3. 대표 결과 카탈로그

| ID | 표시 | 클래스 | 통제 의미 |
|---|---|---|---|
| `residue_recovered` | 잔향 회수 완료 | `FULL_SUCCESS` | 현상·확산 경로 통제와 잔향 확보를 모두 달성 |
| `containment_complete` | 봉쇄 완료 | `CONTROL_SUCCESS` | 지속 가능한 봉쇄를 달성했으나 잔향 미회수 |
| `stabilization_complete` | 안정화 완료 | `PROVISIONAL_SUCCESS` | 현재 발현은 멈췄으나 근원·경로 미봉쇄 |
| `emergency_containment` | 긴급 봉쇄 | `PARTIAL_SUCCESS` | 참사는 막았으나 봉쇄가 임시적이고 잔여 위험이 높음 |
| `approved_withdrawal` | 승인 철수 | `STRATEGIC_EXIT` | 통제 붕괴 전에 책임 조건을 갖추고 의도적으로 종료 |
| `control_failure` | 통제 실패 | `FAILURE` | 통제·안전 종결·승인 철수 어느 것도 성립하지 않음 |

**긴급 봉쇄는 부분 성공**이며, **승인 철수는 실패가 아니다**.

## 4. 종결 후보 판정 순서

대표 결과는 높은 등급부터 단순 점수 비교로 고르지 않는다. 각 상태의 의미 조건을 확인한다.

```text
1. 잔향 확보와 지속 통제 조건 확인
2. 지속 봉쇄 조건 확인
3. 현재 발현 안정화 조건 확인
4. 임시 비상 봉쇄 조건 확인
5. 승인 철수 자격 확인
6. 어느 조건도 아니면 통제 실패
```

이 순서는 상위 의미가 성립하면 하위 의미를 선택하지 않도록 하는 판정 순서다. 수치가 높은 상태를 자동으로 상위 결과로 만드는 점수 순위가 아니다.

### 4.1 residue_recovered

- 현상 비활성 또는 통제 상태
- 활성 확산 경로 봉쇄
- 사건 규칙에 맞는 잔향·매개체 확보
- 회수 대상이 오염·위조·잘못된 표본이 아님

### 4.2 containment_complete

- 현상과 확산 경로가 지속 봉쇄
- 즉시 외부 확산 가능성 없음
- 잔향 미회수 또는 안전상 격리

### 4.3 stabilization_complete

- 현재 발현과 즉시 위험 정지
- 현장 이탈·민간 보호 가능
- 근원 또는 확산 경로가 미봉쇄

### 4.4 emergency_containment

- 임계 확산 또는 참사 방지
- 임시·손상·시간 제한 봉쇄
- 높은 잔여 위험 또는 미완료 보호 의무

### 4.5 approved_withdrawal

승인 철수 자격은 다음을 모두 요구한다.

- **안전 철수 경로** 또는 사건 규칙에 맞는 철수 절차
- 지식·자원·보호·봉쇄 창구에 대한 **철수 근거**
- **보호 대상과 중요 기록의 상태** 확인
- **통제 붕괴 전에 의도적으로 종료**
- 재진입·감시·지원 요청을 포함한 후속 책임

승인 조건을 충족하지 못한 강제 퇴각은 `control_failure`다.

### 4.6 control_failure

- 현상이 통제 밖으로 이탈·확산
- 안전 종결이 성립하지 않음
- 현장 붕괴로 강제 퇴각
- 승인 철수 책임 조건 미충족

## 5. 독립 결과 패킷 구조

개념 구조는 다음과 같다. 실제 키 이름과 schema version은 구현 승인 후 확정한다.

```gdscript
{
    "representative_outcome": {
        "id": "containment_complete",
        "label": "봉쇄 완료",
        "class": "CONTROL_SUCCESS",
        "reason_codes": [],
        "excluded_higher_outcomes": []
    },
    "victim_outcome": {},
    "protection_obligations": {},
    "personnel_and_equipment": {},
    "site_and_public_exposure": {},
    "evidence_and_records": {},
    "follow_up_obligations": {},
    "causal_history": []
}
```

### 5.1 대표 회수 결과

- 상태 ID·표시명·클래스
- 선택된 이유
- 성립하지 않은 상위 결과와 이유
- 종결을 발생시킨 행동·패턴·현장 조건

### 5.2 피해자 생존·분리·후유증

- 생존·실종·사망·불명 상태
- 괴이·매개체·경로에서 분리된 정도
- 부상·기억 손상·오염·사회적 후유증
- 비가역 결과와 재구출 가능성

### 5.3 보호 의무

- 구출에서 인계된 의무
- 회수 중 이행·부분 이행·위반
- 남은 대피·치료·감시·격리 책임

### 5.4 요원 피해와 장비 손실

- 요원별 체력·정신·오염·행동 불능
- 소모품 사용·영구 장비 파손·회수 불가
- 복귀 제한·치료·휴식 요구

### 5.5 현장·매개체·공공 노출

- 현장 보존·손상·붕괴
- 매개체 확보·봉쇄·소실
- 민간·세력·언론·기록망 노출
- 확산 경로와 2차 피해

### 5.6 잔향·증거·기록 확보

- 잔향·표본·매개체 확보
- 공식 증거·후보 증거·위험 사례
- 괴이 매뉴얼 공식 규칙·검증 대기 후보
- 손실·오염·위조된 기록

### 5.7 후속 조사·재진입·감시

- 재진입 요구와 금지 조건
- 감시 수준과 기간 의미
- 추가 인력·장비·세력 지원
- 피해자 치료·봉쇄 보강·비상 대응

### 5.8 판정 근거와 인과 이력

- 적용한 규칙·근거·대응
- 패턴별 정오·피해·위험 사례
- 종결 상태 선택 이유
- 보상·후속 분기 입력

각 축은 **단일 총점으로 덮어쓰지 않는다**.

## 6. 구출·회수 독립성

- **구출 실패가 회수 실패를 자동으로 만들지 않는다**.
- **회수 성공이 피해자 구출 성공을 자동으로 만들지 않는다**.
- **회수 실패나 승인 철수가 이미 구출한 피해자를 소급 삭제하지 않는다**.
- 피해자 상실은 작전 평가와 후속 책임에 강하게 반영되지만 대표 회수 결과를 임의 변경하지 않는다.
- 잔향 회수 완료는 보호 의무 위반·요원 손실·현장 붕괴를 숨기는 전체 성공 배너가 아니다.

결과 화면은 **피해자 결과와 회수 결과를 동등한 헤드라인**으로 보여 주며 **단일 임무 성공/실패 배너 금지**를 적용한다.

## 7. 구형 호환 설계

현행 상태:

```text
core_recovered
recovery_successful: bool
capture_success
capture_result_state
capture_result_stability
```

판정:

- `core_recovered`: `LEGACY_SINGLE_OUTCOME`
- `recovery_successful`·`capture_success`: `LEGACY_COMPAT_ONLY`
- **대표 결과 상태가 권위**다.
- `bool만으로 승인 철수와 통제 실패를 구분하지 않는다`.

권장 호환 파생:

| 새 결과 | 구형 recovery_successful 파생 | 주의 |
|---|---:|---|
| `residue_recovered` | true | 완전 회수 의미 |
| `containment_complete` | true | 잔향 회수 보상과 구분 |
| `stabilization_complete` | true | 조건부 성공·후속 의무 유지 |
| `emergency_containment` | true | 부분 성공이며 완전 성공 보상 금지 |
| `approved_withdrawal` | false | 실패 문구·실패 분기로 직행 금지 |
| `control_failure` | false | 실제 실패 |

구형 bool은 오래된 저장·테스트·보상 어댑터에만 사용한다. 신규 제품 분기는 항상 대표 결과 ID와 클래스를 먼저 읽는다.

### 구형 core_recovered 마이그레이션

- 기존 저장에 잔향 확보와 현상 통제 증거가 모두 있으면 `residue_recovered` 후보로 이관한다.
- 증거가 부족하면 `legacy_core_recovered` 원본 의미를 보존하고 자동으로 완전 성공을 추정하지 않는다.
- 원본 필드와 이관 근거를 provenance에 남긴다.
- save migration은 원자성·rollback·idempotency 테스트를 요구한다.

## 8. 결과 화면 정보 구조

### 헤드라인 영역

- 피해자 결과 카드
- 회수 결과 카드
- 두 카드는 같은 시각 계층과 같은 정보 우선순위를 가진다.

### 책임·손실 영역

- 보호 의무
- 요원 피해·장비 손실
- 현장·매개체·공공 노출

### 증거·인과 영역

- 잔향·증거·기록
- 공식 규칙·후보 규칙·위험 사례
- 대표 결과 판정 이유와 제외된 상위 결과

### 후속 영역

- 재진입·감시·치료·봉쇄 보강
- 보상과 다음 사건 분기

승인 철수는 `전략적 종료`, 긴급 봉쇄는 `부분 성공`, 통제 실패는 `통제 실패`로 명시한다. 색상만으로 구분하지 않는다.

## 9. 현재 구현 접점

### battle_scene.gd

현재 `_recover_anomaly_core()`가 안정도 기준 뒤 `save_recovery_result(true, "core_recovered", ...)`를 호출한다.

후속 구현은 다음 책임으로 분리한다.

- 종결 행동 요청
- 회수 종결 후보 상태 수집
- 결과 정책 평가 호출
- 결과 패킷 저장
- 결과 화면 전환

### game_state.gd

현재 저장 필드는 `recovery_successful`, `recovery_result_status`, `recovery_result_stability`다.

후속 구현은 다음을 추가한다.

- 대표 결과 상태
- 독립 결과 패킷
- 호환 bool 파생
- save migration
- 사건 보고서 스냅샷

### result_scene.gd

현재 피해자 문구와 회수 상태를 표시하지만 구조화된 다중 축을 소비하지 않는다.

후속 구현은 다음을 표시한다.

- 피해자·회수 동등 헤드라인
- 책임·손실·증거·후속 의무
- 판정 이유와 제외된 상위 결과
- 승인 철수와 통제 실패의 명확한 구분

## 10. 오류·예외 처리

- 대표 결과 ID가 없으면 조용히 `core_recovered`로 보정하지 않는다.
- 판정 입력이 불완전하면 `outcome_evaluation_incomplete` 같은 명시적 오류 상태를 기록하고 결과 확정을 중단한다.
- 승인 철수 조건 일부가 누락되면 `approved_withdrawal`을 만들지 않는다.
- 구형 저장 이관 실패 시 원본 저장을 유지하고 rollback한다.
- 사건 데이터가 상위 결과 조건을 제공하지 않으면 공용 의미 조건과 명시적 사건 fallback을 사용하며 숨은 난수로 결정하지 않는다.

## 11. 검증 전략

### 자동 계약

- 6종 대표 결과와 클래스 매핑
- 승인 철수 자격과 강제 퇴각 구분
- 긴급 봉쇄 부분 성공
- 구출·회수 결과 비덮어쓰기
- 결과 패킷 저장·불러오기
- 구형 bool 호환과 status-first 분기
- core_recovered migration 원자성·idempotency
- 결과 화면의 독립 헤드라인과 접근성 텍스트

### Human QA

- 승인 철수가 실패 회피 꼼수로 인식되는지
- 긴급 봉쇄와 봉쇄 완료가 구분되는지
- 피해자 결과와 회수 결과 중 하나가 다른 하나를 가리는지
- 결과 패킷의 정보량이 과도한지
- 색·음향 없이 결과 차이를 이해할 수 있는지

현재는 `HUMAN_QA_NOT_RUN / UI_ACCESSIBILITY_NOT_RUN`이다.

## 12. 범위 경계

이번 승인에 포함:

- 대표 결과 6종과 의미 경계
- 독립 결과 패킷의 책임 축
- 승인 철수·긴급 봉쇄·통제 실패 구분
- 구형 bool 비권위화와 마이그레이션 원칙
- 결과 화면·보고서 정보 구조
- 구현 계획 작성

이번 승인에 미포함:

- runtime·Scene·Episode JSON·save schema 실제 수정
- 수치 임계값과 보상량
- 사건별 최종 조건·문구
- Human QA 실행
- PR 병합

최종 상태는 `IMPLEMENTATION_NOT_AUTHORIZED / HUMAN_QA_NOT_RUN / UI_ACCESSIBILITY_NOT_RUN / BATCH_MERGE_NOT_STARTED / MERGE_NOT_AUTHORIZED`다.

## 13. 다음 기획 게이트

다음 GrillMe 6/10은 `DEC-20260806-120-CANON-V2-RECOVERY-OUTCOME-STATES-AND-INDEPENDENT-RESULT-PACKET`을 바탕으로 구출 결과 패킷이 회수 초기 조건·보호 의무·행동 제약으로 전달되는 규칙을 승인한다.
