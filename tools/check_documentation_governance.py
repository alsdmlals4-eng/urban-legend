#!/usr/bin/env python3
"""Validate Urban Legend's active operating-system entrypoints."""
from __future__ import annotations

import argparse
import json
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", default=".github/documentation-governance.json")
    args = parser.parse_args()
    root = Path.cwd()
    config = json.loads((root / args.config).read_text(encoding="utf-8"))
    missing = [path for path in config["required_paths"] if not (root / path).exists()]
    if missing:
        print("Documentation governance failed:\n- " + "\n- ".join(missing))
        return 1
    print("Documentation governance passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
