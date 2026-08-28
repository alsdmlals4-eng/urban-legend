# 2026-08-28 · Master GDD core-system coverage adversarial review

> Status: `CLEAN_REVIEW_EXIT`
>
> Scope: correction of the human/AI-facing Master GDD and its project-canon routes. No runtime code, Scene, data, asset, balance value, or production-asset promotion is authorized by this review.

## Review basis

- latest completed project main: `72c20182172ea6ed30a9d6f20fb147f034911395`;
- user-approved product rule: one main case in a 10-day cycle with morning/afternoon slots; Day 1–9 early resolution and Day 10 regular resolution;
- fresh-read current planning canon, decision overlay, handoff, Master GDD, historical detailed design, actual GDScript/Scene/JSON, open PR inventory, and automated test sources;
- Godot 4.7.2 import preflight followed by `test_three_case_campaign_manual_qa.gd`, `mvp043_investigation_ui_test.gd`, and `mvp043_recovery_loop_test.gd`;
- official Godot file-path and save documentation, used only to check the next save/round-trip contract boundary, not to invent project behavior.

## Five full adversarial loops

| loop | failure assumption | evidence checked | finding / correction | result |
| --- | --- | --- | --- | --- |
| 1 | The GDD only lists systems, so a reader cannot explain the player experience. | Master GDD against the user finding and M01/M04 scene/data flow. | Added dedicated schedule, investigation, keyword/manual, and rescue/recovery sections. Each now states player question, action, trade-off, immediate feedback, next consequence, guardrails, and current evidence state. | `PASS_AFTER_CORRECTION` |
| 2 | The approved 10-day rule is silently presented as live behavior. | `campaign_state.gd`, preparation flow, and the three-case QA source/runtime. | The code saves 10 days and two slots but still permits M01, M04, and M07 in the same demo. Canon, overlay, handoff, Master GDD, JSON, and status routes now mark one-case enforcement `NOT_IMPLEMENTED`. | `PASS_AFTER_CORRECTION` |
| 3 | The keyword design is claimed as a playable feature because some data field names exist. | M01 Canon v2, M04 JSON, bridge fields, and live Scene consumers. | M01 candidate arrays are empty, M04 has no composition schema, and no player-facing pool/slot consumer exists. The system is now explicitly `APPROVED_DESIGN / NOT_IMPLEMENTED`; existing clue choice and hypothesis UI are not relabelled as keywords. | `PASS_AFTER_CORRECTION` |
| 4 | Recovery is described as combat or auto-solved by allies. | battle scene, recovery tests, M04 effects, and 136-pass campaign runtime QA. | Documented and retained `telegraph → hypothesis → evidence → response`, wrong-response learning, stability threshold, and rescue/resonance separation. No HP-depletion or answer-recommender claim remains. | `PASS` |
| 5 | Documentation and runtime evidence are confused, or a raw headless failure is treated as product proof. | 13-page regenerated PDF, 465 Python tests, direct Godot script run, fresh Godot editor-import preflight, then three runtime tests. | Direct scripts before import fail on missing global-class/import cache although sources exist. After the documented import preflight: 136/0 campaign QA, investigation PASS, recovery PASS. Added this as a test-environment boundary, not a production pass. | `PASS_AFTER_CORRECTION` |

## Evidence ceiling

- `VERIFIED`: core-system text coverage, canon/overlay/handoff synchronization, source/data inspection, one-case mismatch, keyword non-consumer, 13-page PDF render inspection, 465 Python tests, and the named Godot tests after import preflight.
- `NOT_RUN`: human/new-player comprehension, target-resolution usability, accessibility, early-versus-regular numeric balance, Day-10/player-facing timing UI and save/result behavior, keyword-composition vertical slice, M04 sequential-result Scene, audio, and production asset promotion.

## External feasibility check

- **ADOPT:** the next timing/keyword implementation contract must declare the persistent fields and prove a save/load round trip; Godot's official saving guidance similarly requires identifying persistent state before serialization and restoration.
- **ADAPT:** retain the project's existing additive save strategy rather than replacing it with a new generic persistence framework.
- **REJECT:** treating `res://` editor/import artifacts as player-save storage or treating an unimported worktree script invocation as runtime success/failure evidence. Godot documents `res://` as project resources and `user://` as writable persistent user data.
- **Remaining uncertainty:** neither the official guidance nor code inspection chooses the early/regular numerical model or proves player comprehension.

Sources: <https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html>, <https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html>.

## Incident / solution / lesson

- **Incident:** the current Master GDD named core systems but did not explain the schedule → investigation → keyword/manual → rescue/recovery experience. It also left an implemention-status ambiguity around one-case cadence and keyword composition.
- **Solution:** compare product decisions, active canon, actual code/data/Scene consumers, and runtime tests; promote the player flow into four dedicated current sections; and label every unimplemented or conflicting boundary rather than filling it with assumptions.
- **Lesson:** a game GDD must make each named core system traceable from player question through choice and feedback to its actual consumer and evidence ceiling. This correction is tied to this project's cadence, manual, and recovery grammar, so `NO_BASE_PROMOTION`; Base already has the broader canonical-freshness rule.

## Final disposition

No new blocking finding remains within this documentation-only scope. The immediate next product work is still a single unified implementation contract for the one-case calendar and its Day-1–9/Day-10 player surface; keyword composition follows as a separate vertical slice. This review does not authorize either implementation.
