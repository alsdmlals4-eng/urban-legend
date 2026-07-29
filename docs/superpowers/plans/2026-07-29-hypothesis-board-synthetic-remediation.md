# Hypothesis Board Synthetic Remediation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 가설 보드 사람 검증 Artifact에서 진행자 교육 효과·관계 라벨 오해·최소 노동 전략을 분리한다.

**Architecture:** 저승역 사건 JSON과 상태 머신은 유지한다. 모든 최초 배제·관계 연결·최종 증명을 저장하기 전에는 정답 교정을 제공하지 않고, 관계마다 관측 근거와 이유를 기록하며 반례 또는 미해결 하나를 최종 증명에 포함한다.

**Tech Stack:** Markdown 연구 계약, documentation contract CI

## Global Constraints

- 실제 사건 정답률·재미·사용성을 검증했다고 주장하지 않는다.
- `human_validation: NOT_RUN`, `implementation_authority: NONE` 유지.
- 사건 JSON·Scene·상태 머신·Save Schema·JSONL 계약 변경 금지.

---

### Task 1: Artifact 교정

**Files:**
- Modify: `docs/superpowers/plans/2026-07-29-hypothesis-board-human-validation-artifact.md`

**Interfaces:**
- Consumes: `docs/research/2026-07-29-hypothesis-board-synthetic-tester-report.md`
- Produces: no-correction first attempt, 관계 이유 문장, 반례·미해결 최종 증명 계약

- [ ] **Step 1:** current main·Base Governance metadata를 갱신한다.
- [ ] **Step 2:** 단계 1 교정을 모든 first-attempt 관계·최종 증명 저장 뒤로 이동한다.
- [ ] **Step 3:** `지지/반박/미해결`을 확신도가 아닌 논리 관계로 설명하는 문장 보조를 추가한다.
- [ ] **Step 4:** 최종 증명에 가장 강한 반례 또는 유효한 미해결 하나를 요구한다.
- [ ] **Step 5:** 사건 공정성과 보드 UX를 분리하는 기록·판정 항목을 추가한다.

### Task 2: 검증과 병합

**Files:**
- Verify: branch diff
- Verify: documentation contracts CI

**Interfaces:**
- Consumes: Task 1 Artifact
- Produces: 사건 정본 비침범과 문서 계약 통과 증거

- [ ] **Step 1:** 변경 파일이 계획과 Artifact에 한정되는지 확인한다.
- [ ] **Step 2:** Validate documentation contracts 성공을 확인한다.
- [ ] **Step 3:** 미해결 리뷰 스레드가 없는지 확인한다.
- [ ] **Step 4:** 검증된 HEAD를 squash merge한다.
