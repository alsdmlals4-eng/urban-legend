# 괴이 기록국 · AI Production Specification

> Artifact role: `PROJECT_AI_PRODUCTION_SPEC`
> Version: `2026-08-28`
> Status: `CURRENT / REPOSITORY_ONLY_CANON / IMPLEMENTATION_CONTRACT_PENDING`
> Baseline main: `11876dd851a614e9475033c38486b2085894126c` (`docs: lock M04 narrative result vignettes`)
> Scope: project truth, player-experience contract, design verification, production boundary
> Excludes: runtime/code/Scene/asset production, balance finalization, Human QA PASS

## 00. How to read this document

This is the repository-owned master GDD for humans and AI workers. It distinguishes a decision from an implementation and an automated check from a player validation.

| status | meaning |
| --- | --- |
| `CONFIRMED` | user-approved product or workflow decision |
| `IMPLEMENTED` | present in latest-main code/data/Scene |
| `AUTOMATED_TEST_PASS` | a named automated check was run against a stated commit |
| `RUNTIME_VERIFIED` | an actual runtime consumer was observed at a stated target |
| `HUMAN_QA_NOT_RUN` | no human/player evidence; never infer a pass |
| `SUPERSEDED` | historical only; do not use as a current requirement |
| `UNKNOWN` | no verified source is available; do not invent it |

The direct user instruction prevails over an attached work instruction. `PROJECT_MASTER_GDD_TWO_ARTIFACT_WORK_INSTRUCTION_20260828.md` supplied a useful two-artifact format; its Notion and no-automatic-image directives are not current authority.

## 01. Current source registry

| class | source | current use |
| --- | --- | --- |
| `CURRENT` | `AGENTS.md`, `docs/CURRENT_PLANNING_CANON.md`, `docs/current-planning-canon.json`, `docs/CURRENT_DECISION_OVERLAY.md`, `docs/CURRENT_HANDOFF.md` | current project rules, decision, state, handoff |
| `CURRENT` | `docs/decisions/D-2026-08-28-TEN-DAY-HALF-DAY-CASE-CADENCE.md` | 10-day / half-day calendar |
| `CURRENT` | `docs/decisions/D-2026-08-28-M04-SEQUENTIAL-NARRATIVE-RESULT-VIGNETTES.md` | M04 result presentation |
| `CURRENT` | `docs/decisions/D-2026-08-28-URBAN-NOIR-HYBRID-VISUAL-DIRECTION.md`, `docs/visual/VISUAL_DIRECTION_LOCK_PACKET_2026-08-28.md` | visual grammar |
| `CURRENT` | `docs/decisions/D-2026-08-28-VISUAL-CANDIDATE-GENERATION-LOCK-ONLY-APPROVAL.md` | image candidate workflow |
| `CURRENT` | `docs/decisions/D-2026-08-28-REPOSITORY-ONLY-PROJECT-CANON.md` | workspace ownership |
| `CURRENT` | `scripts/core/campaign_state.gd`, `scripts/scenes/preparation_scene.gd`, `scripts/scenes/result_scene.gd`, `scripts/scenes/battle_scene.gd` | actual runtime evidence |
| `CURRENT` | `data/episodes/episode_002_red_umbrella_alley.json`, `data/episodes/episode_002_red_umbrella_alley_validation_map.json` | actual M04 content/data boundary |
| `CURRENT` | `ASSET_MANIFEST.yml`, visual consumer/checklist documents | asset owner and actual consumer boundary |
| `HISTORICAL_READ_ONLY` | existing Notion pages + `docs/migrations/NOTION_CURRENT_WORK_MIGRATION_2026-08-28.md` | prior planning/reference is migrated and indexed in-repository; Notion itself has no write/readback destination |
| `HISTORICAL` | `ANNUAL-MVP-*`, 4-week/7-day documents, `monthly_state_policy.gd` week risk values | regression/provenance only |
| `SUPERSEDED` | `D-2026-08-28-M04-EARLY-DISPATCH-REGULAR-WEEK4-CADENCE` numeric windows | old 2/3/4-week and `0/15/30`, `0/+4/+8`; do not map to days |
| `UNKNOWN` | new timing numeric balance, Day-10 UI/save/result implementation, M04 timing Human QA | requires a later implementation contract and validation |

Repository is the sole source of truth. Notion and Google Sheet are `HISTORICAL_READ_ONLY_NO_WRITE` / migration-only. The current Notion structure, work-product disposition, and seven Notion-only reference files are preserved by `docs/migrations/NOTION_CURRENT_WORK_MIGRATION_2026-08-28.md`. All future write/readback occurs through repository commit, GitHub remote, and exact commit evidence.

## 02. Canon snapshot

```yaml
project: 괴이 기록국 / urban-legend
engine: Godot 4.7, GDScript
platform: PC 16:9
input: mouse + keyboard
protagonist: 권나래
institution: 괴이 기록국
guide: 기록관 아카
case rule: investigate → infer rule → rescue victim → stabilize/recover anomaly → record composite result
calendar: 10 days × 2 half-day slots
main case: 1 resolved per cycle
early: Day 1 through Day 9
regular: Day 10
first session: M01 저승역
release-near slice: M04 빨간 우산 (30–45 min target)
visual direction: Korean urban noir environment + soft-anime people/anomalies + hand-drawn institutional dossier UI
```

### Current Work 5-stage position

| stage | state | evidence ceiling |
| --- | --- | --- |
| 1. Direction / product promise | `CONFIRMED` | M01/M04 role documents and user decisions |
| 2. Core systems / content contract | `PARTIAL` | shared runtime exists; 10-day timing consumer absent |
| 3. Visual direction / screen grammar | `CONFIRMED` | user visual lock; planning board only |
| 4. Production implementation | `PARTIAL` | M01 and M04 shared baseline implemented; new cadence/result pages not implemented |
| 5. Player validation / production expansion | `NOT_RUN` | Human/new-player/accessibility evidence absent |

## 03. Player promise and core experience

### Player promise

**“나는 권나래로서, 시간이 지나기 전에 사람을 보호하되 준비를 포기하지 않고, 눈으로 확인한 근거로 괴이의 규칙을 밝혀 그 현상을 죽이지 않고 안정화·회수한다.”**

```text
Player Promise
→ 10일·반일을 준비하고 출동 시점을 정한다
→ 관측과 해석을 나누고 경쟁 가설을 비교한다
→ 피해자를 먼저 현상에서 분리한다
→ 전조에 맞는 대응으로 잔향을 안정화·회수한다
→ 사람·현상·기록에 남은 서로 다른 결과를 읽는다
→ 다음 cycle에서 더 나은 보호와 판단을 시도한다
```

| connection | intended experience | current state |
| --- | --- | --- |
| representative action | 관찰한 단서를 매뉴얼 가설·구출·회수 선택에 재사용한다 | `IMPLEMENTED` shared grammar |
| meaningful choice | Day 1–9 조기 보호 vs Day 10 정규 해결까지 준비 기회 사용 | `CONFIRMED / NOT_IMPLEMENTED` as a visible contract |
| observable outcome | 피해자 상태, 잔향 상태, 귀가 기억 timing, 기록/연구가 서로 덮어쓰이지 않는다 | result data partly `IMPLEMENTED`; new timing axis `NOT_IMPLEMENTED` |
| reward / failure learning | 매뉴얼·위험 사례·연구가 다음 판단에 남고, 오답은 관측 가능한 반증으로 설명된다 | `PARTIAL` runtime/data; player validation `NOT_RUN` |
| target emotion | 조용한 책임감, 규칙을 알아낸 안도, 피해자를 너무 늦기 전에 지켰다는 기억 | `CONFIRMED`; Human evidence `NOT_RUN` |
| next-action motive | 남은 반일을 후일담·치료·연구·관계·다음 사건 준비에 쓴다 | `CONFIRMED`; calendar flow `NOT_IMPLEMENTED` |
| differentiation / sales hook | 한국 도시의 생활감 있는 괴담을 “처치”가 아니라 증거 기반 보호·기록·안정화로 끝낸다 | `CONFIRMED`; market validation `NOT_RUN` |

### Core fun check

The pointed fun is not “many menus” or “a combat result.” It is the short causal chain in which the player sees a troubling urban detail, chooses what it means, risks an early rescue or uses the calendar to prepare, and later reads a human consequence that does not collapse into a single grade.

**Risk hypothesis to validate in M04:** Does the player feel the pressure to protect the victim early while still valuing preparation, and can they explain why their evidence and recovery decisions caused the ending? This is `UNTESTED`.

## 04. Loop contract

### Core loop — `CONFIRMED`

```text
Prepare a half-day
→ notice a case symptom / choose a case timing
→ investigate observable evidence
→ compare hypotheses in the anomaly manual
→ apply the rule to victim rescue
→ read telegraphs and stabilize/recover resonance
→ read composite result
→ update manual, research, relationship, and next preparation
```

### Session loop — M01 / M04

| phase | player question | player action | feedback |
| --- | --- | --- | --- |
| preparation | “What can I do before I go?” | schedule, select team/case | remaining time, active preparation, case availability |
| investigation | “What did I actually observe?” | choose observation/analysis/protection method | clue, flag, hint, explicit success/failure text |
| deduction/manual | “Which rule has evidence, and what still contradicts it?” | compare support/rebuttal/unresolved slots | readable evidence state, not an auto-answer |
| rescue | “How do I apply the rule to protect this person?” | rule-based rescue interaction | victim result remains separate |
| recovery | “Which telegraph demands which response now?” | choose protection/support/contextual response | anomaly stability, support feedback, recovery result |
| result | “What happened to the person, phenomenon, memory, and record?” | advance one narrative page at a time | causal, non-scoreboard ending |

### Meta loop — `PARTIAL`

Records, research, agent support, and relationships should widen safe questions and response options without revealing the hidden truth. Current detailed long-term rank/economy values are provisional/historical. The live target is **not** a fully proven progression loop yet.

## 05. System registry

| ID | system | player value | state / owner |
| --- | --- | --- | --- |
| `SYS-CAL-01` | 10-day / half-day calendar | clear preparation opportunity and protection timing | `CONFIRMED`; structural calendar in `campaign_state.gd`; timing product consumer `NOT_IMPLEMENTED` |
| `SYS-INV-01` | evidence-led investigation | read a situation before choosing a method | `IMPLEMENTED` shared scene/data grammar |
| `SYS-DED-01` | anomaly manual / competing hypotheses | prove a rule instead of selecting a lucky answer | `IMPLEMENTED` shared grammar; Human clarity `NOT_RUN` |
| `SYS-RES-01` | victim rescue | make the human cost primary | `IMPLEMENTED` data/runtime baseline |
| `SYS-REC-01` | telegraph-first stabilization/recovery | turn knowledge into tense but legible action | `IMPLEMENTED` baseline |
| `SYS-RESULT-01` | composite result | preserve independent human/phenomenon/evidence outcomes | `IMPLEMENTED` current scroll result; M04 vignette successor `NOT_IMPLEMENTED` |
| `SYS-M04-02` | sequential narrative vignettes | make consequences memorable, one cause at a time | `CONFIRMED / NOT_IMPLEMENTED` |
| `SYS-META-01` | records/research/relationship feedback | motivate another cycle without auto-solving cases | `PARTIAL` |
| `SYS-VIS-01` | visual direction lock | make evidence readable and identifiable as this game | `CONFIRMED`; runtime coverage partial |

### Explicit non-systems / guardrails

- Anomaly is not an enemy to defeat with HP/attack-centric combat.
- Growth, agents, equipment, or Aka do not reveal core truth or an unobserved pattern automatically.
- A single S/A/B grade cannot overwrite the composite result.
- A generated board or candidate is never an automatic runtime asset.
- Day 10 is not a disguised failure condition.

## 06. Content registry

| ID | content role | current evidence | state |
| --- | --- | --- | --- |
| `CNT-M01` | Afterlife Station, first complete learning case | episode `episode_001_afterlife_station`; M01 packets | `IMPLEMENTED / AUTOMATED_REGRESSION_GREEN` provenance; Human QA `NOT_RUN` |
| `CNT-M04` | Red Umbrella Alley, release-near player-experience slice | `episode_002_red_umbrella_alley.json` | shared baseline `IMPLEMENTED`; timing/vignettes `NOT_IMPLEMENTED` |
| `CNT-M07` | Dead Frequency Station | campaign case ID list | `PARTIAL / not evaluated this session` |
| `CNT-SLATE` | M01–M12 initial case slate, M13+ continuation | current planning canon | `CONFIRMED` as content budget, not a year-completion gate |

### M04 verified content facts

- Three required clues currently name the red umbrella fabric, repeating alley sign, and reverse rain flow.
- The investigation includes observation, analysis, and destructive/suppression approaches with explicit successes/failures.
- The rescue/recovery adapter names the protected subject `victim_alley_witness`.
- Existing result data already distinguishes temporary/standard/complete recovery outcomes.
- The M04 validation map lists six generic composite-result axes and still marks final visuals as pending; it does not yet own a timing axis.

## 07. 10-day calendar specification

### Confirmed rules

```text
Cycle: 10 days
Day: morning + afternoon
Main case: exactly one resolved per cycle
Early resolution: Day 1–9
Regular resolution: Day 10
After early resolution: no second main case; use remaining half-days for aftermath/preparation
```

### What the player must understand before confirming

1. current day and morning/afternoon slot;
2. whether this is early or regular resolution;
3. remaining half-day opportunities;
4. the concrete protected-person / preparation trade-off;
5. that Day 10 is normal, not a penalty;
6. what consequence will be recorded later.

### Intentionally unresolved balance decision

The old M04 values `0/15/30` exposure and `0/+4/+8` stability gain were superseded. No day-based replacement exists. The future implementation contract must choose one of at least three genuinely different balance models and user-lock the selected one:

| option | player value | production / risk | disposition now |
| --- | --- | --- | --- |
| A. narrative-only timing record | clearest, no fake math | may make early/regular feel too soft | `TEST` |
| B. bounded preparation capacity | a visible fewer-slots vs more-slots trade-off | needs data/save/UI clarity; no answer leakage | `RECOMMENDED FOR GRILL ME` |
| C. victim-memory condition band | strong human consequence | needs careful copy so Day 10 does not read as punishment | `TEST` |

No option is implemented or approved as a numeric contract.

## 08. M04 result-vignette specification

M04 must avoid a single dense result page. The intended logical pages are not new Godot Scenes yet.

| page ID | player learns | required input | prohibited shortcut |
| --- | --- | --- | --- |
| `VIGNETTE_VICTIM_RESCUE` | what happened to the victim | existing rescue result / after-story | overwriting it with recovery grade |
| `VIGNETTE_RESONANCE_RECOVERY` | what happened to the anomaly/resonance | existing recovery state | treating the victim as an enemy-health outcome |
| `VIGNETTE_ROUTE_MEMORY` | early/regular, resolution day/slot, actual Kwon support use | future timing record plus actual support use | old weekly numbers, hidden support-failure judgement |
| `VIGNETTE_CASE_RECORD` | record/research/next action | existing unlock/research data | inventing rewards, clues, or relation state |

Current `result_scene.gd` creates a single `ScrollContainer` containing result, reasoning, report, save, rewards, and navigation. It proves a current consumer and a gap; it does not implement this successor.

## 09. UI/UX and input contract

### Visual information hierarchy

| surface | player needs first | UI rule | status |
| --- | --- | --- | --- |
| main/menu | case identity, resume/enter path | director-room 3-rail language, not a poster | `IMPLEMENTED` baseline; Human usability `NOT_RUN` |
| preparation | calendar and meaningful next choice | day/slot/early/regular must be readable before confirm | `NOT_IMPLEMENTED` for new cadence |
| investigation | scene evidence and method trade-off | 2–4 choices; evidence before character spectacle | `IMPLEMENTED` baseline |
| manual | competing claims and counter-evidence | separate observation from interpretation | `IMPLEMENTED` baseline |
| rescue/recovery | protected subject and telegraph | protection/response priority over damage fantasy | `IMPLEMENTED` baseline |
| result | one causal consequence at a time | short narrative pages, explicit continue/skip | `CONFIRMED / NOT_IMPLEMENTED` |

### Accessibility / usability ceiling

Target resolutions are 1280×720 and 1920×1080. Keyboard focus, mouse routes, Korean text wrapping, first selectable control, and result-page advancement must be tested in actual runtime. No current Human/new-player/accessibility pass exists.

## 10. Visual and audio production contract

### Locked visual grammar — `CONFIRMED`

- **Environment:** real Korean city noir; wet pavement, apartment/commercial alleys, institutional interiors.
- **People and anomaly:** soft-anime identity/silhouette with restrained facial and supernatural emphasis.
- **UI:** hand-drawn institutional dossier language; clear evidence hierarchy, not a bitmap mockup.
- **Palette/light:** deep blue-gray and paper-neutral foundation; restrained crimson only for anomaly/decision emphasis.
- **Camera/density:** readable game-scale framing; evidence area and action dock remain clear.

### Keep / avoid / do not drift

| Keep | Avoid | Do not drift |
| --- | --- | --- |
| Korean specificity, fixed Kwon Narae identity, evidence-first readability, restrained crimson, dossier hierarchy | generic cyberpunk neon/glass HUD, full pixel art, photoreal thriller, fantasy-anime, poster portrait, answer-coded colors | character proportions, soft-anime/noir mixed rendering, palette value hierarchy, camera grammar, Control-driven UI |

### Asset and board boundary

- `PROJECT_CORE_SCENE_VISUAL_BOARD_2026-08-28.png` is `GENERATED_EXPLORATION`, a planning visualization only.
- `ASSET_MANIFEST.yml` is the product-asset authority. Current M01/M04 asset approvals and runtime verification are consumer-specific; Human QA remains separate.
- Future candidates may be generated without an individual pre-approval when the consumer brief, visual lock, and rights/reuse preflight exist. The user later chooses `LOCK`, `REVISE`, or `REJECT`.
- A candidate cannot replace an approved asset, acquire rights/provenance, enter Godot, or pass runtime/Human QA automatically.

### Audio — `UNKNOWN / NOT_IMPLEMENTED`

No approved current audio production plan or runtime evidence was found in the fresh sources inspected for this GDD. Future M04 production must define the minimum evidence/telegraph/confirmation/result audio layer before calling audio ready.

## 11. Technical and data reality

| component | actual evidence | implication |
| --- | --- | --- |
| `CampaignState` | `MAX_DAYS = 10`; morning/afternoon slots; day advances/normalizes | calendar structure is reusable |
| preparation scene | schedules agents, selects episode, begins operation | lacks player-facing early/regular docket and timing record |
| `monthly_state_policy.gd` | validates only `dispatch_risk` 0/15/30 and week index | historical generic state; do not reuse as new timing meaning |
| battle scene | supports one-time agent recovery support; M04 Kwon support has baseline fear -16 / threshold +2 | actual support exists, but timing bonus does not |
| result scene | one scroll result/report surface | concrete successor target for vignette implementation |
| M04 JSON | existing clues, methods, rescue/recovery outcomes | preserve existing case truth/content IDs |
| save state | additive monthly state and agent-support usage exist | new timing fields need separate compatibility/round-trip design |

### Architecture guardrails

1. Do not change protected `data/`, `scripts/`, `scenes/`, `assets/`, or `project.godot` in the GDD phase.
2. Preserve save compatibility, Episode IDs, M01 behaviour, existing rescue/recovery meaning.
3. Do not infer a 10-day timing result from legacy month/week data.
4. Do not store hidden truth as a timing/preparation reward.
5. Build only after a GitHub Issue and one unified implementation contract are approved.

## 12. Evidence-based SWOT

| statement | class | evidence | confidence | player impact | production impact | disposition | next validation |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Evidence → hypothesis → rescue → recovery is present as a consistent M01/M04 grammar | `STRENGTH` | current canon, M04 JSON, scene/runtime paths | `VERIFIED` | a readable causal mystery promise | reuse reduces new-system cost | `PROTECT` | Human M01/M04 comprehension test |
| M04 separates human rescue and resonance recovery in data | `STRENGTH` | M04 recovery result records and current canon | `VERIFIED` | avoids a shallow single-grade ending | supports vignette extension without case rewrite | `PROTECT` | result-page player recall test |
| Existing runtime calendar already has 10 days and two slots | `STRENGTH` | `campaign_state.gd` constants/state | `VERIFIED` | familiar short-cycle cadence | avoids new calendar core | `ADAPT` | save/slot regression under new timing contract |
| Product documents previously contradicted the runtime calendar with 4-week values | `WEAKNESS` | fresh source comparison | `VERIFIED` | player copy could be false | schema/UI migration risk | `IMPROVE` | current-doc and runtime contract tests |
| Day 10, early/regular presentation, timing persistence, and numeric balance do not exist in runtime | `WEAKNESS` | preparation/result scenes, campaign state | `VERIFIED` | key M04 trade-off cannot yet be felt | multi-file save/UI/result scope | `TEST` | unified implementation contract + automated/Human QA |
| Current result scene is one long scroll | `WEAKNESS` | `result_scene.gd` | `VERIFIED` | M04 outcome may read as a report rather than a memory | logical paging redesign needed | `IMPROVE` | M04 readability and emotional recall playtest |
| Korean urban-noir/dossier visual grammar is user-locked | `OPPORTUNITY` | visual lock packet and board | `VERIFIED` | recognizable first impression | reusable UI/asset grammar | `PROTECT` | target-resolution runtime comparisons |
| Deduction games demonstrate value in traceable evidence and player-built theory | `OPPORTUNITY` | official pages for [Return of the Obra Dinn](https://store.steampowered.com/app/653530/Return_of_the_Obra_Dinn/) and [The Case of the Golden Idol](https://store.steampowered.com/app/1677770/The_Case_of_the_Golden_Idol/) | `INFERENCE` | validates evidence clarity, not copied presentation | adapt information traceability only | `ADAPT` | player can explain why a hypothesis is supported/rebutted |
| Unfinalized timing balance can make early and regular choices feel cosmetic or punitive | `THREAT` | numeric contract is intentionally undefined | `PARTIAL` | erodes trust in a core choice | risk of repeated rebalance | `MITIGATE` | one-at-a-time Grill Me balance lock before coding |
| Generated visual candidates can be confused with approved runtime assets | `THREAT` | current planning board/candidate policy boundaries | `VERIFIED` | visual promise could overstate playable quality | rights/promotion/rework risk | `MITIGATE` | manifest/provenance/runtime-capture gate |

## 13. Benchmark decision

| reference | what works | adapt | reject | differentiation |
| --- | --- | --- | --- | --- |
| Return of the Obra Dinn | player confidence comes from reconstructing a case with explicit observations | evidence traceability and explainable deductions | visual style, setting, and proprietary structure | Korean institutional occult care and stabilization |
| The Case of the Golden Idol | lets players assemble a theory from discovered clues | visible hypothesis support/rebuttal and non-auto-solution logic | its art, historical fiction, and exact scene-reconstruction format | half-day preparation + rescue + telegraph recovery |
| Current urban-legend runtime | actual M01/M04 shared screen/data grammar | reuse actual Scene/JSON/save paths first | fabricating a second framework | consequence pages link existing systems rather than replacing them |

**Adopt:** evidence traceability.
**Adapt:** theory slots and causal feedback, only in the project's own language.
**Reject:** copied identity, presentation, case structure, or art expression.
**Remaining uncertainty:** whether the 10-day timing choice adds meaningful pressure without becoming a hidden penalty.

## 14. Validation and QA matrix

| ID | required evidence | state |
| --- | --- | --- |
| `QA-CAL-01` | Day 1–9 and Day 10 labels are correct before confirmation | `NOT_RUN` |
| `QA-CAL-02` | exactly one main case resolves per cycle; early leaves no second main case | `NOT_RUN` |
| `QA-SAVE-01` | new timing record save/load/old-save fallback | `NOT_RUN` |
| `QA-M04-01` | M04 route-memory vignette uses one cause per page | `NOT_RUN` |
| `QA-M04-02` | M01 remains behaviourally unchanged | `NOT_RUN` for successor scope |
| `QA-UI-01` | 1280×720 / 1920×1080 Korean readability, mouse and keyboard | `NOT_RUN` |
| `QA-VIS-01` | consumer-specific asset provenance and runtime capture | `PARTIAL`; do not generalize |
| `QA-HUMAN-01` | new player explains core rule and early/regular trade-off | `NOT_RUN` |
| `QA-HUMAN-02` | player remembers a human/phenomenon consequence after M04 | `NOT_RUN` |

## 15. Implementation queue — not authorization

Order is driven by dependency, player value, and risk. No item starts in this GDD phase.

1. **Unified calendar contract:** data ownership, compatibility, Day 1–9/10 model, and explicit balance selection.
2. **Preparation timing surface:** read current day/slot, early/regular meaning, remaining opportunity before confirmation.
3. **Timing save/result bridge:** persisted record, result payload, no legacy-week inference.
4. **M04 sequential vignette UI:** logical page state, continue/skip, Korean copy, current result data reuse.
5. **Automated regression:** calendar, save, M01, M04, target-resolution UI checks.
6. **Visual/audio consumer work:** only after consumer-specific brief and final LOCK/promotion gates.
7. **Human/new-player validation:** fun, clarity, memory, accessibility.

## 16. User decision required — one at a time later

The only currently material unapproved product decision is the concrete **early/regular balance model**. The user must choose after seeing a Grill Me comparison with player value, production/maintenance cost, risk, reversibility, data/UI impact, and rollback. This GDD deliberately does not fill it with invented numbers.

All other currently known work is a documentation or implementation-contract consequence of existing user approval.

## 17. Production readiness summary

```yaml
planning_canon: CURRENT
workspace_owner: REPOSITORY_ONLY
10_day_half_day_calendar: CONFIRMED
calendar_runtime_structure: IMPLEMENTED
calendar_player_contract: NOT_IMPLEMENTED
m04_timing_balance: UNDEFINED
m04_sequential_result_presentation: CONFIRMED / NOT_IMPLEMENTED
visual_direction: USER_LOCKED
image_candidate_generation: PREAUTHORIZED / FINAL_LOCK_REQUIRED
product_asset_promotion: CONSUMER_SPECIFIC / NOT_AUTOMATIC
automated_exact_head_for_new_change: NOT_RUN
human_usability: NOT_RUN
player_experience: NOT_RUN
production_expansion: NOT_APPROVED
```

## 18. Change log

| date | change | source |
| --- | --- | --- |
| 2026-08-28 | canonicalized 10-day / two-half-day campaign; Day 1–9 early, Day 10 regular | direct user decision; `D-2026-08-28-TEN-DAY-HALF-DAY-CASE-CADENCE` |
| 2026-08-28 | superseded old M04 week/numeric timing values without day mapping | fresh code/document comparison |
| 2026-08-28 | locked M04 sequential narrative results as one causal page at a time | direct user decision; decision #333 provenance |
| 2026-08-28 | candidate generation pre-authorized; final visual lock remains user-owned | direct user decision |
| 2026-08-28 | moved current project owner from Notion + repository to repository-only | direct user decision |
