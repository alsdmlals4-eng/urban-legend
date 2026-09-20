---
name: urban-legend-qa
description: Use for Urban Legend test planning, regression, defect triage, evidence capture, and release-gate decisions tied to actual contracts.
---

# Urban Legend QA

> 공통 실행·DoR·DoD·보고·구조 개선 계약: `skills/disciplines/PROJECT_DISCIPLINE_CONTRACT.md`

## Purpose and boundary

검증은 “문제가 없어 보임”이 아니라 승인 계약과 실제 증거를 연결한다. 실행하지 않은 검사·사람 확인·권한은 통과로 보고하지 않는다.

- Use: 테스트 계획·회귀 범위, 결함 재현·분류·우선순위, 캡처·로그·Actions·Godot 기반 release gate.
- Do not use: 변경 없는 아이디어 비교, 전문 UI 미감 감사, 계획 없이 체크박스 채우기.

## Modes

`plan → execute → defect-triage → visual-qa-and-approval → repository-wide-audit → bca-adoption-audit → release-gate`

## Read first

먼저 `AGENTS.md`의 공통 읽기 순서를 따른다. 아래는 해당 분야 작업의 추가 자료이며 과거 planning 문서는 현재 결정이 인용할 때만 사용한다.

1. `docs/PROJECT_CORE.md`
2. TEST_CHECKLIST.md
3. `docs/MVP_WORKFLOW_CHECKLIST.md`
4. 현재 Issue·PR·완료 기준
5. 실제 diff·테스트·저장·Scene·데이터·캡처

## Domain workflow

- 완료 기준을 위험 기반 정적·데이터·런타임·저장·UI 매트릭스로 바꾼다.
- 원래 실패·반례·정상 경로를 재실행하고 증거와 gate를 일치시킨다.

## Done and failure gate

- 모든 완료 기준에 증거 또는 명시적 `NOT_RUN`이 연결된다.
- 결함은 재현·기대·실제·심각도·영향 범위를 가진다.
- Failure: 미실행 PASS, 캡처만으로 상태 단정, 평균으로 실패 은폐, 사용자 저장 오염, PR·Actions 상태 불일치면 실패다.

## Selective support

공격 검토는 `running-adversarial-review-and-refinement`, 통합 증거는 `reviewing-and-validating-project-changes`, 런타임 원인은 `diagnosing-game-engine-runtime-failures`.

## 재미 검증의 증거 경계

`docs/UX_UI_SYSTEM.md#experience-verification`의 가설별 MACHINE·RUNTIME·HUMAN 질문을 구분한다. 행동 관찰·자기보고·필요 로그와 반증을 대조하고 이해 실패/선택·규칙/연출/반복 피로/환경 결함을 나눠 최소 교정을 제안한다. 사람 미검수는 NOT_RUN이며 승인된 구현을 다시 잠그지 않는다.
