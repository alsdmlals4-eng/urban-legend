from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SPEC = ROOT / "docs/superpowers/specs/2026-08-05-afterlife-station-canon-v2-migration-design.md"
MATRIX = ROOT / "docs/planning/2026-08-05-afterlife-station-id-migration-matrix.md"


def read(*paths: Path) -> str:
    return "\n".join(path.read_text(encoding="utf-8") for path in paths)


class AfterlifeStationCanonV2MigrationDesignTests(unittest.TestCase):
    def test_spec_and_matrix_exist(self) -> None:
        self.assertTrue(SPEC.is_file(), SPEC)
        self.assertTrue(MATRIX.is_file(), MATRIX)

    def test_identity_is_preserved_while_content_contract_is_versioned(self) -> None:
        text = read(SPEC, MATRIX)
        for token in (
            "episode_001_afterlife_station",
            "victim_afterlife_station_001",
            "이하린",
            "afterlife-station-canon-v2",
            "content_schema: 2",
            "episode_001_afterlife_station_canon_v2.json",
            "새 사건 ID를 만들지 않는다",
        ):
            self.assertIn(token, text)

    def test_layering_is_explicit_allowlisted_and_cannot_mix_legacy_patterns(self) -> None:
        text = SPEC.read_text(encoding="utf-8")
        for token in (
            "base_episode",
            "legacy_core_validation",
            "canonical_v2",
            "allowlist",
            "loaded_layers",
            "구형 recovery_patterns와 Canon v2 patterns를 혼합하지 않는다",
            "암묵적 파일명 추론만으로 Canon v2를 활성화하지 않는다",
        ):
            self.assertIn(token, text)

    def test_canon_v2_has_bounded_data_blocks_and_stable_semantic_ids(self) -> None:
        text = SPEC.read_text(encoding="utf-8")
        for token in (
            "investigation_manual",
            "rescue_protocol",
            "recovery_encounters",
            "result_contract",
            "manual_afterlife_page_01_destination_projection",
            "record_afterlife_r1_broadcast_original",
            "pattern_afterlife_nonstop_farewell",
            "response_afterlife_present_official_ticket",
            "usage_refs",
        ):
            self.assertIn(token, text)

    def test_matrix_uses_explicit_migration_dispositions(self) -> None:
        text = MATRIX.read_text(encoding="utf-8")
        for token in (
            "KEEP_ID",
            "ALIAS",
            "SPLIT",
            "MERGE",
            "HISTORICAL_ONLY",
            "DISCARD_SEMANTICS",
            "orphan_legacy_ids",
        ):
            self.assertIn(token, text)

    def test_matrix_covers_high_risk_legacy_ids(self) -> None:
        text = MATRIX.read_text(encoding="utf-8")
        required_rows = (
            "clue_repeating_announcement",
            "clue_missing_terminal_sign",
            "clue_staff_room_log",
            "clue_last_message",
            "clue_black_ticket",
            "pattern_station_false_terminal",
            "pattern_station_boundary_collapse",
            "pattern_station_ticket_imprint",
            "pattern_station_gaze_lure",
            "poc001_clue_reset_timing",
            "poc001_pattern_ticket_imprint",
        )
        for token in required_rows:
            self.assertIn(token, text)
        self.assertIn("같은 시각", text)
        self.assertIn("검은 승차권 접촉", text)
        self.assertIn("자동 정답 변환 금지", text)

    def test_main_save_policy_is_backup_first_fail_closed_and_stage_aware(self) -> None:
        text = SPEC.read_text(encoding="utf-8")
        for token in (
            "mvp-038",
            "mvp-039",
            "mvp-040",
            "원본 저장 bytes를 먼저 backup",
            "실패 시 기존 파일과 메모리 모두 변경하지 않는다",
            "Legacy 저장으로 fallback하지 않는다",
            "draft_active",
            "정답 슬롯은 자동으로 채우지 않는다",
            "LEGACY_CASE_RESTART_REQUIRED",
            "legacy_resolution_snapshot",
            "과거 보상을 다시 지급하지 않는다",
        ):
            self.assertIn(token, text)

    def test_validation_policy_preserves_isolation_and_versions_forward(self) -> None:
        text = SPEC.read_text(encoding="utf-8")
        for token in (
            "validation-save-v1",
            "validation-save-v2",
            "active·suspended v1",
            "완료된 v1 기록은 읽기 전용 역사 결과",
            "구형 correct_response_id를 새 정답으로 사용하지 않는다",
            "Legacy 파일·숨은 메모리는 동일",
        ):
            self.assertIn(token, text)

    def test_migration_is_idempotent_and_preserves_unknown_ids_without_runtime_application(self) -> None:
        text = read(SPEC, MATRIX)
        for token in (
            "UNMAPPED_LEGACY_ID",
            "AMBIGUOUS_SPLIT_MAPPING",
            "ROLLBACK_RESTORED",
            "orphan_legacy_ids",
            "런타임에는 적용하지 않는다",
            "동일 migration을 두 번 적용해도 중복 효과가 없다",
            "effect_id",
        ):
            self.assertIn(token, text)

    def test_scope_is_design_only_and_requires_written_spec_review_before_plan(self) -> None:
        text = SPEC.read_text(encoding="utf-8")
        for token in (
            "REVIEW_READY",
            "DESIGN_ONLY",
            "IMPLEMENTATION_NOT_AUTHORIZED",
            "게임 코드·Scene·Episode JSON·저장 Schema·자산을 변경하지 않는다",
            "사용자 문서 검토 승인 후 implementation plan",
            "Human QA",
        ):
            self.assertIn(token, text)


if __name__ == "__main__":
    unittest.main()
