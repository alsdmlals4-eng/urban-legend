---
name: urban-legend-ux-ui-accessibility
description: Use for Urban Legend information architecture, investigation records, hypothesis flow, interaction, input, accessibility, and Godot UI design grounded in project contracts and the Base UX UI system.
---

# Urban Legend UX·UI·Accessibility

> 공통 실행·DoR·DoD·보고·구조 개선 계약: `skills/disciplines/PROJECT_DISCIPLINE_CONTRACT.md`  
> 프로젝트 UX/UI 책임 원본: `docs/UX_UI_SYSTEM.md`  
> Base 공용 Skill: `auditing-and-refining-ui-art`

## Purpose and boundary

UI는 조사 정보와 선택 의미를 빠르게 이해하게 해야 하며, 연출은 상태를 표현하되 진행·정답·플래그·저장을 소유하지 않는다.

- Use: 화면 정보 위계·흐름·컴포넌트·입력·포커스·한국어 줄바꿈·해상도·접근성 설계.
- Use: 확인 사실·단일 증언·가설·모순·미확인의 정보 신뢰 상태와 검증 흐름.
- Do not use: 새 괴이 규칙·분기·단서·설정 발명, 이미지 프롬프트만 작성, UI와 무관한 저장·규칙 구현.
- Do not use: HTML 기획 대시보드 제작.

## Modes

`architecture → pattern-selection → accessibility → interaction-review → playtest-contract → runtime-ui-audit`

### Base Mode 연결

| 프로젝트 Mode | Base Mode |
|---|---|
| `architecture` | `experience-contract`, `flow-and-information-architecture` |
| `pattern-selection` | `pattern-selection`, `design-system-contract` |
| Godot 상태 소유·Signal | `godot-ui-contract` |
| `accessibility` | `accessibility-gate` |
| `playtest-contract` | `playtest-contract` |
| `interaction-review` | `runtime-ui-audit` |

## Read first

1. `docs/CURRENT_STATUS.md`
2. `docs/PROJECT_CORE.md`
3. `docs/UX_UI_SYSTEM.md`
4. `docs/GODOT_NATIVE_UI_ARCHITECTURE.md`
5. `docs/CINEMATIC_FIELD_RECOVERY_UI.md`
6. `docs/planning/ART_PRESENTATION_PLAN.md`
7. 관련 `scenes/`·`scripts/ui/`
8. `TEST_CHECKLIST.md`

## Domain workflow

1. 플레이어 목표·보유 정보·핵심 행동·상태 소유자를 먼저 정의한다.
2. 화면마다 중심 질문과 첫 시선을 하나씩 정한다.
3. 정보는 확인 사실·단일 증언·가설·모순·미확인·폐기로 구분하고 출처·근거·검증 행동을 보존한다.
4. 공포는 규칙의 의미와 불완전한 정보에서 만들고 조작·읽기 자체를 불명료하게 만들지 않는다.
5. 조사·가설·검증·회수 전에 위험·비용·알려진 불확실성을 표시한다.
6. UI는 권위 상태를 표시하고 조사·가설·검증·회수 의도만 Signal/Command로 반환한다.
7. 1280×720·1920×1080, 마우스·키보드·게임패드·Esc·포커스와 동등 신호를 검수한다.
8. 자동·런타임·사람 검증을 분리하고 미실행은 `NOT_RUN` 또는 `HUMAN_NOT_RUN`으로 둔다.

## Project pattern profile

- `ADOPT`: `UXP-STATUS-VISIBILITY`, `UXP-ACTION-FEEDBACK`, `UXP-ERROR-RECOVERY`, `UXP-FOCUS-NAVIGATION`, `UXP-MULTI-CHANNEL-CUES`, `UXP-RETURNING-PLAYER-MEMORY`, `UXP-CAUSAL-RECAP`, `UXP-EMPTY-LOCKED-FALLBACK`.
- `ADAPT`: `UXP-PREDICT-BEFORE-COMMIT`, `UXP-PROGRESSIVE-DISCLOSURE`, `UXP-COMPARABLE-CHOICES`, `UXP-SAFE-REVERSAL`.
- 실제 노출량·요약 길이·위험 예고 강도는 사람 플레이 전까지 `TEST`다.

## Done and failure gate

- 핵심 선택이 잘리지 않고 입력 경로가 충돌하지 않는다.
- 플레이어가 사실·가설·모순과 다음 검증 행동을 구분한다.
- 색·소리·모션 정보에 동등한 텍스트·시각 폴백이 있다.
- 조사 행동→괴이 규칙→위험/회수→기록 변화의 인과가 남는다.
- Failure: 미확보 정보 노출, 가설을 사실로 표시, 장식으로 선택 불명확, 포커스 단절, 색·소리만으로 의미 전달, UI의 새 상태 소유면 실패다.
- 실제 런타임·사람·보조기기 검증을 실행하지 않았으면 완료로 표시하지 않는다.

## Selective support

시각 결과는 Base `auditing-and-refining-ui-art`의 `runtime-ui-audit`, 공격 검토는 `running-adversarial-review-and-refinement`, 통합 증거는 `reviewing-and-validating-project-changes`를 사용한다.
