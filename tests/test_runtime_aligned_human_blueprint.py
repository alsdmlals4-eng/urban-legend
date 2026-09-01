from __future__ import annotations

import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
BLUEPRINT = ROOT / "docs/design/URBAN_LEGEND_HUMAN_GAME_BLUEPRINT_20260830.md"
BENCHMARK = ROOT / "docs/research/2026-09-01-runtime-aligned-blueprint-benchmark.md"
VISUAL_ORDER = ROOT / "docs/CURRENT_VISUAL_WORK_ORDER.md"


class RuntimeAlignedHumanBlueprintTests(unittest.TestCase):
    def test_blueprint_uses_the_current_manual_and_guide_contract(self) -> None:
        text = BLUEPRINT.read_text(encoding="utf-8")

        self.assertIn("RUNTIME_ALIGNED", text)
        self.assertIn("루메 — CASE-01 저승역", text)
        self.assertIn("기록관 아카 — M04 텍스트 보조", text)
        self.assertIn("실제 입력 UI", text)
        self.assertNotIn("빈칸 매뉴얼에 후보를 직접 배치 | `USER_APPROVED / NOT_IMPLEMENTED`", text)
        self.assertNotIn("하단 · 후보 규칙과 아카", text)

    def test_blueprint_separates_main_truth_from_active_m04_target(self) -> None:
        text = BLUEPRINT.read_text(encoding="utf-8")

        self.assertIn("PENDING_MAIN_RECONCILIATION", text)
        self.assertIn("안정도 시계 — 8칸", text)
        self.assertIn("위험도 시계 — 6칸", text)
        self.assertIn("괴이 매뉴얼 열기", text)
        self.assertIn("대표 교체", text)
        self.assertIn("회수 실행", text)
        self.assertIn("존재하지 않는다", text)

    def test_benchmark_has_ten_source_backed_comparisons(self) -> None:
        text = BENCHMARK.read_text(encoding="utf-8")

        entries = re.findall(r"^\| \d+ \|", text, flags=re.MULTILINE)
        self.assertGreaterEqual(len(entries), 10)
        for disposition in ("ADOPT", "ADAPT", "REJECT"):
            self.assertIn(disposition, text)

    def test_visual_work_order_keeps_repository_as_current_sync_owner(self) -> None:
        text = VISUAL_ORDER.read_text(encoding="utf-8")

        self.assertIn("Repository commit/push/remote readback", text)
        self.assertNotIn("Notion과 Repository를 같은 작업 범위에서 갱신", text)


if __name__ == "__main__":
    unittest.main()
