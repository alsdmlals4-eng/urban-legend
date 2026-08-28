# 2026-08-29 · Core-loop priority adversarial review

> Status: `CLEAN_REVIEW_EXIT`
>
> Scope: user-approved player-experience hierarchy correction. No runtime code, Scene, Resource, save schema, balance, asset, or Human/player validation is changed or authorized.

## Decision under review

- primary playable core: **investigation → deduction/manual → recovery**;
- calendar: 10-day / half-day **supporting campaign context**, not primary fun;
- keyword/manual: deduction-expression tool; victim rescue / Composite Result: human-consequence bridge;
- owner decision: `D-2026-08-29-CORE-LOOP-PRIORITY`.

## External check

- The official *Return of the Obra Dinn* site describes an exploration-and-logical-deduction mystery. The official publisher description for *The Case of the Golden Idol* describes examining clues and building a theory. These are evidence for the narrow claim that an investigation game can center evidence interpretation; they do not prescribe this project's structure, art, cases, or result flow.
- **ADOPT:** make player-observable evidence and explainable inference the primary validation question.
- **ADAPT:** use the existing telegraph-first recovery to turn an inference into a live action test.
- **REJECT:** copying either reference's presentation, setting, case construction, or declaring the calendar itself to be the central deduction challenge.

Sources: <https://obradinn.com/>, <https://www.nintendo.com/us/store/products/the-case-of-the-golden-idol-complete-edition-70010000086587-switch/>.

## Five full adversarial loops

| loop | failure assumption | evidence checked | finding / correction | result |
| --- | --- | --- | --- | --- |
| 1 | The calendar remains the first thing a reader sees and is inferred to be the core loop. | current planning promise, Master GDD promise/core-loop text, handoff. | Reordered the promise and core flow around investigation, deduction, and recovery; marked the calendar `supporting campaign context`. | `PASS_AFTER_CORRECTION` |
| 2 | Reclassifying the calendar silently cancels the approved 10-day / Day 1–9 / Day 10 contract. | cadence decision, canon invariants, Master GDD schedule section. | Preserved all cadence, early/regular, one-case, and no-hidden-truth rules. Only player-experience hierarchy changes. | `PASS` |
| 3 | Keyword/manual or victim rescue is accidentally erased from the causal loop. | M01/M04 flow, current core flow, keyword/recovery boundary. | Kept keyword/manual as deduction expression and rescue/Composite Result as human-consequence bridge; no runtime status promoted. | `PASS` |
| 4 | Recovery is recast as a calendar payoff rather than a player judgment. | `telegraph → hypothesis → evidence → response` contract and recovery baseline. | Made recovery a primary validation target; calendar cannot choose a response or reveal core truth. | `PASS_AFTER_CORRECTION` |
| 5 | A planning label is mistaken for runtime or player evidence. | JSON state, focused static tests, changed-path audit. | Decision explicitly has `NO_RUNTIME_MUTATION`; all Human/new-player validation remains `NOT_RUN`. | `PASS` |

## Evidence and remaining work

- `VERIFIED`: current document/JSON synchronization, static regression coverage, unchanged approved cadence semantics, current M01/M04 core-flow alignment, and external-reference scope.
- `NOT_RUN`: Human/new-player comprehension, first-session fun, calendar player UI, keyword composition consumer, save round-trip successor, target-resolution usability, audio, and production asset promotion.
- **Incident:** the Master GDD's prior order could make a reader treat the schedule as the product's principal loop despite the user's primary experience being investigation/deduction and recovery.
- **Solution:** added a user-approved hierarchy Decision and synchronized canonical Markdown/JSON/handoff/GDD ownership without changing runtime behavior.
- **Lesson:** a campaign cadence must be labeled as support when it frames a case but does not itself supply evidence, inference, or field verification. This is project-specific; `NO_BASE_PROMOTION`.
