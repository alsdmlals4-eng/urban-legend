# M04 Anomaly B/C Adapt 01 — Candidate Receipt

## Status

`USER_AUTONOMOUSLY_AUTHORIZED_VISUAL_CANDIDATE / PRODUCT_ASSET_PROMOTION_PENDING`

The sole decision owner authorized continuous current-slice visual work, automatic generation when an actual runtime consumer requires it, and dual preservation in the repository and Notion. This is a visual candidate, not a product-asset promotion.

## Binary

- PNG: `M04_ANOMALY_BC_ADAPT_01_20260827.png`
- Dimensions: `1672x941`
- Bytes: `465,022`
- Pixel format: `ARGB`; all four corner samples have alpha `0`.
- SHA-256: `cc1402eb914644198217bc9c3e12a03095a22df2089a3813c93b3660bb5810e5`
- Generation date: `2026-08-27`

## Consumer and visual boundary

- Intended consumer: `scenes/battle_scene.tscn -> CinematicStage/AnomalyPanel/Content/AnomalyVisual` for M04 B/C risk stages.
- The candidate is one centered, anonymous human-like apparition beneath a crimson umbrella. Its small pale face-void and restrained dissolving coat edge establish an anomalous read without declaring a solution or a victim identity.
- It contains no environment, reflection, other figure, text, UI, clue, footprint, M01 material, or D-stage escalation. Existing background, HUD, and separate D visual retain their owners.

## Pixel review and provenance

- Existing B/C cutout: `assets/anomalies/cutouts/red_umbrella_b_cutout.png`, `1672x941` ARGB, SHA-256 `cd5a2d7371a414dba45a96cabcf1f23c18811930f111f8a3afcc112e17258c8d`.
- Existing fallback: `assets/anomalies/red_umbrella_b.png`, `1672x941` RGB, SHA-256 `6cbd63bf2b54306714374961edb4ed9bf4c4e25ff5b9f109d23a858081e2ae16`.
- The original cutout reads as an identifiable ordinary person; the fallback includes an alley and reflection figure, so neither preserves the single `AnomalyVisual` role.
- Generation tool: OpenAI built-in image generation. No third-party character, logo, named artist style, or direct copied composition was requested. This provenance record is not a legal release clearance.

## Rejected generation incident

The first B/C generation attempt produced a 24-bit RGB PNG with a visual checkerboard baked into pixels (`fd7e5ca67176f640b468bbd5465b5db9debab2bdced0b00a4a35207e680c690a`). It was rejected before repository or Notion candidate storage. A single transparent-output correction then produced this ARGB candidate.

## Promotion boundary

This candidate does not replace `assets/anomalies/cutouts/red_umbrella_b_cutout.png`, alter fallback paths, add scene/catalog/script wiring, grant `PROJECT_ASSET_APPROVED`, or pass 1280x720/1920x1080 runtime readability, accessibility, or Human QA. D must be evaluated separately after the B/C identity is fixed.
