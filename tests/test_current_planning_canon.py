from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CANON_PATH = ROOT / "docs/current-planning-canon.json"
ADAPTER_PATH = ROOT / "skills/PROJECT_BASE_ADAPTER.json"
REGISTRY_PATH = ROOT / "skills/SKILL_REGISTRY.json"
RUNTIME_MERGE = "8d303f0f9414950273be934fd28c8fb1b3a21e18"


def load(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


class CurrentPlanningCanonTests(unittest.TestCase):
    def setUp(self) -> None:
        self.canon = load(CANON_PATH)

    def test_ten_day_half_day_product_shape_and_slice_roles_are_unambiguous(self) -> None:
        cadence = self.canon["planning"]["cadence"]
        self.assertEqual("TEN_DAY_CYCLE", cadence["unit"])
        self.assertEqual(10, cadence["days_per_cycle"])
        self.assertEqual(2, cadence["slots_per_day"])
        self.assertEqual(["morning", "afternoon"], cadence["slot_ids"])
        self.assertEqual(1, cadence["main_cases_per_cycle"])
        self.assertEqual(list(range(1, 10)), cadence["early_resolution_days"])
        self.assertEqual(10, cadence["regular_resolution_day"])
        self.assertEqual(list(range(1, 13)), cadence["initial_slate_case_numbers"])
        self.assertEqual([1, 4, 7, 10], cadence["signature_case_numbers"])
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
        self.assertTrue(gates["runtime_implementation_authorized"])
        self.assertEqual("MERGED_MAIN", gates["runtime_implementation"])
        self.assertEqual(RUNTIME_MERGE, gates["runtime_merge_commit"])
        self.assertEqual("RUNTIME_RECONCILIATION_MERGED", gates["implementation_reality_gate"])
        self.assertEqual("EXECUTED", gates["implementation_contract"])
        self.assertEqual("NOT_RUN", gates["human_qa"])
        self.assertEqual("NOT_DECLARED", gates["poc_passed"])
        self.assertEqual("COMPLETE", gates["non_visual_planning"])
        self.assertEqual("COMPLETE", gates["visual_planning"])
        self.assertEqual("PENDING", gates["product_reference_asset"])
        self.assertEqual("COMPLETE", gates["overall_plan"])
        self.assertEqual("APPROVED", gates["user_final_planning_declaration"])
        self.assertEqual("COMPLETE", gates["base_adapter_baseline_reconciliation"])

    def test_m04_uses_ten_day_early_and_regular_windows_without_fabricated_balance(self) -> None:
        planning = self.canon["planning"]
        timing = planning["m04_time_tradeoff"]
        support = planning["m04_route_memory_anchor_preparation_benefit"]
        self.assertEqual(
            "D-2026-08-28-TEN-DAY-HALF-DAY-CASE-CADENCE",
            timing["decision_id"],
        )
        self.assertEqual(
            ["DAYS_1_TO_9_EARLY", "DAY_10_REGULAR"],
            [entry["id"] for entry in timing["dispatch_windows"]],
        )
        self.assertEqual(
            list(range(1, 10)),
            timing["dispatch_windows"][0]["days"],
        )
        self.assertEqual(
            "REGULAR", timing["dispatch_windows"][1]["dispatch_kind"]
        )
        self.assertEqual(
            "M04_COMPOSITE_RESULT_TIMING_VIGNETTE / IMPLEMENTATION_PENDING",
            timing["result_timing_record"]["consumer"],
        )
        self.assertEqual("UNDEFINED_REQUIRES_SEPARATE_BALANCE_DECISION", support["replacement_timing_effect"])
        self.assertEqual(-16, support["actual_runtime_base_effect"]["fear_delta"])
        self.assertEqual("NOT_IMPLEMENTED", support["actual_runtime_base_effect"]["timing_bonus"])

    def test_m04_result_vignettes_keep_one_causal_result_per_page(self) -> None:
        vignettes = self.canon["planning"]["m04_sequential_narrative_result_vignettes"]
        decision_path = ROOT / "docs/decisions/D-2026-08-28-M04-SEQUENTIAL-NARRATIVE-RESULT-VIGNETTES.md"
        self.assertTrue(decision_path.is_file(), decision_path)
        self.assertEqual(
            "D-2026-08-28-M04-SEQUENTIAL-NARRATIVE-RESULT-VIGNETTES",
            vignettes["decision_id"],
        )
        self.assertEqual("M04_RED_UMBRELLA_ONLY", vignettes["scope"])
        self.assertEqual(
            [
                "VIGNETTE_VICTIM_RESCUE",
                "VIGNETTE_RESONANCE_RECOVERY",
                "VIGNETTE_ROUTE_MEMORY",
                "VIGNETTE_CASE_RECORD",
            ],
            vignettes["page_order"],
        )
        self.assertEqual(
            [
                "dispatch_kind",
                "resolution_day",
                "resolution_slot",
                "kwon_support_used",
                "actual_support_effect",
            ],
            vignettes["route_memory_payload"],
        )
        self.assertIn("ONE_CAUSAL_RESULT_PER_PAGE", vignettes["invariants"])
        self.assertIn(
            "NO_M04_RESULT_SCOREBOARD_OR_DASHBOARD_AGGREGATION",
            vignettes["invariants"],
        )
        self.assertIn("DAY_10_REMAINS_REGULAR_NOT_A_PENALTY", vignettes["invariants"])

    def test_runtime_compatibility_uses_additive_monthly_orchestration(self) -> None:
        runtime = self.canon["runtime_compatibility"]
        self.assertEqual("monthly_state", runtime["monthly_state_key"])
        self.assertEqual("IMPLEMENTED_ADDITIVE_OPTIONAL", runtime["monthly_state_status"])
        self.assertEqual("TEN_DAYS_AND_TWO_SLOTS_IMPLEMENTED_STRUCTURALLY", runtime["campaign_state_calendar"])
        self.assertEqual("NOT_IMPLEMENTED", runtime["ten_day_case_cadence_consumer"])
        self.assertEqual(
            "NOT_IMPLEMENTED_CURRENT_RUNTIME_ALLOWS_M01_M04_M07_IN_ONE_DEMO_CYCLE",
            runtime["one_main_case_runtime_enforcement"],
        )
        self.assertEqual(
            "APPROVED_DESIGN_NOT_IMPLEMENTED_NO_LIVE_CANDIDATE_POOL_OR_SCENE_CONSUMER",
            runtime["keyword_composition"],
        )
        self.assertEqual("REUSE_EXISTING_CANON_V2_RUNTIME", runtime["canon_v2_runtime_strategy"])
        self.assertEqual("COMPOSITE_RESULT", runtime["current_result_authority"])
        self.assertEqual("LEGACY_MASTERY_COMPATIBILITY_ONLY", runtime["legacy_s_rank_contract"])
        self.assertEqual("IMPLEMENTED", runtime["m01_first_session_orchestration"])
        self.assertEqual("4.3", runtime["main_menu_product_version"])
        self.assertEqual("IMPLEMENTED", runtime["m04_shared_system_baseline"])
        self.assertEqual("PRESERVE_HISTORICAL_RUNTIME_IDS", runtime["annual_mvp_identifiers"])
        self.assertFalse(runtime["infer_month_completion_from_legacy_reports"])
        self.assertFalse(runtime["rename_existing_episode_ids"])

    def test_all_reviewed_pull_request_deliverables_are_integrated(self) -> None:
        expected_docs = {
            "211": "docs/CURRENT_DEDUCTION_RECOVERY_WORK_ORDER.md",
            "213": "docs/M01_M04_VERTICAL_SLICE_FLOW.md",
            "214": "docs/UI_COMPONENT_REUSE_CONTRACT.md",
            "215": "docs/VISUAL_ANCHOR_SPEC.md",
            "216": "docs/M01_INVESTIGATION_SCENE_PACKET.md",
            "217": "docs/M01_DEDUCTION_SCENE_PACKET.md",
            "218": "docs/M01_RESCUE_SCENE_PACKET.md",
        }
        integrated = self.canon["integrated_pull_request_sources"]
        for pr, path in expected_docs.items():
            self.assertEqual(path, integrated[pr])
            self.assertTrue((ROOT / path).is_file(), path)
        self.assertEqual(RUNTIME_MERGE, integrated["224"])

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
        self.assertEqual(RUNTIME_MERGE, handoff["merged_runtime"])
        for key in ("reality_gate", "design", "implementation_plan"):
            self.assertTrue((ROOT / handoff[key]).is_file(), handoff[key])

    def test_active_workspace_contract_is_repository_only_with_historical_notion(self) -> None:
        adapter = load(ADAPTER_PATH)
        workspace = adapter["project"]["workspace_authority"]
        self.assertEqual("REPOSITORY", workspace["human_facing"]["system"])
        self.assertEqual("REPOSITORY", workspace["structured_implementation"]["system"])
        self.assertEqual("HISTORICAL_READ_ONLY_NO_WRITE", adapter["project"]["historical_notion"]["role"])
        self.assertEqual("MIGRATION_ONLY", adapter["gdd_sheet"]["operational_role"])
        self.assertEqual("DO_NOT_USE_FOR_NEW_WORK", adapter["gdd_sheet"]["new_work_policy"])

        registry = load(REGISTRY_PATH)
        self.assertEqual("REPOSITORY", registry["workspace_authority"]["human_facing"])
        self.assertEqual("REPOSITORY", registry["workspace_authority"]["structured_implementation"])
        self.assertEqual("HISTORICAL_READ_ONLY_NO_WRITE", registry["workspace_authority"]["historical_notion"])
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

    def test_current_project_identity_is_ten_day_not_year_gated(self) -> None:
        core = (ROOT / "docs/PROJECT_CORE.md").read_text(encoding="utf-8")
        self.assertIn("TEN_DAY_CYCLE", core)
        self.assertIn("10일·반일 일정", core)
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
