# M01 Investigation Platform Adapt 02 — Candidate and Promotion Receipt

## Status

`PROJECT_ASSET_APPROVED / IMPLEMENTED / RUNTIME_VERIFIED / HUMAN_QA_PENDING`

The sole decision owner delegated routine, current-slice visual production, local repository storage, Notion delivery, and Godot machine validation. This receipt records that bounded authorization; it does not claim Human usability, player experience, release clearance, or a broader art-direction change.

## Binary identity

- Candidate and canonical bytes: `M01_INVESTIGATION_PLATFORM_ADAPT_02_20260827.png`
- Dimensions: `1672x941`
- Bytes: `2,212,772`
- SHA-256: `4e21b9f14f2889e11bcff1872dc5f7cf07d020d24617e2b6c948a7683f32d4be`
- Canonical product path: `assets/backgrounds/afterlife_platform.png`
- Superseded canonical SHA-256: `d4b7bfd6e5cda3293bf5e37a8b050f29e03d88501c3b217e681714a4bde1bdad`

## Exact consumer and decision

- `scenes/investigation_scene.tscn -> ArtLayer/Background`
- shared `LocationPreview`

`M01_INVESTIGATION_PLATFORM_ADAPT_01` was not promoted: its dominant central pillar and blank plaque obscured the place read at the small preview size. Adapt 02 uses an open left-to-center platform sightline, tiled-wall rhythm, off-center small sign silhouette, distant tunnel, and train only on the right. It keeps the image textless and characterless, with no embedded rule answer or M04 material.

## Runtime evidence

- Baseline capture: `docs/qa/M01_INVESTIGATION_PLATFORM_CURRENT_CONSUMER_1280x720_20260827.png`
- Baseline capture: `docs/qa/M01_INVESTIGATION_PLATFORM_CURRENT_CONSUMER_1920x1080_20260827.png`
- Candidate capture: `docs/qa/M01_INVESTIGATION_PLATFORM_ADAPT_02_CANDIDATE_1280x720_20260827.png`
- Candidate capture: `docs/qa/M01_INVESTIGATION_PLATFORM_ADAPT_02_CANDIDATE_1920x1080_20260827.png`

The exact candidate bytes were mounted only in an isolated worktree for the two captures, then the original bytes were SHA-256-verified on restore before permanent promotion. Hera reported both `ArtLayer/Background` and `LocationPreview` loading the existing canonical path, 0 errors, 0 warnings, nonblank output, and no possible clipping at 1280×720 and 1920×1080.

## Provenance and rights boundary

- Generation tool: OpenAI built-in image generation; model identifier and seed were not exposed.
- Prompt did not request a third-party character, logo, named style, or copied composition.
- This is project provenance and an obvious-conflict review, not legal clearance. Final distribution-rights review remains required before release.

## Notion delivery

The repository is the durable binary owner. Notion receives the same PNG as a native attachment and a SHA-256 receipt after the current-task PR is remotely readable, so the attachment uses a durable project URL rather than an expiring local session path.
