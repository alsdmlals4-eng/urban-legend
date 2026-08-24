from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def text(path: str) -> str:
    return (ROOT / path).read_text(encoding="utf-8")


class VisualPlanningClosureTests(unittest.TestCase):
    def test_current_planning_preserves_asset_gate_after_runtime_merge(self) -> None:
        canon = text("docs/CURRENT_PLANNING_CANON.md")
        machine = json.loads(text("docs/current-planning-canon.json"))

        self.assertIn("PLANNING_COMPLETE", canon)
        self.assertIn("USER_FINAL_PLANNING_DECLARATION_APPROVED", canon)
        self.assertIn("PRODUCT_REFERENCE_ASSET_PENDING", canon)
        self.assertEqual(machine["gates"]["visual_planning"], "COMPLETE")
        self.assertEqual(machine["gates"]["product_reference_asset"], "PENDING")
        self.assertEqual(machine["gates"]["overall_plan"], "COMPLETE")
        self.assertEqual(machine["gates"]["user_final_planning_declaration"], "APPROVED")
        self.assertTrue(machine["gates"]["runtime_implementation_authorized"])
        self.assertEqual(machine["gates"]["runtime_implementation"], "MERGED_MAIN")
        self.assertEqual(machine["gates"]["human_qa"], "NOT_RUN")
        self.assertEqual(machine["evidence_ceiling"]["product_reference_asset"], "PENDING")

    def test_visual_contract_locks_medium_without_promoting_assets(self) -> None:
        visual = text("docs/VISUAL_ANCHOR_SPEC.md")
        work_order = text("docs/CURRENT_VISUAL_WORK_ORDER.md")

        for source in (visual, work_order):
            self.assertIn("SOFT_ANIME_NOIR_LOCKED", source)
            self.assertIn("DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM", source)
            self.assertIn("PRODUCT_REFERENCE_ASSET_PENDING", source)
        # These planning artifacts preserve their historical implementation boundary;
        # current runtime authority is owned by CURRENT_PLANNING_CANON / Overlay / main.
        self.assertIn("IMPLEMENTATION_NOT_AUTHORIZED", visual)
        self.assertIn("IMPLEMENTATION_NOT_AUTHORIZED", work_order)

    def test_m01_has_complete_recovery_packet_and_no_current_single_grade_authority(self) -> None:
        recovery = text("docs/M01_RECOVERY_SCENE_PACKET.md")
        afterlife = text("docs/CURRENT_AFTERLIFE_STATION_CANON.md")

        for token in ("목적지 합창", "회귀 승강장", "무정차 환송", "COMPOSITE_RESULT"):
            self.assertIn(token, recovery)
        self.assertIn("LEGACY_SINGLE_GRADE_SUPERSEDED", afterlife)
        self.assertIn("COMPOSITE_RESULT", afterlife)

    def test_historical_closure_contract_preserves_evidence_ceilings(self) -> None:
        closure = text("docs/planning/2026-08-21-visual-ui-planning-closure.md")
        for token in (
            "VISUAL_PLANNING_CLOSURE_READY",
            "PRODUCT_REFERENCE_ASSET_PENDING",
            "HUMAN_QA_NOT_RUN",
            "RUNTIME_IMPLEMENTATION_NOT_AUTHORIZED",
            "SERIAL_EXAM_FATIGUE_GUARD",
            "M01_FIRST_SESSION",
            "M04_RELEASE_NEAR_VERTICAL_SLICE",
        ):
            self.assertIn(token, closure)


if __name__ == "__main__":
    unittest.main()
