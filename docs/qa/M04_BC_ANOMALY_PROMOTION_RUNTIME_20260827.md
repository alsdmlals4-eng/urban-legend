# M04 B/C Anomaly Promotion Runtime Evidence

- GitHub Issue: #299.
- Canonical asset: `assets/anomalies/cutouts/red_umbrella_b_cutout.png`.
- Candidate/canonical SHA-256 match: `cc1402eb914644198217bc9c3e12a03095a22df2089a3813c93b3660bb5810e5`.
- Actual consumer: `BattleScene/CinematicStage/AnomalyPanel/Content/AnomalyVisual` resolved the canonical B/C cutout after Godot reimport.
- Existing presentation retained: `KEEP_ASPECT_COVERED`; no Scene, catalog, fallback, UI, or gameplay change was introduced.

| Launch resolution | Capture | SHA-256 | Result |
|---|---|---|---|
| 1280x720 | `docs/qa/captures/m04/bc_promotion_20260827/m04-bc-promoted-1280x720.png` | `1110188b62ecc840cac4279eb3ff329bd0f80d30e6cf55b8bc7e94874cb102c2` | `RUNTIME_RESOLVED / READABLE` |
| 1920x1080 | `docs/qa/captures/m04/bc_promotion_20260827/m04-bc-promoted-1920x1080.png` | `6581a8bfcaea47c8c825d692bd41245d3dc04a3ff6483e7f745933cea79bd14e` | `RUNTIME_RESOLVED / READABLE` |

The rendered captures show the centered red umbrella, masked face-void, and dissolving coat inside the existing Anomaly panel without a baked environment or UI. The broader M04 background is unchanged and Human QA remains `NOT_RUN`.

## Incident -> Solution -> Lesson

- Incident: a first generation supplied a checkerboard RGB image instead of transparent pixels; the first graphical test then exposed an incorrect `KEEP_ASPECT_CENTERED` test expectation. A first import also produced broad regenerated `.import`/`.uid` worktree noise.
- Solution: reject the RGB output, validate alpha before storage, preserve the scene's actual `KEEP_ASPECT_COVERED` behavior, capture the real M04 consumer at both target resolutions, and transfer only the reviewed source asset, evidence, and test files to a clean worktree.
- Lesson: `NO_NEW_REUSE_LEARNING`; this is a project-local asset-promotion verification pattern, not a Base promotion candidate.
