---
name: urban-legend-engineering
description: Use for Urban Legend Godot and GDScript implementation, scene architecture, save compatibility, data contracts, and runtime integration.
---

# Urban Legend Engineering

> 공통 실행·DoR·DoD·보고·구조 개선 계약: `skills/disciplines/PROJECT_DISCIPLINE_CONTRACT.md`

## Purpose and boundary

승인된 게임·UX 계약을 가장 작은 end-to-end 변경으로 구현한다. 저장·진행·기존 ID와 사용자 변경을 보존하며 코드 편의로 설계를 재정의하지 않는다.

- Use: Godot Scene·Node·GDScript·Autoload·Resource, 저장·로더·상태 경계·ID 호환, 런타임 통합.
- Do not use: 규칙·서사·UI 방향만 설계, 구현 없는 PR 계획, L0 문서 수정.

## Modes

`implement → data-boundary → compatibility-review`

## Read first

1. AGENTS.md
2. `docs/CURRENT_STATUS.md`
3. `docs/PROJECT_CORE.md`
4. 관련 기획 원본·Issue·작업 계약
5. 실제 `scripts/`·`scenes/`·`data/`
6. project.godot
7. TEST_CHECKLIST.md

## Domain workflow

- 현재 구현·호출자·저장 포맷과 known-good baseline을 확인한다.
- 최소 구현 뒤 정적·Godot·저장 왕복·영향 플레이를 검증한다.

## Done and failure gate

- 범위 밖 리팩토링·새 상태 소유자가 없고 기존 저장·세 사건·주요 Scene 흐름이 유지된다.
- 적용 가능한 자동·런타임 검증과 미검증 위험을 분리한다.
- Failure: 보호 경로 무승인 변경, 저장 키·기존 ID 변경, 미니게임 중 저장, 사용자 변경 되돌리기, 검증 없는 완료 보고면 실패다.

## Selective support

런타임 원인은 `diagnosing-game-engine-runtime-failures`, 구조 개선은 `refactoring-with-contract-preservation`, diff·회귀는 `reviewing-and-validating-project-changes`, 전파는 `auditing-canonical-reference-freshness`.
