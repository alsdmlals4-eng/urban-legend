# M04 D Anomaly Pixel Review — 2026-08-27

- GitHub Issue: #301.
- Actual consumer: `scenes/battle_scene.tscn -> CinematicStage/AnomalyPanel/Content/AnomalyVisual` at D risk (`risk >= 70`).
- Existing cutout: `assets/anomalies/cutouts/red_umbrella_d_cutout.png` — 1672×941 ARGB, SHA-256 `29137409dad49ec149d84f9dafeb5483c6eefb37035815f196ac9a5c8cd6c98d`.
- Existing fallback: `assets/anomalies/red_umbrella_d.png` — 1672×941 RGB, SHA-256 `8195e24af3c77b9f83e2b3461032689af9ce26b4c56c5d5bf9d560fe0a74867c`.

## Decision

`REPLACE_REQUIRED / ALPHA_CANDIDATE_BLOCKED`.

The current cutout is technically transparent but reads as a back-facing ordinary civilian. It does not progress the front-facing B/C apparition into a distinct D-risk identity. The fallback is a complete alley scene with multiple red-umbrella figures and floor reflections, so it cannot operate as the single transparent `AnomalyVisual` owner.

## Bounded output failure

Two D-candidate attempts were visually reviewed and then inspected at the file level:

| Attempt | SHA-256 | File fact | Disposition |
|---|---|---|---|
| 1 | `1680c03d641eba5f344b8af30d292eedd6ed3e1062c3b22cc5d30cc5bad737d0` | 1672×941, 24bpp RGB; four corners alpha 255 with baked checkerboard pixels | `REJECTED_NOT_PERSISTED` |
| 2 | `5e0bbce33f5afa9dfd42e8b66ad6007ab2ca2db6da518dc3c37752138d94ac8c` | 1672×941, 24bpp RGB; four corners alpha 255 with baked checkerboard pixels | `REJECTED_NOT_PERSISTED` |

Neither invalid output is a project asset, manifest entry, candidate receipt, Git artifact, or Notion attachment.

## Incident → Solution → Lesson

- Incident: the built-in generation surface returned a transparency-preview checkerboard as actual RGB pixels in two bounded D attempts.
- Solution: reject both outputs before durable storage, preserve the existing canonical D asset and runtime wiring, and document the exact alpha check result.
- Lesson: `NO_NEW_REUSE_LEARNING`; this is a project-local execution blocker. A future candidate route must prove 32-bit ARGB/RGBA pixels with alpha-zero surrounding corners before it can enter repository or Notion storage.

## Remaining gate

`HUMAN_QA_NOT_RUN` remains unchanged. Product promotion, runtime capture, and Notion asset registration are blocked until a genuine transparent D candidate exists.
