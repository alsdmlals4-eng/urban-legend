---
name: urban-legend-production-pm
description: Use for Urban Legend scope, roadmap, issue, dependency, priority, milestone, pull-request, and handoff planning grounded in the current implementation state and protected project contracts.
---

# Urban Legend Production·PM

## Core principle

계획 문서는 구현 완료를 가장하지 않는다. 현재 구현, 승인 계획, 진행 중 작업, 차단 위험과 다음 진입점을 분리하고 작은 검증 가능한 결과 단위로 순서를 정한다.

## Use when

- MVP·Issue·PR의 목표·범위·우선순위·의존성을 설계한다.
- 여러 분야 작업을 순서화하고 milestone·gate·handoff를 관리한다.
- 현재 상태와 계획 문서의 불일치를 감사한다.

## Do not use when

- 사용자 요청의 일반 계약만 만들면 되는 경우다.
- 실제 코드·데이터 구현을 수행한다.
- 저장소 상태가 바뀌지 않은 단순 대화 요약이다.

## Skill modes

- `scope`: 플레이어 가치·포함·제외·완료 기준·위험을 작업 계약으로 만든다.
- `sequence`: 결과 단위·의존성·병렬 가능 범위·gate를 정한다.
- `status-review`: 구현·계획·PR·문서 상태를 대조한다.
- `production-handoff`: 다음 담당자가 재질문 없이 시작할 최소 상태와 진입점을 남긴다.

## Required inputs and read first

1. `docs/CURRENT_STATUS.md`
2. `MVP_ROADMAP.md`
3. `docs/planning/ROADMAP_AND_HANDOFF.md`
4. 현재 Issue·PR·브랜치·Actions 상태
5. `docs/DOCUMENTATION_MAP.md`
6. `TEST_CHECKLIST.md`

## Workflow

```text
현재 구현·승인 계획·진행 중 PR 분리
→ 플레이어 가치와 완료 기준 확정
→ 결과 단위·의존성·보호 경로·위험 지도 작성
→ Issue·PR·Roadmap 상태 동기화
→ gate·검증·rollback·handoff 정의
→ 완료 시 실제 결과와 다음 진입점 갱신
```

## Definition of Ready

- 현재 기준선과 사용자 결정이 확인됐다.
- 목표·포함·제외·완료 기준·영향 파일·검증이 있다.
- 선행 작업과 차단 위험이 명확하다.

## Definition of Done

- 계획과 실제 구현 상태가 분리돼 표시된다.
- 각 작업 단위가 독립적으로 검증·롤백 가능하다.
- PR base·head·stack 의존성과 병합 순서가 명확하다.
- 다음 담당자가 책임 원본과 첫 행동을 찾을 수 있다.

## Validation and failure conditions

- Current Status·Roadmap·Issue·PR·Actions·changed files를 교차 대조한다.
- 문서 존재를 구현 완료로 표시, 차단 PR 위에 후속 작업 발행, 보호 경로·검증 없는 일정 확정, 과도한 병렬화면 실패다.

## Related skills

- 요청 계약·분해: `managing-project-intake-and-work-contract`
- Handoff 압축: `maintaining-project-context-and-handoff`
- 변경 검증: `reviewing-and-validating-project-changes`
- 운영체계 검수: `managing-game-project-operating-system`
- 학습 기록: `skills/SKILL_LEARNING_LOG.md`
