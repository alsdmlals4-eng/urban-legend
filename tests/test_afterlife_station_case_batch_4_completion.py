from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
D6 = ROOT / "docs/decisions/D-2026-08-04-AFTERLIFE-STATION-DESTINATION-CHORUS-SILENCE-COUNTER.md"
S6 = ROOT / "docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-06-destination-chorus-silence-counter.md"
D7 = ROOT / "docs/decisions/D-2026-08-04-AFTERLIFE-STATION-THREE-CHAPTER-MANUAL-AND-CANDIDATE-POOLS.md"
S7 = ROOT / "docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-07-three-chapter-manual-and-candidate-pools.md"
D8 = ROOT / "docs/decisions/D-2026-08-04-AFTERLIFE-STATION-FIRST-TEN-MINUTES-INVESTIGATION-PACING.md"
S8 = ROOT / "docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-08-first-ten-minutes-investigation-pacing.md"
D9 = ROOT / "docs/decisions/D-2026-08-04-AFTERLIFE-STATION-OUTCOME-GRADE-AND-REINVESTIGATION.md"
S9 = ROOT / "docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-09-outcome-grade-and-reinvestigation.md"
D10 = ROOT / "docs/decisions/D-2026-08-04-AFTERLIFE-STATION-VISUAL-ART-AND-INFORMATION-LANGUAGE.md"
S10 = ROOT / "docs/planning/2026-08-04-afterlife-station-complete-case-batch-4-section-10-visual-art-and-information-language.md"
BATCH = ROOT / "docs/planning/2026-08-04-afterlife-station-complete-case-batch-4.md"
LEDGER = ROOT / "docs/GRILLME_BATCH_4_LEDGER.md"


def read(*paths: Path) -> str:
    return "\n".join(path.read_text(encoding="utf-8") for path in paths)


class AfterlifeStationCompletionTests(unittest.TestCase):
    def test_decision_6_destination_chorus_exists(self) -> None:
        self.assertTrue(D6.is_file(), D6)
        self.assertTrue(S6.is_file(), S6)

    def test_destination_chorus_uses_shared_silence_not_ticket_or_trace(self) -> None:
        text = read(D6, S6)
        for token in (
            "[목적지 합창]",
            "서로 다른 목적지",
            "공통 무음 구간",
            "공식 역 식별음",
            "공백에 삽입",
            "승차권을 파훼 수단으로 사용하지 않는다",
            "지속 흔적 좌표를 고정하는 패턴이 아니다",
        ):
            self.assertIn(token, text)

    def test_destination_chorus_follows_final_turn_precommit_and_distinct_results(self) -> None:
        text = read(S6)
        for token in (
            "N ≥ 2",
            "N-1개의 전조",
            "대응 선택 → 패턴 발현 → 결과 산출 → 평상 진행",
            "개인 목적지 투영 붕괴",
            "[파훼]",
            "기억 매듭 노출",
            "괴이 [취약]",
            "하나의 목적지를 선택",
            "방어",
            "잘못된 타이밍",
            "허상 공격",
            "숨겨진 확률",
        ):
            self.assertIn(token, text)

    def test_destination_chorus_is_not_auto_solved_or_audio_only(self) -> None:
        text = read(S6)
        for token in (
            "공통 무음 구간을 자동 강조하지 않는다",
            "정답 타이밍을 자동 선택하지 않는다",
            "자막",
            "타임스탬프",
            "파형 구간 라벨",
            "음향만으로 판별하지 않는다",
        ):
            self.assertIn(token, text)

    def test_decision_7_manual_and_candidate_pools_exist(self) -> None:
        self.assertTrue(D7.is_file(), D7)
        self.assertTrue(S7.is_file(), S7)

    def test_three_chapters_have_exact_questions_and_slot_counts(self) -> None:
        text = read(D7, S7)
        for token in (
            "1장: 누가 목적지를 만드는가",
            "4개 슬롯",
            "2장: 무엇이 반복을 일으키는가",
            "5개 슬롯",
            "3장: 어떻게 현실로 데리고 나오는가",
            "5개 슬롯",
            "최종장의 모든 빈칸",
            "조사 페이즈 종료",
        ):
            self.assertIn(token, text)

    def test_candidate_pools_are_page_local_concrete_and_include_mutations(self) -> None:
        text = read(S7)
        for token in (
            "1장 후보 풀: 8개",
            "2장 후보 풀: 9개",
            "3장 후보 풀: 10개",
            "목적지 구간의 무음 공백",
            "안내 종료 전",
            "위치만 초기화",
            "현실 귀환 경로",
            "공식 역 식별음",
            "노선색·노선명·역 코드 일치 승차권",
            "[변조]",
        ):
            self.assertIn(token, text)

    def test_manual_allows_free_unlocked_placement_without_answer_hints(self) -> None:
        text = read(D7, S7)
        for token in (
            "획득·해금된 후보라면 어떤 빈 슬롯에도",
            "정답 적합도를 이유로 배치를 막지 않는다",
            "정답·오답·근접도·추천 순위",
            "표시하지 않는다",
            "출처와 사용 위치",
            "비소모 증거 참조",
        ):
            self.assertIn(token, text)

    def test_decision_8_first_ten_minutes_exists(self) -> None:
        self.assertTrue(D8.is_file(), D8)
        self.assertTrue(S8.is_file(), S8)

    def test_first_ten_minutes_teaches_record_comparison_and_candidate_placement(self) -> None:
        text = read(D8, S8)
        for token in (
            "0~1분",
            "1~3분",
            "3~6분",
            "6~8분",
            "8~10분",
            "단서 [기록] 비교",
            "후보 키워드 배치",
            "오답 가설 반증",
            "첫 10분",
        ):
            self.assertIn(token, text)

    def test_first_reset_has_prevention_and_alternate_evidence_route(self) -> None:
        text = read(S8)
        for token in (
            "강제 실패가 아니다",
            "피해자의 경계 통과를 막으면",
            "과거 CCTV·연속 녹음",
            "대체 경로",
            "핵심 기록에는 최소 2개의 획득 경로",
            "튜토리얼 팝업이 정답을 말하지 않는다",
        ):
            self.assertIn(token, text)

    def test_opening_emotional_anchor_does_not_make_desire_the_correct_route(self) -> None:
        text = read(D8, S8)
        for token in (
            "이하린",
            "철거된 옛집",
            "돌아가고 싶은 장소",
            "현실 귀환 경로의 정답이 아니다",
            "후회와 귀환 강박",
        ):
            self.assertIn(token, text)

    def test_decision_9_outcomes_exist(self) -> None:
        self.assertTrue(D9.is_file(), D9)
        self.assertTrue(S9.is_file(), S9)

    def test_normal_clear_s_rank_and_retreat_are_separate(self) -> None:
        text = read(D9, S9)
        for token in (
            "일반 클리어",
            "피해자 구출 성공",
            "잔향 회수 성공",
            "S 랭크",
            "필수 슬롯 전부 확인",
            "핵심 [변조] 후보 반증",
            "승인 철수",
            "피해자 구출 후 회수 중단",
            "괴이는 미회수",
        ):
            self.assertIn(token, text)

    def test_failure_preserves_first_run_canon_and_scoped_truth_reveal(self) -> None:
        text = read(S9)
        for token in (
            "최초 조사 정본",
            "덮어쓰지 않는다",
            "partial_truth_revealed",
            "검증된 범위만 공개",
            "공식 정답 공개",
            "answer_viewed",
            "비정본 기록 재현",
            "재현 숙련 등급",
        ):
            self.assertIn(token, text)

    def test_s_rank_does_not_penalize_accessibility_or_mandatory_demo(self) -> None:
        text = read(D9, S9)
        for token in (
            "접근성 기능 사용은 감점하지 않는다",
            "검증 요청 횟수는 감점하지 않는다",
            "통제된 첫 초기화 시연",
            "S 랭크 감점 대상이 아니다",
            "예고 뒤 반복한 예방 가능한 위험",
        ):
            self.assertIn(token, text)

    def test_decision_10_art_direction_exists(self) -> None:
        self.assertTrue(D10.is_file(), D10)
        self.assertTrue(S10.is_file(), S10)

    def test_visual_pillars_support_mundane_transit_and_memory_intrusion(self) -> None:
        text = read(D10, S10)
        for token in (
            "심야 도시철도 현실감",
            "개인 기억의 미세한 침입",
            "공식 교통 정보 문법",
            "공간 반복 공포",
            "현장 기록 문서",
        ):
            self.assertIn(token, text)

    def test_ticket_and_mutated_candidate_visuals_are_redundant_and_fair(self) -> None:
        text = read(S10)
        for token in (
            "노선색",
            "노선명",
            "역 코드",
            "문양",
            "색상만으로 구분하지 않는다",
            "[변조] 후보는 확인 전 정상 후보와 같은 정보 해상도",
            "확인 후 방해 기록 도장",
            "변경된 변수",
        ):
            self.assertIn(token, text)

    def test_three_combat_patterns_have_distinct_visual_languages(self) -> None:
        text = read(S10)
        for token in (
            "[무정차 환송]",
            "잘못된 노선 전광판",
            "[회귀 승강장]",
            "지속 흔적과 위치 잔상",
            "[목적지 합창]",
            "서로 다른 목적지 자막과 공통 무음 파형",
        ):
            self.assertIn(token, text)

    def test_art_brief_does_not_authorize_asset_generation_or_implementation(self) -> None:
        text = read(D10, S10)
        for token in (
            "이미지 생성은 후속 승인",
            "게임 자산 제작은 승인하지 않는다",
            "코드·Scene·UI 구현은 승인하지 않는다",
            "아트 브리프",
        ):
            self.assertIn(token, text)

    def test_batch_and_ledger_reach_ten_of_ten_and_preserve_checkpoints(self) -> None:
        text = read(BATCH, LEDGER)
        for token in (
            "10 / 10",
            "GRILLME_BATCH_4_10_OF_10",
            "5 / 10",
            "GRILLME_BATCH_4_5_OF_10",
            "D-2026-08-04-AFTERLIFE-STATION-DESTINATION-CHORUS-SILENCE-COUNTER",
            "D-2026-08-04-AFTERLIFE-STATION-THREE-CHAPTER-MANUAL-AND-CANDIDATE-POOLS",
            "D-2026-08-04-AFTERLIFE-STATION-FIRST-TEN-MINUTES-INVESTIGATION-PACING",
            "D-2026-08-04-AFTERLIFE-STATION-OUTCOME-GRADE-AND-REINVESTIGATION",
            "D-2026-08-04-AFTERLIFE-STATION-VISUAL-ART-AND-INFORMATION-LANGUAGE",
            "BATCH_COMPLETE_PENDING_EXPLICIT_MERGE_APPROVAL",
        ):
            self.assertIn(token, text)


if __name__ == "__main__":
    unittest.main()
