# D-2026-08-11-GAMEPLAY-MAIN-MENU-SAFE-RETURN-CONTINUE

## Decision

주요 gameplay 화면에서 플레이어가 일관되게 canonical Main Menu로 이동할 수 있게 한다.

승인 방향은 다음과 같다.

- Main Menu 진입 전에 현재 gameplay의 **안전한 resume checkpoint**를 저장한다.
- Main Menu 진입 자체가 저장된 gameplay 목적지를 `main_menu.tscn`으로 덮어쓰지 않는다.
- Main Menu의 기존 `Continue`는 저장 파일을 다시 읽고 저장된 gameplay scene/checkpoint를 재개한다.
- 현재 저장 스키마가 보존하지 않는 순간 입력, 타이머, 프레임 단위 UI 상태를 frame-perfect로 복원한다고 약속하지 않는다.
- 각 gameplay scene은 자기 상태를 손실·중복·악용 없이 재구성할 수 있는 checkpoint를 제공해야 하며, 안전 저장이 실패하면 Main Menu로 이동하지 않는다.

## Relationship

이 결정은 `D-2026-08-09-MAIN-MENU-CONTROL-ROOM-VERSIONING`의 **gameplay 진입/복귀 계약을 확장**한다.

기존 Main Menu의 시각 계층, `Ver 4.3` 목표, 관제실형 레이아웃 의미를 대체하거나 다시 승인하지 않는다.

## Existing-Solution-First

현재 제품의 저장/복귀 권위는 계속 `GameState`와 Main Menu `Continue`가 소유한다.

- `GameState.save_game()` / `load_game()`을 우회하는 두 번째 save system을 만들지 않는다.
- Main Menu의 `_continue_saved_game()` 경로를 가능한 한 그대로 재사용한다.
- gameplay→Main Menu를 위해 별도 back-stack, 별도 세이브 파일, 별도 autoload를 기본안으로 추가하지 않는다.
- scene별 transient state가 기존 save payload로 충분하지 않은 경우에만 최소 checkpoint schema를 확장한다.

## UX Contract

1. 주요 gameplay surface에는 동일 의미의 `메인 메뉴` 진입점이 존재한다.
2. 플레이어가 진입점을 선택하면 저장/일시중단 결과를 이해할 수 있는 명확한 confirmation을 본다.
3. blocking confirmation, 결과 확정, 거래/소비 처리처럼 중복 실행 위험이 있는 상태에서는 현재 작업을 먼저 안전하게 확정 또는 취소해야 한다.
4. 안전 checkpoint 작성과 저장이 성공한 뒤에만 Main Menu로 이동한다.
5. 저장 실패 시 현재 gameplay scene에 남고 실패 원인을 표시한다.
6. Continue는 마지막으로 성공 저장된 gameplay checkpoint를 연다.
7. resume 후 일회성 보상, 소비 아이템, RNG 결과, campaign day 진행이 중복 적용되어서는 안 된다.

## Persistence Boundary

- Legacy main save와 Validation session save의 격리 계약을 유지한다.
- gameplay menu suspend가 Validation/POC 경로의 별도 persistence 권위를 침범하지 않는다.
- Main Menu 진입은 campaign operation의 의미를 자동으로 `suspend_campaign_operation()` 또는 Preparation 복귀로 바꾸지 않는다. 그런 의미 변경은 기존 HQ 복귀와 구분한다.

## Current Evidence

- 현재 Main Menu `Continue`는 `GameState.load_game()` 후 `get_current_scene_path()`를 읽어 해당 scene으로 이동한다.
- 현재 save payload는 scene path, dialogue/field 위치, minigame id/results, 조사·회수·요원·피해자·campaign 상태 등 많은 정본 상태를 저장한다.
- 조사 화면의 기존 `HQ 복귀`는 `suspend_campaign_operation()` 후 저장 scene을 Preparation으로 바꾸므로 이 Decision의 same-gameplay resume 의미와 동일하지 않다.
- 회수전의 기존 utility `메뉴` 버튼은 generic scene navigation을 사용해 저장 scene을 Main Menu로 덮어쓰므로 Continue 계약과 충돌한다.
- 회수전과 진행 중 미니게임에는 save payload에 직접 없는 scene-local 상태가 존재하므로 단순 scene change만으로는 안전한 resume를 보장할 수 없다.

## Acceptance Boundary

구현 완료를 선언하려면 최소한 다음을 증명해야 한다.

- 지원 대상 gameplay scene 각각에서 menu suspend → Main Menu → Continue → 허용된 checkpoint 복귀가 성공한다.
- save failure는 navigation을 차단한다.
- Main Menu 진입이 saved resume scene을 Main Menu로 오염시키지 않는다.
- blocking modal/confirmation이 열려 있는 동안 click-through 또는 중복 transition이 발생하지 않는다.
- minigame/battle 재개에서 일회성 효과·보상·RNG·campaign progression이 중복되지 않는다.
- 기존 Main Menu 새 게임/Continue/Validation 진입 의미가 회귀하지 않는다.
- 자동 검증과 별도로 실제 Windows mouse/keyboard Human QA를 수행하기 전에는 Human PASS를 선언하지 않는다.

## Authority / Implementation Gate

- 사용자 승인: 2026-08-11, 권장안 A 승인.
- GitHub 추적: Issue #181 comment `5246232405`.
- Google Sheet: `02_현재_확정결정` row 104, 동일 Decision ID.
- Planning baseline: project `main` `cba130ee156c89710d3ddef33ed677bf99aa0716`.
- Persistent Godot product authoring은 `UL-DEC-AUTHORITY-001`에 따라 HiGodot 권위를 사용한다.
- Design/plan/test-only 작업이 완료되어도 runtime 구현 또는 Human QA가 자동 승인되는 것은 아니다.
