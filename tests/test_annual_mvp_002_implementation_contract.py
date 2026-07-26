from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data/poc/annual_mvp_002/companion_equipment_research.json"
PLAN = ROOT / "docs/superpowers/plans/2026-07-26-annual-mvp-002-vertical-slice-implementation-plan.md"
QA = ROOT / "docs/qa/ANNUAL_MVP_002_AUTOMATED_QA_2026-07-26.md"
STATUS = ROOT / "docs/CURRENT_STATUS.md"
HANDOFF = ROOT / "docs/CURRENT_HANDOFF.md"
ROADMAP = ROOT / "MVP_ROADMAP.md"
CHECKLIST = ROOT / "TEST_CHECKLIST.md"
DECISIONS = ROOT / "docs/DECISION_LOG.md"


class AnnualMvp002ImplementationContractTests(unittest.TestCase):
    def read(self, path: Path) -> str:
        self.assertTrue(path.is_file(), path.relative_to(ROOT))
        return path.read_text(encoding="utf-8")

    def test_isolated_runtime_files_exist(self) -> None:
        for relative in (
            "scripts/poc/annual_mvp_002/annual_mvp_002_data.gd",
            "scripts/poc/annual_mvp_002/annual_mvp_002_planner.gd",
            "scripts/poc/annual_mvp_002/annual_mvp_002_state.gd",
            "scripts/poc/annual_mvp_002/annual_mvp_002_support_resolver.gd",
            "scripts/poc/annual_mvp_002/annual_mvp_002_incident_adapter.gd",
            "scripts/poc/annual_mvp_002/annual_mvp_002_scene.gd",
            "scenes/poc/annual_mvp_002/annual_mvp_002_scene.tscn",
            "tests/annual_mvp_002_planner_test.gd",
            "tests/annual_mvp_002_state_test.gd",
            "tests/annual_mvp_002_support_resolver_test.gd",
            "tests/annual_mvp_002_incident_adapter_test.gd",
            "tests/annual_mvp_002_scene_test.gd",
            "tests/annual_mvp_002_pointer_qa.gd",
            "tests/annual_mvp_002_visual_capture.gd",
            "tests/run_annual_mvp_002_tests.sh",
        ):
            self.assertTrue((ROOT / relative).is_file(), relative)

    def test_vertical_slice_counts_and_save_boundary(self) -> None:
        data = json.loads(self.read(DATA))
        self.assertEqual("annual-mvp-002-v1", data["contract_version"])
        self.assertEqual("annual-mvp-001-v3", data["base_contract_version"])
        self.assertEqual(3, len(data["companions"]))
        self.assertEqual(3, len(data["unique_skills"]))
        self.assertEqual(6, len(data["support_skills"]))
        self.assertEqual(3, len(data["equipment"]))
        self.assertEqual(6, len(data["modules"]))
        self.assertEqual(4, len(data["research_resources"]))
        self.assertEqual(8, len(data["research_nodes"]))
        combined = self.read(PLAN) + self.read(STATUS) + self.read(HANDOFF)
        for token in (
            "annual-mvp-001-save-v1",
            "state.annual_mvp_002",
            "orphaned_ids",
            "기존 ANNUAL-MVP-001",
            "fallback",
        ):
            self.assertIn(token, combined)

    def test_benchmark_p0_subset_is_recorded(self) -> None:
        combined = "\n".join(
            self.read(path)
            for path in (PLAN, STATUS, HANDOFF, ROADMAP, CHECKLIST)
        )
        for token in (
            "일정 결과 미리보기",
            "지난주 복사",
            "템플릿 3개",
            "전체 초기화",
            "undo",
            "적격",
            "확률",
            "준비도",
            "보장",
            "무엇이 변했는가",
            "왜 변했는가",
            "다음 주 영향",
        ):
            self.assertIn(token, combined)

    def test_excluded_followups_and_product_gates_remain_explicit(self) -> None:
        combined = "\n".join(
            self.read(path)
            for path in (PLAN, STATUS, HANDOFF, ROADMAP, CHECKLIST, DECISIONS)
        )
        for token in (
            "사건 징후 시계",
            "관측·가설·반박 보드",
            "ANNUAL-MVP-003",
            "NOT_RUN",
            "NOT_DECLARED",
            "NOT_APPROVED",
        ):
            self.assertIn(token, combined)

    def test_automated_evidence_is_exact_and_not_human_evidence(self) -> None:
        qa = self.read(QA)
        for token in (
            "run: #333",
            "run: #167",
            "run: #55",
            "8625300008",
            "1280×720",
            "1920×1080",
            "human_usability_qa: NOT_RUN",
            "new_player_validation: NOT_RUN",
            "POC_PASSED: NOT_DECLARED",
            "production_expansion: NOT_APPROVED",
        ):
            self.assertIn(token, qa)

    def test_decision_log_supersedes_not_started_without_deleting_history(self) -> None:
        decisions = self.read(DECISIONS)
        self.assertIn("D-2026-07-26-ANNUAL-EXPANSION-SEQUENCE", decisions)
        self.assertIn("ANNUAL-MVP-002 구현: `NOT_STARTED`", decisions)
        self.assertIn("D-2026-07-26-ANNUAL-MVP-002-VERTICAL-SLICE", decisions)
        self.assertIn("ON_BRANCH / AUTOMATED_QA_PASSED", decisions)
        self.assertIn("이전 기록은 당시 사실로 보존", decisions)

    def test_no_placeholders_in_active_records(self) -> None:
        for path in (PLAN, QA, STATUS, HANDOFF, ROADMAP, CHECKLIST):
            text = self.read(path)
            self.assertNotIn("TBD", text, path.relative_to(ROOT))
            self.assertNotIn("TODO", text, path.relative_to(ROOT))


if __name__ == "__main__":
    unittest.main()
