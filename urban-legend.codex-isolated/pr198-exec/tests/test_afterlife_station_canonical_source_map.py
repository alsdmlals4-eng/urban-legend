from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SOURCE_MAP = ROOT / "docs/planning/2026-08-04-afterlife-station-canonical-source-map-and-legacy-disposition.md"
AUDIT = ROOT / "docs/audits/2026-08-04-afterlife-station-batch-4-canonicalization-audit.md"
SECTION_7 = ROOT / "docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-07-three-chapter-manual-and-candidate-pools.md"


class AfterlifeStationCanonicalSourceMapTests(unittest.TestCase):
    def test_source_map_and_audit_exist(self) -> None:
        self.assertTrue(SOURCE_MAP.is_file(), SOURCE_MAP)
        self.assertTrue(AUDIT.is_file(), AUDIT)

    def test_status_vocabulary_is_authoritative(self) -> None:
        text = SOURCE_MAP.read_text(encoding="utf-8")
        for token in (
            "[정본]",
            "[대체됨]",
            "[보류]",
            "[폐기]",
            "[유지]",
            "각 파일 상단에 직접 적힌 배너와 동일한 권위",
        ):
            self.assertIn(token, text)

    def test_all_ten_decisions_and_sections_are_canonical(self) -> None:
        text = SOURCE_MAP.read_text(encoding="utf-8")
        decision_tokens = (
            "PERSONAL-DESTINATION-PROJECTION",
            "DESTINATION-BOUNDARY-RESET",
            "OFFICIAL-ROUTE-TICKET-AND-CORRECT-DISEMBARKATION",
            "NONSTOP-FAREWELL-TICKET-COUNTER",
            "RECURRING-PLATFORM-PERSISTENT-TRACE-ANCHOR",
            "DESTINATION-CHORUS-SILENCE-COUNTER",
            "THREE-CHAPTER-MANUAL-AND-CANDIDATE-POOLS",
            "FIRST-TEN-MINUTES-INVESTIGATION-PACING",
            "OUTCOME-GRADE-AND-REINVESTIGATION",
            "VISUAL-ART-AND-INFORMATION-LANGUAGE",
        )
        for token in decision_tokens:
            self.assertIn(f"[정본] docs/decisions/D-2026-08-04-AFTERLIFE-STATION-{token}.md", text)
        for index in range(1, 11):
            self.assertIn(f"[정본] docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-{index:02d}", text)

    def test_legacy_episode_and_poc_paths_are_explicitly_classified(self) -> None:
        text = SOURCE_MAP.read_text(encoding="utf-8")
        for token in (
            "data/episodes/episode_001_afterlife_station.json",
            "[보류] 구현 호환 입력 / 저승역 의미 규칙은 [대체됨]",
            "data/episodes/episode_001_afterlife_station_core_validation.json",
            "[보류] CORE-VALIDATION 회귀·이관 입력 / 회수 패턴 의미는 [대체됨]",
            "data/poc/core_mvp_001/afterlife_station_poc.json",
            "[보류] 독립 PoC 회귀 입력 / 사건 콘텐츠는 [대체됨]",
        ):
            self.assertIn(token, text)

    def test_conflicting_legacy_rules_are_discarded(self) -> None:
        text = SOURCE_MAP.read_text(encoding="utf-8")
        for token in (
            "[폐기] poc001_clue_reset_timing.text의 같은 시각으로 되돌아왔다",
            "[폐기] poc001_question_ticket_trigger",
            "[폐기] poc001_manual_ticket_contact_danger",
            "[폐기] 검은 승차권 접촉·파괴",
            "[폐기] 고정 5턴·자동 예측 중심 회수 구조",
        ):
            self.assertIn(token, text)

    def test_legacy_runtime_and_tests_are_deferred_not_deleted(self) -> None:
        text = SOURCE_MAP.read_text(encoding="utf-8")
        for token in (
            "[보류] IMPLEMENTATION_MIGRATION_INPUT",
            "scenes/poc/core_mvp_001/core_mvp_001_scene.tscn",
            "scripts/poc/core_mvp_001/core_mvp_001_state.gd",
            "tests/test_core_mvp_001_data_contract.py",
            "이관 완료 전 삭제하지 않는다",
        ):
            self.assertIn(token, text)

    def test_manual_to_recovery_reasoning_bridge_is_explicit_and_not_automatic(self) -> None:
        text = SECTION_7.read_text(encoding="utf-8")
        for token in (
            "매뉴얼에서 회수 전투로 이어지는 판단 근거",
            "1장",
            "[목적지 합창]",
            "2장",
            "[회귀 승강장]",
            "3장",
            "[무정차 환송]",
            "패턴명·정답 대응·정답 좌표·정답 타이밍을 자동 표시하지 않는다",
            "조사 → 매뉴얼 가설 → 구출 실행 → 전투 전조 판단 → 결과 검증",
        ):
            self.assertIn(token, text)

    def test_adversarial_audit_records_corrections_and_open_gates(self) -> None:
        text = AUDIT.read_text(encoding="utf-8")
        for token in (
            "PASS_AFTER_CORRECTIONS",
            "F-01 — 시간 초기화 충돌",
            "F-02 — 검은 승차권 핵심 정체성 충돌",
            "F-03 — 매뉴얼과 회수 전투 연결 누락",
            "F-04 — 첫 초기화 강제 실패 위험",
            "F-05 — 색상·음향 단독 판별 위험",
            "F-06 — 구형 구현을 정본으로 오인할 위험",
            "실제 한 전투에 세 패턴을 모두 배치할지, 일부만 배치할지는 `[보류]`",
            "IMPLEMENTATION_NOT_AUTHORIZED",
        ):
            self.assertIn(token, text)

    def test_codex_migration_requires_separate_approval(self) -> None:
        text = SOURCE_MAP.read_text(encoding="utf-8")
        for token in (
            "구형 ID → 새 매뉴얼·기록·패턴 ID migration matrix",
            "save `mvp-039` 및 Validation 저장 호환 정책",
            "사용자 별도 구현 승인 전 게임 코드·Scene·JSON·자산을 변경하지 않는다",
        ):
            self.assertIn(token, text)


if __name__ == "__main__":
    unittest.main()
