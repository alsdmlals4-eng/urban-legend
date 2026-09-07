"""Current visual owners must describe every manifest-approved runtime asset."""

from __future__ import annotations

import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "ASSET_MANIFEST.yml"
CURRENT_VISUAL_OWNERS = {
    "docs/CURRENT_VISUAL_ASSET_CONSUMER_CHECKLIST.md": "twelve current approved entries",
    "docs/VISUAL_ANCHOR_SPEC.md": "12개 `PROJECT_ASSET_APPROVED` entry",
    "docs/CURRENT_VISUAL_WORK_ORDER.md": "12개 entry",
}
MASTER_GDD = ROOT / "docs/design/PROJECT_AI_PRODUCTION_SPEC.md"


class CurrentVisualAssetAuthorityTests(unittest.TestCase):
    def test_current_visual_owners_enumerate_all_manifest_assets(self) -> None:
        manifest = MANIFEST.read_text(encoding="utf-8")
        self.assertEqual(12, len(re.findall(r'^\s*- asset_id:', manifest, flags=re.MULTILINE)))

        for relative_path, current_count_label in CURRENT_VISUAL_OWNERS.items():
            text = (ROOT / relative_path).read_text(encoding="utf-8")
            self.assertIn(current_count_label, text, relative_path)
            self.assertIn("Bureau Archive main-menu background/emblem/wordmark", text, relative_path)
            self.assertIn("M04 Investigation/Recovery background", text, relative_path)
            self.assertIn("M04 B/C·D cutout", text, relative_path)

    def test_master_gdd_describes_the_merged_m04_runtime_state(self) -> None:
        text = MASTER_GDD.read_text(encoding="utf-8")
        self.assertIn("M01_M04_RUNTIME_IMPLEMENTED", text)
        self.assertIn("M04 player-authored manual workbench merged to main", text)
        self.assertNotIn("M01_M04_LOCAL_RUNTIME_IMPLEMENTED", text)
        self.assertNotIn("Active local implementation head", text)
        self.assertNotIn("M04 player-authored manual slice; not merged", text)


if __name__ == "__main__":
    unittest.main()
