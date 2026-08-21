# 괴이기록국 · M01-M04 Vertical Slice Flow

Status: PLAN_LOCK / INTEGRATED_CANON / IMPLEMENTATION_NOT_AUTHORIZED

Source PR: #213
Parent canon: `docs/CURRENT_PLANNING_CANON.md`

## Core flow

Investigation
→ Deduction / Anomaly Manual
→ Victim Rescue
→ Recovery
→ Composite Result

## Purpose

M01 is the first complete learning case and regression anchor. Opening Record, 제한된 첫 주간 일정, 첫 조사·추리·구출·회수를 한 번의 인과 체험으로 가르친다. 플레이어는 괴이가 단순 처치가 아니라 규칙 이해를 통해 안정화·회수된다는 점을 배운다.

## Recovery validation

- Telegraphs and anomaly rules are the primary information.
- Protection target state is more important than enemy HP.
- Character visuals are limited except for important support Cut-ins.

## M04 player-experience validation

M04 Red Umbrella is the 30~45 minute release-near player-experience Vertical Slice. It reuses the same screen grammar with different:

- anomaly rule
- keyword structure
- rescue logic
- recovery telegraph

M04는 실제 사용 후보 UI/UX·시각·Audio/VFX·피드백·핵심 시스템·콘텐츠를 연결한 뒤 재미·첫인상·가독성·추리 인과를 Human QA한다. M01은 온보딩/회귀, M04는 제품 경험 검증이므로 서로를 대체하지 않는다.

## Guardrails

- No runtime code/data/Scene/save changes.
- No asset promotion.
- No image generation before review of the user's visual drafts.
- No Human QA claims.
