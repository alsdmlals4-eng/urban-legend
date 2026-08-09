# UI hierarchy regression attribution — 2026-08-09

- Decision: `D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT`
- Status: `BASELINE_REGRESSION_SEPARATED / RECOVERABLE_VERIFICATION_BLOCKER`

## Scope

This records only the attribution of `tests/minigame_pipeline_test.gd`.
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

## Decision

Because pristine main and the tool commit both fail at the same assertion, this is a pre-existing baseline regression. It is not attributed to tool canonicalization, the UI hierarchy GREEN change, or the RED test addition.

The UI change must not alter save/minigame code to mask this regression. Full regression PASS and merge-ready status are not claimed.

## UI-focused evidence

Using the exact UI code/test blobs from the UI change on the RED source snapshot:

- Godot import: PASS
- `anomaly_manual_drawer_test.gd`: PASS
- `cinematic_ui_redesign_test.gd`: PASS
- `mvp043_investigation_ui_test.gd`: PASS

## Remaining validation

- Human/UI/Android: `NOT_RUN`
- Full Godot regression: blocked from PASS claim by the separated baseline failure
- Required next external evidence: exact-head CI after the clean UI-only branch update
