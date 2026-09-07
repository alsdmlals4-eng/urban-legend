# Notion current work migration receipt — 2026-08-28

> Status: `CURRENT_MIGRATION_COMPLETE / REPOSITORY_CANON`
>
> Migration rule: Notion is preserved without edits as `HISTORICAL_READ_ONLY_NO_WRITE`. This document and the linked repository documents now own the usable project record. A Notion URL below is provenance, not a future source-of-truth link.

## Purpose and read boundary

The user requested that the project no longer use Notion, while ensuring that the existing Notion structure and current work products are not lost. On 2026-08-28, the urban-legend Home, all six project-domain roots, their current child work products, and the current visual attachments were fresh-read.

- Included: project structure, current plan/flow/visual/production/validation work, current reference mockups, and material historical conflicts needed to prevent accidental reuse.
- Excluded from content migration: legacy annual/weekly datasets, other projects under the shared Notion hub, expired activity logs, and superseded numeric balances. They remain named here for provenance only.
- Notion writes, deletions, archival actions, and page restructuring: **not performed**.

## Repository entry points after migration

| need | repository owner |
| --- | --- |
| human/AI master GDD | `docs/design/PROJECT_AI_PRODUCTION_SPEC.md` |
| authoritative current state | `docs/CURRENT_PLANNING_CANON.md`, `docs/current-planning-canon.json`, `docs/CURRENT_DECISION_OVERLAY.md` |
| next-work boundary | `docs/CURRENT_HANDOFF.md`, `docs/PROJECT_CONTEXT.md` |
| implementation-vs-evidence reality | `docs/CURRENT_STATUS.md`, actual `scripts/`, `data/`, `scenes/`, and tests |
| M01/M04 experience flow | `docs/M01_M04_VERTICAL_SLICE_FLOW.md` and the master GDD sections 03–09 |
| visual grammar and consumers | `docs/visual/VISUAL_DIRECTION_LOCK_PACKET_2026-08-28.md`, `docs/CURRENT_VISUAL_WORK_ORDER.md`, `ASSET_MANIFEST.yml` |
| approved decisions | `docs/decisions/` — especially the 10-day cadence, visual workflow, repository-only canon, and result-vignette decisions |
| Notion-only reference binaries retained here | `docs/migrations/notion-reference-mockups/` |

## Structure migration

```text
Notion shared hub (other projects excluded)
└── 괴이기록국 · Home
    ├── 01 Direction · Planning       → decisions / current planning canon / master GDD
    ├── 02 Investigation · Cases      → master GDD content contract / M01-M04 flow
    ├── 03 Systems · Flow · Data      → M01-M04 flow / validation and QA contracts
    ├── 04 Visual · UX · Assets       → visual lock / asset manifest / retained mockups
    ├── 05 Production · Validation    → current handoff / status / audit records
    └── 06 Reference · Benchmark      → master GDD benchmark and source register
```

The former Notion work-control database had project filtering and task metadata, but no current implementation contract that is not already owned by the repository roadmap, handoff, decisions, and GitHub issue/PR history. It is represented by this migration receipt rather than recreated as a second task-system authority.

## Current work-product inventory and destination readback

`MIGRATED_CURRENT` means its still-valid substance was incorporated into the named repository owner. `DUPLICATE_ALREADY_REPOSITORY` means the repository had the product record before migration and is retained as the owner. `CONFLICT_SUPERSEDED` means only the provenance was retained because a newer user decision replaces it.

| Notion source | classification | repository destination / result |
| --- | --- | --- |
| [괴이기록국 (urban-legend)](https://app.notion.com/p/3c01b237eb1c811c9d5ec512acad4f92) | `MIGRATED_CURRENT` | project identity, evidence rules, and ownership moved to `AGENTS.md`, `docs/DOCUMENTATION_MAP.md`, and the master GDD source registry. |
| [괴이기록국 · Home](https://app.notion.com/p/3c41b237eb1c81dc9bdad72bf2d5978d) | `MIGRATED_CURRENT` | north star, core loop, governance, visual overview, and current-state reconciliation are owned by the master GDD and current canon documents. Historical status blocks remain non-authoritative. |
| [01 · Direction · Planning](https://app.notion.com/p/3c51b237eb1c81b18f60fbe650765158) | `MIGRATED_CURRENT` | user decisions are split into date-named decision documents and `docs/CURRENT_DECISION_OVERLAY.md`. |
| [01 · 프로젝트 전체 작업계획](https://app.notion.com/p/3c01b237eb1c8164a2e7ce98278d06fb) | `MIGRATED_CURRENT` | active work is now `docs/CURRENT_HANDOFF.md`, `MVP_ROADMAP.md`, GitHub Issues, and the master GDD implementation queue; the old database itself is not recreated. |
| [02 · Investigation · Cases · Narrative](https://app.notion.com/p/3c51b237eb1c81209490ca93bb2b1a34) | `MIGRATED_CURRENT` | project-case structure is consolidated into the master GDD content registry and `docs/M01_M04_VERTICAL_SLICE_FLOW.md`. |
| [07 · 월간 사건 · 서사 결정 기록](https://app.notion.com/p/3c11b237eb1c817eb9f1eca14243557c) | `PARTIAL / CONFLICT_SUPERSEDED` | durable case core (investigate → infer → rescue → recover → composite record), M01–M12 Slate, and result guardrails are in the master GDD. The month/2·3·4-week cadence and its numbers are superseded by the 10-day decision. |
| [10 · Content Budget · 월간 사건 제작 범위](https://app.notion.com/p/3c11b237eb1c816daf1cd88db749c90e) | `PARTIAL / CONFLICT_SUPERSEDED` | Signature 4 + Standard 8, layer reuse, and scope guardrails are in the master GDD. Its old 4-week cadence labels are not migrated as requirements. |
| [03 · Systems · Flow · Data](https://app.notion.com/p/3c51b237eb1c811a823ee01fb5e3f4f2) | `MIGRATED_CURRENT` | player promise, loops, data/evidence boundary, and M01/M04 flows are consolidated in the master GDD and current planning canon. |
| [09 · Vertical Slice · 플레이 검증 계약](https://app.notion.com/p/3c11b237eb1c81c291d8d45d2747451b) | `MIGRATED_CURRENT` | M04’s 30–45 minute purpose, player questions, fresh-human validation, and baseline boundary are owned by the master GDD and `docs/M01_M04_VERTICAL_SLICE_FLOW.md`. |
| [M04 Playable Flow v1](https://app.notion.com/p/3c21b237eb1c811c9fbfd947cf35e494) | `PARTIAL / CONFLICT_SUPERSEDED` | its investigation → deduction → rescue → recovery → result ordering and duration target are migrated. Its Week 2/3/4 timing is superseded. |
| [M04 Balance Simulation Contract v1](https://app.notion.com/p/3c21b237eb1c8140a73ecba7e7cfab93) | `CONFLICT_SUPERSEDED` | retained only as provenance. `0/15/30`, “forced Week 4”, and week-based scenarios must not be translated to days. The unresolved three-model choice is in GDD §07. |
| [M04 Thought-Path Playtest Contract](https://app.notion.com/p/3c21b237eb1c81d287d1c8746b0d6ef8) | `MIGRATED_CURRENT` | observable-evidence path, misconception signals, hint ladder, and thought-path evidence ceiling are preserved in master GDD validation requirements. |
| [M04 Validation Baseline Save Contract v1](https://app.notion.com/p/3c21b237eb1c817fbaecf979f8c5a454) | `MIGRATED_CURRENT` | isolated validation-save boundary and no-main-save-pollution guardrails are in master GDD validation requirements; actual M04 fixture is still `NOT_IMPLEMENTED`. |
| [M01·M02·M04 Human QA Execution Pack v1](https://app.notion.com/p/3c21b237eb1c8117adbce277d866fa46) | `MIGRATED_CURRENT` | E0/E1/E2 evidence separation, unexposed-player standard, observer questions, and `NOT_RUN` ceiling are preserved in the master GDD and QA packets. |
| [M04 Screen Contract](https://app.notion.com/p/3c21b237eb1c816da9f3f965309fe190) | `PARTIAL / CONFLICT_SUPERSEDED` | six-surface information hierarchy, 1280×720/1920×1080 requirement, and evidence-first character policy are in GDD §09–10. Old monthly screen labels are superseded. |
| [M04 Text Wireframes v1](https://app.notion.com/p/3c21b237eb1c81b1a9a9fc8025248e8f) | `PARTIAL / CONFLICT_SUPERSEDED` | safety-zone, hierarchy, and non-color status rules are migrated; old Week 2 header copy is not current. |
| [M04 Microcopy Pack v1](https://app.notion.com/p/3c21b237eb1c81cfbc19fd9af1526418) | `PARTIAL / CONFLICT_SUPERSEDED` | observation/competing-hypothesis/rescue/telegraph/result voice is preserved as a reference. Every old weekly timing line requires re-authoring under the 10-day contract before runtime use. |
| [11 · First Session · 온보딩 경험 계약](https://app.notion.com/p/3c11b237eb1c81c89490c01a3534818b) | `PARTIAL / CONFLICT_SUPERSEDED` | M01 opening record, observe→hypothesize→apply teaching order, no-grade result, and first-session questions are migrated into the master GDD. Its 1–4-week tutorial timing is not current. |
| [04 · Visual · UX · Assets](https://app.notion.com/p/3c51b237eb1c81aeabf2f94a5146aa0f) | `MIGRATED_CURRENT` | current visual board/reference ledger is represented by visual lock docs, `ASSET_MANIFEST.yml`, candidate records, and the retained reference mockups below. |
| [02 · 비주얼 바이블](https://app.notion.com/p/3c01b237eb1c816181c0cc81bb3d3b3d) | `MIGRATED_CURRENT` | environment/event/evidence priority, restrained character exposure, Cut-in rule, and dossier presentation grammar are owned by the visual lock packet. |
| [Visualization Needs · M04](https://app.notion.com/p/3c11b237eb1c81829c31fb4dc348321f) | `PARTIAL / WORKFLOW_SUPERSEDED` | P0 screen needs and reusable layers are migrated. Its old “ask before generation” process is replaced by `D-2026-08-28-VISUAL-CANDIDATE-GENERATION-LOCK-ONLY-APPROVAL.md`. |
| [M04 Visual Reference Decision](https://app.notion.com/p/3c21b237eb1c81a699a1ce6b384f958e) | `MIGRATED_CURRENT` | Korean urban occult dossier composition, soft-anime noir art treatment, anti-copy and readability rules are owned by the visual lock packet. |
| [Current Visual Work Order](https://app.notion.com/p/3c21b237eb1c8174b9acc3ca7779ac8b) | `MIGRATED_CURRENT` | current consumer-first visual sequence and character-exposure limits are owned by `docs/CURRENT_VISUAL_WORK_ORDER.md`. |
| [M01-M04 Vertical Slice Validation Flow](https://app.notion.com/p/3c21b237eb1c81f8a090d6379c009840) | `MIGRATED_CURRENT` | shared investigation/deduction/recovery validation grammar is owned by the master GDD, current visual work order, and M01/M04 flow document. |
| [05 · Production · Validation](https://app.notion.com/p/3c51b237eb1c815cb7b5d466fd2fdd49) | `MIGRATED_CURRENT` | stage gate and evidence boundary are owned by current handoff/status plus audit documents. |
| [06 · Production · Handoff](https://app.notion.com/p/3c01b237eb1c81c0b70ffe96425a0e66) | `PARTIAL / CONFLICT_SUPERSEDED` | latest-main identity, no-runtime-mutation boundary, current blockers, and implementation gate are re-established in current handoff and GDD. Earlier monthly handoffs are historical only. |
| [Planning Completion Candidate Packet](https://app.notion.com/p/3c21b237eb1c81b6a5e4c8b2adb60527) | `PARTIAL / WORKFLOW_SUPERSEDED` | retained in the GDD as an implementation-contract boundary. The old “image generation blocked” process is replaced by the current candidate workflow. |
| [Planning Closure Gap Matrix](https://app.notion.com/p/3c21b237eb1c8174892fd10a0948a61c) | `PARTIAL / RECOMPUTED` | its separation of planning, human evidence, runtime, and visual asset promotion is retained; current closure is recomputed in the GDD stage table. |
| [Final Whole-Plan Adversarial Review](https://app.notion.com/p/3c21b237eb1c81ed854be8e175d3618c) | `HISTORICAL_RETAINED` | prior five-loop findings are preserved as historical audit evidence. Current project changes receive their own fresh review. |
| [06 · Reference · Benchmark](https://app.notion.com/p/3c51b237eb1c8198bf1ce7f0c6366a88) and [benchmark library](https://app.notion.com/p/3c01b237eb1c8150858ff9e7b2516d90) | `MIGRATED_CURRENT` | relevant benchmark decisions and primary-source links are in master GDD §13; third-party references are never asset approvals. |

## Retained Notion-only visual reference binaries

Seven current reference files were available only as Notion attachments. They were copied verbatim into `docs/migrations/notion-reference-mockups/` and are registered by hash in that folder’s `README.md`.

- They are `REFERENCE_MOCKUP` or `USER_APPROVED_VISUAL_CANDIDATE` only.
- They are **not** runtime art, not a product-asset approval, not a Godot import instruction, and not Human QA evidence.
- The image-internal footer that says image generation needs a prior approval is superseded by the current visual-candidate workflow; the preserved source image is not edited.

Thirteen additional visual attachments had a matching filename already present in the repository’s candidate/release records. They were not duplicated. Filename matching is an inventory result, not proof of identical bytes or a promotion decision.

## Migration findings that changed the current record

1. The Notion material repeatedly used a 4-week/7-day cadence and numeric `0/15/30` risk. It is now explicitly `SUPERSEDED`, never a day mapping.
2. Current visual direction was preserved, but Notion’s former per-image generation approval process was superseded by the user’s `generate → inspect → LOCK/REVISE/REJECT` workflow.
3. Earlier production pages contained older main/PR pointers and statements that predated the current 10-day and narrative-result decisions. Current handoff is re-owned by the repository.
4. Validation intent is retained, while its Human/new-player/accessibility evidence remains `NOT_RUN`; no migration is treated as a gameplay pass.

## Completion check

- [x] All current project-domain roots fresh-read.
- [x] Current child work products relevant to direction, systems, visuals, production, validation, and benchmarks fresh-read.
- [x] Each item classified as current, partial, superseded/conflict, or historical.
- [x] Notion-only current reference attachments copied and hash-registered.
- [x] New repository destinations and exclusions recorded.
- [x] No Notion write or destructive action performed.

Future project changes must update repository owners only. If a legacy Notion page is consulted, it is discovery/provenance evidence and must be reclassified before it affects current work.
