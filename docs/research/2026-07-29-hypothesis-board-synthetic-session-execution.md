# 괴이기록국 가설 보드 합성 세션 실행 보고서

```yaml
simulation_id: URBAN-LEGEND-SYNTH-SESSION-002
validation_method: SYNTHETIC_TESTER_SIMULATION
evidence_tier: T6_AI_INFERENCE
baseline_branch: main
baseline_commit: 70bf04105895ab5ce855d9682c9c85b9e6eee579
base_governance_commit: 9c4071c5ecefe28769b512d426442338ceb7acdd
structure_analysis: docs/research/2026-07-29-synthetic-tester-structure-analysis.md
prior_risk_report: docs/research/2026-07-29-hypothesis-board-synthetic-tester-report.md
source_artifact: docs/superpowers/plans/2026-07-29-hypothesis-board-human-validation-artifact.md
synthetic_session: EXECUTED
human_validation: NOT_RUN
implementation_authority: NONE
assumption_not_observation: true
```

## 1. 결정 질문

> 모든 최초 배제·관계·증명을 저장한 뒤에만 피드백을 제공하고 관계 이유와 반례·미해결을 요구하면, 가설 보드가 정답을 대신 조립하지 않으면서 사고 경로를 복기하게 하는가?

## 2. 가상 페르소나 Case

### MYSTERY_NOVICE

```yaml
assumed_first_attempt:
  elimination: 시작 기록을 선택지와 직접 연결하되 기록의 적용 범위를 과도하게 일반화
  relation_labels: 지지·반박을 논리 관계보다 맞음·틀림으로 읽으려 함
  proof: 미해결을 남기면 제출이 덜 완성됐다고 느낌
reasoning_basis: 관계 보드 경험이 없고 완결된 정답 제출을 기대함
counterexample: 관계마다 문장 완성 예시와 `미해결도 유효한 조사 상태` 표기를 제공하면 논리 관계로 전환 가능
confidence: HIGH
finding: 교정 지연은 최초 사고를 보존하지만 관계 언어의 교육 계약이 여전히 필요함
```

### DETECTIVE_EXPERT

```yaml
assumed_first_attempt:
  elimination: 기록의 적용 범위와 예외를 분리
  relation_links: 같은 단서를 두 가설에 서로 다른 관계로 연결
  proof: 가장 강한 지지와 반례·미해결을 함께 제시
reasoning_basis: 가설 경쟁과 반증 사고에 익숙함
counterexample: H2 단서가 지나치게 결정적이면 보드 구조를 쓰지 않아도 정답에 도달 가능
confidence: HIGH
finding: 보드의 사고 외부화는 유효하지만 사건 단서 정보량과 별도 평가해야 함
```

### IMPATIENT_INVESTIGATOR

```yaml
assumed_first_attempt:
  elimination: 가장 결정적으로 보이는 기록 하나로 두 선택지를 제거
  relation_links: 제출 최소 요건만 충족하도록 지지 1개와 미해결 1개만 연결
  original_text_return: 요청하지 않고 카드 요약만 사용
reasoning_basis: 관계 수와 원문 왕복이 많을수록 양식 완주를 최적화함
counterexample: 필수 관계 수를 최소화하되 최종 증명에서 원문 한 줄과 반례 또는 미해결을 요구하면 최소 노동의 질을 높일 수 있음
confidence: HIGH
finding: 반례/미해결 요구가 체크박스 노동으로 축소될 위험
```

### SYSTEM_OPTIMIZER

```yaml
assumed_first_attempt:
  strategy: 정답에 가장 직접적인 단서만 찾아 가설 선택 후 최소 관계를 입력
  exploit: 미해결 칸에 중요도가 낮은 질문을 넣어 계약만 충족
  feedback_use: delayed feedback을 정답 공개로 간주하고 수정 후 기록을 최종 답으로 덮어씀
reasoning_basis: 보드 입력이 결과 보상과 직접 연결되지 않으면 최소 제출이 효율적
counterexample: 최종 증명에 `가장 강한 반례가 왜 가설을 무너뜨리지 않는지` 설명하도록 하면 형식적 미해결을 줄일 수 있음
confidence: HIGH
finding: 최소 노동 방지 계약은 내용 품질 기준까지 필요함
```

### ADVERSARIAL_REASONER

```yaml
assumed_first_attempt:
  exploit: 관계 이유 문장을 카드 문구를 그대로 반복해 논리 연결처럼 보이게 함
  second_exploit: 피드백 후 수정에서 최초 판단 근거를 삭제하고 결과에 맞춘 설명만 작성
reasoning_basis: 원문 인용과 논리 이유가 같은 필드이면 복사로 계약을 충족할 수 있음
counterexample: `관측 원문`과 `이 관측이 가설에 미치는 이유`를 별도 필드로 두고 최초 기록을 불변 보존하면 악용 감소
confidence: HIGH
finding: 원문과 추론 이유, first/post feedback 기록의 불변성 계약이 필요함
```

## 3. 단계별 잠정 결과

| 단계 | 잠정 결과 | 근거 | 남은 위험 |
|---|---|---|---|
| 4→2 배제 | `PROMISING_DIRECTION` | 교정 지연으로 최초 사고 경로 보존 | 결정적 기록 하나로 절차를 건너뛸 수 있음 |
| 관계 편집 | `ADAPT` | 관계 이유 계약이 확신도 오해를 줄일 가능성 | 원문 복사와 체크박스 입력으로 축소 가능 |
| 최종 증명 | `PROMISING_DIRECTION` | 반례 또는 미해결 요구가 지지 단서만 제출하는 전략을 공격 | 중요도 낮은 미해결로 형식 충족 가능 |
| 결과 복기 | `ADAPT` | first/post feedback 분리로 수정 경로를 보존 | 피드백을 정답 공개로 받아들일 위험 |
| 사건 공정성 | `TEST_REQUIRED` | 보드와 사건 난이도를 분리한 것은 적절 | H1/H2 정보량·대안 생존성 미분석 |

## 4. Finding

| ID | 판정 | 내용 | 후속 조치 |
|---|---|---|---|
| `UL-SS-F01` | `PROMISING_DIRECTION` | 모든 first attempt 저장 후 교정하는 흐름이 진행자 교육 효과를 줄임 | 최초 기록을 불변 snapshot으로 보존 |
| `UL-SS-F02` | `ADAPT` | 지지·반박·미해결이 여전히 맞음·틀림·모름으로 읽힐 수 있음 | 관계별 짧은 문장 완성 예시 제공 |
| `UL-SS-F03` | `ADAPT` | 원문 인용을 이유 설명으로 대체하는 복사 전략 가능 | `관측 원문 / 관계 이유` 필드 분리 |
| `UL-SS-F04` | `ADAPT` | 형식적 반례·미해결로 최소 계약을 충족할 수 있음 | 가장 강한 반례 또는 핵심 미해결의 영향 설명 요구 |
| `UL-SS-F05` | `TEST_REQUIRED` | 사건 단서 강도가 보드 UX를 지배하는지 미확인 | H1/H2 단서 정보량·대안 가설 생존성 fairness review |
| `UL-SS-F06` | `TEST_REQUIRED` | 실제 원문 왕복 부담과 정보 과부하는 사람 사용 또는 클릭 로그 필요 | `NOT_RUN` 유지 |

## 5. 적대적 판정

```yaml
strongest_case_for_direction: 최초 사고를 잠그고 관계 이유·반례·미해결을 요구하면 정답 제출뿐 아니라 오독과 수정 경로를 외부화할 수 있음
strongest_case_against_direction: 사건의 결정적 단서와 양식 최소 충족 전략이 보드의 추론 가치를 대신할 수 있음
hidden_assumption: 플레이어가 결과 정답뿐 아니라 관계 설명 과정에 가치를 느낀다는 가정
dominant_strategy_risk: 결정적 단서 하나와 형식적 미해결 하나만 제출
copy_or_facilitator_bias: 피드백을 최종 정답 공개로 해석
fidelity_limit: CARD_RELATION_BOARD_WITH_SCRIPTED_FEEDBACK
provisional_decision: ADAPT
```

## 6. 잠정 결론

```yaml
synthetic_session_result: ADAPT
reason: 교정 누출과 지지 단서만 제출하는 문제는 완화됐으나 관계 언어 오해·원문 복사·형식적 반례와 사건 난이도 혼합이 남음
design_revision_authority: PROVISIONAL_RESEARCH_ARTIFACT_ONLY
human_validation: NOT_RUN
actual_mystery_fairness: NOT_RUN
actual_usability: NOT_RUN
case_data_changed: false
save_schema_changed: false
product_code_changed: false
canon_changed: false
implementation_authority: NONE
next_gate: SEPARATE_QUOTE_AND_REASON_FIELDS_AND_RUN_CASE_INFORMATION_FAIRNESS_ANALYSIS_WITHOUT_CHANGING_CASE_DATA
```
