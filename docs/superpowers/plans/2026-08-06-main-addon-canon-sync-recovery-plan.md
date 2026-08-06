# Main Addon and Canon Sync Recovery Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restore one auditable current state after unreviewed GUT/UID changes by enforcing selective addon adoption, isolating UID validation, synchronizing GitHub and Google Sheet canon, and preserving honest Human QA claim ceilings.

**Architecture:** Add a project-owned addon adoption ledger and static contract tests before changing the plugin. Resolve GUT through a separate approval-gated implementation PR, validate UID changes independently with Godot import and full regression, then update all status surfaces using one decision ID. Product design, episode data, save authority, and narrative content remain untouched.

**Tech Stack:** Python 3.12 `unittest`, JSON/Markdown operating contracts, Godot 4.7.1/GDScript, existing project validation scripts and GitHub Actions, Google Sheets decision ledger.

## Global Constraints

- Do not merge without explicit user approval.
- Do not edit `data/episodes/`, story text, dialogue, clues, flags, save schema, or game-balance values.
- `addons/`, `scripts/`, `scenes/`, `assets/`, and `project.godot` remain protected paths.
- GUT 9.7.1 is not accepted as active merely because files exist or the editor plugin is enabled.
- An addon must declare exact source, version, license, adoption state, consumption path, validation, duplicate-authority check, and rollback.
- HiGodot remains the sole Godot authoring/editor-automation mutation authority; GUT may only serve test execution.
- UID changes are reviewed separately from GUT adoption.
- Existing PR #164 evidence remains historical evidence for commit `47e4bff7ea66d6f6a3792afe846f8a5d9320e966`, not proof for later heads.
- Runtime, local device, Human QA, and UI accessibility states remain `NOT_RUN` until executed.
- Google Sheet and GitHub updates must use the same decision ID.

---

## File Structure

- Create `docs/operations/GODOT_ADDON_ADOPTION_LEDGER.json`: project-owned machine-readable addon states.
- Create `tests/test_godot_addon_adoption_contract.py`: prevents enabled addons without adoption and consumption evidence.
- Modify `skills/PROJECT_BASE_ADAPTER.json`: adopt the selective-addon contract and point to the ledger after Base release identity is verified.
- Modify `docs/BASE_RULES_VERSION.md`: remove the 9.4.0/9.4.3 split and record the exact adopted Base identity.
- Modify `project.godot`: remove GUT activation only if `UL-DEC-ADDON-001=REMOVE_DEFER` is approved.
- Delete `addons/gut/`: only in the approval-gated removal task.
- Create `docs/validation/GUT_AND_UID_RECOVERY_VALIDATION.md`: exact commands, outputs, SHAs, and claim ceiling.
- Modify `START_HERE.md`, `docs/CURRENT_HANDOFF_VALIDATION.md`, and `docs/CURRENT_STATUS.md`: point all entry surfaces to the same current state.
- Update Google Sheet tabs `00_프로젝트_허브`, `01_작업순서`, `02_현재_확정결정`, `04_누락_충돌_감사`, and `99_변경이력` with the same decision IDs.

---

### Task 1: Add the addon adoption contract

**Files:**
- Create: `tests/test_godot_addon_adoption_contract.py`
- Create: `docs/operations/GODOT_ADDON_ADOPTION_LEDGER.json`

**Interfaces:**
- Consumes: `project.godot` `[editor_plugins] enabled`, `docs/operations/GODOT_ADDON_ADOPTION_LEDGER.json`.
- Produces: `AddonAdoptionContractTests`, and ledger schema version `1`.

- [ ] **Step 1: Write the failing contract test**

Create `tests/test_godot_addon_adoption_contract.py`:

```python
from __future__ import annotations

import json
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PROJECT = ROOT / "project.godot"
LEDGER = ROOT / "docs/operations/GODOT_ADDON_ADOPTION_LEDGER.json"
VALID_STATES = {
    "CANDIDATE",
    "TRIAL_APPROVED",
    "ADOPTED_ACTIVE",
    "DEFERRED",
    "INSTALLED_UNUSED",
    "REMOVAL_PENDING",
}


def enabled_plugin_paths() -> set[str]:
    text = PROJECT.read_text(encoding="utf-8")
    match = re.search(
        r"\[editor_plugins\]\s+enabled=PackedStringArray\((.*?)\)",
        text,
        re.DOTALL,
    )
    if match is None:
        return set()
    return set(re.findall(r'"([^"]+/plugin\.cfg)"', match.group(1)))


def load_ledger() -> dict:
    return json.loads(LEDGER.read_text(encoding="utf-8"))


class AddonAdoptionContractTests(unittest.TestCase):
    def test_every_enabled_plugin_has_a_ledger_entry(self) -> None:
        payload = load_ledger()
        entries = {item["plugin_cfg"]: item for item in payload["addons"]}
        self.assertEqual(set(entries), enabled_plugin_paths())

    def test_active_addons_have_real_consumption_and_rollback(self) -> None:
        for item in load_ledger()["addons"]:
            self.assertIn(item["adoption_state"], VALID_STATES)
            self.assertTrue(item["exact_version"])
            self.assertTrue(item["license"])
            self.assertTrue(item["rollback"])
            if item["adoption_state"] == "ADOPTED_ACTIVE":
                self.assertTrue(item["consumption_paths"])
                self.assertTrue(item["validation_commands"])
                self.assertNotEqual("NOT_RUN", item["latest_validation_state"])

    def test_installed_unused_is_not_claimed_active(self) -> None:
        for item in load_ledger()["addons"]:
            if not item["consumption_paths"]:
                self.assertIn(
                    item["adoption_state"],
                    {"CANDIDATE", "DEFERRED", "INSTALLED_UNUSED", "REMOVAL_PENDING"},
                )


if __name__ == "__main__":
    unittest.main()
```

- [ ] **Step 2: Run the test and verify RED**

Run:

```bash
python -m unittest tests.test_godot_addon_adoption_contract -v
```

Expected: FAIL because `docs/operations/GODOT_ADDON_ADOPTION_LEDGER.json` does not exist.

- [ ] **Step 3: Add the initial ledger**

Create `docs/operations/GODOT_ADDON_ADOPTION_LEDGER.json`:

```json
{
  "artifact_role": "GODOT_ADDON_ADOPTION_LEDGER",
  "schema_version": 1,
  "project": "alsdmlals4-eng/urban-legend",
  "decision_id": "UL-DEC-ADDON-001",
  "addons": [
    {
      "addon_id": "godot_ai",
      "plugin_cfg": "res://addons/godot_ai/plugin.cfg",
      "source": "project-existing-addon",
      "exact_version": "VERIFY_FROM_PLUGIN_CFG",
      "license": "VERIFY_FROM_REPOSITORY_LICENSE_RECORD",
      "role": "GODOT_AUTHORING_AUTOMATION",
      "authority_scope": "SOLE_AUTHORING_AUTHORITY",
      "adoption_state": "ADOPTED_ACTIVE",
      "consumption_paths": ["Godot editor authoring workflow"],
      "validation_commands": ["python -m unittest discover -s tests -v"],
      "latest_validation_state": "REVERIFY_REQUIRED",
      "rollback": "Disable plugin and restore the last reviewed project.godot through a dedicated PR"
    },
    {
      "addon_id": "gut",
      "plugin_cfg": "res://addons/gut/plugin.cfg",
      "source": "direct-main-commit-5e06fa4230ec73e50b8ed856a23bc3940c7c5814",
      "exact_version": "9.7.1",
      "license": "MIT_VERIFY_BUNDLED_LICENSE",
      "role": "TEST_FRAMEWORK",
      "authority_scope": "NON_AUTHORING_TEST_ONLY",
      "adoption_state": "INSTALLED_UNUSED",
      "consumption_paths": [],
      "validation_commands": [],
      "latest_validation_state": "NOT_RUN",
      "rollback": "Remove res://addons/gut/plugin.cfg from project.godot and delete addons/gut in an approval-gated PR"
    }
  ]
}
```

Before committing, replace the two `VERIFY_...` values with facts read from repository files. Do not preserve them as placeholders.

- [ ] **Step 4: Run the focused test**

Run:

```bash
python -m unittest tests.test_godot_addon_adoption_contract -v
```

Expected: PASS only after every enabled plugin has one complete ledger entry.

- [ ] **Step 5: Commit**

```bash
git add tests/test_godot_addon_adoption_contract.py docs/operations/GODOT_ADDON_ADOPTION_LEDGER.json
git commit -m "test: enforce project addon adoption evidence"
```

---

### Task 2: Resolve Base adoption identity

**Files:**
- Modify: `skills/PROJECT_BASE_ADAPTER.json`
- Modify: `docs/BASE_RULES_VERSION.md`
- Test: `tests/test_base_v943_first_prompt_adoption.py`
- Create: `tests/test_base_addon_policy_adoption.py`

**Interfaces:**
- Consumes: exact Base release/finalization evidence and Base commit `4f98f968a377f7b6a11aafa4fc94d11bddbebedc`.
- Produces: one non-conflicting Base identity and `godot_addon_utilization` adapter contract.

- [ ] **Step 1: Verify whether Base has issued a release newer than 9.4.3**

Run:

```bash
gh api repos/alsdmlals4-eng/Base/contents/releases

gh api repos/alsdmlals4-eng/Base/commits/4f98f968a377f7b6a11aafa4fc94d11bddbebedc
```

Expected: capture exact release version, payload commit, evidence commit, finalization commit, and registry hash. If `4f98f968...` is policy-on-main but not a finalized release, preserve Base 9.4.3 identity and record the addon policy as `UPSTREAM_POLICY_REVIEW_PENDING`; do not invent a new release number.

- [ ] **Step 2: Write a failing addon-policy adoption test**

Create `tests/test_base_addon_policy_adoption.py`:

```python
from __future__ import annotations

import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ADAPTER = ROOT / "skills/PROJECT_BASE_ADAPTER.json"
LEDGER = "docs/operations/GODOT_ADDON_ADOPTION_LEDGER.json"


class BaseAddonPolicyAdoptionTests(unittest.TestCase):
    def test_adapter_routes_addon_evaluation(self) -> None:
        data = json.loads(ADAPTER.read_text(encoding="utf-8"))
        routes = {
            item["skill_id"]
            for item in data["routing"]["base_routes"]
            if item.get("status") == "ACTIVE"
        }
        self.assertIn("evaluating-godot-assets-and-plugins-before-creation", routes)

    def test_adapter_points_to_project_ledger(self) -> None:
        data = json.loads(ADAPTER.read_text(encoding="utf-8"))
        contract = data["shared_overrides"]["evaluating-godot-assets-and-plugins-before-creation"]
        self.assertEqual(LEDGER, contract["addon_adoption_ledger"])
        self.assertEqual("SELECTIVE_PROJECT_SPECIFIC", contract["adoption_policy"])
        self.assertEqual("INSTALLED_UNUSED", contract["unused_addon_state"])


if __name__ == "__main__":
    unittest.main()
```

- [ ] **Step 3: Run RED**

```bash
python -m unittest tests.test_base_addon_policy_adoption -v
```

Expected: FAIL because the adapter does not yet point to the ledger.

- [ ] **Step 4: Add the minimal adapter contract**

Set the existing override to:

```json
"evaluating-godot-assets-and-plugins-before-creation": {
  "addon_adoption_ledger": "docs/operations/GODOT_ADDON_ADOPTION_LEDGER.json",
  "adoption_policy": "SELECTIVE_PROJECT_SPECIFIC",
  "unused_addon_state": "INSTALLED_UNUSED",
  "core_systems_not_to_outsource": [
    "investigation-record-recovery loop",
    "case fairness rules",
    "canonical episode data"
  ],
  "search_focus": [
    "dialogue branching",
    "localization",
    "timeline",
    "investigation log UI",
    "audio events"
  ]
}
```

Update `docs/BASE_RULES_VERSION.md` with the verified exact Base identity. Do not claim adoption of an unreleased Base payload.

- [ ] **Step 5: Run focused Base tests**

```bash
python -m unittest \
  tests.test_base_v943_first_prompt_adoption \
  tests.test_base_addon_policy_adoption \
  tests.test_godot_addon_adoption_contract \
  -v
```

Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add skills/PROJECT_BASE_ADAPTER.json docs/BASE_RULES_VERSION.md tests/test_base_addon_policy_adoption.py
git commit -m "docs: align Base addon adoption contract"
```

---

### Task 3: Apply the approved GUT decision

**Files:**
- Modify: `project.godot`
- Delete or retain: `addons/gut/`
- Modify: `docs/operations/GODOT_ADDON_ADOPTION_LEDGER.json`
- Test: `tests/test_godot_addon_adoption_contract.py`

**Interfaces:**
- Consumes: explicit user decision `UL-DEC-ADDON-001`.
- Produces: either a removed/deferred GUT state or an evidence-backed active GUT test path.

- [ ] **Step 1: Record the approved branch**

Accepted values:

```text
REMOVE_DEFER
KEEP_AND_INTEGRATE
```

Do not execute this task without one exact value linked to the user's approval.

- [ ] **Step 2A: Implement `REMOVE_DEFER`**

Remove only `"res://addons/gut/plugin.cfg"` from `project.godot`, preserving `godot_ai`. Delete `addons/gut/`. Update the ledger by removing GUT from enabled addons and recording it in a top-level `deferred_addons` array with the original version, source commit, reason `NO_PROJECT_CONSUMPTION_PATH`, and rollback/re-adoption requirements.

- [ ] **Step 2B: Implement `KEEP_AND_INTEGRATE`**

Create one representative GUT test for a pure, stable project contract; do not start with scene screenshots or save mutation. Add the exact `godot --headless -s addons/gut/gut_cmdln.gd ...` command to CI and the ledger. Keep adoption state `TRIAL_APPROVED` until import plus focused and full regression pass. Only then change it to `ADOPTED_ACTIVE`.

- [ ] **Step 3: Run addon contract tests**

```bash
python -m unittest tests.test_godot_addon_adoption_contract -v
```

Expected: PASS with no enabled plugin lacking evidence.

- [ ] **Step 4: Commit protected-path change separately**

```bash
git add project.godot addons/gut docs/operations/GODOT_ADDON_ADOPTION_LEDGER.json
git commit -m "chore: apply approved GUT adoption decision"
```

---

### Task 4: Validate UID changes independently

**Files:**
- Create: `docs/validation/GUT_AND_UID_RECOVERY_VALIDATION.md`
- Modify only if required by verified failure: the specific broken `.uid` or resource reference.

**Interfaces:**
- Consumes: current branch after Task 3 and Godot 4.7.1 executable.
- Produces: import, parse, regression, and Human QA preflight evidence tied to one commit SHA.

- [ ] **Step 1: Record the candidate SHA and environment**

```bash
git rev-parse HEAD
godot --version
python --version
```

Write exact output into `docs/validation/GUT_AND_UID_RECOVERY_VALIDATION.md`.

- [ ] **Step 2: Run Python contracts**

```bash
python -m unittest discover -s tests -v
```

Expected: all existing tests plus the new addon contracts PASS. Record the exact count; do not copy an old count.

- [ ] **Step 3: Run Godot import**

```bash
godot --headless --path . --editor --quit
```

Expected: exit code 0, no parse error, no missing UID/resource error.

- [ ] **Step 4: Run the repository's existing focused and full Godot regressions**

Read `.github/workflows/` and use the exact commands already executed by current CI. Do not substitute a shorter test set. Record every command, exit code, and test count.

- [ ] **Step 5: Run the one-click Human QA preflight without elevating Human QA**

On Windows:

```bat
START_HUMAN_QA.cmd
```

The launcher opening and preflight success may be recorded as `LOCAL_RUNNER_PREFLIGHT_PASSED`. Actual save creation, screen inspection, mouse/keyboard/gamepad behavior, and accessibility remain separate manual checks.

- [ ] **Step 6: Commit evidence**

```bash
git add docs/validation/GUT_AND_UID_RECOVERY_VALIDATION.md
git commit -m "test: record addon and UID recovery validation"
```

---

### Task 5: Synchronize all current-state surfaces

**Files:**
- Modify: `START_HERE.md`
- Modify: `docs/CURRENT_HANDOFF_VALIDATION.md`
- Modify: `docs/CURRENT_STATUS.md`
- Modify: Google Sheet tabs `00_프로젝트_허브`, `01_작업순서`, `02_현재_확정결정`, `04_누락_충돌_감사`, `99_변경이력`

**Interfaces:**
- Consumes: exact validated commit SHA and decision IDs from Tasks 3–4.
- Produces: one current status, same next action, same claim ceiling, same PR/commit references across GitHub and Sheet.

- [ ] **Step 1: Write one canonical status payload**

Use these fields everywhere:

```yaml
decision_id: UL-DEC-ADDON-001
validated_commit: <exact Task 4 SHA>
gut_state: <DEFERRED or TRIAL_APPROVED or ADOPTED_ACTIVE>
uid_validation: <PASSED or FAILED>
automated_regression: <exact result and count>
local_runner_preflight: <actual result>
human_qa: NOT_RUN
ui_accessibility_qa: NOT_RUN
next_action: <one exact action>
```

Replace angle-bracket values with executed facts; do not commit placeholders.

- [ ] **Step 2: Update GitHub entry documents**

Ensure `START_HERE.md`, `CURRENT_HANDOFF_VALIDATION.md`, and `CURRENT_STATUS.md` agree on head, Base identity, addon state, QA ceilings, and next action. Preserve historical PR evidence as historical, not current.

- [ ] **Step 3: Update Google Sheet with minimal ranges**

Read target rows immediately before writing. Update only the rows/cells that own current status and append one row to each ledger tab. Do not overwrite formulas or unrelated formatting. Use the same decision ID and exact GitHub references.

- [ ] **Step 4: Read back every written range**

Verify values and types from the Sheet after write. Confirm the project hub no longer points to PR #149 or an obsolete `main` SHA.

- [ ] **Step 5: Run static consistency tests**

```bash
python -m unittest discover -s tests -v
```

Expected: PASS, with any status-freshness contract checking the new current values.

- [ ] **Step 6: Commit GitHub status sync**

```bash
git add START_HERE.md docs/CURRENT_HANDOFF_VALIDATION.md docs/CURRENT_STATUS.md
git commit -m "docs: synchronize addon recovery handoff state"
```

---

### Task 6: PR adversarial review and merge gate

**Files:**
- No new product files.
- Review the complete PR diff and Sheet readback evidence.

**Interfaces:**
- Consumes: all task commits and validation evidence.
- Produces: `PASS`, `BLOCKED`, or `PASS_WITH_HUMAN_QA_OPEN` review result.

- [ ] **Step 1: Compare the PR against current `main`**

```bash
gh pr diff <PR_NUMBER>
gh pr checks <PR_NUMBER>
```

Confirm no story, episode data, save schema, game balance, or unrelated asset changes.

- [ ] **Step 2: Run adversarial checklist**

```text
[ ] GUT has either a real consumer or is removed/deferred
[ ] No same-role authoring authority duplicates HiGodot
[ ] UID changes passed Godot import and full regression
[ ] Base identity is exact and not invented
[ ] Project hub and detailed Sheet ledgers agree
[ ] GitHub entry documents agree
[ ] PR #164 evidence is not misapplied to later commits
[ ] Human QA and accessibility remain NOT_RUN unless actually executed
[ ] Rollback is explicit
[ ] Merge has explicit user approval
```

- [ ] **Step 3: Leave the PR as Draft until approval**

Do not enable auto-merge. Do not merge based only on automated green checks.

- [ ] **Step 4: After explicit approval, merge with expected head SHA**

Use the exact reviewed head SHA to prevent a moved-head merge. After merge, read `main`, the merged PR, and Sheet current rows again before reporting completion.
