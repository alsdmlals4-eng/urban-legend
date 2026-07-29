# 괴이기록국 가설 보드 사람 검증 Artifact 실행 계획 — 합성 위험 교정판

```yaml
session_packet_id: URBAN-LEGEND-HV-001
project: 괴이기록국
baseline_branch: main
baseline_commit: 85cfc56995846f006edbca241036d0f4679c6de4
base_governance_commit: 9c4071c5ecefe28769b512d426442338ceb7acdd
base_governance_path: docs/knowledge/game-development/HUMAN_VALIDATION_ARTIFACT_GOVERNANCE.md
base_synthetic_governance_path: docs/knowledge/game-development/SYNTHETIC_TESTER_SIMULATION_GOVERNANCE.md
synthetic_review_source: docs/research/2026-07-29-hypothesis-board-synthetic-tester-report.md
artifact_status: READY_AFTER_SYNTHETIC_REMEDIATION
human_validation: NOT_RUN
implementation_authority: NONE
```

> 이 문서는 저승역 CORE-MVP-001의 실제 ID·관측 사실을 사용한 저충실도 관계 보드 검증 계획이다. 사건 JSON, 상태 머신, Scene, 저장 Schema, 에피소드 데이터를 변경하지 않는다.

## 1. 결정 질문

> 가설 보드가 정답을 대신 고르지 않으면서 플레이어가 관측 사실을 `지지 / 반박 / 미해결` 논리 관계로 설명하고, 모든 최초 사고 경로를 저장한 뒤에만 피드백을 받아 오독과 수정 과정을 복기하게 하는가?

## 2. Artifact fidelity와 주장 상한

```yaml
artifact_fidelity: CARD
simulated_components:
  - 카드형 관계 보드
  - 원문 복귀 카드
  - 관계 이유 문장 보조 카드
scripted_components:
  - 모든 first attempt 저장 뒤 제공하는 기존 JSON 수준 교정
  - 현장 검증 결과 카드
fixed_outcomes:
  - poc001_test_follow_display
  - poc001_test_wait_official_signal
claim_ceiling:
  can_claim:
    - 관측 사실과 가설 문장을 연결하는 이유 품질
    - 지지·반박·미해결을 확신도가 아닌 관계로 사용하는지
    - 최초 연결·최초 증명과 피드백 후 수정의 차이
    - 원문 복귀·정보 순서·문서 노동의 반복 결함
    - 결정적 단서만 연결하는 최소 노동 전략 후보
  cannot_claim:
    - 최종 제품 보드 UI·드래그·접근성 통과
    - 사건 정답률이나 전체 추리 능력 일반화
    - 저장 Schema·자동 추론·캠페인 구조 승인
    - CORE-MVP-001 전체 재미 검증
    - 저승역 사건 난이도와 보드 UX의 인과 분리 완료
```

정답 여부보다 최초 사고 경로·관계 이유·반례·미해결 보존을 우선한다.

## 3. 보호 경계와 실제 데이터

- 사건 데이터: `data/poc/core_mvp_001/afterlife_station_poc.json`.
- Scene: `scenes/poc/core_mvp_001/core_mvp_001_scene.tscn`.
- 상태: `scripts/poc/core_mvp_001/core_mvp_001_state.gd`.
- 기존 JSONL 로그와 사람 관찰 기록을 분리한다.
- `scripts/core/game_state.gd`, `data/episodes/**`, 조사·전투 Scene, 저장 Schema는 보호 경로다.
- 관측 사실은 사실이어야 하고 거짓 전조를 추가하지 않는다.
- `미해결`은 거짓·반박·오답·미완성이 아니다.

실제 계약 요소:

- 선택지 4개: `move_before_end`, `follow_passenger_count`, `follow_display`, `hold_official_signal`.
- 시작 기록 3개: `early_movement_reset`, `personal_destination`, `ticket_contact_danger`.
- 관측 단서 6개: 방송 공백, 초기화 시각, 공식 신호, 전광판 불일치, 승객 수 불일치, 승차권 발동 미해결.
- 경쟁 가설 2개: `poc001_hypothesis_display_route`, `poc001_hypothesis_broadcast_blank`.

## 4. 관계 라벨 계약

관계 토큰에는 색상 외 문자·선 형태와 아래 정의를 함께 제공한다.

```yaml
SUPPORT:
  display: 지지
  sentence: "이 관측은 ___ 때문에 이 가설이 성립할 가능성을 높인다."
  not_meaning: "내가 이 가설을 확신한다"
REFUTE:
  display: 반박
  sentence: "이 관측은 ___ 때문에 이 가설의 예상과 충돌한다."
  not_meaning: "이 가설이 완전히 거짓이다"
UNRESOLVED:
  display: 미해결
  sentence: "이 관측만으로는 ___를 구분할 수 없어 다음 확인이 필요하다."
  not_meaning: "오답 또는 미완성"
  penalty: NONE
```

문장 보조는 선택적으로 사용할 수 있지만 관계 토큰을 놓을 때 관측 원문 또는 이유를 하나 이상 연결한다. 진행자는 참가자의 문장을 완성하지 않는다.

## 5. 최소 Artifact

1. 선택지 카드 4장.
2. 시작 기록 카드 3장.
3. 역할 라벨을 숨긴 단서 카드 6장.
4. 경쟁 가설 카드 2장.
5. 문자·선 형태를 함께 쓰는 관계 토큰.
6. 관계 정의·선택적 문장 보조 카드.
7. `scene_id`와 관측 문구를 보여주는 원문 복귀 카드.
8. 최초 배제·최초 관계·최초 증명 시트.
9. 피드백 후 배제·관계·증명 수정 시트.
10. 결과 복기 시트와 진행자 개입 원장.

## 6. 세션 단계 — 모든 최초 시도 저장 전 교정 금지

### 단계 1 — 4→2 논리 배제

1. 선택지와 시작 기록을 공개한다.
2. 참가자가 기록과 선택지를 연결하고 이유를 말한다.
3. `first_attempt_elimination`과 근거 원문을 기록한다.
4. 잘못된 연결이 있어도 정답·교정·칭찬·힌트를 제공하지 않는다.
5. 참가자가 “확정”을 누르거나 말한 뒤 시트를 잠근다.

### 단계 2 — 관계 편집

1. 경쟁 가설과 단서 6장을 공개한다.
2. 관계 정의 카드를 보여주되 기대 관계는 알려주지 않는다.
3. 참가자가 관계 토큰·관측 원문·이유를 선택한다.
4. 최초 관계 전체를 `first_attempt_links`로 저장하고 잠근다.
5. 원문 요청 시 전체 관측 문구만 다시 보여준다.
6. 단계 1의 오답 여부나 기존 JSON 피드백을 아직 공개하지 않는다.

### 단계 3 — 최초 최종 증명

```text
선택한 가설:
가장 강한 지지 근거 1·2:
가장 강한 반례 또는 충돌 근거:
유효하게 남겨 둘 미해결 질문:
반대 가설이 아직 살아 있다면 그 이유:
현장 검증에서 확인할 행동:
```

최소 제출 계약:

```yaml
proof_minimum:
  support_evidence: 1
  observation_quote_or_scene_reference: 1
  counterevidence_or_unresolved: 1
  field_test_action: 1
```

지지 근거만 연결한 제출은 완료로 처리하지 않는다. 반례가 없다고 판단하면 어떤 관측을 검토했으며 왜 반례가 아닌지 설명한다.

### 단계 4 — delayed feedback과 현장 결과

단계 1~3의 모든 first attempt가 잠긴 뒤에만 진행한다.

1. 기존 JSON 수준의 배제 피드백을 공개한다.
2. 교정 문구·시점을 `facilitator_intervention`에 기록한다.
3. 기존 field test 결과를 scripted 카드로 공개한다.
4. `post_feedback_elimination`, `post_feedback_links`, `post_feedback_proof`를 별도 기록한다.
5. 최초 연결 중 무엇을 왜 바꿨는지 말하게 한다.
6. 오독 근거와 다음 조사 질문을 기록한다.
7. 정답을 맞혔어도 이유를 설명하지 못하면 방향 지지로 기록하지 않는다.

## 7. 정보 제시 조건

```yaml
condition_BY_SCENE: 장면별 순차 공개
condition_ALL_AT_ONCE: 단서 6장 동시 공개
```

우월성 A/B 검증이 아니라 정보 과부하·원문 복귀·관계 수정 결함 탐색 조건이다. 어느 조건에서도 first attempt 저장 전 교정하지 않는다.

## 8. 사건 공정성과 보드 UX 분리

보드 관계를 잘 사용했는지와 저승역 단서가 지나치게 결정적인지는 별도 열에 기록한다.

```yaml
board_ux_observation:
  - relation_definition_understood
  - observation_reason_linked
  - counterevidence_or_unresolved_preserved
  - original_text_revisited
case_fairness_observation:
  - decisive_clue_used_without_board
  - alternative_hypothesis_survived
  - unobserved_rule_inferred
  - clue_information_dominance
```

`case_fairness_observation` 결함을 보드 UI 실패로 자동 귀인하지 않는다. 사건 단서 강도 변경은 별도 `fairness-review`가 책임지며 이번 문서로 JSON을 수정하지 않는다.

## 9. 참가자와 기록

```yaml
pilot_purpose: DIRECTIONAL_FINDING_AND_DEFECT_DISCOVERY
minimum_participants: 6
segments:
  low_detective_experience: 3
  detective_or_visual_novel_experienced: 3
presentation_assignment:
  group_1: BY_SCENE
  group_2: ALL_AT_ONCE
session_minutes: 35-45
```

분리 기록:

- `first_attempt_elimination`, `first_attempt_elimination_reason`.
- `first_attempt_links`, 각 관계의 관측 원문·이유.
- `first_attempt_proof`, 가장 강한 반례 또는 미해결.
- 모든 first attempt 잠금 시각.
- `facilitator_intervention`, delayed feedback 공개 시점.
- `post_feedback_elimination`, `post_feedback_links`, `post_feedback_proof`.
- 원문 재확인 행동.
- 최초·수정 후 미해결 보존.
- 수정 횟수·시간·카드 재확인 행동.
- `board_ux_observation`과 `case_fairness_observation` 분리 기록.
- 시스템 정답 오인·문서 노동·미해결 실패감 자기보고.
- 진행자 의존·거짓 전조·비관측 규칙·결정적 단서만 연결한 critical incident.

## 10. 판정

비율은 `n/N` 참고값으로만 기록한다.

```yaml
PROMISING_DIRECTION:
  required_patterns:
    - "서로 다른 참가자 2명 이상이 관측 사실과 가설 문장을 함께 언급해 관계를 설명"
    - "최초 증명에서 지지 근거와 반례 또는 미해결을 함께 보존"
    - "delayed feedback 뒤 오독 근거와 다음 질문을 스스로 제시"
    - "미해결을 거짓·오답·미완성으로 잠그는 심각 결함 없음"
  claim: "근거 관계 편집기·증명 인터페이스·실패 복기 책임을 다음 fidelity 보드에서 검증할 방향을 지지"
ADAPT:
  condition: "추론은 가능하지만 원문 복귀·라벨·정보 순서·문서 노동에서 반복 혼란"
REWORK:
  condition: "최초·수정 관계 모두 이유를 설명하지 못하거나 지지 단서만 연결하는 최소 노동 전략이 우세함"
REJECT:
  condition: "시스템이 답을 골라준다고 느끼거나 미해결을 거짓으로 처리하는 행동이 우세함"
STOP:
  condition: "거짓 전조, 비관측 판정, JSON 불일치, 모든 first attempt 저장 전 진행자 정답 누출"
```

이 fidelity에서는 제품 보드 `ADOPT`나 Schema 변경을 선언하지 않는다.

## 11. 현재 상태

```yaml
synthetic_must_fix_applied:
  correction_delayed_until_all_first_attempts_saved: true
  relation_reason_contract_added: true
  counterevidence_or_unresolved_required: true
  case_fairness_separated_from_board_ux: true
human_session_executed: false
case_data_changed: false
save_schema_changed: false
product_code_changed: false
canon_changed: false
product_board_ui: NOT_RUN
accessibility: NOT_RUN
performance: NOT_RUN
external_sample: NOT_RUN
human_validation: NOT_RUN
implementation_authority: NONE
next_gate: RUN_REVISED_NO_LEAK_AFTERLIFE_STATION_PILOT_AND_SEPARATE_CASE_FAIRNESS_REVIEW
```
