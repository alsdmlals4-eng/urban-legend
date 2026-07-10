# MVP Status Audit

## Audit Scope

Date: 2026-07-10
Baseline: `MVP-020` / `Ver 2.0`
Tracking issue: [#27](https://github.com/alsdmlals4-eng/urban-legend/issues/27). Issue #20 is an old duplicate and is not the MVP-020 reference.

The audit compared the two episode JSON files, `GameState`, main scene flow, roadmap, tests, and shared documentation. No code change is required for this retrospective.

## Verified Implementation Baseline

| Area | Evidence | Status |
|---|---|---|
| Two cases | `episode_001_afterlife_station.json`, `episode_002_red_umbrella_alley.json` | Keep as the demo sample set |
| Shared state | `scripts/core/game_state.gd` manages clues, recovery, trust, reports, and saves | Keep; avoid a parallel state manager |
| Recovery/report loop | Recovery result, unlocks, and `completed_case_reports` are data-driven | Keep; improve presentation in MVP-023/026 |
| Agent trust | Selected agents only, bounded partner trust, one-time events | Keep; avoid romance framing |
| Red-umbrella loop | Dialogue, investigation methods, minigame, recovery, result, and DB are connected | Keep; do not add a third episode |

## MVP-015~019 Retrospective

| MVP | Keep | Reduce or avoid | Hand off |
|---|---|---|---|
| 015 | Preparation and second-case carryover | Dense explanatory text | MVP-021 preparation UI |
| 016 | Partner trust and selected-agent reactions | Romance-like wording and repeated reactions | MVP-024 feedback design |
| 017 | Case report as the outcome summary | Result-screen information density | MVP-023 report layout |
| 018 | Completed-case report snapshots and DB re-check | Premature search/filter expansion | MVP-023 readable browsing first |
| 019 | Two-case, data-driven full loop | A third episode or episode-specific logic | MVP-022, 026, and 029 polish |

## Rule Diet

Keep these non-negotiable rules in `AGENTS.md` and the shared workflow documents:

- Godot 4.7 stable with GDScript.
- ChatGPT plans, benchmarks, drafts Issues/Goals, and owns local HTML dashboards; Codex edits and validates project files.
- Local HTML dashboard delivery is the default. Repository HTML is historical unless a task explicitly requests a repository update.
- Anomalies are investigated, stabilized, sealed, or recovered, not killed.
- Agent trust is investigative-partner trust.
- Do not overwrite user changes.

Reduce repeated task prose by referring to `AGENTS.md` and `docs/MVP_WORKFLOW_CHECKLIST.md` for shared process. A Goal should contain only its objective, scope, exclusions, affected files, completion checks, and task-specific risks. Use one implementation owner unless independent review materially improves confidence.

## Risks and Follow-up

- Main, preparation, investigation, report, and recovery screens have accumulated text and need UI-focused readability work.
- The two-case loop needs manual mobile-vertical and save/continue QA before a demo candidate.
- No current code conflict was found. The remaining work is presentation and reliability, not more episode content.

## Base Promotion

Candidate: concise Goal structure plus a five-MVP retrospective checkpoint.
Project-only: anomaly-recovery terminology, partner-trust framing, and the two-case content limit.
