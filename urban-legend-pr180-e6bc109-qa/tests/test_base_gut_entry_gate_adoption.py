from __future__ import annotations

import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ADAPTER = ROOT / "skills/PROJECT_BASE_ADAPTER.json"
AUTHORITY_LEDGER = ROOT / "docs/operations/GODOT_TOOL_AUTHORITY_LEDGER.json"
ENTRY_GATE = ROOT / "docs/operations/PROJECT_ENTRY_GATE.json"


def load(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


class BaseGutEntryGateAdoptionTests(unittest.TestCase):
    def test_existing_base_routes_remain_the_integration_boundary(self) -> None:
        data = load(ADAPTER)
        active = {
            route["route_id"]
            for route in data["routing"]["base_routes"]
            if route.get("status") == "ACTIVE"
        }
        self.assertIn("evaluating-godot-assets-and-plugins-before-creation", active)
        self.assertIn("managing-project-intake-and-work-contract", active)

    def test_project_ledgers_record_base_policy_evidence(self) -> None:
        authority = load(AUTHORITY_LEDGER)
        self.assertEqual(
            "4f98f968a377f7b6a11aafa4fc94d11bddbebedc",
            authority["base_policy_evidence"]["commit"],
        )
        self.assertEqual(
            "REVIEWED_POLICY_EVIDENCE_NOT_RELEASE_IDENTITY",
            authority["base_policy_evidence"]["state"],
        )
        self.assertEqual(
            ["UL-DEC-ADDON-001", "UL-DEC-AUTHORITY-001"],
            authority["decision_ids"],
        )
        self.assertEqual("UL-DEC-ENTRY-GATE-001", load(ENTRY_GATE)["decision_id"])

    def test_entry_gate_is_fail_closed_and_forbids_generic_states(self) -> None:
        gate = load(ENTRY_GATE)
        self.assertEqual("FAIL_CLOSED", gate["evaluation_policy"])
        self.assertEqual(
            {
                "READY",
                "AWAITING",
                "CANON_READY",
                "IMPLEMENTATION_PLAN_READY",
                "AUTOMATED_PACKAGE_READY",
            },
            set(gate["forbidden_current_states"]),
        )

    def test_release_identity_remains_943_until_new_release_is_verified(self) -> None:
        self.assertEqual("9.4.3", load(ADAPTER)["base_release"]["version"])


if __name__ == "__main__":
    unittest.main()
