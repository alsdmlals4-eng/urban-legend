# 2026-08-28 · Notion migration and master GDD adversarial review

> Status: `REMOTE_EXACT_HEAD_RECHECK_PENDING`
>
> Scope: repository-only canon transition, Notion current-work migration, 10-day cadence documentation, reference-asset boundary, and master GDD PDF. Runtime code/data/Scene behavior is out of scope and remains unchanged.

## Review basis

- latest completed project main used as the planning baseline: `11876dd851a614e9475033c38486b2085894126c`;
- current Notion project-domain roots and listed child work products fresh-read without any Notion write;
- user-approved 10-day/half-day cadence, sequential M04 result-vignettes, visual lock, and repository-only policy;
- actual current planning docs, source JSON, candidate/asset records, and rendered PDF.

## Five full adversarial loops

| loop | failure assumption | check | finding / correction | result |
| --- | --- | --- | --- | --- |
| 1 | The repository secretly still treats Notion as a current post-merge or human owner. | Searched current entrypoint docs, adapter, registry, and authority tests for the old Notion+repository values. | None in current owners after migration. The Notion role is explicitly historical/read-only. | `PASS` |
| 2 | Old 2/3/4-week rules or `0/15/30`, `0/+4/+8` could be mistaken for 10-day requirements. | Searched all current GDD, decision, handoff, flow, and migration owners. | Remaining matches are all explicitly `SUPERSEDED`/historical provenance. No day mapping found. | `PASS` |
| 3 | Migrated reference mockups could accidentally become runtime/product assets. | Recomputed seven binary hashes, compared them to the retention register, and checked the product manifest for migration-path promotion. | Seven files and seven registered hashes; no manifest promotion; reference-only boundary is explicit. | `PASS` |
| 4 | The GDD could be logically correct but unreadable after PDF generation. | Rendered every PDF page at 144 dpi and inspected the two contact sheets plus pages 01, 11, and 12. | Initial cover used pale text on white; corrected cover contrast, regenerated, and re-rendered all 12 pages. No clipping, missing page, or visible overlap remained. | `PASS_AFTER_CORRECTION` |
| 5 | Stale automated expectations, generated views, or document hygiene could conflict with the approved repository-only policy. | Ran the full test discovery suite. Investigated three failures back to exact legacy authority assertions, updated only the stale expectations, ran focused tests, then reran the whole suite. A staged `git diff --check` also found and removed three GDD trailing spaces. Exact-HEAD verification then exposed six stale deterministic operating views, because their hash test reads the committed adapter blob. Regenerated them with the pinned Base artifact generator. | At exact head `ca8b7f7aee14d742e67a305b046a1b875fa2bdc0`, the local generator check passed and all `461` tests passed. PR #335 then exposed that CI still pinned Base `19d936a3`, whose generator conflicts with the current project regression hash rule. The workflow pin is advanced to fresh Base `af870522`, which generates the five views and passes both the contract check and all `461` tests. | `PASS_AFTER_CORRECTION / REMOTE_RECHECK_PENDING` |

## Evidence ceiling

- `VERIFIED`: migration inventory, seven retained source binaries/hashes, structured JSON parsing, current-document link tests, PDF page count/text/render checks, and 461 automated tests.
- `NOT_RUN`: Godot runtime for the new 10-day consumer, target-resolution gameplay compositing, fresh-human/new-player/accessibility evidence, and any production asset promotion caused by this migration. None are inferred from documentation or PDF output.

## Incident / solution / lesson

- **Incident:** Legacy tests still encoded the former Notion+repository workspace model after the user changed the project to repository-only.
- **Solution:** Trace each failure to the stale expected value; update only the authority assertions to match the current adapter, registry, and project decision; then regenerate all adapter-derived views with fresh Base `af870522` and advance the receiving CI to that compatible, remote-verified generator.
- **Lesson:** Workspace-owner transitions require the metadata owner, its regression expectations, every generated operating view, and the receiving CI's pinned generator to move together. This is a project-operational lesson tied to an explicit user workflow choice, so `NO_BASE_PROMOTION`.

## Final disposition

No remaining local blocking finding was found within this documentation/migration scope. Remote exact-HEAD checks for the corrected generated views are required before `CLEAN_REVIEW_EXIT`. The only material product decision still open is the early-versus-regular numeric balance model. This review does not authorize production mutations.
