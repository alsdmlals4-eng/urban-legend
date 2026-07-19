#!/usr/bin/env python3
"""Require an explicit confirmation record before executable prompts are used."""
from __future__ import annotations

import argparse
import json
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--registry", default="[기획서]/00_프로젝트_허브/INTERVIEW_REGISTRY.json")
    args = parser.parse_args()
    root = Path.cwd()
    path = root / args.registry
    data = json.loads(path.read_text(encoding="utf-8"))
    errors = []
    for item in data.get("interviews", []):
        if item.get("status") != "CONFIRMED":
            continue
        for field in ("record_path", "executable_prompt_path", "confirmation_evidence"):
            if not item.get(field):
                errors.append(f"{item.get('interview_id', '<unknown>')}: {field} is required")
        for field in ("record_path", "executable_prompt_path"):
            if item.get(field) and not (path.parent / item[field]).is_file():
                errors.append(f"{item['interview_id']}: missing {field}")
    if errors:
        print("Interview contract failed:\n- " + "\n- ".join(errors))
        return 1
    print("Interview contract passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
