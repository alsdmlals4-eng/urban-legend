# 회수 결과 상태·독립 결과 패킷 적대적 검토

> Decision ID: `DEC-20260806-120-CANON-V2-RECOVERY-OUTCOME-STATES-AND-INDEPENDENT-RESULT-PACKET`
> 상태: `ADVERSARIAL_REVIEW_COMPLETE / DESIGN_ONLY`
> 검토 시각: 2026-08-06 06:46 KST
> 구현: `IMPLEMENTATION_NOT_AUTHORIZED`
> Human QA: `HUMAN_QA_NOT_RUN`
> UI·접근성 QA: `UI_ACCESSIBILITY_NOT_RUN`
> 병합: `MERGE_NOT_AUTHORIZED`
> 기반 Draft PR: PR #149
> 현재 Draft PR: PR #151

## 1. 검토 질문

1. 대표 결과 6종이 의미적으로 겹치지 않는가?
2. 긴급 봉쇄와 봉쇄 완료가 보상 이름만 다른 같은 상태가 아닌가?
3. 승인 철수가 실패 회피 버튼으로 악용되지 않는가?
4. 피해자 결과와 회수 결과가 다시 하나의 성공/실패 값으로 붕괴하지 않는가?
5. 구형 `core_recovered`·`recovery_successful`·`capture_success`가 신규 권위를 오염시키지 않는가?
6. 결과 화면이 피해자·현상·손실·증거·후속 책임을 인과적으로 설명하는가?
7. save migration이 구형 성공을 근거 없이 완전 성공으로 승격하지 않는가?

## 2. 현재 구현 감사

### battle_scene.gd

현재 `_recover_anomaly_core()`는 안정도 기준을 충족하면 다음 단일 경로를 사용한다.

```gdscript
GameState.save_recovery_result(true, "core_recovered", _anomaly_stability)
```

판정:

- 패턴별 판단 구조는 Decision 119와 정합한다.
- 종결 구조는 `LEGACY_SINGLE_OUTCOME`이다.
- 안정도만 충족하면 잔향 확보·봉쇄 지속성·승인 철수·현장 손실을 분리하지 못한다.

### game_state.gd

현행 핵심 상태:

- `recovery_successful: bool`
- `recovery_result_status: String`
- `recovery_result_stability: int`
- `capture_success`
- `capture_result_state`
- `capture_result_stability`

판정:

- 저장·보고 기반은 재사용 가능하다.
- bool이 대표 권위로 남으면 승인 철수와 통제 실패를 구분할 수 없다.
- 상태 문자열은 존재하지만 결과 패킷과 판정 이유가 없다.
- `capture_success` 플래그가 보상·보고·분기에 어떤 영향을 주는지 구현 전 전수 감사가 필요하다.

### result_scene.gd

현행 결과 화면은 피해자 구조 결과와 회수 상태를 모두 표시한다. 그러나 다음이 구조화되지 않았다.

- 대표 회수 결과 클래스
- 보호 의무 이행
- 요원·장비 손실
- 현장·공공 노출
- 잔향·증거·기록 상태
- 후속 감시·재진입
- 대표 결과 판정 이유와 제외된 상위 결과

판정: `PARTIAL_PRESENTATION / MULTI_AXIS_NOT_IMPLEMENTED`.

## 3. 대표 결과 경계 공격

### 3.1 residue_recovered와 containment_complete

공격 시나리오:

- 잔향을 들고 나왔지만 확산 경로가 열려 있다.
- 매개체를 확보했지만 현상이 다른 위치에서 계속 발현한다.

결론:

- 잔향 소유만으로 `residue_recovered` 금지.
- 현상·확산 경로 통제가 함께 필요하다.
- 잔향을 확보했어도 통제 실패가 성립할 수 있다.

### 3.2 containment_complete와 stabilization_complete

공격 시나리오:

- 현재 발현은 멈췄지만 매개체와 경로가 남아 있다.
- 봉쇄 장치는 설치했으나 즉시 재발 가능성이 높다.

결론:

- 지속 봉쇄가 증명되지 않으면 `containment_complete` 금지.
- 현재 위험만 멈춘 상태는 `stabilization_complete`다.

### 3.3 stabilization_complete와 emergency_containment

공격 시나리오:

- 현장은 잠잠하지만 봉쇄가 몇 분만 유지된다.
- 대형 참사는 막았으나 현장 붕괴와 높은 잔여 위험이 남았다.

결론:

- 안정화가 지속 가능한 이탈 상태를 만들지 못하면 `emergency_containment`다.
- **긴급 봉쇄는 부분 성공**이며 완전 성공으로 표시하지 않는다.

### 3.4 approved_withdrawal과 control_failure

공격 시나리오:

- 위험해지자 즉시 철수 버튼을 눌러 실패를 피한다.
- 현장 붕괴로 밀려난 뒤 승인 철수라고 기록한다.
- 피해자와 중요 기록 상태를 확인하지 않고 이탈한다.

결론:

- **승인 철수는 실패가 아니다**. 그러나 자격 조건이 있어야 한다.
- 필요한 조건은 **안전 철수 경로**, 명시적 **철수 근거**, **보호 대상과 중요 기록의 상태**, **통제 붕괴 전에 의도적으로 종료**, 후속 책임이다.
- 승인 조건을 충족하지 못한 강제 퇴각은 `control_failure`다.

## 4. 독립 패킷 붕괴 공격

### 공격 A — 피해자 사망이면 모든 결과 실패

문제:

- 사람 보호의 실패를 숨기면 안 되지만 현상 통제의 사실도 왜곡한다.

결론:

- **구출 실패가 회수 실패를 자동으로 만들지 않는다**.
- 피해자 결과는 독립 헤드라인과 책임 축으로 강하게 표시한다.

### 공격 B — 잔향 회수면 피해자도 성공

문제:

- 현상 통제와 사람 보호를 다시 합친다.

결론:

- **회수 성공이 피해자 구출 성공을 자동으로 만들지 않는다**.
- `residue_recovered + victim_lost` 같은 불편한 조합도 보존해야 한다.

### 공격 C — 회수 실패 시 이미 구조한 피해자 삭제

문제:

- 후속 페이즈가 선행 성과를 소급 삭제한다.

결론:

- **회수 실패나 승인 철수가 이미 구출한 피해자를 소급 삭제하지 않는다**.

### 공격 D — 전체 작전 점수 하나로 재압축

문제:

- 대표 결과와 독립 패킷을 만든 뒤 마지막에 다시 한 점수로 합치면 설계 목적이 사라진다.

결론:

- 대표 회수 결과, 피해자 생존·분리·후유증, 보호 의무, 요원 피해와 장비 손실, 현장·매개체·공공 노출, 잔향·증거·기록 확보, 후속 조사·재진입·감시, 판정 근거와 인과 이력을 **단일 총점으로 덮어쓰지 않는다**.

## 5. 구형 호환 공격

### 공격 A — recovery_successful이 false면 실패

문제:

- `approved_withdrawal`과 `control_failure`가 동일하게 false가 될 수 있다.

결론:

- `recovery_successful`과 `capture_success`는 `LEGACY_COMPAT_ONLY`다.
- **대표 결과 상태가 권위**다.
- `bool만으로 승인 철수와 통제 실패를 구분하지 않는다`.

### 공격 B — 긴급 봉쇄 true를 완전 성공 보상으로 사용

문제:

- 부분 성공이 완전 회수 보상을 받는다.

결론:

- 호환 true는 구형 흐름 유지용일 뿐이다.
- 신규 보상은 대표 결과 ID와 독립 패킷을 읽는다.

### 공격 C — core_recovered를 residue_recovered로 무조건 이관

문제:

- 구형 저장에는 잔향 확보·확산 경로 봉쇄 근거가 없을 수 있다.

결론:

- `core_recovered`는 `LEGACY_SINGLE_OUTCOME`이다.
- 근거가 충분할 때만 `residue_recovered` 후보로 이관한다.
- 근거 부족 시 `legacy_core_recovered`와 원본 provenance를 보존한다.
- save migration은 원자성·rollback·idempotency를 검증한다.

## 6. 결과 화면 공격

### 공격 A — 성공/실패 대형 배너 하나

문제:

- 승인 철수, 부분 성공, 피해자 실패와 회수 성공의 조합을 표현할 수 없다.

결론:

- **피해자 결과와 회수 결과를 동등한 헤드라인**으로 표시한다.
- **단일 임무 성공/실패 배너 금지**다.

### 공격 B — 손실을 접힌 상세 정보로 숨김

문제:

- 잔향 회수 성공이 요원·피해자·현장 손실을 시각적으로 덮는다.

결론:

- 보호 의무·요원·장비·현장 손실은 기본 결과 구조에 포함한다.
- 접기 기능이 있더라도 요약 경고와 남은 의무를 헤드라인 아래에 유지한다.

### 공격 C — 색상만으로 등급 전달

문제:

- 접근성 저하와 의미 혼동.

결론:

- 텍스트·아이콘·형태를 함께 사용하고 색·음향 단독 전달을 금지한다.
- 접근성 설정은 결과·보상·랭크에 영향을 주지 않는다.

## 7. 실패 전진 공격

통제 실패를 즉시 게임 오버나 저장 삭제로 처리하면 조사·기록·후속 대응 게임의 정체성과 충돌한다.

결론:

- `control_failure`는 비상 대응·사건 재분류·후속 작전의 입력이다.
- 이미 확보한 증거와 구출 성과는 보존한다.
- 무조건 재시작 강요는 금지한다.

## 8. 위험도 판정

| 위험 | 등급 | 결론 |
|---|---|---|
| bool 하나로 승인 철수·통제 실패 구분 불가 | P0 | 대표 결과 status-first 필수 |
| core_recovered 자동 완전 성공 이관 | P0 | provenance 기반 보수적 migration |
| 긴급 봉쇄 완전 성공 오표시 | P0 | PARTIAL_SUCCESS 고정 |
| 피해자·회수 결과 상호 덮어쓰기 | P0 | 독립 헤드라인·독립 패킷 |
| 승인 철수 실패 회피 악용 | P1 | 자격 조건·강제 퇴각 구분 |
| 손실·후속 의무 은폐 | P1 | 결과 기본 구조에 노출 |
| 단일 총점 재압축 | P1 | 축별 기록·분기 소비 |
| 결과 색상 단독 전달 | P1 | 텍스트·형태·아이콘 중복 |
| 구형 보상·플래그 오염 | P1 | 사용처 전수 감사와 호환 어댑터 |
| 결과 정보량 과다 | P2 | 헤드라인→책임→증거→후속 순서 Human QA |

## 9. 검증 요구

### 자동 테스트

- 6종 대표 결과와 클래스
- residue/containment/stabilization/emergency 경계
- 승인 철수 자격과 강제 퇴각
- 피해자·회수 비덮어쓰기
- 결과 패킷 저장·불러오기
- 구형 bool 파생과 status-first 분기
- core_recovered save migration 원자성·rollback·idempotency
- 결과 화면 독립 헤드라인

### Human QA

- 승인 철수를 실패 회피로 인식하는지
- 긴급 봉쇄·봉쇄 완료·안정화 완료의 차이를 설명할 수 있는지
- 피해자 결과와 회수 결과를 모두 기억하는지
- 남은 보호 의무와 후속 작전을 이해하는지
- 색·음향 없이 결과를 구분하는지

현재는 `HUMAN_QA_NOT_RUN / UI_ACCESSIBILITY_NOT_RUN`이다.

## 10. 최종 판정

`DEC-20260806-120-CANON-V2-RECOVERY-OUTCOME-STATES-AND-INDEPENDENT-RESULT-PACKET`은 다음 조건에서 승인 가능한 설계다.

- `residue_recovered`, `containment_complete`, `stabilization_complete`, `emergency_containment`, `approved_withdrawal`, `control_failure`의 의미 경계를 유지한다.
- `FULL_SUCCESS`, `CONTROL_SUCCESS`, `PROVISIONAL_SUCCESS`, `PARTIAL_SUCCESS`, `STRATEGIC_EXIT`, `FAILURE`를 서로 치환하지 않는다.
- 대표 결과와 독립 결과 패킷을 함께 저장한다.
- 구출·회수 결과를 서로 덮어쓰지 않는다.
- `core_recovered`, `recovery_successful`, `capture_success`는 호환 전용으로 격하한다.
- 구현·Human QA·병합은 별도 승인 전 실행하지 않는다.

최종 상태:

`APPROVED_DESIGN_CONTRACT / GRILLME_BATCH_3_5_OF_10 / IMPLEMENTATION_NOT_AUTHORIZED / HUMAN_QA_NOT_RUN / UI_ACCESSIBILITY_NOT_RUN / BATCH_MERGE_NOT_STARTED / MERGE_NOT_AUTHORIZED`
