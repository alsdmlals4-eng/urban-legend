from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
PLAN = ROOT / "docs/qa/2026-08-05-afterlife-canon-v2-human-qa-plan.md"
EVIDENCE = ROOT / "docs/qa/templates/afterlife-canon-v2-human-qa-evidence-template.md"
FIXTURE_ROOT = ROOT / "tests/fixtures/afterlife_migration"
EXPECTED_FIXTURES = (
    "main_mvp038_investigation.json",
    "main_mvp039_recovery.json",
    "main_mvp039_completed.json",
    "validation_v1_active_recovery.json",
)


class AfterlifeCanonV2HumanQaPlanTests(unittest.TestCase):
    def test_plan_and_evidence_template_exist(self) -> None:
        self.assertTrue(PLAN.is_file(), PLAN)
        self.assertTrue(EVIDENCE.is_file(), EVIDENCE)

    def test_plan_preserves_human_qa_and_merge_boundaries(self) -> None:
        text = PLAN.read_text(encoding="utf-8")
        for token in (
            "HUMAN_QA_NOT_RUN",
            "AUTOMATED_FIXTURE_PREFLIGHT",
            "MERGE_NOT_AUTHORIZED",
            "원본 저장 파일에서 직접 시험하지 않는다",
            "SHA-256",
            "Windows 10/11",
            "mvp-038",
            "mvp-039",
            "validation-save-v1",
            "파일 잠금",
            "강제 종료",
            "디스크 쓰기 실패",
            "보상 중복",
            "접근성",
            "PASS",
            "FAIL",
            "BLOCKED",
            "NOT_RUN",
        ):
            self.assertIn(token, text)

    def test_evidence_template_requires_reproducible_artifacts(self) -> None:
        text = EVIDENCE.read_text(encoding="utf-8")
        for token in (
            "Exact commit SHA",
            "Fixture SHA-256",
            "운영체제",
            "Godot 버전",
            "원본 bytes 보존",
            "migration journal",
            "재현 절차",
            "스크린샷 또는 로그 경로",
            "PASS / FAIL / BLOCKED / NOT_RUN",
            "Human QA 승인자",
        ):
            self.assertIn(token, text)

    def test_representative_fixture_files_are_declared(self) -> None:
        for name in EXPECTED_FIXTURES:
            self.assertTrue((FIXTURE_ROOT / name).is_file(), name)
        plan_text = PLAN.read_text(encoding="utf-8")
        for name in EXPECTED_FIXTURES:
            self.assertIn(name, plan_text)

    def test_no_placeholder_language_remains(self) -> None:
        for path in (PLAN, EVIDENCE):
            text = path.read_text(encoding="utf-8")
            for forbidden in ("TBD", "TODO", "추후 작성", "나중에 작성"):
                self.assertNotIn(forbidden, text, f"{forbidden}: {path}")


if __name__ == "__main__":
    unittest.main()
