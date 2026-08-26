# M01 Anomaly B/C Adapt 01 — Approval Receipt

## Status

`PROJECT_ASSET_APPROVED / IMPLEMENTED / RUNTIME_AND_HUMAN_QA_PENDING`

This record owns the one-image transparent anomaly candidate for M01 Recovery risk stages B/C.

## Binary

- PNG: `M01_ANOMALY_BC_ADAPT_01.png`
- Dimensions: `941x1672`
- Bytes: `1,110,223`
- Pixel format: `ARGB` (transparent cutout)
- SHA-256: `3f3970067c1465db86d8a9b4214a680d402a373851fc3e7efb88c3d837e1097e`
- Generation date: `2026-08-26`
- Generation contract: `GENERATE_EXACTLY_ONE / COMPLETE`

## Consumer intent

- `scenes/battle_scene.tscn -> CinematicStage/AnomalyPanel/Content/AnomalyVisual`
- risk stages `B` and `C` share this candidate through the existing `afterlife_b_cutout` route.

The candidate depicts an unnamed station-attendant-like humanoid whose uniform details subtly repeat and misalign. It provides a readable middle-risk manifestation without baking a station background or runtime UI into the visual.

## Approval boundary

The sole decision owner authorized product promotion under GitHub Issue #250. The exact candidate bytes now replace only `assets/anomalies/cutouts/afterlife_b_cutout.png`; the existing Godot catalog, scene route, and full-image fallback remain unchanged. Godot import and automated catalog checks are required by this promotion. Live 1280×720/1920×1080 capture and Human QA remain separate pending gates.
