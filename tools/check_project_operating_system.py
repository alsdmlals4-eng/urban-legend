#!/usr/bin/env python3
"""Check Urban Legend's mandatory 11-discipline operating-system contract."""
from __future__ import annotations

import json
from pathlib import Path

from jsonschema import Draft202012Validator

ROOT = Path.cwd()
HUB = ROOT / "[기획서]" / "00_프로젝트_허브"
REQUIRED = ["책임 범위", "현재 상태", "현재 결정과 제약", "다음 작업", "검증 경로"]

def load(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))

def validate(data: dict, schema: Path, label: str) -> list[str]:
    return [f"{label}: {error.message}" for error in Draft202012Validator(load(schema)).iter_errors(data)]

def main() -> int:
    design = load(HUB / "DESIGN_DOCUMENT_REGISTRY.json")
    skills = load(HUB / "SKILL_REGISTRY.json")
    failures = validate(design, ROOT / "schemas" / "design-document-registry-v3.schema.json", "design registry")
    failures += validate(skills, ROOT / "schemas" / "skill-registry-v3.schema.json", "skill registry")
    if len(design.get("documents", [])) != 12: failures.append("exactly 12 published responsibility documents (hub + 11 disciplines) are required")
    if len(skills.get("skills", [])) != 11 or len(skills.get("discipline_entrypoints", {})) != 11: failures.append("exactly 11 discipline skills and entrypoints are required")
    for entry in design.get("documents", []):
        source = (HUB / entry["source_path"]).resolve()
        pdf = (HUB / entry["output_pdf"]).resolve()
        manifest = (HUB / entry["publication_manifest"]).resolve()
        if not source.exists() or not pdf.exists() or not manifest.exists(): failures.append(f"publication missing: {entry['document_id']}")
        elif entry["discipline"] != "프로젝트 전체":
            text = source.read_text(encoding="utf-8")
            for heading in REQUIRED:
                if f"## {heading}" not in text: failures.append(f"{entry['document_id']} lacks section {heading}")
    for entry in skills.get("skills", []):
        path = ROOT / entry["path"]
        if not path.exists(): failures.append(f"skill file missing: {entry['skill_id']}")
    for filename in ("ASSET_REGISTRY.json", "MIGRATION_PRESERVATION_LEDGER.md", "BASE_RULES_VERSION.md", "PROJECT_SKILL_MAP.pdf", "SKILL_MAP_PUBLICATION_MANIFEST.json"):
        if not (HUB / filename).exists(): failures.append(f"hub artifact missing: {filename}")
    if failures:
        print("Operating-system contract failed:\n" + "\n".join(failures))
        return 1
    print("Urban Legend operating-system contract: PASS (12 documents, 11 skills, 3 registries)")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
