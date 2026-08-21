from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CANON_PATH = ROOT / "docs/current-planning-canon.json"
ADAPTER_PATH = ROOT / "skills/PROJECT_BASE_ADAPTER.json"
REGISTRY_PATH = ROOT / "skills/SKILL_REGISTRY.json"


def load(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


class CurrentPlanningCanonTests(unittest.TestCase):
    def setUp(self) -> None:
        self.canon = load(CANON_PATH)

    def test_monthly_product_shape_and_slice_roles_are_unambiguous(self) -> None:
        cadence = self.canon["planning"]["cadence"]
        self.assertEqual("MONTH", cadence["unit"])
        self.assertEqual(1, cadence["main_cases_per_unit"])
        self.assertEqual(list(range(1, 13)), cadence["initial_slate_months"])
        self.assertEqual([1, 4, 7, 10], cadence["signature_months"])
        self.assertEqual("M01_AFTERLIFE_STATION", self.canon["planning"]["first_session"])
        self.assertEqual("M04_RED_UMBRELLA", self.canon["planning"]["release_near_vertical_slice"])

    def test_core_flow_and_evidence_boundaries_remain_locked(self) -> None:
        self.assertEqual(
            [
                "INVESTIGATION",
                "DEDUCTION",
                "ANOMALY_MANUAL",
                "VICTIM_RESCUE",
                "RECOVERY",
                "COMPOSITE_RESULT",
            ],
            self.canon["planning"]["core_flow"],
        )
        gates = self.canon["gates"]
        self.assertEqual("RELEASED_TO_IMPLEMENTATION_GATE", gates["plan_lock"])
        self.assertFalse(gates["runtime_implementation_authorized"])
        self.assertEqual("NOT_RUN", gates["human_qa"])
        self.assertEqual("NOT_DECLARED", gates["poc_passed"])
        self.assertEqual("COMPLETE", gates["non_visual_planning"])
        self.assertEqual("COMPLETE", gates["visual_planning"])
        self.assertEqual("PENDING", gates["product_reference_asset"])
        self.assertEqual("COMPLETE", gates["overall_plan"])
        self.assertEqual("APPROVED", gates["user_final_planning_declaration"])
        self.assertEqual("HANDOFF_READY_WITH_KNOWN_REALIGNMENT", gates["implementation_reality_gate"])
        self.assertEqual("READY", gates["implementation_contract"])

    def test_runtime_compatibility_uses_additive_monthly_orchestration(self) -> None:
        runtime = self.canon["runtime_compatibility"]
        self.assertEqual("monthly_state", runtime["monthly_state_key"])
        self.assertEqual("NOT_IMPLEMENTED", runtime["monthly_state_status"])
        self.assertEqual("REUSE_EXISTING_CANON_V2_RUNTIME", runtime["canon_v2_runtime_strategy"])
        self.assertEqual("COMPOSITE_RESULT", runtime["current_result_authority"])
        self.assertEqual("REALIGNMENT_REQUIRED", runtime["legacy_s_rank_contract"])
        self.assertEqual("PRESERVE_HISTORICAL_RUNTIME_IDS", runtime["annual_mvp_identifiers"])
        self.assertFalse(runtime["infer_month_completion_from_legacy_reports"])
        self.assertFalse(runtime["rename_existing_episode_ids"])

    def test_all_reviewed_pull_request_deliverables_are_integrated(self) -> None:
        expected = {
            "211": "docs/CURRENT_DEDUCTION_RECOVERY_WORK_ORDER.md",
            "213": "docs/M01_M04_VERTICAL_SLICE_FLOW.md",
            "214": "docs/UI_COMPONENT_REUSE_CONTRACT.md",
            "215": "docs/VISUAL_ANCHOR_SPEC.md",
            "216": "docs/M01_INVESTIGATION_SCENE_PACKET.md",
            "217": "docs/M01_DEDUCTION_SCENE_PACKET.md",
            "218": "docs/M01_RESCUE_SCENE_PACKET.md",
        }
        self.assertEqual(expected, self.canon["integrated_pull_request_sources"])
        for path in expected.values():
            self.assertTrue((ROOT / path).is_file(), path)

        closure = self.canon["planning_closure_sources"]
        self.assertEqual(
            "docs/planning/2026-08-21-visual-ui-planning-closure.md",
            closure["visual_ui_closure"],
        )
        self.assertEqual("docs/M01_RECOVERY_SCENE_PACKET.md", closure["m01_recovery"])
        for path in closure.values():
            self.assertTrue((ROOT / path).is_file(), path)

        handoff = self.canon["implementation_handoff_sources"]
        self.assertEqual(
            "docs/audits/2026-08-22-final-planning-implementation-reality-gate.md",
            handoff["reality_gate"],
        )
        self.assertEqual(
            "docs/superpowers/specs/2026-08-22-post-planning-runtime-reconciliation-design.md",
            handoff["design"],
        )
        self.assertEqual(
            "docs/superpowers/plans/2026-08-22-post-planning-runtime-reconciliation-implementation-plan.md",
            handoff["implementation_plan"],
        )
        for path in handoff.values():
            self.assertTrue((ROOT / path).is_file(), path)

    def test_active_workspace_contract_is_notion_plus_repository(self) -> None:
        adapter = load(ADAPTER_PATH)
        workspace = adapter["project"]["workspace_authority"]
        self.assertEqual("NOTION", workspace["human_facing"]["system"])
        self.assertEqual("REPOSITORY", workspace["structured_implementation"]["system"])
        self.assertEqual("MIGRATION_ONLY", adapter["gdd_sheet"]["operational_role"])
        self.assertEqual("DO_NOT_USE_FOR_NEW_WORK", adapter["gdd_sheet"]["new_work_policy"])

        registry = load(REGISTRY_PATH)
        self.assertEqual("NOTION", registry["workspace_authority"]["human_facing"])
        self.assertEqual("REPOSITORY", registry["workspace_authority"]["structured_implementation"])
        self.assertEqual("MIGRATION_ONLY", registry["legacy_bca_visual_sheet"]["role"])

    def test_active_entrypoints_resolve_to_existing_files(self) -> None:
        for path in self.canon["active_entrypoints"]:
            self.assertTrue((ROOT / path).is_file(), path)

    def test_active_ledgers_do_not_reopen_merged_annual_work(self) -> None:
        active_ledgers = (
            ROOT / "MVP_ROADMAP.md",
            ROOT / "TEST_CHECKLIST.md",
            ROOT / "docs/CURRENT_STATUS.md",
        )
        forbidden = (
            "ANNUAL-MVP-002 수직절편 — 자동 검증 완료, 병합 대기",
            "ANNUAL-MVP-002 구현: `ON_BRANCH",
            "annual_mvp_002_implementation: ON_BRANCH",
            "annual_mvp_002_merge: PENDING",
        )
        failures: list[str] = []
        for path in active_ledgers:
            text = path.read_text(encoding="utf-8")
            for value in forbidden:
                if value in text:
                    failures.append(f"{path.relative_to(ROOT)} -> {value}")
        self.assertEqual([], failures)

    def test_current_project_identity_is_monthly_not_year_gated(self) -> None:
        core = (ROOT / "docs/PROJECT_CORE.md").read_text(encoding="utf-8")
        self.assertIn("월간 사건 Slate와 주간 계획", core)
        self.assertIn("월간 복합 결과", core)
        self.assertIn("M13+", core)

        historical_roadmap = (
            ROOT / "docs/planning/ROADMAP_AND_HANDOFF.md"
        ).read_text(encoding="utf-8")
        self.assertIn("HISTORICAL_ANNUAL_RUNTIME_ROADMAP", historical_roadmap)
        self.assertIn("CURRENT_PLANNING_CANON.md", historical_roadmap)

    def test_first_session_packets_preserve_full_flow_and_canon_v2(self) -> None:
        investigation = (
            ROOT / "docs/M01_INVESTIGATION_SCENE_PACKET.md"
        ).read_text(encoding="utf-8")
        deduction = (ROOT / "docs/M01_DEDUCTION_SCENE_PACKET.md").read_text(
            encoding="utf-8"
        )
        rescue = (ROOT / "docs/M01_RESCUE_SCENE_PACKET.md").read_text(
            encoding="utf-8"
        )
        recovery = (ROOT / "docs/M01_RECOVERY_SCENE_PACKET.md").read_text(
            encoding="utf-8"
        )

        for hypothesis in (
            "### H1 공식 원본 목적지설",
            "### H2 단일 가짜 목적지설",
            "### H3 개인 기억 투영설",
            "### H4 검은 승차권 원인설",
        ):
            self.assertIn(hypothesis, deduction)
        self.assertIn("검은 승차권이 없는 동시 청취자", investigation)
        self.assertIn(
            "Investigation → Deduction / Anomaly Manual → Victim Rescue → Recovery",
            rescue,
        )
        self.assertIn("공식 승차권", rescue)
        self.assertIn("검은 승차권 접촉·파괴는 구출 정답이 아니다", rescue)
        for pattern in ("목적지 합창", "회귀 승강장", "무정차 환송"):
            self.assertIn(pattern, recovery)
        self.assertIn("COMPOSITE_RESULT", recovery)

    def test_merge_governance_requires_five_loops_and_postmerge_readback(self) -> None:
        pull_request_template = (
            ROOT / ".github/pull_request_template.md"
        ).read_text(encoding="utf-8")
        workflow = (ROOT / "docs/MVP_WORKFLOW_CHECKLIST.md").read_text(
            encoding="utf-8"
        )
        for text in (pull_request_template, workflow):
            self.assertIn("최소 5회", text)
            self.assertIn("whole-scope", text)
            self.assertIn("GitHub·Notion", text)
            self.assertIn("readback", text)


if __name__ == "__main__":
    unittest.main()
