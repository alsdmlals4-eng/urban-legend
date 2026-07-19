#!/usr/bin/env python3
"""Report Urban Legend publication prerequisites without generating artifacts."""

from __future__ import annotations

import argparse
import json
import os
import platform
import shutil
import subprocess
import sys
from pathlib import Path

import publication_v3 as publication


def probe(command: str | None, arguments: list[str]) -> tuple[str | None, str | None]:
    if not command:
        return None, "not found"
    try:
        invocation = [command, *arguments]
        if Path(command).suffix.lower() in {".cmd", ".bat"}:
            invocation = [os.environ.get("COMSPEC", "cmd.exe"), "/d", "/c", command, *arguments]
        result = subprocess.run(
            invocation,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
            timeout=30,
            check=False,
        )
    except subprocess.TimeoutExpired:
        return None, "timed out after 30 seconds"
    lines = (result.stdout or result.stderr).strip().splitlines()
    if result.returncode:
        return None, lines[0] if lines else f"exit={result.returncode}"
    return lines[0] if lines else "available", None


def libreoffice_probe_command(command: str | None) -> str | None:
    if not command:
        return None
    console = Path(command).with_name("soffice.com")
    return str(console) if console.is_file() else command


def poppler_probe_command(command: str | None) -> str | None:
    if not command or Path(command).suffix.lower() != ".cmd":
        return command
    for parent in Path(command).parents:
        candidate = parent / "native" / "poppler" / "Library" / "bin" / "pdftoppm.exe"
        if candidate.is_file():
            return str(candidate)
    return command


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", default=".", help="Directory that must be writable for publication.")
    parser.add_argument("--require-mermaid", action="store_true")
    args = parser.parse_args()
    root = Path.cwd()
    regular, bold = publication.font_paths()
    tools = {
        "python": sys.executable,
        "libreoffice": publication.libreoffice_path(),
        "pdftoppm": publication.pdftoppm_path(),
        "mermaid_cli": publication.mermaid_cli_path(root),
        "chrome": publication.chrome_path(),
        "node": shutil.which("node"),
        "pnpm": shutil.which("pnpm") or shutil.which("pnpm.cmd"),
        "font_regular": regular,
        "font_bold": bold,
    }
    probes = {
        "libreoffice": probe(libreoffice_probe_command(tools["libreoffice"]), ["--version"]),
        "pdftoppm": probe(poppler_probe_command(tools["pdftoppm"]), ["-v"]),
        "mermaid_cli": probe(tools["mermaid_cli"], ["--version"]),
        "node": probe(tools["node"], ["--version"]),
        "pnpm": probe(tools["pnpm"], ["--version"]),
    }
    output = Path(args.output).resolve()
    required = ["libreoffice", "pdftoppm", "font_regular"]
    if args.require_mermaid:
        required.extend(["mermaid_cli", "chrome", "node", "pnpm"])
    missing = [name for name in required if not tools[name] or (name in probes and probes[name][1])]
    report = {
        "project": "Urban Legend",
        "platform": platform.platform(),
        "tools": tools,
        "versions": {name: value for name, (value, _) in probes.items()},
        "probe_failures": {name: error for name, (_, error) in probes.items() if error},
        "output_path": str(output),
        "output_writable": os.access(output if output.exists() else output.parent, os.W_OK),
        "missing": sorted(set(missing)),
        "recovery": {
            "node": "pnpm install --frozen-lockfile",
            "overrides": [
                "BASE_LIBREOFFICE", "BASE_PDFTOPPM", "BASE_MERMAID_CLI",
                "BASE_FONT_REGULAR", "BASE_FONT_BOLD", "PUPPETEER_EXECUTABLE_PATH",
            ],
        },
    }
    print(json.dumps(report, ensure_ascii=False, indent=2))
    return 0 if not report["missing"] and report["output_writable"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
