from __future__ import annotations

import hashlib
import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ADAPTER_PATH = ROOT / "skills/PROJECT_BASE_ADAPTER.json"
RECEIPT_PATH = ROOT / "docs/operations/receipts/2026-09-01-base-v944-operating-adaptation.json"

EXPECTED_RELEASE = {
    "repository": "alsdmlals4-eng/Base",
    "version": "9.4.4",
    "release_commit": "210ec78292fa12ed7563ba743b322dd36103ae4a",
    "release_evidence_commit": "bb61e68dc3028421b60c11b87ba2abd297ee6f78",
    "finalization_commit": "5adc196c0185951f50e49ab5e51586eff8d60886",
}
EXPECTED_REGISTRY_SHA256 = "08f882d0c77339e8f7ff187c35b79501e0a2958ab1ff1c7aaa1c0ef8dbee45d6"
INTAKE_SKILL = "managing-project-intake-and-work-contract"
GENERATED_VIEWS = (
    ROOT / "skills/PROJECT_SKILL_SNAPSHOT.json",
    ROOT / "skills/BASE_V9_ADAPTER.json",
    ROOT / "skills/PROJECT_BASE_SKILL_ADAPTER.json",
    ROOT / "skills/PROJECT_PATH_ADAPTER.json",
)
CURRENT_ENTRYPOINTS = (
    ROOT / "AGENTS.md",
    ROOT / "START_HERE.md",
    ROOT / "docs/OPERATING_MODEL.md",
    ROOT / "docs/WORK_MODE_AND_SKILL_ROUTING.md",
    ROOT / "docs/DOCUMENTATION_MAP.md",
)


def load_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


class BaseV944OperatingContractTests(unittest.TestCase):
    def test_adapter_pins_released_v944_reuse_first_contract(self) -> None:
        """A downgrade or an unfinalized Base pin must fail the operating contract."""
        adapter = load_json(ADAPTER_PATH)
        self.assertEqual(EXPECTED_RELEASE, adapter["base_release"])
        self.assertEqual(EXPECTED_REGISTRY_SHA256, adapter["skill_registry"]["base"]["sha256"])

        reuse = adapter["shared_overrides"][INTAKE_SKILL]["reuse_first_governance"]
        self.assertEqual(
            ["REUSE_FIRST_PREFLIGHT_REQUIRED", "REUSE_LEARNING_HANDOFF_REQUIRED"],
            reuse["required_gates"],
        )
        self.assertEqual("NOT_RUN", reuse["actual_project_execution"])
        self.assertEqual("19355b7ef065a21d0f2b685c7d9be64a4a3970f8", reuse["policy_evidence_commit"])

    def test_generated_views_follow_the_canonical_adapter_bytes(self) -> None:
        """Editing a compatibility view by hand must be observable as hash drift."""
        adapter_hash = hashlib.sha256(ADAPTER_PATH.read_bytes()).hexdigest()
        snapshot = load_json(ROOT / "skills/PROJECT_SKILL_SNAPSHOT.json")
        self.assertEqual(adapter_hash, snapshot["source_registry"]["sha256"])

        for path in GENERATED_VIEWS[1:]:
            with self.subTest(path=path.name):
                self.assertEqual(adapter_hash, load_json(path)["canonical_source_sha256"])

    def test_receipt_records_reuse_and_preserves_legacy_material(self) -> None:
        """The project must retain evidence and classify old material before any removal."""
        receipt = load_json(RECEIPT_PATH)
        self.assertEqual("L3", receipt["work_level"])
        self.assertEqual("PASS", receipt["benchmark_preflight_receipt"]["state"])
        self.assertGreaterEqual(len(receipt["benchmark_preflight_receipt"]["entries"]), 3)
        self.assertEqual(
            "REUSE_LEARNING_HANDOFF_REQUIRED",
            receipt["reuse_learning_handoff"]["gate"],
        )
        classifications = {
            item["classification"]
            for item in receipt["context_configuration_hygiene"]["inventory"]
        }
        self.assertTrue({"ACTIVE_OWNER", "COMPATIBILITY", "ARCHIVE", "UNKNOWN_UNVERIFIED"} <= classifications)

    def test_current_entrypoints_do_not_reopen_historical_authority_or_runtime_gate(self) -> None:
        """A stale entrypoint cannot demote merged runtime or restore Notion as current canon."""
        combined = "\n".join(path.read_text(encoding="utf-8") for path in CURRENT_ENTRYPOINTS)
        self.assertIn("HISTORICAL_READ_ONLY_NO_WRITE", combined)
        self.assertIn("CURRENT_PLANNING_CANON", combined)
        self.assertNotIn("runtime_implementation: NOT_AUTHORIZED", combined)
        self.assertNotIn("Notion 괴이기록국 프로젝트 홈", combined)


if __name__ == "__main__":
    unittest.main()
