from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CANON_JSON = ROOT / "docs/current-planning-canon.json"
CURRENT_CANON = ROOT / "docs/CURRENT_PLANNING_CANON.md"
CURRENT_OVERLAY = ROOT / "docs/CURRENT_DECISION_OVERLAY.md"
CURRENT_HANDOFF = ROOT / "docs/CURRENT_HANDOFF.md"
REALITY_GATE = ROOT / "docs/audits/2026-08-22-final-planning-implementation-reality-gate.md"
SPEC = ROOT / "docs/superpowers/specs/2026-08-22-post-planning-runtime-reconciliation-design.md"
PLAN = ROOT / "docs/superpowers/plans/2026-08-22-post-planning-runtime-reconciliation-implementation-plan.md"
RUNTIME_MERGE = "8d303f0f9414950273be934fd28c8fb1b3a21e18"


class FinalPlanningHandoffTests(unittest.TestCase):
    def test_final_user_planning_declaration_survives_runtime_successor_without_human_overclaim(self) -> None:
        canon = json.loads(CANON_JSON.read_text(encoding="utf-8"))
        gates = canon["gates"]
        self.assertEqual("COMPLETE", gates["overall_plan"])
        self.assertEqual("APPROVED", gates["user_final_planning_declaration"])
        self.assertEqual("RELEASED_TO_IMPLEMENTATION_GATE", gates["plan_lock"])
        self.assertEqual("RUNTIME_RECONCILIATION_MERGED", gates["implementation_reality_gate"])
        self.assertEqual("EXECUTED", gates["implementation_contract"])
        self.assertTrue(gates["runtime_implementation_authorized"])
        self.assertEqual("MERGED_MAIN", gates["runtime_implementation"])
        self.assertEqual(RUNTIME_MERGE, gates["runtime_merge_commit"])
        self.assertEqual("PENDING", gates["product_reference_asset"])
        self.assertEqual("NOT_RUN", gates["human_qa"])
        self.assertEqual("NOT_DECLARED", gates["poc_passed"])

        current = CURRENT_CANON.read_text(encoding="utf-8")
        overlay = CURRENT_OVERLAY.read_text(encoding="utf-8")
        for text in (current, overlay):
            self.assertIn("PLANNING_COMPLETE", text)
            self.assertIn("USER_FINAL_PLANNING_DECLARATION_APPROVED", text)
            self.assertIn("PRODUCT_REFERENCE_ASSET_PENDING", text)
            self.assertIn("NOT_RUN", text)
        self.assertIn("runtime_implementation: MERGED_MAIN", current)
        self.assertIn("runtime_implementation: MERGED_MAIN", overlay)

    def test_reality_gate_remains_historical_predecessor_evidence(self) -> None:
        self.assertTrue(REALITY_GATE.is_file())
        text = REALITY_GATE.read_text(encoding="utf-8")
        for required in (
            "main@7f9e714e5aac65a826b4fd66d5219df8ed2dfb3e",
            "EXISTING_CANON_V2_RUNTIME_REUSE",
            "COMPOSITE_RESULT_RUNTIME_SUCCESSOR_PRESENT",
            "LEGACY_S_RANK_CONTRACT_REALIGNMENT_REQUIRED",
            "MONTHLY_STATE_NOT_IMPLEMENTED",
            "PRODUCT_REFERENCE_ASSET_PENDING",
            "#181",
            "CURRENT_VALID / IMPLEMENTATION_GATE",
            "runtime_implementation: NOT_AUTHORIZED",
        ):
            self.assertIn(required, text)

    def test_spec_and_plan_are_implementation_provenance_not_current_unexecuted_handoff(self) -> None:
        self.assertTrue(SPEC.is_file())
        self.assertTrue(PLAN.is_file())
        spec = SPEC.read_text(encoding="utf-8")
        plan = PLAN.read_text(encoding="utf-8")
        handoff = CURRENT_HANDOFF.read_text(encoding="utf-8")

        self.assertIn("REUSE_EXISTING_CANON_V2_RUNTIME", spec)
        self.assertIn("COMPOSITE_RESULT", spec)
        self.assertIn("monthly_state", spec)
        self.assertIn("PRODUCT_REFERENCE_ASSET_PENDING", spec)
        self.assertIn("M01_FIRST_SESSION", spec)
        self.assertIn("M04_RELEASE_NEAR_VERTICAL_SLICE", spec)

        self.assertIn("# Post-Planning Runtime Reconciliation Implementation Plan", plan)
        self.assertIn("monthly_state", plan)
        self.assertIn("SERIAL_EXAM_FATIGUE_GUARD", plan)
        self.assertIn("PRODUCT_REFERENCE_ASSET_PENDING", plan)

        self.assertIn(str(SPEC.relative_to(ROOT)).replace("\\", "/"), handoff)
        self.assertIn(str(PLAN.relative_to(ROOT)).replace("\\", "/"), handoff)
        self.assertIn("RUNTIME_RECONCILIATION_MERGED", handoff)
        self.assertIn("설계·계획 provenance", handoff)
        self.assertIn(RUNTIME_MERGE, handoff)
        self.assertNotIn("현재 **runtime implementation authorization**", handoff)


if __name__ == "__main__":
    unittest.main()
