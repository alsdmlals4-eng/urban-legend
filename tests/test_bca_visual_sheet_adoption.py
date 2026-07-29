from __future__ import annotations
import json,unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]; BASE_SHA="c987647d01ad2baa028a16e03d85ddfc1572a727"; SHEET_ID="14xtlvd90iQTKjDLcZR_b-WS5fHnBwNf-OfBruPBS6ck"
class BCAAdoptionTests(unittest.TestCase):
 def test_contract(self):
  for p in ("README.md","AGENTS.md","docs/BASE_RULES_VERSION.md"): self.assertIn(BASE_SHA,(ROOT/p).read_text(encoding="utf-8"),p)
  s=(ROOT/"docs/PROJECT_GOOGLE_SHEET_WORKBOOK.md").read_text(encoding="utf-8")
  for x in ("PROJECT_SHEET_CONFIGURED",SHEET_ID,"USER_FACING_GDD_WORKSPACE","PROPOSED_SHEET_CHANGE","05_GDD_요약","15_조작_게임규칙","51_미니게임","52_글쓰기_서사"): self.assertIn(x,s)
 def test_registry(self):
  r=json.loads((ROOT/"skills/SKILL_REGISTRY.json").read_text(encoding="utf-8")); self.assertEqual(r["base"]["commit"],BASE_SHA); self.assertEqual(r["bca_visual_sheet"]["spreadsheet_id"],SHEET_ID); self.assertIn("51_미니게임",r["bca_visual_sheet"]["required_tabs"]); self.assertIn("52_글쓰기_서사",r["bca_visual_sheet"]["required_tabs"])
if __name__=="__main__": unittest.main()
