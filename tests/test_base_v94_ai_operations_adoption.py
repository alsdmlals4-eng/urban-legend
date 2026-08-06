from __future__ import annotations

import hashlib
import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CANONICAL_ADAPTER = ROOT / "skills/PROJECT_BASE_ADAPTER.json"
GENERATED_VIEWS = (
    ROOT / "skills/BASE_V9_ADAPTER.json",
    ROOT / "skills/PROJECT_BASE_SKILL_ADAPTER.json",
)
EXPECTED_BASE_RELEASE = {
    "repository": "alsdmlals4-eng/Base",
    "version": "9.4.3",
    "release_commit": "7dd1a4f80388bc5faca767ff74a3eb32dc9d0ac8",
    "release_evidence_commit": "da33a350d61b8adc52df97fccc7001708a933370",
    "finalization_commit": "0b7c94f38d959efc0fc9442274c60b2e268a3c97",
}


def _load_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


class TestBaseV94Urban(unittest.TestCase):
    def test_identity_routes_and_protection(self) -> None:
        adapter = _load_json(CANONICAL_ADAPTER)
        snapshot = _load_json(ROOT / "skills/PROJECT_SKILL_SNAPSHOT.json")

        self.assertEqual(EXPECTED_BASE_RELEASE, adapter["base_release"])
        self.assertEqual(
            "693a0dff3f054ecdd653079909e044211473838e73dd9aff07734d1ce5694c59",
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
        canonical_hash = hashlib.sha256(CANONICAL_ADAPTER.read_bytes()).hexdigest()
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
