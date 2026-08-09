# Main Menu Control-Room + Product Versioning Design

Decision: `D-2026-08-09-MAIN-MENU-CONTROL-ROOM-VERSIONING`

Status: `WRITTEN_SPEC_REVIEW_REQUIRED`

Issue: #181

## 1. Goal

Turn the current document-like main menu into a clear, game-first **괴이기록국 관제실형** title hub while preserving all existing Legacy/Validation routing and persistence guarantees.

The same slice fixes the visible version drift by replacing the menu-local `Ver 4.2` literal with one canonical product-version source whose first approved value is `4.3`.

Success means a player can immediately answer three questions without reading a long scroll page:

1. What game/institution am I entering?
2. What is my primary playable action now?
3. Is this Legacy 본편 or a separate Validation record?

## 2. Current state and root cause

At project main `3118aba28e468d2796c9cd8fe1380b587c5c2df3`:

- `scenes/main_menu.tscn` is intentionally minimal and attaches `scripts/ui/main_menu.gd` to the root `Control`.
- `main_menu.gd` builds almost the whole screen at runtime.
- `main_menu.gd` hard-codes `const GAME_VERSION := "Ver 4.2"`.
- `project.godot` declares engine feature compatibility `4.7`; it is not a product-version source.
- `tests/validation/validation_main_menu_contract_test.gd` already protects stable node names, Legacy/Validation independence, fail-closed Validation behavior, and keyboard focusability.

Therefore the version bug must be fixed at its source, and the visual redesign must preserve the existing routing contract rather than replacing it with a second menu state machine.

## 3. Approved visual direction

The approved mockup is a **REFERENCE_ONLY** visual target. Its hierarchy is canonical for this design; its illustrative product data is not.

### 3.1 Overall composition

Use a 16:9 full-screen bureau control-room composition with three functional rails:

```text
┌──────────────────────────────────────────────────────────────────────┐
│ LEFT IDENTITY        │ CENTER ACTIONS        │ RIGHT INTELLIGENCE     │
│                      │                       │                        │
│ 괴이기록국           │ 본편                  │ 현재 사건              │
│ Bureau identity      │  primary action       │ compact case summary   │
│ Ver 4.3              │  secondary action     │                        │
│                      │                       │ 최근 기록 / 상태       │
│ clearance framing    │ Validation            │ 위험/보호 요약         │
│                      │  primary/secondary    │                        │
│                      │                       │ 저장/기록 상태         │
│                      │ 기록 보관실           │                        │
│                      │ 설정 / 접근성         │                        │
│                      │ 종료                  │                        │
└──────────────────────────────────────────────────────────────────────┘
```

This must feel like a playable game title screen, not a vertically stacked documentation form.

The mockup's exact button order is not a new routing rule. Within the 본편 group, the **meaningful available action for the current save state** receives primary visual emphasis while the stable Legacy action identities remain unchanged.

### 3.2 Left identity rail

Persistent, low-interaction identity area:

- large `괴이기록국` title;
- optional small English subtitle such as `Urban Legend Archive Bureau`;
- canonical product label `Ver 4.3`;
- restrained institutional/clearance framing;
- no invented story facts required to fill space.

The title/version remain readable at both target resolutions.

### 3.3 Center action rail

This is the visual and keyboard priority.

Group by domain, not by implementation history:

```text
본편
- LegacyContinueButton
- LegacyNewCampaignButton
- whichever is meaningful for the current save state receives primary emphasis

Validation
- ValidationPrimaryButton semantic action from the existing summary
- ValidationSecondaryButton only when the existing contract exposes it

utility
- 기록 보관실 / DatabaseButton
- 설정 / existing accessibility surface
- 종료
```

The existing Legacy and Validation actions keep their current semantics and stable node identities. The redesign may change surrounding labels, panels, icon treatment, spacing, selection highlight, and explanatory copy, but it may not merge their persistence domains.

Default keyboard focus must land on the same meaningful action that receives primary visual emphasis. Visible keyboard order must match visual order; a disabled or hidden action must not become a focus dead-end.

### 3.4 Right intelligence rail

The approved mockup shows modules such as current case, recent records, risk, protection, and save status. These are **presentation slots**, not permission to create new canon.

Rules:

- Populate a module only from already available canonical runtime/read-only summary data.
- Do not derive hidden truth, correct answers, or future outcomes.
- Do not copy mockup-only dates, investigator names, risk ranks, save timestamps, slot numbers, or case metadata unless an existing project authority already exposes those exact values.
- When a data category is unavailable, prefer a compact neutral/unavailable state or omit the secondary module rather than inventing a value.
- The right rail must remain read-only; it does not become a new save or domain authority.

The right rail is secondary to the center action rail and is the first area allowed to simplify at lower resolution.

## 4. Visual language

Use existing project assets and Godot UI primitives to approximate the approved mood:

- dark charcoal/black base;
- muted green monitor glow;
- restrained red warning accents;
- warm ivory/gold selected-action highlight;
- thin institutional HUD borders;
- analog archive texture/filing-room cues mixed with modern control-panel hierarchy;
- strong contrast between selected, available, disabled, and separate Validation states;
- non-color text/icon/shape cues remain available for status distinctions.

No new product image is required by this Decision.

The generated mockup itself must not be added as a tracked product asset, promoted through `ASSET_MANIFEST.yml`, or counted toward `PROJECT_ASSET_APPROVED`.

## 5. Product-version architecture

### 5.1 Canonical source

Create one source-level product version owner, recommended path:

```text
scripts/core/product_version.gd
```

Recommended public contract:

```gdscript
class_name ProductVersion
extends RefCounted

const CURRENT := "4.3"

static func display_text() -> String:
    return "Ver %s" % CURRENT
```

`main_menu.gd` consumes this owner instead of defining `GAME_VERSION` locally.

### 5.2 Meaning

Product version and Godot engine version are separate concepts:

```text
Product/UI version: 4.3, 4.4, 4.5, ...
Godot engine feature/runtime: 4.7 / target executable 4.7.1
```

The UI must never infer the product version from `config/features`, executable version, addon version, Git hash, or save schema.

### 5.3 Update policy

Current approved value: `4.3`.

Future approved product/UI version steps advance by editing only the canonical product-version owner. A version increment is not automatically triggered by every commit, PR, CI run, engine upgrade, or addon update.

## 6. Resolution behavior

### 6.1 1280×720

Primary target behavior:

- title and `Ver 4.3` visible without scrolling;
- center playable actions visible without scrolling;
- Legacy vs Validation distinction visible at first glance;
- current status/error feedback remains readable;
- right intelligence rail compacts secondary modules before any primary action disappears;
- long Korean text uses concise copy and wrapping without covering controls;
- screen must not regress into one giant `ScrollContainer` document wall.

Allowed compacting order:

1. reduce decorative gaps and low-value framing;
2. shorten right-rail explanatory copy;
3. hide lowest-priority right-rail modules;
4. reduce existing preview/image height;
5. keep title, version, primary actions, Validation distinction, status/error feedback, and focus/back route.

### 6.2 1920×1080

Use the additional area to expose more of the right intelligence rail and atmosphere. Do not increase core action travel distance so much that the menu becomes slower to operate.

## 7. Interaction and accessibility

Preserve existing stable controls and behavior protected by the Package 2 contract:

- `LegacyContinueButton`
- `LegacyNewCampaignButton`
- `ValidationPrimaryButton`
- `ValidationSecondaryButton`
- `DatabaseButton`
- `LegacyStatusLabel`
- `ValidationStatusLabel`
- `ValidationBadgeLabel`
- existing Validation dialogs

Required interaction behavior:

- pointer target and keyboard focus highlight communicate the same selected item;
- focus order follows the visible center action order;
- Validation disabled/error states remain fail-closed;
- corrupt/incompatible Validation data never disables Legacy access;
- status meaning is not color-only;
- `ui_cancel`/dialog behavior remains consistent with existing coordinator semantics;
- settings/accessibility presentation must reuse existing settings/accessibility authority rather than invent a new persistence model.

## 8. Data and save boundaries

Forbidden in this slice:

- changes to Legacy/Validation save schemas;
- merging Legacy and Validation repositories;
- writing menu-only status back into save data;
- new hidden ranking, danger, protection, or investigation truth;
- changes to `scripts/core/game_state.gd` domain meaning;
- changes to `data/episodes/**` merely to populate the dashboard;
- product asset promotion;
- `project.godot` changes unless a later implementation plan proves a separate approved necessity.

If the right rail cannot be populated from current public/read-only state, reduce the rail rather than changing domain truth to satisfy the mockup.

## 9. Implementation authority boundary

This written design does not itself authorize persistent Godot Scene/Node/Resource/Project Settings mutation outside the existing project authority model.

The current scene is only a root Control plus script, so most expected implementation is script/UI presentation work. If implementation later requires persistent Scene/Node/Resource/Project Settings changes, HiGodot remains the sole persistent Godot authoring authority.

GUT remains non-authoring test authority. Hera is outside this Decision; if it is available under a separately verified tool state, it may be used only within that tool state's live-QA/observability boundary and never as persistent product authoring authority.

## 10. Testing contract for the later implementation plan

The implementation plan must use TDD and preserve the existing Package 2 suite.

At minimum it must add failing-before-fix assertions for:

1. canonical product owner reports `4.3` and main menu displays `Ver 4.3`;
2. `main_menu.gd` no longer owns a `Ver 4.2` or duplicate product-version literal;
3. required stable Legacy/Validation controls still exist;
4. Legacy and Validation continue independently under EMPTY/active/completed/corrupt Validation states;
5. primary visual action and initial keyboard focus agree, and center focus order remains valid;
6. 1280×720 primary menu contract fits without requiring a vertical document-wall scroll path;
7. right-rail unavailable data does not fabricate canon or block primary actions;
8. no `assets/**`, root `ASSET_MANIFEST.yml`, save schema, `data/episodes/**`, or protected domain changes are introduced by the visual slice unless separately approved.

Focused tests must be followed by adopted GUT coverage where applicable, maintained full Godot regression, protected-diff audit, exact-head CI, and actual Windows 1280×720 / 1920×1080 / keyboard / gamepad / accessibility Human QA.

## 11. Acceptance criteria

The design is implemented only when all of the following are true:

- menu visibly shows `Ver 4.3` from one canonical product-version owner;
- no current menu path still displays `Ver 4.2`;
- visual hierarchy matches the approved control-room composition closely enough that the screen reads as left identity / center actions / right intelligence;
- the meaningful current playable action is visually dominant and immediately reachable;
- Legacy and Validation remain clearly separate and semantically unchanged;
- illustrative mockup fiction is not promoted into product data;
- 1280×720 and 1920×1080 are both usable;
- keyboard/gamepad order and non-color cues receive actual Human QA before PASS is claimed;
- generated reference image remains `REFERENCE_ONLY` and `PROJECT_ASSET_APPROVED = 0` unless a later independent asset approval changes that state.

## 12. Rollback

Because this Decision does not alter save/domain meaning, rollback is a coordinated revert of the version-owner/menu presentation implementation and its tests. Do not revert tests while keeping the redesigned behavior, or keep the new version display while restoring duplicate hard-coded version ownership.

## 13. Spec self-review

- Placeholder scan: no `TBD`/`TODO` or unresolved implementation placeholder remains.
- Consistency: visual emphasis and keyboard focus now use the same meaningful-action rule; the approved mockup does not silently override existing Legacy/Validation semantics.
- Scope: version ownership + main-menu presentation form one bounded UI slice; PR #180, save/domain changes, tool-stack reconciliation, Android, and product assets remain separate.
- Ambiguity: mockup-only fictional data is explicitly non-canonical; right-rail data must fail closed to read-only available state rather than inventing content.