# CCTV rain-frame execution implementation plan

**Goal:** Connect M04's existing third-rain-after observation to the player's actual capture input, rather than survival by waiting.
**Architecture:** A small Control consumer uses the existing minigame host, completion signals, manual pause, result and save pipeline. It never reads the player's draft or changes world truth.
**Tech stack:** Godot 4.7, GDScript, existing episode JSON.
**Spec:** `docs/superpowers/specs/2026-09-10-daily-case-structure-design.md`, sections 11.5–11.7; M04 third-rain rewind pattern and puddle observation.

## Constraints and comparison

Preserve IDs, success/failure effects, one-attempt persistence, existing approved assets and M01. No new save version. Native text/button instrumentation is functional UI, not final CCTV illustration or audio production.

Existing rain_dodge: unrelated movement and automatic elapsed-time success; REJECT for this consumer, retain for compatibility. Existing rhythm circle: reuse signal/config contract, REJECT radius judgment unrelated to the observation. Dedicated three-cue capture: ADAPT existing host; choose because same world/time yields same result regardless of written hypothesis.

Benchmark preflight VERIFIED: [Outer Wilds developer](https://www.mobiusdigitalgames.com/outer-wilds.html) describes time-dependent locations and testing environmental hazards; ADAPT observation-to-action, REJECT its global time-loop. [Phasmophobia Chronicle developer](https://www.kineticgames.co.uk/news/phasmophobia-chronicle-v013) describes recording video and journal playback; ADAPT explicit capture and retained observation, do not copy its rewards or media quotas. Sources read 2026-09-13. These are public behavior evidence, not private source code.

## Execution

- [ ] Add `tests/recovery/rain_frame_sync_test.gd`: instantiate the actual consumer selected from M04 via the host. Expect capture action support (RED against current dodge). Check literal times 0.2, 2.5, 3.2 seconds: first and third cue fail, after third succeeds. Waiting 12 seconds fails. Pause blocks both time and capture; repeated completion has no effect.
- [ ] Add `scripts/minigames/rain_frame_sync_game.gd`: `configure(Dictionary,bool)`, `set_input_locked(bool)`, `_capture_frame()` and existing `completed/status_changed` signals. Start is explicit; cue cycle 4 seconds, first/second/third at [0,1),[1,2),[2,3), clear interval [3,4). One valid capture succeeds; 3 mistakes or 12 active seconds fails. One equipment protection absorbs one invalid capture, not a correct answer. Store timestamp/observed cue in existing result details.
- [ ] Route `rain_frame_sync` in `scripts/scenes/minigame_scene.gd`; revise M04 minigame operation copy/type only. No rule/candidate/reward alterations.
- [ ] Update actual investigation/manual flow test to exercise capture rather than obsolete umbrella movement; verify explicit resume/input release and result return. Run legacy minigame pipeline/controls, new timing test, actual flow, save retry, GUT and contract checks.
- [ ] Render 1280x720, inspect legibility/bounds, fix demonstrated problems. Two review loops: rule/edge boundaries, then complete host/save/pause regression. Update current handoff and commit exact owned files; push and read back exact remote branch. Main/other PRs remain protected.

Rollback: coherent commit revert restores original type/consumer; existing result dictionaries remain readable. Remaining final-art/audio/balance/human evidence are not represented as completed by functional tests.
