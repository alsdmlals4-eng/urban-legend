# 괴이기록국 · Project Core Scene Visual Board · 2026-08-28

> Role: `PROJECT_CORE_SCENE_VISUAL_BOARD`
> Board file: `docs/visual/boards/PROJECT_CORE_SCENE_VISUAL_BOARD_2026-08-28.png`
> Status: `USER_APPROVED_VISUAL_DIRECTION / GENERATED_EXPLORATION / PLANNING_REVIEW`
> Decision dependency: `D-2026-08-28-URBAN-NOIR-HYBRID-VISUAL-DIRECTION`
> Non-claim: this board is not six runtime assets, six implemented Scenes, an approved UI build, or Human usability / Player Experience evidence.

The board is a single planning visualization used to test whether the project’s core loop reads in one glance. It deliberately contains no canonical in-image text. Exact rules, labels, controls, data, and scene contracts remain owned by the repository and Notion structured documents.

```text
main / case entry → prepare Kwon Narae → investigate environment
→ construct Manual → rescue + recovery response → composite result → next case
```

## Panels and planned consumers

| Panel / scene_or_screen_id | Actual or planned consumer | Player goal and primary action | Meaningful choice / needed information | Expected feedback / next link | Canon evidence / undecided boundary |
| --- | --- | --- | --- | --- | --- |
| P01 `SCR_MAIN_MENU_CASE_ENTRY` | `main_menu` family | Enter or continue the current case. | Current case/record context must be readable; exact menu composition is not locked by the board. | Entry confirmation leads to dialogue/briefing. | Main-menu route is implemented; this panel is only a visual first-impression anchor. |
| P02 `SCR_PREPARATION` | `preparation_scene` | Prepare fixed protagonist **Kwon Narae** for the monthly case. | Use known preparation information before field entry. The board’s pin/map shapes are decorative and do **not** approve a route-map system. | A committed preparation state leads to the investigation. | Preparation is a current core surface; its exact visual layout remains implementation-owned. |
| P03 `SCR_INVESTIGATION` | `investigation_scene` / current M04 `red_crossroads.png` consumer | Observe an anomalous location before naming the rule. | Environment, anomaly, evidence, narration, and 2–4 choices must make the decision legible without revealing the answer. | Fact/record/keyword or risk feedback flows to the Manual or further observation. | Investigation anchor and M04 visual consumer are current. The exact most-risky first-session choice remains a product-question, not an image claim. |
| P04 `SCR_ANOMALY_MANUAL` | `minigame_scene` / Manual surface | Construct a numbered inference sentence from acquired evidence. | Provenance, candidate keywords, slot state, and support/refute/unresolved context; no answer-salience styling. | A confirmed/refuted rule returns the player to rescue/recovery application. | Current Manual primary action is verified in canon; board paper marks are not canonical controls. |
| P05 `SCR_VICTIM_RESCUE_TO_RECOVERY` | consecutive `rescue` then `battle_scene` / Recovery family | Apply a known rule to protect a victim and respond to the next telegraph. | Phenomenon → telegraph → protected target → referenced rule → contextual response; stable attack/protect/support categories remain secondary. | Success/failure creates understandable rescue, cost, and observation feedback and carries into the composite result. | This is one combined flow panel, not a claim that rescue and recovery are one Scene. Exact tension timing remains a Grill-Me decision. |
| P06 `SCR_COMPOSITE_RESULT` | `result_scene` | Read the distinct consequences of the case and choose the next motive. | Victim state, confirmed rule/evidence, danger record, stabilization/aftereffect, unanswered question, and future relation/research must not collapse into one grade. | Composite record points back to preparation or the next case. | Composite Result is the current result authority; the board’s card design is not final runtime UI. |

## Visual grammar cross-check

- P01/P02 establish the institutional dossier language.
- P03 proves the environment-first Korean urban-noir + crimson anomaly contrast.
- P04 makes the record/manual layer tangible without replacing structured information.
- P05 tests that the same Kwon Narae/anomaly/environment grammar survives action pressure.
- P06 turns consequence into a record rather than a score-only reward.

## Review findings and correction

The first generated board showed an incorrect male investigator in the preparation panel. It was rejected and regenerated before durable storage. The stored board depicts Kwon Narae as the fixed female player protagonist. No system, character asset, or runtime content changed during that correction.

## Remaining validation

- Human/new-player evidence that the board’s intended first-session promise is actually understood: `NOT_RUN`.
- Consumer-specific runtime readability, UI composition, audio/VFX, accessibility, and production asset promotion: `NOT_RUN` or separately gated.
- The most consequential first-session tension choice is deliberately not decided by this visualization; resolve it in the next one-at-a-time Grill Me decision before implementation scope expands.
