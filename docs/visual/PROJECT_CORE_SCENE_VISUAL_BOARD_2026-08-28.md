# 괴이기록국 · Project Core Scene Visual Board · 2026-08-28

> Role: `PROJECT_CORE_SCENE_VISUAL_BOARD`
> Board file: `docs/visual/boards/PROJECT_CORE_SCENE_VISUAL_BOARD_2026-08-28.png`
> Status: `USER_APPROVED_VISUAL_DIRECTION / GENERATED_EXPLORATION / PLANNING_REVIEW`
> Classification: `GENERATED_EXPLORATION / NOT_PROJECT_ASSET / NOT_RUNTIME_ASSET`
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
| P02 `SCR_PREPARATION` | `preparation_scene` / planned M04 dispatch docket | Prepare fixed protagonist **Kwon Narae** for the monthly case. | For M04 only, compare week 2 early `+0` / tier 0, week 3 early `+15` / tier 1, and week 4 regular `+30` / tier 2 before confirmation. `+15/+30` are victim route-memory exposure, not delay punishment. The board’s pin/map shapes are decorative and do **not** approve a route-map system. | A committed dispatch state leads to the investigation; week 4 is a normal entry, not a forced acknowledgement. | M04's early/regular timing flow is canon. Its exact runtime layout, exposure consumer, and controls remain implementation-owned. |
| P03 `SCR_INVESTIGATION` | `investigation_scene` / current M04 `red_crossroads.png` consumer | Observe an anomalous location before naming the rule. | Environment, anomaly, evidence, narration, and 2–4 choices must make the decision legible without revealing the answer. | Fact/record/keyword or risk feedback flows to the Manual or further observation. | Investigation anchor and M04 visual consumer are current. M04 dispatch timing is locked separately; the board does not render its exact control. |
| P04 `SCR_ANOMALY_MANUAL` | `minigame_scene` / Manual surface | Construct a numbered inference sentence from acquired evidence. | Provenance, candidate keywords, slot state, and support/refute/unresolved context; no answer-salience styling. | A confirmed/refuted rule returns the player to rescue/recovery application. | Current Manual primary action is verified in canon; board paper marks are not canonical controls. |
| P05 `SCR_VICTIM_RESCUE_TO_RECOVERY` | consecutive `rescue` then `battle_scene` / Recovery family | Apply a known rule to protect a victim and respond to the next telegraph. | Phenomenon → telegraph → protected target → referenced rule → contextual response; stable attack/protect/support categories remain secondary. | Success/failure creates understandable rescue, cost, and observation feedback and carries into the composite result. | This is one combined flow panel, not a claim that rescue and recovery are one Scene. M04 tier 0/1/2 changes only Kwon Narae's active `귀가 기억 고정` stability effect (`+0/+4/+8`) when the player uses it; this board does not approve the runtime control. |
| P06 `SCR_COMPOSITE_RESULT` | `result_scene` / planned M04 logical-page sequence | Read the distinct consequences of the case and choose the next motive. | Victim state, confirmed rule/evidence, danger record, stabilization/aftereffect, unanswered question, future relation/research, and M04 timing causality must not collapse into one grade or one dashboard. | M04 reads `피해자 → 잔향 → 귀가 기억 → 기록국` as short sequential after-stories. The route-memory page distinguishes week 2 early, week 3 early, and week 4 regular timing with support-used/unused before it points back to preparation or the next case. | Composite Result is the current result authority; the board’s card design is not final runtime UI and its single panel does not approve one runtime result page. |

## Visual grammar cross-check

- P01/P02 establish the institutional dossier language.
- P03 proves the environment-first Korean urban-noir + crimson anomaly contrast.
- P04 makes the record/manual layer tangible without replacing structured information.
- P05 tests that the same Kwon Narae/anomaly/environment grammar survives action pressure.
- P06 turns consequence into a sequence of records rather than a score-only reward.

## Review findings and correction

The first generated board showed an incorrect male investigator in the preparation panel. It was rejected and regenerated before durable storage. The stored board depicts Kwon Narae as the fixed female player protagonist. No system, character asset, or runtime content changed during that correction.

## Remaining validation

- Human/new-player evidence that the board’s intended first-session promise is actually understood: `NOT_RUN`.
- Consumer-specific runtime readability, UI composition, audio/VFX, accessibility, and production asset promotion: `NOT_RUN` or separately gated.
- M04’s two early-dispatch windows, regular week-4 baseline, and route-memory preparation tiers are decided. Runtime UI, target-resolution readability, balance, and Human/new-player validation remain separately gated before implementation scope expands.
