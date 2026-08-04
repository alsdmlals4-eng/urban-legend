from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DECISION = ROOT / "docs/decisions/D-2026-08-04-AFTERLIFE-STATION-PERSONAL-DESTINATION-PROJECTION.md"
SECTION = ROOT / "docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-01-personal-destination-projection.md"
DECISION_2 = ROOT / "docs/decisions/D-2026-08-04-AFTERLIFE-STATION-DESTINATION-BOUNDARY-RESET.md"
SECTION_2 = ROOT / "docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-02-destination-boundary-reset.md"
DECISION_3 = ROOT / "docs/decisions/D-2026-08-04-AFTERLIFE-STATION-OFFICIAL-ROUTE-TICKET-AND-CORRECT-DISEMBARKATION.md"
SECTION_3 = ROOT / "docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-03-official-route-ticket-and-correct-disembarkation.md"
DECISION_4 = ROOT / "docs/decisions/D-2026-08-04-AFTERLIFE-STATION-NONSTOP-FAREWELL-TICKET-COUNTER.md"
SECTION_4 = ROOT / "docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-04-nonstop-farewell-ticket-counter.md"
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

    def test_second_decision_and_section_exist(self) -> None:
        self.assertTrue(DECISION_2.is_file(), DECISION_2)
        self.assertTrue(SECTION_2.is_file(), SECTION_2)

    def test_reset_requires_projected_destination_boundary_crossing_before_announcement_ends(self) -> None:
        text = DECISION_2.read_text(encoding="utf-8") + SECTION_2.read_text(encoding="utf-8")
        for token in (
            "안내 종료 전",
            "자신이 들은 목적지",
            "승차선·계단·출구 경계",
            "경계를 넘으면",
            "위치만 초기화",
            "승강장 내부의 관찰·기록 수집·짧은 위치 이동은 안전",
        ):
            self.assertIn(token, text)
        self.assertIn("조금이라도 이동하면 초기화되는 규칙이 아니다", text)
        self.assertIn("검은 승차권 접촉이 발동 조건이 아니다", text)

    def test_reset_preserves_time_and_accumulates_traceable_evidence(self) -> None:
        text = SECTION_2.read_text(encoding="utf-8")
        for token in (
            "시간은 되돌아가지 않는다",
            "휴대전화 시각",
            "녹음 길이",
            "배터리",
            "소지품 위치",
            "요원의 기록",
            "시간은 흘렀지만 위치만 돌아왔다",
        ):
            self.assertIn(token, text)

    def test_first_reset_is_a_risk_case_and_safe_movement_remains_for_chapter_three(self) -> None:
        text = SECTION_2.read_text(encoding="utf-8")
        for token in (
            "첫 초기화",
            "즉사나 사건 실패가 아니다",
            "관찰 가능한 위험 사례",
            "반복 횟수",
            "피해자 연결",
            "위험도",
            "안내 종료까지 기다리면",
            "3장",
            "안전한 이동 절차",
        ):
            self.assertIn(token, text)

    def test_batch_ledger_tracks_two_of_ten_and_preserves_first_checkpoint(self) -> None:
        text = BATCH.read_text(encoding="utf-8") + LEDGER.read_text(encoding="utf-8")
        for token in (
            "2 / 10",
            "GRILLME_BATCH_4_2_OF_10",
            "이전 체크포인트",
            "1 / 10",
            "GRILLME_BATCH_4_1_OF_10",
            "D-2026-08-04-AFTERLIFE-STATION-DESTINATION-BOUNDARY-RESET",
        ):
            self.assertIn(token, text)

    def test_third_decision_and_section_exist(self) -> None:
        self.assertTrue(DECISION_3.is_file(), DECISION_3)
        self.assertTrue(SECTION_3.is_file(), SECTION_3)

    def test_rescue_uses_victim_specific_official_route_ticket_not_projected_desire(self) -> None:
        text = DECISION_3.read_text(encoding="utf-8") + SECTION_3.read_text(encoding="utf-8")
        for token in (
            "자신에게 맞는 승차권",
            "현실 귀환 경로",
            "공식 운행 기록",
            "승차권 색상",
            "노선색",
            "역 코드",
            "개인의 바람에 맞는 표가 아니다",
            "투영된 목적지와 구분",
        ):
            self.assertIn(token, text)

    def test_ticket_match_is_not_color_only_and_has_accessible_redundancy(self) -> None:
        text = SECTION_3.read_text(encoding="utf-8")
        for token in (
            "색상만으로 판별하지 않는다",
            "노선명",
            "역 코드",
            "문양",
            "텍스트",
            "색각",
            "[변조]",
        ):
            self.assertIn(token, text)

    def test_rescue_sequence_requires_ticket_recovery_boarding_and_correct_disembarkation(self) -> None:
        text = SECTION_3.read_text(encoding="utf-8")
        for token in (
            "안내 종료",
            "공식 역 식별음",
            "자신에게 맞는 승차권을 회수",
            "피해자와 함께 탑승",
            "승차권에 적힌 알맞은 역",
            "하차",
            "승차권을 끝까지 보관",
        ):
            self.assertIn(token, text)

    def test_wrong_ticket_or_station_produces_observable_failure_not_hidden_randomness(self) -> None:
        text = SECTION_3.read_text(encoding="utf-8")
        for token in (
            "잘못된 색상",
            "잘못된 역 코드",
            "잘못된 역에서 하차",
            "피해자 위험도",
            "관찰 기록",
            "숨겨진 확률",
            "즉시 사망이 아니다",
        ):
            self.assertIn(token, text)

    def test_batch_ledger_tracks_three_of_ten_and_preserves_prior_checkpoints(self) -> None:
        text = BATCH.read_text(encoding="utf-8") + LEDGER.read_text(encoding="utf-8")
        for token in (
            "3 / 10",
            "GRILLME_BATCH_4_3_OF_10",
            "2 / 10",
            "GRILLME_BATCH_4_2_OF_10",
            "1 / 10",
            "GRILLME_BATCH_4_1_OF_10",
            "D-2026-08-04-AFTERLIFE-STATION-OFFICIAL-ROUTE-TICKET-AND-CORRECT-DISEMBARKATION",
        ):
            self.assertIn(token, text)

    def test_fourth_decision_and_section_exist(self) -> None:
        self.assertTrue(DECISION_4.is_file(), DECISION_4)
        self.assertTrue(SECTION_4.is_file(), SECTION_4)

    def test_nonstop_farewell_uses_variable_telegraph_and_final_turn_precommit(self) -> None:
        text = DECISION_4.read_text(encoding="utf-8") + SECTION_4.read_text(encoding="utf-8")
        for token in (
            "[무정차 환송]",
            "N ≥ 2",
            "N-1개의 전조",
            "1턴 전조",
            "플레이어의 평상 행동 전에",
            "2턴부터 N-1턴",
            "플레이어의 행동이 먼저 해결",
            "대응 선택 → 패턴 발현 → 결과 산출 → 평상 진행",
        ):
            self.assertIn(token, text)
        self.assertIn("패턴 준비 완료", text)
        self.assertIn("다음 턴 발현", text)
        self.assertIn("표시하지 않는다", text)

    def test_official_ticket_counter_creates_break_and_vulnerability_without_consuming_ticket(self) -> None:
        text = SECTION_4.read_text(encoding="utf-8")
        for token in (
            "구출 단계에서 끝까지 보관한 공식 승차권",
            "최종 턴",
            "개찰기에 제시",
            "노선색·노선명·역 코드",
            "투영 노선 무효화",
            "[파훼]",
            "[취약]",
            "유효 공격 기회",
            "승차권은 소모되지 않는다",
            "공식 검표 흔적",
        ):
            self.assertIn(token, text)

    def test_alternative_responses_have_distinct_deterministic_results(self) -> None:
        text = SECTION_4.read_text(encoding="utf-8")
        for token in (
            "방어",
            "피해 감소",
            "[취약]은 발생하지 않는다",
            "공격",
            "강한 피해",
            "잘못된 승차권",
            "노선 불일치",
            "위치 초기화",
            "너무 일찍",
            "행동이나 자원만 소비",
            "파훼 효과 없음",
            "숨겨진 확률",
        ):
            self.assertIn(token, text)

    def test_pattern_cues_are_traceable_and_not_color_or_audio_only(self) -> None:
        text = SECTION_4.read_text(encoding="utf-8")
        for token in (
            "목적지 없는 전광판",
            "잘못된 노선색",
            "역 코드",
            "노선 문양",
            "선로 진동",
            "무정차 열차 접근 기록",
            "색상만으로",
            "음향만으로",
            "텍스트 로그",
        ):
            self.assertIn(token, text)

    def test_first_pattern_does_not_make_every_recovery_pattern_ticket_based(self) -> None:
        text = DECISION_4.read_text(encoding="utf-8") + SECTION_4.read_text(encoding="utf-8")
        self.assertIn("첫 대표 회수 패턴", text)
        self.assertIn("모든 회수 전투 패턴을 승차권으로 해결하지 않는다", text)
        self.assertIn("패턴 길이는 고정하지 않는다", text)

    def test_batch_ledger_tracks_four_of_ten_and_preserves_prior_checkpoints(self) -> None:
        text = BATCH.read_text(encoding="utf-8") + LEDGER.read_text(encoding="utf-8")
        for token in (
            "4 / 10",
            "GRILLME_BATCH_4_4_OF_10",
            "3 / 10",
            "GRILLME_BATCH_4_3_OF_10",
            "2 / 10",
            "GRILLME_BATCH_4_2_OF_10",
            "1 / 10",
            "GRILLME_BATCH_4_1_OF_10",
            "D-2026-08-04-AFTERLIFE-STATION-NONSTOP-FAREWELL-TICKET-COUNTER",
        ):
            self.assertIn(token, text)


if __name__ == "__main__":
    unittest.main()
