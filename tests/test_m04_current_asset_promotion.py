"""M04 recovery asset promotions retain the approved candidate bytes and contracts."""

from __future__ import annotations

import hashlib
import struct
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "ASSET_MANIFEST.yml"
RECOVERY_CANDIDATE = ROOT / "docs/visual/candidates/M04_RECOVERY_BACKGROUND_ADAPT_02_20260828.png"
RECOVERY_CANONICAL = ROOT / "assets/backgrounds/red_recovery.png"
D_CANDIDATE = ROOT / "docs/visual/candidates/M04_ANOMALY_D_ADAPT_01.png"
D_CANONICAL = ROOT / "assets/anomalies/cutouts/red_umbrella_d_cutout.png"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def png_color_type(path: Path) -> int:
    data = path.read_bytes()
    assert data[:8] == b"\x89PNG\r\n\x1a\n"
    assert data[12:16] == b"IHDR"
    _width, _height, _depth, color_type, _compression, _filter, _interlace = struct.unpack(
        ">IIBBBBB", data[16:29]
    )
    return color_type


class M04CurrentAssetPromotionTests(unittest.TestCase):
    def test_recovery_background_live_bytes_match_approved_candidate(self) -> None:
        self.assertEqual(sha256(RECOVERY_CANDIDATE), sha256(RECOVERY_CANONICAL))

    def test_d_cutout_live_bytes_match_approved_rgba_candidate(self) -> None:
        self.assertEqual(sha256(D_CANDIDATE), sha256(D_CANONICAL))
        self.assertEqual(6, png_color_type(D_CANONICAL), "D cutout must remain RGBA")

    def test_root_manifest_records_both_live_m04_consumers(self) -> None:
        text = MANIFEST.read_text(encoding="utf-8")
        for token in (
            'asset_id: "M04-RECOVERY-BACKGROUND-001"',
            'canonical_path: "assets/backgrounds/red_recovery.png"',
            'asset_id: "M04-ANOMALY-D-001"',
            'canonical_path: "assets/anomalies/cutouts/red_umbrella_d_cutout.png"',
            "M04_RECOVERY_BACKGROUND_ADAPT_02_20260828",
            "M04_ANOMALY_D_ADAPT_01",
        ):
            self.assertIn(token, text)


if __name__ == "__main__":
    unittest.main()
