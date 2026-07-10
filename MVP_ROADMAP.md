# MVP Roadmap

## Current Baseline

The implementation and documents are aligned through `MVP-020` (`Ver 2.0`). The authoritative tracking issue is [Issue #27](https://github.com/alsdmlals4-eng/urban-legend/issues/27); GitHub Issue #20 is an old duplicate and must not be used as the MVP-020 source.

The project now has two sample cases: `저승역` and `비 오는 골목의 빨간 우산`. They are enough to validate the core loop. Do not add a third case before the demo review.

## Completed Foundation

| Range | Result kept for later work |
|---|---|
| MVP-001~009 | Godot scenes, data-driven dialogue/investigation, clues, minigames, recovery, flags, and save/load |
| MVP-010~014 | Agent formation, investigation methods, anomaly state, equipment/records, and preparation flow |
| MVP-015 | Second-case preparation connection and carryover of selected agents, records, and equipment |
| MVP-016 | Selected-agent-only partner trust and one-time support events |
| MVP-017 | Case report and partner-trust settlement in the result flow |
| MVP-018 | Completed-case report snapshots and Bureau DB re-check |
| MVP-019 | Full red-umbrella loop from preparation to recovery, report, and DB |
| MVP-020 | Five-MVP retrospective, rule diet, and system/UI transition criteria |

## Direction After Two Cases

Keep the common loop: preparation → formation → dialogue → investigation → event/minigame → anomaly stabilization and recovery → report → Bureau DB.

Improve clarity, usability, and reliability around that loop before expanding content. `battle_scene` remains an anomaly stabilization/recovery phase, not a traditional combat system. Agent trust remains investigative-partner trust, not romance affinity.

## Next Roadmap

| MVP | Focus | Outcome |
|---:|---|---|
| 021 | Main and case-preparation UI | Clearer start, case, agent, and equipment decisions |
| 022 | Investigation UI and clue/hint tracking | Easier point selection, method comparison, and evidence progress |
| 023 | Case report and Bureau DB UI | Readable reports and useful completed-case browsing without overbuilt search |
| 024 | Agent-system development | Stronger selected-agent reactions and trust feedback |
| 025 | Equipment and record development | Meaningful investigation/recovery reference use |
| 026 | Stabilization/recovery UI | Clear anomaly state, support, and recovery decisions |
| 027 | Save/load stabilization | Reliable continuation, restart, and compatibility checks |
| 028 | Mobile/accessibility/readability | Vertical layout, text legibility, and input accessibility |
| 029 | Two-case integrated demo QA | Full-flow regression and player-facing issue list |
| 030 | Demo candidate build and materials | Stable candidate build, concise introduction, and final documentation |

## MVP-021 Brief

Redesign only the main menu and preparation UI first. The player should immediately understand the selected case, 2–3 assigned agents, equipped records/tools, save status, and the next action. Do not change save data or add a new gameplay system in MVP-021.
