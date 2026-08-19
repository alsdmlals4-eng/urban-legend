from __future__ import annotations

import json
import pathlib
import sys
import tempfile
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]
TOOL_DIR = ROOT / "tools" / "reuse"
sys.path.insert(0, str(TOOL_DIR))


class P0SchemaReuseTests(unittest.TestCase):
    def _validator(self):
        import data_schema_crossref_validator  # type: ignore
        return data_schema_crossref_validator

    def test_shared_validator_detects_duplicate_required_enum_and_reference_failures(self) -> None:
        validator = self._validator()
        with tempfile.TemporaryDirectory() as directory:
            root = pathlib.Path(directory)
            (root / "records.json").write_text(
                json.dumps([
                    {"id": "A", "kind": "field", "target_id": "MISSING"},
                    {"id": "A", "kind": "invalid", "target_id": "MISSING"},
                    {"id": "B", "kind": "office"},
                ]),
                encoding="utf-8",
            )
            manifest = {
                "files": [{
                    "path": "records.json",
                    "records": "$",
                    "id_field": "id",
                    "required_fields": ["id", "kind", "target_id"],
                    "enum_fields": {"kind": ["field", "office"]},
                }],
                "references": [{
                    "source_file": "records.json",
                    "field": "target_id",
                    "target_file": "records.json",
                    "target_id_field": "id",
                    "allow_null": True,
                }],
            }
            report = validator.validate_manifest(root, manifest)
            codes = {item["code"] for item in report["violations"]}
            self.assertTrue({"DUPLICATE_ID", "MISSING_REQUIRED_FIELD", "INVALID_ENUM", "DANGLING_REFERENCE"}.issubset(codes))
            self.assertFalse(report["ok"])

    def test_urban_agents_manifest_is_read_only_and_current_data_passes(self) -> None:
        validator = self._validator()
        manifest_path = ROOT / "tools" / "reuse" / "urban_schema_manifest.json"
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
        serialized = json.dumps(manifest, ensure_ascii=False)
        self.assertNotIn("data/episodes/", serialized)
        report = validator.validate_manifest(ROOT, manifest)
        self.assertTrue(report["ok"], report["violations"])
        self.assertGreaterEqual(report["checked_records"], 2)


if __name__ == "__main__":
    unittest.main()
