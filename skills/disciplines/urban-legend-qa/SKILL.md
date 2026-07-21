---
name: urban-legend-qa
description: Use for Urban Legend test planning, regression, defect triage, evidence capture, and release-gate decisions tied to the project's actual runtime, save, UI, and documentation contracts.
---

# Urban Legend QA

## Core principle

검증은 “문제가 없어 보임”이 아니라 승인 계약과 실제 증거를 연결한다. 실행하지 않은 검사·사람 확인·권한은 통과로 보고하지 않는다.

## Use when

- 기능·문서·데이터·자산 변경의 테스트 계획과 회귀 범위를 정한다.
- 결함을 재현·분류·우선순위화하고 수정 후 재검증한다.
- 캡처·로그·Actions·Godot 결과로 release gate를 판정한다.

## Do not use when

- 변경이 없는 아이디어 비교다.
- 전문 UI 미감 감사만 필요하다.
- 테스트 계획 없이 단순히 체크박스를 채우려는 경우다.

## Skill modes

- `plan`: 완료 기준을 자동·수동·회귀 테스트로 변환한다.
- `execute`: 대표·변형·실패 경로를 실행하고 증거를 수집한다.
- `defect-triage`: 재현성·심각도·범위·원인 후보·회귀를 정리한다.
- `release-gate`: PASS·PARTIAL·FAIL·UNVERIFIED를 증거로 판정한다.

## Required inputs and read first

1. `docs/CURRENT_STATUS.md`
2. `TEST_CHECKLIST.md`
3. `docs/MVP_WORKFLOW_CHECKLIST.md`
4. 현재 Issue·PR·완료 기준
5. 실제 변경 diff와 대상 테스트
6. 관련 저장·Scene·데이터·캡처

## Workflow

```text
계약·변경 범위·기존 실패 확인
→ 위험 기반 테스트 매트릭스 작성
→ 정적·데이터·런타임·저장·UI 순으로 실행
→ 실패 재현·원인 범위·수정 여부 판정
→ 회귀와 반례 재실행
→ 증거·미검증·release gate 보고
```

## Definition of Ready

- 관찰 가능한 완료 기준과 변경 파일이 있다.
- 목표 장치·해상도·저장 상태·대표 플레이 경로가 정해졌다.
- 원래 실패 또는 위험을 재현할 방법이 있다.

## Definition of Done

- 각 완료 기준에 실제 증거 또는 명시적 `NOT_RUN`이 연결된다.
- 기존 저장·세 사건·핵심 흐름의 회귀를 확인한다.
- 결함은 재현 단계·기대·실제·심각도·영향 범위를 가진다.
- release gate가 PR 설명·Actions 상태와 일치한다.

## Validation and failure conditions

- JSON·정적 검사·Godot headless·변경 테스트·저장 왕복·해상도·입력·영향 플레이를 범위에 맞게 실행한다.
- 미실행 검사 PASS 처리, 캡처만 보고 상태 단정, 평균 결과로 실패 은폐, 테스트가 사용자 저장을 오염하면 실패다.

## Related skills

- 통합 검증: `reviewing-and-validating-project-changes`
- 참조 최신성: `auditing-canonical-reference-freshness`
- UI 렌더 감사: `auditing-and-refining-ui-art`
- 운영체계 검수: `managing-game-project-operating-system`
- 학습 기록: `skills/SKILL_LEARNING_LOG.md`
