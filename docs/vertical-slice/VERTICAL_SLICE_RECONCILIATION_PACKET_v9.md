# Vertical Slice v9 Reconciliation Packet — 괴이기록국(urban-legend)

## Packet Status

- Issue: `#119`
- Branch: `chore/base-v9.3-vertical-slice-v9`
- Current phase: `RECONCILIATION_PLANNING_PROFILE`
- Product modification authority: `NOT_OPEN`
- Operating-contract implementation authority: `APPROVED`
- Google Sheet write authority before merge: `BLOCKED`

---

## 1. Baseline Recovery Record

### Repository and Release

| Item | Recovered Value | Status |
|---|---|---|
| Project | `괴이기록국(urban-legend)` | `CONFIRMED` |
| Repository | `alsdmlals4-eng/urban-legend` | `CONFIRMED` |
| Main SHA | `656846865eb88871d00842a0da527ce1b0722b77` | `CONFIRMED` |
| Current Adapter | Base `9.1.0` | `CONFIRMED_STALE_TARGET` |
| Target Base | `9.3.0` | `USER_APPROVED` |
| Target release | `30ca6c7b5f93521f0eb0eed42d01437cd43c50ae` | `CONFIRMED` |
| Target evidence | `462a86db192d23d0f386281a1eb54b0a8cbad62e` | `CONFIRMED` |
| Registry hash | `9847bb2b225c776ad7916930f0f48c490bc2a898bea8e02ea1fdd0e6caac60c1` | `CONFIRMED` |
| Sheet ID | `14xtlvd90iQTKjDLcZR_b-WS5fHnBwNf-OfBruPBS6ck` | `CONFIRMED` |
| Engine | Godot 4.7 line | `CONFIRMED` |
| Current platform | PC | `USER_CONFIRMED` |
| Future platform | Mobile consideration | `USER_CONFIRMED_NOT_IMPLEMENTED` |

### Current Product Gate

- ANNUAL-MVP-002: implemented according to current project and Sheet records
- automatic and visual evidence: historical/current records exist
- human/new-player validation: `NOT_RUN`
- production expansion: `NOT_APPROVED`
- ANNUAL-MVP-003: not opened by this Issue

### Facts, Assumptions and Undecided

#### Confirmed

- Project Adapter, Snapshot and router are present.
- Adapter is pinned to Base v9.1.
- Base v9.3 is released with exact release/evidence/Registry pins.
- ten project discipline routes are present in the current Adapter and Snapshot.
- current Sheet tabs exist and identify the project as 괴이기록국(urban-legend).
- Sheet currently presents v9.1 as synced.
- Adapter currently presents the Sheet relationship as conflict/blocking.

#### Assumptions

- none are allowed to change product scope.
- Base v9.3 validation is expected to preserve the current project routes, but the actual generator and validator must prove this.

#### Undecided / Separate Gate

- mobile UX and input contract
- gamepad completion
- human/new-player validation result
- ANNUAL-MVP-003 scope
- production expansion

### Protected Boundary

No migration diff is allowed in:

```text
data/
scripts/
scenes/
assets/
addons/
project.godot
```

---

## 2. Legacy Requirement Traceability

| Legacy Input | Current Responsibility | Classification | Action |
|---|---|---|---|
| `VERTICAL_SLICE_INTEGRATED_EXECUTION_PROMPT_v8.md` | v9 contract | `SUPERSEDED_COMPATIBILITY` | preserve, remove active authority claims |
| old 25-Skill Base index in `docs/BASE_RULES_VERSION.md` | canonical Adapter + pinned Base Registry | `STALE_REFERENCE` | update in place |
| v8 BCA section in `docs/BASE_RULES_VERSION.md` | Vertical Slice v9 application | `STALE_PROMPT_CONTRACT` | replace active wording; keep history |
| Base v9.1 release/evidence pins | Base v9.3 lock | `UPDATE_IN_PLACE` | update canonical Adapter |
| v9.1 Snapshot/router/generated views | Base v9.3 generator outputs | `GENERATED_STALE_OUTPUT` | regenerate only |
| old Sheet sync summary | merged main + exact Sheet readback | `RECONCILIATION_REQUIRED` | merge-then-sync |
| project discipline Skills | project Registry and local Skill files | `CURRENT_KEEP` | preserve |
| investigation case authoring Skill | project local specialist | `CURRENT_KEEP` | preserve |
| product game files | Godot implementation authority | `PROTECTED_CURRENT` | no change |

No legacy requirement may reintroduce HP-zero anomaly extermination, answer-giving companions, save changes or mobile scope.

---

## 3. Source / Consumer / Propagation Map

| Source Authority | Direct Consumers | Propagation Target | Recheck Method |
|---|---|---|---|
| Base `base-v9.3.lock.json` | project Adapter | Base pins and Registry hash | compare exact values |
| `skills/PROJECT_BASE_ADAPTER.json` | Snapshot, compatibility views, router, dashboard, validators | human authority and CI | Base generator `--check` |
| `skills/PROJECT_LOCAL_SKILL_REGISTRY.json` | Adapter project routes, Snapshot | router and Skill discovery | route count/path tests |
| `skills/SKILL_REGISTRY.json` | project discipline view and human routing | project local Registry | package integrity tests |
| `docs/BASE_RULES_VERSION.md` | AGENTS, AI/Codex readers | work contract selection | active reference tests |
| `docs/CURRENT_STATUS.md` | START_HERE, handoff, Sheet summary | next Gate | current-state audit |
| merged GitHub main | Google Sheet summary | project hub, audit, GDD summary, history | post-merge SHA readback |
| Google Sheet contracted tabs | human planning workspace | no automatic canon promotion | bounded range re-read |
| protected Godot paths | runtime and product evidence | no operating migration propagation | `git diff --name-only` |

---

## 4. Duplicate·Omission·Conflict Finding Ledger

| ID | Severity | Finding | Evidence State | Required Resolution | Status |
|---|---|---|---|---|---|
| UL-V9-001 | P1 | canonical Adapter is Base v9.1 while target is v9.3 | confirmed | update exact pins and validate | `OPEN` |
| UL-V9-002 | P1 | human Base document presents old v8/25-Skill authority | confirmed | update in place; preserve legacy | `OPEN` |
| UL-V9-003 | P1 | Sheet says synced while Adapter says conflict/blocked | confirmed | three-way reconciliation and merge-then-sync | `OPEN` |
| UL-V9-004 | P1 | generated Snapshot/router/views are tied to v9.1 | confirmed | regenerate with Base v9.3 | `OPEN` |
| UL-V9-005 | P2 | current platform is PC but mobile future consideration is not a single explicit machine/human boundary | confirmed | add explicit project metadata and authority wording | `OPEN` |
| UL-V9-006 | P2 | current status/document map may retain already-merged work as a future gate | confirmed in prior audit; must be re-read during implementation | reconcile current documents | `OPEN` |
| UL-V9-007 | P2 | operating health may not propagate all existing static evidence | partial | link evidence without raising runtime/device/human | `OPEN` |
| UL-V9-008 | P0 | product protected paths changed by migration | not observed | must remain empty; any diff blocks PR | `GUARD` |
| UL-V9-009 | P0 | Sheet written before merged-main readback | not observed | prohibited | `GUARD` |
| UL-V9-010 | P0 | runtime/device/human maturity raised without evidence | not observed | prohibited | `GUARD` |

### Resolution Policy

- P0/P1 must be resolved before ready-for-review or merge.
- P2 must have an owner, impact and next Gate.
- generated outputs are never repaired by hand.
- no average score can hide a P0/P1.

---

## 5. Vertical Slice Readiness + Critical Gate

### Existing Representative Experience

The existing project promise remains:

```text
observe and record
→ compare evidence
→ reduce candidate rules
→ prove a hypothesis
→ stabilize the manifestation
→ recover the residue
→ update the anomaly manual
```

ANNUAL-MVP-002 adds preparation, allies, equipment, research, support and save/return around the investigation loop.

### Readiness Assessment

| Area | Status | Reason |
|---|---|---|
| core player promise | `CURRENT` | project canon and implemented case exist |
| representative PC flow | `PARTIAL_IMPLEMENTED` | current Godot build exists; this Issue does not rerun it |
| Base operating binding | `BLOCKED_P1` | v9.1 → v9.3 migration pending |
| project Skill routing | `CURRENT_TO_REVALIDATE` | 10 routes present; v9.3 validation pending |
| save compatibility | `PROTECTED_NOT_CHANGED` | out of scope |
| PC platform contract | `CURRENT` | 16:9, mouse/keyboard |
| mobile | `FUTURE_CONSIDERATION_NOT_IMPLEMENTED` | separate Gate required |
| automated evidence | `EXISTING_REVALIDATION_REQUIRED` | run operating and full Python suites |
| Godot runtime/device | `NOT_RUN_THIS_ISSUE` | product files out of scope |
| human/new-player | `NOT_RUN` | remains next product Gate |

### Critical Gate

`BASE_V9_3_APPLICATION_BINDING`

Pass only when:

- exact v9.3 pins validate;
- generated outputs are current;
- project routes and local Skill are preserved;
- active v8/v9.1 authority conflicts are removed;
- protected paths have no diff;
- P0/P1 findings are closed;
- required review has no unresolved thread;
- Sheet has not been written before merge.

---

## 6. Approval Bundle + Change Plan

### Approved Decisions

- migrate to Base v9.3
- use Vertical Slice v9 contract
- project name is 괴이기록국(urban-legend)
- current platform is PC
- mobile is future consideration only
- use the provided GitHub repository and Google Sheet
- preserve project product and Skill boundaries

### Minimal Change

1. add the application, reconciliation, design, plan and Goal documents;
2. add a Red v9.3 contract test;
3. update canonical Adapter pins, baseline and platform metadata;
4. generate all derived views with Base v9.3;
5. repair human authority and status consumers;
6. run contract, full Python, protected-boundary and adversarial review;
7. open and review the Draft PR;
8. merge only after required checks;
9. re-read merged main;
10. synchronize exact Sheet ranges and verify readback;
11. close Issue #119 only when GitHub and Sheet agree.

### Excluded

- product code and content
- save or ID changes
- mobile implementation
- new Vertical Slice feature scope
- production expansion
- unsupported evidence promotion

### Acceptance Evidence

- Red and Green test output
- Base generator and validator output
- route preservation output
- full Python regression
- `git diff --check`
- protected path diff empty
- independent/adversarial review result
- PR and merged main SHA
- exact Sheet range before/after readback
- explicit `NOT_RUN` list

### Rollback

- no Sheet change before merge means failed migration branches are disposable;
- revert canonical Adapter and human authority changes together;
- regenerate rather than reverse-edit generated outputs;
- keep the Issue open with the exact blocking finding;
- create a Base proposal only for a confirmed reusable Base defect.

---

## Evidence Log

| Evidence | Result |
|---|---|
| Base v9.3 lock read | `PASS` |
| Vertical Slice v9 contract read | `PASS` |
| project Adapter read | `PASS` |
| project Snapshot read | `PASS` |
| AGENTS and stale Base document read | `PASS` |
| Sheet metadata and five key tabs read | `PASS` |
| local repository clone/test | `NOT_RUN_ENVIRONMENT_DNS_BLOCKED` |
| implementation tests | `NOT_RUN` |
| Base generator | `NOT_RUN` |
| Godot runtime | `NOT_RUN` |
| device/mobile | `NOT_RUN` |
| accessibility execution | `NOT_RUN` |
| human/new-player | `NOT_RUN` |

Update this log with actual command output during implementation. Do not replace `NOT_RUN` with PASS without evidence.