# Gameplay → Main Menu Safe Return Implementation Plan

> **For implementation executor:** REQUIRED SUB-SKILLS: `superpowers:executing-plans`, `superpowers:test-driven-development`, `superpowers:systematic-debugging` for unexpected failures, and `superpowers:verification-before-completion` before any completion claim.
>
> **Decision:** `D-2026-08-11-GAMEPLAY-MAIN-MENU-SAFE-RETURN-CONTINUE`
>
> **Design Spec:** `docs/superpowers/specs/2026-08-11-gameplay-main-menu-safe-return-design.md`
>
> **Status:** `DRAFT_PLAN / WRITTEN_SPEC_REVIEW_GATE_OPEN / PRODUCT_IMPLEMENTATION_NOT_AUTHORIZED`
>
> **Planning baseline:** project `main` `cba130ee156c89710d3ddef33ed677bf99aa0716`
>
> **Godot:** 4.7.1 stable

## Goal

Implement one trustworthy gameplay→Main Menu session-exit contract without creating a second save system: save the current gameplay resume scene and a bounded JSON-safe checkpoint, navigate only after save success, then let existing Main Menu `Continue` load that gameplay scene and let the scene rebuild its semantic state.

## Architecture

- `GameState` remains the only Legacy persistence owner.
- Add one optional `gameplay_resume_checkpoint` envelope to the existing JSON payload.
- Add small checkpoint save/peek/consume/clear APIs to `GameState`.
- Main Menu Continue remains unchanged unless a RED test proves a real defect.
- Each gameplay scene owns its own semantic checkpoint payload and UI copy.
- No raw engine object serialization.
- No new autoload, back stack, save slot, cloud save, or parallel persistence service.
- Validation persistence remains isolated.

## Authority / execution gate

Persistent product `.gd`, `.tscn`, Resource, project setting, or other Godot mutation must use the project-approved HiGodot authoring path. The current ChatGPT connector does not expose that authoring surface. Tests/docs can be prepared here, but product implementation must not be performed by bypassing the authority contract.

In addition, the planning/build workflow remains gated: this plan does not itself equal `기획 완료` or written-Spec approval.

## Scope order

```text
Task 1  persistence contract
Task 2  shared gameplay exit behavior + Preparation
Task 3  Dialogue
Task 4  Investigation
Task 5  Minigame
Task 6  Recovery/Battle
Task 7  Result idempotency
Task 8  secondary Market/Daily Episode
Task 9  full integration + Human QA
```

Tasks 1–7 define the principal six-scene minimum. Task 8 is cuttable without violating the core Decision.

---

## Task 1 — RED/GREEN: bounded resume checkpoint in existing GameState

**Product files**
- Modify: `scripts/core/game_state.gd`

**Test files**
- Create: `tests/gameplay_main_menu_resume_state_test.gd`
- If repository test registry requires explicit listing, update the smallest existing maintained runner/workflow only after proving the focused test.

### 1.1 RED — optional checkpoint round-trip

Write tests first for these requirements:

1. old save without checkpoint loads with `{}` / no active checkpoint;
2. saving a checkpoint writes `scene_path`, `policy`, `schema_version`, and payload into the existing save;
3. saved `current_scene_path` remains the gameplay path supplied to the resume API;
4. `SCENE_MAIN_MENU`, empty path, unknown policy, or non-JSON-safe payload is rejected;
5. loading the save reconstructs the checkpoint;
6. checkpoint requested by the wrong scene returns empty and is not applied;
7. in-memory state rolls back when `save_game()` reports failure;
8. no Validation-session file/path is touched.

Suggested focused command:

```bash
godot --headless --path . --script res://tests/gameplay_main_menu_resume_state_test.gd
```

Expected RED: missing checkpoint API/save field, not a syntax/import failure.

### 1.2 GREEN — minimal GameState API

Recommended shape; exact names may adapt to established project naming:

```gdscript
var gameplay_resume_checkpoint: Dictionary = {}

func save_gameplay_resume_checkpoint(
	resume_scene_path: String,
	policy: String,
	payload: Dictionary = {}
) -> bool:
	# validate scene/policy/json safety
	# snapshot old current_scene_path + checkpoint
	# set gameplay scene + envelope
	# call existing save_game()
	# rollback in-memory values on failure
	# do not navigate here

func peek_gameplay_resume_checkpoint(scene_path: String) -> Dictionary:
	# return duplicate only if scene/schema/policy match

func consume_gameplay_resume_checkpoint(scene_path: String) -> Dictionary:
	# clear in-memory after matching read; durable clear occurs when resumed scene reaches stable state

func clear_gameplay_resume_checkpoint() -> void:
	gameplay_resume_checkpoint = {}
```

Add `gameplay_resume_checkpoint` to `_make_save_data()` and `load_game()` as an optional field.

Do **not** bump save version reflexively. First run old-save and existing migration tests. Only bump if a current contract requires it.

### 1.3 Save write-strength check

Current `save_game()` returns true after `store_string()` without checking a post-write error. Run a bounded experiment/test in isolated `user://`:

- open failure remains false;
- after store, `flush()` + `get_error()` can be checked without changing location/format semantics.

If the added check is clean and all persistence regressions pass, include the narrow hardening in this task. If it expands into temp-file/rename migration or changes crash recovery semantics, **defer it to a separate persistence Decision** and keep this feature's copy scoped to application-level save success.

### 1.4 Verify

- focused new test GREEN;
- existing save/load/migration tests GREEN;
- no change to Validation save paths;
- `git diff --check`.

Commit only after RED then GREEN evidence.

---

## Task 2 — RED/GREEN: common exit contract + Preparation

**Product files**
- Modify: `scripts/scenes/preparation_scene.gd`
- Main Menu product file expected unchanged: `scripts/ui/main_menu.gd`

**Test files**
- Create: `tests/gameplay_main_menu_preparation_test.gd`
- Optionally extend an existing Main Menu Continue contract test if one already owns that path.

### 2.1 RED

Prove current failure first:

- Preparation `메뉴` path currently uses generic destination-saving navigation;
- invoking it causes saved resume scene to become Main Menu;
- after new behavior, saved resume scene must remain Preparation.

Also assert:

- confirmation exists and is focusable;
- cancel does not write save or change scene;
- save failure does not navigate;
- accepted confirm locks against double activation.

### 2.2 GREEN

Replace only the `메뉴` action's semantics. Do not rewrite generic navigation used by other destinations.

Flow:

```text
메인 메뉴
→ policy = DETERMINISTIC_REBUILD
→ confirmation
→ GameState.save_gameplay_resume_checkpoint(GameState.SCENE_PREPARATION, policy, {})
→ success: change_scene_to_file(GameState.SCENE_MAIN_MENU)
→ failure: stay + status/error
```

Do not save Main Menu as the resume destination.

### 2.3 Continue compatibility

Integration test existing Main Menu `Continue` against a prepared save. It should load the file and route to Preparation without changing Main Menu code.

If this test is GREEN without a Main Menu modification, keep that file untouched to minimize PR #183 conflict.

---

## Task 3 — RED/GREEN: Dialogue semantic checkpoint

**Product files**
- Modify: `scripts/scenes/dialogue_scene.gd`

**Test files**
- Create: `tests/gameplay_main_menu_dialogue_resume_test.gd`

### 3.1 Discover exact semantic locals

Before writing production code, identify the minimum state not already in GameState. Current candidates:

- `_line_index`
- `_waiting_for_result_continue`
- `_pending_next_node_id`
- `_pending_next_scene_path`

Do not serialize UI labels, node references, controls, or full dialogue resources.

### 3.2 RED

Create a dialogue state where a committed flag/choice already exists and a local line/pending transition is active.

Expected after Main Menu→Continue:

- same dialogue node/semantic line checkpoint;
- committed effect count unchanged;
- no duplicate flag/reward/event;
- unsupported checkpoint fields are ignored/fail closed.

### 3.3 GREEN

On scene entry:

1. consume matching checkpoint before the ordinary entry save can overwrite it;
2. build normal dialogue state;
3. apply semantic local checkpoint;
4. after stable reconstruction, clear checkpoint and save normalized state if required.

Add `메인 메뉴` affordance using the same interaction semantics as Task 2.

---

## Task 4 — RED/GREEN: Investigation is not HQ suspension

**Product files**
- Modify: `scripts/scenes/investigation_scene.gd`

**Test files**
- Create: `tests/gameplay_main_menu_investigation_resume_test.gd`

### 4.1 RED — semantic conflict

Prove these separately:

- current `_return_to_hq()` calls `suspend_campaign_operation()` and saves Preparation;
- `메인 메뉴` must not invoke that function or mutate operation suspension state;
- an investigation checkpoint restores the current field/semantic UI step;
- already committed field-choice consequences are not repeated.

### 4.2 GREEN

Reuse the existing confirmation interaction **pattern**, not the HQ-return persistence callback.

Candidate payload is limited to semantic identifiers/mode required by current code after RED discovery, e.g. field node, pending next field node, and UI mode. Prefer existing GameState field node authority where sufficient.

Cancel/save failure restores prior focus and leaves investigation unchanged.

---

## Task 5 — RED/GREEN: Minigame bounded restart with one-shot protection

**Product files**
- Modify: `scripts/scenes/minigame_scene.gd`

**Test files**
- Create: `tests/gameplay_main_menu_minigame_resume_test.gd`
- Extend route/minigame pipeline tests only where they already own the behavior.

### 5.1 Preserve existing product rule

Current authored text says an in-progress field verification is not saved and restarting/loading begins the minigame again. Do not turn this task into arbitrary mid-attempt serialization.

### 5.2 RED

For an incomplete minigame:

- Main Menu confirmation clearly says the attempt restarts at its safe start;
- checkpoint stores minigame ID and `RESTART_INCOMPLETE_ATTEMPT` policy;
- resume opens the same minigame ID at start;
- a legitimately granted one-shot equipment/support hint is neither consumed twice nor lost;
- no minigame result is written merely by exiting/resuming.

For a completed minigame:

- existing saved result remains authoritative;
- result/recovery transition is not duplicated.

### 5.3 GREEN

Add only the minimum support-context field proven necessary by RED. Do not persist puzzle board Nodes/timers/tweens/current pointer state.

If one-shot preservation cannot be made safe without broad save redesign, disable Main Menu during an incomplete attempt and keep the feature truthful rather than ship a duplication/loss bug.

---

## Task 6 — RED/GREEN: Recovery/Battle stable turn boundary

**Product files**
- Modify: `scripts/scenes/battle_scene.gd`

**Test files**
- Create: `tests/gameplay_main_menu_recovery_resume_test.gd`
- Extend current recovery-pattern/state tests only for owner-specific assertions.

### 6.1 RED — reroll and local-state loss

Set a deterministic recovery situation with a known current pattern and local recovery values. Exit at a stable decision boundary, Continue, and prove current code would otherwise reconstruct incorrectly or reroll.

Acceptance requires:

- same current pattern ID after resume;
- no call path that selects a new random pattern merely because of resume;
- stability/fear/threshold and actor indexes equal checkpoint values;
- uncommitted hypothesis/evidence/response choices can reset to the current turn selection step;
- no cost/damage/reward is applied twice;
- while `_turn_locked`/resolution commit is active, menu exit is blocked/deferred.

### 6.2 GREEN

Start with the candidate payload from the Spec, then remove any field that RED proves unnecessary:

```yaml
anomaly_stability:
fear_level:
recovery_threshold:
representative_agent_index:
target_agent_index:
current_pattern_id:
```

Restore the pattern by existing stable ID lookup. Never serialize the pattern Resource itself.

Replace the current utility `메뉴` path's generic destination-saving behavior with the safe-return path only; do not disturb other debug/utility scene transitions unless their own owner requires it.

---

## Task 7 — RED/GREEN: Result re-entry idempotency

**Product files**
- Modify only if RED proves needed: `scripts/scenes/result_scene.gd`
- Modify only if owner defect proven: `scripts/core/game_state.gd`

**Test files**
- Create: `tests/gameplay_main_menu_result_resume_test.gd`

### 7.1 RED/characterization first

Characterize existing `record_current_case_report()` / reward dedupe behavior before changing production code.

Load Result, exit to Main Menu, Continue back to Result, and assert:

- completed report count does not increase a second time;
- echo/research reward does not grant twice;
- follow-up/record append does not duplicate;
- result text remains reconstructible.

If current behavior is already idempotent, keep production Result logic unchanged and add only the menu affordance/checkpoint.

---

## Task 8 — secondary surfaces: Market and Daily Episode

### 8A Market

**Product:** `scripts/scenes/market_scene.gd`
**Test:** `tests/gameplay_main_menu_market_resume_test.gd`

- purchase transaction must be complete before menu exit;
- resume does not repeat purchase;
- selected item ID may be restored or safely reset;
- saved resume scene remains Market.

### 8B Daily Episode

**Product:** `scripts/scenes/daily_episode_scene.gd`
**Test:** `tests/gameplay_main_menu_daily_episode_resume_test.gd`

Characterize GameState first.

- before choice: safe deterministic rebuild;
- after committed choice: never show an executable duplicate choice if that duplicates record/reward;
- if current GameState cannot reconstruct post-choice UI safely, normalize to a clearly disclosed safe scene/checkpoint rather than silently replay.

Task 8 may be deferred as a cut-down without blocking the principal six-scene feature.

---

## Task 9 — integration, adversarial verification, Human QA

### 9.1 Exact changed-scope audit

Expected product scope is bounded to:

```text
scripts/core/game_state.gd
scripts/scenes/preparation_scene.gd
scripts/scenes/dialogue_scene.gd
scripts/scenes/investigation_scene.gd
scripts/scenes/minigame_scene.gd
scripts/scenes/battle_scene.gd
scripts/scenes/result_scene.gd
[optional] scripts/scenes/market_scene.gd
[optional] scripts/scenes/daily_episode_scene.gd
```

Main Menu code should remain unchanged unless justified by a recorded RED test.

No product assets, `project.godot`, data canon, save path, or Validation save owner should change without separate scope evidence.

### 9.2 Automated validation

Run in this order:

1. every new focused RED→GREEN test;
2. existing save/migration tests;
3. minigame/recovery/result focused suites;
4. Canon v2 runtime/UX suite;
5. maintained full Godot regression matrix;
6. Core+Docs / Base adapter / authority gates triggered by changed paths;
7. `git diff --check` and changed-file audit.

Do not use a helper PR descendant as exact-head evidence for the implementation PR.

### 9.3 Adversarial replay matrix

Attack at minimum:

| Attack | Expected |
|---|---|
| double confirm | one save + one transition |
| save-open failure | stay in gameplay |
| Main Menu live scene mutates in-memory current path | Continue still loads persisted gameplay path |
| old save no checkpoint | loads normally |
| checkpoint wrong scene/version | fail closed |
| minigame resume | no duplicate/lost one-shot support |
| battle resume | no pattern reroll / duplicated damage |
| result resume | no duplicate report/reward |
| market/daily transaction | no duplicate purchase/choice |
| confirmation overlay | blocks click-through; cancel restores focus |
| Validation mode | Legacy save not polluted |

### 9.4 Windows Human QA

Automated evidence does not replace Human QA.

Minimum actual checks:

1. Preparation → Main Menu → Continue.
2. Dialogue mid-node → Main Menu → Continue.
3. Investigation after one committed action → Main Menu → Continue.
4. Incomplete minigame → confirmation clearly warns restart → Continue restarts safely.
5. Recovery stable decision boundary → Main Menu → Continue → same pattern/situation.
6. Result → Main Menu → Continue with no visible duplicate reward/report.
7. Mouse and keyboard activation/cancel/focus.
8. Controller where currently supported by surrounding gameplay UI.
9. Save failure simulation if a safe Human-QA harness exists.

Android remains separately `NOT_RUN` unless explicitly executed.

### 9.5 Integration order with active PRs

- Route blocker PR #189 remains a separate exact-head RED/GREEN/Human gate.
- PR #186 must be revalidated on current main after its blocker is integrated.
- PR #183 owns Main Menu Ver 4.3 presentation; safe-return should avoid modifying its Main Menu files, reducing conflict.
- Rebase/update this feature from the then-current `main` before implementation PR exact-head validation.

---

## Final completion boundary

The feature is **not complete** until all are true:

```text
written Spec approved
+ implementation authority path available
+ principal six scenes implemented
+ focused RED→GREEN evidence
+ maintained regressions GREEN on exact head
+ active PR interaction reviewed
+ Windows Human QA performed
+ GitHub Decision/PR evidence and Google Sheet status synchronized
```

Planning artifacts alone never satisfy that boundary.