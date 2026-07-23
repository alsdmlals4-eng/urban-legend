# Skill Contract Hardening Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 프로젝트 분야·로컬·Base Skill의 선택 경계를 명확히 하고 Registry·본문·라우팅 문서·테스트가 같은 계약을 강제하도록 만든다.

**Architecture:** 기존 10개 분야 Skill과 사건 작성 로컬 Skill을 유지한다. `support_skills`에는 Base 지원 Skill만 허용하고 프로젝트 분야 간 관계는 `related_disciplines` 또는 `supporting_disciplines`로 표현하며, 로컬 Skill의 mode와 라우팅 예시는 자동 테스트로 검증한다.

**Tech Stack:** JSON Registry, Markdown Skill 계약, Python `unittest`, GitHub Actions.

## Global Constraints

- 게임 코드·데이터·Scene·승인 자산·저장 Schema·기존 ID는 변경하지 않는다.
- `docs/PROJECT_CORE.md`의 `IDENTIFIED` 상태와 프로젝트 코어를 변경하지 않는다.
- Base 25개 Skill 고정 커밋과 18개 Coverage는 유지한다.
- 주 프로젝트 분야 Skill은 한 시점에 최대 1개다.
- 실행하지 않은 Godot·수동 플레이 검증은 `NOT_RUN`으로 기록한다.

---

### Task 1: 라우팅 회귀 테스트 강화

**Files:**
- Modify: `tests/test_skill_package_integrity.py`

**Interfaces:**
- Consumes: `skills/SKILL_REGISTRY.json`, Skill 본문, `skills/BASE_SKILL_INDEX.json`
- Produces: 로컬 mode, Base 지원 계층, 관련 분야, 라우팅 예시 중복을 차단하는 회귀 테스트

- [x] 로컬 Skill의 모든 `skill_modes`가 본문에 존재하는 테스트를 추가한다.
- [x] 모든 `support_skills`가 Base Skill ID인지 검사한다.
- [x] `related_disciplines`가 유효한 프로젝트 분야이며 자기 자신을 가리키지 않는지 검사한다.
- [x] 동일 태그 조합의 라우팅 예시 중복을 차단한다.
- [ ] GitHub Actions에서 세 운영 계약 테스트가 실패하는지 확인한다.

### Task 2: Registry와 Skill 본문 계약 정렬

**Files:**
- Modify: `skills/SKILL_REGISTRY.json`
- Modify: `skills/urban-legend-investigation-case-authoring/SKILL.md`
- Modify: `skills/disciplines/urban-legend-audio/SKILL.md`
- Modify: `skills/disciplines/PROJECT_DISCIPLINE_CONTRACT.md`

**Interfaces:**
- Consumes: 기존 trigger·mode·정본·보호 계약
- Produces: Base 지원과 프로젝트 분야 인수인계를 분리한 Registry schema v5

- [x] 사건 작성 Skill의 `author / revise / fairness-review`를 본문에 명시한다.
- [x] 오디오 `support_skills`에서 프로젝트 UX Skill을 제거한다.
- [x] 오디오에 `related_disciplines: [urban-legend-ux-ui-accessibility]`를 등록한다.
- [x] 공통 계약에 `support_skills`와 `related_disciplines` 의미를 명시한다.
- [x] 중복 라우팅 예시를 제거하고 Skill 비선택 예시를 추가한다.

### Task 3: 운영 문서·학습 기록 동기화

**Files:**
- Modify: `docs/WORK_MODE_AND_SKILL_ROUTING.md`
- Modify: `skills/SKILL_LEARNING_LOG.md`

**Interfaces:**
- Consumes: Registry schema v5
- Produces: 새 AI와 작업자가 동일하게 해석할 사람용 계약

- [x] Base 지원 Skill과 관련 분야 인수인계를 문서화한다.
- [x] 실행 보고에 `related_discipline_handoffs`를 추가한다.
- [x] 발견·수행·보호·Base 승격 후보를 Learning Log에 기록한다.

### Task 4: Base 공용 불일치 제안 분리

**Files:**
- Create in Base proposal branch: `[수정제안서]/BCP-2026-07-23-active-skill-count-authority/PROPOSAL.md`

**Interfaces:**
- Consumes: Base Registry 25개와 `AGENTS.md`·`docs/OPERATING_MODEL.md`의 13개 표기 충돌
- Produces: 프로젝트 우회 없이 공용 원본에서 해결하는 수정제안서

- [ ] Base 수정제안서를 별도 브랜치와 PR로 제출한다.
- [ ] 제안 PR과 urban-legend 구현 PR을 분리한다.

### Task 5: 전체 참조·회귀 검증

**Files:**
- Verify: `tests/test_base_operating_sync.py`
- Verify: `tests/test_skill_package_integrity.py`
- Verify: `tests/test_active_document_references.py`

**Interfaces:**
- Consumes: Tasks 1~4 산출물
- Produces: CI 증거와 미검증 목록

- [ ] GitHub Actions 세 테스트 PASS를 확인한다.
- [ ] 변경 파일에 게임 런타임 경로가 없는지 확인한다.
- [ ] 구형 Skill ID·stale 경로·중복 라우팅 예시가 없는지 검사한다.
- [ ] Godot·수동 플레이는 런타임 변경 없음으로 `NOT_RUN` 기록한다.
