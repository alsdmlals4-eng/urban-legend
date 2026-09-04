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
            "review_state": "NOT_APPLICABLE",
        },
        "github": {
            "head": "a" * 40,
            "evidence_head": "a" * 40,
            "checks": "PASS",
            "review_threads_open": 0,
        },
        "authority": {"state": "PASS"},
        "gut": {"required": True, "state": "TRIAL_APPROVED"},
        "human_qa": {"required": False, "state": "NOT_APPLICABLE"},
    }


class ProjectEntryGateContractTests(unittest.TestCase):
    def test_contract_forbids_generic_current_states(self) -> None:
        payload = json.loads(CONTRACT.read_text(encoding="utf-8"))
        self.assertTrue(
            FORBIDDEN_CURRENT_STATES.issubset(set(payload["forbidden_current_states"]))
        )

    def test_contract_declares_scope_specific_gut_thresholds(self) -> None:
        payload = json.loads(CONTRACT.read_text(encoding="utf-8"))
        thresholds = payload["gut_usable_states_by_scope"]
        self.assertIn("TRIAL_APPROVED", thresholds["TEST_IMPLEMENTATION"])
        self.assertNotIn("TRIAL_APPROVED", thresholds["PRODUCT_IMPLEMENTATION"])
        self.assertEqual(
            ["EXACT_HEAD_VALIDATED", "ADOPTED_ACTIVE"],
            thresholds["PRODUCT_IMPLEMENTATION"],
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

    def test_malformed_nested_source_blocks_without_exception(self) -> None:
        module = load_module()
        evidence = valid_evidence()
        evidence["github"] = []
        result = module.evaluate(evidence)
        self.assertEqual("ENTRY_BLOCKED_MISSING_SOURCE", result["state"])
        self.assertIn("invalid:github", result["blockers"])

    def test_negative_counts_are_invalid_evidence(self) -> None:
        module = load_module()
        evidence = valid_evidence()
        evidence["unresolved"]["open_p0"] = -1
        result = module.evaluate(evidence)
        self.assertEqual("ENTRY_BLOCKED_MISSING_SOURCE", result["state"])
        self.assertIn("invalid:unresolved.open_p0", result["blockers"])

    def test_non_integer_counts_are_invalid_evidence(self) -> None:
        module = load_module()
        evidence = valid_evidence()
        evidence["github"]["review_threads_open"] = "none"
        result = module.evaluate(evidence)
        self.assertEqual("ENTRY_BLOCKED_MISSING_SOURCE", result["state"])
        self.assertIn("invalid:github.review_threads_open", result["blockers"])

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
            "review_state": "PRODUCT_ASSET_NOT_APPROVED",
        }
        result = module.evaluate(evidence)
        self.assertEqual("ENTRY_BLOCKED_IMAGE_EVIDENCE", result["state"])

    def test_head_mismatch_blocks(self) -> None:
        module = load_module()
        evidence = valid_evidence()
        evidence["github"]["evidence_head"] = "b" * 40
        result = module.evaluate(evidence)
        self.assertEqual("ENTRY_BLOCKED_EXACT_HEAD_EVIDENCE", result["state"])

    def test_non_hex_head_blocks(self) -> None:
        module = load_module()
        evidence = valid_evidence()
        evidence["github"]["head"] = "z" * 40
        evidence["github"]["evidence_head"] = "z" * 40
        result = module.evaluate(evidence)
        self.assertEqual("ENTRY_BLOCKED_EXACT_HEAD_EVIDENCE", result["state"])

    def test_generic_decision_state_blocks(self) -> None:
        module = load_module()
        evidence = valid_evidence()
        evidence["decision"]["state"] = "READY"
        result = module.evaluate(evidence)
        self.assertEqual("ENTRY_BLOCKED_OPEN_DECISION", result["state"])

    def test_product_scope_rejects_trial_only_gut(self) -> None:
        module = load_module()
        evidence = valid_evidence()
        evidence["requested_scope"] = "PRODUCT_IMPLEMENTATION"
        result = module.evaluate(evidence)
        self.assertEqual("ENTRY_BLOCKED_GUT_CONSUMPTION", result["state"])

    def test_product_scope_accepts_exact_head_validated_gut(self) -> None:
        module = load_module()
        evidence = valid_evidence()
        evidence["requested_scope"] = "PRODUCT_IMPLEMENTATION"
        evidence["gut"]["state"] = "EXACT_HEAD_VALIDATED"
        result = module.evaluate(evidence)
        self.assertEqual("ENTRY_ALLOWED_FOR_PRODUCT_IMPLEMENTATION", result["state"])

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
