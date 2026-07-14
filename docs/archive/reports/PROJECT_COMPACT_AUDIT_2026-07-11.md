# Project Compact Audit

점검일: 2026-07-11

## Active Context

- Goal: 외부 스킬의 재사용 가능한 원칙을 Base와 도시괴담 기록국 규칙에 반영하고 다음 개선 작업을 압축한다.
- Player value: PC/Steam 데모를 안정적으로 검수하고 문서·도구 절차 때문에 구현 맥락을 잃지 않는다.
- Decisions: 외부 플러그인은 설치하지 않음. HTML 대시보드는 기본 산출물에서 제외. 최소 스킬 라우팅과 phase-boundary compact 사용.
- Scope: 규칙 문서, GitHub 상태, Godot 설정·코드 구조 감사.
- Excluded: 게임 동작, 저장 스키마, episode data, UI 재설계 추가 변경.
- Risks: PC 16:9 기준과 실제 viewport 충돌, 완료 Issue 미정리, PR #26 문서 충돌, 자동 회귀 테스트 부재.
- Next verification: MVP-029에서 16:9 viewport 변경 후 메인→두 사건 전체 흐름과 저장/이어하기를 격리된 테스트 저장으로 확인.

## 우선 수정

### P0. PC 기준과 viewport 일치

- 해결(2026-07-11): MVP-029~030에서 기본 viewport를 `1280x720`으로 변경하고 메인/현장 판정 16:9 화면을 확인했다.
- 근거: `project.godot`의 viewport가 `540x960`, UI 스크립트는 최소 폭 `960`, 문서는 PC 16:9를 기준으로 한다.
- 영향: 실행 첫 화면이 세로 기준으로 열리거나 가로 UI가 잘리고 스크롤에 의존할 수 있다.
- 권장: MVP-029에서 기본 viewport를 `1280x720` 이상 16:9로 변경하고 창 모드·전체화면 스크린샷을 비교한다.
- 제외: 이번 규칙 작업에서 게임 설정을 즉시 바꾸지 않는다.

### P0. GitHub 완료 상태 정리

- Issue #31은 MVP-028 구현 커밋 이후에도 열려 있다. 수동 16:9 확인 결과를 코멘트한 뒤 완료 기준 체크와 close 여부를 결정한다.
- PR #26 `docs: add agentic GitHub workflow templates`는 mergeable=false이며 `DOCUMENTATION_MAP.md` 등 이번 변경과 겹친다. 그대로 merge하지 말고 최신 main 기준으로 필요한 문서/템플릿만 재검토한다.
- 이전 MVP Issue도 열린 상태가 많다. `완료`, `후속 검증 필요`, `예약`을 구분해 backlog를 줄인다.

### P1. 용어와 README 현재화

- 일부 해결(2026-07-11): 메인 소개, 현재 버전, 런타임 `전투` 내비게이션을 현재 용어로 수정했다. README의 과거 MVP 구현 일지는 이력으로 유지한다.
- `README.md`에 `전투씬`, `플레이어 1명 vs 괴담`, `placeholder` 설명이 현재 회수/안정화·요원 팀 기준과 충돌한다.
- `case_data_scene.gd` 내비게이션의 `전투` 표기도 남아 있다.
- 권장: 런타임 용어 변경과 역사 문서 보존을 분리한다. 현재 사용법·체크리스트만 `회수/안정화`로 고치고, 내부 호환 id인 `battle_scene`, `battle_clue_effects`는 당장 rename하지 않는다.

### P1. 회귀 검증 seam 추가

- 현재 자동 unit test 파일이 없다. headless scene load는 parse/load 오류만 잡고 두 사건의 상태 전이를 검증하지 못한다.
- 우선 seam: `CaseData`의 clue collection/resolution, `GameState` save round-trip, 두 episode의 필수 JSON 계약.
- 권장: 새 프레임워크보다 Godot headless에서 실행 가능한 작은 test scene 또는 script부터 추가한다.
- 저장 테스트는 실제 `user://urban_legend_save.json`을 덮어쓰지 않는 격리 경로를 먼저 설계한다.

## 구조 개선 후보

### P2. 큰 스크립트 분리

- `scripts/core/game_state.gd`: 약 2,106줄. episode, agent, investigation, recovery, report, save 책임이 한 autoload에 모여 있다.
- `investigation_scene.gd`, `battle_scene.gd`, `dialogue_scene.gd`: UI 생성과 게임 흐름·문구 조합을 함께 담당한다.
- 지금 분리하면 회귀 위험이 크다. 먼저 위 test seam을 만든 뒤 `save/report`와 순수 formatting helper부터 작은 단위로 추출한다.

### P2. 코드 생성 UI의 시각 검증

- `.tscn`은 script 연결만 갖고 대부분의 layout이 GDScript에서 생성된다.
- 장점: 빠른 프로토타이핑. 단점: editor에서 16:9 hierarchy와 overflow를 보기 어렵다.
- 권장: MVP-029에서 모든 UI를 갈아엎지 않고, 반복 section helper 유지 + 핵심 화면 screenshot baseline부터 만든다. 안정된 화면만 이후 `.tscn`으로 이동한다.

## Compact 후보

- 읽기 순서: `DOCUMENTATION_MAP.md`를 단일 source로 두고 다른 문서는 링크만 유지한다.
- 스킬 설명: `AI_SKILL_ADOPTION_GUIDE.md`를 canonical source로 두고 Superpowers/Harness/Serena 설치 설명을 여러 문서에 반복하지 않는다.
- HTML 대시보드: active workflow에서 제거하고 과거 기록 문구 한 줄만 유지한다.
- Goal: Issue·로드맵·공통 규칙의 전문을 반복하지 않고 파일 경로, 이번 결정, 완료 기준, 검증 명령만 둔다.
- README: 현재 실행법과 역사적 MVP 로그를 분리한다. 첫 100줄에는 현재 기준만 남기고 과거 구현 일지는 별도 history 문서로 이동하는 안을 검토한다.
- GitHub commit: `2.8ver`, `mvp27` 대신 `MVP-028: align dialogue investigation recovery UX`처럼 변경 가치가 검색되는 이름을 사용한다.

## 다음 작업 제안

MVP-029 QA를 하나의 Issue로 진행한다.

```text
16:9 기본 viewport 정렬
→ README/런타임 회수 용어 정리
→ 두 episode JSON 계약 test
→ 저장 round-trip 격리 test
→ main/preparation/dialogue/investigation/recovery/result/DB 전체 플레이
→ Issue #31 close 및 PR #26 처리
```
