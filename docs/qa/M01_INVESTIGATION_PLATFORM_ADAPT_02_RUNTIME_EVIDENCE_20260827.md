# M01 Investigation Platform Adapt 02 — Runtime Evidence

## Scope and identity

- Issue: `#286`
- Baseline: `c9fa167387ee6a3f3e95a975b0124be1e37b0ce0`
- Consumer: `investigation_scene.tscn -> ArtLayer/Background` and shared `LocationPreview`
- Candidate SHA-256: `4e21b9f14f2889e11bcff1872dc5f7cf07d020d24617e2b6c948a7683f32d4be`
- Exclusions: scene wiring, UI hierarchy, game rules, save data, episode data, and Human QA.

## Result

| Check | 1280×720 | 1920×1080 |
|---|---|---|
| Candidate image loaded through both existing texture consumers | PASS | PASS |
| Nonblank runtime output / possible clipping | PASS / none | PASS / none |
| Hera diagnostics | 0 errors, 0 warnings | 0 errors, 0 warnings |
| Human usability or player experience | NOT_RUN | NOT_RUN |

The candidate improves the desired soft anime-noir, ink/paper station treatment while leaving an open platform read in the small preview. It is intentionally not evidence that a player understands the scene, the investigation UI, or the story.

## Incident → solution → lesson

**Incident:** the first M01 platform candidate was stylistically closer than the existing photoreal source but its large central pillar and blank sign displaced the only compact environmental read (`LocationPreview`).

**Solution:** retained the existing consumer and route, generated one bounded background-only correction, validated it in both actual consumers at both required resolutions, and promoted only the exact tested bytes.

**Project lesson:** for a shared Investigation background, thumbnail/preview composition is an acceptance condition equal to full-background mood. Do not make a separate location-card asset merely to compensate for a background candidate that fails the shared preview.

**Base promotion assessment:** `NO_NEW_REUSE_LEARNING`. The current Base visual identity and actual-consumer contracts already require exact consumer validation, candidate/promotion separation, and no speculative extra asset. This instance adds a project-specific layout finding rather than a reusable Base rule.

**Validation incident:** the current project main already enabled `res://addons/hera_agent_godot/plugin.cfg` at commit `67978e5`, but `tests/test_godot_live_editor_adoption.py` still allowed only the two-plugin predecessor list. The authority-contract test therefore failed before any M01 implementation assertion. The smallest correction adds the already-installed Hera plugin to that test's exact expected set; it does not alter Godot configuration or plugin behavior.

**Validation boundary:** the focused Godot asset and contract tests passed locally. The repository-wide Bash regression runner could not start on this Windows host because its checked-in CRLF shell header is rejected by Bash (`pipefail\r`); therefore the full regression suite remains `BLOCKED_UNVERIFIED` locally and is required from PR CI at the exact reviewed head.

## Re-entry triggers

- Any `ArtLayer/Background` or `LocationPreview` layout/scaling change.
- Human QA reports that the platform remains too dark or visually ambiguous.
- Release-rights review.
