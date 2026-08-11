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

`one task = one isolated worktree/project path = one PowerShell execution context = one Godot editor instance = one unique HiGodot HTTP+WS endpoint pair = one Codex work context`

#### 3.1 Reserved CASE-01 / urban-legend HiGodot endpoints

The urban-legend local authoring pair is reserved as:

- HiGodot HTTP Port: `8004`
- HiGodot WebSocket Port: `9504`

No other concurrently active project/task may intentionally reuse either port. If either port is already listening before the urban-legend Godot session starts, the preflight must stop before product mutation. Do not attach to an unknown listener and do not reuse another project's active HiGodot endpoint.

#### 3.2 Self-contained Godot is the default Windows editor for urban-legend authoring

Do not rely on the ordinary shared `%APPDATA%\Godot` EditorSettings for HiGodot authoring, because concurrent editor instances can otherwise observe or overwrite shared addon/editor settings such as ports.

The urban-legend authoring editor must use a dedicated Godot 4.7.1 executable directory with an `_sc_` marker beside the executable so its editor settings/data/cache live under that dedicated directory's `editor_data/` instead of the shared user EditorSettings location.

Preferred dedicated directory:

`C:\Users\user\Tools\Godot-URBAN-LEGEND-4.7.1`

The actual Godot source executable location is environment-specific and must be resolved on the user's machine at launch time rather than assumed to be one fixed file shape. If a configured source path is a directory, the bootstrap must resolve the actual Godot 4.7.1 executable inside it before copying.

The dedicated editor must open the exact task/PR worktree path, not the shared checkout. Current PR #198 convention:

`C:\Users\user\Documents\GitHub\Ninza\urban-legend.codex-isolated\pr198`

Within the dedicated editor's currently installed `godot_ai` / HiGodot settings, configure HTTP `8004` and WebSocket `9504`. The concrete provider setting keys must be read from the installed addon rather than invented.

#### 3.3 Project-specific CODEX_HOME

Codex CLI does not need a separate installation per project. The same installed Codex executable may be reused, but the urban-legend PowerShell session must provide a project-specific `CODEX_HOME` before launching Codex so its MCP/config state does not overwrite another project's Codex configuration.

Preferred urban-legend convention:

`C:\Users\user\.codex-urban-legend`

The corresponding PowerShell session sets that directory as `CODEX_HOME`, changes directory to the exact isolated urban-legend worktree, and then starts Codex from that same shell. Other projects use different PowerShell sessions and different `CODEX_HOME` directories.

The concrete current Codex/HiGodot MCP config keys must be read from installed tooling before editing config. This Decision fixes the isolation model and endpoint pair but does not invent version-specific provider key names.

#### 3.4 Required startup order and fail-closed preflight

Before persistent product authoring:

1. Resolve the task/PR-specific isolated worktree and verify it is not the shared main checkout.
2. Resolve or create the dedicated self-contained urban-legend Godot executable directory and verify `_sc_` exists beside the executable.
3. Verify self-contained `editor_data/` is created by that dedicated Godot rather than treating shared `%APPDATA%\Godot` as the authoring settings owner.
4. Check TCP ports `8004` and `9504` before starting Godot. If either is already owned/listening, stop and identify the owner; never blindly reuse it or kill an unknown process.
5. Start exactly one dedicated Godot editor against the exact isolated worktree/project path.
6. Verify the installed HiGodot/godot_ai settings in that self-contained editor use HTTP `8004` and WS `9504` and refer to the exact project.
7. Only after the dedicated Godot + HiGodot endpoint pair is established, resolve or create the urban-legend project-specific `CODEX_HOME`.
8. In the same fresh project-specific PowerShell execution context, set `CODEX_HOME`, change directory to the same isolated worktree, and launch Codex.
9. Inside Codex, obtain a fresh HiGodot project/session/version/readiness receipt before persistent mutation. Process existence and open ports are not readiness evidence by themselves.
10. Never run two active urban-legend HiGodot authoring tasks on the same `8004/9504` pair. A concurrent task needs a separately approved endpoint pair and separate editor/CODEX_HOME work context, or it waits.
11. Keep APPDATA/LOCALAPPDATA/TEMP isolation where required by existing Windows QA/tooling policy; a shared-cache crash is not product evidence.

### 4. Local isolation is product-safety infrastructure, not optional convenience

A port collision, shared EditorSettings mutation, wrong worktree binding, or wrong `CODEX_HOME` can cause a HiGodot session to stall or author against the wrong project. Therefore local isolation is a pre-authoring gate. A failed or ambiguous isolation check blocks persistent product mutation until corrected.

### 5. Cold-start assumption and one-shot PowerShell handoff

The normal operating assumption is that the user closes PowerShell after each local work session. No future handoff may assume that a prior shell environment variable, working directory, Godot process, port ownership, `CODEX_HOME`, or HiGodot session still exists.

Every local implementation/review handoff that needs Godot + HiGodot + Codex must start from a fresh PowerShell and consume the Base `ONE_SHOT_LOCAL_EXECUTOR_BOOTSTRAP` contract.

Required order:

`fresh PowerShell -> exact project/worktree check -> dedicated self-contained Godot exists? create if missing -> launch/reuse exact dedicated Godot -> verify/set project HiGodot 8004/9504 -> create/resolve project CODEX_HOME -> bind same worktree in that shell -> launch Codex -> fresh HiGodot receipt -> author`

The user-facing handoff should normally be one copy/paste PowerShell block rather than a sequence of separate snippets. The block may pause once for a manual editor-setting confirmation if the installed HiGodot version does not expose a verified safe command/config key for automated port setup. It must not invent or blindly edit provider-specific config keys.

`BOOTSTRAP_MINIMUM_PREFLIGHT_ONLY` applies:

- verify only identity/state required to avoid the wrong target;
- if an exact matching Godot editor is already running for the exact worktree and port pair, reuse may be allowed only when ownership is unambiguous;
- do not run broad repository scans or noisy diff dumps before Codex merely as ceremony;
- do not `git reset`, `restore`, `clean`, stage, or rewrite user work in the bootstrap;
- do not kill unrelated/unknown Godot, HiGodot, or port-owning processes;
- if the local environment does not exist, create the isolated runtime first instead of launching Codex against shared defaults;
- if any minimum identity/isolation prerequisite is ambiguous, stop with one actionable blocker before product mutation.

Before issuing a project-local PowerShell block, the assistant/operator must run an adversarial review loop against current project authority: current Base structure/latest, project default branch/latest/open PRs, current Sheet owner rows, target worktree/branch, dedicated Godot path, reserved ports, and current execution boundaries. The resulting block must use the current exact project values and must not silently reuse stale chat values when live authority conflicts.

## TDD / verification additions

Before the CASE-01 product GREEN is considered complete, the implementation plan must include checks for:

- localization key/data coverage for new player-facing CASE-01 UI strings;
- minimum four-language catalog readiness;
- long-label and wrapping behavior without semantic reordering;
- same logical region order across current PC/wide/mobile-landscape representative profiles;
- click/tap completion on compact landscape layouts;
- local preflight that detects a conflicting HTTP `8004` or WS `9504` listener and refuses to start a conflicting authoring session;
- self-contained Godot `_sc_` / `editor_data` isolation verification;
- traceability from active Codex/HiGodot task to isolated worktree/project path, project-specific `CODEX_HOME`, HTTP `8004`, and WS `9504`;
- no automatic killing/reuse of an unknown process that owns a required port;
- cold-start test assumption: the launcher must work from a newly opened PowerShell without relying on prior session variables.

## Non-goals / unchanged boundaries

- This Decision does not authorize product GDScript/Scene mutation through a non-HiGodot authoring path.
- It does not select simplified or traditional Chinese yet.
- It does not introduce a mobile-only navigation architecture.
- It does not change the approved three-tab navigation: `[기록] [괴이 매뉴얼] [지도]`.
- It does not add `[로그]` or `AI 로그`.
- It does not change Lume identity/art approval gates.
- It does not claim Human/mobile/Android QA PASS.
- It does not require separate Codex installations; configuration/work contexts are isolated instead.
- A one-shot launcher reaching Codex is not proof that HiGodot, tests, import, runtime, Human QA, or product behavior is ready.

## Current execution classification

`USER_APPROVED / GITHUB_AND_SHEET_SYNC_REQUIRED / BASE_ONE_SHOT_LOCAL_EXECUTOR_BOOTSTRAP_CONSUMED / COLD_START_POWERSHELL_ASSUMED / ONE_COPY_PASTE_HANDOFF_REQUIRED / HTTP_8004_WS_9504_RESERVED / SELF_CONTAINED_GODOT_REQUIRED_FOR_LOCAL_HIGODOT / PROJECT_CODEX_HOME_REQUIRED / PRODUCT_RUNTIME_UNCHANGED / HIGODOT_PRODUCT_AUTHORING_BOUNDARY_PRESERVED`
