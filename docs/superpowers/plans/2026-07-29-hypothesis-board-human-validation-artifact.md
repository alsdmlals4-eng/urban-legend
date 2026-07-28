# 괴이기록국 가설 보드 사람 검증 Artifact 실행 계획

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development or superpowers:executing-plans only after a separate product-build approval. This document authorizes research preparation and human observation only.

**Goal:** 현재 저승역 CORE-MVP-001의 실제 단서·기록·선택지·가설을 사용해, 가설 보드가 정답 자동완성기가 아니라 근거 관계 편집기·증명 인터페이스·실패 복기로 작동하는지 검증한다.

**Architecture:** 기존 `afterlife_station_poc.json`을 수정하지 않는다. 동일한 ID와 문구를 카드로 옮겨 1단계 4→2 논리 배제, 2단계 지지·반박·미해결 연결, 3단계 최종 증명, 4단계 결과 복기를 진행한다. 참가자가 연결을 직접 결정하며 진행자는 정답 관계를 사전에 표시하지 않는다.

**Tech Stack:** 현재 CORE-MVP-001 Godot PoC 또는 동일 데이터를 사용한 인쇄 카드, Markdown 관계 보드, 수기 또는 스프레드시트 관찰 기록, 현재 JSONL 로그와 분리된 연구 기록.

## Global Constraints

- 기준 `main`: `ebd88d4b6088acb7ebf46a921ffe13a279beea02`.
- 상위 Evidence Pack: `docs/research/2026-07-29-fair-play-hypothesis-board-evidence-pack.md`.
- 코어 마일스톤 계약: `docs/superpowers/specs/2026-07-23-project-core-integrated-spec.md`.
- 사건 데이터: `data/poc/core_mvp_001/afterlife_station_poc.json`.
- 기존 `scripts/core/game_state.gd`, `data/episodes/**`, 조사·전투 Scene, 저장 Schema를 변경하지 않는다.
- 관측 사실은 사실이어야 하며 거짓 전조를 추가하지 않는다.
- `미해결`은 `거짓`이나 `반박`으로 처리하지 않는다.
- 시스템 제안은 정답 잠금이 아니며 최종 증명은 플레이어가 구성한다.
- 정답률만으로 통과시키지 않는다.
- 사람 테스트 전 `POC_PASSED`, `VALIDATED`, `PRODUCTION_APPROVED`를 사용하지 않는다.

---

## 1. 현재 실행 경로

| 역할 | 현재 경로 |
|---|---|
| 개발 패널 진입 | `scripts/ui/main_menu.gd`의 F1 개발 패널 |
| PoC Scene | `scenes/poc/core_mvp_001/core_mvp_001_scene.tscn` |
| UI 연결 | `scripts/poc/core_mvp_001/core_mvp_001_scene.gd` |
| 순수 상태 | `scripts/poc/core_mvp_001/core_mvp_001_state.gd` |
| 사건 데이터 | `data/poc/core_mvp_001/afterlife_station_poc.json` |
| 플레이 로그 | `scripts/poc/core_mvp_001/core_mvp_001_playtest_log.gd` |
| 상태 테스트 | `tests/core_mvp_001_state_test.gd` |
| Scene 테스트 | `tests/core_mvp_001_scene_test.gd` |

현재 PoC는 조사 장면 3개, 단서 6개, 시작 기록 3개, 선택지 4개, 배제 2개, 경쟁 가설 2개를 사용한다.

## 2. 최소 Artifact 구성

1. **선택지 카드 4장** — 배제 전 후보.
2. **시작 기록 카드 3장** — 기존 위험 사례와 후보 기록.
3. **관측 단서 카드 6장** — 지지 3, 반박 2, 미해결 1이지만 역할 라벨은 참가자에게 숨김.
4. **가설 카드 2장** — 4→2 배제 뒤 비교할 경쟁 규칙.
5. **관계 토큰** — `지지`, `반박`, `미해결`; 색상과 함께 문자·선 형태 사용.
6. **원문 복귀 표식** — 각 카드의 `scene_id`와 제목.
7. **최종 증명 시트** — 선택한 가설, 핵심 근거 2개 이상, 반대 근거, 남은 질문.
8. **결과 복기 시트** — 강한 근거, 오독한 근거, 다음 조사 질문.

## 3. 선택지 카드

| ID | 참가자 표시 문구 |
|---|---|
| `poc001_choice_move_before_end` | 안내가 끝나기 전에 플랫폼을 벗어난다 |
| `poc001_choice_follow_passenger_count` | 가장 많은 승객이 모인 출구를 따른다 |
| `poc001_choice_follow_display` | 전광판에 표시된 종착지를 따라간다 |
| `poc001_choice_hold_official_signal` | 공식 식별 신호가 끝날 때까지 위치를 고정한다 |

## 4. 시작 기록 카드

### 기록 R1

```yaml
id: poc001_manual_early_movement_reset
title: 안내 종료 전 이동 사례
statement: 안내가 끝나기 전에 이동하면 출발 위치로 되돌아왔다.
status: danger_case
```

### 기록 R2

```yaml
id: poc001_manual_personal_destination
title: 개인 목적지 진술 사례
statement: 승객이 지목한 목적지와 다수 의견은 반복마다 달라 안전 기준이 되지 못했다.
status: danger_case
```

### 기록 R3

```yaml
id: poc001_manual_ticket_contact_danger
title: 검은 승차권 접촉 위험
statement: 검은 승차권과 직접 접촉한 대상의 이름을 닮은 천공 흔적이 남았다.
status: candidate
```

R3는 시작 배제의 정답 키가 아니다. 참가자가 검은 승차권 문제를 최종 안전 경로와 혼합하는지 관찰한다.

## 5. 관측 단서 카드

카드 앞면에는 제목·관측 사실·장면만 표시한다. `role`은 진행자 키에만 남긴다.

| ID | 제목 | 관측 사실 | 원문 장면 |
|---|---|---|---|
| `poc001_clue_broadcast_blank` | 목적지 공백이 있는 방송 원본 | 방송 원본의 목적지 구간은 비어 있다. | 방송 기록실 |
| `poc001_clue_reset_timing` | 이동 직후 초기화된 시간 기록 | 안내 종료 전에 움직인 사람만 같은 시각으로 되돌아왔다. | 방송 기록실 |
| `poc001_clue_official_identifier` | 공식 식별 신호 | 안내가 끝난 뒤 세 번 울리는 짧은 신호는 반복마다 동일하다. | 검은 승차권 개찰구 |
| `poc001_clue_display_mismatch` | 전광판과 방송의 불일치 | 전광판의 종착지는 매번 바뀌지만 방송 원본에는 종착지가 없다. | 변하는 전광판 |
| `poc001_clue_passenger_count` | 맞지 않는 승객 수 | 카메라와 승차권 기록의 승객 수가 서로 다르다. | 변하는 전광판 |
| `poc001_question_ticket_trigger` | 검은 승차권의 발동 조건 | 검은 승차권이 언제 사람 이름을 새기는지는 아직 모른다. | 검은 승차권 개찰구 |

## 6. 가설 카드

### 가설 H1

```yaml
id: poc001_hypothesis_display_route
rule: 전광판이 표시하는 종착지가 현재 반복의 안전 경로다.
```

### 가설 H2

```yaml
id: poc001_hypothesis_broadcast_blank
rule: 방송의 빈 목적지를 임의로 채우지 않고 공식 식별 신호 종료까지 위치를 고정해야 한다.
```

가설 카드에는 요구 단서 목록이나 정답 점수를 표시하지 않는다.

## 7. 관계 토큰

| 토큰 | 문자 | 선 형태 | 의미 |
|---|---|---|---|
| 지지 | `지지` | 실선 | 관측 사실이 가설의 가능성을 높임 |
| 반박 | `반박` | 끊어진 선 | 관측 사실이 가설의 전제와 충돌함 |
| 미해결 | `미해결` | 점선 | 현재 정보만으로 참·거짓을 정하지 못함 |

색상을 제거해도 문자와 선 형태로 구분돼야 한다.

## 8. 진행자 정답 키

### 4→2 배제

| 기록 | 배제 선택지 | 이유 |
|---|---|---|
| `poc001_manual_early_movement_reset` | `poc001_choice_move_before_end` | 안내 종료 전 이동은 공간 초기화를 일으킴 |
| `poc001_manual_personal_destination` | `poc001_choice_follow_passenger_count` | 승객 수와 개인 목적지는 반복마다 달라 안전 기준이 아님 |

### 가설 H1 관계

| 단서 | 기대 관계 |
|---|---|
| `poc001_clue_broadcast_blank` | 지지 후보 |
| `poc001_clue_display_mismatch` | 반박 |
| `poc001_question_ticket_trigger` | 미해결 |

### 가설 H2 관계

| 단서 | 기대 관계 |
|---|---|
| `poc001_clue_broadcast_blank` | 지지 |
| `poc001_clue_reset_timing` | 지지 |
| `poc001_clue_official_identifier` | 지지 |
| `poc001_clue_display_mismatch` | 반박 |
| `poc001_clue_passenger_count` | 반박 |
| `poc001_question_ticket_trigger` | 미해결 |

`지지 후보`는 해당 단서 하나만으로 H1이 참이라는 뜻이 아니다. 참가자가 공백을 임의 종착지로 채우는 해석을 만들 수 있으나 전광판 불일치가 이를 반박한다.

## 9. 진행자 스크립트

### 시작 안내

> "이 보드는 정답을 대신 골라주지 않습니다. 기록과 관측 사실을 이용해 어떤 선택지를 버릴 수 있는지, 남은 가설에 각 근거가 지지·반박·미해결 중 무엇인지 직접 연결해 주세요. 연결은 언제든 수정할 수 있습니다."

### 단계 1 — 논리 배제

1. 선택지 4장과 시작 기록 3장을 공개한다.
2. 참가자에게 기록 하나를 선택지 하나에 연결하게 한다.
3. 연결 이유를 말하게 한다.
4. 서로 다른 선택지 2개가 배제될 때까지 반복한다.
5. 잘못된 연결에는 정답을 말하지 않고 JSON의 기존 피드백 수준으로만 `이 기록은 그 선택지를 직접 반박하지 않는다`고 알린다.

### 단계 2 — 가설 관계 편집

1. 남은 선택지에 대응하는 가설 H1·H2를 공개한다.
2. 단서 6장을 한 번에 제공한다.
3. 참가자는 각 단서를 하나 이상의 가설에 연결할 수 있다.
4. 관계 토큰을 직접 선택하고 이유를 말한다.
5. 원문 확인을 요청하면 장면 카드의 관측 문구를 다시 보여준다.
6. 진행자는 추천 관계선을 자동 생성하지 않는다.

### 단계 3 — 최종 증명

참가자는 다음 양식을 채운다.

```text
선택한 가설:
가장 강한 지지 근거 1:
가장 강한 지지 근거 2:
반대 가설을 약화한 근거:
아직 미해결인 질문:
현장 검증에서 확인할 행동:
```

모든 칸은 참가자의 발화로 채운다. 진행자가 문장을 완성하지 않는다.

### 단계 4 — 결과 복기

1. 현재 PoC의 `poc001_test_follow_display` 또는 `poc001_test_wait_official_signal` 결과를 공개한다.
2. 참가자에게 처음 연결 중 바꿀 관계를 고르게 한다.
3. 잘못 읽은 근거와 다음 조사 질문을 말하게 한다.
4. 정답을 맞혔어도 근거를 설명하지 못하면 통과로 기록하지 않는다.

## 10. 참가자 구성

```yaml
minimum_participants: 6
segments:
  low_detective_experience: 3
  detective_or_visual_novel_experienced: 3
session_minutes: 30-40
presentation_order:
  participant_1_3: [records_first, clues_by_scene]
  participant_4_6: [records_first, clues_all_at_once]
```

두 표현 순서는 정보 획득 순서가 관계 이해에 미치는 영향을 보기 위한 연구 조건이다. 단서 내용은 동일하게 유지한다.

## 11. 관찰 기록지

| 필드 | 기록 규칙 |
|---|---|
| `participant_id` | 개인 식별정보 없는 코드 |
| `segment` | `LOW` 또는 `EXPERIENCED` |
| `clue_presentation` | `BY_SCENE` 또는 `ALL_AT_ONCE` |
| `elimination_1_correct` | 0/1 |
| `elimination_2_correct` | 0/1 |
| `elimination_reason_explained` | 0~2 |
| `relation_links_created` | 수 |
| `relation_links_revised` | 수 |
| `support_reason_correct` | 수 |
| `contradiction_reason_correct` | 수 |
| `unresolved_preserved` | 0/1 |
| `source_reopened` | 원문·장면 재확인 횟수 |
| `final_hypothesis` | H1/H2 |
| `proof_uses_two_observables` | 0/1 |
| `system_seen_as_answer` | 1~5 |
| `documentation_burden` | 1~5 |
| `post_failure_misread_explained` | 0/1 |
| `new_question_proposed` | 0/1 |
| `decision_seconds` | 관계 편집 시작부터 제출까지 |
| `observer_note` | 자동 제안 추종·색상 의존·툴팁 미확인 등 |

## 12. 계산과 판정

- 배제 근거 설명률: 올바른 배제 2개 중 이유까지 설명한 수의 비율.
- 관계 이유 설명률: 참가자가 만든 연결 중 관측 사실과 가설 문장을 함께 언급한 비율.
- 원문 회수율: 최소 한 번 원문·장면을 다시 확인한 참가자 비율.
- 증명 완성률: 관측 근거 2개, 반대 근거 1개, 미해결 질문 1개를 포함한 제출 비율.
- 실패 귀인률: 틀린 가설 뒤 오독 근거와 다음 질문을 모두 말한 비율.
- 자동 정답 오인률: `system_seen_as_answer >= 4` 비율.
- 문서 노동 과부하율: `documentation_burden >= 4`이고 관계 편집이 10분을 초과한 비율.

```yaml
ADOPT_BOARD_RESPONSIBILITIES:
  elimination_explanation_rate: ">= 0.75"
  relation_reason_rate: ">= 0.67"
  proof_completion_rate: ">= 0.67"
  unresolved_preservation_rate: ">= 0.75"
  automatic_answer_misread_rate: "<= 0.25"
ADAPT:
  condition: "근거 추론은 가능하지만 원문 복귀·관계 라벨·정보 순서에서 반복 혼란 발생"
REWORK:
  condition: "정답을 맞혀도 관계 이유를 설명하지 못하거나 편집 노동이 추리를 압도함"
REJECT:
  condition: "시스템이 답을 골라준다고 느끼거나 미해결을 거짓으로 처리하는 행동이 우세함"
STOP:
  condition: "거짓 전조·비관측 규칙·현재 JSON과 다른 판정이 사용됨"
```

## 13. 기존 JSONL 로그와 연구 기록 분리

현재 PoC의 `user://core_mvp_001_playtest.jsonl`은 런타임 이벤트 로그다. 이 문서의 사람 관찰 기록을 해당 파일에 덧붙이지 않는다.

사람 테스트 뒤 다음 보고서를 별도 PR로 만든다.

```text
docs/validation/2026-XX-XX_HYPOTHESIS_BOARD_HUMAN_VALIDATION_REPORT.md
```

보고서에는 다음을 기록한다.

- 실행 `main` SHA와 사건 JSON SHA.
- 참가자 수·경험 구분·표현 순서.
- 원자료와 계산 결과.
- 정답과 사고 과정이 불일치한 사례.
- 자동화가 필요한 부분과 자동화하면 안 되는 부분.
- `ADOPT / ADAPT / REWORK / REJECT` 판정.
- 기존 CORE-MVP-001·저장 Schema·에피소드 데이터 변경 여부 `NO_CHANGE`.

## 14. 실행 작업

### Task 1: 데이터 무결성 확인

- [ ] 사건 ID가 `poc001_case_afterlife_station`인지 확인한다.
- [ ] 단서 6·기록 3·선택지 4·가설 2가 이 문서와 일치하는지 확인한다.
- [ ] `observable: true`가 아닌 사실을 카드에 추가하지 않는다.
- [ ] 불일치하면 사람 세션을 시작하지 않는다.

### Task 2: 카드 패킷 준비

- [ ] 역할 라벨을 숨긴 단서 카드 6장을 준비한다.
- [ ] 관계 토큰을 문자·선 형태로 구분한다.
- [ ] 정답 키를 참가자에게 보이지 않게 분리한다.
- [ ] 원문 장면 복귀 카드를 한 번의 행동으로 확인할 수 있게 한다.

### Task 3: 사람 세션

- [ ] 두 경험군 각 3명 이상을 실행한다.
- [ ] 단서 표현 순서를 3명씩 나눈다.
- [ ] 정답 여부와 근거 설명을 별도 기록한다.
- [ ] 진행자가 관계선을 추천하지 않는다.

### Task 4: 판정

- [ ] 정답률만으로 통과시키지 않는다.
- [ ] 미해결 보존과 실패 귀인을 별도 계산한다.
- [ ] 제품 UI·Schema 변경은 보고서와 사용자 승인 뒤 별도 PR로 분리한다.

## 15. 적대적 셀프 리뷰

- 기대 관계표가 진행자 힌트로 누출될 수 있음 → 참가자 패킷과 진행자 키를 물리적으로 분리.
- H2가 데이터상 더 강해 단일 정답 퍼즐이 될 수 있음 → 최종 선택보다 관계 이유·미해결 보존을 우선 측정.
- 모든 단서를 한 번에 주면 문서 정리 노동이 될 수 있음 → 장면별/일괄 조건을 분리 기록.
- 원문 복귀가 작은 툴팁으로 축소될 수 있음 → 카드 전체 문구를 다시 보여주며 툴팁만 사용하지 않음.
- 기존 PoC 성공을 후속 보드 성공으로 과장할 수 있음 → 저충실도 관계 인터페이스 Pilot로만 판정.

## 16. 현재 상태

```yaml
artifact_status: READY_FOR_ONE_CASE_HUMAN_SESSION
product_code_changed: false
case_data_changed: false
save_schema_changed: false
canon_changed: false
human_validation: NOT_RUN
implementation_authority: NONE
next_gate: RUN_SIX_PARTICIPANT_AFTERLIFE_STATION_BOARD_PILOT
rollback: remove this document only
```
