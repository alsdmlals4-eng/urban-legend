# M01 Anomaly D Runtime Correction Candidate — 2026-08-27

Status: `PROJECT_ASSET_APPROVED / IMPLEMENTED / RUNTIME_VALIDATED_1280 / RUNTIME_1920_PENDING / HUMAN_QA_PENDING`

Issues: `#278`, `#280`

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

- The exact bytes now replace only `assets/anomalies/cutouts/afterlife_d_cutout.png`; the previous canonical SHA-256 was `a67933332cd5deb0f774553e3e785b87ac8646543caaa297a19c1acb17c96ad9`.
- `UiAssetCatalog`, `SceneVisuals`, Godot scene wiring, B/C state, save data, and rules remain unchanged.
- Godot imported the canonical PNG and the actual 1280×720 D consumer resolved the existing route. The 1920×1080 launch-profile capture remains pending.
- Human/player-experience QA remains deferred.
