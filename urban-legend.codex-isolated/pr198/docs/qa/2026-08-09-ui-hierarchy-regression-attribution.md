# UI hierarchy regression attribution — 2026-08-09

- Decision: `D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT`
- Status: `BASELINE_REGRESSION_SEPARATED / UI_ONLY_PR_PRECEDING_EXACT_HEAD_CI_GREEN / HUMAN_UI_ANDROID_NOT_RUN`

## Scope

This records the attribution of `tests/minigame_pipeline_test.gd` and the subsequent UI-only PR verification.
No save or minigame-domain code was changed.

## Reproduction condition

Each revision used an isolated source snapshot, empty per-run `APPDATA`, `LOCALAPPDATA`, `USERPROFILE`, and `HOME`, Godot 4.7.1 stable console, then:

```text
godot --headless --path <snapshot> --import --quit
godot --headless --path <snapshot> --script res://tests/minigame_pipeline_test.gd
```

| Revision | Import | Test | Same failure |
|---|---:|---:|---|
| pristine main `3118aba28e468d2796c9cd8fe1380b587c5c2df3` | 0 | 1 | `save payload should preserve game-specific details` |
| tool `0f7574139823e51e023dc2fe9948bebffd4efbed` | 0 | 1 | same assertion |
| RED `96792b782c6ef333626ab0aca2351cafaa905846` | 0 | 1 | same assertion |

## Attribution decision

Because pristine main and the tool commit both fail at the same assertion, this is a pre-existing baseline regression. It is not attributed to tool canonicalization, the UI hierarchy GREEN change, or the RED test addition.

The UI change must not alter save/minigame code to mask this regression.

## UI-focused evidence

Using the exact UI code/test blobs from the UI change on the RED source snapshot:

- Godot import: PASS
- `anomaly_manual_drawer_test.gd`: PASS
- `cinematic_ui_redesign_test.gd`: PASS
- `mvp043_investigation_ui_test.gd`: PASS

## Tool-stack separation

The UI PR was then reduced to the approved UI/test/attribution scope by restoring these four tool/governance paths to the project `main` blobs without rewriting UI content:

- `addons/godot_ai/plugin.cfg`
- `addons/godot_ai/runtime/game_helper.gd`
- `docs/operations/GODOT_TOOL_AUTHORITY_LEDGER.json`
- `project.godot`

The resulting preceding UI-only head was `e3e2dd1a9c83e12918473fb4ff207bfb77e49e30` with 9 changed files and no `assets/**` paths.

## Preceding exact-head CI evidence

All pull-request workflows triggered for `e3e2dd1a9c83e12918473fb4ff207bfb77e49e30` completed successfully:

- Validate Project Base Adapter — run `31286399999`: PASS
- Validate Urban Legend BCA Adoption — run `31286399996`: PASS
- Validate documentation contracts — run `31286399998`: PASS
- Validate Canon v2 Runtime UX — run `31286399976`: PASS
- Validate full matrix — run `31286399979`: PASS
- Validate core and documentation baseline — run `31286400020`: PASS
- Validate ANNUAL-MVP-001 — run `31286399981`: PASS

The full-matrix Python jobs and `godot-ubuntu` job passed, and the core/annual workflows also completed their Godot 4.7.1 imports and maintained full regressions successfully.

This section is deliberately recorded as **preceding exact-head evidence**. Updating this tracked document creates a new commit, so current-head authority must be read from GitHub Actions and the synchronized Google Sheet rather than self-referenced here.

## Remaining validation

- Current exact-head CI after this evidence-only document update: REQUIRED
- Human/UI/Android: `NOT_RUN`
- `PROJECT_ASSET_APPROVED`: `0`
- Product image generation/deletion/promotion: not authorized by this decision
- Merge-ready status: not claimed until current-head CI and remaining review gates are re-read
