from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DECISION = ROOT / "docs/decisions/D-2026-08-04-AFTERLIFE-STATION-PERSONAL-DESTINATION-PROJECTION.md"
SECTION = ROOT / "docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-01-personal-destination-projection.md"
BATCH = ROOT / "docs/planning/2026-08-04-afterlife-station-complete-case-batch-4.md"
LEDGER = ROOT / "docs/GRILLME_BATCH_4_LEDGER.md"


class AfterlifeStationCaseBatch4Tests(unittest.TestCase):
    def test_decision_and_section_exist(self) -> None:
        self.assertTrue(DECISION.is_file(), DECISION)
        self.assertTrue(SECTION.is_file(), SECTION)

    def test_first_page_uses_cross_record_reasoning(self) -> None:
        text = DECISION.read_text(encoding="utf-8") + SECTION.read_text(encoding="utf-8")
        for token in (
            "1장 핵심 추리",
            "안내방송 원본",
            "목적지 구간이 비어",
            "피해자 휴대전화",
            "같은 순간 서로 다른 목적지",
            "공식 운행 기록",
            "추가 목적지와 추가 열차는 존재하지 않는다",
            "귀환 기억",
            "듣는 사람이",
            "교차검증",
        ):
            self.assertIn(token, text)

    def test_first_page_does_not_resolve_later_rules(self) -> None:
        text = SECTION.read_text(encoding="utf-8")
        self.assertIn("단일 단서만으로 확정하지 않는다", text)
        self.assertIn("2장", text)
        self.assertIn("안내 종료 전 이동", text)
        self.assertIn("3장", text)
        self.assertIn("구출 절차", text)
        self.assertIn("회수 전투 대응", text)
        self.assertIn("1장에서는 정답으로 확정하지 않는다", text)

    def test_records_produce_concrete_candidate_keywords(self) -> None:
        text = SECTION.read_text(encoding="utf-8")
        for token in (
            "목적지 구간의 무음 공백",
            "피해자가 들은 귀환 목적지",
            "동시간대 목적지 불일치",
            "공식 노선에 없는 추가 목적지",
            "공백에 귀환 기억이 투영된다",
            "[변조]",
        ):
            self.assertIn(token, text)

    def test_batch_ledger_tracks_one_of_ten_without_implementation(self) -> None:
        self.assertTrue(BATCH.is_file(), BATCH)
        self.assertTrue(LEDGER.is_file(), LEDGER)
        text = BATCH.read_text(encoding="utf-8") + LEDGER.read_text(encoding="utf-8")
        for token in (
            "1 / 10",
            "GRILLME_BATCH_4_1_OF_10",
            "D-2026-08-04-AFTERLIFE-STATION-PERSONAL-DESTINATION-PROJECTION",
            "IMPLEMENTATION_NOT_AUTHORIZED",
            "게임 코드·Scene·사건 데이터·자산",
        ):
            self.assertIn(token, text)


if __name__ == "__main__":
    unittest.main()
