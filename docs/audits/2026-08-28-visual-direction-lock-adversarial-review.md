# Visual Direction Lock · Adversarial Review · 2026-08-28

> Role: `ADVERSARIAL_REVIEW`
> Scope: `D-2026-08-28-URBAN-NOIR-HYBRID-VISUAL-DIRECTION` and `PROJECT_CORE_SCENE_VISUAL_BOARD`
> Evidence ceiling: planning and generated-board inspection only; runtime, Human usability, Player Experience, accessibility, Audio/VFX remain `NOT_RUN`.

## Five full review loops

| Loop | Failure assumption | Evidence checked | Finding and correction | Result |
| --- | --- | --- | --- | --- |
| 1 | The direction invents a new game instead of reading current canon. | `CURRENT_PLANNING_CANON`, `current-planning-canon.json`, visual work order, current M04 approved asset evidence. | The selected hybrid refines existing `SOFT_ANIME_NOIR_LOCKED` and dossier invariant; no new core loop/system was added. | PASS |
| 2 | The board loses the fixed player identity. | Current canon/data identify Kwon Narae as the fixed female protagonist; first generated board preview. | First preview contained a male investigator in Preparation. It was rejected, regenerated, and only the corrected-board bytes were stored. | CORRECTED / PASS |
| 3 | A six-panel board falsely claims six equivalent runtime Scenes. | Current scene flow and board panel table. | Rescue and Recovery are consecutive current surfaces but one board panel; explicit non-claim and handoff text added. | PASS |
| 4 | Decorative imagery silently approves new UI, routes, buttons, or state. | Generated pixels vs structured panel descriptions. | Decorative map/card/icon/pseudo-text elements were explicitly classified as non-canonical. Exact controls/data remain repository/Notion-owned. | PASS |
| 5 | Planning-image approval is confused with product asset, runtime, or Human evidence. | Asset manifest boundary, visual work order, lock packet provenance. | Board is marked `GENERATED_EXPLORATION / NOT_PROJECT_ASSET / NOT_RUNTIME_ASSET`; no product paths or Godot consumer changed. | PASS |

## Incident → solution → lesson

- **Incident:** the first generated planning board represented the fixed player protagonist with the wrong gender.
- **Solution:** reject the first board, regenerate while preserving composition and visual grammar, inspect the corrected board, and retain only the corrected-board bytes in project documentation.
- **Project-only lesson:** generated visual planning needs an explicit protagonist/role identity check before durable storage, even where the global direction is correct.
- **Base promotion:** `NO_BASE_PROMOTION`. One caught project-specific generation defect is not yet reusable cross-project evidence for a new Base rule.

## Clean-review exit

Five full loops are complete. No remaining blocking finding exists within the approved planning-only scope. The following are intentionally not closed: consumer-specific runtime composition, target-resolution readability, Human/new-player comprehension, accessibility, Audio/VFX, and production asset promotion.
