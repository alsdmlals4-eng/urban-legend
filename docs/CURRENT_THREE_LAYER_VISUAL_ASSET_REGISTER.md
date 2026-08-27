# 괴이기록국 · Three-Layer Visual Asset Register

> Role: `CURRENT_THREE_LAYER_VISUAL_ASSET_REGISTER`  
> Updated: 2026-08-28  
> Issue: #315  
> Scope: M01 first session + M04 30–45 minute vertical slice  
> Runtime authority: latest `main` Scene/script/catalog and `ASSET_MANIFEST.yml`  
> Screen authority: `CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_COVERAGE.md`  
> Candidate authority: `CURRENT_VISUAL_ASSET_CONSUMER_CHECKLIST.md`

## 1. Completion rule

Visual work has three independent deliverable layers. A record in one layer never completes another.

| layer | purpose | completion evidence | current rule |
|---|---|---|---|
| `RUNTIME_IMAGE` | A player-visible or engine-consumed visual component | actual Godot consumer exists, exact source is present, and required runtime capture/import evidence is recorded | candidate-only bytes do not complete this layer |
| `PRODUCTION_VISUAL_REFERENCE` | A durable art/UX production rule used by people and AI | Notion + repository owner, consumer/variant specification, and an approved reference or reusable live evidence | concept sheets are not substituted for runtime files |
| `RELEASE_PROMOTION_IMAGE` | Store, capsule, icon, key-art, and platform screenshot output | target platform/specification, provenance/rights, final pixel requirements, and release-ready review | runtime screenshots do not become store assets automatically |

## 2. Actual runtime image audit

`scripts/ui/ui_asset_catalog.gd` declares **51** explicit `res://assets/...` raster paths. A 2026-08-28 exact-path filesystem read found **51/51 present; 0 missing**. The direct scene/script texture references resolve to the same runtime families. Therefore no current runtime image file is absent merely because the broader generic game checklist contains additional genre possibilities.

| family | target screens | actual consumer | states / variants | expression | current evidence / status |
|---|---|---|---|---|---|
| `AF-BG-ENTRANCE` | SCR-01, SCR-02 | Main Menu + Dialogue `ArtLayer/Background` + preview | M01/M04 location variant | `PNG` background | existing product files; M01 Adapt 02 and M04 Adapt 01 remain separate candidates |
| `AF-BG-INVESTIGATION` | SCR-04 | Investigation background + `LocationPreview` | M01/M04 location variant | `PNG` background | M01/M04 product assets runtime verified; Human QA pending |
| `AF-BG-RECOVERY` | SCR-07 | Battle `ArtLayer/Background` | M01/M04 environment | `PNG` background | M01 product asset verified; M04 Adapt 02 candidate only |
| `AF-ANOMALY` | SCR-07 | `AnomalyVisual` B/C/D | risk stage B/C/D, fallback/full and cutout paths | `PNG`, RGBA cutout where required | B/C product assets verified; M04 D candidate only |
| `AF-AGENT` | SCR-03, SCR-04, SCR-07, support UI | catalog agent/contact textures | portrait, full body, investigation support, recovery support, HQ contact as exposed | `PNG` | all catalog paths present; state expansion is limited to actual runtime consumers |
| `AF-LEGACY-AGENT` | existing menu/dialogue support | expression and cutout sheets | current scripted expression/cutout use | `PNG` sheets | all declared paths present |
| `AF-UI-SURFACE` | SCR-05, SCR-06, SCR-10–14 | Manual frame, metal panel, route tile, log icons | normal/focus/warning or procedural state | `PNG` + Godot Control/Theme/line drawing | all declared paths present; dynamic text/button states remain engine-rendered |
| `AF-TECHNICAL` | current target build | `.import` outputs, alpha cutouts, font atlas inputs | import/alpha/font use | Godot import/resource | no missing declared texture path; any new mask/LUT/noise requires a future material consumer |

### Candidate-only runtime-family gaps

| asset family | target screen | existing product source remains | candidate file | status | next completion gate |
|---|---|---|---|---|---|
| M01 entrance | SCR-01/02 | `assets/backgrounds/afterlife_entrance.png` | `M01_ENTRANCE_BACKGROUND_ADAPT_02_20260828.png` | `USER_AUTONOMOUSLY_AUTHORIZED_VISUAL_CANDIDATE / PRODUCT_ASSET_PROMOTION_PENDING` | shared main-menu, dialogue, and preview comparison |
| M04 recovery | SCR-07 | `assets/backgrounds/red_recovery.png` | `M04_RECOVERY_BACKGROUND_ADAPT_02_20260828.png` | `USER_AUTONOMOUSLY_AUTHORIZED_VISUAL_CANDIDATE / PRODUCT_ASSET_PROMOTION_PENDING` | composited background + anomaly + ActionDock comparison |
| M04 anomaly D | SCR-07 | `assets/anomalies/cutouts/red_umbrella_d_cutout.png` | `M04_ANOMALY_D_ADAPT_01.png` | `USER_AUTHORIZED_VISUAL_CANDIDATE / PRODUCT_ASSET_PROMOTION_PENDING` | alpha, target-size, and telegraph readability comparison |

## 3. Screen-surface register

The screen owner already contains the canonical screen list. This register normalizes every target surface to the mandatory tracking fields requested for visual production.

| screen_id | screen_family / name | stage / priority | flow entry → exit | player goal / first question | consumer_kind | actual surface / runtime consumer | design reference and current coverage | blockers |
|---|---|---|---|---|---|---|---|---|
| SCR-01 | A Main / Title | Slice / P0 | boot → dialogue | start or continue? | `GAME_RUNTIME` | `main_menu.tscn`, `main_menu.gd` | approved control-room direction + live UI; `COVERED_EXISTING` | candidate entrance comparison only |
| SCR-02 | D Dialogue / Event | Slice / P0 | menu/prep → investigation/prep | what should I observe or choose? | `GAME_RUNTIME` | `dialogue_scene.tscn`, `ArtLayer/Background` | location backgrounds + Godot panel/text; `COVERED_EXISTING` | M01 candidate and M04 entrance review remain separate |
| SCR-03 | E Mission Preparation / HQ | Slice / P0 | dialogue/result → field support | who and what is prepared? | `GAME_RUNTIME` | `preparation_scene.tscn` | existing agent family + live UI; `COVERED_EXISTING` | Human QA pending |
| SCR-04 | D Investigation / Manual | Slice / P0 | prep/dialogue → manual/minigame/battle | what is fact and the next observation? | `GAME_RUNTIME` | `investigation_scene.tscn`, preview, Manual overlay | approved backgrounds, paper frame, Godot text; `COVERED_EXISTING` | Human QA pending |
| SCR-05 | E Rescue Route | Slice / P0 | investigation → recovery | which route safely separates victims? | `GAME_RUNTIME` | `minigame_scene.tscn` | metal board + procedural route + Godot UI; `COVERED_EXISTING` | Human QA pending |
| SCR-06 | E Recovery / Telegraph Battle | Slice / P0 | rescue → result/investigation | which contextual response handles the omen? | `GAME_RUNTIME` | `battle_scene.tscn`, Background/AnomalyVisual/ActionDock | raster environment/anomaly + live telegraph; `COVERED_EXISTING` | three candidate promotion comparisons |
| SCR-07 | F Composite Result / Return | Slice / P0 | recovery → prep/menu | what was rescued, recovered, and recorded? | `GAME_RUNTIME` | `result_scene.tscn`, `result_scene.gd` | approved result references + live UI; `COVERED_EXISTING` | stage-3 reference refinement |
| SCR-08 | G Records, Market, Daily, Team/Help | Slice / P1 | secondary → return | what do I know or prepare? | `GAME_RUNTIME` | existing P1 scenes/overlays | existing UI/text and selective textures; `COVERED_EXISTING` | focused audit where a live surface exposes a gap |
| SCR-09 | H Settings / Accessibility | Slice / P1 | persistent overlay → prior surface | can I read, hear, and control this? | `GAME_RUNTIME` | settings controls in scene scripts | `GODOT_UI`, no raster implied | focused 1280/1920 navigation/readability evidence |
| SCR-10 | A/I boot, profiles, pause, failure, ending, release error | outside slice / P2 | N/A | N/A | `PLANNED_GAME_SURFACE` | no current target consumer | `NOT_APPLICABLE`, not a missing image | requires a new player-facing product scope first |

## 4. Production visual-reference coverage

| production deliverable | repository owner | Notion destination | coverage | creation boundary |
|---|---|---|---|---|
| visual language / palette / hierarchy | `docs/VISUAL_ANCHOR_SPEC.md`, visual decisions | `04 · Visual · UX · Assets` | `COVERED_FRAGMENTED` | consolidate only from approved current anchors; do not invent a new art direction |
| screen flow / entry / exit / player question | `docs/M01_M04_VERTICAL_SLICE_FLOW.md`, screen inventory | `03 · Systems · Flow · Data` | `COVERED` | diagrams remain explanatory unless adopted by a runtime tutorial |
| runtime consumer and variant matrix | this register + asset consumer checklist | `04 · Visual · UX · Assets` | `COVERED` | update from Scene/catalog facts only |
| character family reference | `assets/characters/mvp043/ASSET_MANIFEST.json` plus current family files | `04 · Visual · UX · Assets` | `COVERED_FOR_CURRENT_CONSUMERS` | a new expression/pose sheet is created only when a scene/data state requests it |
| M01/M04 candidate receipts | `docs/visual/candidates/*.md` | native image attachments on `04 · Visual · UX · Assets` | `COVERED` | candidate bytes never overwrite approved product paths |
| screen design reference | approved mockups + real captures | `04 · Visual · UX · Assets` | `PARTIAL_FOR_RESULT_STAGE_3` | must not be baked as a runtime full-screen bitmap |

## 5. Release and promotion coverage

| release deliverable | current status | reason it is not runtime-complete | future completion definition |
|---|---|---|---|
| wordmark / logo lockup | `PLANNED_NOT_CREATED` | no store/launcher consumer currently exists | approved vector/raster lockups with font/rights record |
| application icon | `PLANNED_NOT_CREATED` | no shipping platform target or icon specification is in the Slice | platform-specific required sizes and alpha/safe-area validation |
| key art | `PLANNED_NOT_CREATED` | no announced campaign/store target | approved composition plus rights/provenance and title-safe variants |
| PC store capsule / thumbnail | `PLANNED_NOT_CREATED` | no storefront specification or target dimensions are current authority | exact storefront size family, localized logo layer, review-ready exports |
| store screenshots | `PLANNED_NOT_CREATED` | runtime promotion candidates are not release screenshots | captured from release-near target build, without debug/UI defects |
| social/banner derivatives | `PLANNED_NOT_CREATED` | dependent on key art and channel specification | channel-specific crop and readable brand treatment |

`PLANNED_NOT_CREATED` is intentionally not counted as a missing current runtime image. These outputs must be produced when a release platform and campaign scope are chosen; otherwise speculative images create incompatible dimensions, text, rights, and brand commitments.

## 6. Remaining work, ordered by evidence

1. Run candidate promotion comparisons for M01 entrance, M04 recovery background, and M04 D only after opening the exact actual Godot consumers.
2. Capture the P1 settings/accessibility navigation and readability audit at 1280×720 and 1920×1080.
3. Consolidate the existing approved art anchors into the human-facing Visual Bible page without changing runtime or product asset status.
4. Begin the release-promotion asset package only after the shipping platform/specification is part of the approved project scope.

## 7. Anti-drift checks

- Do not manufacture sprite, tile, weapon, inventory, combat, or FX families merely because a genre-generic checklist names them. A Scene/node/resource/data consumer must first exist.
- Do not classify `StyleBoxFlat`, Theme, text, procedurally drawn route lines, focus rings, warning colors, or telegraph state as missing PNG files.
- Do not count a planning board, a Notion visual reference, or a store key art as runtime proof.
- Do not count a candidate as a promoted product asset or a Human QA pass.
