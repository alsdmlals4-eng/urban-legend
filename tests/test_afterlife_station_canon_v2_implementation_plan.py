from __future__ import annotations

import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SPEC = ROOT / "docs/superpowers/specs/2026-08-05-afterlife-station-canon-v2-migration-design.md"
DECISION = ROOT / "docs/decisions/D-2026-08-05-AFTERLIFE-STATION-CANON-V2-MIGRATION-DESIGN.md"
POLICY = ROOT / "docs/decisions/D-2026-08-05-WORKFLOW-BENCHMARK-TDD-AND-CHECKPOINT-POLICY.md"
PLAN = ROOT / "docs/superpowers/plans/2026-08-05-afterlife-station-canon-v2-migration-implementation-plan.md"
ADDENDUM = ROOT / "docs/superpowers/plans/2026-08-05-afterlife-station-canon-v2-migration-plan-adversarial-review-addendum.md"


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


class AfterlifeStationCanonV2ImplementationPlanTests(unittest.TestCase):
    def test_approved_spec_policy_plan_and_addendum_exist(self) -> None:
        self.assertTrue(SPEC.is_file(), SPEC)
        self.assertTrue(DECISION.is_file(), DECISION)
        self.assertTrue(POLICY.is_file(), POLICY)
        self.assertTrue(PLAN.is_file(), PLAN)
        self.assertTrue(ADDENDUM.is_file(), ADDENDUM)

    def test_document_approval_updates_existing_authority_without_authorizing_implementation(self) -> None:
        text = read(SPEC) + "\n" + read(DECISION)
        for token in (
            "APPROVED_SPEC",
            "IMPLEMENTATION_PLAN_READY",
            "IMPLEMENTATION_NOT_AUTHORIZED",
            "문서 승인: `2026-08-05 00:28 KST`",
            "별도 구현 승인",
            "별도 병합 승인",
        ):
            self.assertIn(token, text)

    def test_operating_policy_requires_benchmarking_tdd_and_bounded_approval_batches(self) -> None:
        text = read(POLICY)
        for token in (
            "벤치마킹",
            "현업 비교",
            "권장안",
            "최대 10건",
            "조기 체크포인트",
            "고위험 충돌",
            "세션 종료",
            "정본 영향",
            "TDD",
            "RED",
            "GREEN",
            "리팩터",
            "비실행형 작업",
            "검증 가능한 수용 계약",
        ):
            self.assertIn(token, text)

    def test_plan_uses_required_superpowers_header_and_exact_scope(self) -> None:
        text = read(PLAN)
        for token in (
            "# Afterlife Station Canon v2 Migration Implementation Plan",
            "REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development",
            "**Goal:**",
            "**Architecture:**",
            "**Tech Stack:**",
            "## Global Constraints",
            "episode_001_afterlife_station",
            "victim_afterlife_station_001",
            "afterlife-station-canon-v2",
            "mvp-040",
            "validation-save-v2",
            "IMPLEMENTATION_NOT_AUTHORIZED",
        ):
            self.assertIn(token, text)

    def test_plan_contains_current_industry_benchmark_comparison(self) -> None:
        text = read(PLAN)
        for token in (
            "## 현업 벤치마크와 채택 결론",
            "Godot",
            "Unreal Engine",
            "Unity Cloud Save",
            "Flyway",
            "source_checksum",
            "migration_history",
            "atomic replace",
        ):
            self.assertIn(token, text)

    def test_plan_is_decomposed_into_no_more_than_ten_reviewable_tasks(self) -> None:
        text = read(PLAN)
        tasks = re.findall(r"^### Task (\d+):", text, re.MULTILINE)
        self.assertGreaterEqual(len(tasks), 8)
        self.assertLessEqual(len(tasks), 10)
        self.assertEqual(tasks, [str(index) for index in range(1, len(tasks) + 1)])

    def test_every_task_has_a_complete_tdd_and_commit_cycle(self) -> None:
        text = read(PLAN)
        parts = re.split(r"(?=^### Task \d+:)", text, flags=re.MULTILINE)[1:]
        self.assertTrue(parts)
        for section in parts:
            heading = section.splitlines()[0]
            for token in (
                "**Files:**",
                "**Interfaces:**",
                "RED",
                "Expected: FAIL",
                "최소 구현",
                "GREEN",
                "focused",
                "회귀",
                "커밋",
            ):
                self.assertIn(token, section, f"{heading}: missing {token}")

    def test_plan_names_concrete_components_and_integration_files(self) -> None:
        text = read(PLAN)
        for token in (
            "scripts/data/afterlife_canon_v2_loader.gd",
            "scripts/data/afterlife_id_migration_registry.gd",
            "scripts/core/afterlife_legacy_save_inspector.gd",
            "scripts/core/afterlife_main_save_migrator.gd",
            "scripts/core/afterlife_validation_save_migrator.gd",
            "scripts/core/afterlife_migration_transaction.gd",
            "scripts/data/episode_loader.gd",
            "scripts/core/game_state.gd",
            "scripts/core/validation_save_repository.gd",
            "scripts/core/validation_session.gd",
            "data/episodes/episode_001_afterlife_station_canon_v2.json",
            "data/migrations/afterlife_station_canon_v2_id_migration.json",
            "tests/run_afterlife_canon_v2_migration_tests.sh",
        ):
            self.assertIn(token, text)

    def test_plan_preserves_adversarial_guards_and_approval_gates(self) -> None:
        text = read(PLAN) + "\n" + read(ADDENDUM)
        for token in (
            "migrated_unverified",
            "LEGACY_CASE_RESTART_REQUIRED",
            "legacy_resolution_snapshot",
            "orphan_legacy_ids",
            "구형 `correct_response_id`를 새 정답으로 사용하지 않는다",
            "과거 보상을 다시 지급하지 않는다",
            "Legacy 저장으로 fallback하지 않는다",
            "implementation approval checkpoint",
            "merge approval checkpoint",
        ):
            self.assertIn(token, text)

    def test_addendum_fixes_computed_provenance_and_two_phase_rollback(self) -> None:
        text = read(ADDENDUM)
        for token in (
            "implementation plan Task 1·2·7·8을 이 문서가 보정",
            "loaded_layers는 loader가 계산",
            "sidecar의 self-declared loaded_layers를 신뢰하지 않는다",
            "PREPARED",
            "COMMITTED_PENDING_RUNTIME_APPLY",
            "FINALIZED",
            "rollback_last_commit",
            "runtime apply 실패 시 파일과 메모리 모두 복원",
            "source_checksum",
            "backup",
            "조기 체크포인트",
        ):
            self.assertIn(token, text)

    def test_plan_has_no_placeholders_or_fake_completion_claims(self) -> None:
        text = read(PLAN) + "\n" + read(ADDENDUM)
        forbidden = (
            "TBD",
            "TODO",
            "implement later",
            "적절히 처리",
            "필요시 구현",
            "테스트를 추가한다",
        )
        for token in forbidden:
            self.assertNotIn(token, text)
        self.assertIn("Human QA: NOT_RUN", text)
        self.assertIn("Runtime implementation: NOT_RUN", text)


if __name__ == "__main__":
    unittest.main()
