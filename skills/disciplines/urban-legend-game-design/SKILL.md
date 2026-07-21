---
name: urban-legend-game-design
description: Use for Urban Legend investigation, rule deduction, stabilization, minigame, campaign, balance, and player-choice design grounded in the current GDD and implemented systems.
---

# Urban Legend Game Design

## Core principle

괴이는 처치 대상이 아니라 규칙을 조사하고 현재 출현을 안정화할 현상이다. 시스템은 플레이어의 관찰·판단·선택을 대신하지 않고, 실패도 다음 판단 근거를 남겨야 한다.

## Use when

- 조사·판단·안정화·잔향 회수 루프를 설계하거나 수정한다.
- 미니게임 규칙, 캠페인 흐름, 보상·비용·난이도·수치를 조정한다.
- 플레이어 선택과 결과의 페어플레이·가독성·반복 가치를 검토한다.

## Do not use when

- 시장·경쟁작·핵심 컨셉 자체를 새로 정의하는 전략 조사다.
- 승인된 규칙을 코드로 옮기는 순수 구현 작업이다.
- UI 시각 결과만 감사한다.

## Skill modes

- `system-design`: 핵심 루프·상태·입출력·플레이어 선택을 설계한다.
- `rule-change`: 기존 규칙·수치·캠페인 계약을 영향 지도와 함께 수정한다.
- `balance-review`: 대표·변형·실패 경로에서 난이도·보상·정보량을 검수한다.

## Required inputs and read first

1. `docs/CURRENT_STATUS.md`
2. `docs/GAME_DESIGN_DOCUMENT.md`
3. `docs/MINIGAME_SYSTEM_SPEC.md`
4. `MVP_ROADMAP.md`
5. 실제 `data/`·`scripts/`·`scenes/` 대상 파일
6. `TEST_CHECKLIST.md`

## Workflow

```text
플레이어 가치·현재 구현·불변 조건 확인
→ 입력·상태·선택·출력·실패 복구 정의
→ 포함·제외 범위와 수치 근거 확정
→ 실제 데이터·코드 경계와 대조
→ 대표·변형·실패 경로 검증
→ GDD·Roadmap·Test 갱신 심사
```

## Definition of Ready

- 해결할 플레이어 문제와 관찰 가능한 완료 기준이 있다.
- 저장·캠페인·경제·엔딩·기존 ID 위험을 식별했다.
- 현재 구현과 승인 계획을 구분했다.

## Definition of Done

- 규칙과 UI 설명, 데이터, 코드가 같은 상태 모델을 사용한다.
- 실패가 진행 차단만 만들지 않고 학습 가능한 근거를 남긴다.
- 기존 세 사건과 저장 호환성을 회귀 검증한다.
- 미실행 플레이·밸런스 검증은 `NOT_RUN`으로 기록한다.

## Validation and failure conditions

- JSON·정적 검사·Godot headless·영향 플레이 경로를 범위에 맞게 실행한다.
- HP·공격·처치 중심으로 변질, 요원·아카가 정답 대체, 미니게임 중 저장, 근거 없는 수치 변경이면 실패다.

## Related skills

- 컨셉·PoC: `analyzing-and-refining-game-concepts`
- Vertical Slice: `designing-vertical-slices`
- 구현: `urban-legend-engineering`
- 변경 검증: `reviewing-and-validating-project-changes`
- 학습 기록: `skills/SKILL_LEARNING_LOG.md`
