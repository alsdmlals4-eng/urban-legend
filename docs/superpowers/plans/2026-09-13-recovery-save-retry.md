# Recovery save retry — approved bounded implementation plan

Goal: retain the terminal outcome in memory when persistence is refused, prevent further recovery actions, and allow retry without repeating settlement/rewards.

Approval: user approved the preceding plan on 2026-09-13. No save schema/version, rewards, case rules or art changes.

Files: scripts/core/game_state.gd (propagate existing persistence result); scripts/scenes/battle_scene.gd (terminal lock, retry dialog, successful transition); tests/recovery/recovery_save_retry_test.gd (real router refusal / retry); docs/CURRENT_HANDOFF.md (evidence).

1. RED: exercise real ValidationSession refusal against actual GameState/battle scene, assert no result transition, visible retry, prior disk bytes unchanged.
2. GREEN: return bool from save_recovery_result; settle once; retry only save_game; block background input and show explicit unsaved-session warning.
3. Verify failure/success/approved withdrawal, repeated refusal, Escape, original result/rescue after successful retry and reload. Run existing recovery and GUT regressions.
4. Review full changed behavior twice; preserve user import/uid changes; update existing handoff with evidence ceiling. No main merge without exact-head gates.

Preflight: existing M01 transaction and ValidationSession save routing already return bool; M04 generic writer does not use M01's validator. ADAPT bool propagation and retained-memory retry. DEFER wholesale shared transaction rewrite (cross-case migration risk). REJECT unconditional result navigation after failed save (false persistence). Godot FileAccess official docs https://docs.godotengine.org/en/stable/classes/class_fileaccess.html confirm write-open truncation and get_error/flush behavior; this slice does not claim crash-safe generic storage.

Evidence boundary: test uses deliberate invalid validation-session routing to refuse persistence. It proves consumer error handling, not full-disk, power loss, hardware durability, normal-play completion or human UX. Old scheduling/AKA context is compatibility history; current user daily/case/Lume direction wins.

Rollback: revert only this slice's commit; no user file deletion or save downgrade.
