# 괴이기록국 · Visual Anchor Specification

Status: `PLANNING_COMPLETE / PRODUCT_REFERENCE_ASSET_PENDING / IMPLEMENTATION_NOT_AUTHORIZED`
Art treatment: `SOFT_ANIME_NOIR_LOCKED`
Presentation invariant: `DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM`

Source PR: #215
Parent canon: `docs/CURRENT_PLANNING_CANON.md`
Closure contract: `docs/planning/2026-08-21-visual-ui-planning-closure.md`

## Purpose

Define the final visual planning criteria before production asset work. Planning is complete without pretending that an ungenerated/unreviewed image is an approved product reference. Product-reference image selection, layer/reuse audit, rights review, runtime readability and Human QA remain separate gates.

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
- no M01/M04 generated or user-owned draft is promoted to product reference merely because planning is complete
- final image/reference approval checks Investigation/Deduction/Recovery P0 criteria, 1280×720 and 1920×1080 readability, layer/reuse structure, rights/provenance and semantic correctness
- product-reference approval does not imply runtime or Human QA PASS

## Next gates

1. Final planning declaration — `APPROVED`.
2. Fresh-main Reality Gate — `HANDOFF_READY_WITH_KNOWN_REALIGNMENT`.
3. Runtime implementation execution authorization — `NOT_AUTHORIZED`.
4. Current implementation plan execution for shared code/data/state.
5. Product-reference image/asset approval when concrete candidates exist.
6. Layer/reuse + rights/provenance + resolution checks.
7. Release-near M04 visual/audio/VFX implementation.
8. Runtime + Human QA.

## Evidence boundary

- Planning completion is not product asset approval.
- Product promotion requires project asset authority and rights/meaning review.
- Runtime visual, final 1280×720/1920×1080 readability, animation, Audio/VFX, and Human QA remain `NOT_RUN` until actually executed.
- `IMPLEMENTATION_NOT_AUTHORIZED` remains the product-mutation boundary until explicit runtime execution authorization.
