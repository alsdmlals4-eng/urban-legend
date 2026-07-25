# ANNUAL-MVP-001 Four-Week Month Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** ANNUAL-MVP-001을 4주 × 주당 3슬롯 월간 루프로 전환하고, 4주차 활동 결과 확인 직후 긴급 강제 출동을 실행한다.

**Architecture:** 기존 격리 PoC의 데이터 중심 계약과 상태 머신을 유지한다. 시간 값은 JSON과 검증기가 소유하고, 상태 머신은 `deadline_week`를 기준으로 2·3주차 자율 결정과 4주차 강제 전환을 분리한다. 저장 payload와 CORE adapter는 변경하지 않는다.

**Tech Stack:** Godot 4.7.1, GDScript, JSON, Python `unittest`, Bash, GitHub Actions

## Global Constraints

- 1개월은 4주다.
- 주당 활동 슬롯은 3개이며 최대 12슬롯이다.
- 2주차 자율 출동 위험은 0이다.
- 3주차 자율 출동 위험은 15다.
- 4주차 활동 결과 확인 뒤 강제 출동 위험은 30이다.
- `scripts/core/game_state.gd`, `data/episodes/**`, `project.godot`, `knowledge/base-pack/**`를 변경하지 않는다.
- `annual-mvp-001-save-v1`, `mvp-039`, `mvp-038` 계약을 변경하지 않는다.
- 기존 활동·동료·스킬·장비·연구 ID를 변경하지 않는다.
- 자동 회귀만으로 `POC_PASSED` 또는 제작 확대를 선언하지 않는다.

---

### Task 1: 승인 설계와 추적선 고정

**Files:**
- Create: `docs/superpowers/specs/2026-07-25-annual-mvp-001-four-week-month-design.md`
- Create: `docs/superpowers/plans/2026-07-25-annual-mvp-001-four-week-month-implementation-plan.md`
- Create: `docs/goals/CODEX_GOAL_ANNUAL_MVP_001_FOUR_WEEK_MONTH.md`
- Modify: `docs/CURRENT_STATUS.md`

- [ ] GitHub Issue와 작업 브랜치를 생성한다.
- [ ] 승인 설계·계획·Codex Goal을 커밋한다.

### Task 2: 데이터 계약 Red → Green

**Files:**
- Modify: `tests/test_annual_mvp_001_data_contract.py`
- Modify: `tests/annual_mvp_001_data_test.gd`
- Modify: `data/poc/annual_mvp_001/spring_vertical_slice.json`
- Modify: `scripts/poc/annual_mvp_001/annual_mvp_001_data.gd`

- [ ] `annual-mvp-001-v2`, `max_weeks=4`, `deadline_week=4`, 총 12슬롯을 기대하는 실패 테스트를 먼저 작성한다.
- [ ] Python과 Godot Red 실패를 확인한다.
- [ ] JSON과 런타임 검증기를 최소 변경한다.
- [ ] 데이터 계약 Green을 확인한다.

### Task 3: 상태 머신 Red → Green

**Files:**
- Modify: `tests/annual_mvp_001_state_test.gd`
- Modify: `scripts/poc/annual_mvp_001/annual_mvp_001_state.gd`

- [ ] 3주차 지연 뒤 4주차 계획으로 이동하는 실패 테스트를 작성한다.
- [ ] 4주차 활동 3개와 결과 확인 뒤 `annual_forced_deployment` 이벤트, 위험 30, `PREPARATION`을 기대한다.
- [ ] `deadline_week` 기반 전이로 구현한다.
- [ ] 강제 경로 결산 `weeks_used=4`를 확인한다.

### Task 4: UI·저장 호환성

**Files:**
- Modify: `scripts/poc/annual_mvp_001/annual_mvp_001_scene.gd`
- Modify: `tests/annual_mvp_001_scene_test.gd`
- Modify: `tests/annual_mvp_001_save_data_test.gd`
- Modify: `tests/test_annual_mvp_001_static_contract.py`

- [ ] 주차 분모를 config의 `max_weeks`에서 읽는다.
- [ ] 3주차 안내에 4주차 3슬롯과 위험 30을 명시한다.
- [ ] 기존 `annual-mvp-001-save-v1` 복원 계약을 유지한다.
- [ ] 렌더링·포인터 QA 수정이 보존되는지 정적 계약으로 확인한다.

### Task 5: 활성 정본과 생성물 동기화

**Files:**
- Modify: `docs/CURRENT_STATUS.md`
- Modify: `docs/CURRENT_HANDOFF.md`
- Modify: `docs/PROJECT_CORE.md`
- Modify: `docs/GAME_DESIGN_DOCUMENT.md`
- Modify: `docs/planning/PROJECT_DIRECTION.md`
- Modify: `docs/planning/ROADMAP_AND_HANDOFF.md`
- Modify: `MVP_ROADMAP.md`
- Modify: `TEST_CHECKLIST.md`
- Regenerate: `docs/URBAN_LEGEND_GAME_DESIGN.docx`

- [ ] 현재형 시간 계약을 4주로 변경한다.
- [ ] 기존 3주 QA는 `HISTORICAL` 근거로만 남긴다.
- [ ] GDD DOCX를 재생성하고 `--check`로 동기화를 검증한다.

### Task 6: 전체 검증·PR·병합

- [ ] Python 데이터·정적·활성 문서 계약을 실행한다.
- [ ] Godot 4.7.1 import를 실행한다.
- [ ] CORE-MVP-001 focused suite를 실행한다.
- [ ] ANNUAL-MVP-001 focused suite를 실행한다.
- [ ] 전체 Godot 회귀를 실행한다.
- [ ] 현재형 3주 월간 참조 감사를 수행한다.
- [ ] PR을 열고 changed-file·review thread·CI를 검토한다.
- [ ] 사용자 승인 범위에 따라 squash merge한다.
- [ ] 병합 후 `main` 상태와 Issue를 동기화한다.

## 완료 상태 경계

이 계획의 완료는 4주 월간 구조의 코드·문서·자동 검증·GitHub 통합을 뜻한다. 사람 사용성 QA, 신규 플레이어 검증, `POC_PASSED`, `annual_loop_passed`, 제작 확대는 별도 게이트다.
