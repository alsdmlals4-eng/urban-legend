# D-2026-08-09-MAIN-MENU-CONTROL-ROOM-VERSIONING

Status: `DESIGN_DIRECTION_APPROVED / VERSION_POLICY_A_APPROVED / WRITTEN_SPEC_APPROVED / IMPLEMENTATION_PLAN_READY / PLANNING_EXACT_HEAD_CI_GREEN / RUNTIME_NOT_STARTED`

GitHub issue: #181

User written-spec approval: `2026-08-09 20:19 KST`

## Decision

The user approved two linked presentation decisions for the product main menu:

1. Replace the hard-coded `Ver 4.2` menu label with one canonical product-version source. The first value is `4.3`; future approved product/UI version steps advance sequentially `4.4`, `4.5`, and so on by changing that canonical source rather than duplicating literals in menus.
2. Redesign the main menu around the approved **괴이기록국 관제실형** direction: institutional occult bureau identity on the left, playable entry/actions in the center, and contextual intelligence/status on the right.

The written design at `docs/superpowers/specs/2026-08-09-main-menu-control-room-versioning-design.md` was explicitly approved by the user on 2026-08-09 20:19 KST. The TDD implementation plan is ready at `docs/superpowers/plans/2026-08-09-main-menu-control-room-versioning-implementation-plan.md`. Planning exact-head CI at `a748468d17435868a34863c77e9fdc24bc2e1960` completed 4/4 triggered workflows successfully before this canonical evidence update; this document update itself requires its own final exact-head CI before merge. Neither approval nor planning completion claims runtime implementation or Human QA PASS.

## Verified current cause

At project main `3118aba28e468d2796c9cd8fe1380b587c5c2df3`, `scripts/ui/main_menu.gd` contains:

```gdscript
const GAME_VERSION := "Ver 4.2"
```

The menu therefore cannot advance unless that source file is edited. `project.godot` declares Godot feature compatibility `4.7`; that is the engine feature version and must not be displayed as the product version.

## Preservation contract

The redesign must preserve the existing Package 2 main-menu behavior and stable control identities, including:

- `LegacyContinueButton`
- `LegacyNewCampaignButton`
- `ValidationPrimaryButton`
- `ValidationSecondaryButton`
- `DatabaseButton`
- Validation fail-closed behavior
- Legacy and Validation persistence isolation
- keyboard focus access and existing coordinator semantics

The visual hierarchy may change; save/domain semantics may not.

## Reference image boundary

The user approved the generated control-room mockup as a **REFERENCE_ONLY** design reference.

It is not a product asset. This Decision does not authorize:

- adding the generated image to tracked product assets;
- updating `ASSET_MANIFEST.yml` with it;
- increasing `PROJECT_ASSET_APPROVED` above `0`;
- copying illustrative dates, investigator names, risk values, save-slot contents, or other mockup-only fiction into product truth.

Implementation should reproduce the approved hierarchy and mood using existing project UI primitives/assets unless a separate asset decision later approves new product art.

## Separation

This Decision is separate from `D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT` and PR #180. Main-menu/version work must not be smuggled into PR #180.

## Validation ceiling

No runtime implementation or Human/UI/Android PASS is claimed by this Decision record. Next is the planning-PR final exact-head merge gate, then a separate implementation worktree/branch executes the approved TDD plan.