# Manual observation comparison — plan and improvement loop

User clarification: loop means comparable-game research → concrete project design → connected implementation → play/test review → next bottleneck, not repeated isolated bug fixes. Existing hidden-rule investigation and field survival remain core. Schedule/automatic answers/new art are excluded.

## Current-state / benchmark preflight

- Project: investigation_scene filters earned candidate IDs but supplies only source titles to workbench. The original observed clue description is already in episode clues; reuse it instead of authoring another truth source.
- Phasmophobia Chronicle (developer): journal can replay recorded sounds and separates unique/duplicate media. ADAPT in-place evidence review; REJECT importing its rewards/count quotas. https://www.kineticgames.co.uk/news/phasmophobia-chronicle-v013
- Outer Wilds (developer): exploration of dangerous changing environments uses tools to test hazards and decipher information. ADAPT observation leading to action; REJECT importing a time-loop/calendar. https://www.mobiusdigitalgames.com/outer-wilds.html
- Expelled! (developer): characters remember observations/actions and knowledge has consequences. ADAPT preserving meaning across phases; REJECT importing its one-day timer/accusation objective. https://www.inklestudios.com/expelled/

These are public developer descriptions, not hands-on play or private-code reverse engineering. Alternative A retain title-only UI: reject because it leaves comparison friction. B show every record/answer verdict: reject information leakage and core conflict. C show only earned, page-relevant original records inside existing scrollable dossier: adopt.

## Concrete slice

1. Update M04 integration test to require earned original observation visibility, unearned descriptions absent, draft placement retained and guide Lume. Run RED.
2. investigation_scene maps source_record_id/title/description from existing earned clues into candidate view model. No state schema addition.
3. workbench deduplicates page-relevant records and renders them under the existing deduction text in its scrollable column, explicitly separating original observation from draft interpretation. Never generates a correctness verdict.
4. Test original sources stay visible after draft placement and no new draft/report is created by reading. Run M04 contract/integration and GUT regression; update current handoff.

Files: scripts/scenes/investigation_scene.gd; scripts/ui/manual_deduction_workbench.gd; tests/m04/m04_manual_workbench_integration_test.gd. Preserve current dossier layout/assets. Fix stale Aka text in this active consumer, no approved art replacement.

Next loop: trace actual player input that earns these observations, then draft → rescue/recovery application → observed contradiction/outcome. Do not equate fixture-earned clue integration with normal-play E2E. Rollback this slice only, no content/save migration.
