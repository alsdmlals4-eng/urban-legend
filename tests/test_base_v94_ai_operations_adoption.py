from __future__ import annotations

import hashlib
import json
import subprocess
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CANONICAL_ADAPTER = ROOT / "skills/PROJECT_BASE_ADAPTER.json"
CANONICAL_ADAPTER_REPO_PATH = "skills/PROJECT_BASE_ADAPTER.json"
GENERATED_VIEWS = (
    ROOT / "skills/BASE_V9_ADAPTER.json",
    ROOT / "skills/PROJECT_BASE_SKILL_ADAPTER.json",
)
EXPECTED_BASE_RELEASE = {
    "repository": "alsdmlals4-eng/Base",
    "version": "9.4.4",
    "release_commit": "210ec78292fa12ed7563ba743b322dd36103ae4a",
    "release_evidence_commit": "bb61e68dc3028421b60c11b87ba2abd297ee6f78",
    "finalization_commit": "5adc196c0185951f50e49ab5e51586eff8d60886",
}


def _load_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def _git_blob_bytes(repo_path: str) -> bytes:
    return (ROOT / repo_path).read_bytes()


class TestBaseV94Urban(unittest.TestCase):
    def test_identity_routes_and_protection(self) -> None:
        adapter = _load_json(CANONICAL_ADAPTER)
        snapshot = _load_json(ROOT / "skills/PROJECT_SKILL_SNAPSHOT.json")

        self.assertEqual(EXPECTED_BASE_RELEASE, adapter["base_release"])
        self.assertEqual(
            "08f882d0c77339e8f7ff187c35b79501e0a2958ab1ff1c7aaa1c0ef8dbee45d6",
            adapter["skill_registry"]["base"]["sha256"],
        )
        self.assertIn(
            "optimizing-ai-model-and-prompt-costs",
            {route["route_id"] for route in adapter["routing"]["base_routes"]},
        )
        self.assertEqual(10, len(adapter["routing"]["project_routes"]))
        self.assertEqual(
            "BASE_SHARED",
            snapshot["effective_routes"]["optimizing-ai-model-and-prompt-costs"]["source"],
        )
        self.assertEqual(
            ["data/", "scripts/", "scenes/", "assets/", "addons/", "project.godot"],
            adapter["protected_paths"],
        )

    def test_generated_views_follow_canonical_release(self) -> None:
        adapter = _load_json(CANONICAL_ADAPTER)
        canonical_hash = hashlib.sha256(
            _git_blob_bytes(CANONICAL_ADAPTER_REPO_PATH)
        ).hexdigest()
        snapshot = _load_json(ROOT / "skills/PROJECT_SKILL_SNAPSHOT.json")
        self.assertEqual(canonical_hash, snapshot["source_registry"]["sha256"])

        for path in GENERATED_VIEWS:
            view = _load_json(path)
            self.assertEqual(canonical_hash, view["canonical_source_sha256"], path.name)
            self.assertEqual(adapter["base_release"], view["base_release"], path.name)

        path_adapter = _load_json(ROOT / "skills/PROJECT_PATH_ADAPTER.json")
        self.assertEqual(
            "c987647d01ad2baa028a16e03d85ddfc1572a727",
            path_adapter["base"]["commit"],
        )
        self.assertEqual(adapter["base_release"], path_adapter["base_release"])
        self.assertEqual(canonical_hash, path_adapter["canonical_source_sha256"])

    def test_contracts(self) -> None:
        ai = (ROOT / "docs/AI_WORKFLOW.md").read_text(encoding="utf-8")
        ux = (ROOT / "docs/UX_UI_SYSTEM.md").read_text(encoding="utf-8")
        audit = (ROOT / "docs/reviews/2026-08-01_BASE_V9_4_ADOPTION_AUDIT.md").read_text(
            encoding="utf-8"
        )
        for marker in (
            "[모델 추천]",
            "HARD_CONSTRAINT",
            "Interface-first",
            "Example-as-Fixture",
            "refresh_trigger",
            "복선",
            "NOT_RUN",
        ):
            self.assertIn(marker, ai)
        for marker in (
            "입력 접수",
            "처리 중",
            "중단",
            "즉시 완료",
            "빠른 반복",
            "재진입",
            "Reduced Motion",
            "mute",
            "haptic-off",
            "권위 시점",
        ):
            self.assertIn(marker, ux)
        self.assertIn("product_paths_changed: false", audit)
        self.assertIn("HUMAN_NOT_RUN", audit)


if __name__ == "__main__":
    unittest.main()
