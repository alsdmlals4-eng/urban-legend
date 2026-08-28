from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SHEET_ID = "14xtlvd90iQTKjDLcZR_b-WS5fHnBwNf-OfBruPBS6ck"


def load(path: str) -> dict:
    return json.loads((ROOT / path).read_text(encoding="utf-8"))


class WorkspaceAuthorityContractTests(unittest.TestCase):
    def test_active_authority_is_repository_with_historical_notion(self) -> None:
        registry = load("skills/SKILL_REGISTRY.json")
        self.assertEqual("REPOSITORY", registry["workspace_authority"]["human_facing"])
        self.assertEqual("REPOSITORY", registry["workspace_authority"]["structured_implementation"])
        self.assertEqual("HISTORICAL_READ_ONLY_NO_WRITE", registry["workspace_authority"]["historical_notion"])
        self.assertTrue((ROOT / registry["workspace_authority"]["structured_planning_canon"]).is_file())

    def test_sheet_inventory_is_retained_only_for_migration(self) -> None:
        registry = load("skills/SKILL_REGISTRY.json")
        legacy = registry["legacy_bca_visual_sheet"]
        self.assertEqual(SHEET_ID, legacy["spreadsheet_id"])
        self.assertEqual("MIGRATION_ONLY", legacy["role"])
        self.assertEqual("DO_NOT_USE_FOR_NEW_WORK", legacy["new_work_policy"])
        self.assertIn("51_미니게임", legacy["required_tabs"])
        self.assertIn("52_글쓰기_서사", legacy["required_tabs"])

        workbook = (ROOT / "docs/PROJECT_GOOGLE_SHEET_WORKBOOK.md").read_text(encoding="utf-8")
        self.assertIn("MIGRATION_ONLY", workbook)
        self.assertIn("DO_NOT_USE_FOR_NEW_WORK", workbook)
        self.assertIn(SHEET_ID, workbook)


if __name__ == "__main__":
    unittest.main()
