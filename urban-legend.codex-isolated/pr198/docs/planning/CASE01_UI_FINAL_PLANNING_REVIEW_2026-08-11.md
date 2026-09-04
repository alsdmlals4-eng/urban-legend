# CASE-01 UI Final Planning Review — 2026-08-11

> Work Mode: `REVIEW`
> Review route: `attack → validate-critique → refine-approved-findings → regression-recheck → decision-report`
> Planning PR: `#197`
> Project main baseline: `c903d557399abfc0e44ee79f531a8d37ba5968d9`
> Base remote main observed: `23d5b292f619022cdd8ab7a33fb1debc2d294861`
> Project Base release identity: `v9.4.3 / payload 7dd1a4f80388bc5faca767ff74a3eb32dc9d0ac8`
> Product runtime mutation in PR #197: `NONE`
> Human/UI evidence: `NOT_RUN`

## 1. Review target

This review attacks the CASE-01 investigation UI planning package before any Phase C product/test build.

Current authority bundle:

- `D-2026-08-11-LUME-INTEGRATED-COMPANION-NO-LOG-TAB`
- `D-2026-08-11-CASE01-RECORDS-TAB-ARCHIVE-IA`
- `D-2026-08-11-CASE01-MANUAL-KEYWORD-INPUT-CONTRACT`
- `D-2026-08-11-CASE01-LANDSCAPE-SAME-COMPOSITION-UI`
- `D-2026-08-11-CASE01-SHARED-LOCATION-TRAVEL-CONTRACT`
- `D-2026-08-11-CASE01-FIELD-INVESTIGATION-SURFACE-CONTRACT`
- `D-2026-08-11-CASE01-MANUAL-FIVE-SECTION-THREE-CHAPTER-MAPPING`
- `D-2026-08-11-CASE01-UI-SEPARATION-SPEC-APPROVED`
- `D-2026-08-11-CASE01-UI-RUNTIME-PROJECTION-MAPPING`
- base Spec + `CASE01_ACTUAL_GAME_UI_SEPARATION_SPEC_2026-08-11-r2-addendum.md`
- base Plan + `2026-08-11-case01-investigation-ui-implementation-plan-r2-addendum.md`

Existing product implementation facts are read from latest `main`; PR #180 UI hierarchy is already merged and must be adapted, not rebuilt.

## 2. Failure assumptions attacked

The review assumed the planning package could fail through:

1. silently replacing the existing 3-page/14-slot Canon v2 manual with five independent logic pages;
2. visually leaking mutated/correct candidates;
3. reintroducing a `로그`/`AI 로그` tab;
4. treating Lume as a redesignable case skin despite the user's fixed visual reference;
5. duplicating map and field movement rules;
6. inventing new field-node/save/domain truth to support location UI;
7. binding an unapproved Lume/UI image as a product asset;
8. rebuilding PR #180's already-merged hierarchy rather than adapting it;
9. colliding with active PR #196 protected-path work;
10. starting product/test BUILD before the exact v4.5-r2 planning-completion trigger;
11. promoting automated checks to Human/UI evidence;
12. trusting stale Sheet current-state text over live GitHub implementation facts.

## 3. Findings and dispositions

| Finding | Severity | Validation | Disposition |
|---|---|---|---|
| Lume Decision allowed case-by-case visual variation | MUST_FIX | Contradicted user's fixed-Lume approval | FIXED in `ff18a3c8...`; explicit new approval now required for identity/costume/face/silhouette/pose-family changes |
| Gate A examples exposed `[변조]` in player-facing labels | MUST_FIX | Contradicted no-answer-leak / equal candidate presentation | FIXED in `6d4e8fbb...`; internal lineage retained, pre-reveal display normalized |
| Base Spec still contains an old future-case Lume variation sentence | MUST_FIX | Large-file safe replacement unavailable through current connector | FIXED non-destructively with authoritative r2 Spec addendum `2cde22ff...` |
| Base Plan still contains `[변조]` notation from authoring canon | MUST_FIX | Could be misread as product display copy | FIXED with mandatory r2 Plan addendum `a600dadf...` |
| Travel wording could be read as two separate UI-local movement systems | SHOULD_FIX | User explicitly approved one shared travel authority | FIXED in Gate A/r2: one dataset + one shared handler, two entry points |
| `AGENTS.md` global default says player guide is Aca while CASE-01 approved helper is Lume | USER_DECISION_ALREADY_SCOPED / FRESHNESS_DEBT | Latest user Decision is more specific; connector cannot safely round-trip the truncated large file | RECORD scoped exception: global Aca remains outside this feature; CASE-01 investigation/device uses Lume. Safe router propagation deferred, not silently overwritten |
| Sheet `D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT` still reports PR #180 as Draft while live GitHub main has #180 merged | SHOULD_FIX_OUTSIDE_FEATURE / CURRENT_STATE_DRIFT | GitHub implementation fact is newer | RECORD conflict. Use live main for implementation; do not mutate unrelated row in CASE-01 feature PR |
| Current formal image tables contain no approved CASE-01/Lume product asset | BLOCKED_UNVERIFIED_PRODUCT_ASSET | `71`/`72` reread confirms no current product approval | Keep Visual Requirement Gate; text/native UI may proceed only after Phase C, image binding remains blocked |
| Exact v4.5-r2 `기획 완료` declaration not received | HARD_GATE | Current user message approves recommendation/continuous planning, not exact trigger | Phase C product/test BUILD remains NOT_STARTED |

## 4. Core and contract preservation

The planning package preserves:

- Canon v2 3 pages and 4/5/5 slot counts;
- page candidate pool sizes 8/9/10;
- final manual completion → rescue flow;
- session-time answer secrecy;
- non-consuming evidence reference behavior;
- existing point conditions/locked text;
- existing save version and Canon v2 `manual.filled_slots` storage;
- existing PR #180 investigation hierarchy runtime;
- current recovery/rescue/campaign truth;
- `scripts/core/game_state.gd`, `project.godot`, `data/episodes/**` as untouched protected inputs for this planned slice;
- no real audio player/waveform/audio evidence playback;
- player-facing top navigation exactly `[기록] [괴이 매뉴얼] [지도]`.

## 5. Runtime projection approved

Five UI sections project onto three logic pages without changing domain progression:

```text
발생 조건  → page 1 slots: broadcast_blank + official_absence
피해자 연결 → page 1 slots: listener_memory + destination_mismatch
금지 행동  → all page 2 slots
구출 절차  → all page 3 slots
회수 대응  → no editable investigation slot; existing recovery patterns read-only
```

Location projection is presentation-only over existing investigation points:

```text
승강장   → victim_phone / platform_speaker / frequency_terminal / terminal_sign
개찰구   → black_ticket
역무원실 → staff_room_door / staff_room_log
```

Map and field `[이동]` use the same dataset and handler; explicit confirmation precedes movement.

## 6. Active-PR collision review

- PR #196 modifies protected `scripts/core/game_state.gd` and incident-context test surface. CASE-01 UI implementation is intentionally designed not to edit `game_state.gd`; runtime branch must still be rebased/freshly checked before work.
- PR #189 owns a Canon overlay pointer RED. CASE-01 tests must not overwrite or reinterpret that blocker evidence.
- PR #193/#192/#191 are current-router/freshness/handoff docs. Their stale-state corrections should not be duplicated inside product UI runtime.
- PR #183 owns Main Menu presentation. CASE-01 UI does not modify Main Menu.

## 7. Google Sheet comparison

Same Decision IDs for the CASE-01 planning package are present in `02_현재_확정결정`, including the newly approved runtime-projection mapping.

Known differences are explicitly preserved rather than silently reconciled:

- PR #180 implementation status is stale in the Sheet; live GitHub main is implementation authority.
- CASE-01 fixed Lume is a scoped latest-user exception to the older global Aca line in `AGENTS.md`; current Sheet row records the conflict.
- CASE-01/Lume image product approval is absent from `71`/`72` and remains blocked.

## 8. Regression recheck result

After approved corrections:

- no planning contract authorizes an independent `[로그]`/`AI 로그` tab;
- Lume fixed visual identity is explicit in the current Decision and r2 Spec/Plan overlays;
- pre-reveal mutated ancestry is not player-visible;
- the five-section UI does not become five domain chapters;
- both movement entry points converge on one handler;
- no new save key/version or field node is authorized;
- visual product asset promotion remains gated;
- Phase C remains blocked by exact `기획 완료`.

The original large Spec and Plan retain historical/stale sentences internally, but their corresponding r2 addenda are explicit current overrides. This is an intentional non-destructive compatibility choice until safe full-file/partial-patch authoring is available.

## 9. Final planning verdict

```yaml
planning_design: APPROVED_WITH_R2_CORRECTIONS
runtime_projection_mapping: USER_APPROVED
planning_pr_scope: DOCS_ONLY
runtime_build: NOT_STARTED
phase_c_gate: BLOCKED_PENDING_EXACT_기획_완료
visual_product_asset_gate: BLOCKED_PENDING_71_72_PROJECT_ASSET_APPROVED_MANIFEST
human_ui_qa: NOT_RUN
android_qa: NOT_RUN
remaining_user_design_question: NONE_FOR_GATE_A
remaining_execution_gate: EXACT_PLANNING_COMPLETE_DECLARATION
```

PR #197 may be validated and prepared for planning merge. Product/test implementation must not begin until the exact planning-completion declaration is received and a fresh implementation-start audit is completed.
