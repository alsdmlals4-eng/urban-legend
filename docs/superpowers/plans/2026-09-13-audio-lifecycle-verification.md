# Audio lifecycle verification plan

Goal: distinguish persistent scene-owned audio leaks from shutdown before asynchronous audio retirement; preserve audible playback and pause behavior.
Authority: approved continuation, CURRENT_HANDOFF recovery active-clock successor. No episode/save/art/schema changes. Base9.4.4 retained; other PRs and user imports read-only.

Preflight: actual recovery_active_scene_test with --headless --verbose reproduces AudioStreamWAV / AudioStreamPlaybackWAV pairs at exit after four process frames. Current LogGuide and battle own ordinary AudioStreamPlayers. Godot4.7 official AudioStreamPlayerInternal source pauses on tree exit and stops playback on deletion; audio is not mixed on every process frame per official AudioStreamPlayer documentation.

Sources: https://docs.godotengine.org/en/stable/classes/class_audiostreamplayer.html ; https://raw.githubusercontent.com/godotengine/godot/4.7-stable/scene/audio/audio_stream_player_internal.cpp . ADOPT engine lifecycle/weak-reference evidence; do not copy engine internals. No useful game-mechanic benchmark applies to a test teardown timing issue.

Alternatives: mute/skip audio REJECT (hides real behavior); add production stop/null hooks only if persistent owner retention is proven DEFER; observe weak references and bound asynchronous retirement in test teardown SELECT if refs retire without production changes. Fixed arbitrary sleeps alone are insufficient evidence.

- [x] Capture weakrefs to actual audio streams/playbacks before scene disposal, reproduce premature completion, observe bounded release after disposal without altering runtime.
- [x] Add test-only release probe, timeout failures for retained resources, and a retained-reference negative test. No production cleanup mutation.
- [x] Reproduced recovery/minigame and M04 manual teardown consumers: seven tests, two full loops PASS on 2026-09-14. Vulkan recovery active-scene fixture PASS; Python490 PASS. This is not final listening/device approval.
- [ ] Review twice, record exact evidence and unresolved warnings in current handoff, commit/push/readback owned paths. No release/Human/main completion claim.

Rollback: revert bounded test/helper/doc commit. No user save or asset modification.

2026-09-14 scope extension: M04 manual integration reproduced two WAV/playback objects after three process frames. The same existing weak-reference probe confirms retirement within its one-second deadline. Negative retained-reference test repeats three times and would fail if the observer silently skipped live streams. No generic/global leak-fix claim; future consumers require their own observed ownership and tests.
