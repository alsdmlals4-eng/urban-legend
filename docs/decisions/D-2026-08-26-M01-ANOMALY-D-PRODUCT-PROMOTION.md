# D-2026-08-26 — M01 Anomaly D Product Promotion

## Status

`APPROVED / IMPLEMENTED_PENDING_INDEPENDENT_GITHUB_REVIEW`

## Decision

Promote the user-approved M01 D-risk anomaly candidate to the existing canonical cutout path only:

`assets/anomalies/cutouts/afterlife_d_cutout.png`

## Scope boundary

- Existing consumer: `battle_scene.tscn -> CinematicStage/AnomalyPanel/Content/AnomalyVisual`.
- No scene, script, data, catalog, fallback, or other asset mutation.
- Source and canonical product PNG SHA-256: `a67933332cd5deb0f774553e3e785b87ac8646543caaa297a19c1acb17c96ad9`.
- The 1280x720 live-runtime check passed; 1920x1080 capture and Human visual/accessibility QA remain pending.

## Merge safeguard

The product path remains protected. Its approval manifest lists exactly this one path and the CI gate requires an `APPROVED` GitHub review from an account other than the PR author. This document does not itself authorize a CI bypass or merge.
