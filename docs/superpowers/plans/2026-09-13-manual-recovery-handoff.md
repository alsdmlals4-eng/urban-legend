# Authored manual to recovery reference

Approved continuation: plan → test → connected implementation → review. Current bridge copies pages but does not consume saved draft_slots; recovery drawer renders only titles. This loses the actual player-authored interpretation between phases.

REUSE existing GameState draft filtering, episode segments and recovery quick-open drawer. ADAPT the prior Phasmophobia Chronicle recorded-information-retrieval benchmark (official page reread https://www.kineticgames.co.uk/news/phasmophobia-chronicle-v013). REJECT auto-validating filled slots; DEFER a new full editor in recovery because its input/timer consequences are outside this slice. Existing content/answers/clock and save version stay unchanged.

1. RED integration: earn one existing M04 source as fixture, persist an alternate candidate, reload, enter battle, press manual quick-open; expect selected sentence visible, alternate unselected candidate absent, unfinished slot explicit.
2. Bridge renders page segments from existing saved/known/earned draft slots into a read-only view, only pages with a valid earned selection. Do not add them to active_rule_ids.
3. Drawer displays these lines under a player-draft/not-verified heading with BBCode-safe text. No new asset/state owner.
4. Run integration, prior overlay/manual/GUT regressions. Preserve distinction between reference availability and mechanical rescue/recovery evaluation integration. Update handoff.

Files: scripts/ui/canon_v2_runtime_bridge.gd; scripts/ui/canon_v2_operation_overlay.gd; tests/recovery/authored_manual_handoff_test.gd. Rollback only this commit. No main merge or unrelated PR writes. This slice is not normal-input investigation completion or Human QA.
