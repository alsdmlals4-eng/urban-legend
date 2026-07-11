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

## GPT + Codex + GitHub Default Workflow

This repository does not require Harness, Superpowers, Serena, Claude Code plugins, or any other external automation to continue work. Those tools are optional accelerators only.

### Context Efficiency and Shared Memory

GPT/ChatGPT and Codex keep only the current goal, latest user decisions, active risks, and the immediate handoff summary in conversation context. All durable project knowledge belongs in versioned repository documents: `AGENTS.md` for operating rules, `README.md` for project use, `docs/` for workflow and design decisions, GitHub Issues for accepted scope, and `TEST_CHECKLIST.md` for verification.

Before work, read the relevant local documents and affected files instead of relying on a long conversation history or re-reading the full remote repository. Check GitHub only when an Issue, remote update, merge conflict, Base synchronization, or collaboration handoff requires it. Keep task prompts focused on one MVP or one observable fix. Use a single implementation agent by default; use parallel read-only agents only when their work is independent and the expected evidence is worth the additional context cost. Every completed task must leave a concise, committed handoff note so GPT and Codex can safely begin a new task with minimal context.

External skill selection, permission preflight, and context compaction follow `docs/AI_SKILL_ADOPTION_GUIDE.md`. Use the smallest task-matched skill set; save decisions before compacting at phase boundaries, and never compact during partial implementation or active bug reproduction.

Default responsibility split:

1. **GPT/ChatGPT**: planning, benchmarking, player-experience framing, system/data design, GitHub Issue drafting, Codex Goal drafting, review prompts, and test checklist writing.
2. **Codex**: actual file edits, Godot/GDScript implementation, JSON/TSCN updates, documentation patches, validation, and final change reports.
3. **GitHub**: single source for Issues, Goals, changed files, review history, completion criteria, validation notes, and future handoff context.

If a plugin cannot be installed, downloaded, or invoked, do not block the project. Fall back to `AGENTS.md`, `docs/CODEX_SHARED_WORK_RULES.md`, GitHub Issue, and Codex Goal.

## Spec, Tools, and Review

Use this compact order for every task:

```text
user request → concise working brief → local rules and affected files → smallest safe change → validation → handoff review
```

The brief states the goal, player value, allowed and excluded scope, affected files, save/UI risk, completion checks, and any uncertainty. Do not redefine product direction or add unrequested systems.

Plugins such as Superpowers, Harness, and Serena are optional. They may help plan, debug, or review, but never override the latest user request, repository documents, Issue/Goal, or actual files. If a plugin is unavailable, continue with this document-based workflow.

Before reporting completion, record mistakes or near-misses, their prevention step, untested items, and whether the lesson belongs in Base or this project. Use `docs/MVP_WORKFLOW_CHECKLIST.md` for the detailed checklist instead of duplicating it in every Goal.

## Testing Guidelines

Validate JSON, run headless project and changed-scene checks, then test the affected player path. Verify saves after `GameState` changes and inspect mobile-width wrapping. Report untested items plainly.

## Agent Use

Use one implementation owner by default. Add read-only reviewers only when a task has independent rule, code-flow, benchmark, or QA questions whose evidence justifies the extra context cost. Reviewers never edit overlapping files or commit, push, revert, delete, or rename files. The final owner rereads changed files and `git diff` before validation.

## Tooling Blockers

When a required workflow capability is missing, such as subagents, a connector, a command runtime, a plugin, or credentials, first check whether it is already available in the current session or project configuration. Fix it directly only when the change is safe, scoped, and does not need user or administrator approval. Do not pretend a missing capability ran successfully or continue work that depends on it.

If direct recovery is impossible or requires user action, stop only the dependent task and report the exact blocker, why it prevents reliable work, what was tried, the smallest user action needed, and how recovery will be verified. Independent work may continue when it does not hide, weaken, or conflict with the blocked goal.

A plugin installation failure is not a project failure. Continue with the repository rules, Issue, Codex Goal, and manual verification checklist.

## Commit & Pull Request Guidelines

Use focused messages such as `MVP-018 완료 사건 보고서 DB 재확인 구현` or `docs: update MVP status audit`. PRs state the Issue/MVP, player-visible behavior, validation, UI screenshots, and Compound Review notes.

## Agent Workflow

Read the latest user instruction first, then `AGENTS.md`, `docs/BASE_RULES_VERSION.md`, `docs/DOCUMENTATION_MAP.md`, local Base-derived docs, project rules, Issue/Goal, Git status, and relevant files. Use the remote `alsdmlals4-eng/Base` reference only when the task is Base synchronization, Base promotion, or common-rule comparison. Latest user instructions win.

Before editing, turn requests into a plan with purpose, player value, scope, exclusions, completion criteria, owned files, and verification. Follow the Superpowers / Harness Replacement Workflow: clarify the user's idea through questions and discussion when needed, confirm or summarize the specification, convert it into a high-quality working prompt that starts with `@Superpowers` or another plugin invocation only when available, and only then start work. Explain a better in-scope solution before applying it.

Display versions follow MVP numbers: MVP-018 is `Ver 1.8`, MVP-020 is `Ver 2.0`. Update the start screen with changed behavior and user checks, then explain work in simple Korean. State whether Superpowers, Harness, Serena, or subagents were available, which roles were used, what each role found, what the Compound Review found, and whether a Base-promotion candidate exists.
