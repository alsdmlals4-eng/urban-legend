# M01 Anomaly D — Product Promotion Record

## Status

`PROJECT_ASSET_APPROVED / IMPLEMENTED / 1280_RUNTIME_VERIFIED`

## Authority and scope

- User approved the visual candidate, then explicitly authorized Codex implementation and product promotion on 2026-08-26.
- Implementation contract: [GitHub Issue #246](https://github.com/alsdmlals4-eng/urban-legend/issues/246).
- Only the existing D-risk cutout is replaced. The scene, catalog route, episode data, and full-image fallback remain unchanged.

## Provenance and replacement boundary

- Approved source: `docs/visual/candidates/M01_ANOMALY_D_ADAPT_01.png`
- Approved source SHA-256: `a67933332cd5deb0f774553e3e785b87ac8646543caaa297a19c1acb17c96ad9`
- Canonical product file: `assets/anomalies/cutouts/afterlife_d_cutout.png`
- Previous tracked binary SHA-256: `fc90aa96ce8d203688f1ba09c2ef8fa89ab3d1e386fe59021fb7643105c1c1ad`
- Replacement history: preserved in Git; no prior file is deleted from repository history.
- Notion visual record: `3c51b237-eb1c-81ae-abf2-f94a5146aa0f` (native candidate attachment remains retained).

## Runtime evidence

- Godot reimported the canonical PNG and the actual D-risk consumer resolved `res://assets/anomalies/cutouts/afterlife_d_cutout.png`.
- Live D-risk view: `docs/visual/candidates/M01_ANOMALY_D_RUNTIME_1280x720.png` (1280x720; SHA-256 `65f27649e7e2c7e72c00d0dde40d285253c86c03c0d2f6c7de9e0f6878d391e5`).
- Runtime diagnostics: no errors or warnings after the D-risk preview.
- The figure is singular, readable, and contained in the existing `AnomalyVisual` rectangle; no duplicate-image overlap was observed.

## Remaining validation boundary

- The project uses a fixed 1280x720 logical viewport with canvas-item stretching. A real 1920x1080 capture was not run because the active runtime could not be resized through the approved live-control surface without changing project configuration.
- Human visual/accessibility QA remains pending and must not be inferred from this automated runtime check.
