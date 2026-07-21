---
name: urban-legend-ux-ui-accessibility
description: Use for Urban Legend information architecture, interaction, input, accessibility, and Godot UI design grounded in the project UI contracts.
---

# Urban Legend UX·UI·Accessibility

> 공통 실행·DoR·DoD·보고·구조 개선 계약: `skills/disciplines/PROJECT_DISCIPLINE_CONTRACT.md`

## Purpose and boundary

UI는 조사 정보와 선택 의미를 빠르게 이해하게 해야 하며, 연출은 상태를 표현하되 진행·정답·저장을 소유하지 않는다.

- Use: 화면 정보 위계·흐름·컴포넌트·입력·포커스·한국어 줄바꿈·해상도·접근성 설계.
- Do not use: 구현된 화면의 미감만 감사, 이미지 프롬프트만 작성, UI와 무관한 저장·규칙 구현.

## Modes

`architecture → accessibility → interaction-review`

## Read first

1. `docs/CURRENT_STATUS.md`
2. `docs/PROJECT_CORE.md`
3. `docs/GODOT_NATIVE_UI_ARCHITECTURE.md`
4. `docs/CINEMATIC_FIELD_RECOVERY_UI.md`
5. `docs/planning/ART_PRESENTATION_PLAN.md`
6. 관련 `scenes/`·`scripts/ui/`
7. TEST_CHECKLIST.md

## Domain workflow

- 플레이어 목표·보유 정보·핵심 행동·상태 소유자를 먼저 정의한다.
- 1280×720·1920×1080, 마우스·키보드·Esc·포커스와 동등 신호를 검수한다.

## Done and failure gate

- 핵심 선택이 잘리지 않고 입력 경로가 충돌하지 않는다.
- 색·소리·모션 정보에 동등한 텍스트·시각 폴백이 있다.
- Failure: 미확보 정보 노출, 장식으로 선택 불명확, 포커스 단절, 색·소리만으로 의미 전달, UI의 새 상태 소유면 실패다.

## Selective support

시각 결과는 `auditing-and-refining-ui-art`, 공격 검토는 `running-adversarial-review-and-refinement`, 통합 증거는 `reviewing-and-validating-project-changes`.
