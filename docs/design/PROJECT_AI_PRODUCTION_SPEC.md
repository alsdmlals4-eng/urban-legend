# 괴이 기록국 · Master GDD

> Artifact role: `PROJECT_AI_PRODUCTION_SPEC`
> Version: `2026-08-28 · core-system coverage correction`
> Status: `CURRENT / REPOSITORY_ONLY_CANON / IMPLEMENTATION_CONTRACT_PENDING`
> Baseline main: `72c20182172ea6ed30a9d6f20fb147f034911395` (`docs: close Notion migration review`)
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
| `CURRENT` | `scripts/core/campaign_state.gd`, `scripts/scenes/preparation_scene.gd`, `scripts/scenes/investigation_scene.gd`, `scripts/scenes/result_scene.gd`, `scripts/scenes/battle_scene.gd` | actual runtime evidence |
| `CURRENT` | `data/episodes/episode_001_afterlife_station_canon_v2.json`, `data/episodes/episode_002_red_umbrella_alley.json`, `data/episodes/episode_002_red_umbrella_alley_validation_map.json` | actual M01/M04 content/data boundary |
| `CURRENT` | `ASSET_MANIFEST.yml`, visual consumer/checklist documents | asset owner and actual consumer boundary |
| `HISTORICAL_READ_ONLY` | existing Notion pages + `docs/migrations/NOTION_CURRENT_WORK_MIGRATION_2026-08-28.md` | prior planning/reference is migrated and indexed in-repository; Notion itself has no write/readback destination |
| `HISTORICAL` | `ANNUAL-MVP-*`, 4-week/7-day documents, `monthly_state_policy.gd` week risk values | regression/provenance only |
| `SUPERSEDED` | `D-2026-08-28-M04-EARLY-DISPATCH-REGULAR-WEEK4-CADENCE` numeric windows | old 2/3/4-week and `0/15/30`, `0/+4/+8`; do not map to days |
| `UNKNOWN` | new timing numeric balance, Day-10 UI/save/result implementation, M04 timing Human QA | requires a later implementation contract and validation |
| `CONFLICT` | product rule `one main case per 10-day cycle` ↔ current campaign runtime | runtime supports three case IDs in the same ten-day demo; case-limit enforcement is not implemented |
| `PARTIAL` | keyword/slot composition design ↔ current runtime consumer | approved design exists, but M01 candidate arrays are empty and M04 has no keyword-composition data/consumer |

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
| `SYS-KEY-01` | page-local keyword / slot composition | compare source-grounded candidate wording without an answer recommender | `APPROVED_DESIGN / NOT_IMPLEMENTED`; no player-facing composition consumer |
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

## 07. 10-day schedule system

### What this phase is for

The schedule phase gives the player a limited number of calm, understandable choices before a case becomes dangerous. It is not a calendar decoration and it is not a punishment countdown. The intended question is: **“Do I leave now to protect the person sooner, or do I spend another half-day preparing a safer, better-informed response?”**

```text
Morning or afternoon slot opens
→ assign the current activity and, when available, a case/team
→ spend this half-day on investigation or a supporting activity
→ read the slot result
→ advance to the afternoon or next morning
→ decide again until the one main case is resolved
```

### Confirmed product rule

```text
Cycle: 10 days
Day: morning + afternoon
Main case: exactly one main case per cycle
Early resolution: Day 1–9
Regular resolution: Day 10
After early resolution: no second main case; use remaining half-days for aftermath/preparation
```

Day 1–9 is **early resolution**, and Day 10 is **regular resolution**. The latter is a normal route, not a late-state failure, penalty, or hidden bad ending. Early resolution has to protect earlier; regular resolution has to give more genuine preparation opportunities. The numerical effect that makes that trade-off tangible remains deliberately unapproved.

### What current runtime actually does

| runtime element | verified behavior | player-facing meaning today | status |
| --- | --- | --- | --- |
| `CampaignState.MAX_DAYS` | has ten days and resets/loads a clamped day range | the structural campaign clock exists | `IMPLEMENTED` |
| `TIME_SLOTS` | holds `morning`, then `afternoon`; acknowledging an AM result advances to PM, acknowledging PM advances the day | a half-day is an actual saved turn boundary | `IMPLEMENTED` |
| schedule assignment | only the active planning slot accepts a valid activity; the operation stores day, slot, and suspended/in-progress state | a player can plan the current half-day and resume it after save/load | `IMPLEMENTED` |
| case selection | `CASE_ORDER` currently contains M01, M04, and M07; the three-case regression starts them on Day 1, Day 2, and Day 8 | current runtime does not enforce the one-main-case limit | `CONFLICT / NOT_IMPLEMENTED` |
| early/regular presentation | there is no docket label, Day-10 explanation, timing record, or result consumer | the player cannot yet understand or feel the approved early/regular trade-off in-game | `NOT_IMPLEMENTED` |

This is a deliberate truth boundary: **exactly one main case per cycle** is the approved product rule, while **current runtime does not enforce the one-main-case limit**. No document may use the existing 10-day constants or the three-case regression as proof that the product cadence is complete.

### What the player must understand before confirming a future dispatch

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

## 08. Investigation phase

### The player experience

Investigation begins with an observable situation, not with a puzzle answer. The player reads what is happening, chooses a method, sees the consequence, and decides what that consequence supports or rules out. The meaningful choice is not “which button wins”; it is whether to preserve a fragile trace, spend time analyzing it, or force entry and accept the risk to the victim, the scene, or the anomaly state.

```text
Observable point and situation
→ choose observation / analysis / suppression-style method
→ receive an explicit method result
→ gain or miss a clue, flag, and/or hint
→ compare the new evidence with competing interpretations
→ apply the resulting rule to rescue and recovery
```

### Current playable grammar — `IMPLEMENTED`

`investigation_scene.gd` builds a method card from the selected point's data. The card shows the chosen approach, the assigned helper's relevant ability, a difficulty, and a short consequence before selection. The result then states all of the following in the same surface: current situation, selected method, success/failure, visible calculation, newly acquired clues, hints that are explicitly *not* clues, and changed anomaly/victim/mental/stability state.

That matters because a failed method is not silently discarded. It leaves an explicit result and may change risk, stamina, flags, or later conditions. The runtime is therefore evidence-led, but Human/new-player evidence that the explanation is actually understood is still `NOT_RUN`.

### M04: what the player currently investigates

The Red Umbrella Alley data contains three required observations: the red umbrella fabric, the repeating alley sign, and the reverse rain flow. They are not collectible flavor. Each points to a concrete later effect: locating the anchor, weakening the route loop, or fixing the timing of a recoverable moment. M04 also has a rain-sync rule-verification minigame, whose success/failure changes recovery threshold/stability burden rather than replacing the case rule.

### Investigation guardrails

- Present evidence before spectacle; the player must be able to say what they saw.
- A hint may direct attention but cannot count as acquired evidence.
- A stat, companion, equipment item, or Aka may make a method safer/readable; none may produce the hidden rule automatically.
- Preserve the existing M01 and M04 clue IDs and case truth when a new consumer is later built.

## 09. Keyword and anomaly-manual system

### Why this system exists

The keyword system is the bridge between “I found a clue” and “I can state a rule that changes what I do.” A keyword is a **non-consumable evidence reference with provenance**, not a colored loot card and not a currency. The intended manual makes the player compare the original source, its acquisition context, and the sentence/slot where it is used before committing to a rescue or recovery rule.

```text
Observed source and normal keyword
→ page-local candidate pool
→ compare source, acquisition context, and manual sentence
→ place a candidate in the relevant rule slot
→ reject only structural impossibilities immediately
→ keep semantic correctness unannounced until field verification
```

### Approved design contract — `APPROVED_DESIGN / NOT_IMPLEMENTED`

The approved design defines a normal keyword as source-grounded wording. A mutated candidate is derived from that normal keyword by changing **one** meaningful variable (for example count, timing, order, direction, target, tool, or prohibition); it is not an independently acquired fake clue. The player sees normal and mutated candidates in the same page-local pool and uses memory, provenance, and the rest of the manual to distinguish them.

The pool is intentionally small and relevant: early pages begin around 5–6 candidates for three slots, standard pages 7–10, and major pages 9–12. Search/sort may use keyword name, original source, acquisition context, acquisition order, source grouping, or locale order. It must not filter by “correct,” “mutated,” “compatible with this slot,” or recommendation score. Structural errors can be blocked; a plausible but wrong reading must remain available for field learning.

### Current runtime reality

The current M01 Canon v2 manual already persists evidence records with source IDs and usage references, and the bridge preserves `candidate_keywords` and `semantic_relations`. But the checked M01 data has empty `candidate_keywords` / `semantic_relations`, and the current M04 case data has no keyword-composition schema. There is **no player-facing keyword-composition consumer** in the current scenes. Existing clue selection and hypothesis steps must not be mislabelled as the completed keyword system.

| layer | current status | evidence boundary |
| --- | --- | --- |
| evidence records / clue IDs | `IMPLEMENTED` | current M01/M04 data and manual/recovery UI |
| competing hypotheses / support-rebuttal-unresolved records | `IMPLEMENTED / PARTIAL` | M01 case packet and shared reasoning grammar; Human clarity not tested |
| page-local keyword candidate composition | `APPROVED_DESIGN / NOT_IMPLEMENTED` | no populated live candidate pool or composition UI |
| mutated-keyword verification | `APPROVED_DESIGN / NOT_IMPLEMENTED` | no live M01/M04 consumer, save round-trip, or player validation |

### Production boundary

The next implementation contract must add this as one coherent vertical slice: source-backed candidate data → page-local UI → structural validation → save/load migration → a rescue/recovery consequence → accessibility and Human comprehension evidence. It may not invent new clues, let the UI reveal the answer, or replace M04's existing evidence truth.

## 10. Rescue and recovery phase

### The distinction the game must protect

**Rescue** asks “How do I get this person out of the rule's harm?” **Recovery** asks “Now that the manifestation is understood and contained, how do I stabilize and recover the remaining resonance?” The victim result and resonance result must remain separate. A rescued person is not an enemy health bar, and a recovered resonance cannot erase human harm.

### From deduction to action

```text
Investigation evidence and manual rule
→ victim rescue procedure / protected-person state
→ telegraph → hypothesis → evidence → response
→ stability threshold reached
→ recover anomaly core / resonance
→ composite result: victim, resonance, memory, case record
```

The recovery phase is **not HP depletion**. It is a telegraph-first stabilization loop. A recovery turn obtains one current pattern, displays its telegraph and linked acquired clues, and—when the pattern has a question—guides the player through `telegraph → hypothesis → evidence → response`. The player first chooses the rule hypothesis, then selects one or more acquired records, and only then chooses a field response. The system records whether the hypothesis/evidence/response line up; it never asks a companion to choose the hidden rule for the player.

### Current recovery behavior — `IMPLEMENTED` baseline

| beat | verified runtime behavior | learning feedback |
| --- | --- | --- |
| telegraph | `select_next_recovery_pattern()` selects a current pattern; the screen shows its telegraph/question and acquired linked clues | player knows the observable danger before committing |
| decision | guided patterns require hypothesis, then acquired evidence, then response; other patterns show direct response only | the chosen reasoning remains visible in the evidence panel |
| correct response | increases anomaly stability toward a case threshold | the record states that the rule was interrupted and, when applicable, that the manual candidate was verified |
| wrong response | applies bounded harm/protection mitigation and records the failure reason | **wrong-response learning** remains visible; the next telegraph appears so the player can revise rather than reload for a hidden answer |
| recovery | only after stability reaches the threshold can `core_recovered` be saved and the result scene open | resolution is stabilization/recovery, not killing the anomaly |

M04's three clue effects already supply an anchor, a route-loop break, and a timing stabilization advantage. Its result data independently represents unavailable, temporary, standard, and complete outcomes. The planned sequential result pages will read those causes one at a time; they do not yet exist as live Godot scenes.

### Recovery guardrails

- Never show a false telegraph or treat a random stat roll as the hidden-rule answer.
- The first unobserved pattern must retain at least one broadly protective, recoverable response.
- A wrong response produces a reason and future evidence, not an instant campaign lock or a secret correct answer.
- Equipment/companions may mitigate, reveal a related already-acquired clue, or improve a visible prediction; they may not complete the phase automatically.

## 11. M04 result-vignette specification

M04 must avoid a single dense result page. The intended logical pages are not new Godot Scenes yet.

| page ID | player learns | required input | prohibited shortcut |
| --- | --- | --- | --- |
| `VIGNETTE_VICTIM_RESCUE` | what happened to the victim | existing rescue result / after-story | overwriting it with recovery grade |
| `VIGNETTE_RESONANCE_RECOVERY` | what happened to the anomaly/resonance | existing recovery state | treating the victim as an enemy-health outcome |
| `VIGNETTE_ROUTE_MEMORY` | early/regular, resolution day/slot, actual Kwon support use | future timing record plus actual support use | old weekly numbers, hidden support-failure judgement |
| `VIGNETTE_CASE_RECORD` | record/research/next action | existing unlock/research data | inventing rewards, clues, or relation state |

Current `result_scene.gd` creates a single `ScrollContainer` containing result, reasoning, report, save, rewards, and navigation. It proves a current consumer and a gap; it does not implement this successor.

## 12. UI/UX and input contract

### Visual information hierarchy

| surface | player needs first | UI rule | status |
| --- | --- | --- | --- |
| main/menu | case identity, resume/enter path | director-room 3-rail language, not a poster | `IMPLEMENTED` baseline; Human usability `NOT_RUN` |
| preparation | calendar and meaningful next choice | day/slot/early/regular and one-case limit must be readable before confirm | `NOT_IMPLEMENTED` for the product cadence |
| investigation | scene evidence and method trade-off | 2–4 choices; evidence before character spectacle | `IMPLEMENTED` baseline |
| manual / keyword | competing claims, provenance, and counter-evidence | separate observation from interpretation; never use answer-recommendation UI | manual `IMPLEMENTED` baseline; keyword composition `NOT_IMPLEMENTED` |
| rescue/recovery | protected subject and telegraph | protection/response priority over damage fantasy; show hypothesis → evidence → response | `IMPLEMENTED` baseline |
| result | one causal consequence at a time | short narrative pages, explicit continue/skip | `CONFIRMED / NOT_IMPLEMENTED` |

### Accessibility / usability ceiling

Target resolutions are 1280×720 and 1920×1080. Keyboard focus, mouse routes, Korean text wrapping, first selectable control, and result-page advancement must be tested in actual runtime. No current Human/new-player/accessibility pass exists.

## 13. Visual and audio production contract

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

## 14. Technical and data reality

| component | actual evidence | implication |
| --- | --- | --- |
| `CampaignState` | `MAX_DAYS = 10`; morning/afternoon slots; current code permits M01, M04, and M07 in the same demo cycle | calendar structure is reusable, but product one-case enforcement is absent |
| preparation scene | schedules agents, selects episode, begins/suspends/resumes an operation | lacks player-facing early/regular docket, timing record, and one-case enforcement |
| investigation scene | shows method choice, visible result, clue/hint/state change | current evidence-led investigation baseline is usable and must be preserved |
| keyword composition | bridge preserves fields named `candidate_keywords` / `semantic_relations`, but M01 arrays are empty and M04 has none | approved design has no player-facing keyword-composition consumer yet |
| `monthly_state_policy.gd` | validates only `dispatch_risk` 0/15/30 and week index | historical generic state; do not reuse as new timing meaning |
| battle scene | telegraph, hypothesis, evidence, response, wrong-response learning, stability threshold, and one-time agent support | actual recovery baseline exists; timing bonus does not |
| result scene | one scroll result/report surface | concrete successor target for vignette implementation |
| M04 JSON | existing clues, methods, rescue/recovery outcomes | preserve existing case truth/content IDs |
| save state | additive monthly state and agent-support usage exist | new timing fields need separate compatibility/round-trip design |
| headless runtime QA | Godot 4.7.2 editor import, then `test_three_case_campaign_manual_qa.gd` (136 pass / 0 fail), `mvp043_investigation_ui_test.gd` (PASS), and `mvp043_recovery_loop_test.gd` (PASS) | a fresh worktree needs the Godot import/class-cache preflight before direct script execution; a pre-import missing-class/texture-cache error is a test-environment failure, not product evidence |

### Architecture guardrails

1. Do not change protected `data/`, `scripts/`, `scenes/`, `assets/`, or `project.godot` in the GDD phase.
2. Preserve save compatibility, Episode IDs, M01 behaviour, existing rescue/recovery meaning.
3. Do not infer a 10-day timing result from legacy month/week data.
4. Do not store hidden truth as a timing/preparation reward.
5. Build only after a GitHub Issue and one unified implementation contract are approved.
6. Before interpreting a headless Scene-test failure, import the fresh worktree with the declared Godot version; keep the import preflight separate from a player/runtime pass.

## 15. Evidence-based SWOT

| statement | class | evidence | confidence | player impact | production impact | disposition | next validation |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Evidence → hypothesis → rescue → recovery is present as a consistent M01/M04 grammar | `STRENGTH` | current canon, M04 JSON, scene/runtime paths | `VERIFIED` | a readable causal mystery promise | reuse reduces new-system cost | `PROTECT` | Human M01/M04 comprehension test |
| M04 separates human rescue and resonance recovery in data | `STRENGTH` | M04 recovery result records and current canon | `VERIFIED` | avoids a shallow single-grade ending | supports vignette extension without case rewrite | `PROTECT` | result-page player recall test |
| Existing runtime calendar already has 10 days and two slots | `STRENGTH` | `campaign_state.gd` constants/state | `VERIFIED` | familiar short-cycle cadence | avoids new calendar core | `ADAPT` | save/slot regression under new timing contract |
| The current human-facing master GDD previously named, but did not explain, schedule/investigation/keyword/recovery play | `WEAKNESS` | user finding plus fresh GDD comparison | `VERIFIED` | the core promise was hard to understand or review | leads to wrong implementation scope | `IMPROVE` | core-system coverage test + GDD reader review |
| Product documents previously contradicted the runtime calendar with 4-week values | `WEAKNESS` | fresh source comparison | `VERIFIED` | player copy could be false | schema/UI migration risk | `IMPROVE` | current-doc and runtime contract tests |
| The approved one-case-per-cycle rule is absent from the current campaign enforcement; the three-case regression demonstrates the mismatch | `WEAKNESS` | `campaign_state.gd`, `test_three_case_campaign_manual_qa.gd` | `VERIFIED` | a player can receive a different cadence than the promise | requires operation gating, save/result semantics, and regression changes | `IMPROVE` | unified calendar contract exact-head tests |
| Keyword composition is approved but has no populated live candidate data or scene consumer | `WEAKNESS` | M01 Canon v2 arrays, M04 JSON, current scene inspection | `VERIFIED` | the intended source-comparison deduction is not yet playable | data/UI/save/accessibility scope remains unestimated | `TEST` | keyword vertical-slice contract and Human comprehension test |
| Day 10, early/regular presentation, timing persistence, and numeric balance do not exist in runtime | `WEAKNESS` | preparation/result scenes, campaign state | `VERIFIED` | key M04 trade-off cannot yet be felt | multi-file save/UI/result scope | `TEST` | unified implementation contract + automated/Human QA |
| Current result scene is one long scroll | `WEAKNESS` | `result_scene.gd` | `VERIFIED` | M04 outcome may read as a report rather than a memory | logical paging redesign needed | `IMPROVE` | M04 readability and emotional recall playtest |
| Korean urban-noir/dossier visual grammar is user-locked | `OPPORTUNITY` | visual lock packet and board | `VERIFIED` | recognizable first impression | reusable UI/asset grammar | `PROTECT` | target-resolution runtime comparisons |
| Deduction games demonstrate value in traceable evidence and player-built theory | `OPPORTUNITY` | official pages for [Return of the Obra Dinn](https://store.steampowered.com/app/653530/Return_of_the_Obra_Dinn/) and [The Case of the Golden Idol](https://store.steampowered.com/app/1677770/The_Case_of_the_Golden_Idol/) | `INFERENCE` | validates evidence clarity, not copied presentation | adapt information traceability only | `ADAPT` | player can explain why a hypothesis is supported/rebutted |
| Unfinalized timing balance can make early and regular choices feel cosmetic or punitive | `THREAT` | numeric contract is intentionally undefined | `PARTIAL` | erodes trust in a core choice | risk of repeated rebalance | `MITIGATE` | one-at-a-time Grill Me balance lock before coding |
| Generated visual candidates can be confused with approved runtime assets | `THREAT` | current planning board/candidate policy boundaries | `VERIFIED` | visual promise could overstate playable quality | rights/promotion/rework risk | `MITIGATE` | manifest/provenance/runtime-capture gate |

## 16. Benchmark decision

| reference | what works | adapt | reject | differentiation |
| --- | --- | --- | --- | --- |
| Return of the Obra Dinn | player confidence comes from reconstructing a case with explicit observations | evidence traceability and explainable deductions | visual style, setting, and proprietary structure | Korean institutional occult care and stabilization |
| The Case of the Golden Idol | lets players assemble a theory from discovered clues | visible hypothesis support/rebuttal and non-auto-solution logic | its art, historical fiction, and exact scene-reconstruction format | half-day preparation + rescue + telegraph recovery |
| Current urban-legend runtime | actual M01/M04 shared screen/data grammar | reuse actual Scene/JSON/save paths first | fabricating a second framework | consequence pages link existing systems rather than replacing them |

**Adopt:** evidence traceability.
**Adapt:** theory slots and causal feedback, only in the project's own language.
**Reject:** copied identity, presentation, case structure, or art expression.
**Remaining uncertainty:** whether the 10-day timing choice adds meaningful pressure without becoming a hidden penalty.

## 17. Validation and QA matrix

| ID | required evidence | state |
| --- | --- | --- |
| `QA-CAL-01` | Day 1–9 and Day 10 labels are correct before confirmation | `NOT_RUN` |
| `QA-CAL-02` | exactly one main case resolves per cycle; early leaves no second main case | `NOT_RUN` |
| `QA-SAVE-01` | new timing record save/load/old-save fallback | `NOT_RUN` |
| `QA-INV-01` | M04 player can identify observation, selected method, acquired clue, and changed condition without a guide | `NOT_RUN` |
| `QA-KEY-01` | page-local keyword data, structural validation, save/load, no answer recommendation, and accessible search/sort | `NOT_RUN` |
| `QA-REC-01` | player can explain the telegraph → hypothesis → evidence → response chain and learns from an intentional wrong response | `NOT_RUN` |
| `QA-M04-01` | M04 route-memory vignette uses one cause per page | `NOT_RUN` |
| `QA-M04-02` | M01 remains behaviourally unchanged | `NOT_RUN` for successor scope |
| `QA-UI-01` | 1280×720 / 1920×1080 Korean readability, mouse and keyboard | `NOT_RUN` |
| `QA-VIS-01` | consumer-specific asset provenance and runtime capture | `PARTIAL`; do not generalize |
| `QA-HUMAN-01` | new player explains core rule and early/regular trade-off | `NOT_RUN` |
| `QA-HUMAN-02` | player remembers a human/phenomenon consequence after M04 | `NOT_RUN` |

## 18. Implementation queue — not authorization

Order is driven by dependency, player value, and risk. No item starts in this GDD phase.

1. **Unified calendar contract:** enforce exactly one main case, preserve a ten-day/two-slot save, and obtain the one outstanding early/regular balance decision.
2. **Preparation timing surface:** read day/slot, early/regular meaning, remaining opportunity, and the already-resolved-case state before confirmation.
3. **Timing save/result bridge:** persist the timing record and feed it to M04 route-memory without legacy-week inference.
4. **Keyword/manual vertical slice:** source-backed candidate data, page-local composition, structural validation, save/load, and one M04 rescue/recovery consequence.
5. **M04 sequential vignette UI:** logical page state, continue/skip, Korean copy, current result data reuse.
6. **Automated regression:** calendar limit, save, M01, M04, keyword integrity, intentional wrong-recovery learning, and target-resolution UI checks.
7. **Visual/audio consumer work:** only after consumer-specific brief and final LOCK/promotion gates.
8. **Human/new-player validation:** fun, clarity, memory, accessibility.

## 19. User decision required — one at a time later

The only currently material unapproved product decision is the concrete **early/regular balance model**. The user must choose after seeing a Grill Me comparison with player value, production/maintenance cost, risk, reversibility, data/UI impact, and rollback. This GDD deliberately does not fill it with invented numbers.

All other currently known work is a documentation or implementation-contract consequence of existing user approval.

## 20. Production readiness summary

```yaml
planning_canon: CURRENT
workspace_owner: REPOSITORY_ONLY
10_day_half_day_calendar: CONFIRMED
calendar_runtime_structure: IMPLEMENTED
one_main_case_runtime_enforcement: NOT_IMPLEMENTED
calendar_player_contract: NOT_IMPLEMENTED
investigation_phase: IMPLEMENTED_SHARED_BASELINE
keyword_composition: APPROVED_DESIGN / NOT_IMPLEMENTED
recovery_phase: IMPLEMENTED_SHARED_BASELINE
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

## 21. Change log

| date | change | source |
| --- | --- | --- |
| 2026-08-28 | canonicalized 10-day / two-half-day campaign; Day 1–9 early, Day 10 regular | direct user decision; `D-2026-08-28-TEN-DAY-HALF-DAY-CASE-CADENCE` |
| 2026-08-28 | superseded old M04 week/numeric timing values without day mapping | fresh code/document comparison |
| 2026-08-28 | locked M04 sequential narrative results as one causal page at a time | direct user decision; decision #333 provenance |
| 2026-08-28 | candidate generation pre-authorized; final visual lock remains user-owned | direct user decision |
| 2026-08-28 | moved current project owner from Notion + repository to repository-only | direct user decision |
| 2026-08-28 | corrected master-GDD core-system coverage; documented schedule, investigation, keyword/manual, and rescue/recovery flows with their actual implementation gaps | fresh source/code/data/test comparison after user finding |
