# 회수 패턴 권위·데이터·실행 전수 재감사

> 감사 일시: 2026-08-06 KST
> 원인: 사용자의 예시를 고정 4턴 규칙으로 잘못 승격한 Decision 118 철회
> 결론: `FIXED_FOUR_TURN_RETRACTED / CURRENT_PATTERN_FLOW_CONFIRMED`
> 최신 활성 승인: `DEC-20260805-117-CANON-V2-RESCUE-MINIGAME-AND-RETRIEVAL-RULE-COVERAGE`
> 구현: `IMPLEMENTATION_NOT_AUTHORIZED`
> 사람 검증: `HUMAN_QA_NOT_RUN`
> UI·접근성 검증: `UI_ACCESSIBILITY_NOT_RUN`
> 배치 병합: `BATCH_MERGE_NOT_STARTED`
> 병합: `MERGE_NOT_AUTHORIZED`

## 1. 최종 교정 결론

회수 페이즈에는 고정된 전역 턴 수가 없다. 4턴은 예시일 뿐 전역 규칙이 아니다.

현행 제품의 패턴별 전조·판단 단위는 다음과 같다.

```text
괴이가 가진 패턴 집합
→ 완성된 패턴 하나 선택
→ 단일 전조 공개
→ 가설 선택
→ 관련 근거 선택
→ 대응 선택
→ 즉시 정오 판정
→ 정답: 안정도 증가 / 오답: 피해·위험 사례
→ 판단·학습 기록
→ 다음 패턴 또는 회수 종결
```

패턴 수와 회수 길이는 사건과 괴이가 저작한 패턴 수, 이미 본 패턴, 안정화 조건, 현장 상태에 따라 달라진다. 고정 4턴, 전조 세 개 누적, 4턴 전용 대응창은 승인된 제품 계약이 아니다.

## 2. 권위 문서

### `docs/GAME_DESIGN_DOCUMENT.md`

현행 회수 기본 흐름은 `전조 확인 → 행동 선택 → 괴이 반응 → 안정화·봉쇄·위험 사례 누적`이다.

- 전조는 현재 발현 중인 패턴을 읽기 위한 관측 정보다.
- 행동은 보호·관찰·규칙 대응·공격·장비·봉쇄·후퇴 범주를 사용한다.
- 공격은 억제·약화·대응 창구 확보 수단이며 반복 공격만으로 기본 승리하지 않는다.
- 회수의 최종 제품 목표는 안정화·봉쇄·잔향 회수·승인 철수 등 다중 결과지만, 턴 수를 고정하지 않는다.

### `docs/VALIDATION_TARGET_CANON.md`

저승역 Validation의 패턴 회수는 각 패턴마다 다음 짧은 추론 사슬을 검증한다.

```text
전조
→ 패턴 분류/가설
→ 관련 기록 연결
→ 중립 대응 선택
→ 현장 결과
→ 추론 검증
```

여기서 패턴 하나가 하나의 판단 단위다. 여러 전조를 고정 턴에 나눠 공개하는 전역 구조가 아니다.

### `DEC-20260805-117`

Decision 117은 회수에서 보호·관찰·대응·공격·장비·봉쇄·후퇴와 다중 종결 범위를 요구한다. 정확한 턴 수·행동 비용·패턴 개수는 승인하지 않았다. `core_recovered` 단일 결과는 최종 제품 계약이 아니라 구형 호환 상태로 분류한다.

## 3. 사건 데이터

### 기본 Episode JSON

`data/episodes/episode_001_afterlife_station.json` 등 사건 데이터는 괴이별 `recovery_patterns` 배열을 가진다.

완성된 패턴 레코드는 일반적으로 다음을 포함한다.

- `id`, `order`, `name`
- 단일 `telegraph`
- `description`, `question`, `manual_draft`
- `related_clue_ids`
- 복수 `responses`
- `correct_response_id`
- `failure_reason`
- 선택적으로 `weight`, 능력/안정도 효과

즉 데이터 단위부터 `완성된 패턴 하나 + 단일 전조 + 복수 대응 + 정답` 구조다.

### PoC 데이터와 현행 데이터 구분

`data/poc/core_mvp_001/afterlife_station_poc.json`에는 `recovery_sequence`, `min_recovery_turns`, `max_recovery_turns`가 있다. 이는 초기 PoC/Validation 범위를 제한하기 위한 실험 데이터다.

이 값을 현행 모든 괴이에 적용되는 전역 턴 규칙으로 승격하면 안 된다. PoC의 시퀀스·턴 범위와 현행 Episode의 패턴 풀 선택은 권위 수준과 용도가 다르다.

## 4. Canon v2와 runtime projection

### Canon v2 sidecar

`episode_001_afterlife_station_canon_v2.json`의 `recovery_encounters`는 괴이가 가진 패턴 집합을 정의한다.

- 패턴마다 하나의 `telegraph_event_ids`
- 패턴에 연결된 `response_ids`
- 별도 `telegraph_events`
- 별도 `response_outcomes`

저승역 Canon v2는 세 개의 서로 다른 패턴을 갖지만, 이것은 전조 1·2·3을 한 패턴에 누적한다는 뜻이 아니다. 각각 독립된 패턴과 전조다.

### Canon v2 runtime projection

`episode_001_afterlife_station_canon_v2_runtime_projection.json`은 각 canonical encounter를 현행 runtime이 소비할 완성 패턴으로 투영한다.

각 투영 패턴은 다음을 포함한다.

- 하나의 `telegraph`
- 질문·설명·매뉴얼 초안
- 관련 단서
- 복수 대응
- `correct_response_id`
- 실패 이유

### 로더

`scripts/data/episode_loader.gd`는 기본 Episode를 읽고, 명시적으로 content contract를 요청한 경우에만 Canon v2 로더를 사용한다. Canon v2가 기본 경로에 암묵적으로 섞이지 않는다.

`scripts/data/afterlife_canon_v2_loader.gd`는 base·legacy validation overlay·canonical sidecar·runtime projection을 검증한 뒤, 구형 `recovery_patterns` 권위를 제거하고 검증된 projection의 패턴 배열을 주입한다.

검증기는 패턴 ID, 단일 `telegraph`, 질문·설명, 관련 기록, 복수 응답, canonical `correct_response_id`, 정답 응답의 근거를 확인한다. 세 전조 배열이나 고정 턴 수를 요구하지 않는다.

## 5. `battle_scene.gd`

### 패턴 시작

`_begin_recovery_turn()`은 `GameState.select_next_recovery_pattern()`에서 완성된 패턴 하나를 받는다.

- 패턴의 단일 전조를 UI에 공개한다.
- 가설 단계가 있으면 가설을 먼저 고르게 한다.
- 선택 가설에 따라 근거 선택 단계로 이동한다.
- 근거 확인 뒤 대응 목록을 연다.
- 간소 패턴은 필요한 경우 바로 대응 단계로 갈 수 있다.

이 함수명에 `turn`이 들어가지만, 하나의 고정 4턴 주기 중 첫 턴을 의미하지 않는다. 회수 전투의 다음 패턴 판정 단위를 시작한다는 의미다.

### 대응 판정

`_select_pattern_response()`은 선택한 응답 ID를 현재 패턴의 `correct_response_id`와 즉시 비교한다.

- 정답이면 패턴의 안정도 증가를 적용한다.
- 오답이면 요원 피해·위험 사례를 처리한다.
- 가설·근거·대응·이유를 `GameState.record_recovery_pattern_outcome()`에 기록한다.
- 필요한 저장을 수행한다.
- 안정화 기준에 도달하지 않았으면 다음 패턴을 시작한다.

따라서 현행 `battle_scene.gd`는 사용자가 설명한 실제 구조와 정합한다. 이전 감사의 `LEGACY_RUNTIME_CONFLICT` 판정은 잘못된 4턴 전제에서 나온 것이므로 철회한다.

## 6. `GameState`

`GameState.select_next_recovery_pattern()`은 현재 괴이의 패턴 집합에서 완성 패턴을 고른다.

- 아직 보지 않은 패턴이 있으면 미관측 패턴을 저작 순서로 우선 선택한다.
- 모든 패턴을 본 뒤에는 가능한 경우 직전 패턴 반복 회피를 적용한다.
- 이후 후보에서 선택해 반복 플레이가 같은 패턴만 고정적으로 순환하지 않게 한다.

`record_recovery_pattern_outcome()`은 패턴 ID·선택 가설·근거·대응·정오·이유·시도 기록을 학습/보고 상태에 남긴다.

현재 의미 상태는 “진행 중인 완성 패턴과 그 판단 기록” 중심이다. 고정 4턴용 `cycle_turn`, `ordered_telegraphs`, `revealed_telegraph_count`가 없는 것은 누락이 아니라 승인되지 않은 구조를 구현하지 않은 정상 상태다.

## 7. 저장·마이그레이션

현행 저장은 회수 결과·패턴 학습·확인 패턴·위험 사례 등 현재 실행이 필요로 하는 상태를 보존한다.

Canon v2 migration 계층은 다음을 분리한다.

- 구형 save inspection
- ID migration registry
- payload migration
- transaction prepare/commit/finalize/rollback
- runtime 적용 실패 시 rollback
- Canon v2 content contract와 migration history 저장

`scripts/core/afterlife_migrating_game_state.gd`는 mvp-038/039 저장을 mvp-040으로 옮기고, 기존 세이브의 권위가 새 Canon v2 정답을 자동 확정하지 않도록 migrated-unverified 상태를 검증한다.

고정 4턴의 턴 번호·전조 순서 저장 요구는 승인되지 않았으므로 추가하지 않는다. 향후 패턴 판정 중간 저장을 제품 요구로 채택할지는 별도 GrillMe와 구현 설계가 필요하다.

## 8. `result_scene.gd`

결과 화면은 다음을 소비한다.

- 회수/안정화 등급
- 피해자 구조·후일담
- 잔향 회수 상태
- 사건 보고서의 `recovery_result`
- 수집 단서와 미니게임 기록
- 괴이 매뉴얼의 검증 규칙·후보·위험 사례
- 판단의 가설·선택 근거·대응
- 저장 상태

즉 결과 화면도 개별 패턴에서 축적된 가설·근거·대응 기록을 설명하는 구조다.

현재 종결은 안정도 기준 뒤 `core_recovered` 중심으로 이어지는 `LEGACY_SINGLE_OUTCOME` 한계가 있다. 이는 Decision 117이 지적한 다중 종결 미구현 문제이며, 고정 4턴 여부와는 별개다.

## 9. 자동 테스트

현행 테스트는 다음을 검증한다.

- Episode 패턴 레코드의 ID·전조·응답·정답·관련 단서 완전성
- 미관측 패턴 우선과 패턴 선택
- 가설·근거·대응 결과 기록
- 안정도 증가와 오대응 피해
- Canon v2 sidecar와 runtime projection의 ID·근거 연결
- 구형 권위 키 제거와 projection 주입
- save migration의 exact/incompatible/fatal 경계
- rollback과 idempotency
- 결과 보고서와 회수 결과 저장

기존 테스트는 고정 네 턴을 요구하지 않는다. 이번 교정 계약은 향후 예시가 전역 제품 규칙으로 승격되는 것을 방지한다.

## 10. 남아 있는 실제 갭

고정 4턴이 없다는 것은 현행 회수가 최종 완성됐다는 뜻이 아니다.

### 실제 유지 갭

1. `core_recovered` 중심 `LEGACY_SINGLE_OUTCOME`을 안정화·봉쇄·잔향·긴급 봉쇄·승인 철수·실패로 확장.
2. 구출 결과 패킷의 보호 의무와 초기 조건을 회수 결과에 구조적으로 연결.
3. 보호·관찰·대응·공격·장비·봉쇄·후퇴의 행동 책임과 비용 확정.
4. 패턴 선택 빈도·반복 피로·가설/근거 단계의 길이를 Human QA로 검증.
5. 사건별 패턴 풀이 각 괴이의 규칙을 충분히 구분하는지 저작 검수.
6. 결과 화면이 구출과 회수의 독립 결과·원인 사슬을 모두 설명하도록 확장.

### 잘못 생성된 갭 — 철회

- 모든 패턴에 전조 세 개 필요
- 모든 회수가 네 턴 고정
- 4턴 전 대응 금지
- `pattern_cycle_id`와 `cycle_turn` 필수
- 현행 단일 전조 runtime을 구조적 충돌로 분류

## 11. 재발 방지

- 사용자가 제시한 순서·수치는 예시인지 전역 규칙인지 먼저 권위 문서와 데이터에서 대조한다.
- `battle_scene.gd` 한 파일만 보고 설계를 확정하지 않고 권위→데이터→로더→Scene→GameState→저장→결과→테스트를 추적한다.
- 사용자 승인 문구가 이전 질문의 권장안과 새 보충 설명 중 무엇을 가리키는지 분리한다.
- 모호한 보충 설명을 새 Decision으로 승격하지 않는다.
- 철회된 Decision은 삭제해 숨기지 않고 `NOT_ACTIVE_AUTHORITY`로 보존한다.

## 12. 최종 판정

- Decision 118: `RETRACTED_MISINTERPRETATION / NOT_USER_APPROVED / NOT_ACTIVE_AUTHORITY`
- Batch 3: `3_OF_10`
- 실제 회수 패턴 구조: `CURRENT_PATTERN_FLOW_CONFIRMED`
- 현행 단일 전조·즉시 판단 runtime: 사용자 설명과 정합
- `core_recovered`: `LEGACY_SINGLE_OUTCOME`, 후속 다중 결과 설계 필요
- 제품 구현·Schema·수치·아트·Human QA·병합: 미승인

최종 상태:
`IMPLEMENTATION_NOT_AUTHORIZED / HUMAN_QA_NOT_RUN / UI_ACCESSIBILITY_NOT_RUN / BATCH_MERGE_NOT_STARTED / MERGE_NOT_AUTHORIZED`
