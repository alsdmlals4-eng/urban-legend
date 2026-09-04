# Afterlife Station FACT → MEANING → IDENTITY PoC Human Playtest Contract

- Decision: `D-2026-08-11-HYBRID-NARRATIVE-DEDUCTION-GROWTH-INTEGRATION`
- Package: `PACKAGE_1_AFTERLIFE_FACT_MEANING_IDENTITY_POC`
- Contract status: `PREREGISTERED_PLANNING_CONTRACT / SESSIONS_NOT_RUN`
- Evidence status before sessions: `HUMAN_USABILITY_EVIDENCE=NOT_RUN / PLAYER_EXPERIENCE_EVIDENCE=NOT_RUN`
- Recommended starting sample: `5 fresh/unexposed sessions`
- Statistical claim ceiling: `RECOMMENDED_STARTING_SAMPLE / NOT_POPULATION_EVIDENCE`

## 1. Purpose

This contract measures whether one Afterlife Station vertical slice actually produces the intended reasoning and callback experience. It does not treat automated tests, author self-play, or existing benchmark evidence as Human/player-experience proof.

The three independently classified PoC components are:

1. chapter-1 Thought Path;
2. `point_staff_room_door` Scene Contract;
3. post-case Oh Hyun incident callback.

## 2. Fixed test route

1. Start the current Afterlife Station first-run flow without briefing the participant on the case rule.
2. Observe chapter-1 evidence review until the participant states a hypothesis about why destinations differ.
3. Do not explain whether a hypothesis is correct during the session.
4. Continue to `point_staff_room_door` and observe the participant's chosen method and stated reason.
5. For the causal callback route, use/observe successful `destruction` at `point_staff_room_door` with Oh Hyun selected.
6. Continue to the normal result/report surface and observe the existing `오현의 돌파 경고` callback.

The observer must not add hints that are absent from the current product surface merely to keep the route moving. If a session cannot reach a required observation naturally, record the blocker instead of manufacturing the missing evidence.

## 3. Session observations

For each actual session record all of the following:

- whether the participant stated the page-1 hypothesis before an explicit answer-like phrase was noticed;
- which two or more independent records they cited, if any;
- whether `목적지는 방송되지 않는다` or equivalent intro/manual wording was described as giving away the answer;
- the staff-room method chosen and the participant's reason;
- whether the participant understood the method as `information / attitude / risk / relationship / action`;
- whether the participant recognized the Oh Hyun callback as caused by the earlier staff-room choice;
- whether the participant described a Narae working style/responsibility implication without being shown a morality/affection score;
- whether they instead interpreted the callback as generic hidden affection/trust points;
- any accessibility/input issue that prevented observation, without counting accessibility use as a gameplay failure.

## 4. Preregistered decision rules

### Thought Path

`THOUGHT_PATH_KEEP` requires at least **4/5** participants to independently articulate a page-1 hypothesis using at least **two independent records** before explicit answer exposure.

If this threshold is missed, classify Thought Path as `CHANGE` or `RETEST`; do not average the miss into PASS.

### Priming

`PRIMING_CHANGE` is triggered if at least **2/5** participants say the manual page title or intro wording supplied the answer.

If triggered, wording/presentation becomes a separate bounded CHANGE package before broader Thought-Path validation. The current Package 1 runtime implementation does not silently edit the baseline first.

### Callback causality

`CALLBACK_CAUSALITY_KEEP` requires at least **4/5** participants to correctly identify the staff-room choice as the causal source of the Oh Hyun callback after seeing it.

### Hidden-meter interpretation

`HIDDEN_METER_CHANGE` is triggered if at least **2/5** participants primarily interpret the callback as generic affection/trust points rather than incident memory.

If triggered, revise the feedback presentation before any Core Relationship Network L2 promotion. Do not solve it by exposing a relationship meter.

### Evidence ceiling

Automated CI cannot satisfy any of the four Human rules above.

The five-session recommendation is an initial decision sample only. It is not population evidence and does not justify claims about broad commercial audiences.

## 5. Evidence row schema

Use one row per actual session with these fields:

```text
session_id
exposure_status
page1_hypothesis_before_answer
independent_record_count
records_cited
priming_reported
priming_source
staff_room_choice
choice_reason
choice_role_interpretation
callback_cause_identified
identity_or_responsibility_read
hidden_meter_interpretation
accessibility_or_input_blocker
observer_notes
artifact_refs
```

Do not fill a missing observation by inference. Use `NOT_OBSERVED` with the blocker in `observer_notes`.

## 6. Session-level recording table

| Session | Exposure | Page-1 hypothesis before answer | Independent records | Priming reported | Staff-room choice/reason | Callback cause identified | Identity/responsibility read | Hidden-meter read | Blocker | Artifact refs |
|---|---|---|---:|---|---|---|---|---|---|---|
| S01 | `NOT_RUN` | `NOT_RUN` | 0 | `NOT_RUN` | `NOT_RUN` | `NOT_RUN` | `NOT_RUN` | `NOT_RUN` | — | — |
| S02 | `NOT_RUN` | `NOT_RUN` | 0 | `NOT_RUN` | `NOT_RUN` | `NOT_RUN` | `NOT_RUN` | `NOT_RUN` | — | — |
| S03 | `NOT_RUN` | `NOT_RUN` | 0 | `NOT_RUN` | `NOT_RUN` | `NOT_RUN` | `NOT_RUN` | `NOT_RUN` | — | — |
| S04 | `NOT_RUN` | `NOT_RUN` | 0 | `NOT_RUN` | `NOT_RUN` | `NOT_RUN` | `NOT_RUN` | `NOT_RUN` | — | — |
| S05 | `NOT_RUN` | `NOT_RUN` | 0 | `NOT_RUN` | `NOT_RUN` | `NOT_RUN` | `NOT_RUN` | `NOT_RUN` | — | — |

These rows are preregistered placeholders for **future actual sessions**, not evidence that sessions occurred.

## 7. Package disposition

After actual sessions, classify each component separately:

| Component | Allowed disposition |
|---|---|
| Thought Path | `KEEP / CHANGE / RETEST / REMOVE` |
| Scene Contract | `KEEP / CHANGE / RETEST / REMOVE` |
| Oh Hyun callback | `KEEP / CHANGE / RETEST / REMOVE` |

Only `KEEP` components may become candidates for separate Investigator Identity / Core Relationship Network / Year-One L2 Specs.

Do not promote those later systems merely because automated contract tests are green.

## 8. Evidence publication lifecycle

This file is a **planning-stage preregistration contract**, so current planning/spec documents may reference it.

When actual Human sessions are executed, store completed evidence under the repository's Human-QA lifecycle conventions and link it from QA/history surfaces rather than turning completed evidence into a current design dependency. Current design authority remains the Decision + approved Spec + Phase B review; evidence supports or challenges those decisions but does not silently rewrite them.
