#!/usr/bin/env python3
"""Repair Markdown links after semantic document moves using the recorded move map."""
from __future__ import annotations

import csv
import os
import re
from pathlib import Path

ROOT = Path.cwd()
MAP = ROOT / "[기획서]" / "00_프로젝트_허브" / "LEGACY_DOCUMENT_MOVE_MAP.tsv"
EXCLUDED = {"[백업]", "[보류]"}
LINK = re.compile(r"(?<!!)(\[[^]]*\]\()([^)#]+)(#[^)]+)?(\))")

def norm(value: str) -> str:
    return Path(os.path.normpath(value)).as_posix().lstrip("./")

def main() -> int:
    rows = list(csv.DictReader(MAP.read_text(encoding="utf-8").splitlines(), delimiter="\t"))
    moves = {norm(row["source"]): norm(row["target"]) for row in rows}
    target_to_source = {target: source for source, target in moves.items()}
    changed = 0
    for path in ROOT.rglob("*.md"):
        relative = path.relative_to(ROOT).as_posix()
        if ".git" in path.parts or any(part in EXCLUDED for part in path.parts):
            continue
        original_parent = Path(target_to_source.get(relative, relative)).parent
        text = path.read_text(encoding="utf-8")
        def replace(match: re.Match[str]) -> str:
            target = match.group(2).strip()
            if target.startswith(("http://", "https://", "mailto:", "#")) or "://" in target:
                return match.group(0)
            candidate = norm(target) if target.startswith("docs/") else norm(str(original_parent / target))
            destination = moves.get(candidate)
            if not destination:
                return match.group(0)
            new_target = Path(os.path.relpath(ROOT / destination, path.parent)).as_posix()
            return match.group(1) + new_target + (match.group(3) or "") + match.group(4)
        rewritten = LINK.sub(replace, text)
        if rewritten != text:
            path.write_text(rewritten, encoding="utf-8")
            changed += 1
    print(f"Rewrote links in {changed} active Markdown file(s).")

if __name__ == "__main__":
    main()
