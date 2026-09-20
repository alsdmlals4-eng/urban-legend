# Headless helper parity correction

Goal: remove the existing full-suite blocker without downgrading the live runtime helper or enabling additional services.
Scope: helper launch guard, its obsolete wrapper-shaped test, and actual launch verification. Gameplay and editor helper implementation remain intact.

Evidence: full Python discovery 490 tests, one pre-existing failure. Current helper is monolithic and matches main; stale test requires the predecessor wrapper/impl split. Editor plugin already disables headless unless GODOT_AI_ALLOW_HEADLESS is truthy. Actual headless game currently registers capture/logger anyway.

Alternatives: restore predecessor wrapper REJECT (would replace newer screenshot/liveness code); delete test REJECT (loses genuine launch boundary); preserve current helper and add matching guard ADAPT. Reuse existing settings.truthy and command-line semantics. Godot official command-line tutorial confirms --headless is display-driver headless plus Dummy audio: https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html (read 2026-09-13). No new framework, API, paid service, or configuration write.

Execution: first run new SceneTree autoload registration test without opt-in (expect RED); guard _ready before logger/capture registration and disable processing; replace obsolete structure assertions with launch-policy matrix plus actual consumer launch test; run absent/false/true opt-in in fresh processes, visible-window launch, complete Python suite, CCTV/flow/GUT. Keep legacy impl file untouched because removal is separate consumer/provenance work. Commit bounded change after verification. Rollback is commit revert; no saves involved.
