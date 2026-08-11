# Hybrid Narrative · Deduction · Growth — Phase B Final Planning Review

- Decision: `D-2026-08-11-HYBRID-NARRATIVE-DEDUCTION-GROWTH-INTEGRATION`
- Feature umbrella: `UL-HYBRID-NARRATIVE-DEDUCTION-GROWTH-001`
- Review date: `2026-08-11 KST`
- Exact user gate received: **`기획 완료`**
- Work-instruction authority: `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION.md` / v4.5-r2
- Phase result: `PHASE_B_FINAL_REVIEW_COMPLETE / PACKAGE_1_DOR_LOCKED / PHASE_C_READY`
- Product runtime mutation in this planning PR: `NONE`
- Human usability evidence: `NOT_RUN`
- Player Experience evidence: `NOT_RUN`

## 1. Fresh authority readback

Phase B did not rely on historical chat state as current truth. It re-read the live authorities before locking Package 1.

### Base

- repository: `alsdmlals4-eng/Base`
- default branch: `main`
- current observed Base main: `315c66eea9614c284b9c11c4d522141065dfa4b0`
- fresh-read router/operating references: `START_HERE.md`, `AGENTS.md`, `docs/OPERATING_MODEL.md`, `docs/WORK_MODE_AND_SKILL_ROUTING.md`, `docs/DOCUMENTATION_MAP.md`
- project-adopted Base baseline remains a separate historical adoption fact and is not auto-upgraded merely because Base remote moved.

### Project GitHub

- repository: `alsdmlals4-eng/urban-legend`
- default branch: `main`
- current planning baseline: `aee356a140c32c820a1c8832965b62ac3a5a6d58`
- baseline commit: `docs: adopt v4.5-r2 project work-instruction canon (#194)`
- active design PR: `#195`
- remaining open PR frontier was freshly re-read; historical exact-head green from older bases is not reusable as strict current-main merge evidence after main moves.

### Google Sheet

- workbook: `괴이기록국(urban-legend)`
- Decision row: `02_현재_확정결정` row `106`
- live row was still at `USER_WRITTEN_SPEC_REVIEW_REQUIRED / PRODUCT_BUILD_NOT_AUTHORIZED` when this Phase B review began and therefore must be synchronized after GitHub exact-head/merge readback.
- `10_제품방향` current Gate was stale and still referred to an older Validation/writing-plans/Codex sequence. This is a current-state drift to reconcile, not a reason to downgrade v4.5-r2.

## 2. Final feature decomposition

The approved umbrella remains intentionally split. Phase C authorization applies only to **Package 1**, not to all five umbrella components.

```text
Umbrella: FACT → MEANING → IDENTITY
  └─ Package 1 PoC — IMPLEMENTATION PACKAGE LOCKED
       1. Afterlife chapter-1 Thought-Path observation
       2. one staff-room investigation Scene Contract
       3. one post-case Oh Hyun incident callback

Later candidates — NOT INCLUDED IN PACKAGE 1 BUILD
  ├─ Investigator Identity L2
  ├─ Core Relationship Network L2
  └─ Year-One Narrative Spine L2
```

Surviving PoC components must be classified `KEEP / CHANGE / RETEST / REMOVE` before any later L2 promotion.

## 3. Existing / current-valid / conflict-stale classification

### 3.1 Already implemented and reusable

Phase B found enough existing infrastructure to reject a new parallel relationship/identity architecture.

| Existing owner | Current capability | Package 1 use |
|---|---|---|
| `data/episodes/episode_001_afterlife_station_canon_v2.json` | Canon v2 chapter/manual/evidence authority with `record_afterlife_*` records | chapter-1 Thought Path source |
| `scripts/data/afterlife_canon_v2_loader.gd` | explicit Canon v2 layering; legacy authority keys erased/reprojected | preserve current truth authority |
| `scripts/core/game_state.gd` | investigation method results, agent trust, one-time `triggered_agent_event_ids`, authored agent events, save persistence | incident choice memory + existing callback ID |
| `scripts/scenes/result_scene.gd` | displays triggered agent events/support text in the case report | callback output; no new result UI |
| `scripts/core/afterlife_migrating_game_state.gd` | Canon v2 runtime state, protection obligations, follow-up records, evaluation packet | preserve responsibility/evaluation owner |
| `scripts/core/protection_follow_up_policy.gd` | bounded causal follow-up records and evaluation axes | no parallel long-term callback DB |
| `scripts/ui/canon_v2_runtime_bridge.gd` | result-time follow-up/evaluation bootstrap | preserve current runtime linkage |

Result: `EXISTING_SOLUTION_FIRST = PASS`.

### 3.2 Approved design still current

The following remain valid and unchanged:

- `FACT → MEANING → IDENTITY` is the integration rule.
- Required mystery truth remains independent of stats, relationship, identity, tags, and RNG.
- No universal morality/affection meter is introduced.
- Relationship memory comes from actual incident/responsibility decisions rather than gift/click grind.
- Identity feedback may frame optional context/responsibility, never replace objective anomaly truth.
- Automated tests cannot establish fun, emotional resonance, comprehension, or Player Experience.

### 3.3 Conflicts and stale inputs

#### A. Han Serin Package 1 eligibility conflict — resolved by current authority

Fresh `13_주요인물` Sheet data classifies **Han Serin as `PARTIAL_DISABLED`** and Oh Hyun as current. Therefore:

```text
Package 1 companion = Oh Hyun only
Han Serin = EXCLUDED_FROM_PACKAGE_1_WHILE_PARTIAL_DISABLED
```

The umbrella Spec's earlier candidate wording that grouped Oh Hyun and Han Serin is superseded **for Package 1 selection only** by this Phase B review. It is not a broad deletion of Han Serin from all future design.

#### B. Sheet current-Gate drift — open until post-merge synchronization

`10_제품방향` still described an older Validation/Codex gate. Current v4.5-r2 authority is:

```text
exact `기획 완료` received
→ Phase B final planning review
→ Package 1 DoR lock
→ HiGodot-authorized Phase C BUILD
```

This row must be reconciled after GitHub exact-head/merge evidence is known.

#### C. Main-content responsibility path drift — remains owner-aware open debt

Sheet `50_메인콘텐츠` points at an absent historical GitHub Decision path. Phase B does not recreate a missing authority file from inference. State remains `OPEN_OWNER_RECONCILIATION`.

#### D. `CURRENT_AFTERLIFE_STATION_CANON` implementation-status wording is history-heavy

`docs/CURRENT_AFTERLIFE_STATION_CANON.md` still contains older `IMPLEMENTATION_NOT_AUTHORIZED` wording. Later main Decisions, Canon v2 files, current runtime code, and current router state demonstrate later implementation. The older wording is not used as current product-implementation truth for this Package 1 review.

#### E. Chapter-1 answer priming — confirmed validation risk, not silently fixed

Current Canon v2 page 1 is titled `목적지는 방송되지 않는다`, and the Canon v2 operation/manual UI renders page titles even while pages may be `[후보]`. Current intro/base wording also contains answer-adjacent statements. Therefore a blind player's Thought Path may be primed before independent inference.

Classification:

```text
PRIMING_RISK = OPEN_AS_HUMAN_CHARACTERIZATION_ITEM
NOT_AUTOMATIC_CONTENT_REWRITE
NOT_PLAYER_EXPERIENCE_PASS
```

Package 1 is specifically designed to measure this. If at least 2/5 fresh participants report that title/intro wording gave away the answer, a separate CHANGE package is required before broader Thought-Path claims.

## 4. Benchmark / professional comparison disposition

PR #195 already contains the approved `SOURCE_CONTEXT_PACKET` covering benchmark/professional/player-response inputs. Phase B reviewed that packet as planning evidence and found no requirement for a new external benchmark search merely to lock this bounded PoC.

Evidence ceiling remains:

```text
benchmark/professional evidence = planning input
Steam/player-response signal = directional input
Urban Legend new Human usability = NOT_RUN
Urban Legend new Player Experience = NOT_RUN
```

## 5. Adversarial review of the final implementation package

### Attack: “Add a new relationship schema now”

Rejected. Existing one-time event persistence and case-report output are sufficient for one PoC callback. A broad schema before Human validation creates scope without evidence.

### Attack: “Just raise Oh Hyun trust by adding a balanced trust rule”

Rejected. The existing authored callback text is specifically causal about opening a route. Adding arbitrary numeric trust would turn incident memory into an affection-style proxy and introduce an unapproved balance value.

### Attack: “Existing Oh Hyun event already solves it”

Rejected as incomplete. Current Oh Hyun temperament is `balanced`, while the inspected staff-room methods define trust rules for `breakthrough`, `empathetic`, and `analytical`. The event remains trust ≥2 and is not naturally reachable from that representative staff-room choice.

### Attack: “Trigger by reading `method_results` after the choice”

Rejected for the current call site. In `resolve_investigation_method`, event evaluation happens before the new `method_result` is stored into `method_results[point_id]`. The implementation must pass the just-resolved context explicitly rather than depend on not-yet-persisted state or reorder unrelated persistence.

### Attack: “Rewrite the page title now because it looks like a spoiler”

Rejected in the initial implementation package. The risk is real, but the PoC's Human protocol is the evidence gate. Silent wording changes would destroy the baseline being characterized and mix content tuning with relationship-runtime work.

### Attack: “Build all Identity/Relationship/Year-One systems because planning is complete”

Rejected. `기획 완료` closes the project planning gate; it does not erase the approved PoC-before-L2 decomposition.

Final adversarial disposition:

```text
PACKAGE_1_SURVIVES_PHASE_B_ADVERSARIAL_REVIEW
MINIMAL_GAP = INCIDENT_CONTEXT_TRIGGER_FOR_EXISTING_OH_EVENT
NO_PARALLEL_SCHEMA
HUMAN_PRIMING_RISK_REMAINS_OPEN
```

## 6. Locked Package 1 implementation scope

Implementation plan authority:
`docs/superpowers/plans/2026-08-11-afterlife-station-fact-meaning-identity-poc-implementation-plan.md`

Only the following initial product/test/QA surfaces are authorized by Package 1:

```text
MODIFY  scripts/core/game_state.gd
CREATE  tests/canon_v2_runtime/canon_v2_fact_meaning_identity_poc_test.gd
MODIFY  tests/run_canon_v2_runtime_ux_tests.sh
CREATE  docs/qa/2026-08-11-afterlife-fact-meaning-identity-poc-human-playtest.md
```

### Exact minimal runtime contract

Reuse stable event:

```text
agent_event_oh_breakthrough_warning_01
```

Add event metadata:

```gdscript
"trigger_mode": "incident_context",
"trigger_context": {
    "point_id": "point_staff_room_door",
    "method_type": "destruction",
    "successful": true
}
```

Add interfaces:

```gdscript
_agent_event_requirements_met(event: Dictionary, context: Dictionary) -> bool
_try_trigger_agent_trust_events(context: Dictionary = {}) -> Array
```

Default events without `trigger_mode` remain trust-threshold-gated. The Oh Hyun incident callback requires Oh Hyun to be in the selected team, uses the matching successful staff-room forced-entry context, remains one-time through the existing stable event ID, and does not create a numeric trust delta.

### Protected no-change initial package

No initial modification to:

- Afterlife base episode JSON
- Canon v2 sidecar/runtime projection
- Canon v2 loader/migration/follow-up architecture
- result scene
- any Scene/Resource
- `project.godot`
- save version/schema
- event ID or existing Oh Hyun event copy

## 7. Test and Human evidence gates

### Automated TDD

Required order:

```text
RED focused event-contract test
→ minimum GameState change
→ GREEN focused test
→ maintained Canon v2 runtime suite
→ maintained full Godot regression
→ exact-head CI
```

The focused matrix must prove:

1. existing trust events still require the existing threshold;
2. Oh callback does not trigger for a different point/method/failure;
3. Oh must be selected;
4. matching staff-room destruction success triggers at zero numeric trust;
5. same event ID triggers once;
6. existing title/text/support copy remains unchanged.

### Human / Player Experience preregistration

Recommended starting sample: **5 fresh/unexposed sessions** (`RECOMMENDED_STARTING_SAMPLE`, not population/statistical proof).

Fixed decision rules:

- `THOUGHT_PATH_KEEP`: ≥4/5 articulate page-1 hypothesis using ≥2 independent records before explicit answer exposure.
- `PRIMING_CHANGE`: ≥2/5 report title/intro wording gave away the answer.
- `CALLBACK_CAUSALITY_KEEP`: ≥4/5 identify the staff-room choice as the callback's causal source.
- `HIDDEN_METER_CHANGE`: ≥2/5 primarily interpret the callback as generic affection/trust points rather than incident memory.

Actual sessions remain `NOT_RUN` at Phase B close.

## 8. Dependencies, protection, and rollback

### Dependencies

- current main/Base/Sheet authority fresh-read complete;
- Canon v2 runtime/evidence infrastructure exists on current main;
- Oh Hyun current eligibility confirmed;
- implementation must execute through the current HiGodot persistent-authoring authority.

### Protected semantics

- stable episode/victim/Canon IDs;
- objective anomaly truth;
- required clue/record access and normal clear;
- existing save fields and save versions;
- current Canon v2 follow-up/evaluation owner;
- Legacy/Validation isolation;
- current event ID and authored copy.

### Rollback

Revert the Oh event trigger metadata, requirement helper, and explicit context call. Preserve the stable event ID and save list. This returns the old trust-threshold-only behavior with no save migration.

## 9. Definition of Ready

| Gate | Result |
|---|---|
| exact `기획 완료` declaration | `PASS / RECEIVED_2026-08-11_KST` |
| Base current re-read | `PASS` |
| project main/open PR/latest re-read | `PASS` |
| Sheet current state re-read | `PASS` |
| GitHub ↔ Sheet conflicts classified | `PASS` |
| feature decomposition bounded to Package 1 | `PASS` |
| existing solution first | `PASS` |
| current-valid / stale / conflict classification | `PASS` |
| benchmark/professional evidence disposition | `PASS` |
| implementation sequence and protected surfaces | `PASS` |
| adversarial review | `PASS` |
| exact implementation plan | `PASS` |
| Human evidence preregistration | `PASS / EXECUTION_NOT_RUN` |
| persistent product-authoring executor in this ChatGPT surface | `NOT_AVAILABLE / HIGODOT_REQUIRED` |

Final state:

```text
PHASE_B_FINAL_REVIEW_COMPLETE
PACKAGE_1_DOR_LOCKED
PHASE_C_READY
HIGODOT_EXECUTOR_REQUIRED_FOR_PERSISTENT_PRODUCT_BUILD
PRODUCT_RUNTIME_BUILD_NOT_STARTED_IN_THIS_PLANNING_PR
HUMAN_USABILITY_EVIDENCE=NOT_RUN
PLAYER_EXPERIENCE_EVIDENCE=NOT_RUN
```

Phase C may begin when the package is handed to the authorized HiGodot execution surface. This review does not fabricate a PowerShell/Codex/HiGodot run and does not claim product implementation that has not occurred.
