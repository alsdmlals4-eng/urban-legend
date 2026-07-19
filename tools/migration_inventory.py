#!/usr/bin/env python3
"""Deterministic tracked/untracked migration inventory; no files are changed."""

from __future__ import annotations

import argparse, hashlib, json, subprocess
from pathlib import Path


def run(*args: str) -> bytes:
    return subprocess.run(["git", *args], check=True, capture_output=True).stdout


def classify(path: str) -> str:
    if path.endswith(".log") or path.endswith("/server.pid"):
        return "[제거]"
    if path.startswith(("docs/archive/", ".superpowers/", "docs/superpowers/", "docs/CODEX_GOAL_")):
        return "[백업]"
    if path.startswith(("docs/gpt_tasks/", "docs/benchmarks/")):
        return "[보류]"
    if path.startswith(("docs/qa/captures/", "assets/", "tests/")):
        return "[증거]"
    if path.startswith("docs/") or path in {"README.md", "AGENTS.md", "DESIGN_INTENT.md", "PROJECT_BRIEF.md", "MVP_ROADMAP.md", "TEST_CHECKLIST.md"}:
        return "[본책 이주]"
    return "[증거]"


def headings(data: bytes) -> list[str]:
    try: text = data.decode("utf-8")
    except UnicodeDecodeError: return []
    return [line.lstrip("#").strip() for line in text.splitlines() if line.startswith(("# ", "## "))]


def row(path: str, data: bytes, source: str, state: str) -> dict:
    return {"path": path, "source": source, "git_state": state, "bytes": len(data), "sha256": hashlib.sha256(data).hexdigest(), "suffix": Path(path).suffix.lower(), "headings": headings(data), "disposition": classify(path)}


def main() -> int:
    p = argparse.ArgumentParser(); p.add_argument("--ref", required=True); p.add_argument("--output", required=True); p.add_argument("--extra-root")
    a = p.parse_args(); rows = []
    for entry in run("ls-tree", "-r", "-z", a.ref).split(b"\0"):
        if not entry: continue
        meta, raw_path = entry.split(b"\t", 1); _, kind, blob = meta.decode().split()
        if kind == "blob":
            path = raw_path.decode(); rows.append(row(path, run("cat-file", "-p", blob), f"git:{a.ref}", "TRACKED"))
    if a.extra_root:
        root = Path(a.extra_root)
        tracked = {r["path"] for r in rows}
        for file in root.rglob("*"):
            if file.is_file() and ".git" not in file.parts:
                relative = file.relative_to(root).as_posix()
                if relative not in tracked:
                    rows.append(row(relative, file.read_bytes(), str(root), "UNTRACKED_OR_DIRTY"))
    rows.sort(key=lambda item: (item["path"], item["source"]))
    output = Path(a.output); output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps({"baseline_ref": a.ref, "files": rows}, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Inventoried {len(rows)} entries: {sum(x['git_state']=='TRACKED' for x in rows)} tracked, {sum(x['git_state']!='TRACKED' for x in rows)} extra.")
    return 0


if __name__ == "__main__": raise SystemExit(main())
