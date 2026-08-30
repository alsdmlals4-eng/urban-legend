# 괴이 기록국 · Master GDD

> Artifact role: `PROJECT_AI_PRODUCTION_SPEC`
> Version: `2026-08-30 · M01/M04 runtime readback reconciliation`
> Status: `CURRENT / REPOSITORY_ONLY_CANON / M01_M04_LOCAL_RUNTIME_IMPLEMENTED / HUMAN_QA_NOT_RUN`
> Baseline main: `522d9af75ea90cecd58fe3fe6afa9de0520990a8` (`fix: preserve main menu panels at wide resolutions`)
> Active local implementation head: `544857824f4afd0d5d9cf0549ced3b138dedfba6` (M04 player-authored manual slice; not merged)
> Scope: project truth, player-experience contract, design verification, production boundary
> Excludes: M05+ case production, timing-balance finalization, unpromoted asset replacement, and Human QA PASS

## 00. How to read this document

This is the repository-owned master GDD for humans and AI workers. It distinguishes a decision from an implementation and an automated check from a player validation.

| status | meaning |
| --- | --- |
| `CONFIRMED` | user-approved product or workflow decision |
| `IMPLEMENTED` | present in current code/data/Scene at the stated branch or commit |
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
| `CURRENT` | `docs/decisions/D-2026-08-29-CORE-LOOP-PRIORITY.md` | investigation/deduction and recovery as the primary playable core; calendar as support |
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
| `UNKNOWN` | new timing numeric balance and M04 timing Human QA | requires a later balance decision and human validation |
| `IMPLEMENTED` | product rule `one main case per 10-day cycle` | `CampaignState` uses a `cycle main case lock` (`cycle_main_case_id`) for the first operation and rejects a second main case in the same cycle; focused machine verification exists |
| `IMPLEMENTED_M01_M04` | keyword/slot composition | source-backed `candidate_keywords` pools and a player-authored, draft-only workbench are live for M01 and M04; M05+ remains outside the slice |

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
| 2. Core systems / content contract | `IMPLEMENTED_M01_M04` | shared runtime, cycle lock, player-authored manual, and M04 result pages have focused machine evidence; numeric balance remains undefined |
| 3. Visual direction / screen grammar | `CONFIRMED` | user visual lock; planning board only |
| 4. Production implementation | `IMPLEMENTED_M01_M04` | M01 and M04 use the current cycle/docket, manual, rescue/recovery, and M04 logical-vignette consumers on the active local implementation branch |
| 5. Player validation / production expansion | `NOT_RUN` | Human/new-player/accessibility evidence absent |

## 03. Player promise and core experience

### Player promise

**“나는 권나래로서, 눈으로 확인한 근거로 괴이의 규칙을 밝혀, 그 가설을 현장에서 검증하고 현상을 죽이지 않고 안정화·회수한다.”**

```text
Player Promise
→ 관측과 해석을 나누고 경쟁 가설을 비교한다
→ 피해자를 먼저 현상에서 분리한다
→ 전조에 맞는 대응으로 잔향을 안정화·회수한다
→ 사람·현상·기록에 남은 서로 다른 결과를 읽는다
→ 10일·반일의 준비·후일담을 거쳐 다음 사건에서 더 나은 판단을 시도한다
```

| connection | intended experience | current state |
| --- | --- | --- |
| representative action | 관찰한 단서를 매뉴얼 가설·구출·회수 선택에 재사용한다 | `IMPLEMENTED` shared grammar |
| meaningful choice | 관측을 보존/분석/억제할지, 어떤 가설·근거·전조 대응을 연결할지 | `IMPLEMENTED` shared grammar; Human clarity `NOT_RUN` |
| supporting choice | Day 1–9 조기 보호 vs Day 10 정규 해결까지 준비 기회 사용 | `IMPLEMENTED / FOCUSED_MACHINE_VERIFIED`; Preparation docket and dispatch context explain the non-numeric route, while balance remains `UNDEFINED` |
| observable outcome | 피해자 상태, 잔향 상태, 귀가 기억 timing, 기록/연구가 서로 덮어쓰이지 않는다 | M04 uses separate logical result pages for rescue, resonance, route memory, and case record; Human recall remains `NOT_RUN` |
| reward / failure learning | 매뉴얼·위험 사례·연구가 다음 판단에 남고, 오답은 관측 가능한 반증으로 설명된다 | `PARTIAL` runtime/data; player validation `NOT_RUN` |
| target emotion | 조용한 책임감, 규칙을 알아낸 안도, 피해자를 너무 늦기 전에 지켰다는 기억 | `CONFIRMED`; Human evidence `NOT_RUN` |
| next-action motive | 남은 반일을 후일담·치료·연구·관계·다음 사건 준비에 쓴다 | `IMPLEMENTED` cycle lock and Preparation docket; player motivation quality remains `NOT_RUN` |
| differentiation / sales hook | 한국 도시의 생활감 있는 괴담을 “처치”가 아니라 증거 기반 보호·기록·안정화로 끝낸다 | `CONFIRMED`; market validation `NOT_RUN` |

### Core fun check

The pointed fun is not “many menus,” a calendar puzzle, or “a combat result.” It is the short causal chain in which the player sees a troubling urban detail, investigates what it actually is, constructs a rule from competing evidence, and proves that rule under a live recovery telegraph. The calendar frames when the player prepares and reads aftermath; it never substitutes for the investigation/deduction or recovery judgment.

**Primary risk hypothesis to validate in M04:** Can the player explain which observed evidence supports the chosen rule and why the recovery response follows from the current telegraph? **Secondary support hypothesis:** does the calendar make preparation and aftermath legible without displacing that reasoning? Both are `UNTESTED`.

## 04. Loop contract

### Core loop — `CONFIRMED`

```text
Notice a case symptom
→ investigate observable evidence
→ compare hypotheses in the anomaly manual
→ apply the rule to victim rescue
→ read telegraphs and stabilize/recover resonance
→ read composite result
→ update manual, research, relationship, and calendar-supported next preparation
```

### Session loop — M01 / M04

| phase | player question | player action | feedback |
| --- | --- | --- | --- |
| preparation (support) | “What can I do before I go?” | schedule, select team/case | remaining time, active preparation, case availability |
| investigation (primary) | “What did I actually observe?” | choose observation/analysis/protection method | clue, flag, hint, explicit success/failure text |
| deduction/manual (primary) | “Which rule has evidence, and what still contradicts it?” | compare support/rebuttal/unresolved slots | readable evidence state, not an auto-answer |
| rescue | “How do I apply the rule to protect this person?” | rule-based rescue interaction | victim result remains separate |
| recovery (primary) | “Which telegraph demands which response now?” | choose protection/support/contextual response | anomaly stability, support feedback, recovery result |
| result | “What happened to the person, phenomenon, memory, and record?” | advance one narrative page at a time | causal, non-scoreboard ending |

### Meta loop — `PARTIAL`

Records, research, agent support, and relationships should widen safe questions and response options without revealing the hidden truth. Current detailed long-term rank/economy values are provisional/historical. The live target is **not** a fully proven progression loop yet.

## 05. System registry

### Experience hierarchy — `USER_APPROVED`

- **Primary playable core:** `investigation → deduction/manual → recovery`. This is the chain that must make the Vertical Slice fun, clear, and memorable.
- **Core-expression systems:** keyword/manual composition exposes the player’s deduction; victim rescue and composite result preserve the human consequence of that deduction and recovery.
- **Supporting campaign system:** the 10-day / half-day calendar creates preparation and aftermath rhythm. It is not a separate primary fun loop, an answer source, or a substitute for core-loop validation.

| ID | system | player value | state / owner |
| --- | --- | --- | --- |
| `SYS-CAL-01` | 10-day / half-day calendar | clear preparation opportunity and protection timing | `IMPLEMENTED / FOCUSED_MACHINE_VERIFIED`; first-operation cycle lock, dispatch context, and Preparation docket exist; numeric balance is `UNDEFINED` |
| `SYS-INV-01` | evidence-led investigation | read a situation before choosing a method | `IMPLEMENTED` shared scene/data grammar |
| `SYS-DED-01` | anomaly manual / competing hypotheses | prove a rule instead of selecting a lucky answer | `IMPLEMENTED` shared grammar; Human clarity `NOT_RUN` |
| `SYS-KEY-01` | page-local keyword / slot composition | compare source-grounded candidate wording without an answer recommender | `IMPLEMENTED_M01_M04 / DRAFT_ONLY / FOCUSED_MACHINE_VERIFIED`; no semantic answer verdict and no M05+ consumer |
| `SYS-RES-01` | victim rescue | make the human cost primary | `IMPLEMENTED` data/runtime baseline |
| `SYS-REC-01` | telegraph-first stabilization/recovery | turn knowledge into tense but legible action | `IMPLEMENTED` baseline |
| `SYS-RESULT-01` | composite result | preserve independent human/phenomenon/evidence outcomes | `IMPLEMENTED`; M04 uses its logical vignette successor while M01/legacy result surfaces remain compatible |
| `SYS-M04-02` | sequential narrative vignettes | make consequences memorable, one cause at a time | `IMPLEMENTED / FOCUSED_MACHINE_VERIFIED / HUMAN_QA_NOT_RUN` |
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
| `CNT-M04` | Red Umbrella Alley, release-near player-experience slice | `episode_002_red_umbrella_alley.json` | shared baseline, player-authored manual, non-numeric timing context, and sequential vignettes `IMPLEMENTED / FOCUSED_MACHINE_VERIFIED`; Human QA pending |
| `CNT-M07` | Dead Frequency Station | campaign case ID list | `PARTIAL / not evaluated this session` |
| `CNT-SLATE` | M01–M12 initial case slate, M13+ continuation | current planning canon | `CONFIRMED` as content budget, not a year-completion gate |

### M04 verified content facts

- Three required clues currently name the red umbrella fabric, repeating alley sign, and reverse rain flow.
- The investigation includes observation, analysis, and destructive/suppression approaches with explicit successes/failures.
- The rescue/recovery adapter names the protected subject `victim_alley_witness`.
- Existing result data already distinguishes temporary/standard/complete recovery outcomes.
- The M04 validation map keeps validation routing only; the live M04 episode owns its manual, three existing clue IDs, two rule pages, and rescue gate. Final visuals and Human QA remain pending.

## 07. 10-day schedule system — supporting campaign context

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

Day 1–9 is **early resolution**, and Day 10 is **regular resolution**. The latter is a normal route, not a late-state failure, penalty, or hidden bad ending. Early resolution has to protect earlier; regular resolution has to give more genuine preparation opportunities. The numerical effect that makes that trade-off tangible remains deliberately unapproved. This calendar is supporting campaign context: it may shape when the player prepares or reads aftermath, but it may not supply the rule, select the recovery response, or be used as evidence that the primary investigation/deduction/recovery loop is fun.

### What current runtime actually does

| runtime element | verified behavior | player-facing meaning today | status |
| --- | --- | --- | --- |
| `CampaignState.MAX_DAYS` | has ten days and resets/loads a clamped day range | the structural campaign clock exists | `IMPLEMENTED` |
| `TIME_SLOTS` | holds `morning`, then `afternoon`; acknowledging an AM result advances to PM, acknowledging PM advances the day | a half-day is an actual saved turn boundary | `IMPLEMENTED` |
| schedule assignment | only the active planning slot accepts a valid activity; the operation stores day, slot, and suspended/in-progress state | a player can plan the current half-day and resume it after save/load | `IMPLEMENTED` |
| case selection | the first actual `begin_operation()` stores `cycle_main_case_id` and rejects another main case during that cycle | exactly one main case per cycle is enforced without renaming historical case IDs | `IMPLEMENTED / FOCUSED_MACHINE_VERIFIED` |
| early/regular presentation | Preparation reads dispatch kind/day/slot and the result retains the non-numeric route-memory context | the player sees early/regular context and remaining-cycle reason; numerical reward or penalty remains undefined | `IMPLEMENTED / FOCUSED_MACHINE_VERIFIED / HUMAN_QA_NOT_RUN` |

This is a deliberate truth boundary: **exactly one main case per cycle** is an enforced runtime rule. The current cycle lock, dispatch context, Preparation docket, and M04 route-memory page prove the non-numeric product path; they do not define numerical timing balance or replace Human QA.

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

The keyword system is the bridge between “I found a clue” and “I can state a rule that changes what I do.” A keyword is a **non-consumable evidence reference with provenance**, not a colored loot card and not a currency. The manual is a player-authored deduction tool: it presents pre-authored, readable inference sentences with blank keyword slots. The player recalls the investigation, compares original source/acquisition context, and fills those blanks before committing to a rescue or recovery rule.

```text
Observed source and normal keyword
→ page-local candidate pool
→ compare source, acquisition context, and manual sentence
→ place a candidate in the relevant rule slot
→ reject only structural impossibilities immediately
→ create a candidate rule, not a correct-answer result
→ perform the rescue minigame and field recovery
→ keep semantic correctness unannounced until field verification
```

### Implemented M01/M04 contract — `IMPLEMENTED_M01_M04 / DRAFT_ONLY / FOCUSED_MACHINE_VERIFIED`

The approved design defines a normal keyword as source-grounded wording acquired through investigation. A mutated candidate is derived from that normal keyword by changing **one** meaningful variable (for example count, timing, order, direction, target, tool, or prohibition); it is not an independently acquired fake clue and has no independent source. A factual helper candidate that does not belong in the slot is distinct from a mutation. The player sees the relevant candidates in the same page-local pool and uses investigation memory, provenance, and the rest of the manual to distinguish them.

The pool is intentionally small and relevant: early pages begin around 5–6 candidates for three slots, standard pages 7–10, and major pages 9–12. Search/sort may use keyword name, original source, acquisition context, acquisition order, source grouping, or locale order. It must not filter by “correct,” “mutated,” “compatible with this slot,” or recommendation score. Structural errors can be blocked; a plausible but wrong reading must remain available for field learning. In particular, placing a plausible rule may set `candidate rule`; it cannot emit semantic correct/wrong or reveal the completed answer manual.

### Current runtime reality

M01 has source-backed candidate data and a full-screen dossier workbench. M04 owns its existing three clues, two rule pages, rescue gate, provenance records, and candidate pool directly in the live episode; `InvestigationScene` opens the same player-facing keyword-composition consumer for either authored manual. Both cases persist only existing `anomaly_manual_records[episode_id].draft_slots`, block structural impossibilities only, and never show a semantic answer verdict. M01 sets `normal_clear.reveal_complete_manual: false`; M04 adds no answer state or save-schema field.

| layer | current status | evidence boundary |
| --- | --- | --- |
| evidence records / clue IDs | `IMPLEMENTED` | current M01/M04 data and manual/recovery UI |
| competing hypotheses / support-rebuttal-unresolved records | `IMPLEMENTED / PARTIAL` | M01 case packet and shared reasoning grammar; Human clarity not tested |
| player-authored blank-manual composition | `IMPLEMENTED_M01_M04 / DRAFT_ONLY / FOCUSED_MACHINE_VERIFIED` | live candidate pools, input UI, and existing draft-slot save/load path; Human comprehension remains `NOT_RUN` |
| mutated-keyword field verification | `NOT_IMPLEMENTED_OUTSIDE_M01_M04_SLICE` | M01/M04 do not label mutations or reveal semantic verdicts; future M05+ field-verification expansion requires separate data and Human evidence |

### Production boundary

M01/M04 already implement the coherent vertical slice: source-backed candidate data → readable blank-manual input → structural-only validation → existing draft save/load → rescue and recovery field verification. M05+ expansion must not invent new clues, reveal an answer (including on normal clear), or replace M04's existing evidence truth. The two user-provided comparison images remain planning UI references, not copied assets or runtime UI requirements.

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

M04's three clue effects already supply an anchor, a route-loop break, and a timing stabilization advantage. Its result data independently represents unavailable, temporary, standard, and complete outcomes. Native Godot logical vignette pages now read rescue, resonance, route memory, and case record one cause at a time; they are not a new Scene or a Human-QA result.

### Recovery guardrails

- Never show a false telegraph or treat a random stat roll as the hidden-rule answer.
- The first unobserved pattern must retain at least one broadly protective, recoverable response.
- A wrong response produces a reason and future evidence, not an instant campaign lock or a secret correct answer.
- Equipment/companions may mitigate, reveal a related already-acquired clue, or improve a visible prediction; they may not complete the phase automatically.

## 11. M04 sequential narrative vignettes — `IMPLEMENTED / FOCUSED_MACHINE_VERIFIED`

M04 avoids a single dense result page with logical pages inside the current Godot result surface. This preserves M01/legacy result behavior and does not create a new runtime Scene.

| page ID | player learns | required input | prohibited shortcut |
| --- | --- | --- | --- |
| `VIGNETTE_VICTIM_RESCUE` | what happened to the victim | existing rescue result / after-story | overwriting it with recovery grade |
| `VIGNETTE_RESONANCE_RECOVERY` | what happened to the anomaly/resonance | existing recovery state | treating the victim as an enemy-health outcome |
| `VIGNETTE_ROUTE_MEMORY` | early/regular, resolution day/slot, actual Kwon support use | persisted dispatch context plus actual support use | old weekly numbers, hidden support-failure judgement |
| `VIGNETTE_CASE_RECORD` | record/research/next action | existing unlock/research data | inventing rewards, clues, or relation state |

`result_scene.gd` keeps the legacy direct result surface, and adds the M04-only logical vignette path. The four pages are Control content within the current result scene, with explicit continuation rather than a new result schema.

## 12. UI/UX and input contract

### Visual information hierarchy

| surface | player needs first | UI rule | status |
| --- | --- | --- | --- |
| main/menu | case identity, resume/enter path | director-room 3-rail language, not a poster | `IMPLEMENTED` baseline; Human usability `NOT_RUN` |
| preparation | calendar and meaningful next choice | day/slot/early/regular and one-case limit are readable before confirm | `IMPLEMENTED / FOCUSED_MACHINE_VERIFIED`; Human usability `NOT_RUN` |
| investigation | scene evidence and method trade-off | 2–4 choices; evidence before character spectacle | `IMPLEMENTED` baseline |
| manual / keyword | competing claims, provenance, and counter-evidence | separate observation from interpretation; never use answer-recommendation UI | `IMPLEMENTED_M01_M04 / DRAFT_ONLY`; Human comprehension `NOT_RUN` |
| rescue/recovery | protected subject and telegraph | protection/response priority over damage fantasy; show hypothesis → evidence → response | `IMPLEMENTED` baseline |
| result | one causal consequence at a time | short narrative pages, explicit continue/skip | M04 `IMPLEMENTED / FOCUSED_MACHINE_VERIFIED`; M01/legacy behavior preserved |

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
| `CampaignState` | `MAX_DAYS = 10`; morning/afternoon slots; first operation locks `cycle_main_case_id` and preserves dispatch context | calendar structure and one-case enforcement are active; numeric balance is intentionally absent |
| preparation scene | schedules agents, selects episode, begins/suspends/resumes an operation, and renders a dispatch docket | player-facing early/regular context and one-case availability are implemented |
| investigation scene | shows method choice, visible result, clue/hint/state change | current evidence-led investigation baseline is usable and must be preserved |
| keyword composition | M01 and M04 use source-backed candidate data, readable slots, and existing draft records | player-facing workbench exists; structural validation only and no semantic answer field |
| `monthly_state_policy.gd` | validates only `dispatch_risk` 0/15/30 and week index | historical generic state; do not reuse as new timing meaning |
| battle scene | telegraph, hypothesis, evidence, response, wrong-response learning, stability threshold, and one-time agent support | actual recovery baseline exists; timing bonus does not |
| result scene | legacy direct surface plus M04 logical vignette path | M04 four-page causal result is implemented without a new Scene |
| M04 JSON | existing clues, methods, rescue/recovery outcomes, manual pages, candidate provenance, and rescue gate | preserve existing case truth/content IDs and use one live manual owner |
| save state | additive monthly state, agent-support usage, dispatch context, and draft-slot records exist | no new save version or M04 answer-state field was added |
| headless runtime QA | Godot 4.7.2 editor import, then `test_three_case_campaign_manual_qa.gd` (136 pass / 0 fail), `mvp043_investigation_ui_test.gd` (PASS), and `mvp043_recovery_loop_test.gd` (PASS) | a fresh worktree needs the Godot import/class-cache preflight before direct script execution; a pre-import missing-class/texture-cache error is a test-environment failure, not product evidence |

### Architecture guardrails

1. Do not change protected `data/`, `scripts/`, `scenes/`, `assets/`, or `project.godot` without a current scoped approval and test-first evidence.
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
| The approved one-case-per-cycle rule is enforced by the first-operation cycle lock | `STRENGTH` | `campaign_state.gd`, M04 cadence tests | `FOCUSED_MACHINE_VERIFIED` | a player cannot receive a second main case in the same cycle | preserves existing IDs and enables the intended aftermath rhythm | `PROTECT` | Human explanation of early/regular trade-off |
| Keyword composition has source-backed M01/M04 data and a shared scene consumer | `STRENGTH` | M01/M04 manual tests, live episode data, `InvestigationScene` | `FOCUSED_MACHINE_VERIFIED` | source-comparison deduction is playable without answer UI | existing draft-save path avoids a new schema | `PROTECT` | Human comprehension and accessibility test |
| Day 10 and early/regular presentation, timing persistence, and M04 result pages exist; numeric balance remains undefined | `PARTIAL` | preparation/result scenes, campaign state | `FOCUSED_MACHINE_VERIFIED` | player can read the route context but its numerical weight remains unvalidated | balance needs a later decision, not another core refactor | `TEST` | one-at-a-time balance decision + Human QA |
| M04 result scene uses logical narrative pages while legacy direct result stays compatible | `STRENGTH` | `result_scene.gd`, M04 vignette tests | `FOCUSED_MACHINE_VERIFIED` | M04 outcome can be read as a causal memory | no new Scene or result schema needed | `PROTECT` | M04 readability and emotional recall playtest |
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
| `QA-KEY-01` | player acquires normal keyword with source/memory, fills a readable blank manual, receives only structural validation, save/loads it, sees no answer/variant recommendation or normal-clear answer reveal, then verifies one rule through rescue and recovery | `NOT_RUN` |
| `QA-REC-01` | player can explain the telegraph → hypothesis → evidence → response chain and learns from an intentional wrong response | `NOT_RUN` |
| `QA-M04-01` | M04 route-memory vignette uses one cause per page | `NOT_RUN` |
| `QA-M04-02` | M01 remains behaviourally unchanged | `NOT_RUN` for successor scope |
| `QA-UI-01` | 1280×720 / 1920×1080 Korean readability, mouse and keyboard | `NOT_RUN` |
| `QA-VIS-01` | consumer-specific asset provenance and runtime capture | `PARTIAL`; do not generalize |
| `QA-HUMAN-01` | new player explains core rule and early/regular trade-off | `NOT_RUN` |
| `QA-HUMAN-02` | player remembers a human/phenomenon consequence after M04 | `NOT_RUN` |

## 18. Implementation queue — not authorization

Order is driven by primary player value, then dependency and risk. No item starts in this GDD phase. A calendar item may be technically necessary later, but its place in a contract never makes it primary fun.

1. **Investigation → deduction → recovery vertical slice:** `IMPLEMENTED_M01_M04`; retain focused regression and obtain Human/player validation.
2. **Keyword/manual vertical slice:** `IMPLEMENTED_M01_M04`; retain structural-only validation and add no mutation-label or answer-reveal shortcut.
3. **M04 sequential vignette UI:** `IMPLEMENTED_M04_ONLY`; retain logical pages and collect Human readability evidence.
4. **Unified calendar support contract:** cycle lock, ten-day/two-slot save context, and docket are implemented; only the numerical early/regular balance decision remains open.
5. **Preparation timing surface and save/result bridge:** `IMPLEMENTED`; preserve non-numeric dispatch context and M04 route memory.
6. **Automated regression:** `IMPLEMENTED / FOCUSED_MACHINE_VERIFIED`; rerun for each successor change before Human QA.
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
one_main_case_runtime_enforcement: IMPLEMENTED / FOCUSED_MACHINE_VERIFIED
calendar_player_contract: IMPLEMENTED / FOCUSED_MACHINE_VERIFIED / NUMERIC_BALANCE_UNDEFINED
investigation_phase: IMPLEMENTED_SHARED_BASELINE
keyword_composition: IMPLEMENTED_M01_M04 / DRAFT_ONLY / FOCUSED_MACHINE_VERIFIED / OTHER_CASES_PENDING
player_authored_blank_manual: USER_APPROVED / IMPLEMENTED_M01_M04 / HUMAN_QA_NOT_RUN
m01_complete_manual_auto_reveal: IMPLEMENTED_FALSE / NO_AUTO_REVEAL
recovery_phase: IMPLEMENTED_SHARED_BASELINE
m04_timing_balance: UNDEFINED
m04_sequential_result_presentation: IMPLEMENTED_M04_ONLY / FOCUSED_MACHINE_VERIFIED / HUMAN_QA_NOT_RUN
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
| 2026-08-29 | fixed player-experience hierarchy: investigation/deduction and recovery are primary; the calendar is supporting campaign context | direct user decision; `D-2026-08-29-CORE-LOOP-PRIORITY` |
| 2026-08-29 | clarified that players acquire source-backed true keywords through investigation, complete blank manual sentences themselves, and verify without an answer UI through rescue/recovery | direct user decision; `D-2026-08-29-PLAYER-AUTHORED-MANUAL-KEYWORD-VERIFICATION` |
| 2026-08-30 | reconciled the human-facing GDD with verified M01/M04 cycle lock, dispatch docket, player-authored manual, and M04 logical-vignette runtime | current canon, exact local implementation head, focused machine evidence; Human QA remains not run |
