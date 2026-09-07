# M04 Player-Authored Manual Workbench Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Connect the M04 Red Umbrella evidence to the existing Godot player-authored manual workbench without adding a semantic answer checker.

**Architecture:** The M04 episode becomes the single owner of its readable manual pages, provenance records, candidate keywords, and already-approved rescue-context metadata. `InvestigationScene` opens the existing workbench whenever the active episode supplies candidate keywords. The workbench receives a generic guide view model: M01 keeps Lume’s portrait, M04 uses text-only Archivist Aka.

**Tech Stack:** Godot 4.7, GDScript, JSON episode data, existing shell-based headless Godot regression runners.

**Spec:** `docs/superpowers/specs/2026-08-30-m04-player-authored-manual-design.md`

## Global Constraints

- Scope is `episode_002_red_umbrella_alley` plus the shared presentation path only; do not create M05+ content.
- Preserve the existing save version and `GameState.anomaly_manual_records` draft-only API.
- Reuse only the three declared M04 clue IDs and existing M04 rule/rescue contracts.
- M04 guide text is `기록관 아카` with no portrait; Lume’s approved portrait remains CASE-01-only.
- Never store or display semantic truth, answer, correct/wrong, recommendation, score, or auto-reveal fields.
- Keep existing recovery/minigame behavior and all user save bytes unchanged.

---

### Task 1: Move the M04 manual contract into the runtime episode

**Files:**
- Create: `tests/m04/m04_player_authored_manual_contract_test.gd`
- Modify: `data/episodes/episode_002_red_umbrella_alley.json`
- Modify: `data/episodes/episode_002_red_umbrella_alley_validation_map.json`
- Modify: `tests/m04/m04_validation_baseline_test.gd`

**Interfaces:**
- Consumes: `ManualKeywordCompositionPolicy.validate_manual(manual) -> Dictionary` and `SharedInvestigationManualPolicy.validate_contract(manual) -> Dictionary`.
- Produces: `episode.investigation_manual`, containing `pages`, `slots`, `evidence_records`, `candidate_keywords`, `record_ids`, `rule_pages`, and `rescue_gate`.

- [ ] **Step 1: Write the failing test**

```gdscript
var manual := episode.get("investigation_manual", {}) as Dictionary
_expect(not manual.is_empty(), "M04 runtime episode must own its player-authored manual")
_expect(bool(composition.validate_manual(manual).get("ok", false)), "M04 manual must satisfy draft-only composition policy")
_expect(bool(shared.validate_contract(manual).get("ok", false)), "M04 manual must retain existing rescue-context contract")
```

- [ ] **Step 2: Run test to verify it fails**

```bash
GODOT_BIN="$GODOT_BIN" bash tests/run_godot_regression.sh
```

Expected: the new M04 test fails because the live episode lacks `investigation_manual`.

- [ ] **Step 3: Write minimal implementation**

Move the existing `rule_m04_rain_rewind`, `rule_m04_victim_tether`, three clue IDs, and rescue gate from the validation map into the M04 episode. Add two readable deduction pages, their slots, provenance entries, and one-variable candidate pairs. Remove the copied manual payload from the validation map and make the baseline test validate the live episode instead.

- [ ] **Step 4: Run test to verify it passes**

```bash
GODOT_BIN="$GODOT_BIN" bash tests/run_godot_regression.sh
```

Expected: M04 manual contract and existing baseline tests pass.

- [ ] **Step 5: Commit**

```bash
git add data/episodes/episode_002_red_umbrella_alley.json data/episodes/episode_002_red_umbrella_alley_validation_map.json tests/m04/m04_player_authored_manual_contract_test.gd tests/m04/m04_validation_baseline_test.gd
git commit -m "feat: add player-authored M04 manual data"
```

### Task 2: Open the existing workbench for all authored manuals

**Files:**
- Create: `tests/m04/m04_manual_workbench_integration_test.gd`
- Modify: `scripts/scenes/investigation_scene.gd`
- Modify: `tests/run_godot_regression.sh`

**Interfaces:**
- Consumes: `GameState.get_current_episode() -> Dictionary`, `GameState.set_manual_draft_slot(manual, slot_id, candidate_id, episode_id)`, and the episode’s `investigation_manual`.
- Produces: `_get_player_authored_workbench_manual() -> Dictionary`, `_build_player_authored_workbench_model(manual) -> Dictionary`, and M04 `ManualToggleButton` activation.

- [ ] **Step 1: Write the failing test**

```gdscript
_expect(scene._get_player_authored_workbench_manual().size() > 0, "M04 authored manual must open the workbench")
var model := scene._build_player_authored_workbench_model(manual)
_expect(String((model.get("guide", {}) as Dictionary).get("name", "")) == "기록관 아카", "M04 must use Aka guide text")
```

- [ ] **Step 2: Run test to verify it fails**

```bash
GODOT_BIN="$GODOT_BIN" godot --headless --path . --script res://tests/m04/m04_manual_workbench_integration_test.gd
```

Expected: the CASE-01-only workbench gate makes the M04 model unavailable.

- [ ] **Step 3: Write minimal implementation**

Replace the CASE-01-only gate with an active-episode authored-manual gate. Keep all CASE-01-specific layout, record drawer, and Lume data intact. M04 creates the same workbench and uses text-only Aka copy; no M04 page opens a separate read-only manual drawer.

- [ ] **Step 4: Run test to verify it passes**

```bash
GODOT_BIN="$GODOT_BIN" godot --headless --path . --script res://tests/m04/m04_manual_workbench_integration_test.gd
GODOT_BIN="$GODOT_BIN" godot --headless --path . --script res://tests/case01_ui/m01_manual_workbench_integration_test.gd
```

Expected: M04 draft intent reaches the existing state API and M01 remains CASE-01-only.

- [ ] **Step 5: Commit**

```bash
git add scripts/scenes/investigation_scene.gd tests/m04/m04_manual_workbench_integration_test.gd tests/run_godot_regression.sh
git commit -m "feat: open authored manuals from investigation"
```

### Task 3: Render guide identity without leaking Lume into M04

**Files:**
- Modify: `tests/case01_ui/manual_deduction_workbench_test.gd`
- Modify: `tests/m04/m04_manual_workbench_integration_test.gd`
- Modify: `scripts/ui/manual_deduction_workbench.gd`

**Interfaces:**
- Consumes: `view_model.guide` with `name`, `message`, and `portrait_visible`; legacy `view_model.lume` remains a M01 compatibility fallback.
- Produces: correct guide text and portrait visibility while retaining M01’s `LumeGuidePanel` and `LumePortrait` test nodes.

- [ ] **Step 1: Write the failing test**

```gdscript
_expect(not portrait.visible, "M04 guide must not display Lume portrait")
_expect(name_label.text == "기록관 아카", "M04 guide identity must be Aka")
```

- [ ] **Step 2: Run test to verify it fails**

```bash
GODOT_BIN="$GODOT_BIN" godot --headless --path . --script res://tests/m04/m04_manual_workbench_integration_test.gd
```

Expected: current workbench unconditionally renders Lume portrait and fallback text.

- [ ] **Step 3: Write minimal implementation**

Resolve a generic guide dictionary first, then fallback to legacy `lume`. Render the approved portrait only when `portrait_visible` is true; otherwise hide it and reduce the guide panel to text. Preserve CASE-01 test fixture behavior.

- [ ] **Step 4: Run test to verify it passes**

```bash
GODOT_BIN="$GODOT_BIN" godot --headless --path . --script res://tests/m04/m04_manual_workbench_integration_test.gd
GODOT_BIN="$GODOT_BIN" godot --headless --path . --script res://tests/case01_ui/manual_deduction_workbench_test.gd
```

Expected: M04 shows Aka text only; M01 shows Lume with the approved texture.

- [ ] **Step 5: Commit**

```bash
git add scripts/ui/manual_deduction_workbench.gd tests/case01_ui/manual_deduction_workbench_test.gd tests/m04/m04_manual_workbench_integration_test.gd
git commit -m "feat: render manual guide per case"
```

### Task 4: Reconcile current documentation and verify the slice

**Files:**
- Create: `docs/approvals/PROJECT_PROTECTED_CHANGE_APPROVAL_M04_PLAYER_AUTHORED_MANUAL_20260830.json`
- Modify: `docs/CURRENT_DECISION_OVERLAY.md`
- Modify: `docs/current-planning-canon.json`

**Interfaces:**
- Consumes: current user authorization and exact changed-path evidence.
- Produces: `M01_M04_IMPLEMENTED / OTHER_CASES_PENDING` documentation state without claiming global rollout or Human QA.

- [ ] **Step 1: Write the documentation acceptance test**

```bash
python -m unittest tests/test_active_document_references.py
```

- [ ] **Step 2: Run it before reconciliation**

```bash
python -m unittest tests/test_active_document_references.py
```

Expected: baseline passes; this preserves the document-router contract before status wording changes.

- [ ] **Step 3: Write minimal documentation changes**

Record M04 implementation and automated evidence separately from M05+ pending work, Human QA, product-reference asset status, and release evidence. Keep the approval receipt limited to M04 manual data, workbench presentation, scene integration, and tests.

- [ ] **Step 4: Run full verification**

```bash
GODOT_BIN="$GODOT_BIN" bash tests/run_validation_package_2_tests.sh
GODOT_BIN="$GODOT_BIN" bash tests/run_godot_regression.sh
python -m unittest discover -s tests -p 'test_*.py'
git diff --check
```

Expected: all executed checks pass; save hash is read again afterwards.

- [ ] **Step 5: Commit**

```bash
git add docs/approvals/PROJECT_PROTECTED_CHANGE_APPROVAL_M04_PLAYER_AUTHORED_MANUAL_20260830.json docs/CURRENT_DECISION_OVERLAY.md docs/current-planning-canon.json
git commit -m "docs: record M04 authored manual implementation"
```

## Self-Review

- Spec coverage: Task 1 owns single-source data and no-answer structure; Task 2 owns visible entry and state intent; Task 3 owns guide identity and M01 regression; Task 4 owns current status and verification.
- Placeholder scan: no `TBD`, deferred implementation, or undefined interface remains.
- Type consistency: manual is a `Dictionary`; guide is a `Dictionary`; draft writes retain existing `String` slot and candidate IDs.

## Execution Decision

The user already explicitly selected continuation of the recommended approach. Execute this plan inline in the current isolated worktree, preserving the user save and stopping only for a true out-of-scope or irreversible decision.

## Execution Result — 2026-08-30

Tasks 1–4 are implemented in this worktree. M04 now owns its existing three-clue manual data and opens the shared dossier workbench; the guide is text-only `기록관 아카`, while CASE-01 keeps Lume's approved portrait. The system remains draft-only and adds no answer state or save-schema field. Focused contract tests, the Package 2 suite, the complete Godot regression runner, and the Python suite were run; Human, accessibility, and release QA remain `NOT_RUN`.
