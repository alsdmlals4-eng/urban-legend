# M01 Entrance Background Adapt 01 — Comparison Evidence

## Scope

- Issue: `#293`
- Existing canonical asset: `assets/backgrounds/afterlife_entrance.png`
- Candidate: `docs/visual/candidates/M01_ENTRANCE_BACKGROUND_ADAPT_01.png`
- Static consumer proof: `UiAssetCatalog` routes M01 dialogue to `afterlife_entrance`; Main Menu applies the same texture as a full-screen `STRETCH_KEEP_ASPECT_COVERED` backdrop beneath a `Color(0.025, 0.035, 0.05, 0.82)` overlay; dialogue assigns the same `ArtLayer/Background` texture to `LocationPanel` preview.

## Decision

`CANDIDATE_NOT_PROMOTED / REUSE_REVIEW`.

The candidate's soft anime-noir surface is closer to the approved treatment, but it substitutes the current, readable descending-station threshold with a generic platform corridor. Its large blank sign and two central pillars take the compact preview's limited focal area, so it does not improve the shared consumer enough to justify replacing an existing valid asset.

## Incident → solution → lesson

**Incident:** the live Hera comparison could not start because its available ports were already occupied by unrelated active projects.

**Solution:** did not interrupt those editors or mutate the product asset; used exact consumer routes, Main Menu overlay configuration, and direct pixel comparison to make the safe non-promotion decision.

**Project lesson:** a replacement needs to retain the location's narrative landmark, not only the art treatment. For M01 entrance, the descending threshold is a shared-consumer requirement.

**Base promotion assessment:** `NO_NEW_REUSE_LEARNING`; current Base contracts already require actual-consumer proof before promotion and preservation when the comparison is inconclusive or unfavorable.

## Evidence boundary

- Runtime/Hera resolution captures: `NOT_RUN` (unrelated live-editor port occupancy).
- Human QA: `NOT_RUN`.
- Canonical PNG, scene wiring, UI, data, and gameplay: unchanged.
