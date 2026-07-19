#!/usr/bin/env python3
"""Validate active Urban Legend discipline and foundation skill routes."""
from __future__ import annotations

import argparse
import json
from pathlib import Path


HUB = Path("[기획서]") / "00_프로젝트_허브"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", default=".github/documentation-governance.json")
    args = parser.parse_args()
    root = Path.cwd()
    config = json.loads((root / args.config).read_text(encoding="utf-8"))
    registry = json.loads((root / HUB / "SKILL_REGISTRY.json").read_text(encoding="utf-8"))
    active = {item["skill_id"]: item for item in registry["skills"] if item.get("status") == "ACTIVE"}
    errors = []
    for skill_id in config["required_foundation_skills"]:
        item = active.get(skill_id)
        if not item or item.get("layer") != "foundation":
            errors.append(f"missing active foundation skill: {skill_id}")
        elif not (root / item["path"]).is_file():
            errors.append(f"missing skill file: {item['path']}")
    if len(registry.get("discipline_entrypoints", {})) != 11:
        errors.append("Urban Legend requires 11 discipline entrypoint groups")
    for item in active.values():
        if not (root / item["path"]).is_file():
            errors.append(f"registered skill missing: {item['path']}")
    if errors:
        print("Skill routing governance failed:\n- " + "\n- ".join(errors))
        return 1
    print("Skill routing governance passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
