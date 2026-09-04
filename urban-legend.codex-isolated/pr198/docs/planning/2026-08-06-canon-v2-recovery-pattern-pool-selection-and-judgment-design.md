# Canon v2 회수 패턴 풀 선택·판단 설계

> Decision ID: `DEC-20260806-119-CANON-V2-RECOVERY-PATTERN-POOL-SELECTION-AND-JUDGMENT`
> 상태: `APPROVED_DESIGN_BASELINE`
> GrillMe Batch 3: `4_OF_10`
> 구현: `IMPLEMENTATION_NOT_AUTHORIZED`
> 사람 검증: `HUMAN_QA_NOT_RUN`
> UI·접근성 검증: `UI_ACCESSIBILITY_NOT_RUN`
> 병합: `MERGE_NOT_AUTHORIZED`
> 기반 작업: Draft PR #149 위 Draft PR #151

## 1. 목표

괴이마다 고유한 규칙을 가진 **괴이별 패턴 풀**을 사용하면서도 첫 경험은 학습 가능하고, 반복 플레이는 기계적인 고정 순환이나 운 나쁜 연속 중복을 피하도록 한다.

한 패턴 판단은 다음의 완결 단위다.

```text
완성된 패턴 하나 선택
→ 단일 전조 공개
→ 가설
→ 근거
→ 대응
→ 즉시 정오 판정
→ 안정도 또는 피해
→ 기록
→ 다음 패턴 또는 회수 종결
```

전역 고정 턴 수 없음이 기본이다.

## 2. 검토한 접근

### A. 완전 고정 순서

모든 플레이에서 `order`만 따라 패턴을 반복한다.

- 장점: 저작·테스트가 단순하고 학습 순서를 정확히 통제한다.
- 문제: 재플레이가 예측 가능해지고, 동일한 패턴 순환이 콘텐츠의 생명력을 빠르게 소모한다.
- 판정: 첫 노출에만 일부 사용하고 전체 방식으로는 기각한다. 순수 고정 순서 금지다.

### B. 완전 무작위

첫 패턴부터 모든 후보 중 무작위 선택한다.

- 장점: 구현이 단순하고 표면적 변화가 크다.
- 문제: 핵심 규칙을 못 보고 같은 패턴만 반복할 수 있으며, 사건 난이도와 정보 순서가 운에 좌우된다.
- 판정: 기각한다. 완전 무작위 금지다.

### C. 권장 — 미관측 저작 순서 + 반복 가중 선택

- 첫 경험: 미관측 패턴을 저작 순서로 우선.
- 전체 경험 뒤: 유효 후보를 계산하고 즉시 반복 회피 후 사건별 가중치 선택.
- 후보가 하나뿐이면 반복을 허용하되 이유를 기록.

학습 보장과 반복 다양성을 동시에 확보하므로 채택한다.

## 3. 구성 요소

### 3.1 패턴 풀

한 사건·괴이가 소유한 완성 패턴 목록이다. 각 패턴은 최소한 다음 의미를 가진다.

- 고유 `pattern_id`
- 저작 순서
- 단일 전조
- 질문 또는 판단 맥락
- 관련 조사 기록
- 대응 목록
- `correct_response_id`
- 정답·오답 결과와 오대응 이유
- 선택적 가중치와 유효 조건

정확한 JSON Schema는 구현 승인 전까지 확정하지 않는다.

### 3.2 후보 계산기

현재 사건 상태에서 선택 가능한 **유효 후보**를 만든다.

입력 의미:

- 괴이별 패턴 풀
- 이미 본 패턴
- 직전 패턴
- 사건 플래그와 확보 기록
- 구출 결과에서 인계된 보호 의무·현장 상태
- 패턴별 선택 조건이 존재할 경우 그 조건

출력 의미:

- 선택 가능한 완성 패턴 목록
- 후보 제외 이유
- 후보가 없을 때의 명시적 상태

숨은 난수로 후보 자격을 바꾸지 않는다.

### 3.3 선택기

의사 흐름은 다음과 같다.

```text
valid_candidates = filter(pattern_pool, authored_conditions, field_state)

if valid_candidates is empty:
    return explicit_no_valid_pattern_state

unseen = valid_candidates not in seen_recovery_pattern_ids
if unseen is not empty:
    return first by authored order, then stable id

repeat_candidates = valid_candidates
if repeat_candidates has more than one item:
    remove last_recovery_pattern_id

return weighted choice using case-authored weight or equal default
```

핵심 계약:

- **미관측 패턴을 저작 순서로 우선**한다.
- **모든 패턴을 확인한 뒤**에는 즉시 반복 회피를 적용한다.
- 남은 후보에서 사건별 가중치를 사용한다.
- 유효 후보가 하나면 반복을 허용한다.

### 3.4 판단 세션

선택기가 패턴을 반환하면 전조 공개 전에 패턴을 확정한다.

- 판단이 끝날 때까지 같은 pattern_id를 유지한다.
- `correct_response_id`도 함께 고정한다.
- 가설·근거·대응에 따라 패턴을 교체하지 않는다.
- 결과 처리 전에 다음 패턴을 뽑지 않는다.

판단 세션 흐름:

```text
PATTERN_SELECTED
→ TELEGRAPH_REVEALED
→ HYPOTHESIS_SELECTED
→ EVIDENCE_LINKED
→ RESPONSE_SELECTED
→ JUDGED
→ OUTCOME_RECORDED
→ NEXT_PATTERN_OR_RECOVERY_RESULT
```

화면상 가설·근거를 한 화면에 합칠 수는 있지만, 결과 기록에는 무엇을 근거로 어떤 대응을 선택했는지 남긴다.

## 4. 반복과 variant

같은 패턴이 재등장하면 같은 규칙과 정답을 유지한다.

- 체력·보호·안정도·장비·구출 의무는 현장 결과 범위를 바꿀 수 있다.
- 현장 상태는 결과 범위만 바꾸며 패턴 정답을 바꾸지 않는다.
- 다른 정답이 필요한 변형은 별도 variant pattern_id로 분리한다.
- 별도 variant pattern_id는 독립 전조·근거·대응·정답을 가져야 한다.

이 규칙은 플레이어가 같은 전조에 대해 이전과 반대 답을 강요받는 숨은 규칙 변경을 막는다.

## 5. 전조와 근거 공정성

전조는 정답 공개가 아니다. 다만 조사 기록과 괴이 매뉴얼을 이용하면 합리적으로 답할 수 있어야 한다.

- 전조는 현재 발현 패턴의 관측 특징을 명확히 전달한다.
- 결정적인 규칙은 이전 조사 기록이나 현재 규칙 스트립에서 확인 가능하다.
- 예고되지 않은 결정적 조건 금지다.
- 오대응 이유를 기록해 학습 가능한 실패로 만든다.
- 색상·음향만으로 전달 금지다.
- 매뉴얼 열람은 행동 비용 없음이다.
- 접근성 대체 표현·입력은 랭크 감점이나 정답 변경을 만들지 않는다.

## 6. 상태와 저장

현행 상태를 중심으로 설계한다.

- `current_recovery_pattern_id`
- `last_recovery_pattern_id`
- `seen_recovery_pattern_ids`
- `confirmed_recovery_pattern_id`
- `recovery_pattern_history`

추가로 필요한 의미는 선택 이유와 결과 인과다.

```text
selection_reason
eligible_candidate_ids
excluded_candidate_reasons
selected_pattern_id
judgment_stage
selected_hypothesis
selected_evidence_ids
selected_response_id
judgment_result
outcome_cause_chain
```

이는 의미 모델이며 정확한 저장 키 승인안이 아니다.

진행 중 저장을 제공한다면:

- 현재 패턴과 판단 단계를 복원한다.
- 저장·불러오기 재추첨 금지다.
- 이미 기록한 결과를 중복 적용하지 않는다.
- 무효화된 패턴은 중단·취소로 기록한다.

고정 주기 구조가 아니므로 `cycle_turn` 요구 없음, `ordered_telegraphs` 요구 없음이다.

## 7. 오류 처리

### 유효 후보 없음

- 무관한 패턴을 임의 선택하지 않는다.
- 정상적인 종결 조건이라면 회수 결과 판정으로 이동한다.
- 승인 철수·대상 소실이면 중단 이유를 기록한다.
- 데이터 누락이면 명시적 저작 오류로 보고한다.

### 유일 후보 반복

- 같은 패턴이 재등장할 수 있다.
- 선택 이유를 `sole_valid_candidate` 의미로 기록한다.
- 반복 자체를 숨기지 않는다.

### 조건이 실행 중 변함

- 전조 공개 전에 패턴을 확정한 후에는 판정 종료까지 유지한다.
- 객관적으로 패턴이 무효가 되면 중단·취소한다.
- 다른 패턴으로 조용히 교체하지 않는다.

## 8. 콘텐츠 저작 기준

전역 최소 패턴 수를 고정하지 않는다. 각 괴이별 패턴 풀은 다음 질문에 답할 수 있어야 한다.

- 괴이의 대표 규칙을 서로 다른 관측으로 적용하는가.
- 조사 기록을 회수 행동으로 전환하게 하는가.
- 오대응이 왜 틀렸는지 설명 가능한가.
- 패턴끼리 단순 문구 교체가 아니라 규칙·판단 차이가 있는가.
- 반복 노출에도 정답 일관성이 유지되는가.
- 공격만 반복해 자동 승리할 수 없게 하는가.

## 9. 현행 프로젝트 적용 판정

### 정합

- Episode 데이터는 완성 패턴과 단일 전조·복수 대응·정답을 가진다.
- Canon v2 sidecar와 runtime projection도 독립된 완성 패턴을 제공한다.
- `battle_scene.gd`는 단일 패턴 판단 흐름을 수행한다.
- `GameState.select_next_recovery_pattern()`은 미관측 저작 순서 우선, 이후 가중 무작위, 즉시 반복 회피를 수행한다.
- 결과 기록은 가설·근거·대응·정오·위험 사례를 보존한다.

### 부분 갭

- 조건부 유효 후보를 패턴 선택기에 연결하는 최종 계약은 미완료다.
- 선택 이유와 제외 이유를 결과·저장에 명시적으로 남기는지 불충분하다.
- 사건별 `weight` 저작 품질과 편향을 검증하는 자동 테스트가 부족하다.
- 진행 중 판단 저장·재개의 정확한 범위가 미승인이다.
- 반복 피로와 학습 순서는 Human QA가 필요하다.
- 종결은 여전히 `LEGACY_SINGLE_OUTCOME` 중심이다.

## 10. 테스트 계획

### 문서 계약

- Decision·설계·감사·Batch 원장이 같은 ID와 `4_OF_10`을 사용한다.
- 철회 Decision 118은 계속 `RETRACTED / NON_COUNTING`이어야 한다.
- 고정 전역 턴 수를 다시 요구하지 않는다.

### 후속 구현 테스트 후보

- 미관측 패턴 저작 순서 우선
- 전체 확인 뒤 직전 패턴 회피
- 가중치 분포의 결정론적 seed 테스트
- 유효 후보 하나일 때 반복 허용
- 후보 없음의 명시적 처리
- 전조 공개 뒤 패턴·정답 불변
- 저장·불러오기 재추첨 금지
- variant ID 분리
- 오대응 이유와 선택 이유 기록

## 11. 경계

제품 runtime·Scene·Episode JSON·저장 Schema·자산·수치를 변경하지 않는다.

`IMPLEMENTATION_NOT_AUTHORIZED / HUMAN_QA_NOT_RUN / UI_ACCESSIBILITY_NOT_RUN / BATCH_MERGE_NOT_STARTED / MERGE_NOT_AUTHORIZED`를 유지한다.
