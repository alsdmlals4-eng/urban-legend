from __future__ import annotations
import json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
BASE_SHA="7072b9e2742a60d7548fd39df3328ad76a8dbad1"
TABS=["00_프로젝트_허브","01_작업순서","02_현재_확정결정","03_근거_라이브러리","04_누락_충돌_감사","10_제품방향","11_세계관","12_핵심루프","13_주요인물","14_조연_세력_관계","20_코어경험_데모목표","30_데모범위_품질기준_제작기반","40_핵심시스템_메인콘텐츠","41_성장_경제","50_메인콘텐츠","51_미니게임","52_글쓰기_서사","60_UX_UI_접근성","70_아트_오디오_에셋","71_이미지기획_생성목록","72_이미지검수_승인로그","80_데모_버티컬슬라이스_플레이테스트","90_본제작_출시_사업","98_Base_반영후보","99_변경이력"]
def write(path,content):
 p=ROOT/path;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(content.rstrip()+"\n",encoding="utf-8")
def append(path,marker,content):
 p=ROOT/path;t=p.read_text(encoding="utf-8")
 if marker not in t:p.write_text(t.rstrip()+"\n\n"+content.strip()+"\n",encoding="utf-8")
def main():
 tabs="\n".join(f"- `{x}`" for x in TABS)
 write("docs/PROJECT_GOOGLE_SHEET_WORKBOOK.md",f"""# Urban Legend 프로젝트 Google Sheets Workbook

```yaml
sheet_status: NOT_CONFIGURED
base_commit: {BASE_SHA}
```

정확한 Sheet URL·ID·권한을 확인하지 못했으므로 신규 Sheet를 만들지 않는다. 연결 시 기존 탭·대화·분기·플래그·사용자 편집을 보존하고 아래 의미 구조를 설치·병합한다.

{tabs}

| 의미 구조 | 책임 원본 |
|---|---|
| 세계관·세력 | 괴담기록국, 퇴마사·마법사·중립·적대 세력 정본 |
| 핵심루프 | 조사·규칙 가설·위험 관리·기록·회수·복귀·연간 진행 |
| 주요인물·조연 | 권나래와 동료·요원·기관·괴이 관련 인물 정본 |
| 핵심시스템·메인콘텐츠 | 조사 VN, 선택·플래그·호감도, 미니게임, 회수·회복 전투, 기록물 |
| 이미지 계획·검수 | `docs/IMAGE_ASSET_WORKFLOW.md` |
""")
 write("docs/BCA_VISUAL_SHEET_ADOPTION_AUDIT.md",f"""# Urban Legend BCA v8 적용 적대적 검토

```yaml
base_commit: {BASE_SHA}
sheet_status: NOT_CONFIGURED
product_paths_changed: false
final_status: CONFLICT_FIXED
```

- `MUST_FIX`: 기존 이미지 workflow의 DeepSeek→Codex 생성 중심 구조 → GPT 기획 시각화·최종 후보·승인 중심으로 전환.
- `MUST_FIX`: Sheet에 세계관·핵심루프·인물·핵심시스템·이미지 tab 계약 부재 → 설치.
- `MUST_FIX`: Base SHA와 art/UX/QA trigger가 v8 이전 → 갱신.
- `ALLOWED_LEGACY`: 기존 manifest·크로마키·Godot import 절차는 실제 자산 파이프라인으로 보존.
- `BLOCKED_UNVERIFIED`: 실제 Sheet·생성 이미지·Godot 렌더·사용자 시각 검수.
""")
 image=ROOT/"docs/IMAGE_ASSET_WORKFLOW.md"
 image.write_text(f"""# 이미지 자산 제작·GPT 기획 시각화·검수 워크플로

- Base: `alsdmlals4-eng/Base@{BASE_SHA}`
- Mode: `planning-visualization`, `final-visual-candidate`, `visual-qa-and-approval`
- Sheet: `NOT_CONFIGURED`

## 역할

GPT는 프로젝트 정본과 레퍼런스를 바탕으로 기획 중 탐색 이미지·목업과 기획 종료 실사용 후보를 생성한다. Codex는 승인된 후보의 파일 규격·manifest·Godot import·실제 화면 적용을 담당한다. DeepSeek는 명시적 대량 초안 위임에서만 보조하며 이미지 생성의 기본 소유자가 아니다.

## 기획 중 우선 이미지

1. 연간 일정·일상·조사·회수·복귀 핵심루프 시각화.
2. 권나래와 동료·요원·기관·세력 관계·표정·대화 장면.
3. 조사 VN, 규칙 가설 카드, 단서·위험·기록물 UI 목업.
4. 에피소드별 미니게임과 회수·회복 전투의 연결 화면.
5. 현대 한국 도시괴담의 장소·조명·괴이 징후 톤 보드.

## 기획 종료 우선 후보

1. Annual Demo·Steam 키아트·캡슐·스크린샷.
2. 주요 인물 초상·표정·컷인 시트.
3. 괴이 기록 매뉴얼·규칙 카드·장비·기관 시각 체계.
4. 조사·분기·미니게임·회복 전투의 실제 16:9 UI 고도화 목업.

## 상태와 검수

`PLANNED → GENERATED_EXPLORATION → IN_REVIEW → REVISION_REQUIRED/REJECTED/APPROVED_CANDIDATE → PROJECT_ASSET_APPROVED → APPLIED_AND_RUNTIME_VERIFIED`.

기획·세계관·인물·괴이 규칙 일치, 실제 16:9 가독성, 구현 가능성, 손·표정·한글·간판·원근·광원 오류, 특정 IP·작가 스타일 유사성, 원출처·라이선스·모델·프롬프트를 검수한다. 생성 이미지는 자동 최종 자산이 아니다.

## `ASSET_MANIFEST.json`

manifest에는 단계, 상태, Image ID, 선택 콘셉트, 최종 프롬프트, 모델·버전, 용도, 파일명, 크기, 알파 여부, 참조 이미지·원출처, 교체 승인, QA와 실제 적용 결과를 기록한다.

- PNG 경로가 작업 묶음 밖으로 나가지 않는가.
- 해상도·알파·여백·파일명이 규칙에 맞는가.
- 최종 변형이 승인 후보와 정본을 참조하는가.
- 기존 파일 덮어쓰기가 승인되었는가.
- Godot import가 성공하고 16:9 화면에서 UI·플레이 요소를 가리지 않는가.
- 기존 프로젝트 스타일과 일치하는가.

투명 컷아웃은 크로마키 후처리를 기본으로 유지하며 복잡한 반투명 소재는 승인 뒤 별도 투명 출력 경로를 사용한다.
""",encoding="utf-8")
 append("README.md","## BCA v8 기획·이미지·Sheet 운영",f"""## BCA v8 기획·이미지·Sheet 운영

- Base: `alsdmlals4-eng/Base@{BASE_SHA}`
- v8 통합 실행문 사용.
- Sheet: `NOT_CONFIGURED`; `docs/PROJECT_GOOGLE_SHEET_WORKBOOK.md`
- GPT 이미지·검수: `docs/IMAGE_ASSET_WORKFLOW.md`
- 적대적 검토: `docs/BCA_VISUAL_SHEET_ADOPTION_AUDIT.md`
""")
 append("AGENTS.md","## BCA Sheet·GPT 이미지 생성·검수",f"""## BCA Sheet·GPT 이미지 생성·검수

- Base 기준은 `alsdmlals4-eng/Base@{BASE_SHA}`와 `VERTICAL_SLICE_INTEGRATED_EXECUTION_PROMPT_v8.md`다.
- Sheet는 `NOT_CONFIGURED`; URL 확인 전 신규 Sheet를 추정 생성하지 않는다.
- GPT는 기획 중 세계관·인물·에피소드·UI 목업과 기획 종료 Demo·상점 후보를 생성할 수 있다.
- 생성 결과는 자동 최종 자산이 아니며 `docs/IMAGE_ASSET_WORKFLOW.md`의 검수·manifest·Godot 적용 Gate를 통과해야 한다.
- 각 단계 뒤 `repository-wide-audit`로 stale 이미지·구형 Prompt·untouched 소비자를 검수한다.
""")
 p=ROOT/"docs/BASE_RULES_VERSION.md";t=p.read_text(encoding="utf-8").replace("41a20584dd2ee51d917e5c9d7cab6838e1ceba7e",BASE_SHA).replace("2026-07-23","2026-07-28")
 if "BCA v8" not in t:t=t.rstrip()+"\n\n## BCA v8\n\n- Prompt: `templates/prompts/VERTICAL_SLICE_INTEGRATED_EXECUTION_PROMPT_v8.md`.\n- Sheet: `NOT_CONFIGURED`.\n- 이미지 workflow: `docs/IMAGE_ASSET_WORKFLOW.md`.\n"
 p.write_text(t,encoding="utf-8")
 reg=ROOT/"skills/SKILL_REGISTRY.json";data=json.loads(reg.read_text(encoding="utf-8"));data["base"]["commit"]=BASE_SHA;data["base"]["integrated_execution_prompt"]="templates/prompts/VERTICAL_SLICE_INTEGRATED_EXECUTION_PROMPT_v8.md";data["bca_visual_sheet"]={"status":"ADOPTED","sheet_status":"NOT_CONFIGURED","required_tabs":TABS,"image_modes":["planning-visualization","final-visual-candidate","visual-qa-and-approval"],"adversarial_mode":"repository-wide-audit"}
 by={x["skill_id"]:x for x in data["project_disciplines"]}
 for tag in ("worldbuilding","core-loop","main-characters","supporting-characters","core-systems","main-content"):
  if tag not in by["urban-legend-game-design"]["trigger_tags"]:by["urban-legend-game-design"]["trigger_tags"].append(tag)
 for tag in ("planning-visualization","final-visual-candidate","image-mockup","image-approval"):
  if tag not in by["urban-legend-art"]["trigger_tags"]:by["urban-legend-art"]["trigger_tags"].append(tag)
 for mode in ("planning-visualization","final-visual-candidate","visual-qa-and-approval"):
  if mode not in by["urban-legend-art"]["skill_modes"]:by["urban-legend-art"]["skill_modes"].append(mode)
 for tag in ("visual-qa","image-approval","stale-prompt","sheet-structure","repository-wide-audit"):
  if tag not in by["urban-legend-qa"]["trigger_tags"]:by["urban-legend-qa"]["trigger_tags"].append(tag)
 for mode in ("visual-qa-and-approval","bca-adoption-audit"):
  if mode not in by["urban-legend-qa"]["skill_modes"]:by["urban-legend-qa"]["skill_modes"].append(mode)
 reg.write_text(json.dumps(data,ensure_ascii=False,separators=(",",":")),encoding="utf-8")
 art=ROOT/"skills/disciplines/urban-legend-art/SKILL.md";t=art.read_text(encoding="utf-8")
 if "`planning-visualization`" not in t:t=t.rstrip()+"\n\n## BCA 이미지 Mode\n\n- `planning-visualization`: 세계관·인물·조사·미니게임·UI 탐색 이미지와 목업.\n- `final-visual-candidate`: Demo·상점·키아트·초상·기록 매뉴얼 후보.\n- `visual-qa-and-approval`: 실제 화면·구현·권리·오류·승인 상태 검수.\n\n생성 이미지는 자동 최종 자산이 아니다.\n"
 art.write_text(t,encoding="utf-8")
 write("tests/test_bca_visual_sheet_adoption.py",f'''from __future__ import annotations
import json,unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1];BASE_SHA="{BASE_SHA}"
class TestBCA(unittest.TestCase):
 def test_pin(self):
  for p in ("README.md","AGENTS.md","docs/BASE_RULES_VERSION.md"):self.assertIn(BASE_SHA,(ROOT/p).read_text(encoding="utf-8"),p)
 def test_contracts(self):
  s=(ROOT/"docs/PROJECT_GOOGLE_SHEET_WORKBOOK.md").read_text(encoding="utf-8");v=(ROOT/"docs/IMAGE_ASSET_WORKFLOW.md").read_text(encoding="utf-8")
  for x in ("11_세계관","12_핵심루프","13_주요인물","14_조연_세력_관계","40_핵심시스템_메인콘텐츠","71_이미지기획_생성목록","72_이미지검수_승인로그","NOT_CONFIGURED"):self.assertIn(x,s)
  for x in ("planning-visualization","final-visual-candidate","visual-qa-and-approval","PROJECT_ASSET_APPROVED","자동 최종 자산"):self.assertIn(x,v)
 def test_registry(self):
  r=json.loads((ROOT/"skills/SKILL_REGISTRY.json").read_text(encoding="utf-8"));self.assertEqual(r["base"]["commit"],BASE_SHA);self.assertEqual(r["bca_visual_sheet"]["status"],"ADOPTED")
if __name__=="__main__":unittest.main()
''')
 write(".github/workflows/validate-bca-visual-sheet-adoption.yml",'''name: Validate Urban Legend BCA Adoption
on:
  pull_request:
    branches: [main]
    paths: ["README.md","AGENTS.md","docs/**","skills/**","tests/test_bca_visual_sheet_adoption.py",".github/workflows/validate-bca-visual-sheet-adoption.yml"]
permissions: {contents: read}
concurrency:
  group: urban-legend-bca-${{ github.event.pull_request.number || github.ref }}
  cancel-in-progress: true
jobs:
  contract:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with: {python-version: "3.12"}
      - run: python -m unittest tests.test_bca_visual_sheet_adoption -v
      - run: git diff --check origin/main...HEAD
''')
if __name__=="__main__":main()
