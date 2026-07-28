# 공정 추리 가설 보드 Evidence Pack Pilot

```yaml
evidence_pack_id: URBAN-LEGEND-EVP-001
project: 괴이 기록국
baseline_branch: main
baseline_commit: 4eb451699486c1519f24018b341f804e7e086877
created_at: 2026-07-29
work_mode: PLAN
status: PILOT_RECOMMENDATION
implementation_authority: NONE
human_validation: NOT_RUN
method_reference: Base dc9603595155989e13fb92edff347df5c725217e
```

> 이 문서는 기존 사건 데이터·저장 Schema·CORE-MVP-001 구현을 변경하지 않는다. 후속 `관측·가설·반박 보드`를 공정한 추리 도구로 설계하기 위한 계획 입력이다.

## 1. 현재 코어와 보호 경계

- 괴이는 처치 대상이 아니라 규칙을 조사하고 현재 출현을 안정화할 현상이다.
- 관측 가능한 증거로 4개 선택지 중 2개를 제거한다.
- 가설은 지지·반박·미해결 근거를 가진다.
- 거짓 전조를 사용하지 않는다.
- 보이지 않는 패턴으로 비가역 손실을 주지 않는다.
- 성공·실패 결과는 괴이 매뉴얼과 위험 사례로 기록한다.
- 요원·장비·관계·자동행동은 핵심 정답을 대신하지 않는다.
- 후속 보드는 현재 저장·ID·에피소드 규칙을 승인 없이 변경하지 않는다.

## 2. 결정 질문

> 플레이어가 단서를 수집한 뒤 게임이 정답을 대신 골라주지 않으면서도, **왜 어떤 가설이 지지·반박·미해결인지** 확인하고 자신의 결론을 증명할 수 있게 하려면 가설 보드는 어떤 책임을 가져야 하는가?

### 성공 조건

- 플레이어가 각 가설에 연결된 근거와 연결 이유를 설명한다.
- 제거된 선택지가 왜 제거됐는지 화면에서 다시 확인한다.
- 최종 두 후보 중 선택은 플레이어의 해석과 위험 판단으로 남는다.
- 잘못된 가설도 어떤 근거를 과대평가했는지 설명 가능한 위험 사례가 된다.
- 필수 단서 누락이 있어도 보이지 않는 난수 처벌 대신 추가 질문 또는 안전한 실패 전진으로 이어진다.

### 실패 조건

- 증거를 획득하면 시스템이 자동으로 정답 가설을 완성한다.
- `지지/반박` 라벨만 있고 이유나 원문 근거로 돌아갈 수 없다.
- 거짓 단서와 미해결 단서를 같은 방식으로 표시한다.
- 플레이어가 증명한 내용보다 숨은 점수·호감도·요원 능력이 정답을 결정한다.
- 실패 뒤 새 규칙이 소급 공개된다.

## 3. 선택 Coverage

| Coverage | 상태 | 이유 |
|---|---|---|
| 프로젝트 코어·게임 기획 | EVIDENCED | 공정한 규칙 추론이 코어다. |
| 내러티브·콘텐츠 | EVIDENCED | 단서의 문맥·모순·미해결 상태가 필요하다. |
| UX·UI·접근성 | EVIDENCED | 근거 관계와 원문 복귀가 읽혀야 한다. |
| 벤치마킹·GUR | EVIDENCED | 추리 성공보다 사고 과정과 실패 귀인을 관찰한다. |
| 구현·저장 | NOT_APPLICABLE | 이번 Pilot은 설계 입력이며 Schema 변경을 승인하지 않는다. |

## 4. Evidence

| ID | 층 | 출처 | 확인된 활용점 | 한계 |
|---|---|---|---|---|
| EVD-UL-01 | T2_PROFESSIONAL_PRACTICE | Jon Ingold, GDC 2022, The Burden of Proof | 증거와 추측으로 구체적인 해답을 조립·수정하고, 창의성을 제거하지 않으면서 게임에 결론을 증명하는 문제를 다룬다. | Overboard!의 역할·서사 구조를 복제하지 않는다. |
| EVD-UL-02 | T2_PROFESSIONAL_PRACTICE | Jon Ingold, GDC 2018, Heaven's Vault: Creating a Dynamic Detective Story | 발견 순서와 누락이 달라도 계속 진전하도록 적응형 콘텐츠와 자동 테스트를 사용한 접근을 다룬다. | 괴이기록국의 4→2 제거 규칙을 직접 제시하지 않는다. |
| EVD-UL-03 | T2_PROFESSIONAL_PRACTICE | Jolie Menzel, GDC 2016, Solving Puzzle Design | 퍼즐을 평가·개선하고 좌절 원인을 진단하는 실무 기법을 다룬다. | 서사 추리 전용 규칙은 아니다. |
| EVD-UL-04 | T2_PROFESSIONAL_PRACTICE | Patrick Traynor, GDC 2024, System-Centric Puzzle Design in Patrick's Parabox | 핵심 시스템을 드러내는 퍼즐 구성과 플레이테스트 휴리스틱을 다룬다. | 공간 퍼즐과 조사 추리의 차이가 크다. |
| EVD-UL-05 | T6_AI_INFERENCE | 본 Pilot 종합 | 가설 보드는 답안지가 아니라 `근거 관계 편집기 + 증명 인터페이스 + 실패 복기`여야 한다. | 사람 테스트 전 가설이다. |

## 5. 대안 비교

### A. 자동 추론 보드

- 단서를 얻으면 시스템이 가설에 자동 연결하고 틀린 선택을 제거한다.
- 장점: 진행이 빠르고 막힘이 적다.
- 위험: 요원이나 UI가 정답을 대신해 조사 코어가 약화된다.
- 판정: `AVOID`.

### B. 증거 연결은 제안하되 이유 확인·최종 판단은 플레이어가 수행

- 새 증거가 어떤 가설과 관계될 수 있는지 후보만 알린다.
- 플레이어는 `지지 / 반박 / 미해결` 중 관계를 선택하거나 수정한다.
- 각 연결은 원문·관측 장면·기록으로 되돌아갈 수 있다.
- 선택지 제거는 근거 체인이 충족될 때만 발생하고 이유를 표시한다.
- 판정: `ADAPT`.

### C. 완전 수동 자유 메모

- 장점: 높은 표현 자유와 추리감.
- 위험: 입력 부담, 접근성, 검증 난이도, 모바일이 아닌 PC에서도 과도한 문서 작업감.
- 판정: 핵심 기능으로는 `AVOID`, 선택형 메모는 `TEST`.

## 6. Pilot 권장안

최종 판정: **`ADAPT` — B안을 기본으로 검증한다.**

### 가설 보드의 책임

1. **가설 카드:** 현재 주장, 필요한 조건, 반례 가능성을 짧게 표시.
2. **증거 카드:** 관측 사실과 해석을 분리하고 원문 위치로 돌아갈 수 있게 함.
3. **관계선:** `지지 / 반박 / 미해결`을 색상뿐 아니라 형태·문구로 표시.
4. **제거 근거:** 4개 후보 중 제거된 항목에 최소 한 개 이상의 관측 가능한 근거 체인을 표시.
5. **최종 증명:** 남은 두 후보 중 플레이어가 가설과 근거 묶음을 제출.
6. **결과 복기:** 맞음/틀림뿐 아니라 강한 근거, 오독한 근거, 남은 질문을 기록.
7. **위험 사례:** 실패를 다음 조사에서 사용할 질문·주의 규칙으로 보존.

### 공정성 규칙

- 거짓 전조를 만들지 않는다. 등장한 관측 사실은 사실이어야 한다.
- `미해결`은 `거짓`이 아니다.
- 필수 사실을 선택형 관계 이벤트나 자유일정에만 숨기지 않는다.
- 증거 자동 연결은 제안 상태이며 플레이어 판단을 잠그지 않는다.
- 핵심 선택을 호감도·요원 스킬·장비 수치로 자동 해결하지 않는다.
- 실패 판정에 사용된 규칙은 결과 전에 관측 가능해야 한다.

## 7. 사건 1개 Pilot 계약

```yaml
artifact: one_case_clickable_hypothesis_board
tester_segment:
  - 추리 게임 경험이 적은 참가자 3명 이상
  - 추리·비주얼노벨 경험자 3명 이상
tasks:
  - 증거 4~6개를 가설 4개에 연결
  - 두 후보를 제거하고 이유 설명
  - 남은 두 후보 중 하나를 근거 묶음과 제출
  - 결과 뒤 잘못 읽은 근거와 다음 질문 설명
primary_metrics:
  - 관계선 이유 설명률
  - 제거 근거 회수율
  - 원문·관측 장면 재확인 사용률
  - 실패 후 오독 근거 설명률
  - 증거 연결·수정 횟수
guardrails:
  - 시스템 제안을 정답으로 오인하는가
  - 색상만으로 관계를 구분하는가
  - 필수 정보가 작은 툴팁에만 존재하는가
success:
  - 다수 참가자가 제거와 최종 선택을 관측 근거로 설명한다
failure:
  - 정답은 맞혀도 이유를 설명하지 못하거나 시스템 자동 연결만 따른다
stop:
  - 사건이 거짓 전조 또는 비관측 규칙에 의존하면 테스트 중단
```

정답률만 측정하지 않는다. 사고 과정, 근거 수정, 실패 귀인, 인과 이해를 함께 기록한다.

## 8. 적대적 검토

| Finding | 공격 | 판정 | 대응 |
|---|---|---|---|
| ADV-UL-01 | 보드가 정답 자동완성기가 된다. | MUST_FIX | 자동 연결을 제안으로 제한하고 최종 증명은 플레이어가 구성한다. |
| ADV-UL-02 | 자유도가 높아 문서 정리 노동이 된다. | SHOULD_FIX | 관계 종류를 3개로 제한하고 원문 복귀를 빠르게 한다. |
| ADV-UL-03 | 틀린 가설에 사후 규칙을 붙인다. | REJECT | 결과 전에 관측 가능한 규칙만 판정에 사용한다. |
| ADV-UL-04 | 실패 전진이 사실상 무벌점 정답 반복이다. | SHOULD_FIX | 위험 사례·시간·다음 사건 조건 등 기존 계약 안의 결과를 사용하되 숨은 정답 공개는 피한다. |
| ADV-UL-05 | Overboard!·Heaven's Vault 표면 구조를 복제한다. | REJECT | 증명·진전 원리만 4→2 규칙과 매뉴얼 기록에 맞게 변형한다. |
| ADV-UL-06 | 문서 검토를 신규 플레이어 검증으로 주장한다. | MUST_FIX | 실제 테스트 전 `POC_PASSED` 금지. |

## 9. 현재 결정에 미치는 영향

- CORE-MVP-001·저장 Schema·에피소드 데이터: `NO_CHANGE`.
- 후속 관측·가설·반박 보드: `PILOT_RECOMMENDATION`.
- ANNUAL-MVP-003 분기 콘텐츠: `NO_CHANGE / DEFERRED`.
- 신규 플레이어 검증: `NOT_RUN`.
- 구현 변경은 사람 검증과 사용자 승인 뒤 별도 PR로 분리한다.

## 10. 원출처

- https://www.gdcvault.com/play/1027723/The-Burden-of-Proof-Narrative
- https://www.gdcvault.com/play/1025149/-Heaven-s-Vault-Creating
- https://www.gdcvault.com/play/1023139/Level-
- https://www.gdcvault.com/play/1034415/System-Centric-Puzzle-Design-in

## 11. 실행 보고

```yaml
selected_skills:
  - managing-project-intake-and-work-contract
  - analyzing-and-refining-game-concepts
  - governing-game-user-research-coverage
  - urban-legend-investigation-case-authoring
  - running-adversarial-review-and-refinement
work_modes_used: PLAN -> REVIEW
protected_paths_changed: false
runtime_validation: NOT_APPLICABLE
human_validation: NOT_RUN
rollback: remove this research document and its planning index link
```