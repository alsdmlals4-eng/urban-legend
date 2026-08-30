# M01 Entrance Background Adapt 02 — Isolated Runtime Comparison

- **Status:** `CANDIDATE_RUNTIME_COMPARED / PROMOTION_RECOMMENDED / FINAL_USER_LOCK_REQUIRED`
- **Review date:** 2026-08-30
- **Exact reviewed local head:** `08393255464b75837705aff501b9820b586ed837`
- **Candidate:** `docs/visual/candidates/M01_ENTRANCE_BACKGROUND_ADAPT_02_20260828.png`
- **Candidate SHA-256:** `82f4378b3c662b18dc16566c0b52d496794f6495b6b1148e4d0aaabf317370a2`
- **Current canonical path:** `assets/backgrounds/afterlife_entrance.png`
- **Current canonical SHA-256:** `019d0203ca69f90070c67c3a0c6c180853703a6c4576d5a3449fde10911f82e8`
- **Approval boundary:** This is a candidate comparison receipt. It does not grant `USER_LOCKED`, `PROJECT_ASSET_APPROVED`, `IMPLEMENTED`, `RUNTIME_VERIFIED`, Human QA, accessibility QA, or release-rights clearance.

## Actual consumer readback

The one candidate was compared only through the existing shared product path, in a detached temporary worktree. The primary worktree, canonical PNG, catalog mapping, Scene wiring, episode data, and user save file were never changed.

| Consumer | Existing route | Observed result |
| --- | --- | --- |
| Main Menu backdrop | `scripts/ui/main_menu.gd` loads `afterlife_entrance` beneath the existing dark overlay | At 1280×720 the dossier rails retain the first visual read; at the larger requested 1920×1080 launch profile the candidate remains a restrained atmosphere rather than a menu illustration. |
| Main Menu current-case preview | `CurrentCasePreview` uses the M01 dialogue background | Hidden by the existing compact breakpoint at 1280×720; visible and still reads as a descending station threshold at the larger launch profile. |
| M01 dialogue `ArtLayer/Background` | `UiAssetCatalog` maps M01 dialogue to `afterlife_entrance` | No missing texture or load failure in either capture; the text/UI remains legible over the background. |
| M01 dialogue location preview | Existing background is reused by the small `LocationPanel` preview | The central descent, paired rails, and analog clock remain readable at 1280×720 and the larger launch profile. |

The requested 1920×1080 window produced a `1920×1061` client-area capture on this desktop because window chrome occupies the remaining height. This is recorded as observed runtime geometry, not reported as an exact 1920×1080 image capture.

## Three-alternative decision review

| Alternative | Shared-consumer result | Direction result | Decision |
| --- | --- | --- | --- |
| Keep current `afterlife_entrance.png` | Strong descending-station read, working current consumers | Grounded but comparatively photoreal/dark; less consistent with the locked soft-anime-noir and hand-drawn dossier split | `REUSE_VALID / NOT_PREFERRED` |
| `M01_ENTRANCE_BACKGROUND_ADAPT_01` | Generic corridor, central blank sign, and pillars consume the compact-preview focal area | Softer treatment, but it loses the narrative entry-threshold landmark | `REJECTED` — prior evidence remains valid |
| `M01_ENTRANCE_BACKGROUND_ADAPT_02_20260828` | Keeps the descending steps, paired rails, and clock landmark in every actual consumer | Better matches the locked grounded-environment + soft-anime-noir material language without adding character, anomaly, readable signage, answer clue, or baked UI | `PROMOTION_RECOMMENDED` after final user `LOCK` |

## Evidence loops

1. **Binary boundary:** verified the baseline SHA-256 in the primary worktree and a detached worktree before mounting the candidate; verified the mounted candidate SHA-256 exactly matched the receipt.
2. **Compact menu route:** captured the mounted candidate at the 1280×720 profile; the existing compact breakpoint continued to hide the secondary preview.
3. **Large menu route:** captured the mounted candidate at the requested 1920×1080 profile; `CurrentCasePreview` remained visible and did not compete with the product UI rails.
4. **Dialogue route:** captured M01 dialogue at 1280×720 and the requested 1920×1080 profile; full background and `LocationPanel` preview both loaded the mounted candidate.
5. **Consumer regression:** `ui_asset_catalog_test.gd` and `main_menu_window_breakpoint_test.gd` passed against the mounted candidate. Godot emitted its pre-existing shutdown leak warnings, so no warning-free runtime claim is made.
6. **Safety readback:** the protected user save SHA-256 was unchanged before/after every capture and test. The candidate existed only in the detached comparison worktree; the canonical product file remained at its original SHA-256.

## Required next gate

The candidate is the recommended promotion choice, but the asset pipeline requires the user to make the visual product decision explicitly:

```text
LOCK M01_ENTRANCE_BACKGROUND_ADAPT_02_20260828
→ exact-byte replacement at assets/backgrounds/afterlife_entrance.png
→ root ASSET_MANIFEST.yml receipt with provenance and SHA-256
→ existing consumer tests plus focused runtime recapture
→ PROJECT_ASSET_APPROVED / IMPLEMENTED / machine runtime evidence
```

Until that lock, preserve the current canonical PNG and all existing runtime mappings. Human/new-player/accessibility/release-rights gates remain separate and `NOT_RUN`.
