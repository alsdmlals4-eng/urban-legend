# 괴이기록국 · AI Indie Pattern Adoption — 2026-08-24

```yaml
status: USER_DIRECTED_ADAPTATION
work_mode: PLAN_REVIEW
runtime_mutation: NONE
source_base_merge: dff09d83c3892a70ba5fee86a59d36086889a6c5
current_planning_owner: docs/CURRENT_PLANNING_CANON.md
runtime_implementation: NOT_AUTHORIZED
human_qa: NOT_RUN
```

## 결론

괴이기록국은 이미 `성공·실패·미확정 → 기록/매뉴얼 → 다음 판단`이라는 강한 recovery 구조를 갖고 있다. 따라서 Slotbound식 랜덤 보상 회복을 새로 넣지 않는다.

이번 적용은 기존 **조사 불확실성의 agency와 실패 정보 환류**를 명시적으로 보호하고, production AI가 사건 Canon/가설/필수 단서를 침범하지 않게 하는 것이다.

## 판정

| Pattern | 판정 | 적용 |
|---|---|---|
| HUMAN_DIRECTED_AI_BUILD_LOOP | ADOPT_HIGH | 사건/대사/UI 후보는 AI가 보조해도 인간이 Canon·인과·공포 감각 승인 |
| SILENT_OMISSION_GATE | ADOPT_HIGH | 원시 관찰/가설/반증/구출/회수/복합결과/매뉴얼 consumer 누락 검사 |
| CONTEXT_SCOPE_AND_ARCHITECTURE_BUDGET | ADOPT | 사건별 rule owner와 월간 cadence/result owner 분리 유지 |
| BREADTH_AFTER_CORE_IDENTITY_LOCK | ADOPT | M01/M04 Human evidence 전 사건/변형 대량 생산 금지 |
| PLAYER_FEEDBACK_REBUILD_LOOP | ADOPT_HIGH | 조사 실패가 추리 실패인지 UI/정보 실패인지 분리 |
| AI_VISIBLE_OUTPUT_QUALITY_GATE | ADOPT_HIGH | 생성 이미지/음성/문구도 soft-anime-noir/dossier/rights/readability Gate 동일 적용 |
| RNG_AGENCY_AND_RECOVERY | ADAPT_EXISTING | `EVIDENCE_AND_CONSEQUENCE_RECOVERY`로 해석 |
| runtime generative AI | REJECT_CURRENT | 핵심 진실/Canon/상태를 생성형 모델에 맡기지 않음 |

## EVIDENCE_AND_CONSEQUENCE_RECOVERY

현재 정본의 규칙을 다음 설계 렌즈로 고정한다.

```text
관측
→ 경쟁 가설
→ 선택/행동
→ 성공 | 실패 | 미확정
→ 관측 가능한 결과/반증/위험 사례
→ 매뉴얼 및 기록 갱신
→ 다음 조사/재출동 판단
```

핵심은 실패를 보상으로 바꾸는 것이 아니라 **실패가 무엇을 의미했는지 추론할 수 있게 하는 것**이다.

### 금지

- 필수 진실을 단일 RNG 성공에 잠그기.
- 잘못된 가설을 눌렀다는 이유만으로 핵심 단서를 영구 삭제.
- AI가 미관측 진실이나 정답을 대신 제공.
- 실패를 즉시 무료 undo하여 인과를 지움.
- 모든 실패에 자동 힌트를 지급해 추리를 무력화.

## Human Feedback 분류

```text
GOOD_UNCERTAINTY
= 정보가 제한되어 고민하지만 결과를 보고 왜 틀렸는지/무엇이 남았는지 이해

BAD_OPACITY
= 필요한 정보가 화면/문구/흐름 때문에 보이지 않아 틀림

BAD_RANDOM_GATE
= 필수 진실이 운 때문에 차단됨

CORE_DEDUCTION_FAILURE
= 정보는 충분하지만 가설·반증 구조 자체가 의미 있는 추리를 만들지 못함
```

수정 우선순위:

```text
관측/해석 분리와 cue
→ 반증 가시성
→ UI progressive disclosure
→ 사건별 정보 구조
→ 마지막에만 core deduction 구조 재검토
```

## 생산 AI 보호 계약

AI가 사건 후보를 만들 때 매번 다음을 공격한다.

- 원시 관찰과 해석이 섞였는가.
- 정답 가설만 그럴듯하고 오답은 허수아비인가.
- 오답에 관측 가능한 반증이 있는가.
- 피해자 구출과 회수 결과가 서로 덮어쓰이는가.
- 공격 반복이 정답이 되는가.
- 사건 고유 질문/피해자 갈등/봉쇄 조건이 공용 템플릿에 묻히는가.
- M01/M04 역할을 서로 복제하는가.

## Breadth Gate

M01 First Session과 M04 release-near slice에서 다음이 Human 검증되기 전에는 AI로 M01~M12 사건 수를 빠르게 채우는 것을 성과로 보지 않는다.

- 관측→가설→반증의 인과 이해.
- 구출과 회수의 역할 구분.
- 실패/미확정이 다음 판단으로 환류.
- 사건 환경/증거가 화면의 주체로 읽힘.
- 복합 결과가 단일 rank보다 이해 가능함.

## 다음 Codex/QA 소비

1. current runtime reconciliation 뒤 M01/M04에 observation/hypothesis/contradiction/result trace 검증.
2. 사건 결과 packet에서 실패·미확정 provenance 보존 여부 테스트.
3. Human QA에 GOOD_UNCERTAINTY vs BAD_OPACITY 질문 추가.
4. 생성형 runtime AI는 별도 Decision 전 구현 금지.

## IRG

현재 주장 가능: 기존 planning canon 안의 실패/정보 환류를 Base pattern과 연결해 보호 계약으로 명시함.

현재 주장 불가: runtime implementation, M01/M04 Human QA, 생성형 AI 조사 시스템, product reference asset 승인.

## 적대적 검토 5회

1. RNG reward를 사건에 억지로 추가하지 않음: PASS.
2. 필수 진실 단일 RNG 금지 보존: PASS.
3. 실패가 자동 정답 힌트로 변질되지 않음: PASS.
4. M01/M04 검증 전 breadth 차단: PASS.
5. runtime authorization/Human evidence 과장 없음: PASS.

`CLEAN_REVIEW_EXIT`.
