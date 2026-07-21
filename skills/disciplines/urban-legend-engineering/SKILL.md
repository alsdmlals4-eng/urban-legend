---
name: urban-legend-engineering
description: Use for Urban Legend Godot and GDScript implementation, scene architecture, save compatibility, data contracts, and runtime integration within the project's protected boundaries.
---

# Urban Legend Engineering

## Core principle

승인된 게임·UX 계약을 가장 작은 end-to-end 변경으로 구현한다. 저장·진행·기존 ID와 사용자 변경을 보존하며, 코드 편의로 설계를 재정의하지 않는다.

## Use when

- Godot Scene·Node·GDScript·Autoload·Resource를 구현하거나 수정한다.
- 저장·불러오기, 데이터 로더, 상태 경계와 기존 ID 호환을 다룬다.
- 여러 코드·데이터·Scene을 연결하는 런타임 통합을 수행한다.

## Do not use when

- 게임 규칙·서사·UI 방향만 설계한다.
- 구현 없이 PR·로드맵만 계획한다.
- 단순 문서 오탈자다.

## Skill modes

- `implement`: 승인된 기능을 최소 변경으로 구현한다.
- `data-boundary`: 저장·JSON·상태 소유권·ID 호환을 설계·수정한다.
- `compatibility-review`: 기존 저장·Scene·호출자·플레이 경로의 회귀를 검수한다.

## Required inputs and read first

1. `AGENTS.md`
2. `docs/CURRENT_STATUS.md`
3. 관련 기획 책임 원본과 Issue·작업 계약
4. 실제 대상 `scripts/`·`scenes/`·`data/` 파일
5. `project.godot`
6. `TEST_CHECKLIST.md`

## Workflow

```text
현재 구현·호출자·저장 포맷 확인
→ 범위·보호 경로·롤백·완료 기준 확정
→ 가장 작은 end-to-end 변경 구현
→ 정적·데이터·Godot headless 검증
→ 영향 플레이·저장 왕복·회귀 검증
→ 문서 갱신 필요 심사와 결과 보고
```

## Definition of Ready

- 승인된 기능 계약과 영향 파일이 명확하다.
- 저장·기존 ID·보호 경로 위험이 식별됐다.
- 테스트와 사용자 확인 순서가 있다.

## Definition of Done

- 요청 범위 밖 리팩터링과 새 상태 소유자를 만들지 않는다.
- 기존 저장·세 사건·주요 Scene 흐름을 보존한다.
- 자동 검사와 적용 가능한 런타임 검증이 통과한다.
- 테스트하지 못한 항목과 남은 위험을 분리 보고한다.

## Validation and failure conditions

- `git diff --check`, JSON, Godot headless, 대상 테스트, 저장 왕복과 영향 플레이 경로를 실행한다.
- `scripts/core/game_state.gd`, `data/episodes/`, `project.godot`, `knowledge/base-pack/`을 승인 없이 변경하면 실패다.
- 저장 키·기존 ID 변경, 미니게임 중 저장, 정상 사용자 변경 되돌리기, 검증 없는 완료 보고는 실패다.

## Related skills

- 설계: `urban-legend-game-design`
- UX 계약: `urban-legend-ux-ui-accessibility`
- 변경 검증: `reviewing-and-validating-project-changes`
- 참조 전파: `auditing-canonical-reference-freshness`
- 학습 기록: `skills/SKILL_LEARNING_LOG.md`
