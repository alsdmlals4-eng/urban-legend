# D-2026-08-27 — M04 Investigation Background Product Promotion

## Status

`APPROVED / IMPLEMENTED / RUNTIME_AND_HUMAN_QA_PENDING`

## Decision

Promote the user-approved M04 Investigation adaptation to its existing canonical runtime path only:

- `assets/backgrounds/red_crossroads.png`

## Scope boundary

- Existing consumers: `investigation_scene.tscn -> ArtLayer/Background` and the shared `LocationPreview` route.
- No scene, script, data, catalog, fallback, UI layout, or other asset mutation.
- Candidate source and canonical PNG SHA-256: `874d3c531a45c9ddf670e9a8ff70a37443762dc24af640edac2ff45fea762f9d`.
- Godot import and automated catalog verification are required in this promotion. Live 1280×720/1920×1080 capture and Human visual/accessibility QA remain pending.

## Merge safeguard

The product path remains protected. Its approval manifest lists exactly this path and records the sole decision owner's explicit authorization. CI still validates the protected baseline, exact allowlist, manifest schema, generated views, and all other project contracts; it does not require a second GitHub identity for this single-owner project.
