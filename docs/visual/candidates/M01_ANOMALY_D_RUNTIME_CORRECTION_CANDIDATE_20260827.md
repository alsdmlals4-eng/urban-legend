# M01 Anomaly D Runtime Correction Candidate — 2026-08-27

Status: `USER_AUTONOMOUSLY_AUTHORIZED_VISUAL_CANDIDATE / NOT_PRODUCT_ASSET / RUNTIME_PROMOTION_PENDING`

Issue: `#278`

## Why this candidate exists

The actual Recovery `AnomalyVisual` consumer was inspected at 1280x720 and under the 1920x1080 launch profile. The existing D cutout resolves correctly, but its visual hierarchy does not meet the already-authored D-state rule: it reads as a clean uniformed figure rather than a visibly escalated continuation of the B/C apparition. This candidate addresses only that gap.

## Exact local binary

- file: `docs/visual/candidates/M01_ANOMALY_D_RUNTIME_CORRECTION_CANDIDATE_20260827.png`
- source: built-in image generation, one image only
- dimensions: `1024x1536`
- alpha: `Format32bppArgb`; corner alpha `0`
- SHA-256: `c9430f62a0bad800b53a328e05395ce4c2eafd094778acd227c406c21d8b24ff`

## Text brief used

Preserve the existing Korean urban-rail operator apparition as the same D-state identity: black peaked cap, dark long station coat, pale face, tall slender vertical silhouette, restrained soft-anime-noir rendering. Escalate only the D state with broken trailing coat edges, fragmented afterimage slivers, narrow black linear interference, and restrained dull red-rust accents. Use a genuinely transparent background; no platform, train, scenery, text, UI, logo, watermark, weapons, attack pose, gore, bright neon, or other characters. The result must remain legible in Godot `STRETCH_KEEP_ASPECT_CENTERED` and must not become a different monster.

## Boundary

- This is a review candidate only. It does **not** replace `assets/anomalies/cutouts/afterlife_d_cutout.png`.
- It does **not** change `UiAssetCatalog`, `SceneVisuals`, Godot scene wiring, B/C state, save data, or rules.
- Product promotion requires a separate exact-byte comparison, import/readback, actual runtime capture, and documentation reconciliation.
- Human/player-experience QA remains deferred.
