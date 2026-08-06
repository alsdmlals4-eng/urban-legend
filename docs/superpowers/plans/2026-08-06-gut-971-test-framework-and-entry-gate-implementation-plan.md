# GUT 9.7.1 Test Framework and Mandatory Entry Gate Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement an evidence-backed GUT 9.7.1 test path and a scope-aware mandatory entry gate while preserving HiGodot as the sole Godot authoring authority.

**Architecture:** Introduce machine-readable authority and entry-gate ledgers, contract tests that reject incomplete or generic states, one pure GUT test for `ValidationRouteMapper`, and a dedicated CI workflow that runs import, GUT, existing regressions, JUnit collection, and protected-diff verification. Keep GUT at `TRIAL_APPROVED` until all exact-HEAD gates pass.

**Tech Stack:** Godot 4.7.1, GDScript, GUT 9.7.1, Python 3.12 `unittest`, JSON, GitHub Actions, Google Sheets readback evidence.

## Global Constraints

- Implement on a new branch created from the latest reviewed target head after design approval.
- Do not merge without explicit exact-HEAD user approval.
- HiGodot is the only authority allowed to modify scenes, nodes, resources, or `project.godot`.
- GUT test execution must not modify tracked files in `project.godot`, `addons/`, `scripts/`, `scenes/`, `assets/`, or `data/`.
- GUT writes are limited to `.artifacts/gut/` and isolated `user://test_runs/` paths.
- Do not change episode data, clues, flags, answers, save schema, narrative, balance, or product assets.
- Do not infer installed GUT tree identity from version metadata alone.
- Do not use standalone `READY`, `AWAITING`, `CANON_READY`, `IMPLEMENTATION_PLAN_READY`, or `AUTOMATED_PACKAGE_READY` as current entry authorization.
- Missing decision, unresolved, image, exact-HEAD, CI, or Human QA evidence blocks entry.
- Existing PR #164 checks are historical evidence only for `47e4bff7ea66d6f6a3792afe846f8a5d9320e966`.
- UID validation is independent and cannot be satisfied by a GUT pass.

---

## File Structure

- Create: `docs/operations/GODOT_TOOL_AUTHORITY_LEDGER.json`
  - Exact HiGodot/GUT roles, source, lifecycle, consumption, CI, and rollback.
- Create: `docs/operations/PROJECT_ENTRY_GATE.json`
  - Current gate inputs, forbidden generic states, block reasons, and allowed scopes.
- Create: `tools/governance/evaluate_project_entry_gate.py`
  - Deterministic gate evaluator with nonzero blocked exit.
- Create: `tests/test_project_entry_gate_contract.py`
  - Static and behavioral contract tests for the gate.
- Create: `tests/test_godot_tool_authority_contract.py`
  - Verifies installed plugin declarations and non-overlapping authority.
- Create: `tests/gut/test_validation_route_mapper.gd`
  - First project-owned GUT test.
- Create: `.gutconfig.json`
  - Canonical GUT discovery and JUnit settings.
- Create: `.github/workflows/validate-gut-test-authority.yml`
  - Focused GUT, JUnit, existing regressions, and protected-diff gate.
- Modify: `skills/PROJECT_BASE_ADAPTER.json`
  - Point addon evaluation and project-entry governance to project ledgers.
- Modify: `docs/BASE_RULES_VERSION.md`
  - Reconcile Base version identity without claiming an unreleased Base release.
- Create: `docs/validation/GUT_9_7_1_ADOPTION_VALIDATION.md`
  - Exact commands, run IDs, outputs, SHA, and claim ceiling.
- Modify after validation only: `START_HERE.md`, `docs/CURRENT_STATUS.md`, `docs/CURRENT_HANDOFF_VALIDATION.md`
  - Current entry-point readback.

---

### Task 1: Add RED tests for authority separation

**Files:**
- Create: `tests/test_godot_tool_authority_contract.py`
- Create later in this task: `docs/operations/GODOT_TOOL_AUTHORITY_LEDGER.json`

**Interfaces:**
- Consumes: `project.godot`, `addons/gut/plugin.cfg`, `addons/gut/LICENSE.md`.
- Produces: `GodotToolAuthorityContractTests` and ledger schema version `1`.

- [ ] **Step 1: Write the failing authority contract test**

Create `tests/test_godot_tool_authority_contract.py`:

```python
from __future__ import annotations

import json
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PROJECT = ROOT / "project.godot"
LEDGER = ROOT / "docs/operations/GODOT_TOOL_AUTHORITY_LEDGER.json"
GUT_PLUGIN = ROOT / "addons/gut/plugin.cfg"
GUT_LICENSE = ROOT / "addons/gut/LICENSE.md"
PROTECTED_PATHS = {
    "project.godot",
    "addons/",
    "scripts/",
    "scenes/",
    "assets/",
    "data/",
}


def enabled_plugins() -> set[str]:
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


class GodotToolAuthorityContractTests(unittest.TestCase):
    def test_all_enabled_plugins_are_declared(self) -> None:
        payload = load_ledger()
        declared = {item["plugin_cfg"] for item in payload["tools"]}
        self.assertEqual(enabled_plugins(), declared)

    def test_exact_gut_identity_is_declared(self) -> None:
        payload = load_ledger()
        gut = next(item for item in payload["tools"] if item["tool_id"] == "gut")
        self.assertEqual("9.7.1", gut["exact_version"])
        self.assertEqual("bitwes/Gut", gut["upstream_repository"])
        self.assertEqual("godot_4_7", gut["upstream_branch"])
        self.assertEqual(
            "aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605",
            gut["upstream_commit"],
        )
        self.assertEqual("MIT", gut["license"])
        self.assertEqual("4.7.x", gut["compatible_godot"])
        self.assertEqual("TRIAL_APPROVED", gut["adoption_state"])

    def test_gut_plugin_and_license_match_declared_metadata(self) -> None:
        plugin = GUT_PLUGIN.read_text(encoding="utf-8")
        license_text = GUT_LICENSE.read_text(encoding="utf-8")
        self.assertIn('version="9.7.1"', plugin)
        self.assertIn("The MIT License (MIT)", license_text)
        self.assertIn('Copyright (c) 2018 Tom "Butch" Wesley', license_text)

    def test_authoring_authority_is_unique(self) -> None:
        tools = load_ledger()["tools"]
        authors = [item for item in tools if item["authority"] == "GODOT_AUTHORING"]
        self.assertEqual(1, len(authors))
        self.assertEqual("higodot", authors[0]["tool_id"])

    def test_gut_has_no_product_mutation_scope(self) -> None:
        gut = next(item for item in load_ledger()["tools"] if item["tool_id"] == "gut")
        self.assertEqual("TEST_EXECUTION", gut["authority"])
        self.assertEqual([], gut["allowed_product_mutations"])
        self.assertTrue(PROTECTED_PATHS.issubset(set(gut["forbidden_mutation_paths"])))
        self.assertTrue(gut["consumption_paths"])
        self.assertTrue(gut["ci_commands"])
        self.assertTrue(gut["rollback_steps"])

    def test_active_claim_requires_validation(self) -> None:
        gut = next(item for item in load_ledger()["tools"] if item["tool_id"] == "gut")
        if gut["adoption_state"] == "ADOPTED_ACTIVE":
            self.assertEqual("PASS", gut["latest_exact_head_validation"]["state"])
            self.assertRegex(
                gut["latest_exact_head_validation"]["commit"],
                r"^[0-9a-f]{40}$",
            )


if __name__ == "__main__":
    unittest.main()
```

- [ ] **Step 2: Run RED**

```bash
python -m unittest tests.test_godot_tool_authority_contract -v
```

Expected: FAIL because `GODOT_TOOL_AUTHORITY_LEDGER.json` does not exist.

- [ ] **Step 3: Create the initial authority ledger**

Create `docs/operations/GODOT_TOOL_AUTHORITY_LEDGER.json`:

```json
{
  "artifact_role": "GODOT_TOOL_AUTHORITY_LEDGER",
  "schema_version": 1,
  "project": "alsdmlals4-eng/urban-legend",
  "decision_ids": [
    "UL-DEC-ADDON-001",
    "UL-DEC-AUTHORITY-001"
  ],
  "protected_paths": [
    "project.godot",
    "addons/",
    "scripts/",
    "scenes/",
    "assets/",
    "data/"
  ],
  "tools": [
    {
      "tool_id": "higodot",
      "plugin_cfg": "res://addons/godot_ai/plugin.cfg",
      "authority": "GODOT_AUTHORING",
      "authority_cardinality": "SOLE",
      "allowed_operations": [
        "create_edit_save_scenes",
        "create_edit_save_nodes",
        "create_edit_save_resources",
        "edit_project_settings"
      ],
      "allowed_product_mutations": [
        "project.godot",
        "scripts/",
        "scenes/",
        "assets/"
      ],
      "forbidden_operations": [
        "forge_test_pass",
        "suppress_gut_failure",
        "replace_human_qa"
      ],
      "adoption_state": "ADOPTED_ACTIVE",
      "consumption_paths": [
        "Godot editor authoring workflow"
      ],
      "ci_commands": [],
      "rollback_steps": [
        "Disable res://addons/godot_ai/plugin.cfg in a dedicated reviewed PR",
        "Restore the last reviewed project.godot",
        "Run Godot import and the full regression matrix"
      ],
      "latest_exact_head_validation": {
        "state": "REVERIFY_REQUIRED",
        "commit": ""
      }
    },
    {
      "tool_id": "gut",
      "plugin_cfg": "res://addons/gut/plugin.cfg",
      "authority": "TEST_EXECUTION",
      "authority_cardinality": "NON_AUTHORING",
      "upstream_repository": "bitwes/Gut",
      "upstream_branch": "godot_4_7",
      "upstream_commit": "aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605",
      "exact_version": "9.7.1",
      "compatible_godot": "4.7.x",
      "license": "MIT",
      "license_path": "addons/gut/LICENSE.md",
      "installed_tree_match": "NOT_RUN",
      "allowed_operations": [
        "discover_tests",
        "execute_tests",
        "assert_results",
        "create_doubles_stubs_spies",
        "write_junit_artifacts"
      ],
      "allowed_product_mutations": [],
      "allowed_write_paths": [
        ".artifacts/gut/",
        "user://test_runs/"
      ],
      "forbidden_mutation_paths": [
        "project.godot",
        "addons/",
        "scripts/",
        "scenes/",
        "assets/",
        "data/"
      ],
      "forbidden_operations": [
        "invoke_higodot_mutation",
        "modify_user_save_origin",
        "convert_failure_to_success",
        "replace_human_qa"
      ],
      "adoption_state": "TRIAL_APPROVED",
      "consumption_paths": [
        "tests/gut/test_validation_route_mapper.gd",
        ".github/workflows/validate-gut-test-authority.yml"
      ],
      "ci_commands": [
        "godot --headless -d -s --path . addons/gut/gut_cmdln.gd -gdir=res://tests/gut -ginclude_subdirs -gexit -gjunit_xml_file=.artifacts/gut/junit.xml"
      ],
      "rollback_steps": [
        "Set adoption_state to REMOVAL_PENDING",
        "Disable res://addons/gut/plugin.cfg through a dedicated reviewed PR",
        "Remove addons/gut only after an equivalent test path exists",
        "Preserve historical JUnit and adoption evidence",
        "Run Godot import and the full regression matrix",
        "Set adoption_state to REMOVED"
      ],
      "latest_exact_head_validation": {
        "state": "NOT_RUN",
        "commit": ""
      }
    }
  ]
}
```

- [ ] **Step 4: Run GREEN**

```bash
python -m unittest tests.test_godot_tool_authority_contract -v
```

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add tests/test_godot_tool_authority_contract.py docs/operations/GODOT_TOOL_AUTHORITY_LEDGER.json
git commit -m "test: enforce HiGodot and GUT authority separation"
```

---

### Task 2: Add RED tests for the mandatory entry gate

**Files:**
- Create: `tests/test_project_entry_gate_contract.py`
- Create later in this task: `docs/operations/PROJECT_ENTRY_GATE.json`
- Create later in this task: `tools/governance/evaluate_project_entry_gate.py`

**Interfaces:**
- Consumes: one JSON evidence payload path.
- Produces: scoped `ENTRY_ALLOWED_FOR_*` or blocking `ENTRY_BLOCKED_*`, plus exit code `0` only for allowed states.

- [ ] **Step 1: Write the failing behavioral tests**

Create `tests/test_project_entry_gate_contract.py`:

```python
from __future__ import annotations

import importlib.util
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / "tools/governance/evaluate_project_entry_gate.py"
CONTRACT = ROOT / "docs/operations/PROJECT_ENTRY_GATE.json"
FORBIDDEN_CURRENT_STATES = {
    "READY",
    "AWAITING",
    "CANON_READY",
    "IMPLEMENTATION_PLAN_READY",
    "AUTOMATED_PACKAGE_READY",
}


def load_module():
    spec = importlib.util.spec_from_file_location("entry_gate", SCRIPT)
    if spec is None or spec.loader is None:
        raise AssertionError("entry gate module cannot be loaded")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def valid_evidence() -> dict:
    return {
        "requested_scope": "TEST_IMPLEMENTATION",
        "decision": {"state": "APPROVED", "id": "UL-DEC-ADDON-001"},
        "unresolved": {"open_p0": 0, "open_p1": 0, "open_decisions": 0},
        "images": {
            "required": False,
            "planning_state": "NOT_APPLICABLE",
            "review_state": "NOT_APPLICABLE"
        },
        "github": {
            "head": "a" * 40,
            "evidence_head": "a" * 40,
            "checks": "PASS",
            "review_threads_open": 0
        },
        "authority": {"state": "PASS"},
        "gut": {"required": True, "state": "TRIAL_APPROVED"},
        "human_qa": {"required": False, "state": "NOT_APPLICABLE"}
    }


class ProjectEntryGateContractTests(unittest.TestCase):
    def test_contract_forbids_generic_current_states(self) -> None:
        payload = json.loads(CONTRACT.read_text(encoding="utf-8"))
        self.assertTrue(
            FORBIDDEN_CURRENT_STATES.issubset(set(payload["forbidden_current_states"]))
        )

    def test_valid_test_scope_is_allowed(self) -> None:
        module = load_module()
        result = module.evaluate(valid_evidence())
        self.assertEqual("ENTRY_ALLOWED_FOR_TEST_IMPLEMENTATION", result["state"])
        self.assertEqual([], result["blockers"])

    def test_missing_source_blocks(self) -> None:
        module = load_module()
        evidence = valid_evidence()
        del evidence["images"]
        result = module.evaluate(evidence)
        self.assertEqual("ENTRY_BLOCKED_MISSING_SOURCE", result["state"])

    def test_open_p1_blocks(self) -> None:
        module = load_module()
        evidence = valid_evidence()
        evidence["unresolved"]["open_p1"] = 1
        result = module.evaluate(evidence)
        self.assertEqual("ENTRY_BLOCKED_OPEN_P0_P1", result["state"])

    def test_required_image_without_product_approval_blocks(self) -> None:
        module = load_module()
        evidence = valid_evidence()
        evidence["images"] = {
            "required": True,
            "planning_state": "PLANNING_WIREFRAME_REVIEWED",
            "review_state": "PRODUCT_ASSET_NOT_APPROVED"
        }
        result = module.evaluate(evidence)
        self.assertEqual("ENTRY_BLOCKED_IMAGE_EVIDENCE", result["state"])

    def test_head_mismatch_blocks(self) -> None:
        module = load_module()
        evidence = valid_evidence()
        evidence["github"]["evidence_head"] = "b" * 40
        result = module.evaluate(evidence)
        self.assertEqual("ENTRY_BLOCKED_EXACT_HEAD_EVIDENCE", result["state"])

    def test_cli_returns_nonzero_when_blocked(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "evidence.json"
            evidence = valid_evidence()
            evidence["unresolved"]["open_p0"] = 1
            path.write_text(json.dumps(evidence), encoding="utf-8")
            completed = subprocess.run(
                [sys.executable, str(SCRIPT), str(path)],
                cwd=ROOT,
                capture_output=True,
                text=True,
                check=False,
            )
            self.assertNotEqual(0, completed.returncode)
            self.assertIn("ENTRY_BLOCKED_OPEN_P0_P1", completed.stdout)


if __name__ == "__main__":
    unittest.main()
```

- [ ] **Step 2: Run RED**

```bash
python -m unittest tests.test_project_entry_gate_contract -v
```

Expected: FAIL because the contract and evaluator do not exist.

- [ ] **Step 3: Create the gate contract**

Create `docs/operations/PROJECT_ENTRY_GATE.json`:

```json
{
  "artifact_role": "PROJECT_ENTRY_GATE_CONTRACT",
  "schema_version": 1,
  "decision_id": "UL-DEC-ENTRY-GATE-001",
  "required_sources": [
    "decision",
    "unresolved",
    "images",
    "github",
    "authority",
    "gut",
    "human_qa"
  ],
  "forbidden_current_states": [
    "READY",
    "AWAITING",
    "CANON_READY",
    "IMPLEMENTATION_PLAN_READY",
    "AUTOMATED_PACKAGE_READY"
  ],
  "allowed_states": [
    "ENTRY_ALLOWED_FOR_DOCS_ONLY",
    "ENTRY_ALLOWED_FOR_TEST_IMPLEMENTATION",
    "ENTRY_ALLOWED_FOR_PRODUCT_IMPLEMENTATION",
    "ENTRY_ALLOWED_FOR_IMAGE_GENERATION",
    "ENTRY_ALLOWED_FOR_IMAGE_IMPLEMENTATION"
  ],
  "blocked_states": [
    "ENTRY_BLOCKED_MISSING_SOURCE",
    "ENTRY_BLOCKED_OPEN_P0_P1",
    "ENTRY_BLOCKED_OPEN_DECISION",
    "ENTRY_BLOCKED_IMAGE_EVIDENCE",
    "ENTRY_BLOCKED_EXACT_HEAD_EVIDENCE",
    "ENTRY_BLOCKED_AUTHORITY_CONFLICT",
    "ENTRY_BLOCKED_GUT_CONSUMPTION",
    "ENTRY_BLOCKED_HUMAN_QA"
  ]
}
```

- [ ] **Step 4: Create the evaluator**

Create `tools/governance/evaluate_project_entry_gate.py`:

```python
from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Any

REQUIRED_SOURCES = (
    "decision",
    "unresolved",
    "images",
    "github",
    "authority",
    "gut",
    "human_qa",
)
SCOPE_TO_ALLOWED_STATE = {
    "DOCS_ONLY": "ENTRY_ALLOWED_FOR_DOCS_ONLY",
    "TEST_IMPLEMENTATION": "ENTRY_ALLOWED_FOR_TEST_IMPLEMENTATION",
    "PRODUCT_IMPLEMENTATION": "ENTRY_ALLOWED_FOR_PRODUCT_IMPLEMENTATION",
    "IMAGE_GENERATION": "ENTRY_ALLOWED_FOR_IMAGE_GENERATION",
    "IMAGE_IMPLEMENTATION": "ENTRY_ALLOWED_FOR_IMAGE_IMPLEMENTATION",
}
PRODUCT_IMAGE_APPROVED = "PRODUCT_ASSET_APPROVED"


def evaluate(evidence: dict[str, Any]) -> dict[str, Any]:
    missing = [name for name in REQUIRED_SOURCES if name not in evidence]
    if missing:
        return {
            "state": "ENTRY_BLOCKED_MISSING_SOURCE",
            "blockers": [f"missing:{name}" for name in missing],
        }

    unresolved = evidence["unresolved"]
    if int(unresolved.get("open_p0", 0)) > 0 or int(unresolved.get("open_p1", 0)) > 0:
        return {
            "state": "ENTRY_BLOCKED_OPEN_P0_P1",
            "blockers": ["open_p0_or_p1"],
        }
    if evidence["decision"].get("state") != "APPROVED" or int(
        unresolved.get("open_decisions", 0)
    ) > 0:
        return {
            "state": "ENTRY_BLOCKED_OPEN_DECISION",
            "blockers": ["decision_not_approved_or_open_decision"],
        }

    images = evidence["images"]
    if bool(images.get("required")) and images.get("review_state") != PRODUCT_IMAGE_APPROVED:
        return {
            "state": "ENTRY_BLOCKED_IMAGE_EVIDENCE",
            "blockers": ["product_image_not_approved"],
        }

    github = evidence["github"]
    if (
        github.get("head") != github.get("evidence_head")
        or github.get("checks") != "PASS"
        or int(github.get("review_threads_open", 0)) > 0
    ):
        return {
            "state": "ENTRY_BLOCKED_EXACT_HEAD_EVIDENCE",
            "blockers": ["head_checks_or_review_threads"],
        }

    if evidence["authority"].get("state") != "PASS":
        return {
            "state": "ENTRY_BLOCKED_AUTHORITY_CONFLICT",
            "blockers": ["authority_contract_failed"],
        }

    gut = evidence["gut"]
    if bool(gut.get("required")) and gut.get("state") not in {
        "TRIAL_APPROVED",
        "CONSUMPTION_IMPLEMENTED",
        "EXACT_HEAD_VALIDATED",
        "ADOPTED_ACTIVE",
    }:
        return {
            "state": "ENTRY_BLOCKED_GUT_CONSUMPTION",
            "blockers": ["gut_not_available_for_scope"],
        }

    human = evidence["human_qa"]
    if bool(human.get("required")) and human.get("state") != "PASS":
        return {
            "state": "ENTRY_BLOCKED_HUMAN_QA",
            "blockers": ["human_qa_required"],
        }

    scope = str(evidence.get("requested_scope", ""))
    if scope not in SCOPE_TO_ALLOWED_STATE:
        return {
            "state": "ENTRY_BLOCKED_MISSING_SOURCE",
            "blockers": ["unknown_requested_scope"],
        }
    return {"state": SCOPE_TO_ALLOWED_STATE[scope], "blockers": []}


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        print("usage: evaluate_project_entry_gate.py <evidence.json>")
        return 2
    path = Path(argv[1])
    if not path.is_file():
        print(json.dumps({"state": "ENTRY_BLOCKED_MISSING_SOURCE", "blockers": ["evidence_file"]}))
        return 2
    try:
        evidence = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        print(json.dumps({"state": "ENTRY_BLOCKED_MISSING_SOURCE", "blockers": [str(exc)]}))
        return 2
    result = evaluate(evidence)
    print(json.dumps(result, ensure_ascii=False, sort_keys=True))
    return 0 if result["state"].startswith("ENTRY_ALLOWED_FOR_") else 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
```

- [ ] **Step 5: Run GREEN**

```bash
python -m unittest tests.test_project_entry_gate_contract -v
```

Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add \
  tests/test_project_entry_gate_contract.py \
  docs/operations/PROJECT_ENTRY_GATE.json \
  tools/governance/evaluate_project_entry_gate.py
git commit -m "feat: add mandatory project entry gate"
```

---

### Task 3: Add the first project-owned GUT test

**Files:**
- Create: `tests/gut/test_validation_route_mapper.gd`
- Create: `.gutconfig.json`
- Test: `scripts/core/validation_route_mapper.gd`

**Interfaces:**
- Consumes: `ValidationRouteMapper.resolve(flow_stage: String, lifecycle: String) -> Dictionary`.
- Produces: five deterministic tests with no product mutation.

- [ ] **Step 1: Create the GUT test**

Create `tests/gut/test_validation_route_mapper.gd`:

```gdscript
extends GutTest

var mapper: ValidationRouteMapper


func before_each() -> void:
    mapper = ValidationRouteMapper.new()


func test_sit_001_active_routes_to_dialogue() -> void:
    var result := mapper.resolve("SIT-001", "active")
    assert_true(result["ok"])
    assert_eq(result["code"], "OK")
    assert_eq(result["route_id"], "dialogue")
    assert_eq(result["scene_path"], "res://scenes/dialogue_scene.tscn")


func test_sit_004_suspended_routes_to_investigation() -> void:
    var result := mapper.resolve("SIT-004", "suspended")
    assert_true(result["ok"])
    assert_eq(result["code"], "OK")
    assert_eq(result["route_id"], "investigation")
    assert_eq(result["scene_path"], "res://scenes/investigation_scene.tscn")


func test_known_unavailable_stage_is_explicit() -> void:
    var result := mapper.resolve("SIT-003", "active")
    assert_false(result["ok"])
    assert_eq(result["code"], "NOT_AVAILABLE")
    assert_eq(result["route_id"], "SIT-003")
    assert_eq(result["scene_path"], "")


func test_unknown_stage_is_not_treated_as_unavailable() -> void:
    var result := mapper.resolve("SIT-999", "active")
    assert_false(result["ok"])
    assert_eq(result["code"], "UNKNOWN_FLOW_STAGE")
    assert_eq(result["route_id"], "")


func test_invalid_lifecycle_is_rejected_before_routing() -> void:
    var result := mapper.resolve("SIT-001", "completed")
    assert_false(result["ok"])
    assert_eq(result["code"], "INVALID_LIFECYCLE")
```

- [ ] **Step 2: Create canonical GUT config**

Create `.gutconfig.json`:

```json
{
  "dirs": ["res://tests/gut"],
  "include_subdirs": true,
  "prefix": "test_",
  "suffix": ".gd",
  "should_exit": true,
  "log_level": 2,
  "junit_xml_file": ".artifacts/gut/junit.xml"
}
```

- [ ] **Step 3: Run import first**

```bash
godot --headless --editor --quit --path .
```

Expected: exit code `0`; no parse/import error.

- [ ] **Step 4: Run focused GUT**

```bash
godot --headless -d -s --path "$PWD" addons/gut/gut_cmdln.gd \
  -gtest=res://tests/gut/test_validation_route_mapper.gd \
  -gexit \
  -gjunit_xml_file=.artifacts/gut/junit.xml
```

Expected: 5 tests pass, exit code `0`, JUnit file exists.

- [ ] **Step 5: Verify no product mutation**

```bash
git diff --exit-code -- project.godot addons scripts scenes assets data
git status --short
```

Expected: only intended new test/config files are listed before commit; no runtime or protected existing file changed by test execution.

- [ ] **Step 6: Commit**

```bash
git add tests/gut/test_validation_route_mapper.gd .gutconfig.json
git commit -m "test: add GUT validation route contract"
```

---

### Task 4: Verify installed GUT tree against upstream

**Files:**
- Modify after verification: `docs/operations/GODOT_TOOL_AUTHORITY_LEDGER.json`
- Create evidence: `.artifacts/gut/upstream-tree-compare.txt` but do not commit generated artifact unless project policy requires it.

**Interfaces:**
- Consumes: upstream commit `aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605`.
- Produces: `MATCH` or blocking `MISMATCH` with exact file list.

- [ ] **Step 1: Fetch upstream without modifying project history**

```bash
git clone --filter=blob:none --no-checkout https://github.com/bitwes/Gut.git .tmp/gut-upstream
git -C .tmp/gut-upstream checkout aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605 -- addons/gut
```

- [ ] **Step 2: Compare normalized trees**

```bash
git diff --no-index --exit-code \
  .tmp/gut-upstream/addons/gut \
  addons/gut \
  > .artifacts/gut/upstream-tree-compare.txt
```

Expected: exit code `0` for exact match.

- [ ] **Step 3: Handle mismatch safely**

When exit code is nonzero:

- do not overwrite project files automatically;
- list exact added, removed, and modified files;
- compare whether differences are only Godot-generated `.uid` or `.import` metadata;
- open a P0/P1 finding according to affected executable or license content;
- keep adoption state `TRIAL_APPROVED`.

- [ ] **Step 4: Record match**

Only on exact match, update:

```json
"installed_tree_match": "MATCH_UPSTREAM_AEB5D4F3"
```

- [ ] **Step 5: Commit ledger update**

```bash
git add docs/operations/GODOT_TOOL_AUTHORITY_LEDGER.json
git commit -m "docs: record verified GUT upstream identity"
```

---

### Task 5: Add the GUT authority CI workflow

**Files:**
- Create: `.github/workflows/validate-gut-test-authority.yml`

**Interfaces:**
- Consumes: Godot 4.7.1 executable, Python tests, GUT config.
- Produces: import, focused GUT, JUnit, contracts, full regression, protected-diff evidence.

- [ ] **Step 1: Create the workflow**

Create `.github/workflows/validate-gut-test-authority.yml`:

```yaml
name: Validate GUT Test Authority

on:
  pull_request:
    paths:
      - "addons/gut/**"
      - "tests/gut/**"
      - ".gutconfig.json"
      - "scripts/core/validation_route_mapper.gd"
      - "docs/operations/GODOT_TOOL_AUTHORITY_LEDGER.json"
      - "docs/operations/PROJECT_ENTRY_GATE.json"
      - "tools/governance/evaluate_project_entry_gate.py"
      - "tests/test_godot_tool_authority_contract.py"
      - "tests/test_project_entry_gate_contract.py"
      - ".github/workflows/validate-gut-test-authority.yml"
  workflow_dispatch:

permissions:
  contents: read

jobs:
  gut-test-authority:
    runs-on: ubuntu-latest
    timeout-minutes: 30
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - uses: chickensoft-games/setup-godot@v2
        with:
          version: 4.7.1
          use-dotnet: false
          include-templates: false

      - name: Verify versions
        run: |
          python --version
          godot --version
          test "$(godot --version | cut -d. -f1-2)" = "4.7"

      - name: Run Python governance contracts
        run: |
          python -m unittest \
            tests.test_godot_tool_authority_contract \
            tests.test_project_entry_gate_contract \
            -v

      - name: Capture protected baseline
        run: |
          mkdir -p .artifacts/gut
          git status --short > .artifacts/gut/status-before.txt
          git diff -- project.godot addons scripts scenes assets data > .artifacts/gut/diff-before.patch

      - name: Import Godot project
        run: godot --headless --editor --quit --path .

      - name: Run GUT
        run: |
          godot --headless -d -s --path "$PWD" addons/gut/gut_cmdln.gd \
            -gdir=res://tests/gut \
            -ginclude_subdirs \
            -gexit \
            -gjunit_xml_file=.artifacts/gut/junit.xml
          test -s .artifacts/gut/junit.xml

      - name: Run existing Python tests
        run: python -m unittest discover -s tests -p "test_*.py" -v

      - name: Enforce GUT non-authoring boundary
        run: |
          git diff --exit-code -- project.godot addons scripts scenes assets data
          git status --short > .artifacts/gut/status-after.txt
          diff -u .artifacts/gut/status-before.txt .artifacts/gut/status-after.txt

      - name: Upload GUT evidence
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: gut-test-authority-${{ github.sha }}
          path: .artifacts/gut/
          if-no-files-found: error
```

- [ ] **Step 2: Verify action version availability**

Before committing, confirm `chickensoft-games/setup-godot@v2` supports Godot `4.7.1`. When it does not, use the repository's existing Godot installation pattern instead of inventing a download path.

- [ ] **Step 3: Validate YAML locally**

```bash
python - <<'PY'
from pathlib import Path
import yaml
path = Path('.github/workflows/validate-gut-test-authority.yml')
yaml.safe_load(path.read_text(encoding='utf-8'))
print('workflow yaml parsed')
PY
```

Expected: `workflow yaml parsed`.

- [ ] **Step 4: Commit**

```bash
git add .github/workflows/validate-gut-test-authority.yml
git commit -m "ci: enforce GUT test-only authority"
```

---

### Task 6: Adopt project ledgers in the Base adapter

**Files:**
- Modify: `skills/PROJECT_BASE_ADAPTER.json`
- Modify: `docs/BASE_RULES_VERSION.md`
- Create: `tests/test_base_gut_entry_gate_adoption.py`

**Interfaces:**
- Consumes: existing Base 9.4.3 release identity and Base main policy commit.
- Produces: project-owned pointers without inventing a new Base release.

- [ ] **Step 1: Write RED test**

Create `tests/test_base_gut_entry_gate_adoption.py`:

```python
from __future__ import annotations

import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ADAPTER = ROOT / "skills/PROJECT_BASE_ADAPTER.json"


class BaseGutEntryGateAdoptionTests(unittest.TestCase):
    def test_project_ledgers_are_routed(self) -> None:
        data = json.loads(ADAPTER.read_text(encoding="utf-8"))
        addon = data["shared_overrides"]["evaluating-godot-assets-and-plugins-before-creation"]
        intake = data["shared_overrides"]["managing-project-intake-and-work-contract"]
        self.assertEqual(
            "docs/operations/GODOT_TOOL_AUTHORITY_LEDGER.json",
            addon["tool_authority_ledger"],
        )
        self.assertEqual("HIGODOT_SOLE_AUTHORING_GUT_TEST_ONLY", addon["authority_policy"])
        self.assertEqual(
            "docs/operations/PROJECT_ENTRY_GATE.json",
            intake["project_entry_gate"],
        )
        self.assertEqual("BLOCK_ON_MISSING_SOURCE", intake["entry_gate_missing_source_policy"])

    def test_release_identity_remains_943_until_new_release_is_verified(self) -> None:
        data = json.loads(ADAPTER.read_text(encoding="utf-8"))
        self.assertEqual("9.4.3", data["base_release"]["version"])


if __name__ == "__main__":
    unittest.main()
```

- [ ] **Step 2: Run RED**

```bash
python -m unittest tests.test_base_gut_entry_gate_adoption -v
```

- [ ] **Step 3: Add minimal adapter pointers**

Extend the existing override without deleting project-specific search focus:

```json
"evaluating-godot-assets-and-plugins-before-creation": {
  "tool_authority_ledger": "docs/operations/GODOT_TOOL_AUTHORITY_LEDGER.json",
  "authority_policy": "HIGODOT_SOLE_AUTHORING_GUT_TEST_ONLY",
  "addon_adoption_lifecycle": "TRIAL_APPROVED_TO_EXACT_HEAD_VALIDATED",
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

Add to the existing intake override:

```json
"project_entry_gate": "docs/operations/PROJECT_ENTRY_GATE.json",
"entry_gate_missing_source_policy": "BLOCK_ON_MISSING_SOURCE",
"forbidden_current_entry_states": [
  "READY",
  "AWAITING",
  "CANON_READY",
  "IMPLEMENTATION_PLAN_READY",
  "AUTOMATED_PACKAGE_READY"
]
```

- [ ] **Step 4: Reconcile `BASE_RULES_VERSION.md`**

Keep Base release identity `9.4.3`. Record Base main policy commit `4f98f968...` as reviewed upstream policy evidence, not a released payload.

- [ ] **Step 5: Run focused Base tests**

```bash
python -m unittest \
  tests.test_base_v943_first_prompt_adoption \
  tests.test_base_gut_entry_gate_adoption \
  tests.test_godot_tool_authority_contract \
  tests.test_project_entry_gate_contract \
  -v
```

Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add \
  skills/PROJECT_BASE_ADAPTER.json \
  docs/BASE_RULES_VERSION.md \
  tests/test_base_gut_entry_gate_adoption.py
git commit -m "docs: adopt GUT authority and entry gate contracts"
```

---

### Task 7: Correct Google Sheet current-state overclaims

**Files:**
- Google Sheet `02_현재_확정결정`
- Google Sheet `04_누락_충돌_감사`
- Google Sheet `71_이미지기획_생성목록`
- Google Sheet `72_이미지검수_승인로그`
- Google Sheet `00_프로젝트_허브`, `01_작업순서`, `99_변경이력`

**Interfaces:**
- Consumes: exact implementation PR head and actual row contents.
- Produces: explicit scoped states and same-ID change history.

- [ ] **Step 1: Re-read before every write**

Read the exact target rows immediately before updates. Abort on changed values.

- [ ] **Step 2: Preserve historical facts while removing current authority ambiguity**

For old Draft/spec rows, replace current-gate classification fields with:

```text
HISTORICAL_RECORD / NOT_CURRENT_ENTRY_AUTHORITY
```

For approved but non-implemented canon:

```text
CANON_APPROVED / IMPLEMENTATION_NOT_AUTHORIZED
```

For the Human QA package:

```text
AUTOMATED_PACKAGE_AVAILABLE / HUMAN_QA_NOT_RUN / UI_ACCESSIBILITY_NOT_RUN
```

- [ ] **Step 3: Normalize image rows**

Required current states:

```text
UL-IMG-001 -> PLANNED / IMAGE_NOT_GENERATED
UL-IMG-002 -> PLANNED / IMAGE_NOT_GENERATED
UL-IMG-003 -> PLANNED / IMAGE_NOT_GENERATED
UL-IMG-004 -> BLOCKED_BY_DEMO
UL-IMG-STYLE-REF-001 -> REFERENCE_ONLY / NOT_PRODUCT_ASSET
UL-IMG-005 -> PLANNED / BRIEF_NOT_PRODUCT_APPROVED
UL-IMG-006 -> PLANNED / SUPERSEDED_PLACEHOLDER_RULE_ACTIVE
UL-IMG-007 -> PLANNING_WIREFRAME_REVIEWED / OPEN_P2 / NOT_PRODUCT_ASSET
```

Required review states:

```text
UL-REV-INIT -> BLOCKED_NO_IMAGE / REVIEW_NOT_STARTED / RUNTIME_NOT_RUN
UL-REV-STYLE-REF-001 -> REFERENCE_ONLY / PRODUCT_ASSET_APPROVAL_NOT_APPLICABLE
UL-REV-007-PRE -> BRIEF_APPROVED / IMAGE_NOT_GENERATED / PRODUCT_APPROVAL_NOT_STARTED
R-2026-08-01-UL-IMG-007-VISUAL-REVIEW -> PLANNING_WIREFRAME_REVIEWED / OPEN_P2 / PRODUCT_ASSET_NOT_APPROVED / RUNTIME_NOT_RUN
```

- [ ] **Step 4: Record implementation decision and exact head**

Use one change ID across tabs:

```text
UL-SYNC-<DATE>-GUT-ENTRY-GATE-IMPLEMENTATION
```

- [ ] **Step 5: Read back all written ranges**

Do not claim synchronization until exact values are returned.

---

### Task 8: Run UID validation independently

**Files:**
- Create: `docs/validation/GUT_9_7_1_ADOPTION_VALIDATION.md`

**Interfaces:**
- Consumes: implementation candidate exact SHA.
- Produces: separate GUT and UID evidence sections.

- [ ] **Step 1: Record environment**

```bash
git rev-parse HEAD
godot --version
python --version
```

- [ ] **Step 2: Record pre-import status**

```bash
git status --short
git diff --stat
```

- [ ] **Step 3: Run Godot import**

```bash
godot --headless --editor --quit --path .
```

- [ ] **Step 4: Inspect UID/resource diff**

```bash
git status --short
git diff -- '*.uid' '*.tscn' '*.tres' '*.gd' project.godot
```

Unexpected rewrite is a blocker.

- [ ] **Step 5: Run GUT and full regressions**

```bash
godot --headless -d -s --path "$PWD" addons/gut/gut_cmdln.gd \
  -gdir=res://tests/gut \
  -ginclude_subdirs \
  -gexit \
  -gjunit_xml_file=.artifacts/gut/junit.xml
python -m unittest discover -s tests -p "test_*.py" -v
```

Also run the repository's maintained full Godot regression command from its current workflow; do not substitute a shorter smoke test.

- [ ] **Step 6: Write validation document**

Use separate headings:

```text
GUT adoption evidence
Installed tree identity evidence
UID/import evidence
Existing regression evidence
Protected-diff evidence
Human QA evidence
Claim ceiling
```

- [ ] **Step 7: Commit evidence document**

```bash
git add docs/validation/GUT_9_7_1_ADOPTION_VALIDATION.md
git commit -m "docs: record GUT and UID validation evidence"
```

---

### Task 9: Promote lifecycle only after exact-HEAD validation

**Files:**
- Modify: `docs/operations/GODOT_TOOL_AUTHORITY_LEDGER.json`
- Modify: `docs/operations/PROJECT_ENTRY_GATE.json` only when required by validated behavior.
- Modify: `START_HERE.md`
- Modify: `docs/CURRENT_STATUS.md`
- Modify: `docs/CURRENT_HANDOFF_VALIDATION.md`

**Interfaces:**
- Consumes: successful workflow run on the current implementation head.
- Produces: `ADOPTED_ACTIVE` tied to one SHA.

- [ ] **Step 1: Verify exact head did not move**

```bash
git rev-parse HEAD
```

Compare to the GitHub workflow SHA.

- [ ] **Step 2: Verify all required evidence**

Required:

```text
GUT focused PASS
JUnit present
Python contracts PASS
full Godot regression PASS
protected diff empty
installed tree match PASS
UID/import PASS
open P0 = 0
open P1 = 0
review threads open = 0
```

- [ ] **Step 3: Update the ledger**

Set:

```json
"adoption_state": "ADOPTED_ACTIVE",
"latest_exact_head_validation": {
  "state": "PASS",
  "commit": "<exact 40-character validated SHA>"
}
```

The commit value must be the actual validated SHA, not a branch name or shortened SHA.

- [ ] **Step 4: Update entry documents**

Use:

```text
GUT_ADOPTED_ACTIVE_FOR_TEST_EXECUTION
HIGODOT_SOLE_AUTHORING_AUTHORITY
ENTRY_GATE_ACTIVE
HUMAN_QA_NOT_RUN
```

Do not write generic `READY`.

- [ ] **Step 5: Commit**

```bash
git add \
  docs/operations/GODOT_TOOL_AUTHORITY_LEDGER.json \
  START_HERE.md \
  docs/CURRENT_STATUS.md \
  docs/CURRENT_HANDOFF_VALIDATION.md
git commit -m "docs: activate validated GUT test authority"
```

---

### Task 10: Final adversarial verification and PR handoff

**Files:**
- Entire implementation PR diff
- Google Sheet readback

**Interfaces:**
- Consumes: final candidate exact HEAD.
- Produces: merge-review package without merging.

- [ ] **Step 1: Run whitespace and diff validation**

```bash
git diff --check main...HEAD
git status --short
```

- [ ] **Step 2: Run all focused contracts**

```bash
python -m unittest \
  tests.test_godot_tool_authority_contract \
  tests.test_project_entry_gate_contract \
  tests.test_base_gut_entry_gate_adoption \
  -v
```

- [ ] **Step 3: Run GUT fresh**

```bash
godot --headless -d -s --path "$PWD" addons/gut/gut_cmdln.gd \
  -gdir=res://tests/gut \
  -ginclude_subdirs \
  -gexit \
  -gjunit_xml_file=.artifacts/gut/junit-final.xml
```

- [ ] **Step 4: Run maintained full regressions fresh**

Use the repository's current complete workflow commands and record zero failures.

- [ ] **Step 5: Verify no authority violation**

```bash
git diff --exit-code -- project.godot addons scripts scenes assets data
```

Run this against the clean committed head after tests. Generated artifacts must be ignored or isolated.

- [ ] **Step 6: Verify Sheet state**

Search current authority surfaces for standalone forbidden states. Historical rows must be explicitly marked `NOT_CURRENT_ENTRY_AUTHORITY`.

- [ ] **Step 7: Inspect PR checks and review threads**

Required before merge-review handoff:

```text
all required checks PASS
review threads open = 0
mergeable = true
head SHA unchanged
```

- [ ] **Step 8: Report claim ceiling**

Maximum before Human QA:

```text
GUT_ADOPTED_ACTIVE_FOR_TEST_EXECUTION
HIGODOT_SOLE_AUTHORING_AUTHORITY
MANDATORY_ENTRY_GATE_ACTIVE
AUTOMATED_EXACT_HEAD_VALIDATED
UID_IMPORT_VALIDATED
HUMAN_QA_NOT_RUN
UI_ACCESSIBILITY_QA_NOT_RUN
MERGE_NOT_AUTHORIZED
```

- [ ] **Step 9: Do not merge**

Wait for a separate explicit exact-HEAD merge authorization.
