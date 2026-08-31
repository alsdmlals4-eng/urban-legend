# Recovery Operation Surface and Bureau Main Menu Design

**Status:** `USER_APPROVED / IMPLEMENTED / FOCUSED_MACHINE_VERIFIED / GPU_RUNTIME_CAPTURED / HUMAN_QA_NOT_RUN`
**Decision source:** 2026-08-31 user approval after live recovery-screen review.
**Scope:** the active Recovery operation surface, shared procedure dialogue panel, and the user-approved scenario-neutral Bureau main-menu background.

## Player outcome

During Recovery, the player sees the stable-versus-danger clock pair in the actual visible operation overlay, reads the next telegraph in the larger action dock, and can open the anomaly manual from the lower-right action area without covering the current decision. The player never has to choose a hidden representative or press a redundant “recover execution” button: Kwon Narae remains the direct field lead and a reached stability threshold advances to the composite result once.

The main menu remains an institution control surface instead of inheriting a specific case’s entrance art. Its user-approved background is a separate Bureau research/archive space, while all Korean menu labels, navigation, and the product title remain native Godot UI.

## Locked constraints

- Preserve the current core loop: `investigation → player-authored manual → rescue → recovery → composite result`.
- Preserve the approved Recovery clock state already owned by `GameState.recovery_clock_state`; do not add a second save field or repurpose investigation risk.
- `GameState.investigation_risk` remains investigation-only. The six-segment danger clock remains recovery-only.
- Recovery is stabilization and residue containment, never HP-zero combat.
- Kwon Narae is the sole direct command owner. Selected teammates remain conditional support actors.
- Do not reveal a correct response, recommended response, or hidden answer before a response is committed.
- Keep the existing Canon v2 action-confirmation and protection-obligation semantics.
- PC 16:9, mouse and keyboard, Godot 4.7 / GDScript.
- Existing approved scenario Lume portraits remain confined to their named manual-workbench consumers. They are not general dialogue art.
- The user-approved `ULAB-MAIN-MENU-BACKGROUND-001` remains an environment-only background; no generated candidate, baked typography, or reference-copy UI is imported into the runtime.

## Actual-owner correction

The live runtime mounts `CanonV2OperationOverlay` and hides `RecoveryHud`. Consequently, `RecoveryHud` cannot own player-visible clocks, manual entry, or action-state controls. The visible overlay owns the top operational state, clock cluster, manual drawer, detail stack, and action confirmation; `battle_scene` owns the current Recovery data and responses; `CanonV2RuntimeBridge` maps that data into the visible overlay.

## Recovery surface

### Header

The top strip contains only:

1. the mode title;
2. the short current rule/telegraph summary;
3. the visible **stability clock** (eight segments); and
4. the visible **danger clock** (six segments, urgent at six).

It contains no manual button. Clock values are semantic text as well as radial segments, so color is never the only signal.

### Field/action dock

- `CinematicStage` ends before `ActionDock` begins: the cutout panel and dock cannot overlap.
- `AnomalyVisual` uses aspect-preserving containment, so the approved transparent cutout is never cropped by an aspect-cover layout.
- The lower-right footer contains the one named `ManualQuickButton`. It opens/closes the visible `ManualDetailPanel` and keeps focus reachable by keyboard.
- The shared LogGuide becomes a compact, text-first “루메 · 절차 통신” panel. It retains tutorial copy, advance control, and audio signature behavior, but displays no global device portrait.
- `RepresentativeSwitchButton`, `RecoverButton`, the hidden clock row, and the hidden manual-toggle path are removed from the playable tree.

### Automatic completion

When the existing stability threshold is reached, `battle_scene` writes the same recovery result packet and transitions once to `result_scene`. It must remain idempotent, must not require a second button press, and must not create a new confirmation/action-cost channel. The bridge determines termination readiness from the scene’s public readiness method rather than a removed UI node.

## Main-menu background and native title lockup

**Asset ID:** `ULAB-MAIN-MENU-BACKGROUND-001`
**Intent:** scenario-neutral, textless archive-research-room environment for `MainMenu` only.
**Current state:** `USER_APPROVED / PROJECT_ASSET_APPROVED / IMPLEMENTED / RUNTIME_VERIFIED / HUMAN_QA_NOT_RUN`.

The exact user-provided PNG is registered in `ASSET_MANIFEST.yml`, loaded through `UiAssetCatalog`, and rendered by `MainMenuBackdrop`. The display title is **`괴이기록국: 잔향 보고서`**, assembled by native `WorldTitle` (`괴이기록국`) and `WorldTitleSuffix` (`잔향 보고서`) labels. The canonical world-internal agency remains **괴이 기록국**; no save, episode, case, or asset IDs are renamed.

## Non-goals

- No changes to M01/M04 clue IDs, response IDs, rule truth, save version, economy, campaign timing, or results semantics.
- No new main-menu UI screenshot image, baked typography, or image-based controls.
- No replacement of approved M01/M04 backgrounds, anomaly cutouts, or scenario Lume portrait assets.
- No Human QA, accessibility PASS, release-rights clearance, or release claim from automated verification.

## Acceptance evidence

1. A Recovery scene test proves the visible `CanonV2OperationOverlay` owns both clocks and the hidden legacy HUD no longer contains player controls.
2. A scene/UI test proves the lower-right manual button opens the manual panel, and the old top-strip manual control, representative switch, and recover button are absent.
3. A Recovery route test proves correct responses retain the previously approved clock behavior and reaching threshold changes scene automatically exactly once.
4. A LogGuide test proves tutorial advancement and audio helpers remain, while no `TextureRect` or `log_*.png` catalog consumer remains.
5. A presentation test proves `AnomalyVisual` uses `STRETCH_KEEP_ASPECT_CENTERED` and the stage/dock anchor ranges do not overlap.
6. The approved background has a receipt, SHA-256, runtime catalog/consumer, exact 1280×720 and 1920×1061 GPU captures, and a native product-title contract; it does not inherit fictional reference names or baked UI.
7. Targeted GUT tests, Godot import, `git diff --check`, and live 1280×720 / 1920×1080 captures are recorded separately. Human visual and accessibility review remain `NOT_RUN`.
