# 괴이기록국 · Visual Anchor Specification

Status: `PLANNING_COMPLETE / RUNTIME_IMPLEMENTED / PRODUCT_REFERENCE_ASSET_PENDING / HUMAN_QA_NOT_RUN`
Art treatment: `SOFT_ANIME_NOIR_LOCKED`
Presentation invariant: `DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM`

Source PR: #215
Parent canon: `docs/CURRENT_PLANNING_CANON.md`
Closure contract: `docs/planning/2026-08-21-visual-ui-planning-closure.md`

## Purpose

현재 visual planning criteria와 product-reference 승격 경계를 정의한다. 공유 runtime은 이미 구현됐지만, ungenerated/unreviewed 이미지를 승인된 product reference로 간주하지 않는다. Product-reference image selection, layer/reuse audit, rights review, 실제 해상도 가독성 및 Human QA는 별도 Gate다.

## Anchor order

1. Investigation Scene Anchor
2. Deduction Manual Anchor
3. Recovery Phase Anchor

## Investigation Anchor

Priority:
- environment
- anomaly
- evidence
- narration
- choices

Avoid:
- large permanent character illustration
- HUD overload
- revealing the deduction answer

Presentation:
- scene image
- short observation text
- 2~4 choices
- small record/support indicators

## Deduction Manual Anchor

Priority:
- dossier/document feeling
- evidence provenance
- competing hypotheses
- inference construction

Required:
- manual index
- keyword sources
- support/refute/unresolved states
- return to field

## Recovery Anchor

Priority:
- anomaly phenomenon
- telegraph/foreshadowing
- protection target
- response choices

Character usage:
- small status presence normally
- short skill Cut-in only for meaningful support

## Art direction

Main treatment — `SOFT_ANIME_NOIR_LOCKED`:
- selected soft anime noir direction for character and key narrative illustration
- restrained urban occult
- grounded Korean modern environment
- restrained contrast and readable clue surfaces over ornamental neon

`DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM`:
- Korean Urban Occult Dossier Hybrid describes UI metaphor, information hierarchy and field-record composition
- it does not reopen the main art treatment as pixel / painterly / another competing medium
- field terminal, case file, anomaly manual and validation marks share one institutional component language

Pixel/dot:
- supporting observation language only
- logs, sensors, CCTV, markers, interference effects

No:
- full pixel conversion of characters
- pixel-only main investigation surface
- glass-heavy sci-fi HUD that obscures field evidence

## Asset boundary

`PRODUCT_REFERENCE_ASSET_PENDING` means:
- no M01/M04 generated or user-owned draft is promoted to product reference merely because planning/runtime implementation is complete
- final image/reference approval checks Investigation/Deduction/Recovery P0 criteria, 1280×720 and 1920×1080 readability, layer/reuse structure, rights/provenance and semantic correctness
- product-reference approval does not imply runtime or Human QA PASS
- 현재 첫 승인 후보는 `docs/visual/M04_PRODUCT_REFERENCE_APPROVAL_BRIEF.md`의 M04 Investigation Anchor 한 장이다
- 텍스트 Brief의 명시적 사용자 승인 전 이미지 생성 금지, 승인 후에도 후보 정확히 1장만 생성한다

## Current gates

1. Final planning declaration — `APPROVED`.
2. Shared runtime/state/result implementation — `COMPLETE_MERGED` via PR #224.
3. Base protected-baseline governance reconciliation — `COMPLETE` via PR #226/#227 successor.
4. M01 actual First Session Human QA — `NOT_RUN`; `docs/qa/M01_FIRST_SESSION_HUMAN_QA_PACKET.md` 사용.
5. M04 product-reference text Brief — ready for explicit user review.
6. Product-reference image generation — blocked until explicit Brief approval; approved path generates exactly one candidate then stops.
7. Candidate approval 뒤 layer/reuse + rights/provenance + 1280×720/1920×1080 checks.
8. Release-near M04 visual/audio/VFX implementation.
9. Actual runtime/input + Human player-experience QA.

## Evidence boundary

- Planning/runtime completion is not product asset approval.
- Product promotion requires project asset authority and rights/meaning review.
- M01 actual Human comprehension/fatigue QA remains `HUMAN_QA_NOT_RUN` until a person runs the session.
- Runtime visual, final 1280×720/1920×1080 readability, animation, Audio/VFX, and M04 Human QA remain `NOT_RUN` until actually executed.
- 이미지 Brief 작성이나 자동 CI 성공을 product-reference 또는 Human PASS로 승격하지 않는다.
