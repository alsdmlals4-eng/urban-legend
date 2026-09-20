---
name: urban-legend-production-pm
description: Use for Urban Legend scope, roadmap, issue, dependency, priority, milestone, pull-request, and handoff planning grounded in actual state.
---

# Urban Legend Production·PM

> 공통 실행·DoR·DoD·보고·구조 개선 계약: `skills/disciplines/PROJECT_DISCIPLINE_CONTRACT.md`

## Purpose and boundary

계획 문서는 구현 완료를 가장하지 않는다. 현재 구현·승인 계획·진행 중 작업·차단 위험·다음 진입점을 분리하고 검증 가능한 결과 단위로 순서화한다.

- Use: MVP·Issue·PR 범위·우선순위·의존성, 여러 분야 순서·milestone·gate·handoff, 상태 불일치 감사.
- Do not use: 일반 요청 계약만 작성, 실제 코드·데이터 구현, 저장소가 안 바뀐 단순 대화 요약.

## Modes

`scope → sequence → status-review → production-handoff`

## Read first

먼저 `AGENTS.md`의 공통 읽기 순서를 따른다. 아래는 해당 분야 작업의 추가 자료이며 과거 planning 문서는 현재 결정이 인용할 때만 사용한다.

1. `docs/PROJECT_CORE.md`
2. MVP_ROADMAP.md
3. `docs/planning/ROADMAP_AND_HANDOFF.md`
4. 현재 Issue·PR·브랜치·Actions
5. `docs/DOCUMENTATION_MAP.md`
6. TEST_CHECKLIST.md

## Domain workflow

- 구현·계획·진행 PR을 분리하고 결과 단위·의존성·보호 경로·위험을 지도화한다.
- BUILD 승인 범위에서만 Issue·PR·Roadmap·gate·rollback·handoff를 동기화한다. status-review는 차이를 보고하고 외부/파일 쓰기를 하지 않는다.

## Done and failure gate

- 각 작업이 독립 검증·롤백 가능하고 PR base·head·stack·병합 순서가 명확하다.
- 다음 담당자가 책임 원본과 첫 행동을 찾을 수 있다.
- Failure: 문서 존재를 구현 완료로 표시, 차단 PR 위 후속 발행, 보호·검증 없는 일정 확정, 과도한 병렬화면 실패다.

## Selective support

요청 계약은 `managing-project-intake-and-work-contract`, 긴 작업은 `maintaining-long-running-task-continuity`, Git 상태는 `synchronizing-local-and-github-state`, Handoff는 `maintaining-project-context-and-handoff`.
