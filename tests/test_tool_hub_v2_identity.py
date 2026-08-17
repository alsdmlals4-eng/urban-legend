from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ADAPTER = ROOT / "skills" / "PROJECT_BASE_ADAPTER.json"


class ToolHubV2IdentityTests(unittest.TestCase):
    def test_canonical_adapter_exposes_verified_tool_hub_project_identity(self) -> None:
        adapter = json.loads(ADAPTER.read_text(encoding="utf-8"))

        self.assertEqual(2, adapter.get("schema_version"))
        self.assertEqual("urban-legend", adapter.get("project", {}).get("project_id"))


if __name__ == "__main__":
    unittest.main()
