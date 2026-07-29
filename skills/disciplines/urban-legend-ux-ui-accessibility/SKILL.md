---
name: urban-legend-ux-ui-accessibility
description: Use for Urban Legend investigation information architecture, hypothesis flow, input, accessibility, and Godot UI design grounded in project and Base UX contracts.
---

# Urban Legend UX·UI·Accessibility

- 공통 계약: `skills/disciplines/PROJECT_DISCIPLINE_CONTRACT.md`
- 프로젝트 정본: `docs/UX_UI_SYSTEM.md`
- Base 공용 Skill: `auditing-and-refining-ui-art`

## Purpose and boundary

UI는 조사 정보와 선택 의미를 이해하게 하되 진행·정답·플래그·저장을 소유하지 않는다.

- Use: 정보 위계·흐름·컴포넌트·입력·포커스·한국어·해상도·접근성.
- Use: 확인 사실·증언·가설·모순·미확인의 신뢰 상태와 검증 흐름.
- Do not use: 새 괴이 규칙·분기·단서·설정 발명, 이미지 프롬프트, UI와 무관한 저장·규칙 구현, HTML 기획 대시보드.

## Modes

`architecture → pattern-selection → accessibility → interaction-review → playtest-contract → runtime-ui-audit`

| 프로젝트 Mode | Base Mode |
|---|---|
| `architecture` | `experience-contract`, `flow-and-information-architecture` |
| `pattern-selection` | `pattern-selection`, `design-system-contract` |
| Godot 상태·Signal | `godot-ui-contract` |
| `accessibility` | `accessibility-gate` |
| `playtest-contract` | `playtest-contract` |
| `interaction-review` | `runtime-ui-audit` |

## Read first

1. `docs/CURRENT_STATUS.md`, `docs/PROJECT_CORE.md`, `docs/UX_UI_SYSTEM.md`
2. `docs/GODOT_NATIVE_UI_ARCHITECTURE.md`, `docs/CINEMATIC_FIELD_RECOVERY_UI.md`
3. `docs/planning/ART_PRESENTATION_PLAN.md`, 관련 `scenes/`·`scripts/ui/`, `TEST_CHECKLIST.md`

## Workflow

1. 플레이어 목표·보유 정보·핵심 행동·상태 소유자를 먼저 정의한다.
2. 화면마다 중심 질문과 첫 시선을 하나씩 정한다.
3. 사실·증언·가설·모순·미확인·폐기를 구분하고 출처·근거·검증 행동을 보존한다.
4. 공포는 규칙과 불완전한 정보에서 만들고 조작·읽기를 불명료하게 만들지 않는다.
5. 조사·가설·검증·회수 전에 위험·비용·알려진 불확실성을 표시한다.
6. UI는 권위 상태를 표시하고 조사·가설·검증·회수 의도만 Signal/Command로 반환한다.
7. 1280×720·1920×1080, 마우스·키보드·게임패드·Esc·포커스와 동등 신호를 검수한다.
8. 미실행 검증은 `NOT_RUN` 또는 `HUMAN_NOT_RUN`으로 둔다.

## Pattern profile

- `ADOPT`: 상태 가시성, 입력 피드백, 오류 복구, 포커스, 다중 채널, 복귀 기억, 인과 복기, 빈/잠금 폴백.
- `ADAPT`: 실행 전 예측, 점진 공개, 선택 비교, 안전한 되돌리기.
- 실제 노출량·요약 길이·위험 예고 강도는 사람 플레이 전까지 `TEST`다.

## Done and failure gate

- 플레이어가 사실·가설·모순과 다음 검증 행동을 구분한다.
- 색·소리·모션에 동등 폴백이 있고 조사→규칙→위험/회수→기록 인과가 남는다.
- 미확보 정보 노출, 가설의 사실화, 포커스 단절, UI의 새 상태 소유면 실패다.
- 시각 결과는 Base `runtime-ui-audit`, 공격 검토는 `running-adversarial-review-and-refinement`, 통합 증거는 `reviewing-and-validating-project-changes`를 사용한다.
