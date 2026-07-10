# Repository Guidelines

This guide applies equally to Codex, GPT/ChatGPT, and every delegated subagent. Each agent must read it before planning, advising, editing, testing, or handing work to another agent.

## Project Structure & Module Organization

`urban-legend` is a Godot 4.7 stable GDScript project. Scenes live in `scenes/`; code is in `scripts/core/`, `scripts/data/`, `scripts/scenes/`, and `scripts/ui/`. Episode content belongs in `data/episodes/`. Project docs include `README.md`, `MVP_ROADMAP.md`, `TEST_CHECKLIST.md`, and `docs/`. Do not edit generated `.godot/` files.

## Build, Test, and Development Commands

Open `project.godot` with Godot 4.7 stable and run `scenes/main_menu.tscn`. For headless validation:

```powershell
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --quit
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --scene "res://scenes/main_menu.tscn" --quit-after 1
```

Run changed scenes directly. `TEST_CHECKLIST.md` defines manual player-flow checks; no unit-test framework exists yet.

## Coding Style & Naming Conventions

Use GDScript and Godot nodes only. Indent with tabs; use `snake_case`; name concepts clearly (`GameState`, `ResultScene`). New `.gd` files start with one Korean role comment. Keep state ownership single, avoid duplicate logic, reuse JSON data flow, and preserve user changes.

Design mobile-vertical UI first while retaining PC mouse support. `battle_scene` is anomaly stabilization/recovery, not RPG combat: prefer `회수`, `안정화`, `위험도`, and `괴이 안정도`; do not add HP, damage, kill, or death-centered systems.

## Superpowers Replacement Workflow

This repository uses a spec-first collaboration workflow even when the Superpowers plugin or any other coding-agent skill is unavailable.

The highest-priority order is always:

```text
User idea or opinion → clarification questions and discussion → confirmed specification → high-quality working prompt → work starts → compound review learning
```

Do not treat a short idea, concern, or opinion as permission to immediately edit files.

### Required Clarification

Before implementation, documentation updates, GitHub Issue creation, Codex Goal creation, review, or testing, clarify or summarize:

1. Goal
2. Background
3. Intended player/user experience
4. Implementation scope
5. Excluded scope
6. Affected systems, files, or data
7. UI/UX impact
8. Save/data compatibility impact
9. Risks and dependencies
10. Completion criteria
11. Test checklist

If the request is already clear, summarize the inferred specification instead of asking unnecessary questions. Mark uncertain items as `Needs confirmation` and do not present them as confirmed facts.

### Prompt Conversion Rule

Before Codex begins work, convert the confirmed specification into a working prompt that includes:

1. `@Superpowers` invocation when available
2. Objective
3. Context documents to read
4. Rule priority order
5. Allowed scope
6. Forbidden scope
7. Files or systems likely to change
8. Risks to watch
9. Required verification steps
10. Expected final report format
11. Required Compound Review section

Codex prompts should start with this pattern when `@Superpowers` is available:

```text
@Superpowers Use this repository's spec-first workflow.
Do not edit files immediately.
First read AGENTS.md, docs/BASE_RULES_VERSION.md, docs/DOCUMENTATION_MAP.md, the project-local Base rules, the current Issue/Goal, and relevant files.
Then summarize the goal, scope, exclusions, risks, completion criteria, and test checklist.
Proceed only within the confirmed scope.
At the end, run the Compound Review process and report mistakes, lessons, prevention rules, and Base-promotion candidates.
```

Codex must not redefine the product direction, player experience, genre direction, art direction, core loop, or high-level design unless the latest user instruction explicitly asks for that.

### Plugin Compatibility and Installation

If `@Superpowers` or another plugin is available, it may support brainstorming, planning, TDD, debugging, review, and verification. It must not override the latest user instruction, this `AGENTS.md`, the current Goal/Issue, project docs, or actual repository files.

If the plugin does not activate automatically, this replacement workflow remains the source of truth.

Superpowers must be installed separately for each coding-agent environment. For Codex App, install `Superpowers` from the Codex plugin marketplace. For Codex CLI, open `/plugins`, search `superpowers`, and select `Install Plugin`. Do not claim Superpowers is installed or active unless Codex actually shows it as callable or installed.

### Compound Review Process

At the end of every execution-review cycle, Codex must run a Compound Review process before the final report is considered complete.

The purpose is to prevent repeated mistakes from the execution-review loop. Codex must identify:

1. Mistakes, omissions, or wrong assumptions made during the task
2. Root causes: unclear scope, unread files, insufficient tests, terminology mismatch, duplicated system, save compatibility risk, UI layout risk, or tool limitation
3. What should be checked earlier next time
4. One concrete prevention sentence to add to the next Codex prompt
5. Whether the lesson belongs in Base rules or only in this project
6. Whether any project document should be updated

The final report must include a `Compound Review` section with:

- Mistakes or near-misses
- Lessons learned
- Prevention checklist
- Base-promotion candidates
- Project-only rule candidates

## Testing Guidelines

Validate JSON, run headless project and changed-scene checks, then test the affected player path. Verify saves after `GameState` changes and inspect mobile-width wrapping. Report untested items plainly.

## Parallel Agent Workflow

Use subagents to improve evidence and speed, not to create competing edits. The coordinator first creates a task map containing the goal, player value, exclusions, dependencies, expected files, save-risk level, agent owner, output format, and verification. A task is `read_only` by default. No agent may stage, commit, push, revert, delete, rename, or edit another agent's owned path.

### Required Roles

1. **Rules and Git Inspector**: checks the latest GitHub `alsdmlals4-eng/Base` reference, local Base copies, project rules, Issue/Goal, branch status, user changes, conflicts, and relevant history. Output: rule conflicts, current-state facts, and a safe file list. This role does not edit files.
2. **Benchmark and Player Insight Analyst**: use only for new systems, major UX decisions, genre changes, or unclear player needs. Research 3–5 similar games or keyword cases, separating official facts, professional analysis, and player feedback. Output: evidence, observed need, adopt/reject decision, and why it fits this game. Do not copy features or expand the approved scope.
3. **Goal and Scope Analyst**: turns the Issue/Goal into a Definition of Ready: problem, target player experience, in-scope and excluded work, observable completion criteria, expected files, dependencies, and save/compatibility risks. Output: a short implementation brief and unanswered questions.
4. **Codebase and Data-Flow Inspector**: reads the actual related scenes, scripts, JSON, calls, save/load fields, and existing helpers. Output: current behavior, reuse candidates, duplicate-code risks, affected paths, and regression risks. This prevents implementing a second version of an existing system.
5. **QA and Regression Inspector**: independently checks JSON, headless scenes, relevant player flow, save compatibility, and mobile text layout. Output: tested behavior, failures, untested items, and reproduction steps. This role does not repair code unless explicitly assigned an isolated fix.
6. **Final Integration Agent**: reviews all reports, resolves contradictions against real files and the latest user instruction, chooses the smallest safe solution, and owns all overlapping code edits. It runs final validation, performs the Compound Review process, updates required documentation, and reports changes in simple Korean.

### Execution Order

Run roles 1, 3, and 4 in parallel. Add role 2 only when a design decision needs evidence; add role 5 after implementation. The final integration agent starts writing only after the read-only reports agree on scope and file ownership. Independent write tasks are allowed only when paths do not overlap; otherwise one integrator writes the final patch. Every handoff must include findings, file paths, evidence, suggested action, and risks. The integrator rereads all changed files and `git diff` before validation, then performs Compound Review before final reporting.

If subagents are unavailable, perform the same roles with parallel read-only tool calls and keep one implementation owner.

## Tooling Blockers

When a required workflow capability is missing, such as subagents, a connector, a command runtime, or credentials, first check whether it is already available in the current session or project configuration. Fix it directly only when the change is safe, scoped, and does not need user or administrator approval. Do not pretend a missing capability ran successfully or continue work that depends on it.

If direct recovery is impossible or requires user action, stop the dependent task and report the exact blocker, why it prevents reliable work, what was tried, the smallest user action needed, and how recovery will be verified. Independent work may continue only when it cannot hide, weaken, or conflict with the blocked goal.

## Commit & Pull Request Guidelines

Use focused messages such as `MVP-018 완료 사건 보고서 DB 재확인 구현` or `docs: update MVP status audit`. PRs state the Issue/MVP, player-visible behavior, validation, UI screenshots, and Compound Review notes.

## Agent Workflow

Check the latest GitHub `alsdmlals4-eng/Base` reference first, then local Base copies, project rules, Issue/Goal, Git status, and relevant files. Latest user instructions win. Before editing, turn requests into a plan with purpose, player value, scope, exclusions, completion criteria, owned files, and verification. Follow the Superpowers Replacement Workflow: clarify the user's idea through questions and discussion, confirm the specification, convert it into a high-quality working prompt that starts with `@Superpowers` when available, and only then start work. Explain a better in-scope solution before applying it. Display versions follow MVP numbers: MVP-018 is `Ver 1.8`, MVP-020 is `Ver 2.0`. Update the start screen with changed behavior and user checks, then explain work in simple Korean. State whether Superpowers was callable, whether subagents were available, which roles were used, what each role found, what the Compound Review found, and whether a Base-promotion candidate exists.
