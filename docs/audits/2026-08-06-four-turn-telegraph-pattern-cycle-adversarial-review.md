# 4턴 전조·패턴 주기 적대적 검토

> Decision ID: `DEC-20260806-118-CANON-V2-FOUR-TURN-TELEGRAPH-PATTERN-CYCLE`
> 감사 일시: 2026-08-06 KST
> 범위: 회수 정본·Canon v2 패턴 데이터·`battle_scene.gd`·`game_state.gd`·테스트·저장/접근성 경계
> 결론: `APPROVED_WITH_RUNTIME_CONFLICT_CLASSIFIED`
> 구현: `IMPLEMENTATION_NOT_AUTHORIZED`
> 사람 검증: `HUMAN_QA_NOT_RUN`
> UI·접근성 검증: `UI_ACCESSIBILITY_NOT_RUN`
> 병합: `MERGE_NOT_AUTHORIZED`
> Draft PR: #151
> 기반 PR: PR #149

## 1. 감사 기준

승인된 주기:

```text
1턴: 전조 1 → 선택 → 평상 진행
2턴: 선택 → 전조 2 → 평상 진행
3턴: 선택 → 전조 3 → 평상 진행
4턴: 대응 선택 → 패턴 발현 → 결과 산출 → 평상 진행
```

핵심은 2턴과 3턴의 선택이 새 전조보다 먼저 확정되는 **비대칭 정보 구조**다.

## 2. 현행 runtime 감사

### `scripts/scenes/battle_scene.gd::_begin_recovery_turn()`

현행 흐름:

1. `GameState.select_next_recovery_pattern()`으로 완성 패턴 선택
2. 패턴의 단일 `telegraph` 즉시 표시
3. 가설·근거·대응 또는 직접 대응 입력 표시

판정: `LEGACY_RUNTIME_CONFLICT`

- 4턴 누적 주기가 없다.
- 2·3턴의 선택 선확정 구조가 없다.
- 한 전조를 본 직후 즉시 대응할 수 있다.
- 평상 선택과 전용 대응 선택이 분리되지 않는다.

### `scripts/scenes/battle_scene.gd::_select_pattern_response()`

현행 흐름:

1. 응답 ID와 `correct_response_id` 즉시 비교
2. 정답이면 안정도 증가
3. 오답이면 피해 처리
4. 결과 기록·저장
5. 다음 패턴 또는 `core_recovered`로 진행

판정: `LEGACY_RUNTIME_CONFLICT`

- 대응 선택 직후 패턴 발현 단계를 별도 상태로 보존하지 않는다.
- 1~3턴 평상 행동 이력을 결과 범위에 반영하지 않는다.
- 즉시 결과 산출로 인해 전조 누적 리듬이 성립하지 않는다.
- 다음 완성 패턴으로 바로 넘어간다.

### `scripts/core/game_state.gd::select_next_recovery_pattern()`

현행 함수는 미확인 패턴을 저작 순서로 고르고 이후 가중 무작위로 완성 패턴을 선택한다.

판정: `PARTIAL_CONCEPT / LEGACY_RUNTIME_CONFLICT`

- 패턴 ID 선택 개념은 재사용 가능하다.
- `pattern_cycle_id`, `cycle_turn`, `pending pattern 상태 없음`이다.
- 전조 공개 단계와 응답 가능 단계를 제어하지 않는다.
- 저장·불러오기 시 진행 중 전조 주기를 복원할 계약이 없다.

## 3. 현행 데이터 감사

저승역 Canon v2와 runtime projection은 패턴마다 다음을 가진다.

- 패턴 ID
- 단일 `telegraph`
- 질문
- 응답 목록
- 정답 응답 ID
- 근거 기록

판정: `DATA_MEANING_REUSABLE / SEQUENCE_SCHEMA_MISSING`

- 패턴과 대응 의미는 재사용할 수 있다.
- 현재는 **단일 telegraph** 중심이다.
- `ordered_telegraphs` 3개와 각 공개 시점이 없다.
- 전조 1·2·3의 개별 기능과 누적 논리를 검증하는 저작 계약이 없다.
- 단일 전조를 자동으로 세 문장으로 분할하면 의미 없는 중복이나 정답 누설이 발생할 수 있으므로 수동 저작·검수해야 한다.

## 4. 현행 상태·저장 감사

현재 GameState에는 다음 관련 상태가 있다.

- `current_recovery_pattern_id`
- `last_recovery_pattern_id`
- `confirmed_recovery_pattern_id`
- `seen_recovery_pattern_ids`
- `recovery_pattern_learning`

누락:

- `pattern_cycle_id`
- `cycle_turn 상태 없음`
- `pending pattern 상태 없음`
- `ordered_telegraphs`
- `revealed_telegraph_count`
- `normal_action_history`
- 전조 누적 원장 없음
- `response_choice`
- `manifestation_result`
- `next_cycle_state`

판정: `SAVE_SCHEMA_GAP / IMPLEMENTATION_NOT_AUTHORIZED`

## 5. 순서 공정성 적대 검토

### 위험 1 — 2·3턴 순서 왜곡

개발 편의를 위해 `전조→선택`으로 통일하면 사용자 승인과 다른 게임이 된다.

대응:

- 2턴과 3턴의 선택은 새 전조 공개 전에 확정한다.
- 전조 2·3은 이미 확정한 선택을 소급 변경하지 않는다.
- UI·로그·테스트에 턴별 순서를 별도 명시한다.

### 위험 2 — 선택 뒤 전조 공개가 불공정하게 느껴짐

전조 2·3이 “방금 선택이 틀렸음”을 뒤늦게 알려주는 처벌 장치가 되면 불공정하다.

대응:

- 새 전조는 이미 끝난 선택을 정답/오답으로 소급 판정하지 않는다.
- 전조 2는 3턴 이후 판단, 전조 3은 4턴 대응을 위한 근거다.
- 평상 선택의 현장 결과와 패턴 대응 정오를 분리한다.

### 위험 3 — 평상 선택이 의미 없는 대기 행동

정답이 4턴에만 결정된다는 이유로 1~3턴이 반복 공격이나 턴 넘기기가 될 수 있다.

대응:

- 평상 선택은 결과 피해 범위·보호·관찰·봉쇄·철수 준비에 영향을 준다.
- 평상 행동 반복만으로 자동 승리 금지다.
- 세부 효과는 다음 Decision에서 별도 승인한다.

## 6. 전조 품질 적대 검토

### 정답 누설

- 전조 1에서 정답을 사실상 확정하면 2·3턴이 무의미하다.
- 전조 3이 정답 버튼 문구를 직접 말하면 추론이 사라진다.

가드레일:

- 전조는 근거이지 정답 공개가 아니다.
- 각 전조는 개별적으로 의미가 있다.
- 세 전조를 함께 읽으면 조사 근거와 연결해 패턴을 구분할 수 있다.
- 전조 1에서 정답을 사실상 확정하지 않는다.
- 전조 3이 정답 문구를 직접 제시하지 않는다.

### 예고 없는 규칙

패턴 발현 때만 결정적 조건을 추가하면 플레이어는 대응할 수 없다.

가드레일:

- 예고되지 않은 결정적 규칙 금지.
- 패턴 발현은 이미 고정된 규칙을 시각화·실행한다.
- 패턴 발현은 선택 결과로 새로 생성되지 않는다.
- 평상 행동에 따라 패턴 정답을 바꾸지 않는다.

## 7. 조기 대응·입력 위험

- 4턴 전 대응 버튼이 보이면 플레이어가 세 전조를 기다릴 이유가 없다.
- 평상 선택과 대응 선택이 같은 버튼 그룹이면 책임이 혼동된다.
- 4턴 대응 후 추가 평상 선택을 넣으면 승인 순서와 결과 인과가 흐려진다.

가드레일:

- 4턴 전 조기 대응 금지.
- 1~3턴은 평상 선택, 4턴은 전용 대응 선택으로 화면 역할을 분리한다.
- 4턴에는 대응→발현→결과→평상 진행만 수행한다.

## 8. 저장·재개·중단 위험

### 저장·불러오기 재추첨

진행 중 저장을 반복해 유리한 전조나 패턴을 뽑는 문제가 생길 수 있다.

가드레일:

- 저장·불러오기 재추첨 금지.
- `pattern_cycle_id`, `pattern_id`, 전조 순서, 현재 턴, 평상 행동 이력을 복원한다.
- 결과 적용 전후를 구분해 중복 적용을 막는다.

### 중단된 주기

승인 철수·긴급 봉쇄·대상 소실 시 미발현 패턴을 억지로 성공/실패 판정할 위험이 있다.

가드레일:

- `중단된 주기` 상태와 이유를 기록한다.
- 공개된 전조와 행동 기록은 보존한다.
- 발현하지 않은 패턴 결과는 만들지 않는다.
- 진행 중 패턴을 다른 패턴으로 조용히 교체하지 않는다.

## 9. 접근성 위험

- 색상이나 음향만으로 전조를 구분하면 정보 순서를 잃는다.
- 모션 감소가 패턴 발현 정보를 삭제할 수 있다.
- 매뉴얼 확인에 행동 비용을 부과하면 읽기 지원이 패널티가 된다.

가드레일:

- 색상이나 음향만으로 전조 제공 금지.
- 텍스트·아이콘·형태를 기본으로 사용한다.
- 전조 1·2·3을 순서 고정 로그로 유지한다.
- 정적 패턴 발현 대체를 제공한다.
- 현행 규칙 스트립과 매뉴얼 열람은 행동 비용 없음이다.
- 접근성 등가 기능은 랭크 감점 금지다.

## 10. 테스트 누락

현재 자동 테스트는 패턴 ID·단일 전조·응답·정오·근거 기록과 migration 안전성을 검증한다. 다음은 미검증이다.

- 정확한 1~4턴 순서
- 2·3턴 선택 선확정
- 전조 공개 비소급성
- 4턴 전용 대응 잠금
- 세 전조 누적
- 평상 선택과 대응 선택 분리
- 패턴 고정과 발현 분리
- 결과 범위와 정답 분리
- 저장·재개 exact state
- 중단된 주기
- 전조 접근성 순서

## 11. 최종 판정

- 사용자 제시 4턴 주기는 프로젝트 코어와 정합하며 승인 가능하다.
- 기존 전조·패턴·근거 개념은 재사용 가능하다.
- 현행 `battle_scene.gd`의 즉시 단일 전조→대응→결과 흐름은 `LEGACY_RUNTIME_CONFLICT`다.
- 현행 데이터는 단일 전조이므로 세 전조 저작 Schema와 검수가 필요하다.
- runtime·저장 Schema·수치·아트·Human QA·병합은 승인되지 않았다.

최종 상태: `APPROVED_WITH_RUNTIME_CONFLICT_CLASSIFIED / IMPLEMENTATION_NOT_AUTHORIZED / HUMAN_QA_NOT_RUN / UI_ACCESSIBILITY_NOT_RUN / MERGE_NOT_AUTHORIZED`.
