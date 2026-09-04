# 괴이기록국 가설 보드 합성 테스터 보고서

```yaml
simulation_id: URBAN-LEGEND-SYNTH-001
validation_method: SYNTHETIC_TESTER_SIMULATION
evidence_tier: T6_AI_INFERENCE
baseline_commit: 4ca854dba4926ebb6da3f445dd494dd82d6f3d80
base_governance_commit: 9c4071c5ecefe28769b512d426442338ceb7acdd
structure_analysis: docs/research/2026-07-29-synthetic-tester-structure-analysis.md
human_validation: NOT_RUN
ai_simulation: COMPLETED
implementation_authority: NONE
assumption_not_observation: true
```

## 1. 결정 질문

> 가설 보드가 정답을 대신 고르지 않으면서 플레이어가 관측 사실을 `지지 / 반박 / 미해결` 관계로 설명하고 최초 오독과 피드백 후 수정 과정을 복기하게 하는가?

실제 정답률·추리 재미·신규 플레이어 이해는 측정하지 않는다.

## 2. 페르소나별 가정

### MYSTERY_NOVICE

```yaml
assumed_first_attempt:
  - 지지를 "맞는 것 같음", 반박을 "틀린 것 같음", 미해결을 "모르겠음"이라는 확신도 버튼으로 사용
  - 관측 사실과 가설 사이의 논리 관계보다 자신의 직감을 표시
reasoning_basis: 관계 용어가 논리 방향보다 감정적 확신도로 읽힐 수 있음
confidence: HIGH
counterexample: 각 관계에 짧은 문장 완성 예시가 있으면 논리 관계로 전환될 수 있음
adversarial_question: 관계를 연결하는가, 자신감을 표시하는가?
assumption_not_observation: true
```

### MYSTERY_EXPERT

```yaml
assumed_first_attempt:
  - H2를 강하게 지지하는 결정적 단서만 연결하고 나머지는 미해결로 남김
  - 가설 보드 UX보다 사건 답의 강도에 의해 빠르게 수렴
reasoning_basis: 저승역 사건의 일부 단서가 경쟁 가설 간 정보량이 비대칭일 가능성
confidence: HIGH
counterexample: 반례와 설명 책임을 요구하면 결정적 단서 하나만으로 완료할 수 없음
adversarial_question: 보드를 검증하는가, 사건 정답의 쉬움을 검증하는가?
assumption_not_observation: true
```

### ANSWER_SEEKER

```yaml
assumed_first_attempt:
  - 첫 배제 오류 뒤 진행자 교정을 시스템의 정답 힌트로 사용
  - 이후 관계 편집 단계에서 교정된 온톨로지를 따라 원하는 관계를 작성
reasoning_basis: 배제 단계의 즉시 피드백이 다음 단계의 학습 자극물이 됨
confidence: HIGH
counterexample: no-correction branch와 delayed-correction branch를 분리하면 최초 사고를 보존할 수 있음
adversarial_question: 플레이어가 추리했는가, 세션이 답을 가르쳤는가?
assumption_not_observation: true
```

### MINIMAL_LABOR_OPTIMIZER

```yaml
assumed_first_attempt:
  - 최종 제출에 필요한 최소 근거만 연결
  - 반박·미해결 관계와 원문 복귀를 생략
reasoning_basis: 보드 완성 보상보다 최종 정답 제출이 더 직접적인 목표일 가능성
confidence: HIGH
counterexample: 제출이 최소 지지·반박·미해결 설명을 요구하면 노동 최소화 전략이 달라짐
adversarial_question: 보드 편집이 승리 경로인가, 선택 가능한 메모인가?
assumption_not_observation: true
```

### IMPATIENT_READER

```yaml
assumed_first_attempt:
  - ALL_AT_ONCE에서 카드 요약만 읽고 원문 장면 복귀를 하지 않음
  - BY_SCENE에서는 최근 단서만 과대평가
reasoning_basis: 정보 조건마다 다른 recency·summary 편향
confidence: MEDIUM
counterexample: 원문 복귀가 결정적 관계를 확인하는 명확한 이득을 제공하면 사용될 수 있음
adversarial_question: 원문 복귀는 실제 도구인가, 기록 장식인가?
assumption_not_observation: true
```

### LOW_WORKING_MEMORY

```yaml
assumed_first_attempt:
  - 6개 단서와 2개 가설의 연결 이유를 유지하지 못하고 반복 문구를 사용
  - 미해결을 오류나 미완성으로 느껴 모두 지지/반박 중 하나로 강제
reasoning_basis: 관계 수와 원문 왕복의 작업기억 부담
confidence: MEDIUM
counterexample: 단서별 한 문장 이유와 필터·그룹이 있으면 부담이 감소함
adversarial_question: 추리 깊이를 측정하는가, 보드 관리 능력을 측정하는가?
assumption_not_observation: true
```

## 3. Finding

| ID | 상태 | 내용 | 최소 조치 |
|---|---|---|---|
| `UL-SYN-F01` | `MUST_FIX_BEFORE_TEST` | 배제 단계의 즉시 교정이 이후 관계 편집을 교육해 first attempt를 오염 | no-correction와 delayed-correction 흐름 분리 |
| `UL-SYN-F02` | `SHOULD_ADAPT` | 지지/반박/미해결이 논리 관계보다 확신도 척도로 오해될 가능성 | 관계별 문장 완성형 이유 필드·예시 추가 |
| `UL-SYN-F03` | `TEST_REQUIRED` | H2 단서 강도가 보드 UX보다 정답을 지배하는지 실제 사건 난이도 분석 필요 | 단서 정보량·대안 가설 생존성 별도 fairness review |
| `UL-SYN-F04` | `SHOULD_ADAPT` | 결정적 단서만 연결하는 최소 노동 전략 가능 | 최종 증명에 반례·미해결·원문 근거 중 최소 계약 요구 |
| `UL-SYN-F05` | `SHOULD_ADAPT` | 미해결을 실패·미완성으로 읽을 가능성 | 미해결의 유효성·후속 조사 가치·무벌점 명시 |
| `UL-SYN-F06` | `COUNTEREXAMPLE` | 관계 입력을 강제하면 탐정 놀이보다 양식 작성처럼 느껴질 수 있음 | 필수 관계 수를 최소화하고 자유 메모 허용 |
| `UL-SYN-F07` | `TEST_REQUIRED` | BY_SCENE/ALL_AT_ONCE의 실제 과부하·원문 복귀 차이는 사람 사용 없이는 판정 불가 | 실제 신규 플레이어 또는 클릭 로그 필요 |

## 4. 권장 수정

1. **교정 분리**: 최초 배제·연결을 저장한 뒤에만 delayed feedback을 제공한다.
2. **관계 이유 문장**: “이 관측은 ___ 때문에 가설을 지지/반박하며, ___는 아직 알 수 없다” 형식의 선택적 보조를 둔다.
3. **미해결 유효성**: 미해결이 오답이나 미완성이 아니라 다음 조사 질문을 만든다는 설명을 제공한다.
4. **최소 노동 방지**: 최종 증명은 지지 근거만이 아니라 가장 강한 반례 또는 미해결 하나를 함께 설명하도록 한다.
5. **사건 공정성 분리**: 저승역 H1/H2의 단서 정보량과 보드 UX를 별도 검토한다.
6. **정보 조건 주장 축소**: BY_SCENE/ALL_AT_ONCE는 우월성 판정이 아니라 과부하·recency·원문 복귀 결함 탐색으로 유지한다.

## 5. 적대적 검토

```yaml
strongest_case_for_current_direction: 관측 사실과 가설 관계를 외부화하면 실패 후 오독 위치와 다음 조사 질문을 복기할 수 있음
strongest_case_against_current_direction: 사건 정답 강도와 진행자 교정이 보드 이해를 대신하고 입력 노동만 늘릴 수 있음
hidden_assumption: 플레이어가 최종 정답보다 관계 설명 과정 자체에 가치를 느낌
dominant_strategy_risk: 결정적 지지 단서만 연결하고 즉시 제출
facilitator_or_copy_bias: 첫 오류의 즉시 교정
fidelity_confound: 사건 난이도와 보드 UX가 같은 세션에 혼합
canon_conflict_check: NO_CONFLICT
product_path_intrusion_check: NONE
verdict: ADAPT
```

## 6. 판정

```yaml
decision: ADAPT
reason: 관계 편집·복기 방향은 유지하되 진행자 교육 효과, 관계 의미 오해, 최소 노동 전략과 사건 난이도를 분리해야 함
human_validation: NOT_RUN
actual_mystery_fairness: NOT_RUN
actual_usability: NOT_RUN
implementation_authority: NONE
case_data_changed: false
canon_changed: false
next_gate: REVISE_SESSION_FLOW_AND_RUN_SEPARATE_CASE_FAIRNESS_REVIEW
```
