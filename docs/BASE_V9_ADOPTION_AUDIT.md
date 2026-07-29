# urban-legend Base v9 Adoption Audit

## Scope and decision

`OPERATING_SYSTEM_ONLY`. This Draft PR updates Base-v9 adoption metadata and
validation contracts only. It does not modify GDScript, Scene, game data, assets,
save data, or player-facing game rules.

The Base lock is `v9.0.0` at `585a53a25be1b04c543196f5901551deb49c7691`.
Common Skill bodies remain in Base; the project keeps only a Base lock, Registry
hash, snapshot hash, and its project-specific Skill Registry.

## Audit result

| Area | Result | Evidence / next action |
| --- | --- | --- |
| Base reference | `MIGRATION_REQUIRED` | Existing active adapter points to the prior `c987647d...` line; `skills/BASE_V9_ADAPTER.json` is the v9 migration authority. |
| Project-local Skills | `KEEP` | Ten discipline Skills and one investigation-case Skill remain project-owned. |
| Legacy Base index | `KEEP_AS_LEGACY_REFERENCE` | `skills/BASE_SKILL_INDEX.json` is a v8 snapshot; it is not a copy of common Skill bodies and must not become a second v9 authority. |
| GDD Sheet | `SHEET_GITHUB_CONFLICT` | `00_프로젝트_허브` reported `SYNCED` while `05_GDD_요약` reported `SHEET_UPDATE_PENDING_GITHUB`; preserve both until an approved comparison resolves them. |
| Runtime evidence | `NOT_RUN` | Existing historical automated evidence is retained, but a current Base-v9 adoption does not claim a new Godot run. |
| Human validation | `HUMAN_VALIDATION_NOT_RUN` | No new-player validation or approval is implied. |

## UX/UI validation contract

The existing Godot-native direction remains authoritative: `Control`,
`Container`, `Theme`, reusable Scene, and explicit `Signal` boundaries; display
components receive display data and return intent, while the owning screen and
authoritative state retain rules and persistence.

For the next UI-affecting change, the required evidence is keyboard and gamepad
focus traversal, pointer behavior, long Korean text wrapping, and captures or
runtime checks at `1280x720` and `1920x1080`. Accessibility and regression evidence
must remain separate from a merely successful parse or document test.

## Open-source UI reference policy

`OPEN_SOURCE_REFERENCE_CARD_ONLY`: candidates may be recorded for research, but
no template is installed, copied, or treated as project art. A candidate must
record license, commercial use, attribution, modification/redistribution,
Godot compatibility, maintenance, removable dependencies, no-copy boundary, and
project transformation/validation plan before any separate adoption decision.

## Resume gate

Resolve the Sheet conflict with an approved three-way comparison (GitHub canon,
actual implementation, Sheet). Then rerun the project CI and the relevant Godot
runtime/accessibility evidence before the maturity result can move beyond
`PROVISIONAL_PENDING_RUNTIME_REVALIDATION`.
