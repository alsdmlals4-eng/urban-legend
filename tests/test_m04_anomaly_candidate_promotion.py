"""M04 B/C product promotion keeps the approved candidate bytes at the live cutout path."""

from __future__ import annotations

import hashlib
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CANDIDATE = ROOT / "docs/visual/candidates/M04_ANOMALY_BC_ADAPT_01_20260827.png"
CANONICAL = ROOT / "assets/anomalies/cutouts/red_umbrella_b_cutout.png"


def _sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def test_m04_bc_live_cutout_matches_approved_candidate_bytes() -> None:
    assert CANDIDATE.is_file()
    assert CANONICAL.is_file()
    assert _sha256(CANONICAL) == _sha256(CANDIDATE)
