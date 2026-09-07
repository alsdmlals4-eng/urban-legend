# M01 Recovery Approved Asset Runtime Evidence — 2026-08-27

Issue: `#278`

## Scope and result

This is an actual Godot runtime check of the existing M01 Recovery consumers. It proves consumer resolution, import, and viewport readability only. It does not claim Human QA or product promotion for the newly generated D correction candidate.

| Consumer | 1280×720 | 1920×1080 launch profile | Result |
|---|---|---|---|
| `ArtLayer/Background` → `afterlife_recovery.png` | B-state capture | B-state capture | `RUNTIME_RESOLVED / READABLE` |
| `AnomalyVisual` B/C → `afterlife_b_cutout.png` | B and C captures | B and C captures | `RUNTIME_RESOLVED / READABLE` |
| `AnomalyVisual` D → `afterlife_d_cutout.png` | D capture | D capture | `RUNTIME_RESOLVED / VISUAL_CORRECTION_REQUIRED` |

The Godot launch profile requested `1920×1080`. The operating-system window decoration yields a captured game viewport of `1920×1061`; it is recorded exactly in the filenames rather than being represented as a full `1920×1080` pixel capture.

## Actual resource readback

- Background: `res://assets/backgrounds/afterlife_recovery.png`.
- B/C family uses the documented `afterlife_b_cutout.png` risk-stage resource.
- D readback: `res://assets/anomalies/cutouts/afterlife_d_cutout.png`.
- Candidate and canonical hashes match their individual receipt records.
- Hera diagnostics after the captures: `0` errors, `0` warnings.

## Captures

- `docs/qa/captures/m01/recovery_asset_runtime_20260827/m01-recovery-b-1280x720.png`
- `docs/qa/captures/m01/recovery_asset_runtime_20260827/m01-recovery-c-1280x720.png`
- `docs/qa/captures/m01/recovery_asset_runtime_20260827/m01-recovery-d-1280x720.png`
- `docs/qa/captures/m01/recovery_asset_runtime_20260827/m01-recovery-b-launch-1920x1080_capture-1920x1061.png`
- `docs/qa/captures/m01/recovery_asset_runtime_20260827/m01-recovery-c-launch-1920x1080_capture-1920x1061.png`
- `docs/qa/captures/m01/recovery_asset_runtime_20260827/m01-recovery-d-launch-1920x1080_capture-1920x1061.png`

## Visual correction finding

The existing D asset is technically resolved and readable, but it does not visibly escalate the same apparition represented by B/C: its clean, static uniformed silhouette lacks the authored D-state fragmentation and intrusion. `M01_ANOMALY_D_RUNTIME_CORRECTION_CANDIDATE_20260827` is the one-image correction candidate. It remains `NOT_PRODUCT_ASSET` until an explicit promotion comparison and runtime import/readback are complete.

## Explicitly not verified

- Real-player/Human QA.
- The candidate's runtime import or consumer fit.
- Product asset promotion/replacement.
- M01 background art-direction replacement.
