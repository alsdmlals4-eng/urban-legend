# M01 Anomaly B/C Adapt 01 — Approval Receipt

## Status

`USER_APPROVED_VISUAL_CANDIDATE / PRODUCT_ASSET_PROMOTION_PENDING`

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

User result approval confirms this visual candidate and requires durable storage in this repository and Project Notion. It does not replace `assets/anomalies/cutouts/afterlife_b_cutout.png`, change the asset catalog, grant `PROJECT_ASSET_APPROVED`, or pass runtime readability and Human QA. Those gates remain separately authorized work.
