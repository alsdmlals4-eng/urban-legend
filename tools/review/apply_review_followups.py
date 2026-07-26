from pathlib import Path

root = Path(__file__).resolve().parents[2]


def patch(path: str, old: str, new: str) -> None:
    target = root / path
    text = target.read_text(encoding="utf-8")
    if old not in text:
        raise RuntimeError(f"missing text in {path}: {old}")
    target.write_text(text.replace(old, new), encoding="utf-8")


patch(
    "docs/CURRENT_STATUS.md",
    "- 독립 격리 경로 `data/scripts/scenes/poc/annual_mvp_002`",
    "- 독립 격리 경로 `data/poc/annual_mvp_002`, `scripts/poc/annual_mvp_002`, `scenes/poc/annual_mvp_002`",
)
patch(
    "docs/DECISION_LOG.md",
    "`docs/qa/ANNUAL_MVP_002_AUTOMATED_QA_2026-07-26.md`",
    "ANNUAL-MVP-002 자동 QA 기록",
)
print("review follow-up document references fixed")
