# M04 Anomaly D Adapt 01 — Candidate Receipt

## Status

`PROJECT_ASSET_APPROVED / IMPLEMENTED / RUNTIME_VERIFIED / HUMAN_QA_PENDING`

This is the one-image, transparent high-risk anomaly asset for M04 Recovery risk stage D. The user authorized automatic generation on 2026-08-28 and the approved current implementation promoted its exact bytes to the existing product path on 2026-08-30. The Scene/catalog/fallback stay intact; automated runtime evidence is not Human QA or release clearance.

## Binary

- PNG: `M04_ANOMALY_D_ADAPT_01.png`
- Dimensions: `1024x1536`
- Bytes: `1,508,601`
- Pixel format: `RGBA`; each tested corner alpha is `0`
- SHA-256: `0e52f8c02e2ce5a24684603b6280f131224fc02ea661c22275564e327d66541f`
- Generation date: `2026-08-28`
- Generation path: built-in image generation
- Generation contract: `GENERATE_EXACTLY_ONE / COMPLETE`

## Consumer intent

- `scenes/battle_scene.tscn -> CinematicStage/AnomalyPanel/Content/AnomalyVisual`
- target: M04 `red_umbrella_d_cutout` active product asset

The candidate is one suspended crimson umbrella with a bent black handle, sparse water and soot-like residue, and a transparent margin. It contains no human figure, scene, crowd, text, UI, or duplicate umbrella, so it can be assessed without the current full-image fallback's scenery/crowd overlap.

## Direction and limits

- Keep the M04 urban-legend red-umbrella identity and the established restrained noir palette.
- `ASSET_MANIFEST.yml` records the canonical path, candidate/canonical SHA-256 equality, actual consumer, and current approval receipt.
- The existing full fallback remains unchanged. The runtime editor now defaults this D-stage transparent cutout to `KEEP_ASPECT_CENTERED` while preserving a player-set crop preference.
- Exact target-scene checks passed at 1280×720 and 1920×1080. Human visual/accessibility QA and release-rights review remain separate gates.
