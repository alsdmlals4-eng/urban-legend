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


class FinalPlanningHandoffTests(unittest.TestCase):
    def test_final_user_planning_declaration_is_recorded_without_runtime_overclaim(self) -> None:
        canon = json.loads(CANON_JSON.read_text(encoding="utf-8"))
        gates = canon["gates"]
        self.assertEqual("COMPLETE", gates["overall_plan"])
        self.assertEqual("APPROVED", gates["user_final_planning_declaration"])
        self.assertEqual("RELEASED_TO_IMPLEMENTATION_GATE", gates["plan_lock"])
        self.assertEqual(
            "HANDOFF_READY_WITH_KNOWN_REALIGNMENT",
            gates["implementation_reality_gate"],
        )
        self.assertEqual("READY", gates["implementation_contract"])
        self.assertFalse(gates["runtime_implementation_authorized"])
        self.assertEqual("PENDING", gates["product_reference_asset"])
        self.assertEqual("NOT_RUN", gates["human_qa"])
        self.assertEqual("NOT_DECLARED", gates["poc_passed"])

        current = CURRENT_CANON.read_text(encoding="utf-8")
        overlay = CURRENT_OVERLAY.read_text(encoding="utf-8")
        for text in (current, overlay):
            self.assertIn("PLANNING_COMPLETE", text)
            self.assertIn("USER_FINAL_PLANNING_DECLARATION_APPROVED", text)
            self.assertIn("IMPLEMENTATION_HANDOFF_READY", text)
            self.assertIn("PRODUCT_REFERENCE_ASSET_PENDING", text)
            self.assertIn("runtime_implementation: NOT_AUTHORIZED", text)

    def test_reality_gate_records_successors_and_current_gaps(self) -> None:
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

    def test_new_spec_and_plan_are_the_single_current_handoff(self) -> None:
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
        self.assertIn("tests/test_final_planning_handoff.py", plan)
        self.assertIn("data/episodes/episode_001_afterlife_station_canon_v2.json", plan)
        self.assertIn("scripts/core/afterlife_main_save_migrator.gd", plan)
        self.assertIn("monthly_state", plan)
        self.assertIn("SERIAL_EXAM_FATIGUE_GUARD", plan)
        self.assertIn("main menu", plan.lower())
        self.assertIn("PRODUCT_REFERENCE_ASSET_PENDING", plan)

        self.assertIn(str(SPEC.relative_to(ROOT)).replace("\\", "/"), handoff)
        self.assertIn(str(PLAN.relative_to(ROOT)).replace("\\", "/"), handoff)
        self.assertIn("IMPLEMENTATION_HANDOFF_READY", handoff)


if __name__ == "__main__":
    unittest.main()
