from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
M01_PACKET = ROOT / "docs/qa/M01_FIRST_SESSION_HUMAN_QA_PACKET.md"
M01_CHECKLIST = ROOT / "tools/qa/m01_first_session_human_qa_checklist.json"
M04_BRIEF = ROOT / "docs/visual/M04_PRODUCT_REFERENCE_APPROVAL_BRIEF.md"
LEGACY_CHECKLIST = ROOT / "tools/qa/afterlife_canon_v2_human_qa_checklist.json"


class M01HumanQaAndM04ReferenceGateTests(unittest.TestCase):
    def test_existing_one_click_system_checklist_is_preserved(self) -> None:
        legacy = json.loads(LEGACY_CHECKLIST.read_text(encoding="utf-8"))
        self.assertEqual(18, len(legacy["items"]))
        self.assertEqual(["PASS", "FAIL", "BLOCKED", "NOT_RUN"], legacy["allowed_statuses"])

    def test_m01_first_session_human_qa_packet_is_human_only_and_behavior_first(self) -> None:
        self.assertTrue(M01_PACKET.is_file())
        text = M01_PACKET.read_text(encoding="utf-8")
        for token in (
            "M01_FIRST_SESSION",
            "BEHAVIOR_FIRST_SELF_REPORT_SECOND",
            "SERIAL_EXAM_FATIGUE_GUARD",
            "NO_AUTOMATIC_PASS",
            "HUMAN_QA_NOT_RUN",
            "repository commit SHA",
            "START_HUMAN_QA.cmd",
            "조사 → 추리 → 구출 → 회수",
        ):
            self.assertIn(token, text)
        self.assertIn("진행자가 정답이나 규칙을 설명하지 않는다", text)
        self.assertIn("행동 관찰", text)
        self.assertIn("세션 후 자기보고", text)

    def test_m01_checklist_measures_comprehension_causal_reuse_and_fatigue_without_answer_hints(self) -> None:
        self.assertTrue(M01_CHECKLIST.is_file())
        payload = json.loads(M01_CHECKLIST.read_text(encoding="utf-8"))
        self.assertEqual(1, payload["schema_version"])
        self.assertEqual(["PASS", "FAIL", "BLOCKED", "NOT_RUN"], payload["allowed_statuses"])
        self.assertTrue(payload["human_only"])
        self.assertFalse(payload["automatic_pass_allowed"])
        items = payload["items"]
        self.assertEqual(8, len(items))
        self.assertEqual(len(items), len({item["id"] for item in items}))
        categories = {item["category"] for item in items}
        self.assertTrue({"identity", "comprehension", "causal_reuse", "fatigue", "result"}.issubset(categories))
        raw = M01_CHECKLIST.read_text(encoding="utf-8")
        self.assertNotIn("correct_response_id", raw)
        self.assertNotIn("answer_key", raw)
        self.assertTrue(all(item["human_only"] for item in items))

    def test_m04_reference_brief_is_one_candidate_and_stops_at_explicit_approval_gate(self) -> None:
        self.assertTrue(M04_BRIEF.is_file())
        text = M04_BRIEF.read_text(encoding="utf-8")
        for token in (
            "M04_RED_UMBRELLA",
            "비 오는 골목의 빨간 우산",
            "세 번째 빗소리",
            "젖지 않은 발자국",
            "SOFT_ANIME_NOIR_LOCKED",
            "DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM",
            "GENERATE_EXACTLY_ONE",
            "PRODUCT_REFERENCE_ASSET_PENDING",
        ):
            self.assertIn(token, text)
        self.assertIn("Investigation Anchor", text)
        self.assertIn("환경·괴이·증거 우선", text)
        self.assertNotIn("PRODUCT_REFERENCE_ASSET_APPROVED", text)

    def test_m04_result_approval_is_recorded_without_promoting_product_asset(self) -> None:
        machine = json.loads((ROOT / "docs/current-planning-canon.json").read_text(encoding="utf-8"))
        evidence = machine["evidence_ceiling"]
        self.assertEqual("USER_APPROVED_VISUAL_CANDIDATE", evidence["m04_reference_visual_candidate"])
        self.assertEqual("PENDING", evidence["product_reference_asset"])
        self.assertEqual("NOT_RUN", evidence["m04_runtime_visual_validation"])

        text = M04_BRIEF.read_text(encoding="utf-8")
        for token in (
            "RESULT_APPROVAL: USER_APPROVED",
            "USER_APPROVED_VISUAL_CANDIDATE",
            "4c67a65c9f7469bf39c231c81710fd71f0796501d13231c8fd7020bdad20462f",
            "1672x941",
            "2291020",
            "PRODUCT_REFERENCE_ASSET_PENDING",
        ):
            self.assertIn(token, text)
        self.assertNotIn("PRODUCT_REFERENCE_ASSET_APPROVED", text)

    def test_current_active_visual_docs_do_not_reopen_runtime_authorization_gate(self) -> None:
        for relative in (
            "docs/CURRENT_VISUAL_WORK_ORDER.md",
            "docs/VISUAL_ANCHOR_SPEC.md",
            "docs/M01_RECOVERY_SCENE_PACKET.md",
        ):
            text = (ROOT / relative).read_text(encoding="utf-8")
            self.assertNotIn("IMPLEMENTATION_NOT_AUTHORIZED", text, relative)
            self.assertNotIn("runtime_implementation: NOT_AUTHORIZED", text, relative)
            self.assertIn("PRODUCT_REFERENCE_ASSET_PENDING", text, relative)
            self.assertIn("HUMAN", text.upper(), relative)

    def test_validation_router_links_new_human_and_visual_gates(self) -> None:
        text = (ROOT / "docs/VALIDATION_TARGET_CANON.md").read_text(encoding="utf-8")
        self.assertIn("docs/qa/M01_FIRST_SESSION_HUMAN_QA_PACKET.md", text)
        self.assertIn("tools/qa/m01_first_session_human_qa_checklist.json", text)
        self.assertIn("docs/visual/M04_PRODUCT_REFERENCE_APPROVAL_BRIEF.md", text)
        self.assertIn("HUMAN_QA_NOT_RUN", text)
        self.assertIn("PRODUCT_REFERENCE_ASSET_PENDING", text)


if __name__ == "__main__":
    unittest.main()
