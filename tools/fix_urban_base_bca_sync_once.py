from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE_SHA = "c987647d01ad2baa028a16e03d85ddfc1572a727"
BASE_BLOB = "0f749dca51423ff3ea3e6db6a712a2b5bee800a8"
OLD_BASE_SHA = "41a20584dd2ee51d917e5c9d7cab6838e1ceba7e"
OLD_BASE_BLOB = "14950c9361b3c939990560ae8cc683a936633e89"


def load_json(path: str) -> dict:
    return json.loads((ROOT / path).read_text(encoding="utf-8"))


def write_json(path: str, value: dict) -> None:
    (ROOT / path).write_text(
        json.dumps(value, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )


registry = load_json("skills/SKILL_REGISTRY.json")
registry["base"]["commit"] = BASE_SHA
registry["base"]["source_registry_blob_sha"] = BASE_BLOB
for discipline in registry.get("project_disciplines", []):
    if discipline.get("skill_id") == "urban-legend-qa":
        discipline["trigger_tags"] = [
            tag for tag in discipline.get("trigger_tags", []) if tag != "image-approval"
        ]
        for mode in (
            "visual-qa-and-approval",
            "repository-wide-audit",
            "bca-adoption-audit",
        ):
            if mode not in discipline["skill_modes"]:
                discipline["skill_modes"].append(mode)
write_json("skills/SKILL_REGISTRY.json", registry)

index = load_json("skills/BASE_SKILL_INDEX.json")
index["source"]["commit"] = BASE_SHA
index["source"]["registry_blob_sha"] = BASE_BLOB
write_json("skills/BASE_SKILL_INDEX.json", index)

coverage = load_json("skills/BASE_SKILL_COVERAGE.json")
coverage["source"]["commit"] = BASE_SHA
write_json("skills/BASE_SKILL_COVERAGE.json", coverage)

adapter = load_json("skills/PROJECT_PATH_ADAPTER.json")
adapter["base"]["commit"] = BASE_SHA
write_json("skills/PROJECT_PATH_ADAPTER.json", adapter)

version_path = ROOT / "docs/BASE_RULES_VERSION.md"
version = version_path.read_text(encoding="utf-8")
version = version.replace(OLD_BASE_BLOB, BASE_BLOB)
version = version.replace("Base Registry 25개 @ 41a20584...", "Base Registry 코어 25개 + shared extension 2개 @ c987647d...")
version = version.replace("| 확인일 | 2026-07-25 |", "| 확인일 | 2026-07-29 |")
version_path.write_text(version, encoding="utf-8")

test_path = ROOT / "tests/test_base_operating_sync.py"
test_text = test_path.read_text(encoding="utf-8")
test_text = test_text.replace(f'BASE_COMMIT = "{OLD_BASE_SHA}"', f'BASE_COMMIT = "{BASE_SHA}"')
test_text = test_text.replace(f'BASE_REGISTRY_BLOB = "{OLD_BASE_BLOB}"', f'BASE_REGISTRY_BLOB = "{BASE_BLOB}"')
test_path.write_text(test_text, encoding="utf-8")

qa_path = ROOT / "skills/disciplines/urban-legend-qa/SKILL.md"
qa = qa_path.read_text(encoding="utf-8")
old_modes = "`plan → execute → defect-triage → release-gate`"
new_modes = "`plan → execute → defect-triage → visual-qa-and-approval → repository-wide-audit → bca-adoption-audit → release-gate`"
qa = qa.replace(old_modes, new_modes)
qa_path.write_text(qa, encoding="utf-8")
