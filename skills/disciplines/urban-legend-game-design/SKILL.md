---
name: urban-legend-game-design
description: Use for Urban Legend investigation, rule deduction, stabilization, minigame, campaign, balance, and player-choice design grounded in the current GDD and implemented systems.
---

# Urban Legend Game Design

> 공통 실행·DoR·DoD·보고·구조 개선 계약: `skills/disciplines/PROJECT_DISCIPLINE_CONTRACT.md`

## Purpose and boundary

괴이는 처치 대상이 아니라 규칙을 조사하고 현재 출현을 안정화할 현상이다. 시스템은 관찰·판단·선택을 대신하지 않고 실패도 다음 판단 근거를 남긴다.

- Use: 조사·판단·안정화·잔향 회수, 미니게임, 캠페인, 보상·비용·난이도·수치 설계와 검수.
- Do not use: 시장 전략, 승인 규칙의 순수 구현, UI 미감 감사.

## Modes

`system-design → rule-change → balance-review`

## Read first

1. `docs/CURRENT_STATUS.md`
2. `docs/PROJECT_CORE.md`
3. `docs/GAME_DESIGN_DOCUMENT.md`
4. `docs/MINIGAME_SYSTEM_SPEC.md`
5. MVP_ROADMAP.md
6. 실제 `data/`·`scripts/`·`scenes/`
7. TEST_CHECKLIST.md

## Domain workflow

- 입력·상태·선택·출력·실패 복구와 플레이어 정보 경계를 정의한다.
- 대표·변형·실패 경로에서 수치·정보량·반복 가치를 검수한다.

## Done and failure gate

- 규칙·UI 설명·데이터·코드가 같은 상태 모델을 사용한다.
- 실패가 학습 가능한 위험 사례를 남기고 기존 세 사건·저장을 보존한다.
- Failure: HP·공격·처치 중심 변질, 요원·아카의 정답 대체, 미니게임 중 저장, 근거 없는 수치 변경이면 실패다.

## Selective support

컨셉은 `analyzing-and-refining-game-concepts`, 코어 영향은 `identifying-project-core`, 공격 검토는 `running-adversarial-review-and-refinement`, diff 증거는 `reviewing-and-validating-project-changes`.
