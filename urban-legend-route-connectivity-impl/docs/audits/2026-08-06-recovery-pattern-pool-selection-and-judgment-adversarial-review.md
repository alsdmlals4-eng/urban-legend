# 회수 패턴 풀 선택·판단 적대적 검토

> Decision ID: `DEC-20260806-119-CANON-V2-RECOVERY-PATTERN-POOL-SELECTION-AND-JUDGMENT`
> 감사 일시: 2026-08-06 KST
> 범위: 권위 문서·Episode/PoC·Canon v2 sidecar/projection·로더·`battle_scene.gd`·`game_state.gd`·저장·결과·테스트
> 결론: `APPROVED_CURRENT_FLOW_WITH_SELECTION_GUARDRAILS`
> 구현: `IMPLEMENTATION_NOT_AUTHORIZED`
> 사람 검증: `HUMAN_QA_NOT_RUN`
> UI·접근성 검증: `UI_ACCESSIBILITY_NOT_RUN`
> 병합: `MERGE_NOT_AUTHORIZED`
> Draft PR: #151
> 기반 PR: PR #149

## 1. 감사 기준

승인된 패턴 판단 단위는 다음과 같다.

```text
괴이별 패턴 풀
→ 유효 후보
→ 완성된 패턴 하나 선택
→ 단일 전조 공개
→ 가설
→ 근거
→ 대응
→ 즉시 정오 판정
→ 안정도 또는 피해
→ 선택 이유와 결과 인과 기록
→ 다음 패턴 또는 회수 종결
```

전역 고정 턴 수 없음이 기준이며 Decision 118의 고정 4턴은 계속 철회 상태다.

## 2. 권위 문서 감사

### `docs/GAME_DESIGN_DOCUMENT.md`

회수는 전조 확인→행동 선택→괴이 반응→안정화·봉쇄·위험 사례 누적 흐름을 사용한다. 패턴 수나 전역 턴 수를 고정하지 않는다.

### `docs/VALIDATION_TARGET_CANON.md`

각 패턴을 전조→분류/가설→관련 기록 연결→대응→현장 결과→추론 검증의 완결 판단 단위로 다룬다.

### Decision 117

보호·관찰·대응·공격·장비·봉쇄·후퇴와 다중 회수 결과 범위를 승인했지만, 정확한 패턴 수·턴 수·가중치·조건 Schema는 승인하지 않았다.

판정: `AUTHORITY_ALIGNED`.

## 3. Episode·Canon v2 데이터 감사

기본 Episode의 `recovery_patterns`는 다음 의미를 가진 완성 패턴이다.

- `id`, `order`, `name`
- 단일 `telegraph`
- 설명·질문·매뉴얼 초안
- 관련 단서
- 복수 대응
- `correct_response_id`
- 오대응 이유
- 선택적 `weight`와 효과

Canon v2 sidecar의 `recovery_encounters.patterns`도 독립 패턴과 전조 이벤트·대응을 연결한다. Runtime projection은 이를 단일 전조·복수 대응·정답을 가진 완성 패턴으로 변환한다.

### 확인된 장점

- 괴이별 패턴 풀 구조가 이미 존재한다.
- 같은 괴이의 여러 규칙을 독립 패턴으로 저작할 수 있다.
- 전조와 근거·정답의 연결을 데이터에서 감사할 수 있다.

### 확인된 위험

- 일부 사건에서 가중치가 생략되거나 의도 없이 편중될 수 있다.
- 패턴별 조건을 추가할 경우 로더와 선택기가 동일한 조건 의미를 사용해야 한다.
- 단순 문구 차이를 별도 패턴으로 늘리면 패턴 풀이 커져도 실제 판단 다양성은 늘지 않는다.

판정: `DATA_MODEL_ALIGNED / AUTHORING_QA_REQUIRED`.

## 4. 로더 감사

`episode_loader.gd`는 기본 Episode를 읽으며, 명시적인 content contract 요청에서만 Canon v2 로더를 사용한다.

`afterlife_canon_v2_loader.gd`는 다음을 검증한다.

- canonical pattern ID와 runtime pattern ID의 일치
- 단일 전조·질문·설명 존재
- 관련 기록 ID의 유효성
- 복수 대응과 canonical `correct_response_id`
- 정답 대응의 근거 존재

세 전조 누적이나 고정 턴을 요구하지 않는다.

### 갭

- 선택적 패턴 조건과 가중치의 범위·형식·편향 검증은 최종 계약이 아니다.
- 후보 제외 이유를 로더가 설명 가능한 형태로 유지할지 미확정이다.

판정: `LOADER_ALIGNED / OPTIONAL_SELECTION_METADATA_NOT_FINAL`.

## 5. `GameState.select_next_recovery_pattern()` 감사

코드 주석과 흐름은 **미관측 패턴을 저작 순서로 우선**한 뒤 가중 무작위와 즉시 반복 방지를 수행한다고 명시한다.

확인된 의미:

1. 패턴 풀이 비어 있으면 빈 결과를 반환한다.
2. `seen_recovery_pattern_ids`에 없는 패턴을 분리한다.
3. 미관측 패턴이 있으면 저작 순서를 기준으로 먼저 선택한다.
4. 모든 패턴을 확인한 뒤에는 직전 패턴을 가능한 후보에서 제외한다.
5. 남은 후보에서 사건별 가중치를 사용한다.
6. 후보가 하나뿐이면 같은 패턴이 재등장할 수 있다.

이는 순수 고정 순서 금지와 완전 무작위 금지를 동시에 만족하는 혼합 구조다.

### 적대적 위험

#### 위험 A — 즉시 반복 회피가 후보를 모두 제거

후보가 하나인데 무조건 직전 패턴을 제거하면 선택 불능이 된다.

가드레일:

- 유효 후보가 둘 이상일 때만 즉시 반복 회피를 적용한다.
- 하나뿐이면 `sole_valid_candidate` 이유로 반복을 허용한다.

#### 위험 B — 높은 가중치가 다른 패턴을 사실상 굶김

가중치가 과도하면 전체 경험 이후 특정 패턴만 반복될 수 있다.

가드레일:

- 첫 경험은 가중치와 무관하게 미관측 패턴을 저작 순서로 우선한다.
- Human QA와 seed 기반 분포 테스트로 반복 편향을 확인한다.
- 정확한 수치 범위는 구현 승인에서 결정한다.

#### 위험 C — 조건이 숨은 정답 변경처럼 작동

플레이어에게 보이지 않는 조건으로 동일 패턴의 정답을 바꾸면 규칙 학습이 붕괴한다.

가드레일:

- 조건은 패턴의 유효 후보 여부만 결정한다.
- 같은 `pattern_id`의 `correct_response_id`를 상태에 따라 바꾸지 않는다.
- 다른 정답은 별도 variant pattern_id로 저작한다.

판정: `CURRENT_SELECTOR_ALIGNED / CONDITION_AND_REASON_LOGGING_GAP`.

## 6. `battle_scene.gd` 판단 흐름 감사

### `_begin_recovery_turn()`

- 완성된 패턴 하나를 선택한다.
- 단일 전조 공개를 수행한다.
- 필요한 경우 가설과 근거를 선택하게 한다.
- 대응 목록을 연다.

### `_select_pattern_response()`

- 선택 대응을 현재 패턴의 `correct_response_id`와 즉시 비교한다.
- 정답이면 안정도 증가를 적용한다.
- 오답이면 피해와 위험 사례를 처리한다.
- 판단 기록을 저장하고 다음 패턴 또는 회수 종결로 이동한다.

### 불변성 판정

- 전조 공개 전에 패턴을 확정한다.
- 판정이 끝날 때까지 같은 pattern_id를 사용한다.
- 대응에 따라 패턴을 교체하지 않는다.
- 결과 산출 전에 다음 패턴을 뽑지 않는다.

판정: `RUNTIME_JUDGMENT_FLOW_ALIGNED`.

## 7. 전조·근거 공정성 감사

### 위험 D — 전조가 정답 버튼을 그대로 말함

전조는 정답 공개가 아니다. 정답 버튼을 직접 지시하면 조사 기록을 적용하는 재미가 사라진다.

### 위험 E — 전조와 기록으로 알 수 없는 숨은 조건

판정 순간에만 예고되지 않은 결정적 조건이 추가되면 공정한 추론이 불가능하다.

가드레일:

- 조사 기록과 괴이 매뉴얼을 사용해 대응을 추론할 수 있어야 한다.
- 예고되지 않은 결정적 조건 금지다.
- 오대응 이유를 관측·기록·규칙 충돌로 설명한다.
- 색상·음향만으로 전달 금지다.
- 매뉴얼 열람은 행동 비용 없음이다.

판정: `FAIRNESS_CONTRACT_REQUIRED / CONTENT_HUMAN_QA_NOT_RUN`.

## 8. 반복 패턴·variant 감사

같은 패턴이 재등장할 때 같은 규칙과 정답을 유지해야 한다.

- 현장 상태는 결과 범위·피해·보호·안정화 품질을 바꿀 수 있다.
- 현장 상태는 패턴 정답을 바꾸지 않는다.
- 다른 전조와 다른 정답을 가진 변형은 별도 variant pattern_id로 분리한다.
- 저장된 학습 기록은 variant를 서로 다른 규칙 사례로 구분해야 한다.

### 위험 F — 난이도를 높인다는 이유로 같은 ID의 정답 변경

가드레일:

- 숨은 정답 변경 금지.
- 선택 이유와 결과 인과를 기록한다.
- variant는 별도 ID와 독립 근거를 갖는다.

판정: `RULE_IDENTITY_GUARDRAIL_APPROVED`.

## 9. 상태·저장 감사

현행 관련 상태:

- `current_recovery_pattern_id`
- `last_recovery_pattern_id`
- `seen_recovery_pattern_ids`
- `confirmed_recovery_pattern_id`
- `recovery_pattern_learning`

사건 보고서와 학습 상태가 제공하는 의미상 `recovery_pattern_history`에는 가설·근거·대응·정오·이유·시도 정보가 축적된다.

### 승인된 재사용 방향

- 현재·직전·관측·확인 패턴 상태를 유지한다.
- 선택 이유와 후보 제외 이유를 추가 감사 정보로 남긴다.
- 진행 중 저장을 지원한다면 활성 패턴과 판단 단계를 복원한다.
- 저장·불러오기 재추첨 금지다.
- 결과 중복 적용 금지다.

고정 주기가 아니므로 `cycle_turn 요구 없음`, `ordered_telegraphs 요구 없음`이다.

판정: `EXISTING_STATE_REUSABLE / SELECTION_CAUSE_CHAIN_NOT_EXPLICIT`.

## 10. 결과 화면과 종결 감사

`result_scene.gd`는 다음을 설명한다.

- 회수 결과
- 패턴 가설·선택 근거·대응
- 검증 규칙·후보 규칙·위험 사례
- 사건 보고서와 저장 상태

개별 패턴 판단 기록은 현재 구조에 적합하다.

그러나 최종 종결은 여전히 `core_recovered` 중심의 `LEGACY_SINGLE_OUTCOME`이다. 이는 패턴 선택 문제와 별개의 실제 다음 갭이다.

판정: `PATTERN_EXPLANATION_ALIGNED / LEGACY_SINGLE_OUTCOME`.

## 11. 테스트 감사

기존 테스트가 다루는 항목:

- 패턴 ID·단일 전조·응답·정답·관련 기록 완전성
- 미관측 패턴 선택과 반복 처리
- 안정도 증가와 오대응 피해
- Canon v2 projection과 근거 연결
- migration·rollback·idempotency
- 결과와 위험 사례 저장

추가가 필요한 구현 테스트:

- 유효 후보 필터
- 후보가 하나일 때 반복 허용
- 가중치 분포와 starvation 방지
- 선택 이유 기록
- 전조 공개 뒤 패턴·정답 불변
- 진행 중 저장·불러오기 재추첨 금지
- 별도 variant pattern_id 강제
- 오대응 이유와 결과 인과 기록

## 12. 최종 판정

- 사용자가 설명한 실제 구조와 현행 프로젝트의 패턴 판단 단위는 일치한다.
- 미관측 저작 순서 우선 + 전체 경험 후 가중 선택 + 즉시 반복 회피를 권장 정본으로 승인한다.
- 유효 조건과 선택 이유 기록은 후속 구현 갭으로 남긴다.
- 같은 패턴의 규칙·정답은 반복 시 불변이며 다른 정답은 별도 variant ID를 사용한다.
- 고정 4턴·세 전조 누적·`cycle_turn`·`ordered_telegraphs`는 요구하지 않는다.
- runtime·Scene·Episode JSON·저장 Schema·수치·Human QA·병합은 승인하지 않았다.

최종 상태:
`APPROVED_CURRENT_FLOW_WITH_SELECTION_GUARDRAILS / IMPLEMENTATION_NOT_AUTHORIZED / HUMAN_QA_NOT_RUN / UI_ACCESSIBILITY_NOT_RUN / BATCH_MERGE_NOT_STARTED / MERGE_NOT_AUTHORIZED`.
