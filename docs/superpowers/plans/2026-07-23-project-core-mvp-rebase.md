# Project Core MVP Rebase Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 승인된 조사-이해도-턴제 회수 코어를 현행 문서 체계와 MVP 로드맵에 충돌 없이 기록하고, 런타임 구현 전 PoC 게이트를 명확히 한다.

**Architecture:** 제품 정체성은 `docs/PROJECT_CORE.md`, 상세 시스템은 `docs/GAME_DESIGN_DOCUMENT.md`, 현재 구현 사실은 `docs/CURRENT_STATUS.md`, 구현 순서는 `MVP_ROADMAP.md`가 각각 소유한다. 설계 전문과 실행 계획은 `docs/superpowers/` 아래에 별도로 보존해 현재 구현과 승인 목표를 혼합하지 않는다.

**Tech Stack:** Markdown, repository document reference tests, Git diff validation, DOCX/PDF generation pipeline.

## Global Constraints

- 권나래는 고정 주인공이며 교체 기능이 없다.
- 권나래의 일정만 진행·소비하고 서포트는 독립 일정을 요구하지 않는다.
- 새 코어는 `POC_PENDING`이며 현재 구현 완료로 표시하지 않는다.
- 현행 저장 스키마 `mvp-039`를 이 문서 단계에서 변경하지 않는다.
- 기존 MVP-044~046 자산은 삭제하지 않고 구현 보류·재매핑 대상으로 기록한다.
- 조사와 회수 전투의 연결은 이해도와 전조 해석으로 표현한다.
- 이해도는 공격력 보너스가 아니라 정보 우위다.

---

### Task 1: Record the approved core contract

**Files:**
- Create: `docs/superpowers/specs/2026-07-23-project-core-finalization-design.md`
- Modify: `docs/PROJECT_CORE.md`

**Interfaces:**
- Consumes: 2026-07-23 사용자 승인 결정 기록
- Produces: `CORE_RECORDED` 제품 정체성, WHY/HOW/WHAT, 재승인 조건, PoC 통과 조건

- [ ] **Step 1: Add the design specification**

Create the specification with the approved decisions for investigation choices, manual evidence linking, understanding stages, turn-based recovery, injury, capture, research, hidden branches, chapter requests, and ending axes.

- [ ] **Step 2: Replace the old non-combat core statement**

Update `docs/PROJECT_CORE.md` so `비전투 정체성` is removed and replaced by `전조 기반 턴제 패턴 대응형 회수 전투`. Keep the distinction between killing and recovery.

- [ ] **Step 3: Verify status language**

Run:

```bash
rg -n "IDENTIFIED|CORE_CONFIRMED|CORE_RECORDED|POC_PENDING" docs/PROJECT_CORE.md docs/superpowers/specs/2026-07-23-project-core-finalization-design.md
```

Expected:

```text
docs/PROJECT_CORE.md contains CORE_RECORDED and POC_PENDING.
The specification contains CORE_RECORDED and POC_PENDING.
No line claims the runtime implementation is complete.
```

- [ ] **Step 4: Commit**

```bash
git add docs/PROJECT_CORE.md docs/superpowers/specs/2026-07-23-project-core-finalization-design.md
git commit -m "docs: record approved project core"
```

### Task 2: Rebase direction and detailed design

**Files:**
- Modify: `docs/planning/PROJECT_DIRECTION.md`
- Modify: `docs/GAME_DESIGN_DOCUMENT.md`

**Interfaces:**
- Consumes: `docs/PROJECT_CORE.md`
- Produces: investigation, understanding, recovery combat, capture, research, chapter, request, and ending system contracts

- [ ] **Step 1: Update the project promise and pointed fun**

Replace the old non-combat promise with the approved investigation-to-recovery causal loop. Preserve fair-play clues, learnable failure, and the anomaly manual as permanent knowledge.

- [ ] **Step 2: Add the investigation contract**

Document exactly:

```text
4 choices
→ 2-3 automatically surfaced manual cases
→ player links evidence to eliminate 2 choices
→ test 1 of 2 competing hypotheses
→ update understanding, health, anomaly risk, and scene constraints
```

- [ ] **Step 3: Add the recovery combat contract**

Document exactly:

```text
failed omen read: 놈은 무언가 하려 한다.
successful omen read: 놈은 [행동명]을 하려 한다.
```

Include the first-use hidden core pattern rule and universal defense mitigation.

- [ ] **Step 4: Add capture, research, hidden branch, chapter, request, and ending contracts**

Use the four value axes `괴이 구제`, `민간인 보호`, `기관 명령 준수`, `진실 공개`. Record one linked request maximum and one independent request per chapter.

- [ ] **Step 5: Validate terminology**

Run:

```bash
rg -n "비전투 정체성|전통 RPG|턴제|이해도|포획|연구|히든|연계 의뢰|진실 공개" docs/planning/PROJECT_DIRECTION.md docs/GAME_DESIGN_DOCUMENT.md
```

Expected:

```text
No active statement defines the product as non-combat.
Turn-based recovery is described as pattern response rather than killing.
All approved systems are present in both documents at the appropriate level.
```

- [ ] **Step 6: Commit**

```bash
git add docs/planning/PROJECT_DIRECTION.md docs/GAME_DESIGN_DOCUMENT.md
git commit -m "docs: rebase game design around investigation and recovery"
```

### Task 3: Rebase status and MVP roadmap

**Files:**
- Modify: `docs/CURRENT_STATUS.md`
- Modify: `MVP_ROADMAP.md`

**Interfaces:**
- Consumes: approved core and current implementation baseline
- Produces: clear separation of implemented baseline and CORE-MVP-001~004 future track

- [ ] **Step 1: Preserve current implementation facts**

Keep the implemented baseline exactly as:

```text
MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A
Ver 4.2
save mvp-039
```

- [ ] **Step 2: Add approved but unimplemented status**

Mark the new core as `CORE_RECORDED` and `POC_PENDING`. List turn-based recovery, understanding, chapter conversion, capture research, hidden branches, and ending axes under `구현되지 않은 항목`.

- [ ] **Step 3: Add the four-stage MVP track**

Record:

```text
CORE-MVP-001 조사·이해도·회수 PoC
CORE-MVP-002 실패·부상·결과·포획·연구
CORE-MVP-003 기간제 챕터·세력 의뢰
CORE-MVP-004 연구 히든 분기·가치관 엔딩
```

- [ ] **Step 4: Reclassify previous plans**

Mark UX-PD-001 2B·2C and MVP-044~046 as `재평가 대기` or `구현 보류`. Do not delete their assets or describe them as implemented.

- [ ] **Step 5: Run document reference tests**

Run:

```bash
python -m pytest tests/test_active_document_references.py -q
python -m pytest tests/test_core_validation_contract.py -q
git diff --check
```

Expected:

```text
All tests pass.
git diff --check produces no output.
```

- [ ] **Step 6: Commit**

```bash
git add docs/CURRENT_STATUS.md MVP_ROADMAP.md
git commit -m "docs: add core mvp rebase roadmap"
```

### Task 4: Generate and verify the PDF brief

**Files:**
- Create locally: `도시괴담_기록국_프로젝트_코어_MVP_재기준화_2026-07-23.docx`
- Create locally: `도시괴담_기록국_프로젝트_코어_MVP_재기준화_2026-07-23.pdf`

**Interfaces:**
- Consumes: `docs/PROJECT_CORE.md`, `docs/GAME_DESIGN_DOCUMENT.md`, `MVP_ROADMAP.md`
- Produces: a user-readable PDF matching the repository documents

- [ ] **Step 1: Build the DOCX source**

Use `python-docx` with A4 portrait layout, Korean-capable fonts, a title page, heading hierarchy, compact tables, and page numbers.

- [ ] **Step 2: Render the DOCX to PDF and PNG**

Run:

```bash
python /home/oai/skills/docx/render_docx.py \
  /mnt/data/도시괴담_기록국_프로젝트_코어_MVP_재기준화_2026-07-23.docx \
  --output_dir /mnt/data/core_pdf_render \
  --emit_pdf
```

Expected:

```text
A non-empty PDF and one PNG per page are produced.
```

- [ ] **Step 3: Inspect every rendered page**

Confirm no clipped Korean text, broken tables, missing glyphs, overlaps, or footer collisions. Fix the DOCX and rerender until clean.

- [ ] **Step 4: Render the final PDF independently**

Run:

```bash
python /home/oai/skills/pdfs/scripts/render_pdf.py \
  /mnt/data/도시괴담_기록국_프로젝트_코어_MVP_재기준화_2026-07-23.pdf \
  --out_dir /mnt/data/core_pdf_verify \
  --dpi 200
```

Expected:

```text
Every PDF page renders successfully with no missing glyphs or clipping.
```

### Task 5: Final review and draft PR

**Files:**
- Review: all files changed in Tasks 1-3

**Interfaces:**
- Consumes: completed documentation diff and validation output
- Produces: draft PR for user review

- [ ] **Step 1: Check scope**

Run:

```bash
git status -sb
git diff --stat main...HEAD
git diff --check
```

Expected:

```text
Only the five active documents, one design specification, and one implementation plan are changed.
No runtime code, data, scene, asset, or save file is changed.
```

- [ ] **Step 2: Review for implementation claims**

Run:

```bash
rg -n "구현 완료|구현 확인|완료 기능" docs/PROJECT_CORE.md docs/planning/PROJECT_DIRECTION.md docs/GAME_DESIGN_DOCUMENT.md docs/CURRENT_STATUS.md MVP_ROADMAP.md
```

Expected:

```text
Current main facts are clearly separated from CORE-MVP future targets.
```

- [ ] **Step 3: Open a draft PR**

Use title:

```text
docs: rebase project core and MVP roadmap
```

Use a body that states:

```text
- records the user-approved CORE_RECORDED contract
- replaces the obsolete non-combat identity with investigation-linked turn-based recovery
- adds CORE-MVP-001~004 PoC roadmap
- keeps the current implementation baseline and mvp-039 unchanged
- defers MVP-044~046 for post-PoC remapping
```
