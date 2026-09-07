# D-2026-08-27 — M01 Recovery Visual Assets Product Promotion

## Status

`APPROVED / IMPLEMENTED / RUNTIME_AND_HUMAN_QA_PENDING`

## Decision

Promote the two user-approved M01 Recovery candidates to their existing canonical runtime paths only:

- `assets/backgrounds/afterlife_recovery.png`
- `assets/anomalies/cutouts/afterlife_b_cutout.png`

## Scope boundary

- Existing consumers: `battle_scene.tscn -> ArtLayer/Background` and `battle_scene.tscn -> CinematicStage/AnomalyPanel/Content/AnomalyVisual`.
- No scene, script, data, catalog, fallback, UI layout, or other asset mutation.
- Recovery source and canonical PNG SHA-256: `d8ad9d38122dd509cb8ed62922195831c1183b4030d64e578fcb85b059aa3327`.
- B/C source and canonical PNG SHA-256: `3f3970067c1465db86d8a9b4214a680d402a373851fc3e7efb88c3d837e1097e`.
- Godot import and automated catalog verification are required in this promotion. Live 1280×720/1920×1080 capture and Human visual/accessibility QA remain pending.

## Merge safeguard

The two product paths remain protected. Their approval manifest lists exactly these two paths and records the sole decision owner's explicit authorization. CI still validates the protected baseline, exact allowlist, manifest schema, generated views, and all other project contracts; it does not require a second GitHub identity for this single-owner project.
