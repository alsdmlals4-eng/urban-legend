# Gameplay → Main Menu Safe Return — Adversarial Review

Date: 2026-08-11 KST  
Decision: `D-2026-08-11-GAMEPLAY-MAIN-MENU-SAFE-RETURN-CONTINUE`  
Feature: `UL-FEATURE-GAMEPLAY-MAIN-MENU-SAFE-RETURN-001`  
Project baseline inspected: `cba130ee156c89710d3ddef33ed677bf99aa0716`  
Base remote inspected: `315c66eea9614c284b9c11c4d522141065dfa4b0`

## Scope of attack

This review attacks the approved direction and written Spec against actual current project code, save/load semantics, active Draft PRs, Google Sheet state, external evidence, and implementation authority.

It is not a runtime verification result.

## Evidence compared

- `scripts/core/game_state.gd`
- `scripts/ui/main_menu.gd`
- PR #183 Main Menu Ver 4.3 `main_menu.gd`
- `scripts/scenes/preparation_scene.gd`
- `scripts/scenes/dialogue_scene.gd`
- `scripts/scenes/investigation_scene.gd`
- `scripts/scenes/minigame_scene.gd`
- `scripts/scenes/battle_scene.gd`
- `scripts/scenes/result_scene.gd`
- `scripts/scenes/market_scene.gd`
- `scripts/scenes/daily_episode_scene.gd`
- current route blocker PR #186/#189 evidence
- live Google Sheet current-decision / project-hub / Base-proposal surfaces
- `docs/research/2026-08-11-gameplay-main-menu-safe-return-source-context.md`

## Findings

### F-01 — P0 — Generic `메뉴` navigation currently destroys the intended Continue target

**Attack:** Preparation and Battle utility navigation use a generic scene-button pattern that sets the **destination** scene path before saving. If the destination is Main Menu, the save's `current_scene_path` becomes Main Menu.

**Consequence:** `Continue` cannot reliably mean “return to the gameplay surface I just left.”

**Resolution in Spec:** Main Menu exit is no longer treated as generic destination navigation. The persistent path stays the gameplay scene; Main Menu is only the live destination.

**Status:** `RESOLVED_IN_DESIGN / RED_TEST_REQUIRED`.

---

### F-02 — P0 — Investigation HQ return is a semantic trap, not a reusable persistence implementation

**Attack:** Investigation already has a confirmation and a “return” action, making it tempting to reuse. Its callback calls `suspend_campaign_operation()`, writes Preparation as the current save scene, saves, then leaves Investigation.

**Consequence:** Reuse would silently alter campaign semantics and violate the approved same-gameplay Continue meaning.

**Resolution in Spec:** reuse the confirmation interaction pattern only; create a separate gameplay→Main Menu save path that does not suspend the operation.

**Status:** `RESOLVED_IN_DESIGN / RED_TEST_REQUIRED`.

---

### F-03 — P0 — “Same checkpoint” can be distorted into frame-perfect save

**Attack:** Dialogue, Investigation, Minigame and Recovery contain scene-local UI/runtime state that is not universally represented in GameState.

**Consequence:** a naive implementation either loses progress, serializes unstable engine objects, or makes a player-facing promise the product cannot fulfill.

**Resolution in Spec:** four explicit policy classes:

- `DETERMINISTIC_REBUILD`
- `SEMANTIC_CHECKPOINT`
- `RESTART_INCOMPLETE_ATTEMPT`
- `TURN_BOUNDARY_CHECKPOINT`

Player copy discloses the actual policy before exit.

**Status:** `RESOLVED_IN_DESIGN / PER_SCENE_FIELD_SET_UNVERIFIED`.

---

### F-04 — P0 — Recovery resume can become an RNG exploit or difficulty reroll

**Attack:** Recovery has local stability/fear/threshold/actor state and current pattern selection. Re-entering through the ordinary initialization path can select a different pattern or lose local state.

**Consequence:** menu exit becomes a reroll exploit or produces a different situation from the one the player saved.

**Resolution in Spec:** save a stable turn-boundary semantic payload and restore the pattern by ID. Block/defer exit while a resolution commit is locked.

**Status:** `RESOLVED_IN_DESIGN / TDD_REQUIRED`.

---

### F-05 — P0 — Minigame resume can duplicate or erase one-shot support

**Attack:** current minigame text explicitly defines incomplete attempts as non-saveable/restarted. Entry can also consume/grant one-shot support context.

**Consequence:** inventing mid-attempt persistence conflicts with authored rules; naive restart can duplicate or lose a legitimate one-shot hint/equipment effect.

**Resolution in Spec:** preserve the existing restart rule, add truthful confirmation copy, and persist only the bounded support context proven necessary by RED tests.

**Fallback:** if one-shot preservation cannot be made safe without broad persistence redesign, disable Main Menu during incomplete attempts rather than ship a false resume promise.

**Status:** `RESOLVED_IN_DESIGN / TDD_REQUIRED`.

---

### F-06 — P0 — Result/Daily Episode/Market re-entry can duplicate committed side effects

**Attack:** Result may call report-recording logic on `_ready`; Daily Episode resolves a choice into persistent records; Market performs purchases.

**Consequence:** Continue-driven re-entry could append/grant/purchase twice if idempotency is assumed instead of proven.

**Resolution in Spec:** characterization tests before production changes; no menu interruption during transaction commit; secondary surfaces remain cuttable.

**Status:** `RESOLVED_IN_DESIGN / CHARACTERIZATION_REQUIRED`.

---

### F-07 — P0 — Validation save isolation can be contaminated by a generic resume API

**Attack:** a global “save and menu” helper that knows nothing about persistence domain can accidentally write Legacy save state from Validation/POC surfaces.

**Consequence:** violates existing Validation-session isolation authority.

**Resolution in Spec:** feature scope is Legacy principal gameplay only; new GameState resume API must not become a Validation persistence bridge; tests explicitly check that no Validation path is touched.

**Status:** `RESOLVED_IN_DESIGN / CONTRACT_TEST_REQUIRED`.

---

### F-08 — P1 — Save-success wording can overclaim filesystem durability

**Attack:** current `GameState.save_game()` detects open failure, then writes JSON with `store_string()` and returns true without an explicit post-write `get_error()`/flush check. Current evidence is not a crash-atomic save guarantee.

**Consequence:** UI copy such as “안전하게 저장됨” can promise more than the implementation proves.

**Resolution in Spec:** navigation blocks on the failures the current API can report; a bounded post-write error/flush hardening may be tested; temp-file/rename atomic redesign is kept out of scope unless separately approved/proven necessary.

**Status:** `OPEN_P2_PERSISTENCE_DEBT / P1_OVERCLAIM_RESOLVED_IN_COPY_AND_SCOPE`.

---

### F-09 — P1 — Main Menu PR #183 collision risk

**Attack:** the safe-return feature could modify `scripts/ui/main_menu.gd` while PR #183 already owns its Ver 4.3 presentation.

**Consequence:** avoidable rebase conflicts and mixed review responsibility.

**Resolution in Spec:** current and PR #183 Continue paths share the same load→saved-scene contract, so safe-return implementation should remain gameplay/GameState-side unless a genuine RED proves otherwise.

**Status:** `RESOLVED_IN_DESIGN`.

---

### F-10 — P1 — Confirmation layers themselves can reproduce the current pointer blocker class

**Attack:** the project already has Human-QA evidence that non-interactive overlay panels can intercept real pointer input. Adding another full-screen modal/overlay without real-input tests can reproduce that class of bug.

**Consequence:** visible Main Menu button or cancel/confirm controls may not receive pointer input, or the modal may leak clicks through.

**Resolution in Spec:** active modal must block underlying input, inactive/read-only layers must not; tests require real mouse press/release plus focus restoration, not property-only assertions.

**Status:** `RESOLVED_IN_DESIGN / INPUT_TDD_REQUIRED`.

---

### F-11 — P1 — Scope creep into a universal pause/save framework

**Attack:** supporting many scenes can encourage a new autoload, back stack, raw scene serialization, multiple slots, or pause manager.

**Consequence:** much larger blast radius than the approved player problem requires.

**Resolution in Spec:** one optional checkpoint envelope inside existing GameState JSON; scene-owned reconstruction; no second persistence owner.

**Status:** `RESOLVED_IN_DESIGN`.

---

### F-12 — Governance — product authoring cannot be performed in this ChatGPT session

**Attack:** GitHub Contents API can technically edit `.gd`, creating pressure to bypass the approved HiGodot sole-authoring path.

**Consequence:** authority violation even if the code is correct.

**Resolution:** design/docs/test planning may continue; product Godot mutation is held. Current ChatGPT plugin discovery exposes no HiGodot/Godot-MCP authoring plugin.

**Status:** `BLOCKED_HIGODOT_UNAVAILABLE_IN_CURRENT_CHAT / NO_PRODUCT_MUTATION`.

---

## Existing-solution-first result

The codebase already has the two core owners needed:

```text
GameState save/load
+ Main Menu Continue
```

The missing capability is bounded semantic checkpoint data and correct gameplay-side transition semantics.

Therefore:

- new save service: `AVOID`
- new Main Menu resume engine: `AVOID`
- optional checkpoint envelope in existing save: `ADAPT`
- scene-specific reconstruction: `ADAPT`
- external navigation/accessibility guidance: `ADAPT / evidence only`

## Cut-down decision

If implementation risk is higher than estimated:

1. defer Market/Daily Episode;
2. keep principal six scenes;
3. disable menu exit in unsafe Recovery/minigame transient states instead of faking persistence;
4. never weaken the P0 saved-scene, duplicate-effect, Validation-isolation, or truthful-copy rules.

## Review disposition

```yaml
P0_design_findings_total: 7
P0_unresolved_after_design_mitigation: 0
P1_design_findings_total: 4
P1_unresolved_after_design_mitigation: 0
open_nonblocking_debt:
  - save durability beyond current application-level contract
blocked_execution:
  - written Spec approval / planning gate
  - HiGodot product-authoring surface unavailable in current ChatGPT session
executed_runtime_verification: NOT_RUN
human_qa: NOT_RUN
android_qa: NOT_RUN
```

## Next gate

1. exact-head docs-only PR review/CI;
2. user written-Spec approval / project planning completion gate;
3. HiGodot-authorized test-first implementation on current `main`;
4. exact-head automated validation;
5. Windows Human QA;
6. same Decision ID state propagation to GitHub and Google Sheet.
