import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
RETRACTED_ID = "DEC-20260806-118-CANON-V2-FOUR-TURN-TELEGRAPH-PATTERN-CYCLE"
RETRACTED_DECISION = ROOT / f"docs/decisions/{RETRACTED_ID}.md"
REAUDIT = ROOT / "docs/audits/2026-08-06-recovery-pattern-authority-project-wide-reaudit.md"
BATCH = ROOT / "docs/planning/2026-08-05-grillme-batch-3-approvals.md"
DESIGN_INTENT = ROOT / "DESIGN_INTENT.md"
PROJECT_BRIEF = ROOT / "PROJECT_BRIEF.md"


class RecoveryPatternAuthorityCorrectionContractTests(unittest.TestCase):
    def test_misinterpreted_four_turn_decision_is_retracted(self):
        text = RETRACTED_DECISION.read_text(encoding="utf-8")
        for phrase in (
            "RETRACTED_MISINTERPRETATION",
            "NOT_USER_APPROVED",
            "NOT_ACTIVE_AUTHORITY",
            "예시를 전역 고정 4턴 규칙으로 잘못 승격",
            "고정 4턴",
        ):
            self.assertIn(phrase, text)
        self.assertNotIn("> 상태: `APPROVED_DESIGN_CONTRACT`", text)

    def test_project_wide_reaudit_preserves_actual_pattern_flow(self):
        text = REAUDIT.read_text(encoding="utf-8")
        for phrase in (
            "괴이가 가진 패턴 집합",
            "완성된 패턴 하나",
            "단일 전조",
            "가설",
            "근거",
            "대응",
            "즉시 정오 판정",
            "안정도",
            "피해",
            "다음 패턴",
            "고정된 전역 턴 수가 없다",
            "미관측 패턴을 저작 순서로 우선",
            "직전 패턴 반복 회피",
            "core_recovered",
            "LEGACY_SINGLE_OUTCOME",
        ):
            self.assertIn(phrase, text)

    def test_authority_data_runtime_save_result_and_tests_are_all_audited(self):
        text = REAUDIT.read_text(encoding="utf-8")
        for heading in (
            "권위 문서",
            "사건 데이터",
            "Canon v2와 runtime projection",
            "battle_scene.gd",
            "GameState",
            "저장·마이그레이션",
            "result_scene.gd",
            "자동 테스트",
        ):
            self.assertIn(heading, text)

    def test_retraction_remains_non_counting_as_valid_batch_approvals_advance(self):
        text = BATCH.read_text(encoding="utf-8")
        counter = re.search(r"상태: `OPEN / (\d+)_OF_10", text)
        self.assertIsNotNone(counter)
        approved_rows = re.findall(
            r"^\|\s*\d+\s*\|\s*`(DEC-[^`]+)`\s*\|.*\|\s*`APPROVED`\s*\|",
            text,
            re.MULTILINE,
        )
        self.assertEqual(int(counter.group(1)), len(approved_rows))
        self.assertGreaterEqual(len(approved_rows), 3)
        self.assertNotIn(RETRACTED_ID, approved_rows)
        self.assertIn(RETRACTED_ID, text)
        self.assertIn("RETRACTED / NON_COUNTING", text)

    def test_active_pointers_never_return_to_retracted_decision(self):
        batch = BATCH.read_text(encoding="utf-8")
        approved_ids = set(
            re.findall(
                r"^\|\s*\d+\s*\|\s*`(DEC-[^`]+)`\s*\|.*\|\s*`APPROVED`\s*\|",
                batch,
                re.MULTILINE,
            )
        )
        for path in (DESIGN_INTENT, PROJECT_BRIEF):
            text = path.read_text(encoding="utf-8")
            pointer = re.search(r"최신 승인 오버레이: `([^`]+)`", text)
            self.assertIsNotNone(pointer, path.relative_to(ROOT))
            active_id = pointer.group(1)
            self.assertIn(active_id, approved_ids, path.relative_to(ROOT))
            self.assertNotEqual(active_id, RETRACTED_ID, path.relative_to(ROOT))
            self.assertNotIn(
                f"최신 승인 오버레이: `{RETRACTED_ID}`",
                text,
                path.relative_to(ROOT),
            )

    def test_no_universal_fixed_turn_contract_is_asserted(self):
        combined = "\n".join(
            path.read_text(encoding="utf-8") for path in (RETRACTED_DECISION, REAUDIT, BATCH)
        )
        for phrase in (
            "4턴은 예시일 뿐 전역 규칙이 아니다",
            "패턴별 전조·판단 단위",
            "사건과 괴이가 저작한 패턴 수",
        ):
            self.assertIn(phrase, combined)

    def test_authorization_and_qa_boundaries_remain_closed(self):
        combined = "\n".join(
            path.read_text(encoding="utf-8") for path in (RETRACTED_DECISION, REAUDIT, BATCH)
        )
        for phrase in (
            "IMPLEMENTATION_NOT_AUTHORIZED",
            "HUMAN_QA_NOT_RUN",
            "UI_ACCESSIBILITY_NOT_RUN",
            "BATCH_MERGE_NOT_STARTED",
            "MERGE_NOT_AUTHORIZED",
        ):
            self.assertIn(phrase, combined)


if __name__ == "__main__":
    unittest.main()
