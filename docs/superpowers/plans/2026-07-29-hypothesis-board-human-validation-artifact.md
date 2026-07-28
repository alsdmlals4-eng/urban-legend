# 괴이기록국 가설 보드 사람 검증 Artifact 실행 계획 — Governance 교정판

```yaml
session_packet_id: URBAN-LEGEND-HV-001
project: 괴이기록국
baseline_branch: main
baseline_commit: e29e2da34f06d3e5c762ee763d21409f6f324883
base_governance: BASE_PR_56_PENDING_MERGE
base_governance_path: docs/knowledge/game-development/HUMAN_VALIDATION_ARTIFACT_GOVERNANCE.md
base_template_path: templates/research/HUMAN_VALIDATION_SESSION_PACKET.md
artifact_status: READY_FOR_ONE_CASE_HUMAN_SESSION
human_validation: NOT_RUN
implementation_authority: NONE
```

> 이 문서는 저승역 CORE-MVP-001의 실제 ID·관측 사실을 사용한 저충실도 관계 보드 검증 계획이다. 사건 JSON, 상태 머신, Scene, 저장 Schema, 에피소드 데이터를 변경하지 않는다.

## 1. 결정 질문

> 가설 보드가 정답을 대신 고르지 않으면서 플레이어가 관측 사실을 `지지 / 반박 / 미해결` 관계로 설명하고, 최초 오독과 피드백 후 수정 과정을 스스로 복기하게 하는가?

## 2. Artifact fidelity와 주장 상한

```yaml
artifact_fidelity: CARD
simulated_components:
  - 카드형 관계 보드
  - 원문 복귀 카드
scripted_components:
  - 기존 JSON 피드백 수준의 진행자 교정
  - 현장 검증 결과 카드
fixed_outcomes:
  - poc001_test_follow_display
  - poc001_test_wait_official_signal
claim_ceiling:
  can_claim:
    - 관측 사실과 가설 문장을 연결하는 이유 품질
    - 지지·반박·미해결 라벨의 이해와 수정 가능성
    - 최초 연결과 피드백 후 수정의 차이
    - 원문 복귀·정보 순서·문서 노동의 반복 결함
  cannot_claim:
    - 최종 제품 보드 UI·드래그·접근성 통과
    - 사건 정답률이나 전체 추리 능력 일반화
    - 저장 Schema·자동 추론·캠페인 구조 승인
    - CORE-MVP-001 전체 재미 검증
```

정답 여부보다 최초 사고 경로·관계 이유·미해결 보존을 우선한다.

## 3. 보호 경계와 실제 데이터

- 사건 데이터: `data/poc/core_mvp_001/afterlife_station_poc.json`.
- Scene: `scenes/poc/core_mvp_001/core_mvp_001_scene.tscn`.
- 상태: `scripts/poc/core_mvp_001/core_mvp_001_state.gd`.
- 기존 JSONL 로그와 사람 관찰 기록을 분리한다.
- `scripts/core/game_state.gd`, `data/episodes/**`, 조사·전투 Scene, 저장 Schema는 보호 경로다.
- 관측 사실은 사실이어야 하고 거짓 전조를 추가하지 않는다.
- `미해결`은 거짓이나 반박이 아니다.

### 선택지 4개

- `poc001_choice_move_before_end`
- `poc001_choice_follow_passenger_count`
- `poc001_choice_follow_display`
- `poc001_choice_hold_official_signal`

### 시작 기록 3개

- `poc001_manual_early_movement_reset`
- `poc001_manual_personal_destination`
- `poc001_manual_ticket_contact_danger`

### 관측 단서 6개

| ID | 역할은 진행자 키에서만 사용 |
|---|---|
| `poc001_clue_broadcast_blank` | support 후보 |
| `poc001_clue_reset_timing` | support |
| `poc001_clue_official_identifier` | support |
| `poc001_clue_display_mismatch` | contradiction |
| `poc001_clue_passenger_count` | contradiction |
| `poc001_question_ticket_trigger` | unresolved |

### 경쟁 가설 2개

- H1 `poc001_hypothesis_display_route`
- H2 `poc001_hypothesis_broadcast_blank`

## 4. 최소 Artifact

1. 선택지 카드 4장.
2. 시작 기록 카드 3장.
3. 역할 라벨을 숨긴 단서 카드 6장.
4. 경쟁 가설 카드 2장.
5. 문자·선 형태를 함께 쓰는 관계 토큰.
6. `scene_id`와 관측 문구를 보여주는 원문 복귀 카드.
7. 최초 연결 시트.
8. 피드백 후 수정 시트.
9. 최종 증명·결과 복기 시트.
10. 진행자 개입 원장.

## 5. 세션 단계

### 단계 1 — 4→2 논리 배제

1. 선택지 4장과 기록 3장 공개.
2. 참가자가 기록과 선택지를 연결하고 이유를 말한다.
3. **first_attempt_elimination**을 피드백 전에 기록한다.
4. 잘못된 연결은 최초 기록을 보존한 뒤에만 `이 기록은 그 선택지를 직접 반박하지 않는다` 수준으로 교정한다.
5. 교정 문구·시점을 `facilitator_intervention`에 기록한다.
6. **post_feedback_elimination**을 별도 기록한다.

### 단계 2 — 관계 편집

1. H1·H2와 단서 6장 공개.
2. 참가자가 각 단서를 하나 이상의 가설에 연결하고 관계 이유를 말한다.
3. 모든 최초 관계를 `first_attempt_links`로 저장한다.
4. 진행자는 기대 관계를 추천하지 않는다.
5. 원문 확인 요청 시 전체 관측 문구를 다시 보여준다.
6. 현장 결과 공개 뒤 바꿀 관계를 `post_feedback_links`로 저장한다.

### 단계 3 — 최종 증명

참가자가 직접 작성한다.

```text
선택한 가설:
가장 강한 지지 근거 1:
가장 강한 지지 근거 2:
반대 가설을 약화한 근거:
아직 미해결인 질문:
현장 검증에서 확인할 행동:
```

### 단계 4 — 결과 복기

- 기존 field test 결과를 scripted 카드로 공개한다.
- 최초 연결 중 무엇을 왜 바꿀지 말하게 한다.
- 오독 근거와 다음 조사 질문을 기록한다.
- 정답을 맞혔어도 이유를 설명하지 못하면 방향 지지로 기록하지 않는다.

## 6. 정보 제시 조건

```yaml
condition_BY_SCENE:
  clues: 장면별 순차 공개
condition_ALL_AT_ONCE:
  clues: 6장 동시 공개
```

이 조건은 우월성 A/B 검증이 아니다. 정보 과부하·원문 복귀·관계 수정 결함을 탐색하기 위한 방향성 조건이다.

## 7. 참가자 구성

```yaml
pilot_purpose: DIRECTIONAL_FINDING_AND_DEFECT_DISCOVERY
minimum_participants: 6
segments:
  low_detective_experience: 3
  detective_or_visual_novel_experienced: 3
presentation_assignment:
  group_1: BY_SCENE
  group_2: ALL_AT_ONCE
session_minutes: 30-40
```

작은 표본으로 사건 난이도나 전체 추리 유저를 일반화하지 않는다.

## 8. 관찰 기록

| 필드 | 정의 |
|---|---|
| `participant_id` | 개인정보 없는 코드 |
| `segment` | LOW / EXPERIENCED |
| `clue_presentation` | BY_SCENE / ALL_AT_ONCE |
| `first_attempt_elimination` | 피드백 전 배제와 이유 |
| `post_feedback_elimination` | 교정 후 배제와 이유 |
| `first_attempt_links` | 최초 관계·이유 전체 |
| `source_reopened` | 원문 재확인 횟수·대상 |
| `facilitator_intervention` | 교정·결과 공개 문구와 시점 |
| `post_feedback_links` | 결과 뒤 수정 관계·이유 |
| `unresolved_preserved_first` | 최초 미해결 보존 여부 |
| `unresolved_preserved_after` | 피드백 후 보존 여부 |
| `final_proof` | 관측 근거·반대 근거·미해결 질문 |
| `behavior_observation` | 수정 횟수·시간·카드 재확인 |
| `player_self_report` | 시스템 정답 오인·문서 노동·확신 |
| `critical_incident` | 진행자 의존·거짓 전조·비관측 규칙 오인 |
| `observer_interpretation` | 원자료와 분리한 분석 |

## 9. 판정

1. JSON과 카드 문구·판정이 다르면 `STOP`.
2. 진행자가 최초 시도 전에 힌트를 주면 해당 결과를 해석하지 않는다.
3. 심각도 높은 미해결→거짓 처리·시스템 자동 정답 오인 사례를 본다.
4. 서로 다른 참가자 2명 이상에게 반복된 관계·정보 순서 결함을 본다.
5. 경험군·표현 조건 차이를 본다.
6. 정답률보다 이유 품질·최초→수정 변화·미해결 보존을 우선한다.
7. 수치는 `n/N` 참고값으로 기록한다.

```yaml
PROMISING_DIRECTION:
  required_patterns:
    - "서로 다른 참가자 2명 이상이 관측 사실과 가설 문장을 함께 언급해 관계를 설명"
    - "피드백 뒤 오독 근거와 다음 질문을 스스로 제시"
    - "미해결을 거짓으로 잠그는 심각 결함 없음"
  claim: "근거 관계 편집기·증명 인터페이스·실패 복기 책임을 다음 fidelity 보드에서 계속 검증할 방향을 지지"
ADAPT:
  condition: "추론은 가능하지만 원문 복귀·라벨·정보 순서·문서 노동에서 반복 혼란"
REWORK:
  condition: "최초·수정 관계 모두 이유를 설명하지 못하거나 편집 노동이 추리를 압도"
REJECT:
  condition: "시스템이 답을 골라준다고 느끼거나 미해결을 거짓으로 처리하는 행동이 우세"
STOP:
  condition: "거짓 전조, 비관측 판정, JSON 불일치, 최초 시도 전 진행자 정답 누출"
```

이 fidelity에서는 `ADOPT_BOARD_RESPONSIBILITIES` 또는 제품 Schema 변경을 선언하지 않는다.

## 10. 현재 상태

```yaml
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
next_gate: RUN_FIRST_ATTEMPT_SEPARATED_AFTERLIFE_STATION_PILOT_AND_WRITE_REPORT
```
