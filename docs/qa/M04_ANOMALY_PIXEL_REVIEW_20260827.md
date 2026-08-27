# M04 Recovery Anomaly Pixel Review

## Scope

GitHub Issue #297 reviews the actual M04 risk-stage texture route only. `scripts/ui/ui_asset_catalog.gd` maps B/C to `red_umbrella_b_cutout` and D to `red_umbrella_d_cutout`; `scripts/ui/scene_presentation.gd::apply_anomaly()` loads the transparent cutout first and only then falls back to the full RGB image. `battle_scene.tscn` gives both stages the one `CinematicStage/AnomalyPanel/Content/AnomalyVisual` owner using the existing `KEEP_ASPECT_COVERED` presentation.

## Findings

- B/C cutout: alpha is valid, but it reads as an identifiable ordinary girl beneath a red umbrella rather than an anonymous M04 apparition.
- B/C fallback: contains an entire wet alley, reflection figure, and subject identity; it is a scenic image inside a cutout consumer.
- D cutout: alpha is valid but is merely a back view of the same ordinary figure; it supplies no clear stage escalation beyond orientation and tint.
- D fallback: contains a whole alley/crowd of figures and cannot serve as a single anomaly panel portrait.

## Decision

- B/C: `REPLACE_REQUIRED` was proven, followed by exactly one accepted transparent candidate: `M04_ANOMALY_BC_ADAPT_01_20260827`.
- D: `REUSE_REVIEW / SEPARATE_IDENTITY_ESCALATION_COMPARE_PENDING`; no D image was generated because B/C must establish the shared apparition identity first.
- No product asset was changed.

## Evidence boundary

Static paths, dimensions, alpha format, hashes, and pixels were inspected. Runtime capture and Human QA are `NOT_RUN`; the Hera bridge-port boundary remains unchanged and no unrelated editor was stopped.

## Incident -> Solution -> Lesson

- Incident: the first transparent generation rendered a checkerboard into an RGB image instead of providing alpha.
- Solution: reject it before durable candidate storage, issue a single explicit-alpha correction, and check four transparent corners before preservation.
- Lesson: `PROJECT_ONLY_LESSON`; a generated transparency request must be verified by pixel format and alpha samples before candidate storage. `NO_NEW_REUSE_LEARNING` for Base promotion.
