# Current Canon / Reference Freshness Audit — 2026-08-11

> Mode: `impact-map → reference-scan → content-drift → propagation-gap → closure-report`
>
> Base skill: `auditing-canonical-reference-freshness`
>
> Project baseline inspected: `cba130ee156c89710d3ddef33ed677bf99aa0716`
>
> Base remote inspected: `315c66eea9614c284b9c11c4d522141065dfa4b0`
>
> Status: `AUDIT_ONLY / PRODUCT_RUNTIME_UNCHANGED / RECONCILIATION_SCOPE_PROPOSED`

## 1. Why this audit exists

2026-08-11 live GitHub + Google Sheet reconciliation established that several active project routers still describe an earlier 2026-08-08~10 state as current.

The goal here is **not** to rewrite history or collapse all status documents into one file. The goal is to classify actual active consumers and identify the smallest owner-aware propagation set that must be refreshed without weakening compatibility anchors.

## 2. Current authority snapshot used for comparison

```yaml
project_main_last_observed: cba130ee156c89710d3ddef33ed677bf99aa0716
base_remote_main_last_observed: 315c66eea9614c284b9c11c4d522141065dfa4b0
project_adopted_base: fa69a77a14f923a756064f6ae151d34cadb374f7
project_adopted_base_auto_advanced: false
ui_hierarchy_pr180:
  merged: true
  merge_commit: 8294aa2eefe03fa7669617675516c9f03f739076
  exact_implementation_head: e6bc10992e631df546f64d356be506fafee5c939
  investigation_real_pointer_human_progression: PASS
  android: NOT_RUN
route_pr186:
  state: DRAFT
  route_core_human_qa: PASS
  post_clear_return: FAIL
route_blocker_pr189:
  state: DRAFT
  exact_red_head: 5e1c30a4b98732541d8c25d4f9390272c950cfeb
  exact_red_run: 31433463182
main_menu_pr183:
  state: DRAFT
  complete_input_gate: NOT_RUN
  gamepad: NOT_RUN
  android: NOT_RUN
main_menu_safe_return_decision:
  id: D-2026-08-11-GAMEPLAY-MAIN-MENU-SAFE-RETURN-CONTINUE
  user_direction: APPROVED_A
  planning_pr: 190
  planning_exact_head: f70fb8d56bce7cfaef6f92bd0cdfbf46b9cbf2ca
  planning_exact_head_ci: GREEN
  runtime: NOT_STARTED
handoff_reconciliation_pr191:
  state: DRAFT
  exact_head: 6af73377ee8e40d30d6fe18a2d2c54cc55e5958b
  changed_files: 1
  exact_head_ci: GREEN
base_bcp_014:
  status: IMPLEMENTED
  implementation_pr: 260
```

The above is an audit comparison snapshot, not a permanent hard-coded latest-main contract. Resume work must still read live refs again.

## 3. Impact map

| Surface | Consumer class | Current role | Finding | Default disposition |
|---|---|---|---|---|
| `START_HERE.md` | `CURRENT_MUTABLE + CANONICAL_LOCATOR` | top-level cold-start router and current gate summary | stale UI-hierarchy runtime/gate; stale active next-step | `FIX_NOW` candidate |
| `docs/CURRENT_CONFIRMED_DECISIONS.md` | `CURRENT_MUTABLE + CANONICAL_LOCATOR` | project-wide current approvals/substitution relationships | stale UI runtime status; missing 8/10–8/11 current Decisions; stale Base remote observation | `FIX_NOW`, high rewrite risk |
| `docs/DOCUMENTATION_MAP.md` | `CANONICAL_LOCATOR + CURRENT_MUTABLE_ROUTING` | routes workers to current owner docs | “current active implementation” still points to old ANNUAL-MVP-001 path/state | `FIX_NOW` candidate |
| `AGENTS.md` | `CANONICAL_LOCATOR + COMPATIBILITY_ANCHOR` | global rules and owner locators | no duplicated stale UI runtime status found in inspected portion | `NO_CHANGE` unless downstream evidence changes |
| `docs/CURRENT_HANDOFF.md` | `CURRENT_MUTABLE` | live continuation router | main version stale; separately corrected in Draft PR #191 | `SEPARATE_OWNER_PR191` |
| `docs/CURRENT_STATUS.md` | `HISTORICAL_DISCOVERY + IMPLEMENTATION_LEDGER` with some current summary | long implementation/QA history | old top summary exists, but large historical content must not be globally rewritten | `INSPECT / FOLLOW_UP`, not blanket replace |
| decision/spec/plan/audit history | `HISTORICAL_DISCOVERY` | evidence of what was true/approved at the time | old SHAs/status words may be intentional history | `ALLOWED_LEGACY` unless explicitly current-mutating |
| Git history / merged PR bodies | `HISTORICAL_DISCOVERY` | historical evidence | old then-current statements are valid historical records | `ALLOWED_LEGACY` |
| Google Sheet 00/02/04/98/99 | `CURRENT_MUTABLE + AUDIT_LEDGER` | current planning/audit propagation | reconciled on 2026-08-11 | `CURRENT`, continue readback on resume |

## 4. Finding FRESH-01 — `START_HERE.md` still routes to a pre-PR180 UI state

**Type:** `CONFLICTING_SOURCE / MISSING_PROPAGATION`

`START_HERE.md` currently declares:

```yaml
ui_hierarchy_runtime_implementation: NOT_STARTED
ui_hierarchy_new_runtime_render: NOT_RUN
```

and its next-gate flow still says to create the separate UI-hierarchy implementation branch/PR before Human QA.

This conflicts with actual merged PR #180:

- UI hierarchy runtime implementation merged;
- exact implementation head `e6bc1099...`;
- Windows 1280×720 real-pointer investigation progression Human QA PASS;
- the user reached the route-restore minigame;
- Android and broader release QA remain unverified.

### Required correction

The cold-start router should distinguish:

```text
UI hierarchy runtime implementation = MERGED_PR180
investigation pointer progression Human QA = PASS_EXACT_HEAD_PR180
route-restore endpoint/post-clear return = separate later Decisions/PRs
Android / broader complete release QA = NOT_RUN
```

Its “current next gate” must route to the **live open PRs and current decisions**, not tell the next worker to recreate PR #180.

**Disposition:** `BLOCKING_CURRENT_ROUTER / FIX_NOW`.

## 5. Finding FRESH-02 — `CURRENT_CONFIRMED_DECISIONS.md` contradicts implementation fact

**Type:** `CONFLICTING_SOURCE / MISSING_PROPAGATION`

The document still says the 2026-08-08 UI hierarchy Decision has approved design/plan but runtime remains unchanged / `NOT_STARTED`, and that Human validation is not run.

Actual authority:

- PR #180 merged runtime implementation into main on 2026-08-10;
- exact-head Windows pointer progression PASS exists for the investigation path;
- unrelated Android/broader release QA remains `NOT_RUN`.

This is not a wording preference. `CURRENT_CONFIRMED_DECISIONS.md` is explicitly named by `START_HERE.md` and `AGENTS.md` as the project-wide current user-approval authority, so stale implementation context can cause a new worker to repeat already-merged work or mis-sequence later Decisions.

**Disposition:** `BLOCKING_CURRENT_CANON / FIX_NOW_WITH_HISTORY_PRESERVATION`.

## 6. Finding FRESH-03 — new 2026-08-10/11 Decisions are missing from the current aggregate

**Type:** `MISSING_PROPAGATION`

At minimum, current aggregate routing must know about:

- `D-2026-08-10-DISPLAY-RESOLUTION-WINDOW-MODE`
- `D-2026-08-10-ROUTE-RESTORE-ENDPOINT-CONNECTIVITY`
- `D-2026-08-11-GAMEPLAY-MAIN-MENU-SAFE-RETURN-CONTINUE`

They do not all have the same implementation status:

```yaml
DISPLAY_RESOLUTION_WINDOW_MODE:
  decision: APPROVED
  implementation: NOT_STARTED
ROUTE_RESTORE_ENDPOINT_CONNECTIVITY:
  decision: APPROVED_CORRECTION
  implementation: DRAFT_PR186
  route_core_human_qa: PASS
  post_clear_return: FAIL
  blocker_red: PR189_CONFIRMED
GAMEPLAY_MAIN_MENU_SAFE_RETURN_CONTINUE:
  direction_A: APPROVED
  planning: DRAFT_PR190_DOCS_EXACT_HEAD_GREEN
  runtime: NOT_STARTED
```

These must not be flattened into one generic “approved” or “done” state.

**Disposition:** `FIX_NOW` in the current aggregate once full-file preservation can be guaranteed.

## 7. Finding FRESH-04 — Base remote observation in current aggregate is stale but adopted Base pin is not

**Type:** `STALE_REFERENCE`, with an important non-finding.

The project’s adopted Base pin remains:

```text
fa69a77a14f923a756064f6ae151d34cadb374f7
```

and **must not** be auto-advanced.

However the current aggregate’s “latest Base remote observed” value is older than the live remote `315c66ee...` seen on 2026-08-11.

### Correct model

```text
project-adopted Base = stable project-owned pin
Base remote latest observed = ephemeral audit fact, reread from GitHub
```

Do not replace the adopted pin with `315c66ee...` merely to make the numbers match.

**Disposition:** `FIX_NOW_CURRENT_OBSERVATION / KEEP_ADOPTED_PIN`.

## 8. Finding FRESH-05 — `DOCUMENTATION_MAP.md` current implementation routing is ANNUAL-stale

**Type:** `STALE_REFERENCE / CONFLICTING_SOURCE`

Its `현재 활성 구현 라우팅` still ends at the old ANNUAL-MVP-001 isolated implementation plan and declares:

```text
APPROVED_DESIGN_BASELINE / ANNUAL-MVP-001 PLAN_PENDING_APPROVAL
```

That is no longer a safe project-wide active implementation route for the present 2026-08-11 work, where the live frontier includes:

- route endpoint/post-clear blocker;
- Main Menu Ver 4.3 Draft;
- gameplay→Main Menu safe-return written-Spec gate;
- display-settings plan queued after current blockers.

### Required correction

`DOCUMENTATION_MAP.md` should remain a **topic/owner router**, not attempt to freeze one historical implementation frontier as the global “current active” track.

Preferred direction:

```text
CURRENT_CONFIRMED_DECISIONS
+ CURRENT_HANDOFF / live PRs
→ choose topic owner
→ choose current Decision/spec/plan for that topic
```

ANNUAL-specific routing remains valid under an ANNUAL work condition, not as a universal current implementation entrypoint.

**Disposition:** `FIX_NOW_ROUTING_SCOPE`.

## 9. Finding FRESH-06 — `AGENTS.md` is not currently a duplicated-state defect

**Type:** `FALSE_POSITIVE / NO_CHANGE`

The inspected `AGENTS.md` mainly:

- defines read order;
- declares canonical owners;
- sets immutable project terms;
- states global implementation rules.

It does **not** reproduce the stale `ui_hierarchy_runtime_implementation: NOT_STARTED` current-state block found in `START_HERE.md` and `CURRENT_CONFIRMED_DECISIONS.md`.

Changing it merely because it links those files would create unnecessary churn.

**Disposition:** `NO_CHANGE`.

## 10. Finding FRESH-07 — `CURRENT_STATUS.md` must not be mass-normalized

**Type:** `LEGACY_REFERENCE_ALLOWED + FOLLOW_UP_INSPECT`

`CURRENT_STATUS.md` is a long implementation/verification ledger containing historical ANNUAL, CORE, QA, version and artifact evidence. Old values inside historical sections are not defects merely because later work exists.

The top “현재 기준” can become stale, but a blanket rewrite of the file would risk converting historical truth into invented current truth.

Before any edit, classify its sections into:

- current mutable summary;
- historical regression evidence;
- long-lived implementation fact;
- compatibility anchor.

**Disposition:** `FOLLOW_UP`, separate from the minimal current-router patch.

## 11. Why no direct rewrite of `CURRENT_CONFIRMED_DECISIONS.md` was performed in this audit branch

The current GitHub connector exposes whole-file replacement for existing files, not a partial patch operation.

`CURRENT_CONFIRMED_DECISIONS.md` is long and history-heavy. Tool output for the full file is truncated in this environment, while line-range reads provide only partial windows.

A whole-file replacement assembled from incomplete content would create a higher-risk failure mode:

- accidental truncation;
- dropped historical Decisions;
- broken machine-consumer literals;
- lost links/anchors;
- false “freshness” achieved by deleting history.

Therefore this audit treats **preservation of the existing full canonical file as a hard safety constraint**. The next mutation step should only proceed when the complete file can be read and deterministically round-tripped, or via an environment/tool that supports partial patching.

This is an `UNVERIFIED_DEPENDENCY` on the current mutation surface, not permission to leave the stale canon untracked.

## 12. Propagation-gap matrix

| Source change / live fact | Expected consumer | Current consumer status | Required action |
|---|---|---|---|
| PR #180 UI runtime merged | START_HERE | stale | update current block/gate |
| PR #180 UI runtime merged | CURRENT_CONFIRMED_DECISIONS | stale | update current status while preserve Decision history |
| user resumed work | CURRENT_HANDOFF | stale on main, corrected PR191 | finish PR191 lifecycle separately |
| Main Menu A approved | Sheet | synced | none |
| Main Menu A approved | Issue #181 | synced | none |
| Main Menu A approved | CURRENT_CONFIRMED_DECISIONS | missing | add once safe full-file mutation available |
| Route endpoint Decision | Sheet | reconciled | none |
| Route endpoint Decision | CURRENT_CONFIRMED_DECISIONS | missing | add once safe full-file mutation available |
| Display Decision | Sheet | present | none |
| Display Decision | CURRENT_CONFIRMED_DECISIONS | missing | add once safe full-file mutation available |
| BCP-014 implemented PR260 | Sheet 98 | synced | none |
| BCP-014 implemented PR260 | CURRENT_HANDOFF main | stale, PR191 fixes | separate PR191 |
| current project frontier | DOCUMENTATION_MAP | ANNUAL-stale | make routing topic-aware/live-frontier-aware |

## 13. Smallest safe reconciliation proposal

### Slice A — low-risk router correction

Potential files:

- `START_HERE.md`
- `docs/DOCUMENTATION_MAP.md`

Goals:

- stop cold-start workers from trying to recreate PR #180;
- remove project-wide “current active implementation = old ANNUAL plan” assumption;
- route current work through live GitHub/Sheet/current Decision owners.

This slice should not add or rewrite product semantics.

### Slice B — current Decision aggregate correction

File:

- `docs/CURRENT_CONFIRMED_DECISIONS.md`

Prerequisite:

- complete deterministic full-file read/round-trip or a partial-patch-capable environment.

Goals:

- preserve all historical Decision text;
- update UI hierarchy implementation truth;
- add the 8/10–8/11 Decision entries and differentiated statuses;
- update Base remote observation without changing project-adopted Base pin;
- retain current-vs-history distinction.

### Slice C — historical/current status ledger inspection

File:

- `docs/CURRENT_STATUS.md`

Only after section classification. Do not couple this to Slice A/B unless exact impact evidence requires it.

## 14. Adversarial review of the reconciliation plan

### Attack A — “Fresh” by deleting old facts

Rejected. Historical PR/Decision/QA evidence stays historical; current summary layers are corrected instead.

### Attack B — auto-adopt latest Base

Rejected. Base remote and project-adopted Base are different authorities.

### Attack C — use PR191 Draft handoff as if already main

Rejected. PR191 is useful exact-head evidence but remains Draft/unmerged. Main consumers cannot assume it exists on main.

### Attack D — update every file that mentions an old SHA/status

Rejected. History-only references are allowed legacy, not stale-current defects.

### Attack E — rewrite the large Decision aggregate from truncated tool output

Rejected. Preservation risk exceeds freshness benefit; tracked as mutation-surface dependency.

### Attack F — treat PR180 Human pointer PASS as complete Human/Android QA

Rejected. Only the actual investigated path is PASS. Android and broader complete input/release evidence remain separately `NOT_RUN`.

## 15. Closure report

```yaml
BLOCKING_CURRENT_ROUTER:
  - START_HERE stale UI hierarchy implementation/gate
  - CURRENT_CONFIRMED_DECISIONS stale UI hierarchy implementation status
FIX_NOW_CANDIDATES:
  - START_HERE.md
  - docs/DOCUMENTATION_MAP.md
FIX_NOW_WHEN_SAFE_MUTATION_AVAILABLE:
  - docs/CURRENT_CONFIRMED_DECISIONS.md
FOLLOW_UP:
  - section-aware CURRENT_STATUS freshness audit
SEPARATE_ALREADY_TRACKED:
  - CURRENT_HANDOFF via PR191 exact head 6af73377
ALLOWED_LEGACY:
  - historical PR bodies
  - historical Decision/audit/plan wording
  - old SHAs that explicitly describe then-current evidence
NO_CHANGE:
  - AGENTS.md based on current inspected evidence
UNVERIFIED_DEPENDENCY:
  - safe partial mutation / deterministic complete round-trip for long CURRENT_CONFIRMED_DECISIONS.md in current connector surface
product_runtime_changed: false
human_qa_executed_by_this_audit: false
android_qa: NOT_RUN
```

## 16. Next verification gate

This audit branch itself must pass exact-head documentation/reference/Base/core workflows before its findings are used as a durable project artifact.

The audit being GREEN would prove only that the **audit document** is repository-contract-safe. It would not resolve the stale current consumers until the proposed reconciliation slices are implemented and independently verified.