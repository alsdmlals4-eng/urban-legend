# 2026-08-21 Open Issue · Current Authority Freshness Correction

> Audit mode: `REVIEW → APPROVED_CORRECTION`
> Baseline main: `faaf7731dd9013eba1aa0944d24fc17dba3a6ae3`
> Baseline open PR: `0`
> Baseline open Issue: `35`
> Product gate: `PLAN_LOCK / RUNTIME_NOT_AUTHORIZED`

## 목적

월간 기획 PR #219 병합 뒤에도 과거 MVP·ANNUAL·Base 이관·UI 구현 Issue와 predecessor current 문서가 실행 가능한 현재 작업처럼 남아 있는 문제를 교정한다.

이번 교정은 **제품 코드·Scene·데이터·save·asset을 변경하지 않는다.** 완료·대체된 Issue는 원문을 보존한 채 close하고, 실제 미완료이며 현재 정본과 충돌하지 않는 Issue만 열린 상태로 유지한다.

## 판정 원칙

- `CLOSE_COMPLETED`: current main/merged PR/현재 Adapter 등으로 완료가 직접 확인됨.
- `CLOSE_NOT_PLANNED_SUPERSEDED`: 원래 Issue의 세부 완료 체크를 이번 감사에서 재인증하지 않으며, 후속 정본·후속 MVP·새 제품 구조가 현재 작업 권한을 대체함.
- `KEEP_OPEN_DEFERRED_VALID`: 실제 미완료이며 현재 정본과 충돌하지 않지만 PLAN_LOCK 때문에 지금 구현하지 않음.
- Issue를 닫아도 원문·댓글·PR/commit 계보는 GitHub history에 보존된다.
- Human QA가 미실행인 항목은 `완료`로 허위 승격하지 않는다. predecessor Validation Issue를 닫더라도 현재 Validation Router에서 Human `NOT_RUN`을 유지한다.

## 35개 Issue disposition

| Issue | 기존 역할 | 판정 | 근거 / successor |
|---:|---|---|---|
| #1 | MVP-002 데이터 구조 | `CLOSE_NOT_PLANNED_SUPERSEDED` | 현재 프로젝트가 MVP-043·CORE/Canon v2·월간 정본까지 전진. 원 Issue 체크리스트를 재인증하지 않고 역사 milestone로 종료. |
| #2 | 예약 Issue | `CLOSE_NOT_PLANNED_SUPERSEDED` | 실제 작업이 아니며 번호 정렬 목적 종료. |
| #3 | MVP-003 힌트/단서 | `CLOSE_NOT_PLANNED_SUPERSEDED` | 후속 조사/Canon v2/runtime에 흡수. |
| #4 | MVP-004 해결 진입 | `CLOSE_NOT_PLANNED_SUPERSEDED` | 후속 안정화·회수/Canon 계약으로 대체. |
| #5 | MVP-005 단서 자동효과·회수 | `CLOSE_NOT_PLANNED_SUPERSEDED` | 후속 회수 시스템과 current canon으로 대체. |
| #6 | MVP-006 결과·연구 | `CLOSE_NOT_PLANNED_SUPERSEDED` | 후속 결과·보고서·매뉴얼 구조로 대체. |
| #7 | MVP-007 플래그·저장 | `CLOSE_NOT_PLANNED_SUPERSEDED` | 현재 save/Validation persistence 계층이 별도 정본을 소유. |
| #8 | MVP-008 데이터 기반 대화·조사 | `CLOSE_NOT_PLANNED_SUPERSEDED` | 후속 데이터/scene 구조에 흡수. |
| #9 | MVP-009 미니게임 분기 | `CLOSE_NOT_PLANNED_SUPERSEDED` | 후속 대표 현장 검증/미니게임 정본으로 대체. |
| #10 | MVP-010 3성향 요원 | `CLOSE_NOT_PLANNED_SUPERSEDED` | 후속 요원/Canon 구조와 실제 data가 현재 책임을 소유. |
| #11 | MVP-011 조사 방법·지원·신뢰 | `CLOSE_NOT_PLANNED_SUPERSEDED` | 후속 조사 시스템·관계/지원 계약에 흡수. |
| #12 | MVP-012 조사 루프·괴이 상태 | `CLOSE_NOT_PLANNED_SUPERSEDED` | current investigation/recovery 정본으로 대체. |
| #13 | MVP-013 장비·기록물·연구 | `CLOSE_NOT_PLANNED_SUPERSEDED` | 후속 기록국/매뉴얼·준비 구조로 대체. |
| #14 | MVP-014 준비·로그 | `CLOSE_NOT_PLANNED_SUPERSEDED` | 후속 준비/UI·안내자 계약으로 대체. |
| #15 | MVP-015 두 번째 사건 골격 | `CLOSE_NOT_PLANNED_SUPERSEDED` | M04 빨간 우산 release-near 역할이 현재 정본을 소유. |
| #16 | MVP-016 요원 신뢰·이벤트 | `CLOSE_NOT_PLANNED_SUPERSEDED` | 관계는 current planning/narrative contract에서 관리. |
| #17 | MVP-017 사건 보고서 | `CLOSE_NOT_PLANNED_SUPERSEDED` | 후속 결과/DB/매뉴얼과 current product flow로 대체. |
| #18 | MVP-018 DB 탭 강화 | `CLOSE_NOT_PLANNED_SUPERSEDED` | 후속 기록 UI와 current flow로 대체. |
| #19 | MVP-019 빨간 우산 조사 | `CLOSE_NOT_PLANNED_SUPERSEDED` | M04 release-near Vertical Slice가 현재 successor. |
| #27 | MVP-020 회고·규칙 다이어트 | `CLOSE_NOT_PLANNED_SUPERSEDED` | 이후 Base/문서 lifecycle과 월간 canon integration이 successor. |
| #28 | MVP-021 메인/준비 UI | `CLOSE_NOT_PLANNED_SUPERSEDED` | 후속 Package/UI hierarchy 및 별도 #181 메인 메뉴 Decision으로 분리. |
| #29 | MVP-022 조사 UI | `CLOSE_NOT_PLANNED_SUPERSEDED` | PR #180 조사 hierarchy와 current UI contract가 successor. |
| #30 | MVP-023~027 통합 UI/저장 | `CLOSE_NOT_PLANNED_SUPERSEDED` | 후속 세분화 구현·검증 및 current canon으로 대체. |
| #31 | MVP-028 PC/Steam 팀 기반 회수 UX | `CLOSE_NOT_PLANNED_SUPERSEDED` | PR #180 + current investigation/recovery UI contract로 대체. |
| #44 | 미니게임·회수 책형 매뉴얼 | `CLOSE_NOT_PLANNED_SUPERSEDED` | 후속 요청형 manual drawer / UI hierarchy가 current 책임. |
| #92 | ANNUAL-MVP-002 Human Validation | `CLOSE_NOT_PLANNED_SUPERSEDED` | ANNUAL은 runtime/history ID. 현재 Human target은 M01 First Session + M04 Slice로 재라우팅. Human은 여전히 `NOT_RUN`. |
| #97 | v6 재기획 보류 후속 | `CLOSE_NOT_PLANNED_SUPERSEDED` | 월 1사건 current canon + PR #219가 successor. |
| #105 | CORE-MVP-001 신규 플레이어 검증 | `CLOSE_NOT_PLANNED_SUPERSEDED` | 현재 Validation Router가 M01/M04 책임을 다시 정의. Human은 `NOT_RUN`. |
| #112 | Base v9.1 Adapter 채택 | `CLOSE_COMPLETED` | current `PROJECT_BASE_ADAPTER.json`은 후속 Base v9.4.3 릴리스 구조를 채택. |
| #115 | 로컬 Skill route 보존 | `CLOSE_COMPLETED` | current Adapter/Registry에 project-local routes가 유지됨. |
| #119 | Base v9.3 이관 | `CLOSE_COMPLETED` | 프로젝트는 이미 후속 Base v9.4.3을 채택. v9.3 migration은 역사 단계. |
| #179 | 조사/회수 UI hierarchy 구현 | `CLOSE_COMPLETED` | PR #180 병합으로 successor runtime이 main에 존재. |
| #181 | 메인 메뉴 관제실 + Ver 4.3 중앙화 | `KEEP_OPEN_DEFERRED_VALID` | current main은 아직 `GAME_VERSION := "Ver 4.2"`. 유효 미완료지만 PLAN_LOCK으로 구현 보류. |
| #203 | Godot AI headless wrapper 회귀 | `CLOSE_COMPLETED` | current main `game_helper.gd`에 headless-safe wrapper와 `GODOT_AI_ALLOW_HEADLESS` 계약 존재; #196은 종료. |
| #212 | PR #211 Deduction/Recovery 추적 | `CLOSE_COMPLETED` | PR #211 내용이 통합 PR #219 / current canon에 흡수됨. |

## Current authority correction

### 1. `START_HERE.md`

- predecessor UI `NOT_STARTED` 값을 current truth로 고정하지 않는다.
- current decision overlay를 월간 canon 다음에 읽는다.
- old Issue `open` 상태만으로 구현 권한을 부여하지 않는다.

### 2. `AGENTS.md`

- `CURRENT_DECISION_OVERLAY.md`를 current mutable decision source로 추가한다.
- `CURRENT_CONFIRMED_DECISIONS.md`는 상세 승인·대체 역사 ledger로 유지한다.
- Base version 숫자/채택 commit의 중복 literal을 제거하고 `BASE_RULES_VERSION.md`를 단일 owner로 사용한다.

### 3. `VALIDATION_TARGET_CANON.md`

- current target을 M01 First Session과 M04 release-near Vertical Slice로 분리한다.
- 과거 2026-08-02 저승역 단일 Validation은 predecessor history로 남기되 current execution authority를 제거한다.

### 4. `DOCUMENTATION_MAP.md`

- current decision overlay와 current Validation Router를 활성 entrypoint에 반영한다.
- predecessor handoff/decision ledger를 필요할 때만 읽도록 분리한다.

## 보호 범위

이번 교정에서 변경 금지:

- `data/`
- `scripts/`
- `scenes/`
- `assets/`
- `addons/`
- `project.godot`
- save schema / Episode ID / report ID / ANNUAL runtime ID
- 실제 Human/runtime evidence

## Post-merge Issue mutation

문서 PR이 main에 병합된 뒤 exact main을 readback한 다음 이 표에 따라 Issue 상태를 변경한다. Issue 상태 변경 후 open Issue 수와 #181 상태를 다시 조회하고 Notion에 merge receipt를 동기화한다.

## 검증

- current-authority focused static contract
- existing `test_current_planning_canon.py`
- active-document references
- archive/legacy governance 해당 시 확인
- repository CI exact-head
- 5회 whole-scope adversarial review
- post-merge GitHub·Notion readback

Runtime/Human/device 검증은 제품 runtime을 변경하지 않으므로 이번 교정에서 `NOT_RUN`이다.