#!/usr/bin/env python3
"""Create the Urban Legend 11-discipline routing, skill, and publication sources.

This is deliberately data-driven: it never edits gameplay files and derives each
appendix list from the documents that were physically migrated before it runs.
"""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path.cwd()
PLAN = ROOT / "[기획서]"
HUB = PLAN / "00_프로젝트_허브"
BASE = "d2457e75a856260d309203e20262f2a2142d2dd6"
SOURCE = "dd3c9a8776eb938eeeeb2f1319af6bfc4a135202"

DISCIPLINES = [
    ("01_설정_내러티브", "01_설정_내러티브_본책.md", "설정·내러티브", "세계관, 사건, 인물, 대화와 콘텐츠 의도를 책임진다.", "NARRATIVE_CONTENT_PLAN.md, PROJECT_DIRECTION.md", "data/episodes/**와 대화 데이터는 이주 PR에서 수정하지 않는다."),
    ("02_게임_디자인", "02_게임_디자인_본책.md", "게임 디자인", "조사·판단·선택·결과 루프, 미니게임, 캠페인 규칙과 수치를 책임진다.", "GAME_DESIGN_DOCUMENT.md, MINIGAME_SYSTEM_SPEC.md, MVP037_CAMPAIGN_CORE.md, MVP038_SEQUENTIAL_CAMPAIGN.md, URBAN_LEGEND_GAME_DESIGN.docx", "기존 DOCX는 비교 자료이며 Markdown 본책이 현행 책임 원본이다."),
    ("03_UX_UI_접근성", "03_UX_UI_접근성_본책.md", "UX·UI·접근성", "화면 흐름, 입력, 정보 계층, 가독성과 접근성 검증을 책임진다.", "CINEMATIC_FIELD_RECOVERY_UI.md, GODOT_NATIVE_UI_ARCHITECTURE.md, UI_UX_REDESIGN_R1_REPORT.md", "수동 1920×1080 및 1280×720 QA는 [미검증]으로 유지한다."),
    ("04_개발_엔지니어링", "04_개발_엔지니어링_본책.md", "개발·엔지니어링", "Godot 구조, 저장, 캠페인, Scene, 데이터 경계와 자동 검증을 책임진다.", "코드·Scene·Resource·tests/는 실행 증거로 유지", "project.godot, scripts/core/game_state.gd, data/episodes/**의 해시는 이주 전후 같아야 한다."),
    ("05_테크니컬아트_콘텐츠_파이프라인", "05_테크니컬아트_콘텐츠_파이프라인_본책.md", "테크니컬 아트·콘텐츠 파이프라인", "이미지 import, 자산 Manifest, 콘텐츠 제작·검수 경로를 책임진다.", "IMAGE_ASSET_WORKFLOW.md", "기존 .import와 원격 자산 경로를 이동하지 않는다."),
    ("06_아트", "06_아트_본책.md", "아트", "캐릭터·배경·UI 시각 언어, 승인 자산과 제작 상태를 책임진다.", "ART_PRESENTATION_PLAN.md", "자산 원본은 assets/에 두고 Asset Registry로 연결한다."),
    ("07_사운드", "07_사운드_본책.md", "사운드", "BGM·SFX·음성 이벤트 연결과 믹싱 상태를 책임진다.", "등록된 활성 사운드 기획 없음", "사운드 구현·QA 증거가 없으므로 다음 작업은 [미검증] 요구사항 확정이다."),
    ("08_QA", "08_QA_본책.md", "QA", "자동·수동 검증, 결함, 캡처 증거, 재현 절차와 릴리스 게이트를 책임진다.", "MVP039~043 QA 문서, TWO_CASE_CAMPAIGN_MANUAL_QA.md", "47개 새 PNG와 기존 캡처는 docs/qa/captures 경로를 유지하고 로그 22개는 추적하지 않는다."),
    ("09_프로덕션_PM", "09_프로덕션_PM_본책.md", "프로덕션·PM", "우선순위, Roadmap, Issue/PR, 위험, 인수와 완료 조건을 책임진다.", "ROADMAP_AND_HANDOFF.md", "PR #26은 대체 PR의 workflow 계약 대조 후에만 종료 후보가 된다."),
    ("10_분석_유저리서치", "10_분석_유저리서치_본책.md", "분석·유저리서치", "참고 사례, 플레이어 반응 가설, 측정·리서치 계획을 책임진다.", "BENCHMARKING_REFERENCE_GUIDE.md, REFERENCE_CASES.md, MULTIMODEL_20_TASK_EVALUATION.md", "외부 비교는 방향 참고일 뿐 프로젝트 사실을 덮어쓰지 않는다."),
    ("11_통합검수", "11_통합검수_본책.md", "통합검수", "분야 간 계약, 문서·코드·자산 연결, 발행과 최종 Ready 판정을 책임진다.", "CONTENT_DIRECTION_V09.md, PROJECT_COMPACT_AUDIT.md, urban_legend_flow_dashboard.html", "Godot import → headless → runtime smoke → 문서 발행 순서가 완료 기준이다."),
]

SLUGS = ["narrative", "game-design", "ux-ui-accessibility", "engineering", "technical-art-pipeline", "art", "audio", "qa", "production-pm", "analytics-user-research", "integration-review"]

def write(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text.rstrip() + "\n", encoding="utf-8")

def rel(path: Path) -> str:
    return path.relative_to(HUB).as_posix()

def active_appendices(folder: Path) -> list[str]:
    appendix = folder / "등록_부록"
    return sorted(item.name for item in appendix.iterdir() if item.is_file()) if appendix.exists() else []

def bible(index: int, row: tuple[str, str, str, str, str, str]) -> None:
    folder, filename, discipline, responsibility, inherited, boundary = row
    appendices = active_appendices(PLAN / folder)
    appendix_links = "\n".join(f"- [등록 부록: {name}](등록_부록/{name})" for name in appendices) or "- 등록된 원문 없음"
    text = f"""# Urban Legend {discipline} 본책

## 책임 범위

{responsibility} 이 파일은 이 분야의 서술형 단일 책임 원본이며, 세부 원문은 아래 등록 부록으로 보존한다.

## 현재 상태

- 기준 Base: `{BASE}`
- 이주 기준 프로젝트 커밋: `{SOURCE}`
- 승계한 원문: {inherited}
- 본책 상태: `ACTIVE`; 원문·표·수치·승인/미검증 표기는 등록 부록과 보존표에서 추적한다.

## 현재 결정과 제약

{boundary}

## 다음 작업

해당 분야 변경 시 이 본책의 상태·다음 작업·검증 경로와 관련 등록 부록을 같은 PR에서 함께 갱신한다. 확정되지 않은 결론은 `[미검증]` 또는 `[확인 필요]`로 남긴다.

## 검증 경로

- 문서 구조: `python tools/verify_migration_inventory.py --before docs/MIGRATION_INVENTORY_BEFORE.json --after docs/MIGRATION_INVENTORY_AFTER.json`
- 링크/Registry/발행: `python tools/build_design_documents.py --registry [기획서]/00_프로젝트_허브/DESIGN_DOCUMENT_REGISTRY.json --source-commit {SOURCE}`
- 게임 변경이 있을 때만: Godot editor import → 관련 headless test → runtime smoke.

## 등록 부록

{appendix_links}
"""
    write(PLAN / folder / filename, text)

def skill(index: int, row: tuple[str, str, str, str, str, str], slug: str) -> dict:
    folder, filename, discipline, responsibility, _, boundary = row
    skill_path = ROOT / "skills" / "disciplines" / f"{index:02d}-{slug}" / "SKILL.md"
    bible_path = f"[기획서]/{folder}/{filename}"
    text = f"""---
name: urban-legend-{slug}
description: Urban Legend의 {discipline} 작업을 해당 본책, 등록 부록, 검증 경로로 라우팅한다.
---

# Urban Legend {discipline} 스킬

## 사용할 때

{responsibility}

## 먼저 읽을 파일

1. `{bible_path}`
2. `[기획서]/00_프로젝트_허브/ACTIVE_CONTEXT.md`
3. `[기획서]/00_프로젝트_허브/DOCUMENTATION_MAP.md`
4. 관련 `등록_부록/` 원문과 실제 대상 파일

## 작업 계약

- {boundary}
- 본책과 등록 부록의 책임을 섞지 않는다. 실행 데이터·상태·경로·해시는 JSON Registry 또는 실제 파일을 원본으로 한다.
- 변경 뒤 본책의 현재 상태·다음 작업·검증 경로를 갱신하고, 미실행 검증은 `NOT_RUN`으로 기록한다.

## 검증

`python tools/verify_migration_inventory.py --before docs/MIGRATION_INVENTORY_BEFORE.json --after docs/MIGRATION_INVENTORY_AFTER.json`
"""
    write(skill_path, text)
    return {"skill_id": f"urban-legend-{slug}", "layer": "discipline", "discipline": discipline, "path": skill_path.relative_to(ROOT).as_posix(), "status": "ACTIVE", "load_by_default": False, "trigger_tags": [slug], "use_when": [responsibility], "do_not_use_when": ["다른 분야의 단독 변경"], "learning_log": "skills/LEARNING_LOG.md", "review_triggers": ["본책 또는 검증 경로 변경"], "last_reviewed_at": "2026-07-20", "last_reviewed_commit": SOURCE, "knowledge_state": "MIGRATED"}

def main() -> None:
    for index, row in enumerate(DISCIPLINES, 1): bible(index, row)
    skills = [skill(index, row, slug) for index, (row, slug) in enumerate(zip(DISCIPLINES, SLUGS), 1)]
    write(ROOT / "skills" / "LEARNING_LOG.md", "# Urban Legend Learning Log\n\n- 2026-07-20: Base 11개 분야 구조를 적용했다. 프로젝트 고유 사실은 본책·등록 부록에, 재사용 가능한 방식은 Base에만 반영한다.\n")
    documents = [{"document_id": "urban-legend-project-hub", "title": "Urban Legend 프로젝트 종합 책임 원본", "discipline": "프로젝트 전체", "responsibility_coverage": ["프로젝트 전체"], "status": "ACTIVE", "source_path": "00_프로젝트_종합_책임_원본.md", "source_format": "markdown", "source_role": "narrative_spec", "publication_policy": "always_sync", "output_pdf": "00_프로젝트_종합_책임_원본.pdf", "output_docx": None, "asset_dir": None, "diagram_policy": "none", "publication_manifest": "00_프로젝트_종합_책임_원본_PUBLICATION_MANIFEST.json", "generator": "tools/build_design_documents.py", "required_sections": ["목표", "배경과 의도", "범위", "규칙과 제약", "검증과 완료 기준"]}]
    for folder, filename, discipline, *_ in DISCIPLINES:
        stem = Path(filename).stem
        documents.append({"document_id": f"urban-legend-{folder[:2]}", "title": f"Urban Legend {discipline} 본책", "discipline": discipline, "responsibility_coverage": [discipline], "status": "ACTIVE", "source_path": f"../{folder}/{filename}", "source_format": "markdown", "source_role": "narrative_spec", "publication_policy": "always_sync", "output_pdf": f"../{folder}/{stem}.pdf", "output_docx": None, "asset_dir": None, "diagram_policy": "none", "publication_manifest": f"../{folder}/{stem}_PUBLICATION_MANIFEST.json", "generator": "tools/build_design_documents.py", "required_sections": ["책임 범위", "현재 상태", "현재 결정과 제약", "다음 작업", "검증 경로"]})
    registry = {"$schema": "../../schemas/design-document-registry-v3.schema.json", "schema_version": 3, "registry_role": "ai-design-document-router-and-publication-index", "project_name": "Urban Legend", "source_of_truth_policy": "프로젝트 허브와 11개 분야 본책은 Markdown 책임 원본이다. Registry·Manifest·상태·ID·경로·해시·게임 데이터는 JSON 또는 실제 파일이 원본이다.", "required_responsibility_coverage": [row[2] for row in DISCIPLINES] + ["프로젝트 전체"], "available_responsibility_catalog": [row[2] for row in DISCIPLINES], "documents": documents}
    write(HUB / "DESIGN_DOCUMENT_REGISTRY.json", json.dumps(registry, ensure_ascii=False, indent=2))
    asset = {"schema_version": 1, "registry_role": "asset-and-qa-evidence-index", "project_name": "Urban Legend", "protected_paths": ["project.godot", "scripts/core/game_state.gd", "data/episodes/**"], "qa_capture_library": {"path": "docs/qa/captures", "dirty_png_count": 47, "log_policy": "docs/qa/captures/**/*.log is ignored; logs are not evidence assets."}, "source_manifests": ["assets/ASSET_MANIFEST.json", "assets/characters/mvp043/ASSET_MANIFEST.json"]}
    write(HUB / "ASSET_REGISTRY.json", json.dumps(asset, ensure_ascii=False, indent=2))
    skill_registry = {"$schema": "../../schemas/skill-registry-v3.schema.json", "schema_version": 3, "registry_role": "project-skill-router-and-learning-index", "routing_policy": {"load_all_skills": False, "default_selection": "none", "require_trigger_match": True, "max_primary_discipline_skills": 1, "max_foundation_skills": 3, "exclude_statuses": ["HOLD", "BACKUP", "REMOVAL_CANDIDATE"]}, "human_presentation": {"primary_reading_format": "PROJECT_SKILL_MAP.pdf", "editable_derivative": None, "diagram_directory": "PROJECT_SKILL_MAP.assets", "publication_manifest": "SKILL_MAP_PUBLICATION_MANIFEST.json", "generator": "tools/build_project_skill_map.py", "source_of_truth": "SKILL_REGISTRY.json", "markdown_summary": "PROJECT_SKILL_MAP.md"}, "required_disciplines": [row[2] for row in DISCIPLINES], "discipline_entrypoints": {row[2]: [f"urban-legend-{slug}"] for row, slug in zip(DISCIPLINES, SLUGS)}, "skills": skills}
    write(HUB / "SKILL_REGISTRY.json", json.dumps(skill_registry, ensure_ascii=False, indent=2))
    write(HUB / "BASE_RULES_VERSION.md", f"# Base Rules Version\n\n- Base commit: `{BASE}`\n- 적용 정책: 11개 독립 본책, 11개 1:1 분야 스킬, Markdown 본책, JSON Registry/Manifest, 항상 최신 PDF.\n- 이 프로젝트 이주 기준: `{SOURCE}`\n")
    write(HUB / "00_프로젝트_종합_책임_원본.md", f"""# Urban Legend 프로젝트 종합 책임 원본

## 목표

도시 전설 조사·판단·회복의 반복 루프를 통해 미스터리를 해결하는 Godot 프로젝트를 유지한다.

## 배경과 의도

현행 구현과 승인 기획은 보존하면서 Base `{BASE}`의 11개 분야 운영체계로 라우팅한다.

## 범위

이 문서는 전체 연결 책임만 가진다. 각 분야의 결정은 01~11 본책, 실행 상태는 실제 코드·데이터·테스트가 원본이다.

## 규칙과 제약

`project.godot`, 저장·캠페인·에피소드 데이터, 보호 코드는 이 문서 이주 PR에서 변경하지 않는다.

## 검증과 완료 기준

전수 보존 대조 `missing=0`, 11 본책·11 스킬·3 Registry·PDF/Manifest·활성 링크·Godot 검증 순서가 모두 통과해야 한다.
""")
    write(HUB / "DEVELOPMENT_GATES.md", "# Development Gates\n\n1. 문서/데이터/코드 책임 원본 확인\n2. 변경 영향 분야 본책과 스킬 선택\n3. Godot editor import → 관련 headless test → runtime smoke\n4. PDF/Manifest·링크·보존표 검증\n5. 사람 수동 QA는 실행 증거가 없으면 `[미검증]`으로 기록\n")
    write(HUB / "UPDATE_MATRIX.md", "# Update Matrix\n\n| 변경 | 반드시 갱신 |\n|---|---|\n| 규칙·콘텐츠 | 해당 본책, 등록 부록, Registry, QA |\n| 코드·Scene·데이터 | 04 본책, 관련 테스트, 11 통합검수 |\n| 자산·import | 05·06 본책, Asset Registry, QA 증거 |\n| 일정·Issue·PR | 09 본책, Active Context, 통합검수 |\n")

if __name__ == "__main__": main()
