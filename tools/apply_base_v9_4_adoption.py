#!/usr/bin/env python3
from __future__ import annotations
import hashlib, json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
VERSION='9.4.0'; PAYLOAD='a728712cb776ec98f4875914a580fcf7d0156593'; EVIDENCE='ef1fba11167e4da0b298123b0c85ebd268191a42'; FINAL='87a0b54c2847ce4b685879209205957c170cc1cd'; REG='693a0dff3f054ecdd653079909e044211473838e73dd9aff07734d1ce5694c59'; BASELINE='656846865eb88871d00842a0da527ce1b0722b77'; NEW='optimizing-ai-model-and-prompt-costs'
def load(p): return json.loads((ROOT/p).read_text(encoding='utf-8'))
def save(p,d): (ROOT/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def route(): return {'route_id':NEW,'skill_id':NEW,'status':'ACTIVE'}

def adapters():
 p='skills/PROJECT_BASE_ADAPTER.json'; a=load(p); a['base_release']={'release_commit':PAYLOAD,'release_evidence_commit':EVIDENCE,'repository':'alsdmlals4-eng/Base','version':VERSION}; a['protected_baseline']['commit']=BASELINE; a['skill_registry']['base']['sha256']=REG
 if NEW not in {x['route_id'] for x in a['routing']['base_routes']}: a['routing']['base_routes'].append(route())
 a['routing']['base_routes'].sort(key=lambda x:x['route_id']); a['shared_overrides'].setdefault(NEW,{'modes':['route-model-and-effort','design-cacheable-prefix','estimate-cost','measure-actual-usage','recalibrate'],'provider_measurement_status':'NOT_RUN'}); save(p,a); h=hashlib.sha256((ROOT/p).read_bytes()).hexdigest()
 sp='skills/PROJECT_SKILL_SNAPSHOT.json'; s=load(sp); s['base_registry']['sha256']=REG
 if NEW not in {x['route_id'] for x in s['base_routes']}: s['base_routes'].append(route())
 s['base_routes'].sort(key=lambda x:x['route_id']); s['effective_routes'][NEW]={'route_id':NEW,'skill_id':NEW,'source':'BASE_SHARED','status':'ACTIVE','target_route_id':NEW}; s['source_registry']['sha256']=h; save(sp,s)
 for vp in ('skills/BASE_V9_ADAPTER.json','skills/PROJECT_BASE_SKILL_ADAPTER.json'):
  v=load(vp); v['base_release']={'release_commit':PAYLOAD,'release_evidence_commit':EVIDENCE,'repository':'alsdmlals4-eng/Base','version':VERSION}; v['canonical_source_sha256']=h
  if vp.endswith('PROJECT_BASE_SKILL_ADAPTER.json'): v.setdefault('shared_skill_overrides',{}).setdefault(NEW,{})
  save(vp,v)
 pp='skills/PROJECT_PATH_ADAPTER.json'; v=load(pp); v['base']={'commit':PAYLOAD,'evidence_commit':EVIDENCE,'finalization_commit':FINAL,'registry_sha256':REG,'repository':'alsdmlals4-eng/Base','version':VERSION,'version_authority':'docs/BASE_RULES_VERSION.md'}; v['canonical_source_sha256']=h; save(pp,v)

def docs():
 (ROOT/'docs/BASE_RULES_VERSION.md').write_text(f'''# Base Rules Version

```yaml
base: alsdmlals4-eng/Base
base_version: {VERSION}
base_payload_commit: {PAYLOAD}
base_trusted_evidence_commit: {EVIDENCE}
base_pin_finalization_commit: {FINAL}
base_registry_sha256: {REG}
release_state: BASE_RELEASED
project: alsdmlals4-eng/urban-legend
adoption_scope: OPERATING_CONTRACT_ONLY
product_paths_changed: false
```

`skills/PROJECT_BASE_ADAPTER.json`이 Base route와 프로젝트 분야 Skill 10개를 결합한다. Base v9.4는 모델·추론·Prompt caching·비용 측정, 지시 권위, Interface-first Prompt, Context 큐레이션, Artifact 주장 상한, Godot UI 모션 계약을 제공한다.

## 프로젝트 보호 경계

- 괴이 기록국의 조사→기록→가설→검증→안정화·잔향 회수 루프를 변경하지 않는다.
- 새 괴이·분기·단서·플래그·대사·설정·호감도·미니게임 결과를 발명하지 않는다.
- `data/`, `scripts/`, `scenes/`, `assets/`, `addons/`, `project.godot`, 특히 `data/episodes/*`와 `scripts/core/game_state.gd`를 수정하지 않는다.
- 복선·반대 근거·위험 사례·실패 경로·기존 ID·저장 호환성을 보존한다.
- Sheet는 `SHEET_GITHUB_CONFLICT / NO_AUTOMATIC_OVERWRITE`를 유지한다.
- Godot·입력·사람·provider 비용 검증은 `NOT_RUN` 또는 `HUMAN_NOT_RUN`이다.
''',encoding='utf-8')
 (ROOT/'docs/AI_WORKFLOW.md').write_text(f'''# 괴이기록국 AI·GitHub 작업 흐름

- `[모델 추천]`은 난도·실패 비용·재작업 위험으로 모델과 추론 단계를 제안한다. 실제 설정 변경은 사용자가 수행하고 다음 checkpoint부터 적용한다.
- 보안·권한·데이터 무결성·저장 호환성·기존 ID·에피소드 의미는 `HARD_CONSTRAINT`다.
- 일반 기술 구조는 `RECOMMENDED_DEFAULT`, 비파괴 표현 초안은 `JUDGMENT_SPACE`다.
- Prompt는 `problem / player_or_user_value / inputs / authority_and_source / output_contract / invariants / failure_conditions / validation`의 Interface-first 계약을 사용한다.
- `Example-as-Fixture`: 예시는 정상·실패·경계·회귀 Fixture 또는 Golden Set이며 정본 권위가 아니다.
- Context는 `decision_question / include_criteria / exclude_criteria / authority_level / freshness / known_conflicts / progressive_load_trigger / refresh_trigger`를 기록한다.
- 복선·반대 근거·위험 사례·실패 경로·보호 규칙은 큐레이션에서 제거하지 않는다.
- 화면·Schema·Fixture는 실제 Godot 런타임·플레이어 이해·접근성·성능을 자동 증명하지 않는다. 미실행 자동 검증은 `NOT_RUN`, 사람 검증은 `HUMAN_NOT_RUN`이다.

Base identity: `{PAYLOAD}` / `{EVIDENCE}` / `{REG}`.
''',encoding='utf-8')
 up=ROOT/'docs/UX_UI_SYSTEM.md'; u=up.read_text(encoding='utf-8').replace('Base content commit: `0fd95f4513343e77fd664af2763a01b02f52545b`  ',f'Base content commit: `{PAYLOAD}`')
 if '## 8A. UI 모션·중단·반복 계약' not in u:
  b='''## 8A. UI 모션·중단·반복 계약

```text
입력 접수 → 처리 중 → 도메인 결과 확정 → 결과 표현
```

- 조사·기록·가설·선택지·위험 검증·안정화·잔향 회수 모션은 중단과 즉시 완료 경로를 가진다.
- 빠른 반복·팝업 재진입에서 단서·플래그·선택 기억·위험·보상·저장이 중복되지 않아야 한다.
- `AnimationPlayer`·`Tween` 완료 signal은 에피소드·플래그·분기·저장·회수 결과의 권위 시점이 아니다.
- `Reduced Motion`, `mute`, `haptic-off`에서도 신뢰 상태·위험·모순·결과 원인·다음 행동을 보존한다.
- 실제 조사 흐름·입력·성능·사람 이해는 `NOT_RUN` / `HUMAN_NOT_RUN`으로 유지한다.

'''; u=u.replace('## 9. 검증 매트릭스',b+'## 9. 검증 매트릭스',1)
 up.write_text(u,encoding='utf-8')
 cs=ROOT/'docs/CURRENT_STATUS.md'; t=cs.read_text(encoding='utf-8')
 if '## Base v9.4 운영 계약' not in t: t=t.rstrip()+f'''\n\n## Base v9.4 운영 계약\n\n- adapter에 Base `{VERSION}` payload/evidence를 적용했다.\n- 제품 코드·에피소드 JSON·대사·Scene·자산·저장·Sheet는 변경하지 않는다.\n- 런타임·입력·사람·provider 검증은 `NOT_RUN` 또는 `HUMAN_NOT_RUN`이다.\n'''
 cs.write_text(t,encoding='utf-8')
 dm=ROOT/'docs/DOCUMENTATION_MAP.md'; t=dm.read_text(encoding='utf-8')
 if '2026-08-01_BASE_V9_4_ADOPTION_AUDIT' not in t: t=t.rstrip()+'''\n\n## Base v9.4 운영 계약\n\n- `docs/AI_WORKFLOW.md`: 모델 추천·지시 권위·Context 큐레이션·증거 상한.\n- `docs/reviews/2026-08-01_BASE_V9_4_ADOPTION_AUDIT.md`: payload·evidence·route·내러티브/저장 보호 감사.\n'''
 dm.write_text(t,encoding='utf-8')
 ap=ROOT/'docs/reviews/2026-08-01_BASE_V9_4_ADOPTION_AUDIT.md'; ap.parent.mkdir(parents=True,exist_ok=True); ap.write_text(f'''# Base v9.4 적용 감사 — 괴이기록국

```yaml
decision_id: DEC-2026-08-01-001
issue: 123
baseline_commit: {BASELINE}
base_version: {VERSION}
base_payload: {PAYLOAD}
base_evidence: {EVIDENCE}
base_finalization: {FINAL}
base_registry_sha256: {REG}
adoption_scope: OPERATING_CONTRACT_ONLY
product_paths_changed: false
gdd_sheet_written: false
runtime_validation: NOT_RUN
human_validation: HUMAN_NOT_RUN
```

프로젝트 분야 Skill 10개, 조사·기록·가설·안정화·잔향 회수 루프, 에피소드·복선·분기·플래그·대사·저장·Sheet 경계를 보존한다. Context 큐레이션은 반대 근거·복선·위험 사례·실패 경로를 제거하지 않는다. UI 모션은 에피소드·플래그·분기·회수·저장 결과의 권위가 아니다.
''',encoding='utf-8')

def tests():
 (ROOT/'tests/test_base_v94_ai_operations_adoption.py').write_text(f'''from __future__ import annotations
import hashlib,json,unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
class TestBaseV94Urban(unittest.TestCase):
 def test_identity_routes_and_protection(self):
  a=json.loads((ROOT/'skills/PROJECT_BASE_ADAPTER.json').read_text(encoding='utf-8')); s=json.loads((ROOT/'skills/PROJECT_SKILL_SNAPSHOT.json').read_text(encoding='utf-8'))
  self.assertEqual('{VERSION}',a['base_release']['version']); self.assertEqual('{PAYLOAD}',a['base_release']['release_commit']); self.assertEqual('{EVIDENCE}',a['base_release']['release_evidence_commit']); self.assertEqual('{REG}',a['skill_registry']['base']['sha256']); self.assertIn('{NEW}',{{x['route_id'] for x in a['routing']['base_routes']}}); self.assertEqual(10,len(a['routing']['project_routes'])); self.assertEqual('BASE_SHARED',s['effective_routes']['{NEW}']['source']); self.assertEqual(['data/','scripts/','scenes/','assets/','addons/','project.godot'],a['protected_paths'])
 def test_views(self):
  h=hashlib.sha256((ROOT/'skills/PROJECT_BASE_ADAPTER.json').read_bytes()).hexdigest(); s=json.loads((ROOT/'skills/PROJECT_SKILL_SNAPSHOT.json').read_text(encoding='utf-8')); self.assertEqual(h,s['source_registry']['sha256'])
  for p in ('skills/BASE_V9_ADAPTER.json','skills/PROJECT_BASE_SKILL_ADAPTER.json'):
   v=json.loads((ROOT/p).read_text(encoding='utf-8')); self.assertEqual(h,v['canonical_source_sha256']); self.assertEqual('{VERSION}',v['base_release']['version'])
  p=json.loads((ROOT/'skills/PROJECT_PATH_ADAPTER.json').read_text(encoding='utf-8')); self.assertEqual('{PAYLOAD}',p['base']['commit']); self.assertEqual(h,p['canonical_source_sha256'])
 def test_contracts(self):
  ai=(ROOT/'docs/AI_WORKFLOW.md').read_text(encoding='utf-8'); ux=(ROOT/'docs/UX_UI_SYSTEM.md').read_text(encoding='utf-8'); audit=(ROOT/'docs/reviews/2026-08-01_BASE_V9_4_ADOPTION_AUDIT.md').read_text(encoding='utf-8')
  for x in ('[모델 추천]','HARD_CONSTRAINT','Interface-first','Example-as-Fixture','refresh_trigger','복선','NOT_RUN'): self.assertIn(x,ai)
  for x in ('입력 접수','처리 중','중단','즉시 완료','빠른 반복','재진입','Reduced Motion','mute','haptic-off','권위 시점'): self.assertIn(x,ux)
  self.assertIn('product_paths_changed: false',audit); self.assertIn('HUMAN_NOT_RUN',audit)
if __name__=='__main__': unittest.main()
''',encoding='utf-8')
adapters(); docs(); tests()
