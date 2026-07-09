# Core
- Godot project rooted at `urban-legend`; episode JSON in `data/episodes`, reusable state in `scripts/core/game_state.gd`, data adapters in `scripts/data`, scene behavior in `scripts/scenes` and `scripts/ui`.
- Game flow is JSON-driven: menu/preparation -> dialogue -> investigation -> minigame or recovery -> result; `GameState` is the autoloaded cross-scene/save authority.
- Read focused gameplay conventions in `mem:conventions`, runtime commands in `mem:suggested_commands`, and completion checks in `mem:task_completion`.