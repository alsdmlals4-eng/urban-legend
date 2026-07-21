---
name: urban-legend-narrative
description: Use for Urban Legend worldbuilding, episode narrative, dialogue, relationship memory, and continuity work grounded in the project's canonical narrative sources and implemented data.
---

# Urban Legend Narrative

## Core principle

설정·대사·관계는 플레이어가 실제로 획득한 정보와 선택 기억을 표현한다. 미확보 단서·정답·숨은 수치를 서사 편의로 누설하지 않는다.

## Use when

- 사건·인물·세계관·대사·일상·후일담을 작성하거나 수정한다.
- 관계 태그와 선택 기억이 후속 대사·이벤트에 이어지는지 검토한다.
- 구현 데이터와 기획 서사의 연속성·용어·톤을 감사한다.

## Do not use when

- 핵심 게임 컨셉·시장·벤치마크 전략만 비교한다.
- 저장·Scene·데이터 경계를 구현하는 엔지니어링 작업이다.
- 맞춤법만 고치는 L0 편집이다.

## Skill modes

- `route`: 요청을 사건·인물·대사·관계·후일담 책임 원본으로 연결한다.
- `author`: 승인된 범위의 서사와 대사를 작성·갱신한다.
- `continuity-review`: 설정·정보 공개·선택 기억·용어·구현 데이터의 연속성을 검수한다.

## Required inputs and read first

1. `docs/CURRENT_STATUS.md`
2. `docs/planning/NARRATIVE_CONTENT_PLAN.md`
3. `docs/PROJECT_CONTEXT.md`
4. 관련 `data/`·대화·이벤트 파일
5. `TEST_CHECKLIST.md`

## Workflow

```text
플레이어가 아는 정보와 사건 상태 확인
→ 장면 목적·화자·선택 기억·금지 정보 확정
→ 최소 문장·분기 작성
→ 구현 ID·조건·후속 반응과 대조
→ continuity-review
→ 필요한 자동·수동 검증과 결과 보고
```

## Definition of Ready

- 장면 목적, 화자, 시점, 선행 조건과 플레이어 보유 정보가 명확하다.
- 기존 ID·저장 상태·후속 이벤트 영향이 확인됐다.
- 포함·제외 범위와 승인된 톤이 있다.

## Definition of Done

- 공식 용어와 캐릭터 말투가 책임 원본과 일치한다.
- 미확보 정보와 정답을 누설하지 않는다.
- 선택 기억이 필요한 후속 반응에 연결된다.
- 변경 데이터·문서·검증 결과와 미검증 항목을 보고한다.

## Validation and failure conditions

- JSON·대화 데이터 구문과 참조 ID를 검사한다.
- 사건 진행·저장 호환·대사 노출 조건을 회귀 확인한다.
- 설정 충돌, 정보 선행 공개, 관계를 단일 호감도 숫자로 축소, 서사가 게임 상태를 소유하면 실패다.

## Related skills

- 컨셉·외부 근거: `analyzing-and-refining-game-concepts`
- 변경 검증: `reviewing-and-validating-project-changes`
- 경로·ID 전파: `auditing-canonical-reference-freshness`
- 학습 기록: `skills/SKILL_LEARNING_LOG.md`
