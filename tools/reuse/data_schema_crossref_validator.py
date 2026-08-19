from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any


def _select_records(document: Any, selector: str) -> list[Any]:
    if selector in ("", "$"):
        value = document
    else:
        if not selector.startswith("$."):
            raise ValueError(f"unsupported records selector: {selector}")
        value = document
        for part in selector[2:].split("."):
            if not isinstance(value, dict) or part not in value:
                return []
            value = value[part]
    if isinstance(value, list):
        return value
    if isinstance(value, dict):
        return list(value.values())
    return []


def _violation(path: str, record: str, field: str, code: str, message: str) -> dict[str, Any]:
    return {"path": path, "record": record, "field": field, "code": code, "message": message}


def validate_manifest(root: Path, manifest: dict[str, Any]) -> dict[str, Any]:
    root = Path(root)
    violations: list[dict[str, Any]] = []
    loaded: dict[str, dict[str, Any]] = {}
    file_specs = manifest.get("files", [])
    for spec in file_specs:
        rel_path = str(spec["path"])
        try:
            document = json.loads((root / rel_path).read_text(encoding="utf-8"))
        except FileNotFoundError:
            violations.append(_violation(rel_path, "$", "", "FILE_NOT_FOUND", "configured data file does not exist"))
            loaded[rel_path] = {"records": [], "spec": spec}
            continue
        except json.JSONDecodeError as exc:
            violations.append(_violation(rel_path, "$", "", "INVALID_JSON", f"invalid JSON at line {exc.lineno} column {exc.colno}"))
            loaded[rel_path] = {"records": [], "spec": spec}
            continue
        records = _select_records(document, str(spec.get("records", "$")))
        loaded[rel_path] = {"records": records, "spec": spec}
        seen: dict[Any, int] = {}
        for index, record in enumerate(records):
            locator = f"$[{index}]"
            if not isinstance(record, dict):
                violations.append(_violation(rel_path, locator, "", "RECORD_NOT_OBJECT", "record must be a JSON object"))
                continue
            for field in spec.get("required_fields", []):
                if field not in record:
                    violations.append(_violation(rel_path, locator, str(field), "MISSING_REQUIRED_FIELD", "required field is missing"))
            for field, allowed in spec.get("enum_fields", {}).items():
                if field in record and record[field] not in allowed:
                    violations.append(_violation(rel_path, locator, str(field), "INVALID_ENUM", f"value {record[field]!r} is not in the allowed enum"))
            id_field = spec.get("id_field")
            if id_field and id_field in record:
                value = record[id_field]
                if value in seen:
                    violations.append(_violation(rel_path, locator, str(id_field), "DUPLICATE_ID", f"duplicate id {value!r}; first seen at index {seen[value]}"))
                else:
                    seen[value] = index
    target_ids: dict[tuple[str, str], set[Any]] = {}
    for rel_path, payload in loaded.items():
        fields = {str(payload["spec"].get("id_field", "id"))}
        for ref in manifest.get("references", []):
            if str(ref.get("target_file")) == rel_path:
                fields.add(str(ref.get("target_id_field", "id")))
        for field in fields:
            target_ids[(rel_path, field)] = {r[field] for r in payload["records"] if isinstance(r, dict) and field in r}
    for ref in manifest.get("references", []):
        source_file = str(ref["source_file"]); field = str(ref["field"]); target_file = str(ref["target_file"]); target_field = str(ref.get("target_id_field", "id")); allow_null = bool(ref.get("allow_null", False)); targets = target_ids.get((target_file, target_field), set())
        for index, record in enumerate(loaded.get(source_file, {}).get("records", [])):
            if not isinstance(record, dict) or field not in record:
                continue
            value = record[field]
            values = value if isinstance(value, list) else [value]
            for candidate in values:
                if candidate is None and allow_null:
                    continue
                if candidate not in targets:
                    violations.append(_violation(source_file, f"$[{index}]", field, "DANGLING_REFERENCE", f"reference {candidate!r} not found in {target_file}.{target_field}"))
    violations.sort(key=lambda x: (str(x["path"]), str(x["record"]), str(x["field"]), str(x["code"]), str(x["message"])))
    return {"ok": not violations, "checked_files": len(file_specs), "checked_records": sum(len(p["records"]) for p in loaded.values()), "violations": violations}


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("manifest", type=Path)
    parser.add_argument("--root", type=Path, default=None)
    args = parser.parse_args(argv)
    manifest = json.loads(args.manifest.read_text(encoding="utf-8"))
    report = validate_manifest(args.root or Path.cwd(), manifest)
    print(json.dumps(report, ensure_ascii=False, indent=2, sort_keys=True))
    return 0 if report["ok"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
