# M04 Entrance Background Adapt 01 — Isolated Runtime Comparison

- **Status:** `CANDIDATE_RUNTIME_COMPARED / PROMOTION_RECOMMENDED / FINAL_USER_LOCK_REQUIRED`
- **Review date:** 2026-08-30
- **Exact reviewed local head:** `01dea864398a1c5d369d1455c71f5347e97bda17`
- **Candidate:** `docs/visual/candidates/M04_ENTRANCE_BACKGROUND_ADAPT_01_20260827.png`
- **Candidate SHA-256:** `0beea877665acb7bc60d5c7e6d6e5c67b48e41fc0f65c7cfa46e321766959b9c`
- **Current canonical:** `assets/backgrounds/red_alley_entrance.png`
- **Current canonical SHA-256:** `e05feff89439a26354182b71b6c550bbec8528b1752fcab173010089f2f8a299`
- **Approval boundary:** This is a candidate comparison receipt. It does not grant `USER_LOCKED`, `PROJECT_ASSET_APPROVED`, `IMPLEMENTED`, `RUNTIME_VERIFIED`, Human QA, accessibility QA, or release-rights clearance.

## Actual consumer readback

The one candidate was compared only through the existing product path in a detached temporary worktree. The primary worktree, canonical PNG, catalog mapping, Scene wiring, episode data, and user save file were never changed.

| Consumer | Existing route | Observed result |
| --- | --- | --- |
| M04 dialogue background | `scripts/ui/ui_asset_catalog.gd` resolves `red_alley_entrance`; dialogue scene renders it behind the character cutouts and live dialogue surface | At 1280×720 and the requested 1920×1080 profile, the collapsed red umbrella remains an immediate lower-left cue, the warm lamp and central wet path retain the quiet Korean side-alley read, and no readable sign, commercial striping, baked UI, people, or answer clue is introduced. |
| Main menu current-case preview | `main_menu.gd` loads the same catalog asset for the non-compact `CurrentCasePreview` | At the requested 1920×1080 profile the preview remains a subordinate case cue, not a competing hero panel. At 1280×720 the existing compact breakpoint hides it, as designed. |

The requested 1920×1080 captures had a 1920×1061 client area because the visible Windows frame consumed vertical pixels. They are valid route/readability observations, not a claim of an exact 1920×1080 client capture.

## Three-alternative decision review

| Alternative | Shared-consumer result | Direction result | Decision |
| --- | --- | --- | --- |
| Keep current `red_alley_entrance.png` | Umbrella is prominent and both consumers work | Strongly photoreal, with convenience-store-like striped signage that conflicts with the locked grounded urban-occult / soft-anime character split | `REUSE_VALID / NOT_PREFERRED` |
| Immediate replacement without consumer comparison | Would avoid retaining the branded read | No evidence for dialogue crop, menu hierarchy, or save safety; violates the candidate-promotion boundary | `REJECTED` |
| `M04_ENTRANCE_BACKGROUND_ADAPT_01_20260827` through isolated consumer comparison | Retains the red umbrella and readable path in dialogue; remains subordinate in the non-compact preview | Removes brand/text cues and is closer to the quiet, grounded urban-occult material language without adding characters, anomaly resolution, answer text, or baked UI | `PROMOTION_RECOMMENDED` after final user `LOCK` |

## Evidence loops

1. **Binary boundary:** verified the baseline SHA-256 in the primary worktree and a detached worktree before mounting the candidate; verified the mounted candidate SHA-256 exactly matched its receipt.
2. **Dialogue route:** captured the mounted candidate at 1280×720 and at the requested 1920×1080 profile; the existing dialogue path resolved the mounted image behind its separate character and live-UI owners.
3. **Menu route:** captured the mounted candidate at the requested 1920×1080 profile; `CurrentCasePreview` remained visible but visually subordinate. The 1280×720 compact capture continued to hide that secondary preview.
4. **Candidate-versus-baseline review:** observed each of the same consumer states against the canonical baseline. The candidate removes the bright convenience-store-style striping while retaining the case's red-umbrella cue.
5. **Consumer regression:** `ui_asset_catalog_test.gd` and `main_menu_window_breakpoint_test.gd` passed against the mounted candidate. Godot emitted its existing shutdown object/RID leak warnings, so no warning-free runtime claim is made.
6. **Safety readback:** the protected user save SHA-256 was unchanged before/after every import, capture, and test. The candidate existed only in the detached comparison worktree; the canonical product file remained at its original SHA-256.

## Required next gate

The candidate is the recommended promotion choice, but the asset pipeline requires the user to make the visual product decision explicitly:

```text
LOCK M04_ENTRANCE_BACKGROUND_ADAPT_01_20260827
→ exact-byte replacement at assets/backgrounds/red_alley_entrance.png
→ root ASSET_MANIFEST.yml receipt with provenance and SHA-256
→ existing consumer tests plus focused runtime recapture
→ PROJECT_ASSET_APPROVED / IMPLEMENTED / machine runtime evidence
```

Until that lock, preserve the current canonical PNG and all existing runtime mappings. Human/new-player/accessibility/release-rights gates remain separate and `NOT_RUN`.
