#!/usr/bin/env python3
"""Validate registered active documents and their existing publication artifacts."""
from __future__ import annotations

import argparse
import json
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--registry", default="[기획서]/00_프로젝트_허브/DESIGN_DOCUMENT_REGISTRY.json")
    parser.add_argument("--config", default=".github/documentation-governance.json")
    args = parser.parse_args()
    root = Path.cwd()
    registry_path = root / args.registry
    registry = json.loads(registry_path.read_text(encoding="utf-8"))
    base = registry_path.parent
    errors = []
    for entry in registry.get("documents", []):
        if entry.get("status") != "ACTIVE":
            continue
        for key in ("source_path", "output_pdf", "publication_manifest"):
            if not (base / entry[key]).resolve().is_file():
                errors.append(f"{entry['document_id']}: missing {key}")
    if errors:
        print("Design document publication governance failed:\n- " + "\n- ".join(errors))
        return 1
    print("Design document publication governance passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
