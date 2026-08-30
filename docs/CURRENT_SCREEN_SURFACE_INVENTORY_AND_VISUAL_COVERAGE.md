# 괴이기록국 · Target Screen Surface Inventory & Visual Coverage

> Role: `CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_COVERAGE`
> Updated: `2026-08-27`
> Scope: `M01_FIRST_SESSION` + `M04_RED_UMBRELLA_30_TO_45_MIN_VERTICAL_SLICE`
> GitHub issue: `#309`
> Human-facing companion: Notion `03 · Systems · Flow · Data`, `04 · Visual · UX · Assets`, `06 · Production · Handoff`
> Asset lifecycle owner: `ASSET_MANIFEST.yml`; consumer/detail owner: `docs/CURRENT_VISUAL_ASSET_CONSUMER_CHECKLIST.md`

## 0. 권위와 읽기 경계

이 문서는 현재 목표 빌드의 **화면 단위** 인벤토리와 화면→시각 구성요소 coverage를 소유한다. 각 PNG의 승인·권리·승격·바이트 상태를 복제하거나 대체하지 않는다.

```text
현재 사용자 결정
→ latest main의 Scene / script / data / runtime capture
→ CURRENT_PLANNING_CANON + CURRENT_VISUAL_WORK_ORDER
→ 이 화면 coverage owner
→ ASSET_MANIFEST + CURRENT_VISUAL_ASSET_CONSUMER_CHECKLIST
→ Base coverage guide
```

Base latest completed main `7cfc75d607d1ed4d0f8323d4389e64da93df00c8`에서 요청된 `GAME_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_MATRIX.md`는 존재하지 않았다. 과거 파일을 현행 계약처럼 복원하지 않는다. 현행 `GAME_VISUAL_ASSET_COVERAGE_CHECKLIST.md`의 `ACTUAL_CONSUMER_REQUIRED`, `STATE_FAMILY_COMPLETENESS`, `NO_AUTOMATIC_IMAGE_GENERATION_FROM_GAPS`만 적용한다. 이는 Base 변경 요청이 아니라 프로젝트의 발견 기록이다.

## 1. 고정한 목표 빌드와 플레이 흐름

| 구분 | 현재 판정 |
|---|---|
| 현재 목표 build | M01 첫 세션(온보딩·회귀)과 M04 빨간 우산 30–45분 Vertical Slice |
| P0 must-play | Main Menu → Dialogue → Preparation → Investigation / Manual → Rescue Minigame → Recovery → Composite Result → Preparation 또는 Main Menu |
| P1 support | Case Data, Market, Daily Episode, Team / Record / Accessibility overlays |
| P2 | 기존 Annual PoC, 개발/Validation route, 본편 M02+ 확장, 출시/스토어 표면 |
| 플랫폼/입력 | PC 16:9, 1280×720 / 1920×1080, mouse + keyboard; gamepad/touch는 이번 Slice에 `NOT_APPLICABLE` |
| Evidence ceiling | Scene/script consumer와 자동 capture는 확인됨. Human/new-player/accessibility playtest는 모두 `NOT_RUN` |

### P0 흐름

```text
main_menu
→ dialogue_scene (사건 진입)
→ preparation_scene (팀·준비·출동)
→ investigation_scene (현장 관측 / Manual overlay)
→ minigame_scene (피해자 구출)
→ battle_scene (전조 기반 회수)
→ result_scene (복합 결과)
→ preparation_scene | main_menu
```

근거: `project.godot`, `scripts/core/afterlife_migrating_game_state.gd`, 각 `scripts/scenes/*.gd`의 실제 `change_scene_to_file` 경로. 이 flow는 새 화면을 설계한 것이 아니라 기존 runtime route의 현재 목적을 정리한 것이다.

## 2. Target Screen Inventory

`E`는 existing runtime/capture/approved reference, `C`는 coverage 판정이다. `SCREEN_DESIGN_REFERENCE`와 `RUNTIME_COMPONENT`는 의도적으로 분리한다.

| screen_id | family / name | priority | flow_entry → exit | player goal / first question | consumer surface / runtime consumer | E | C / blockers |
|---|---|---|---|---|---|---|---|
| `SCR-01` | A Main / Title | P0 | boot → start/continue → Dialogue | 무엇을 시작·이어갈까? | `main_menu.tscn` / `scripts/ui/main_menu.gd` | existing Godot menu; control-room reference | `COVERED_EXISTING`; main-menu mockup is reference only |
| `SCR-02` | D Dialogue / Event | P0 | menu/prep → investigation/prep | 지금 무엇을 관측·선택해야 하나? | `dialogue_scene.tscn` / `dialogue_scene.gd`; `ArtLayer/Background` | current scene route; M01/M04 background consumers | `COVERED_EXISTING`; M04 entrance candidate remains `REUSE_REVIEW`, not promoted |
| `SCR-03` | E Mission Preparation / HQ | P0 | dialogue/result → investigation/market/daily | 누구와 무엇을 준비해 출동할까? | `preparation_scene.tscn` / `preparation_scene.gd` | 1280/1920 existing capture | `COVERED_EXISTING`; live controls/text, character visual already consumed |
| `SCR-04` | D Investigation Field | P0 | prep/dialogue → manual/minigame/battle | 무엇이 사실이고 다음 관측은 무엇인가? | `investigation_scene.tscn` / `investigation_scene.gd`; `ArtLayer/Background`, `LocationPreview` | 1280/1920 captures; M01/M04 backgrounds | `COVERED_EXISTING`; M04 background runtime verified; Human QA pending |
| `SCR-05` | G Manual / Deduction Overlay | P0 | investigation ↔ investigation | 어떤 근거로 규칙 문장을 완성할까? | `investigation_scene` Manual surface / live Control layer | 1920 reasoning capture; `manual_book_frame.png` | `COVERED_EXISTING`; `NO_NEW_IMAGE_FILE_REQUIRED` |
| `SCR-06` | E Rescue Route Minigame | P0 | investigation → battle | 어떤 경로·순서로 피해자를 분리할까? | `minigame_scene.tscn` / `minigame_scene.gd` | 1280/1920 route capture; metal surface | `COVERED_EXISTING`; `NO_NEW_IMAGE_FILE_REQUIRED` |
| `SCR-07` | E Recovery / Telegraph Battle | P0 | rescue → result/investigation | 지금 전조에 어떤 현장 행동으로 대응할까? | `battle_scene.tscn` / `battle_scene.gd`; Background, AnomalyVisual, ActionDock | M01/M04 target-scene runtime checks at 1280×720 / 1920×1080 | M04 Recovery background and D cutout are `PROJECT_ASSET_APPROVED / IMPLEMENTED / RUNTIME_VERIFIED`; Human/accessibility/release QA remains pending |
| `SCR-08` | F Composite Result / Reward | P0 | recovery → prep/menu | 무엇이 구출·회수·기록에 남았나? | `result_scene.tscn` / `result_scene.gd` | 1280/1920 result capture; approved mockups | `COVERED_EXISTING`; mockups are `SCREEN_DESIGN_REFERENCE`, not product PNG |
| `SCR-09` | F Return / Next Step | P0 | result → prep/menu | 다음 준비를 할까, 돌아갈까? | `result_scene.gd` explicit return routes | scene transition evidence | `COVERED_EXISTING`; same Result surface, no separate image |
| `SCR-10` | G Case Data / Records | P1 | menu/prep → return route | 무엇을 이미 알고 있으며 무엇이 잠겼나? | `case_data_scene.tscn` / `case_data_scene.gd` | actual scene, records route | `COVERED_EXISTING`; no dedicated image requirement proven |
| `SCR-11` | F Market / Equipment Support | P1 | prep → prep | 어떤 지원 자원을 준비할까? | `market_scene.tscn` / `market_scene.gd` | actual route and live UI | `COVERED_EXISTING`; Godot UI/text first |
| `SCR-12` | F Daily Episode | P1 | prep → prep | 이 짧은 기록에서 무엇을 남길까? | `daily_episode_scene.tscn` / `daily_episode_scene.gd` | actual conditional route | `COVERED_EXISTING`; no separate visual consumer proven |
| `SCR-13` | H Settings / Accessibility | P1 | persistent overlay → prior surface | 읽기·소리·입력을 내게 맞출 수 있나? | `accessibility_settings.gd` + per-scene Settings controls | settings controls exist | `GAP_NONBLOCKING`: target Slice needs a focused runtime navigation/readability audit; no raster asset implied |
| `SCR-14` | G Team / Record / Help overlays | P1 | field/recovery → same scene | 상태·기록·규칙을 확인할 수 있나? | existing buttons and overlay builders | field/recovery captures | `COVERED_EXISTING`; manual/record are live UI/text |
| `SCR-15` | A Boot / Splash / Loading | P2 | application boot / scene handoff | 기다리는 이유를 알 수 있나? | no dedicated scene or loading consumer | `project.godot` starts Main Menu directly | `NOT_APPLICABLE`: no current player-facing loading surface |
| `SCR-16` | A Save Slot / Profile / Difficulty / Mode | P2 | main menu | 어떤 독립 campaign slot을 열까? | legacy/Validation routing only | main-menu source | `NOT_APPLICABLE`: no target Slice profile/difficulty selection surface |
| `SCR-17` | B Character Class / Deck / Start Bonus | P2 | pre-run setup | 어떤 build를 새로 고를까? | no current target consumer | current fixed protagonist/team constraints | `NOT_APPLICABLE`: team preparation exists, but no class/deck/start-bonus screen |
| `SCR-18` | C World Map / Node Map / Chapter Select | P2 | hub → case | 어디로 갈까? | no current target map scene | no runtime consumer | `NOT_APPLICABLE`: route-rescue board is a minigame, not world map |
| `SCR-19` | H Pause | P2 | gameplay → same scene | 멈추고 안전하게 복귀할까? | no dedicated pause surface | no scene/consumer found | `NOT_APPLICABLE`: Settings/HQ actions are present but pause UI is not current Slice scope |
| `SCR-20` | I Game Over / Retry / Checkpoint | P2 | terminal failure → recovery | 실패 이유와 재시도 경로는 무엇인가? | failure is recorded through existing Result/return paths | recovery/result sources | `NOT_APPLICABLE`: no separate game-over scene; result records failure-forward outcome |
| `SCR-21` | I Ending / Credits / Release Errors / Offline | P2 | release flow | 제품 종료·오류를 어떻게 알릴까? | no current release consumer | no runtime scene consumer | `NOT_APPLICABLE`: production/release scope |
| `SCR-22` | Q Dev / Validation / Annual PoC | P2 | developer-only route | 개발 검증을 어떻게 할까? | `scenes/poc/**`, menu validation routes | actual but isolated | `NOT_APPLICABLE`: not player-facing target Slice; preserve as technical evidence only |

## 3. Screen → Asset / Component Coverage Matrix

| screen_id | composition / first sight | runtime components and production mode | required states / variants | technical consumption / validation | coverage |
|---|---|---|---|---|---|
| `SCR-01` | logo, current-case identity, primary entry | `GODOT_UI`, `TEXT_LAYER`, existing case preview texture | normal/focus/disabled; compact hides preview below 1500×850 | 1280/1920; preview only non-compact | covered; no menu bitmap |
| `SCR-02` | location before narration and choice | Background `RASTER_IMAGE`, dialogue panels `GODOT_UI`, text `TEXT_LAYER` | M01/M04 episode variant, choices enabled/locked | 16:9 background, safe text zone; dialogue 1280/1920 | covered; M04 entrance comparison is pending |
| `SCR-03` | protagonist, current case, launch decision | portrait/character texture `EXISTING_APPROVED`, panels/buttons `GODOT_UI` | no case/selected case, schedule/launch unavailable, tabs | 1280/1920 capture; live Korean text | covered |
| `SCR-04` | environment → evidence → choice | Background `EXISTING_APPROVED`, location preview reuse, panels/HUD/manual `GODOT_UI` | field choice, record, risk/warning, HQ/settings, current episode | 16:9 + preview crop; M04 1280/1920 runtime evidence | covered |
| `SCR-05` | provenance / sentence slots / candidate keywords | paper frame `REUSE_PROJECT`, all copy/slot controls `GODOT_UI` + `TEXT_LAYER` | candidate/selected/locked; page navigation; focus | 1920 visual evidence; localizable text not baked | covered |
| `SCR-06` | rule/route board and current route consequence | metal panel `REUSE_PROJECT`, grid/path `PROCEDURAL_DRAW`/Godot UI, text `TEXT_LAYER` | selectable, invalid, target, warning, completion | 1280/1920 route capture; keyboard focus | covered |
| `SCR-07` | anomaly → next telegraph → protect target → action | Background / AnomalyVisual / optional cut-in `RASTER_IMAGE`; ActionDock, telegraph, HUD `GODOT_UI` | B/C/D risk, telegraph active, contextual action, normal/disabled/focus, success/failure | alpha cutouts; B/C keeps `KEEP_ASPECT_COVERED`, D defaults `KEEP_ASPECT_CENTERED`; 1280/1920 target-scene check | M04 Recovery background and D promoted/runtime verified; Human QA pending |
| `SCR-08/09` | multi-axis outcome then next action | panels/cards/buttons `GODOT_UI`, result text `TEXT_LAYER`; mockup `SCREEN_DESIGN_REFERENCE` | rescue/recovery/record outcome, return to prep/menu | 1280/1920 capture; no baked result sheet | covered |
| `SCR-10–14` | current question before secondary controls | existing panels/icons/text `GODOT_UI`, selective existing textures | selected/locked/empty/error/focus where consumer exposes it | source-level evidence; targeted runtime audit remains P1 | covered / P1 audit noted |

### Runtime Asset Family Queue

| asset_family_id | screens | actual consumer | role / states | mode | status |
|---|---|---|---|---|---|
| `AF-BG-ENTRANCE` | 01,02 | Main Menu, Dialogue `ArtLayer/Background` | entrance, episode variant | `REUSE_PROJECT` / `RASTER_IMAGE` | M04 candidate `REUSE_REVIEW`; no generation |
| `AF-BG-INVESTIGATION` | 04 | Investigation Background + LocationPreview | M01/M04 location | `EXISTING_APPROVED` | covered; M04 runtime verified |
| `AF-UI-MANUAL` | 05 | Investigation `ManualSurface` | textless paper surface | `REUSE_PROJECT` + live UI | covered |
| `AF-UI-ROUTE` | 06 | minigame full rect background | textless metal board | `REUSE_PROJECT` + procedural/live UI | covered |
| `AF-BG-RECOVERY` | 07 | Battle `ArtLayer/Background` | M01/M04 environment | `RASTER_IMAGE` | M04 promoted/runtime verified; no extra raster gap auto-created |
| `AF-ANOMALY-BC` | 07 | Battle `AnomalyVisual` | B/C transparent apparition | `EXISTING_APPROVED` | covered/runtime verified |
| `AF-ANOMALY-D` | 07 | Battle `AnomalyVisual` | D escalation transparent apparition | `RASTER_IMAGE` | M04 promoted/runtime verified; Human QA pending |
| `AF-REPRESENTATIVE` | 03,07 | preparation portrait; battle cut-in | limited character presence | `EXISTING_APPROVED` | covered; no broader portrait batch |

No asset family is added merely to decorate documentation. `SCR-01` UI, `SCR-05` text, `SCR-06` route lines, `SCR-08` result cards, and status feedback remain engine-rendered rather than image-generation requirements.

## 4. Screen Design Reference Queue

| screen_id | consumer surface | reference needed | existing anchor | required fidelity / validation | priority |
|---|---|---|---|---|---|
| `SCR-01` | Main Menu | no new reference | approved control-room reference + actual UI | maintain hierarchy at 1280/1920 | P0 |
| `SCR-04/05` | Investigation / Manual | no new reference | approved manual and current captures | preserve field-first / manual separate hierarchy | P0 |
| `SCR-06` | Rescue | no new reference | approved rescue reference + route capture | readable path/feedback at both targets | P0 |
| `SCR-07` | Recovery | no whole-screen image required | approved successor mockup + live target-scene checks; promoted `M04_ANOMALY_D_ADAPT_01` | Human review must confirm D does not overlap UI; no new full-screen image | P0 runtime verified / Human QA pending |
| `SCR-08` | Composite Result | reference refinement only | user-approved stages 1–2 | stage 3 remains in review; live UI stays source of runtime truth | P1 |
| `SCR-13` | Settings/accessibility | no image reference | live controls | focused navigation/readability test | P1 |

## 5. Correction Log

| current finding | correction | actual use / expected effect | verification |
|---|---|---|---|
| Asset-first checklist existed but no target screen owner | created this screen-first owner and linked existing asset owners | prevents a missing screen/overlay from being mistaken for an image count problem | latest main Scene/script route readback |
| Main-menu preview was previously described as compact | preserve current correction: preview is hidden below 1500×850 | M04 entrance comparison uses dialogue at 1280/1920 and preview at non-compact 1920 only | Issue #305 / PR #306 |
| Manual and rescue board could be mistaken for missing art | marked `NO_NEW_IMAGE_FILE_REQUIRED` with actual surface consumers | text/control/route remain editable and localizable | Issue #307 / PR #308; inspected captures |
| M04 Recovery D role was not met by current/fallback image | exact RGBA single-umbrella candidate promoted to the existing D cutout route with a consumer-specific no-crop default | removes ordinary-person/multi-figure ambiguity without replacing the fallback or player layout preference | candidate/canonical SHA equality and 1280×720 / 1920×1080 target-scene test; Human QA pending |
| Base screen-inventory subordinate contract is absent from current Base main | recorded fact without restoring historical Base content | avoids silently treating old guidance as authority | Base `7cfc75d` path readback |

## 6. Codex Implementation Handoff

Use this document with `CURRENT_VISUAL_WORK_ORDER.md`, `CURRENT_VISUAL_ASSET_CONSUMER_CHECKLIST.md`, and `ASSET_MANIFEST.yml`; do not use it to promote an asset or invent a screen.

```yaml
approved_scope:
  - Preserve M01/M04 common screen grammar and current Scene routes.
  - Prefer Godot Control/Theme/Text/Procedural layers for dynamic UI.
  - Use existing approved runtime assets at their current consumers.
non_goals:
  - No full-screen mockup bitmap as UI.
  - No new image from a coverage gap.
  - No Human QA or product-asset approval inference.
remaining_visual_gate:
  screen_id: SCR-07
  issue: M04 Recovery promoted-asset human readability and occlusion review
  consumer: scenes/battle_scene.tscn -> ArtLayer/Background; CinematicStage/AnomalyPanel/Content/AnomalyVisual
  acceptance: human review at 1280x720/1920x1080 confirms the background, D umbrella, telegraph, and ActionDock remain mutually readable; release-rights is a separate review
  current_status: PROJECT_ASSET_APPROVED / IMPLEMENTED / RUNTIME_VERIFIED / HUMAN_QA_PENDING
godot_validation:
  - Start from the exact target Scene route, not a fabricated mockup.
  - Check 1280x720 and 1920x1080, mouse/keyboard focus, selected/disabled/warning states.
  - Record actual captures/logs; keep Human QA as NOT_RUN.
```

## 7. Five adversarial readback loops

| loop | attack | outcome |
|---|---|---|
| 1 Screen completeness | Did P0 omit title, core gameplay, result, or settings applicability? | all recorded; settings is P1, pause is explicit N/A |
| 2 Player judgment | Does each P0 surface have an entry, question, decision, exit? | yes; rows 01–09 answer these fields |
| 3 State / feedback | Are manual/route/recovery outcomes treated as a single static image? | corrected to live UI/state families; D is isolated |
| 4 Over-production | Did a coverage gap become an automatic image queue? | no; only existing consumer D remains a blocked requirement |
| 5 Canonical realism | Do Notion, repository docs, actual consumers, and historical captures disagree? | system-record Home is excluded; human Home/domain pages and latest main are the current destinations; historical flow docs are not used as runtime authority |

## 8. Remaining Work

```yaml
blocking_gap:
  - M01 Entrance remains candidate-only and needs its exact Dialogue plus non-compact preview comparison.
  - M04 Recovery background and D AnomalyVisual need Human/accessibility and release-rights review; their product promotion and automated target-scene evidence are complete.
nonblocking_gap:
  - SCR-13 focused settings/accessibility runtime navigation and readability evidence.
  - Composite Result reference stage 3 remains in review; it is not a product PNG requirement.
user_decision_required:
  - No product-promotion decision remains for M04 Recovery background or D under the approved current implementation. Human/release review remains a separate evidence gate.
codex_implementation_required:
  - Complete the M04 campaign, preparation, and result implementation contract; promotion itself no longer requires a separate task.
image_brief_approval_required:
  - Complete for M01 Entrance, M04 Recovery background, and M04 D: the 2026-08-28 user request authorized their bounded candidates.
runtime_player_validation:
  - Existing automated captures reused; Human/new-player/accessibility playtest remains NOT_RUN.
```

`CLEAN_COVERAGE_EXIT` applies to the target-build inventory and preparation state only. It does not claim release completion, M04 D resolution, Human QA, or production expansion.
