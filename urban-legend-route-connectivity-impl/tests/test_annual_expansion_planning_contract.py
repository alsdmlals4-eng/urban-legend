from __future__ import annotations

import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MASTER = ROOT / "docs/superpowers/specs/2026-07-26-annual-expansion-master-design.md"
DATA = ROOT / "docs/planning/ANNUAL_PROVISIONAL_DATA_BASELINE.md"
MVP002 = ROOT / "docs/superpowers/specs/2026-07-26-annual-mvp-002-companion-equipment-research-design.md"
DECISIONS = ROOT / "docs/DECISION_LOG.md"
ROADMAP = ROOT / "MVP_ROADMAP.md"


class AnnualExpansionPlanningContractTests(unittest.TestCase):
    def test_planning_authorities_exist_without_placeholders(self) -> None:
        for path in (MASTER, DATA, MVP002, DECISIONS, ROADMAP):
            self.assertTrue(path.is_file(), path.relative_to(ROOT))
            text = path.read_text(encoding="utf-8")
            self.assertNotIn("TODO", text, path.relative_to(ROOT))
            self.assertNotIn("TBD", text, path.relative_to(ROOT))

    def test_approved_sequence_is_complete_and_ordered(self) -> None:
        master = MASTER.read_text(encoding="utf-8")
        ordered_terms = (
            "ANNUAL-MVP-002 동료·장비·연구 조합",
            "일정·상태·회복 확장",
            "ANNUAL-MVP-003 1분기 운영",
            "사건 콘텐츠 제작 규격",
            "관계·동료·선택적 로맨스 연간 구조",
            "조작형 규칙 검증 미니게임 규격",
            "ANNUAL-MVP-004 1년 캠페인·결산·계승",
        )
        positions = [master.index(term) for term in ordered_terms]
        self.assertEqual(positions, sorted(positions))
        self.assertIn("APPROVED_SEQUENCE", master)
        self.assertIn("PROVISIONAL_DATA_BASELINE", master)

    def test_fixed_contracts_are_preserved(self) -> None:
        combined = "\n".join(
            path.read_text(encoding="utf-8") for path in (MASTER, DATA, MVP002, ROADMAP)
        )
        for required in (
            "권나래",
            "4주",
            "주당 7일",
            "2주차 0",
            "3주차 15",
            "4주차 강제 30",
            "CORE",
            "mvp-039",
            "annual-mvp-001-save-v1",
            "POC_PASSED",
            "NOT_APPROVED",
        ):
            self.assertIn(required, combined)

    def test_provisional_data_covers_all_requested_domains(self) -> None:
        data = DATA.read_text(encoding="utf-8")
        for required in (
            "companion_ohyun",
            "companion_han_serin",
            "companion_park_doyun",
            "companion_yoon_seoa",
            "companion_choi_minjae",
            "skill_support_observation_second_read",
            "equipment_observation_echo_recorder",
            "module_containment_pattern_memory",
            "research_observation_1_field_notation",
            "research_recovery_3_team_debrief",
            "condition_injury_minor",
            "condition_sleep_debt_1",
            "case_spring_core_01_last_platform",
            "case_spring_small_04_name_on_receipt",
            "value_truth_priority",
            "annual-year-end-v1",
        ):
            self.assertIn(required, data)
        self.assertIn("핵심 사건 4", data)
        self.assertIn("중형 사건 9", data)
        self.assertIn("소형 사건 14", data)

    def test_mvp002_is_implementation_ready_but_not_started(self) -> None:
        spec = MVP002.read_text(encoding="utf-8")
        for required in (
            "DESIGN_READY_FOR_USER_REVIEW",
            "annual-mvp-002-v1",
            "동료 최대 2명",
            "준비도 100",
            "deterministic_seed",
            "orphaned_ids",
            "기존 CORE-MVP-001을 직접 수정하지 않는다",
            "ANNUAL-MVP-002 focused",
        ):
            self.assertIn(required, spec)
        self.assertIn("annual_mvp_002_implementation: NOT_STARTED", spec)
        self.assertIn("production_expansion: NOT_APPROVED", spec)

    def test_decision_log_and_roadmap_link_the_baseline(self) -> None:
        decisions = DECISIONS.read_text(encoding="utf-8")
        roadmap = ROADMAP.read_text(encoding="utf-8")
        self.assertIn("D-2026-07-26-ANNUAL-EXPANSION-SEQUENCE", decisions)
        self.assertIn("Issue #84", decisions)
        self.assertIn("annual_expansion_sequence: APPROVED", roadmap)
        self.assertIn("annual_expansion_provisional_data: AUTHORED", roadmap)
        self.assertIn("annual_mvp_003_implementation: NOT_APPROVED", roadmap)
        self.assertIn("annual_mvp_004_implementation: NOT_APPROVED", roadmap)


if __name__ == "__main__":
    unittest.main()
