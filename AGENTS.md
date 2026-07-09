# AGENTS.md

Codex and other coding agents should follow this file when working in this repository.

## Project

Project name: `urban-legend`
Engine: Godot 4.7 stable
Language: GDScript
Genre: visual novel / horror mystery

This project recreates the provided HTML-based urban legend database as a Godot project. The goal is not to copy the web page literally, but to preserve its production data structure and turn it into a usable visual novel foundation.

## Source References

- `C:\Users\user\Downloads\도시괴이담\urban-legend-database.html`
- `C:\Users\user\Downloads\도시괴이담\agent-workflow-report-v28.md`

Before implementing features that depend on the old tool, inspect the relevant source file directly.

## Core Direction

- Build a horror mystery visual novel foundation.
- Preserve the original concepts: urban legend archive, agency records, factions, agents, equipment, skills, timelines, branches, dialogue, minigames, and production checks.
- Keep the mood investigative, ominous, readable, and data-driven.
- Prioritize mobile portrait UI, while keeping PC mouse input usable.
- Do not add combat, HP, stamina, damage, death, ranking, ads, payments, or online systems unless explicitly requested.

## Work Style

- Inspect actual files before editing. Use `rg` to locate relevant scenes, scripts, and source references.
- Prefer small, focused changes that move the Godot recreation forward.
- Do not overwrite or revert unrelated user changes.
- Avoid speculative framework work until a concrete feature needs it.
- Keep generated structures understandable for a beginner.
- Update `README.md` when setup, scene flow, test steps, or project scope changes.

## Godot Rules

- Use Godot 4.7 stable.
- Use GDScript unless explicitly requested otherwise.
- Keep scene and node structures simple.
- Use clear names such as `DatabaseView`, `SectionList`, `DetailText`, and `UrbanLegendState`.
- New GDScript files must start with a one-line Korean role comment.

Example.

```gdscript
# 데이터베이스 화면의 섹션 선택과 상세 표시를 관리한다.
extends Control
```

## Data Migration Priorities

Move the HTML concepts into Godot in this order.

1. Project overview and section navigation.
2. Factions, agents, equipment, and skills.
3. Horror episodes and daily episodes.
4. Timeline, branches, dialogue, and audio cues.
5. Minigame links and condition rules.
6. Production quality checks.
7. Import/export pipeline.

## Verification

If code, scenes, or project settings changed, run the smallest useful Godot check.

```powershell
godot --headless --path . --quit
godot --headless --path . --scene "res://scenes/main_menu.tscn" --quit-after 1
```

Known Windows local fallback.

```powershell
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --quit
```

Final replies should include changed files, implemented content, verification, remaining risks, and what the user should do next.

