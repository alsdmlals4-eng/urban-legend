---
name: urban-legend-ux-ui-accessibility
description: Use for Urban Legend information architecture, interaction, input, accessibility, and Godot UI design grounded in the project's UI architecture and field-recovery presentation contracts.
---

# Urban Legend UX·UI·Accessibility

## Core principle

UI는 조사 정보와 선택의 의미를 빠르게 이해하게 해야 하며, 연출은 상태를 표현하되 진행·정답·저장을 대신 소유하지 않는다.

## Use when

- 화면 정보 위계, 흐름, 컴포넌트, 입력과 포커스를 설계한다.
- 한국어 줄바꿈, 해상도 대응, 키보드·마우스 접근성과 폴백을 검토한다.
- 조사·안정화·대화·HQ 화면의 UX 계약을 수정한다.

## Do not use when

- 구현된 화면의 미감만 A~E 영역으로 감사한다.
- 새 이미지 생성 프롬프트만 작성한다.
- UI와 무관한 게임 규칙·저장 구현이다.

## Skill modes

- `architecture`: 화면 구조·정보 위계·공용 컴포넌트 책임을 설계한다.
- `accessibility`: 입력 장벽·가독성·동등 신호·폴백을 정의한다.
- `interaction-review`: 실제 흐름·포커스·첫 선택 노출·오류 복구를 검수한다.

## Required inputs and read first

1. `docs/CURRENT_STATUS.md`
2. `docs/GODOT_NATIVE_UI_ARCHITECTURE.md`
3. `docs/CINEMATIC_FIELD_RECOVERY_UI.md`
4. `docs/planning/ART_PRESENTATION_PLAN.md`
5. 관련 `scenes/`·`scripts/ui/` 파일
6. `TEST_CHECKLIST.md`

## Workflow

```text
플레이어 목표·보유 정보·주요 행동 확인
→ 정보 위계·상태 소유자·입력 경로 정의
→ 1280×720·1920×1080·키보드·마우스 기준 설계
→ 접근성 폴백과 오류 복구 추가
→ 실제 Scene·Theme·스크립트와 대조
→ interaction-review와 필요 시 렌더 감사
```

## Definition of Ready

- 대상 화면, 플레이어 목표, 핵심 선택과 상태 소유자가 명확하다.
- 지원 해상도·입력·언어·접근성 기준이 있다.
- 기존 공용 컴포넌트 재사용 여부를 확인했다.

## Definition of Done

- 핵심 행동과 첫 선택이 두 기준 해상도에서 잘리지 않는다.
- 마우스·키보드·Esc·포커스가 충돌하지 않는다.
- 음향·색·연출 정보에 동등한 텍스트 또는 시각 폴백이 있다.
- UI가 저장·진행·판정 상태를 새로 소유하지 않는다.

## Validation and failure conditions

- Scene 로드, UI 계약 테스트, 두 해상도와 입력 경로를 검증한다.
- 플레이어가 아직 모르는 정보 노출, 장식 때문에 선택 불명확, 포커스 단절, 색·소리만으로 의미 전달하면 실패다.

## Related skills

- 시각 결과 감사: `auditing-and-refining-ui-art`
- 이미지·기술 카드: `designing-art-prompts-and-technique-cards`
- 구현: `urban-legend-engineering`
- 변경 검증: `reviewing-and-validating-project-changes`
- 학습 기록: `skills/SKILL_LEARNING_LOG.md`
