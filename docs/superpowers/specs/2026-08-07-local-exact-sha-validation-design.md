# Local Exact-SHA Validation Correction Design

- Decision ID: `UL-DEC-LOCAL-VALIDATION-001`
- Approved by user: `2026-08-07 07:37 KST`
- Project repository: `alsdmlals4-eng/urban-legend`
- Design base: project `main` at `d79b79a0a51ed533f48be30b77e95cdd8c433ce4`
- Base authority reference: `alsdmlals4-eng/Base` `main` at `4f98f968a377f7b6a11aafa4fc94d11bddbebedc`
- Lifecycle state: `DESIGN_APPROVED / SPEC_REVIEW_PENDING / IMPLEMENTATION_NOT_STARTED / ADOPTED_ACTIVE_NOT_CLAIMED`

## 1. Purpose

GitHub Actions budget unavailability left two required matrix jobs and the Live Editor adoption-contract job unevidenced. The approved local route must reproduce the required checks at one exact project SHA without weakening fail-closed semantics or treating local output as an automatic lifecycle promotion.

The local runs at `d79b79a0a51ed533f48be30b77e95cdd8c433ce4` established two repository defects that prevent a clean exact-SHA validation:

1. `tests/test_godot_live_editor_adoption.py` still requires the pre-GUT single-plugin string even though the approved project state enables both `godot_ai` and GUT.
2. Godot 4.7.1 import creates the missing companion file `tests/gut/test_validation_route_mapper.gd.uid`, leaving a clean checkout dirty after import.

This design corrects only those two defects and then reruns the objective local validation set.

## 2. Verified Baseline

The following results are evidence for the design baseline, not completion claims:

- Windows Python 3.11.9: `415/415 PASS`
- Windows Python 3.12.10: `415/415 PASS`
- Windows Python 3.13.14: `415/415 PASS`
- Ubuntu 24.04 / WSL2 Python 3.12.3: `415/415 PASS`
- Windows Python 3.14.7 compatibility run: `415/415 PASS`; informational only
- Live Editor focused contract: `4 PASS / 1 FAIL`
- Failure: stale exact string requiring only `res://addons/godot_ai/plugin.cfg`
- Godot: `4.7.1.stable.official.a13da4feb`
- Godot headless import: completed successfully
- Tracked protected-path diff after import: clean
- Post-import worktree: dirty only because `tests/gut/test_validation_route_mapper.gd.uid` was untracked
- Generated UID content: `uid://ctcbx5pl1hwyl`
- Generated UID SHA-256: `4243BF1669E3DFD330A9A8D816C5D6F471B41814BF2C2A624B128EE1C03FA9A8`
- Delete-and-reimport result in the same Godot cache: exact content and hash match; classified `UID_REGENERATION_EXACT_MATCH_CACHE_ASSISTED`

The cache-assisted result proves stable restoration in the tested environment, not cross-machine deterministic generation. Tracking the approved companion file makes the repository value authoritative for later clean checkouts.

## 3. Scope

### 3.1 Planned implementation files

Only these implementation files may change:

- Create `tests/gut/test_validation_route_mapper.gd.uid`
- Modify `tests/test_godot_live_editor_adoption.py`

The design and implementation plan under `docs/superpowers/` are governance artifacts and do not expand the product-change surface.

### 3.2 Explicit exclusions

The correction must not modify:

- `project.godot`
- `addons/gut/**`
- `scripts/**`
- `scenes/**`
- `assets/**`
- `data/**`
- save schemas or runtime behavior
- product images, UI, Android state, or Human QA state

No GitHub Actions retry is part of this design while the budget block remains active.

## 4. Correction Design

### 4.1 Canonical GDScript UID companion

Add `tests/gut/test_validation_route_mapper.gd.uid` with exactly:

```text
uid://ctcbx5pl1hwyl
```

Requirements:

- UTF-8 text
- one logical line
- no additional metadata
- implementation verification must confirm the exact content
- after a clean Godot 4.7.1 import, `git status --porcelain` must be empty

The file is a companion identity artifact for the existing GUT test script. It does not change test behavior.

### 4.2 Live Editor plugin assertion

Replace the stale whole-string assertion with a bounded parser for the `[editor_plugins]` `enabled=PackedStringArray(...)` entry.

The parser must:

- inspect only the `[editor_plugins]` section
- extract quoted resource paths from the `enabled` value
- require both `res://addons/godot_ai/plugin.cfg` and `res://addons/gut/plugin.cfg`
- fail when either required authority is absent
- avoid accepting an unrelated occurrence elsewhere in `project.godot`

The test may permit additional future plugins only when the authority contract does not prohibit them. This correction does not authorize any new plugin; it only recognizes the two already approved and installed plugins.

## 5. Validation Architecture

Validation is exact-SHA and fail-closed. Every command records the branch SHA before and after execution. A result is invalid when the SHA moves, the worktree has an unexpected change, or a required command is not run.

### 5.1 Required Python matrix

- Windows Python 3.11: `python -m unittest discover -s tests -p "test_*.py"`
- Windows Python 3.12: same command
- Windows Python 3.13: same command
- Ubuntu 24.04 / WSL2 Python 3.12: same command
- Python 3.14: optional compatibility information and never a required gate

### 5.2 Focused Live Editor contract

Run with Python 3.12, pytest 8.3.5, and jsonschema 4.23.0:

```text
python -m pytest tests/test_godot_live_editor_adoption.py -q
```

Required result: `5 passed`.

### 5.3 Godot import and repository cleanliness

Using Godot `4.7.1.stable.official.a13da4feb`:

```text
godot --headless --path . --import
```

Required results:

- exit code 0
- tracked protected-path diff clean
- complete worktree clean after import
- exact SHA unchanged

### 5.4 GUT and regression

Run the established GUT command against `tests/gut`, emit JUnit XML, and require:

- GUT test result success
- JUnit reports no failure or error
- existing Godot regression suite success
- protected paths remain unchanged

### 5.5 Base reusable pilot

Run the existing Live Editor reusable-pilot contract against immutable Base pilot commit `2b595570bd237174b2b962a1eb54588b5ecc508d`. Base `main` movement does not silently change this pilot pin.

## 6. Failure Handling

Validation must stop and report a precise non-PASS state when any of these occur:

- current HEAD differs from the declared exact SHA
- pre-run worktree is not clean except for an explicitly staged correction under review
- Godot version is not 4.7.1
- required Python interpreter is missing
- any required Python suite fails
- Live Editor contract is not `5 passed`
- Godot import creates an unexpected file or modifies a tracked protected path
- GUT or JUnit fails
- regression fails
- Base pilot is not run or fails

`NOT_RUN`, `BLOCKED`, and `FAIL` must never be rewritten as `PASS`.

## 7. Evidence and Lifecycle Claims

Implementation evidence must identify:

- Decision ID `UL-DEC-LOCAL-VALIDATION-001`
- project exact SHA
- Base main SHA observed at validation time
- immutable Base pilot pin
- OS, Python, Godot, pytest, and jsonschema versions
- command result and exit status for every required check
- pre/post worktree state
- UID content and SHA-256

Passing this correction permits the bounded claim `LOCAL_EXACT_SHA_VALIDATED`. It does not by itself permit `ADOPTED_ACTIVE`. Lifecycle promotion requires an explicit authority acceptance after all required objective evidence is reviewed.

Human QA, UI/accessibility QA, Android QA, and product-image approval remain outside this correction and retain their existing states.

## 8. GitHub and Google Sheet Synchronization

The same Decision ID must appear in both authorities:

- GitHub authority surface: this design spec and its Draft PR
- Google Sheet: `02_현재_확정결정` and `99_변경이력`

At spec stage the Sheet state must be:

```text
DESIGN_APPROVED / SPEC_REVIEW_PENDING / IMPLEMENTATION_NOT_STARTED / ADOPTED_ACTIVE_NOT_CLAIMED
```

The project hub must not claim full local validation until implementation and reruns are complete.

## 9. Rollback

Rollback is limited to reverting the correction commit:

- remove the added `.gd.uid` companion
- restore the prior Live Editor assertion

Because no product runtime or product data changes are allowed, rollback does not require a save migration or content rollback. A rollback returns the state to the known baseline defects and therefore also returns local exact-SHA validation to `FAIL/BLOCKED`.

## 10. Acceptance Criteria

The design is ready for implementation planning only after the user reviews this committed spec. The later implementation is complete only when all of the following are true on one exact correction SHA:

1. implementation change surface is limited to the two approved implementation files
2. Live Editor focused contract reports `5 passed`
3. required Windows and Ubuntu Python matrix passes
4. Godot 4.7.1 import exits successfully and leaves a clean worktree
5. GUT/JUnit passes
6. established Godot regression passes
7. Base reusable pilot passes or is truthfully reported as non-PASS
8. protected paths are unchanged
9. GitHub and Google Sheet use `UL-DEC-LOCAL-VALIDATION-001`
10. no `ADOPTED_ACTIVE` claim is made without separate explicit acceptance
