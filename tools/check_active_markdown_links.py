#!/usr/bin/env python3
"""Validate all local links in active Markdown; historical hold/backup trees are excluded."""
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path.cwd().resolve()
EXCLUDED = {".git", "[백업]", "[보류]"}
LINK = re.compile(r"(?<!!)\[[^]]*\]\(([^)#]+)(?:#[^)]+)?\)")

def main() -> int:
    failures: list[str] = []
    for source in ROOT.rglob("*.md"):
        if any(part in EXCLUDED for part in source.parts):
            continue
        for value in LINK.findall(source.read_text(encoding="utf-8")):
            target = value.strip().strip("<>")
            if not target or target.startswith(("http://", "https://", "mailto:", "#")):
                continue
            resolved = (source.parent / target).resolve()
            if not resolved.exists() or (resolved != ROOT and ROOT not in resolved.parents):
                failures.append(f"{source.relative_to(ROOT)} -> {target}")
    if failures:
        print("Broken active Markdown links:\n" + "\n".join(failures))
        return 1
    print("Active Markdown links: PASS")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
