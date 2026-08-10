# Gameplay → Main Menu Safe Return — SOURCE_CONTEXT_PACKET

Checked: 2026-08-11 KST
Decision owner: `D-2026-08-11-GAMEPLAY-MAIN-MENU-SAFE-RETURN-CONTINUE`
Base remote checked: `315c66eea9614c284b9c11c4d522141065dfa4b0`
Project baseline checked: `cba130ee156c89710d3ddef33ed677bf99aa0716`

This packet separates external-source facts from project-specific decisions. External sources do not override project canon; they constrain or validate the chosen implementation where applicable.

---

## Packet 1 — Xbox Accessibility Guideline 112: UI navigation

```yaml
source_id: microsoft-xag-112-ui-navigation
source_domain: GAME_UI_ACCESSIBILITY
source_role: AUTHORITY_TARGET
source_url_or_surface: https://learn.microsoft.com/en-us/xbox/accessibility/xbox-accessibility-guidelines/112
original_source_backtrace: Microsoft Game Dev / Xbox Accessibility Guidelines
published_or_updated_at: current page retrieved 2026-08-11
checked_at: 2026-08-11
source_fact: Game UI navigation should be clear and consistent across the game; interaction methods and focus movement should be predictable; players should have an easy mechanism to return to a main menu or previous screen; supported digital inputs should remain usable.
context_conditions: Applies to navigable game UI and accessibility/navigation consistency. It does not prescribe this project's save schema.
freshness: CURRENT_CHECKED
scope: gameplay/menu navigation and focus behavior
sample_or_method: official implementation guidance and examples
platform_or_medium: game UI; Xbox guidance also explicitly discusses PC keyboard/digital input examples
commercial_or_vendor_interest: platform-holder accessibility guidance
license_or_copying_notes: paraphrase only; do not copy examples or text wholesale
base_overlap: PARTIAL
existing_owner: D-2026-08-11-GAMEPLAY-MAIN-MENU-SAFE-RETURN-CONTINUE / project UX canon
decision_delta: Supports one consistent Main Menu affordance and keyboard/controller-accessible focus behavior across principal gameplay surfaces.
smallest_change_candidate: shared semantics and focus/confirmation acceptance criteria; no new navigation framework solely because of this source
disposition: ADAPT
work_disposition: ABSORB_EXISTING_OWNER
```

Project adoption:

- Use one consistent `메인 메뉴` meaning rather than scene-specific hidden/debug semantics.
- Keep the action keyboard/digital-focusable where the surrounding UI is focusable.
- Restore focus predictably if the confirmation is canceled or save fails.
- Do not infer save/restore technical behavior from XAG 112; that remains project-owned.

---

## Packet 2 — Xbox Accessibility Guideline 114: UI context

```yaml
source_id: microsoft-xag-114-ui-context
source_domain: GAME_UI_ACCESSIBILITY
source_role: AUTHORITY_TARGET
source_url_or_surface: https://learn.microsoft.com/en-us/gaming/accessibility/xbox-accessibility-guidelines/114
original_source_backtrace: Microsoft Game Dev / Xbox Accessibility Guidelines
published_or_updated_at: current page retrieved 2026-08-11
checked_at: 2026-08-11
source_fact: UI should provide enough context for a player to understand what an interaction will do before activating it; context-changing actions should be clearly described.
context_conditions: Applies to descriptive UI context; does not require confirmation for every action.
freshness: CURRENT_CHECKED
scope: labels, context, confirmation copy
sample_or_method: official implementation guidance
platform_or_medium: game UI
commercial_or_vendor_interest: platform-holder accessibility guidance
license_or_copying_notes: paraphrase only
base_overlap: PARTIAL
existing_owner: gameplay menu confirmation copy and save-failure UX
decision_delta: The confirmation must say whether the current activity resumes exactly, from a semantic checkpoint, or by restarting an incomplete minigame attempt.
smallest_change_candidate: scene-policy-specific confirmation text
disposition: ADAPT
work_disposition: ABSORB_EXISTING_OWNER
```

Project adoption:

- Do not label every behavior simply `저장하고 메뉴` if the resume policy differs by scene.
- For minigames, explicitly state that an incomplete attempt restarts from its defined safe checkpoint if that remains the implementation contract.
- Save failure must keep the player in the current scene and show the failure instead of silently navigating.

---

## Packet 3 — Godot 4.7 Saving games

```yaml
source_id: godot-4-7-saving-games
source_domain: ENGINE_PERSISTENCE
source_role: AUTHORITY_TARGET
source_url_or_surface: https://docs.godotengine.org/en/4.7/tutorials/io/saving_games.html
original_source_backtrace: Godot Engine 4.7 official documentation
published_or_updated_at: current 4.7 documentation retrieved 2026-08-11
checked_at: 2026-08-11
source_fact: JSON persistence requires explicit encoding/decoding decisions and does not natively preserve every Godot engine type; custom state requires custom serialization logic.
context_conditions: Applies because the project uses a JSON save file through GameState. It does not imply binary serialization should replace the current format.
freshness: CURRENT_CHECKED
scope: explicit save-state representation
sample_or_method: official engine documentation
platform_or_medium: Godot 4.7
commercial_or_vendor_interest: engine-author documentation
license_or_copying_notes: paraphrase; retain project implementation ownership
base_overlap: PARTIAL
existing_owner: scripts/core/game_state.gd save/load contract
decision_delta: Scene-local battle/minigame/dialogue state must not be assumed to survive unless it is already reconstructible from GameState or explicitly encoded in a bounded checkpoint.
smallest_change_candidate: one optional JSON-safe resume checkpoint dictionary; no second save format
disposition: ADAPT
work_disposition: ABSORB_EXISTING_OWNER
```

Project adoption:

- Reuse the existing JSON save.
- Store only JSON-safe primitive/Array/Dictionary checkpoint data.
- Do not serialize live Nodes, Callables, Resources, Tweens, timers, or Control references.
- Prefer semantic identifiers and values that allow the scene to rebuild itself.

---

## Existing-Solution-First result

The external sources do **not** justify a new save service, pause framework, autoload, or main-menu back stack.

Current project code already provides the essential path:

```text
GameState save file
→ saved current_scene_path
→ Main Menu Continue
→ GameState.load_game()
→ change_scene_to_file(saved scene)
```

The smallest missing project-owned capability is a bounded **resume checkpoint** for scene-local state plus a separate gameplay→menu transition that does not overwrite the saved resume scene with `main_menu.tscn`.

## Adversarial exclusions

- `XAG 112` supports consistency but does not prove every gameplay moment must be frame-perfect resumable.
- `XAG 114` supports clear context but does not require a modal confirmation where an action is already reversible and obvious.
- Godot's save guide does not prove JSON is inadequate for this project; it only means required state must be explicitly representable.
- No source supports changing Validation persistence, campaign-day semantics, reward rules, or minigame scoring.

## Final disposition

`ADAPT / ABSORB_EXISTING_OWNER`

External evidence strengthens the approved project decision but introduces no new product direction and no independent approval claim.
