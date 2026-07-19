"""Regression coverage for approved migration preservation exceptions."""

from __future__ import annotations

import subprocess
import sys
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class MigrationPreservationContractTests(unittest.TestCase):
    def test_approved_test_route_updates_do_not_break_preservation_audit(self) -> None:
        result = subprocess.run(
            [
                sys.executable,
                "tools/verify_migration_inventory.py",
                "--before",
                "docs/MIGRATION_INVENTORY_BEFORE.json",
                "--after",
                "docs/MIGRATION_INVENTORY_AFTER.json",
            ],
            cwd=ROOT,
            check=False,
            capture_output=True,
            text=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)


if __name__ == "__main__":
    unittest.main()
