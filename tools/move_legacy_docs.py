#!/usr/bin/env python3
"""Move baseline Urban Legend documents into their audited discipline homes."""
from __future__ import annotations
import shutil
from pathlib import Path

ROOT=Path.cwd(); K="[기획서]"

def target(path: str) -> str:
    name=Path(path).name
    if path.startswith("docs/archive/"): return f"{K}/[백업]/urban-legend/archive/{path.removeprefix('docs/archive/')}"
    if path.startswith(("docs/superpowers/",)): return f"{K}/[백업]/urban-legend/{path.removeprefix('docs/')}"
    if path.startswith("docs/gpt_tasks/"): return f"{K}/[보류]/urban-legend/{path.removeprefix('docs/')}"
    if path.startswith("docs/benchmarks/"): return f"{K}/10_분석_유저리서치/등록_부록/{name}"
    if path.startswith("docs/qa/") and not path.startswith("docs/qa/captures/"): return f"{K}/08_QA/등록_부록/{name}"
    if path.startswith("docs/planning/"):
        if name in {"NARRATIVE_CONTENT_PLAN.md", "PROJECT_DIRECTION.md"}: return f"{K}/01_설정_내러티브/등록_부록/{name}"
        if name == "ART_PRESENTATION_PLAN.md": return f"{K}/06_아트/등록_부록/{name}"
        if name == "REFERENCE_CASES.md": return f"{K}/10_분석_유저리서치/등록_부록/{name}"
        return f"{K}/09_프로덕션_PM/등록_부록/{name}"
    if name in {"GAME_DESIGN_DOCUMENT.md", "MINIGAME_SYSTEM_SPEC.md", "MVP037_CAMPAIGN_CORE.md", "MVP038_SEQUENTIAL_CAMPAIGN.md", "URBAN_LEGEND_GAME_DESIGN.docx"}: return f"{K}/02_게임_디자인/등록_부록/{name}"
    if name in {"CINEMATIC_FIELD_RECOVERY_UI.md", "GODOT_NATIVE_UI_ARCHITECTURE.md", "UI_UX_REDESIGN_R1_REPORT.md"}: return f"{K}/03_UX_UI_접근성/등록_부록/{name}"
    if name in {"IMAGE_ASSET_WORKFLOW.md"}: return f"{K}/05_테크니컬아트_콘텐츠_파이프라인/등록_부록/{name}"
    if name.startswith("CODEX_GOAL_") or name in {"CURRENT_STATUS.md", "CURRENT_HANDOFF.md", "MVP_STATUS_AUDIT.md", "MVP_WORKFLOW_CHECKLIST.md"}: return f"{K}/[백업]/urban-legend/completed-work/{name}"
    if name in {"BENCHMARKING_REFERENCE_GUIDE.md", "MULTIMODEL_20_TASK_EVALUATION.md"}: return f"{K}/10_분석_유저리서치/등록_부록/{name}"
    if name in {"DOCUMENTATION_MAP.md", "DOCUMENT_LIFECYCLE.md", "BASE_RULES_VERSION.md", "PROJECT_CONTEXT.md", "AI_DELEGATION_WORKFLOW.md", "AI_SHARED_WORK_RULES.md", "AI_SKILL_ADOPTION_GUIDE.md", "AI_WORKFLOW_RULES.md", "AI_SHARED_WORK_RULES.md", "CODEX_ACCOUNT_HANDOFF.md", "CODEX_SHARED_WORK_RULES.md", "DIALOGUE_AUTHORING_WORKFLOW.md", "SERENA_CODEX_MANUAL_CONFIG.md"}: return f"{K}/[백업]/urban-legend/root-docs/{name}"
    return f"{K}/11_통합검수/등록_부록/{name}"

def main() -> int:
    moved=[]
    for source in sorted((ROOT/'docs').rglob('*')):
        if not source.is_file() or 'captures' in source.parts or source.name.startswith('MIGRATION_'): continue
        relative=source.relative_to(ROOT).as_posix(); destination=ROOT/target(relative)
        destination.parent.mkdir(parents=True,exist_ok=True)
        if destination.exists(): raise FileExistsError(destination)
        shutil.move(str(source),str(destination)); moved.append((relative,destination.relative_to(ROOT).as_posix()))
    (ROOT/K/'00_프로젝트_허브'/'LEGACY_DOCUMENT_MOVE_MAP.tsv').parent.mkdir(parents=True,exist_ok=True)
    (ROOT/K/'00_프로젝트_허브'/'LEGACY_DOCUMENT_MOVE_MAP.tsv').write_text('source\ttarget\n'+'\n'.join(f'{a}\t{b}' for a,b in moved)+'\n',encoding='utf-8')
    print(f'Moved {len(moved)} legacy document file(s).')
    return 0
if __name__=='__main__': raise SystemExit(main())
