# D-2026-08-11-CASE01-UI-I18N-RESPONSIVE-LOCAL-ISOLATION

- Date: 2026-08-11 KST
- Scope: CASE-01 investigation UI implementation constraints
- Status: USER_APPROVED / PHASE_C_IMPLEMENTATION_CONSTRAINT
- Related decisions:
  - D-2026-08-11-CASE01-UI-SEPARATION-SPEC-APPROVED
  - D-2026-08-11-CASE01-LANDSCAPE-SAME-COMPOSITION-UI
  - D-2026-08-11-CASE01-MANUAL-KEYWORD-INPUT-CONTRACT

## User-approved constraints

### 1. Localization-ready implementation from the first product pass

The CASE-01 UI must be authored with translation in mind rather than translating hard-coded Korean after implementation.

Minimum supported language set for the UI/content pipeline:

- Korean
- English
- Japanese
- Chinese

Player-facing text owned by the new CASE-01 device/surface package must be addressable through localization keys or an equivalent data-driven localization surface. UI layout must tolerate language-dependent text expansion, wrapping, line-height, glyph/fallback differences, and translated button/label lengths without changing the semantic information hierarchy.

The exact Chinese regional locale (for example simplified vs traditional) is not inferred by this Decision and remains a later localization-data choice. The implementation contract must not structurally block either choice.

Do not encode deduction truth, keyword fitness, or hidden answer state in locale-specific copy.

### 2. Same UX composition across PC, wide displays, and mobile landscape

This Decision explicitly reconfirms `D-2026-08-11-CASE01-LANDSCAPE-SAME-COMPOSITION-UI` for Phase C.

PC, wider landscape displays, and mobile landscape keep the same functional regions, semantic order, navigation model, and core interaction flow. Responsive behavior may adapt scale, padding, minimum panel width, text wrapping, scroll behavior, and secondary density, but must not move core regions into a mobile-only drawer/bottom-sheet or create a different mobile information architecture.

The manual remains the same left index / center deduction / right candidates-plus-Lume composition. Records and Map keep the same region meaning/order across device classes. Click/tap completion remains mandatory; precision drag is optional.

Exact representative pixel profiles are implementation/test details and must be derived from the current project display configuration before product authoring rather than guessed in this Decision.

### 3. Local PowerShell / Godot / HiGodot / Codex isolation

Concurrent local authoring must fail closed against shared editor/tool state.

Operational rule:

`one task = one isolated worktree/project path = one PowerShell execution context = one Godot editor instance = one unique HiGodot port = one Codex work context`

Required behavior before local HiGodot authoring:

1. Use a task/PR-specific isolated worktree rather than the shared base checkout.
2. Start the Godot editor against that exact isolated project path.
3. Assign a HiGodot port that is unique to that active task/session.
4. Check that the selected port is available before starting the authoring session.
5. Bind the Codex work context to the same isolated worktree/project and its HiGodot endpoint.
6. Never intentionally share one active HiGodot port between concurrent Godot/Codex jobs.
7. If the desired port is occupied, ambiguous, or already associated with another active task, stop before product mutation and allocate another port/session instead of reusing it.
8. Keep local editor/user-data/cache/temp isolation where required by the existing project Windows QA/tooling policy; do not treat a shared local cache crash as product evidence.

The concrete HiGodot command-line flag, setting key, environment variable, or port-registration mechanism must be read from the currently installed HiGodot tooling at execution time. This Decision does not invent a provider-specific option name.

## TDD / verification additions

Before the CASE-01 product GREEN is considered complete, the implementation plan must include checks for:

- localization key/data coverage for new player-facing CASE-01 UI strings;
- minimum four-language catalog readiness (ko/en/ja/zh-family, with the exact Chinese regional locale still explicitly classified until selected);
- long-label and wrapping behavior without semantic reordering;
- same logical region order across current PC/wide/mobile-landscape representative profiles;
- click/tap completion on compact landscape layouts;
- local preflight that detects a conflicting HiGodot port and refuses to start the conflicting authoring session;
- traceability from an active Codex/HiGodot task to its isolated worktree/project path and unique port.

## Non-goals / unchanged boundaries

- This Decision does not authorize product GDScript/Scene mutation through a non-HiGodot authoring path.
- It does not select simplified or traditional Chinese yet.
- It does not introduce a mobile-only navigation architecture.
- It does not change the approved three-tab navigation: `[기록] [괴이 매뉴얼] [지도]`.
- It does not add `[로그]` or `AI 로그`.
- It does not change Lume identity/art approval gates.
- It does not claim Human/mobile/Android QA PASS.

## Current execution classification

`USER_APPROVED / GITHUB_AND_SHEET_SYNC_REQUIRED / PRODUCT_RUNTIME_UNCHANGED / TDD_RED_ALREADY_ESTABLISHED_FOR_CORE_DEVICE_CONTRACTS / NEW_I18N_RESPONSIVE_LOCAL_ISOLATION_GUARDS_REQUIRED_BEFORE_PRODUCT_GREEN / HIGODOT_PRODUCT_AUTHORING_BOUNDARY_PRESERVED`
