# Gameplay → Main Menu Safe Return — Game Feature Design Spec

> **Feature ID:** `UL-FEATURE-GAMEPLAY-MAIN-MENU-SAFE-RETURN-001`
>
> **Decision:** `D-2026-08-11-GAMEPLAY-MAIN-MENU-SAFE-RETURN-CONTINUE`
>
> **Work level:** L2 `GAME_FEATURE_DESIGN_SPEC`
>
> **Status:** `PROPOSED_FOR_WRITTEN_SPEC_REVIEW`
>
> **Planning baseline:** project `main` `cba130ee156c89710d3ddef33ed677bf99aa0716`
>
> **Base remote observed:** `315c66eea9614c284b9c11c4d522141065dfa4b0`; project-adopted Base remains `fa69a77a14f923a756064f6ae151d34cadb374f7`

## 0. Identity & authority

```yaml
feature_id: UL-FEATURE-GAMEPLAY-MAIN-MENU-SAFE-RETURN-001
feature_name: Gameplay → Main Menu Safe Return + Continue Resume
work_level: L2
status: PROPOSED_FOR_WRITTEN_SPEC_REVIEW
owner: gameplay navigation + persistence interaction contract
canonical_path: docs/superpowers/specs/2026-08-11-gameplay-main-menu-safe-return-design.md
related_decision_ids:
  - D-2026-08-11-GAMEPLAY-MAIN-MENU-SAFE-RETURN-CONTINUE
  - D-2026-08-09-MAIN-MENU-CONTROL-ROOM-VERSIONING
related_specialized_sources:
  - source_id: current-save-authority
    path: scripts/core/game_state.gd
    authority: existing runtime persistence
  - source_id: current-main-menu-continue
    path: scripts/ui/main_menu.gd
    authority: existing resume consumer
  - source_id: external-context
    path: docs/research/2026-08-11-gameplay-main-menu-safe-return-source-context.md
    authority: evidence only; does not override project canon
created_at: 2026-08-11
updated_at: 2026-08-11
```

### Authority boundary

This Spec owns:

- what `메인 메뉴` means when invoked from gameplay;
- what must be saved before navigation;
- scene-specific resume semantics;
- player-facing disclosure when exact resume is impossible;
- navigation failure behavior;
- duplicate-effect and save/load acceptance rules.

Other authorities retain:

- Main Menu visual hierarchy/version: `D-2026-08-09-MAIN-MENU-CONTROL-ROOM-VERSIONING` / PR #183 scope;
- game-state persistence implementation: `scripts/core/game_state.gd`;
- investigation/recovery semantic rules: existing Canon v2 Decisions;
- minigame rules/results: existing minigame authority;
- Validation-session persistence isolation: existing Validation save contract;
- actual Task/PR/executed verification: implementation plan, PR, CI, Human QA evidence.

This Spec does **not** claim product implementation, CI PASS, or Human QA PASS.

---

## 1. Player Problem

```yaml
player_problem: Gameplay currently lacks one trustworthy meaning for leaving to Main Menu and later pressing Continue.
current_behavior:
  - some gameplay surfaces have no Main Menu entry
  - some utility navigation writes the destination Main Menu path into the save
  - investigation HQ return changes campaign semantics and saves Preparation instead of preserving same-gameplay resume
  - incomplete minigames explicitly restart and do not support arbitrary mid-attempt save
undesired_outcome:
  - Continue may not return to the gameplay surface the player expected
  - a hidden/debug-like Menu action can overwrite the intended resume destination
  - players can infer stronger persistence than the product actually supports
  - adding naive save-on-exit can duplicate rewards/RNG/transactions or lose scene-local state
desired_change: One consistent Main Menu action that saves an explicit safe resume checkpoint and tells the truth about how that scene will resume.
evidence_ids:
  - current source inspection 2026-08-11
  - D-2026-08-11-GAMEPLAY-MAIN-MENU-SAFE-RETURN-CONTINUE
  - SOURCE_CONTEXT_PACKET 2026-08-11
```

---

## 2. Experience Intent & Core Alignment

### Experience intent

The player should be able to stop a play session without wondering whether `Continue` will strand them, silently advance/rewind the campaign, or replay a one-time effect.

- **Player action:** choose `메인 메뉴` from a principal gameplay surface.
- **Player judgment:** read the scene-specific resume consequence, then confirm or cancel.
- **Immediate feedback:** save/resume policy is stated before navigation; failure is surfaced without leaving the scene.
- **Expected feeling:** session exit is predictable, reversible through Continue, and does not require technical knowledge of save files.
- **Repeated mastery:** the meaning of `메인 메뉴` remains consistent even though exact resume granularity varies by scene.

### Core alignment

| Target | Contribution | Violation risk |
|---|---|---|
| Investigation/operation continuity | lets players suspend real sessions without changing operation meaning | reusing HQ-return semantics would silently suspend the operation instead |
| Evidence-first decision play | preserves committed choices/results while avoiding invented frame persistence | saving transient UI as if it were canon can create duplicate/contradictory state |
| Control-room Main Menu | makes the approved Main Menu a reliable session hub rather than a dead-end destination | saving `main_menu.tscn` as Continue target defeats the hub contract |

### Planned evidence layers

```yaml
TECH_EVIDENCE: save payload round-trip; scene checkpoint reconstruction; duplicate-effect regressions
UI_EVIDENCE: visible/focusable menu affordance; scene-specific confirmation copy; save-failure feedback
HUMAN_USABILITY_EVIDENCE: Windows mouse/keyboard at minimum; controller where supported
PLAYER_EXPERIENCE_EVIDENCE: player correctly predicts whether resume is exact semantic checkpoint or minigame restart
```

Human evidence remains `NOT_RUN` until executed.

---

## 3. Scope / Non-goals

### In scope — principal gameplay

1. Preparation
2. Dialogue
3. Investigation
4. Minigame
5. Recovery/Battle
6. Result

### Secondary same-decision extension

7. Market
8. Daily Episode

Secondary surfaces use the same contract but may be implemented after the principal six if that reduces risk. This does not authorize new gameplay semantics.

### Out of scope

- Validation-session persistence or Validation-to-Legacy save promotion;
- Android-specific layout redesign;
- Main Menu visual redesign already owned by PR #183;
- arbitrary pause anywhere during an animation/tween/transaction;
- saving raw Nodes, Controls, Callables, Resources, Tweens, Timers, or engine object references;
- a second save file, back-stack service, cloud save, checkpoint slot UI, save-slot selection;
- changing route/recovery/minigame reward rules to make resume easier.

### Non-goals

- frame-perfect restoration of every pointer position, animation frame, timer, or uncommitted UI selection;
- crash-atomic save-system redesign. Current `GameState.save_game()` writes the existing JSON directly. This feature must detect the failures the existing API can report and must not market that as full filesystem transaction safety;
- replacing existing HQ return or operation suspension semantics.

### Minimum viable behavior

For the six principal gameplay scenes, `메인 메뉴` must preserve a truthful semantic resume point in the existing save file, navigate only after the save API reports success, and let the existing Continue path reload the saved gameplay scene. Where exact local state is not currently persistent, the player must be told which bounded checkpoint will be used.

---

## 4. Player Verbs & Decisions

| verb_id | Verb | Input/action | Decision | Risk | Feedback |
|---|---|---|---|---|---|
| MM-01 | Open menu-exit confirmation | activate `메인 메뉴` | stop now or keep playing | leaving during transient state | scene-specific resume description |
| MM-02 | Confirm | choose confirm | accept stated resume point | last uncommitted local selection may be discarded | saving state → transition |
| MM-03 | Cancel | choose cancel/back | remain in gameplay | none | prior focus restored |
| MM-04 | Continue | Main Menu `Continue` | resume saved run | stale/corrupt save | existing Continue loading/error feedback |

The destructive/irreversible part is not entering Main Menu itself; it is accepting any loss of **uncommitted transient progress**. Confirmation copy therefore changes by resume policy.

---

## 5. Entry / Exit / Cancel / Re-entry

| Type | Condition | System behavior | Feedback | Next state |
|---|---|---|---|---|
| Entry | principal gameplay is in a stable resumable boundary | open confirmation; do not mutate save yet | explain checkpoint policy | confirmation open |
| Entry blocked | active commit/resolution/transaction cannot be safely interrupted | disable or defer menu action | short reason | current gameplay |
| Exit confirm | checkpoint serialization valid and save succeeds | persist gameplay scene + checkpoint; change only live scene to Main Menu | saving/transition feedback | Main Menu |
| Exit save failure | save API reports failure | rollback in-memory pending checkpoint if needed; do not navigate | explicit save failure | current gameplay |
| Cancel | confirmation open | close modal | restore prior focus | current gameplay |
| Re-entry | Continue loads file | route to saved gameplay scene; scene consumes matching checkpoint | resume/restart disclosure as appropriate | gameplay restored |

### Critical distinction

`gameplay resume scene` is persistent. `Main Menu currently displayed` is not the resume target. Main Menu must not overwrite the save merely because it is the live scene.

---

## 6. Player Flow

```text
Gameplay stable boundary
→ player activates 메인 메뉴
→ scene identifies resume policy + checkpoint payload
→ confirmation explains consequence
→ player confirms
→ GameState validates JSON-safe checkpoint
→ GameState saves current gameplay scene + checkpoint
→ only after success, scene changes to canonical Main Menu
→ player later selects Continue
→ existing GameState.load_game()
→ existing Continue chooses saved gameplay scene
→ gameplay scene consumes matching checkpoint
→ scene reconstructs semantic state
→ checkpoint is normalized/cleared after successful restore
```

### Invalid flow to eliminate

```text
메인 메뉴 click
→ set_current_scene_path(main_menu)
→ save_game()
→ Main Menu
→ Continue
→ Main Menu or fallback scene
```

### Existing HQ-return flow remains separate

Investigation `HQ 복귀` may continue to suspend the operation and save Preparation. It must not be relabeled as the safe Main Menu feature.

---

## 7. State & Rules

### Resume policy classes

| policy_id | Meaning | Scene examples | Persisted local payload |
|---|---|---|---|
| `DETERMINISTIC_REBUILD` | GameState already contains gameplay semantics; UI can rebuild | Preparation, Result, Market | minimal/empty semantic payload |
| `SEMANTIC_CHECKPOINT` | small scene-local semantic state is required | Dialogue, Investigation | IDs/indexes/mode strings only |
| `RESTART_INCOMPLETE_ATTEMPT` | incomplete attempt intentionally restarts from safe start | Minigame | minigame ID + already-granted one-shot context needed to prevent double consume/loss |
| `TURN_BOUNDARY_CHECKPOINT` | current recovery turn reconstructs from bounded state | Recovery/Battle | numeric state + actor indexes + current pattern ID; no uncommitted choice widgets |

### Core rules

| rule_id | Rule | Priority |
|---|---|---|
| MM-R01 | Main Menu destination must never replace the saved gameplay resume scene during this action. | P0 |
| MM-R02 | Navigation occurs only after `save_game()` returns success under the existing persistence contract. | P0 |
| MM-R03 | Checkpoint data must be JSON-safe semantic data only. | P0 |
| MM-R04 | A checkpoint is only consumed by the matching saved scene and supported policy version. | P0 |
| MM-R05 | Active one-time commit/resolution/transaction state must not be interrupted in a way that can duplicate side effects. | P0 |
| MM-R06 | Resume must not grant a reward, consume an item, roll RNG, advance campaign time, or append a record merely because of load. | P0 |
| MM-R07 | Existing Validation save isolation remains unchanged. | P0 |
| MM-R08 | Confirmation text must disclose bounded restart/discard behavior before the player commits to exit. | P1 |
| MM-R09 | Cancel/save failure restores usable focus and leaves gameplay state unchanged. | P1 |

### Checkpoint envelope

Recommended JSON-safe shape:

```json
{
  "schema_version": 1,
  "scene_path": "res://scenes/...",
  "policy": "SEMANTIC_CHECKPOINT",
  "payload": {}
}
```

The envelope belongs inside the existing save payload as one optional field. It is not a separate save system.

### Consumption rule

A resumed scene should read/consume the checkpoint **before** its ordinary scene-entry autosave can persist a default state over the resume data. Clearing in memory may occur before reconstruction; durable clearing should occur only after reconstruction reaches a stable boundary.

---

## 8. Input → Processing → Output

| io_id | Input | Validation | Processing | Output | Failure behavior |
|---|---|---|---|---|---|
| MM-IO-01 | Menu command | scene stable; no blocking modal/transaction | build policy-specific checkpoint | confirmation | stay in scene |
| MM-IO-02 | Confirm | checkpoint JSON-safe + scene matches current gameplay | save envelope with current gameplay scene | save success | explicit error, no navigation |
| MM-IO-03 | Continue | save parses; saved scene valid | existing load + route | gameplay scene | existing Continue error path |
| MM-IO-04 | Scene restore | envelope scene/policy/schema supported | reconstruct semantics; clear normalized checkpoint | stable resumed gameplay | fail closed to safe scene behavior; never invent state |

- **Input authority:** current gameplay scene UI.
- **Runtime state authority:** scene + `GameState`, depending on existing owner.
- **Persistent authority:** existing `GameState` JSON save.
- **Output consumer:** existing Main Menu Continue and resumed scene.

---

## 9. Feedback — UI / accessibility

### Common labels

- primary affordance: `메인 메뉴`
- confirmation primary: `저장하고 메인 메뉴로`
- cancel: `계속 진행`

Copy may be shorter if layout requires, but the semantic consequence cannot be hidden.

### Policy-specific disclosure

- `DETERMINISTIC_REBUILD`: “현재 진행을 저장하고 메인 메뉴로 이동합니다. 이어하기에서 이 화면의 저장된 진행으로 돌아옵니다.”
- `SEMANTIC_CHECKPOINT`: “확정된 진행을 저장합니다. 열려 있는 선택/세부 UI는 저장된 단계에서 다시 구성됩니다.”
- `RESTART_INCOMPLETE_ATTEMPT`: “완료하지 않은 현장 검증은 이 미니게임의 안전한 시작 지점부터 다시 시작합니다. 이미 확정된 결과는 유지됩니다.”
- `TURN_BOUNDARY_CHECKPOINT`: “현재 확정된 회수 상태를 저장합니다. 아직 확정하지 않은 선택은 현재 턴의 선택 단계에서 다시 고릅니다.”

### Focus/accessibility

- menu action must be keyboard/digital-focusable where surrounding UI supports focus;
- modal initial focus goes to the lower-risk `계속 진행`/cancel action unless project modal convention explicitly says otherwise;
- cancel and save failure restore focus to the control that opened the modal;
- no critical meaning is carried only by color;
- blocking modal must block click-through, while non-interactive overlays must not intercept the underlying action.

---

## 10. Success / Failure / Recovery

| Outcome | Condition | Player-visible result | Recovery |
|---|---|---|---|
| Success | checkpoint saved and Main Menu loaded | Main Menu opens; Continue available | Continue resumes saved scene |
| Save failure | save API returns false | player stays in gameplay; error shown | retry or keep playing |
| Unsupported/stale checkpoint | envelope invalid/mismatched | do not invent local state | rebuild from existing GameState safe defaults; log diagnostic; preserve committed progression |
| Corrupt save | existing load fails | existing Continue failure flow | no fake recovery claim |
| Transient action locked | current operation not interruptible | menu action temporarily unavailable or deferred | becomes available at next stable boundary |

---

## 11. Scene policies

### Preparation — `DETERMINISTIC_REBUILD`

Current scene entry already writes Preparation as the save scene. Menu exit must **not** use the generic destination-saving helper. UI selection/tab state may reset; campaign/loadout semantics stay in GameState.

### Dialogue — `SEMANTIC_CHECKPOINT`

Persist only semantic locals required to avoid replay/confusion, such as current line index and pending next-node/scene identifiers where those are not already GameState-owned. Do not serialize label text or Control visibility.

Load must not reapply a choice/flag/reward that was already committed before the checkpoint.

### Investigation — `SEMANTIC_CHECKPOINT`

Do not reuse `_return_to_hq()` because it calls operation suspension and saves Preparation. Reuse only the **confirmation interaction pattern**.

Persist semantic field position/mode needed to reconstruct the current investigation step. Uncommitted picker/highlight state can normalize to the current decision step. Already resolved field-choice consequences remain GameState authority.

### Minigame — `RESTART_INCOMPLETE_ATTEMPT`

Preserve the existing authored rule that an incomplete minigame is not arbitrarily mid-attempt saved. Main Menu becomes a truthful session-exit route, not a loophole to create frame save.

Checkpoint must preserve enough one-shot context to prevent a resume from consuming the same equipment/support hint twice or losing a hint that was already legitimately granted before exit. Completed minigame results remain existing GameState authority.

### Recovery/Battle — `TURN_BOUNDARY_CHECKPOINT`

Never serialize live buttons/cards/tweens or half-applied resolution.

Checkpoint the last stable recovery decision boundary. Candidate semantic payload:

```yaml
anomaly_stability:
fear_level:
recovery_threshold:
representative_agent_index:
target_agent_index:
current_pattern_id:
```

Exact fields are validated against current code during TDD. Current pattern must be restored by ID; resume must not call random pattern selection and silently reroll the challenge.

If a resolution is locked/in progress, `메인 메뉴` is disabled/deferred until the commit reaches a stable boundary.

### Result — `DETERMINISTIC_REBUILD`

Result reconstruction must be idempotent. Re-entering Result through Continue must not append a second report or grant the same reward twice. Existing one-report-per-episode and reward dedupe behavior must be covered by regression tests rather than assumed.

### Market — secondary `DETERMINISTIC_REBUILD`

Selected catalog item may reset or be stored as a harmless item ID. Completed purchases remain GameState transactions and must not replay on resume.

### Daily Episode — secondary conditional rebuild

Before a choice, rebuild from active episode. After a committed choice, the resumed state must not present the same choice as newly executable if it would duplicate the record/reward. If current GameState cannot reconstruct the post-choice display safely, the allowed checkpoint may normalize to Preparation **only when the player is told before exit**; silent semantic change is forbidden.

---

## 12. Edge cases

| ID | Situation | Required behavior |
|---|---|---|
| E01 | repeated confirm/double click | only one save/scene transition; buttons lock after accepted confirm |
| E02 | save open failure | no navigation; no false success message |
| E03 | save write/flush uncertainty | do not claim crash-atomicity; separately harden persistence if evidence requires it |
| E04 | checkpoint scene mismatch | ignore/fail closed; never apply Battle payload to Investigation etc. |
| E05 | unknown schema version | preserve committed GameState; use safe fallback; diagnostic |
| E06 | Continue after Main Menu display | load file first; do not trust in-memory `current_scene_path` changed by Main Menu `_ready` |
| E07 | minigame one-shot hint | no duplicate consume and no silent loss |
| E08 | recovery RNG | current pattern does not reroll on resume |
| E09 | result load | no duplicate report/reward/follow-up |
| E10 | purchase/daily choice during commit | no menu interruption until transaction stable |
| E11 | confirmation overlay | blocks underlying clicks; closing it restores prior focus/input |
| E12 | Validation session | no writes into Legacy main save through this feature |
| E13 | stale old saves without checkpoint | load unchanged through optional field default |
| E14 | PR #183 not yet merged | feature logic remains compatible with existing Continue contract and does not depend on Ver 4.3 layout internals |

---

## 13. Data & persistence

### Data authority

```yaml
runtime_authority: existing scene scripts + GameState
persistent_authority: scripts/core/game_state.gd / user://urban_legend_save.json
authoring_source: existing GDScript save schema
format: JSON
new_optional_field: gameplay_resume_checkpoint
```

No balance values are introduced.

### Compatibility

The checkpoint field is optional. Old saves without it must behave exactly as before. A save-version bump is **not automatically required** merely for an optional backward-compatible field; TDD must decide based on actual migration contracts and existing test expectations.

### Save-strength adversarial finding

Current `save_game()` detects failure to open the save file but directly `store_string()`s JSON and returns true without an explicit post-write error/flush check. Godot FileAccess exposes `flush()` and `get_error()`, and its documentation notes flush can force buffered data to disk. This feature should not label existing behavior “crash-safe atomic save”.

Preferred bounded scope:

1. require navigation to stop when existing `save_game()` returns false;
2. add a targeted write-error/flush check only if it can be done without changing save-location/format semantics and with regression coverage;
3. treat temp-file + rename atomic-save redesign as separate persistence work unless testing proves it necessary for this feature.

---

## 14. Art / Audio / Narrative dependencies

No new product art, audio, or narrative asset is required for the minimum feature.

| Dependency | Need | Blocking |
|---|---|---|
| UI text | policy-specific confirmation/error copy | yes |
| existing theme/buttons | reuse | no new asset |
| sound | optional existing confirm/cancel feedback only | no |
| image asset | none | no |

`PROJECT_ASSET_APPROVED` remains unaffected.

---

## 15. Technical constraints

- Godot target: 4.7.1 stable project contract.
- Existing product authoring authority: HiGodot for persistent Godot Scene/GDScript changes.
- Current ChatGPT connector has no invokable HiGodot/Godot-MCP authoring surface; product implementation must not bypass that contract.
- `GameState` is already large; add the smallest optional checkpoint state/API rather than a parallel persistence subsystem.
- Main Menu Continue should remain unchanged unless a test proves an unavoidable defect there.
- PR #183 is a separate Main Menu visual/version implementation; minimize overlapping file changes.
- Active route blocker PR #189 is separate and remains RED until its HiGodot-authorized GREEN.

---

## 16. Benchmark decision

See `docs/research/2026-08-11-gameplay-main-menu-safe-return-source-context.md`.

- Microsoft XAG navigation/context: **ADAPT** — consistent, understandable navigation and focus behavior.
- Godot 4.7 save guidance: **ADAPT** — explicitly encode only required semantic state in JSON.
- New save framework/back stack: **AVOID** — existing solution is sufficient if bounded checkpoints are added.

---

## 17. Risks & adversarial review

### A. Distortion: “Continue means exact frame resume”

**Attack:** approved wording could be interpreted as every local timer/input/animation restoring exactly.

**Resolution:** define policy classes; minigame uses bounded restart; recovery uses stable turn boundary; confirmation tells the truth.

### B. Conflict: existing HQ return

**Attack:** reusing Investigation HQ return would silently call `suspend_campaign_operation()` and save Preparation.

**Resolution:** UI pattern may be reused; persistence semantics may not.

### C. Conflict: generic destination-saving navigation

**Attack:** existing Battle/Preparation utility navigation saves the destination scene, so Menu overwrites Continue target.

**Resolution:** Main Menu path is a special session-exit transition, not generic scene navigation.

### D. Omission: local battle/RNG state

**Attack:** saving only current scene would reroll recovery patterns and lose local values.

**Resolution:** explicit turn-boundary payload + current pattern ID; block during resolution commit.

### E. Omission: one-shot minigame support

**Attack:** restarting could consume a one-shot hint twice or lose it.

**Resolution:** checkpoint granted support context and test both directions.

### F. Duplicate side effects

**Attack:** Result/Daily Episode/market restore could append/grant/purchase twice.

**Resolution:** test idempotency and transaction boundaries before enabling menu exit from those states.

### G. Overengineering

**Attack:** a universal pause/save service, multiple slots, or raw scene serialization expands blast radius.

**Resolution:** one optional envelope in existing save + scene-owned reconstruction.

### H. Persistence overclaim

**Attack:** `save_game()` true currently does not prove atomic durability across abrupt process/OS failure.

**Resolution:** narrow product copy and acceptance to existing application-level save success; separately harden if required.

### I. PR collision

**Attack:** changing Main Menu itself while PR #183 is open raises rebase/conflict risk.

**Resolution:** keep Continue consumer unchanged and implement from gameplay/GameState side unless a RED test proves otherwise.

### Current adversarial disposition

```yaml
P0_UNRESOLVED_DESIGN_BLOCKERS: 0
P1_UNRESOLVED_DESIGN_BLOCKERS: 0
OPEN_IMPLEMENTATION_RISKS:
  - exact per-scene checkpoint field set must be proven with TDD
  - current save write durability is not crash-atomic evidence
  - Human usability and controller behavior remain NOT_RUN
IMPLEMENTATION_AUTHORIZATION: NOT_GRANTED_BY_THIS_SPEC
```

---

## 18. Acceptance — planned, not executed

### Core persistence

- **Given** a supported gameplay scene with a stable checkpoint, **when** the player confirms Main Menu, **then** the save file contains that gameplay scene as resume target, not `main_menu.tscn`.
- **Given** save failure, **when** the player confirms, **then** the scene does not change and an error is shown.
- **Given** an old save without `gameplay_resume_checkpoint`, **when** it loads, **then** existing behavior remains compatible.

### Continue

- **Given** a successful gameplay→Main Menu save, **when** Continue is selected, **then** existing Main Menu load logic opens the saved gameplay scene.
- **Given** Main Menu `_ready` changed in-memory scene path, **when** Continue loads, **then** file state wins.

### Per-scene

- Preparation resumes without changing campaign semantics.
- Dialogue resumes at the defined semantic dialogue checkpoint without replaying committed effects.
- Investigation Main Menu exit does not call operation suspension or silently route to Preparation.
- Incomplete minigame resumes according to its declared safe restart policy with no one-shot hint duplicate/loss.
- Recovery/Battle restores the same stable pattern/turn state and does not reroll on load.
- Result resume does not create duplicate report/reward/follow-up.
- Secondary Market/Daily Episode paths pass their transaction/idempotency checks before exposure.

### Input/UX

- real mouse click and keyboard focus can activate Menu;
- confirmation blocks click-through;
- cancel/save failure restores focus;
- policy-specific consequence is visible before confirm;
- actual Windows Human QA remains required before a Human PASS claim.

---

## 19. Telemetry / playtest questions

No analytics backend is required for this feature. Human playtest should record:

1. Before pressing confirm, can the player correctly say where Continue will return?
2. Does `RESTART_INCOMPLETE_ATTEMPT` copy prevent surprise/anger in minigame exit?
3. Does recovery resume feel like “same situation” rather than a reroll?
4. Can mouse/keyboard/controller users find and cancel the action without accidental exit?
5. Does a save failure clearly explain that progress was not left behind?

---

## 20. Cut-down / rollback

Cut in this order if implementation risk grows:

1. defer Market and Daily Episode;
2. keep the six principal scenes only;
3. if Recovery checkpoint proves unsafe, temporarily disable Main Menu during Recovery rather than ship a destructive/rerolling resume;
4. if Minigame support-context preservation proves unsafe, keep existing no-save semantics and disable Main Menu during incomplete attempts rather than fake resume;
5. never cut P0 rules MM-R01–MM-R07.

Rollback is file-level removal of checkpoint API/scene menu affordances while preserving existing save keys and Main Menu Continue.

---

## 21. Open decisions / next gate

```yaml
CONFIRMED:
  - user approved option A and Decision ID on 2026-08-11
  - reuse canonical Main Menu and existing Continue
  - no frame-perfect promise where current schema lacks state
  - GitHub + Google Sheet same Decision ID synced
RECOMMENDED_DEFAULT:
  - optional JSON-safe checkpoint envelope in existing save
  - four resume-policy classes
  - principal six scenes before secondary HQ surfaces
USER_DECISION_REQUIRED:
  - written Spec approval before persistent product implementation
BLOCKED_UNVERIFIED:
  - actual per-scene RED/GREEN tests
  - Windows Human QA
  - controller/Android evidence
  - crash-atomic durability beyond current save contract
```

No persistent product runtime change is authorized merely by creating this Spec.