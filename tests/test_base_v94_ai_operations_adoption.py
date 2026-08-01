from __future__ import annotations
import hashlib,json,unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
class TestBaseV94Urban(unittest.TestCase):
 def test_identity_routes_and_protection(self):
  a=json.loads((ROOT/'skills/PROJECT_BASE_ADAPTER.json').read_text(encoding='utf-8')); s=json.loads((ROOT/'skills/PROJECT_SKILL_SNAPSHOT.json').read_text(encoding='utf-8'))
  self.assertEqual('9.4.0',a['base_release']['version']); self.assertEqual('a728712cb776ec98f4875914a580fcf7d0156593',a['base_release']['release_commit']); self.assertEqual('ef1fba11167e4da0b298123b0c85ebd268191a42',a['base_release']['release_evidence_commit']); self.assertEqual('693a0dff3f054ecdd653079909e044211473838e73dd9aff07734d1ce5694c59',a['skill_registry']['base']['sha256']); self.assertIn('optimizing-ai-model-and-prompt-costs',{x['route_id'] for x in a['routing']['base_routes']}); self.assertEqual(10,len(a['routing']['project_routes'])); self.assertEqual('BASE_SHARED',s['effective_routes']['optimizing-ai-model-and-prompt-costs']['source']); self.assertEqual(['data/','scripts/','scenes/','assets/','addons/','project.godot'],a['protected_paths'])
 def test_views(self):
  h=hashlib.sha256((ROOT/'skills/PROJECT_BASE_ADAPTER.json').read_bytes()).hexdigest(); s=json.loads((ROOT/'skills/PROJECT_SKILL_SNAPSHOT.json').read_text(encoding='utf-8')); self.assertEqual(h,s['source_registry']['sha256'])
  for p in ('skills/BASE_V9_ADAPTER.json','skills/PROJECT_BASE_SKILL_ADAPTER.json'):
   v=json.loads((ROOT/p).read_text(encoding='utf-8')); self.assertEqual(h,v['canonical_source_sha256']); self.assertEqual('9.4.0',v['base_release']['version'])
  p=json.loads((ROOT/'skills/PROJECT_PATH_ADAPTER.json').read_text(encoding='utf-8')); self.assertEqual('c987647d01ad2baa028a16e03d85ddfc1572a727',p['base']['commit']); self.assertEqual('a728712cb776ec98f4875914a580fcf7d0156593',p['base_release']['release_commit']); self.assertEqual(h,p['canonical_source_sha256'])
 def test_contracts(self):
  ai=(ROOT/'docs/AI_WORKFLOW.md').read_text(encoding='utf-8'); ux=(ROOT/'docs/UX_UI_SYSTEM.md').read_text(encoding='utf-8'); audit=(ROOT/'docs/reviews/2026-08-01_BASE_V9_4_ADOPTION_AUDIT.md').read_text(encoding='utf-8')
  for x in ('[모델 추천]','HARD_CONSTRAINT','Interface-first','Example-as-Fixture','refresh_trigger','복선','NOT_RUN'): self.assertIn(x,ai)
  for x in ('입력 접수','처리 중','중단','즉시 완료','빠른 반복','재진입','Reduced Motion','mute','haptic-off','권위 시점'): self.assertIn(x,ux)
  self.assertIn('product_paths_changed: false',audit); self.assertIn('HUMAN_NOT_RUN',audit)
if __name__=='__main__': unittest.main()
