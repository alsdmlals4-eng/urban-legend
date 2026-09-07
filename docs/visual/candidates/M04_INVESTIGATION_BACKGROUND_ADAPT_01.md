# M04 Investigation Background Adapt 01 — Approval Receipt

## Status

`PROJECT_ASSET_APPROVED / IMPLEMENTED / RUNTIME_AND_HUMAN_QA_PENDING`

This record owns the approved visual-adaptation candidate created after the pixel comparison between the current `assets/backgrounds/red_crossroads.png` consumer and the approved M04 Investigation Anchor direction.

## Binary

- PNG: `M04_INVESTIGATION_BACKGROUND_ADAPT_01.png`
- Dimensions: `1672x941`
- Bytes: `2,662,606`
- SHA-256: `874d3c531a45c9ddf670e9a8ff70a37443762dc24af640edac2ff45fea762f9d`
- Generation date: `2026-08-26`

## Consumer intent

- `investigation_scene.tscn -> ArtLayer/Background`
- shared `LocationPreview`

The image preserves an information-first read: wet Korean back-alley crossroad, abandoned red umbrella, then footprints that remain visually distinct from the rain-wet pavement. It contains no baked UI, title, panel, rule answer, or readable text.

## Approval boundary

The sole decision owner's approved continuation promoted these exact bytes to `assets/backgrounds/red_crossroads.png` on 2026-08-27. It reuses the existing Godot route and does not add a new reference, scene, script, catalog, fallback, or UI change.

Promotion records:

- Decision: `docs/decisions/D-2026-08-27-M04-INVESTIGATION-BACKGROUND-PRODUCT-PROMOTION.md`
- Protected-path approval: `docs/approvals/PROJECT_PROTECTED_CHANGE_APPROVAL_M04_INVESTIGATION_BACKGROUND_20260827.json`
- GitHub Issue: `#253`

Godot import plus focused automated catalog checks are required in this promotion. Live 1280×720/1920×1080 runtime readability and Human visual/accessibility QA remain separate pending gates.
