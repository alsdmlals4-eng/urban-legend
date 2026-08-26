from __future__ import annotations

import hashlib
import json
from pathlib import Path
import re
import unittest
from urllib.parse import parse_qs, urlparse


ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / "docs" / "APPROVED_VISUAL_ANCHORS.json"
SOURCE_PATH = "assets/source/mvp043_character_v1/kwon_narae.png"
SOURCE = ROOT / SOURCE_PATH
EXPECTED_PROJECT_ID = "urban-legend"
EXPECTED_FIGMA_FILE_KEY = "Z7J3eLeavEytKN20H4HfoP"


class ApprovedVisualAnchorRegistryTests(unittest.TestCase):
    def test_kwon_narae_source_card_is_the_pinned_project_owned_anchor(self) -> None:
        self.assertTrue(SOURCE.is_file(), SOURCE_PATH)
        source_sha256 = hashlib.sha256(SOURCE.read_bytes()).hexdigest()
        self.assertTrue(
            REGISTRY.is_file(),
            f"missing docs/APPROVED_VISUAL_ANCHORS.json; source_sha256={source_sha256}",
        )

        document = json.loads(REGISTRY.read_text(encoding="utf-8"))
        self.assertEqual(document.get("version"), 1)
        entries = document.get("entries")
        self.assertIsInstance(entries, list)

        matches = [
            entry
            for entry in entries
            if entry.get("project_id") == EXPECTED_PROJECT_ID
            and entry.get("source_path") == SOURCE_PATH
        ]
        self.assertEqual(len(matches), 1)
        entry = matches[0]

        self.assertEqual(entry.get("approval_state"), "APPROVED")
        self.assertEqual(entry.get("source_sha256"), source_sha256)
        self.assertRegex(entry.get("source_sha256", ""), r"^[0-9a-f]{64}$")

        figma_url = entry.get("figma_node_url")
        self.assertIsInstance(figma_url, str)
        parsed = urlparse(figma_url)
        self.assertEqual(parsed.scheme, "https")
        self.assertIn(parsed.netloc, {"figma.com", "www.figma.com"})
        self.assertIn(f"/design/{EXPECTED_FIGMA_FILE_KEY}/", parsed.path)
        node_values = parse_qs(parsed.query).get("node-id", [])
        self.assertEqual(len(node_values), 1)
        self.assertRegex(node_values[0], r"^\d+[-:]\d+$")

        evidence = entry.get("evidence")
        self.assertIsInstance(evidence, dict)
        self.assertEqual(evidence.get("kind"), "FIGMA_CONNECTOR")
        self.assertIsInstance(evidence.get("ref"), str)
        self.assertTrue(evidence.get("ref"))
        self.assertRegex(
            evidence.get("checked_at", ""),
            r"^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$",
        )

    def test_anchor_approval_does_not_grant_unrelated_product_asset_approval(self) -> None:
        manifest = (ROOT / "ASSET_MANIFEST.yml").read_text(encoding="utf-8")
        self.assertNotIn("kwon_narae.png", manifest)
        self.assertNotIn("현재 PROJECT_ASSET_APPROVED 자산은 0건", manifest)
        self.assertIn('asset_id: "M01-RECOVERY-BACKGROUND-001"', manifest)
        self.assertIn(
            'source_path: "docs/visual/candidates/M01_RECOVERY_BACKGROUND_ADAPT_01.png"',
            manifest,
        )
        self.assertIn('asset_id: "M01-ANOMALY-BC-001"', manifest)
        self.assertIn(
            'source_path: "docs/visual/candidates/M01_ANOMALY_BC_ADAPT_01.png"',
            manifest,
        )
        self.assertIn('asset_id: "M01-ANOMALY-D-001"', manifest)
        self.assertIn('source_path: "docs/visual/candidates/M01_ANOMALY_D_ADAPT_01.png"', manifest)
        self.assertIn('asset_id: "M04-INVESTIGATION-BACKGROUND-001"', manifest)
        self.assertIn(
            'source_path: "docs/visual/candidates/M04_INVESTIGATION_BACKGROUND_ADAPT_01.png"',
            manifest,
        )
        self.assertIn('replacement_requires_approval: true', manifest)


if __name__ == "__main__":
    unittest.main()
