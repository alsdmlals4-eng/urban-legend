# M01 Anomaly D Adapt 01 — Approval Receipt

## Status

`USER_APPROVED_VISUAL_CANDIDATE / PROJECT_ASSET_APPROVED / IMPLEMENTED`

This record owns the one-image transparent high-risk anomaly candidate for M01 Recovery risk stage D.

## Binary

- PNG: `M01_ANOMALY_D_ADAPT_01.png`
- Dimensions: `941x1672`
- Bytes: `1,082,053`
- Pixel format: `ARGB` (transparent cutout)
- SHA-256: `a67933332cd5deb0f774553e3e785b87ac8646543caaa297a19c1acb17c96ad9`
- Generation date: `2026-08-26`
- Generation contract: `GENERATE_EXACTLY_ONE / COMPLETE`

## Consumer intent

- `scenes/battle_scene.tscn -> CinematicStage/AnomalyPanel/Content/AnomalyVisual`
- risk stage `D` uses this candidate through the existing `afterlife_d_cutout` route.

The candidate depicts one unnamed station-attendant-like humanoid with a coherent single figure and a forward-facing head/upper-body read. Its high-risk escalation is limited to an unnaturally continuing coat hem and slightly displaced uniform details; it does not depict duplicated faces or limbs, a scene background, or runtime UI.

## Approval boundary

User result approval confirmed this visual candidate and required durable storage in this repository and Project Notion. The user subsequently authorized Codex product promotion under GitHub Issue #246. The approved source now replaces only `assets/anomalies/cutouts/afterlife_d_cutout.png`; the asset catalog and full-image fallback remain unchanged. The 1280x720 live runtime check passed. Human QA and 1920x1080 runtime capture remain separate pending gates.
