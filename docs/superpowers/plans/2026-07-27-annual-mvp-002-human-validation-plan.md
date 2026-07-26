# ANNUAL-MVP-002 Human Validation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** ANNUAL-MVP-002의 반복 사용성·신규 플레이어 증거를 동일 빌드에서 수집하고, 행동 관찰과 자기보고를 분리해 Gate 2 다음 판정을 만든다.

**Architecture:** 검증 설계 정본, 실행 패키지, 세션별 증거, 통합 결과 보고서를 분리한다. 먼저 기준 빌드를 고정하고 자동·시각 회귀를 확인한 뒤 반복 사용성 세션과 신규 플레이어 세션을 순차 실행한다. 결과는 Finding으로 라우팅하고 사용자 승인 전 제품 게이트 상태를 변경하지 않는다.

**Tech Stack:** Godot 4.7.1, GDScript 프로젝트 빌드, PC 16:9, 키보드·마우스, Markdown 증거 문서, GitHub Issue·PR·Actions.

## Global Constraints

- 주인공 권나래 고정.
- 4주 × 주당 7일 유지.
- 일정별 1~3일, 주차 경계 초과 금지.
- 출동 위험 0/15/30 유지.
- `annual-mvp-001-save-v1`, `mvp-039`, `mvp-038` 비침범.
- CORE 핵심 단서·정답·미관측 패턴 자동 제공 금지.
- `충격 완화`, `위험 억제`만 활성 공용 지원으로 검증.
- `교차 색인`은 관측·가설 보드 계약 전 비활성 유지.
- 실제 사람 증거 전 `POC_PASSED`, `annual_loop_passed`, 제작 확대 미선언.
- 참가자 실명과 연락처를 저장소에 기록하지 않음.

---

## File Map

| 파일 | 책임 |
|---|---|
| `docs/superpowers/specs/2026-07-27-annual-mvp-002-human-validation-design.md` | 검증 목적·가설·범위·판정 계약 |
| `docs/qa/ANNUAL_MVP_002_HUMAN_VALIDATION_PACKAGE.md` | 진행자 스크립트·관찰지·설문·게이트 체크리스트 |
| `docs/qa/evidence/annual_mvp_002_human_validation/SESSION-<번호>.md` | 세션 한 건의 환경·행동·개입·설문 증거 |
| `docs/qa/2026-07-27_ANNUAL_MVP_002_HUMAN_VALIDATION_RESULTS.md` | 모든 세션의 통합 결과·Finding·게이트 판정 |
| `docs/CURRENT_STATUS.md` | 실제 검증 상태와 다음 게이트 |
| `docs/DECISION_LOG.md` | KEEP·AMPLIFY·CHANGE·RETEST·HOLD 결정 |
| `docs/planning/ROADMAP_AND_HANDOFF.md` | 다음 작업과 금지된 선행 확장 |

### Task 1: 기준 빌드 동결과 사전 회귀

**Files:**
- Read: `docs/CURRENT_STATUS.md`
- Read: `docs/qa/ANNUAL_MVP_002_HUMAN_VALIDATION_PACKAGE.md`
- Create after verification: `docs/qa/evidence/annual_mvp_002_human_validation/BUILD_BASELINE.md`

**Interfaces:**
- Consumes: `main`의 최신 병합 상태와 PR #91 자동·시각 QA 증거.
- Produces: 모든 사람 세션이 참조할 단일 커밋 SHA·빌드 ID·환경 계약.

- [ ] **Step 1: main 최신 상태 확인**

```bash
git fetch origin
git switch main
git pull --ff-only origin main
git status --short
git rev-parse HEAD
```

Expected: worktree가 깨끗하고 `git rev-parse HEAD`가 검증 기준 SHA로 기록된다.

- [ ] **Step 2: 기준선 문서 생성**

`BUILD_BASELINE.md`에 다음 실제 값을 기록한다.

```yaml
commit_sha: <git rev-parse HEAD 출력>
build_id: human-validation-001
godot_version: 4.7.1
platform: PC
resolution_targets:
  - 1280x720
  - 1920x1080
input: KEYBOARD_MOUSE
entry_route: MAIN_MENU_F1_ANNUAL_MVP_002
documentation_validation: NOT_RUN
annual_validation: NOT_RUN
visual_validation: NOT_RUN
human_sessions: NOT_RUN
```

각 `NOT_RUN`은 실제 검사 후에만 `PASSED` 또는 `FAILED`로 변경한다.

- [ ] **Step 3: 기존 문서 계약 workflow 실행**

GitHub Actions에서 `Validate documentation contracts`를 기준 커밋으로 실행한다.

Expected: workflow 결론 `success`. 실패하면 사람 세션을 시작하지 않고 로그와 실패 파일을 Issue #92에 기록한다.

- [ ] **Step 4: ANNUAL 자동 검증 workflow 실행**

GitHub Actions에서 `Validate ANNUAL-MVP-001` 계열의 현행 ANNUAL 검증 workflow를 기준 커밋으로 실행한다.

Expected: Python 계약, Godot 4.7.1 import, CORE focused, ANNUAL-MVP-001 focused, ANNUAL-MVP-002 focused, 전체 Godot 회귀가 모두 PASS.

- [ ] **Step 5: 시각·포인터 workflow 실행**

GitHub Actions에서 현행 Visual workflow를 기준 커밋으로 실행한다.

Expected: F1 진입, 키보드, 포인터, 1280×720, 1920×1080가 PASS하고 artifact ID가 생성된다.

- [ ] **Step 6: 기준선 문서 갱신과 커밋**

실제 run 번호·artifact ID·결론을 `BUILD_BASELINE.md`에 기록한다.

```bash
git add docs/qa/evidence/annual_mvp_002_human_validation/BUILD_BASELINE.md
git commit -m "test: freeze ANNUAL-MVP-002 human validation build"
```

### Task 2: 반복 사용성 세션 2회 실행

**Files:**
- Read: `docs/qa/ANNUAL_MVP_002_HUMAN_VALIDATION_PACKAGE.md`
- Create: `docs/qa/evidence/annual_mvp_002_human_validation/SESSION-U01.md`
- Create: `docs/qa/evidence/annual_mvp_002_human_validation/SESSION-U02.md`

**Interfaces:**
- Consumes: Task 1 기준 빌드.
- Produces: 반복 편성, 저장·복귀, 연구 조작의 행동 증거 두 건.

- [ ] **Step 1: SESSION-U01 헤더 작성**

패키지의 세션 헤더를 복사하고 `session_type: REPEATED_USABILITY`로 기록한다. 커밋 SHA·빌드 ID·해상도·입력·녹화 상태를 실제 값으로 채운다.

- [ ] **Step 2: 사전 점검 수행**

패키지 2절의 모든 체크박스를 확인한다. 실패 항목이 있으면 세션을 무효 처리하고 `invalid_reason`을 기록한다.

- [ ] **Step 3: U01 한 달 흐름 실행**

패키지의 과제 1~7을 순서대로 수행한다. 반복 편성 과제에서는 지난주 복사, 템플릿, 실행 취소, 전체 초기화를 각각 한 번 이상 사용한다.

Expected: 행동 타임라인, 개입, 저장·복귀, 연구, 2·3·4주 출동 결과가 기록된다.

- [ ] **Step 4: U01 관찰 요약 작성**

패키지의 `핵심 결과 요약` YAML을 실제 관찰값으로 작성한다. 추정값을 쓰지 않는다.

- [ ] **Step 5: SESSION-U02 독립 실행**

새 저장 상태로 U01과 같은 과제를 다시 수행한다. U01의 효율 조합이나 발견 위치를 진행자가 알려주지 않는다.

- [ ] **Step 6: 두 세션의 반복 마찰 비교**

각 세션 끝에 다음을 기록한다.

- 가장 오래 걸린 반복 작업
- 자발적으로 선택된 반복 도구
- 저장·복귀 혼란
- 연구 시작·취소·완료 마찰
- 동일 마찰의 재현 여부

- [ ] **Step 7: 반복 사용성 증거 커밋**

```bash
git add docs/qa/evidence/annual_mvp_002_human_validation/SESSION-U01.md docs/qa/evidence/annual_mvp_002_human_validation/SESSION-U02.md
git commit -m "test: record ANNUAL-MVP-002 repeated usability sessions"
```

### Task 3: 신규 플레이어 세션 최소 3회 실행

**Files:**
- Create: `docs/qa/evidence/annual_mvp_002_human_validation/SESSION-N01.md`
- Create: `docs/qa/evidence/annual_mvp_002_human_validation/SESSION-N02.md`
- Create: `docs/qa/evidence/annual_mvp_002_human_validation/SESSION-N03.md`
- Optional after minimum: `SESSION-N04.md`, `SESSION-N05.md`

**Interfaces:**
- Consumes: Task 1과 동일 빌드, Task 2에서 수정하지 않은 상태.
- Produces: 설명 없는 첫 진입, 4주 완주, 지원·연구·정답 비대체 이해 증거.

- [ ] **Step 1: 참가자 적격성 기록**

각 세션에서 `prior_exposure`를 기록한다. 프로젝트 멤버이거나 이전 빌드 규칙을 상세히 아는 참가자는 신규 플레이어 최소 표본에 포함하지 않는다.

- [ ] **Step 2: 소개문만 제공**

패키지 3절 소개문 외에 4주 구조, 자동 휴식, 동료 효과, 지원 확률, 연구 규칙을 설명하지 않는다.

- [ ] **Step 3: 과제 1~7 실행**

각 세션은 같은 순서와 개입 규칙을 사용한다. 세션 중 UI·데이터·밸런스를 수정하지 않는다.

- [ ] **Step 4: 행동 관찰 작성**

시간, 화면, 행동, 발화, 개입을 기록한다. 진행자 해석을 플레이어 발화처럼 쓰지 않는다.

- [ ] **Step 5: 사후 설문 작성**

행동 관찰을 닫은 뒤 별도 섹션에 1~5점과 자유 답변을 기록한다.

- [ ] **Step 6: 세션 유효성 판정**

커밋·빌드·시간·개입·중단 원인이 모두 기록된 세션만 유효로 센다. 유효 신규 플레이어가 3명 미만이면 `REPEAT_VALIDATION`을 기록하고 Gate 판정을 진행하지 않는다.

- [ ] **Step 7: 신규 플레이어 증거 커밋**

```bash
git add docs/qa/evidence/annual_mvp_002_human_validation/SESSION-N*.md
git commit -m "test: record ANNUAL-MVP-002 new player sessions"
```

### Task 4: Finding 통합과 적대적 재검토

**Files:**
- Create: `docs/qa/2026-07-27_ANNUAL_MVP_002_HUMAN_VALIDATION_RESULTS.md`
- Read: 모든 `SESSION-*.md`

**Interfaces:**
- Consumes: 유효 세션 전체.
- Produces: 가설별 결과, P0~P3 Finding, 게이트 후보 판정.

- [ ] **Step 1: 행동과 자기보고 분리 집계**

각 가설 HV-01~HV-08에 대해 다음 구조로 작성한다.

```yaml
hypothesis_id: HV-01
observed_behavior:
player_self_report:
contradiction:
evidence_sessions:
result: KEEP | AMPLIFY | CHANGE | RETEST | HOLD | UNVERIFIED
```

- [ ] **Step 2: Finding 생성**

패키지의 Finding 형식을 사용한다. 크래시·저장·진행 불가는 `CRITICAL`, 핵심 규칙 오해와 정답 비대체 위반은 `HIGH` 이상으로 검토한다.

- [ ] **Step 3: 비판 사실성 재검증**

각 Finding에 대해 다음을 확인한다.

- 두 세션 이상에서 재현되었는가?
- 한 세션만이라도 저장·진행 불가처럼 즉시 차단할 문제인가?
- 진행자 개입 때문에 발생한 현상인가?
- 개인 선호를 규칙 실패로 잘못 분류하지 않았는가?
- 더 단순한 설명 또는 최소 변경이 있는가?

- [ ] **Step 4: 게이트 후보 판정**

패키지 10절을 적용한다.

- P0 하나라도 실패: `HOLD`
- 최소 표본 미달: `REPEAT_VALIDATION`
- 핵심 경험 다수 실패: `REWORK`
- 핵심 가설 유효, 비차단 개선만 존재: `APPROVED_WITH_CONDITIONS` 후보
- 모든 필수 증거와 P0 통과: `APPROVED` 후보

사용자 승인 전 후보 상태로만 기록한다.

- [ ] **Step 5: 결과 보고서 커밋**

```bash
git add docs/qa/2026-07-27_ANNUAL_MVP_002_HUMAN_VALIDATION_RESULTS.md
git commit -m "test: report ANNUAL-MVP-002 human validation results"
```

### Task 5: 정본·Context·게이트 동기화

**Files:**
- Modify: `docs/CURRENT_STATUS.md`
- Modify: `docs/DECISION_LOG.md`
- Modify: `docs/planning/ROADMAP_AND_HANDOFF.md`
- Modify when required by Documentation Map: `docs/PROJECT_CORE.md`
- Modify when required by approved design change: `docs/GAME_DESIGN_DOCUMENT.md`

**Interfaces:**
- Consumes: Task 4 결과와 사용자 게이트 결정.
- Produces: 저장소 정본의 일관된 현행 상태와 다음 작업.

- [ ] **Step 1: 사용자 결정 기록**

Issue #92에 결과 보고서 링크, 가설 결과, P0/P1, 게이트 후보를 게시한다. `USER_DECISION_REQUIRED`가 있으면 한 번에 하나의 충돌만 선택지·장단점·권장안으로 제시한다.

- [ ] **Step 2: CURRENT_STATUS 갱신**

실제 세션 수, 기준 커밋, 결과 보고서, 사람 사용성 상태, 신규 플레이어 상태, `POC_PASSED`, `annual_loop_passed`, 제작 확대 상태를 기록한다. 실행하지 않은 항목은 `NOT_RUN` 또는 `UNVERIFIED`로 유지한다.

- [ ] **Step 3: Decision Log 갱신**

각 가설을 `KEEP / AMPLIFY / CHANGE / RETEST / HOLD`로 기록하고 근거 세션을 연결한다.

- [ ] **Step 4: Roadmap과 Handoff 갱신**

- `HOLD` 또는 `REWORK`: 최소 수정 패키지와 재검증을 다음 작업으로 지정.
- `REPEAT_VALIDATION`: 부족한 표본·시나리오만 추가.
- 사용자 `APPROVED`: 다음 승인 작업을 별도 Issue로 생성하되 ANNUAL-MVP-003 자동 착수 금지.

- [ ] **Step 5: 문서 회귀 실행**

GitHub Actions의 문서 계약 workflow를 실행한다.

Expected: 활성 참조, archive, planning sync, Base/Skill 계약 PASS.

- [ ] **Step 6: 최종 커밋과 PR**

```bash
git add docs/CURRENT_STATUS.md docs/DECISION_LOG.md docs/planning/ROADMAP_AND_HANDOFF.md docs/PROJECT_CORE.md docs/GAME_DESIGN_DOCUMENT.md
git diff --check
git commit -m "docs: sync ANNUAL-MVP-002 human validation gate"
git push -u origin <validation-results-branch>
```

결과 PR에는 세션 수, 기준 빌드, 자동 검사, 사람 증거, Finding, 미실행 검사, 게이트 후보를 기록한다. 사용자 승인 없이 병합하지 않는다.

## Verification Before Completion

완료 보고 전에 다음을 확인한다.

- [ ] 세션 파일 수와 결과 보고서의 표본 수가 일치한다.
- [ ] 모든 세션이 동일 기준 빌드를 사용하거나 차이가 명시되어 있다.
- [ ] 행동 관찰과 자기보고가 별도 필드다.
- [ ] `POC_PASSED`, `annual_loop_passed`, 제작 확대가 사용자 승인 없이 변경되지 않았다.
- [ ] P0 Finding이 숨겨지거나 평균 점수로 상쇄되지 않았다.
- [ ] 실행하지 않은 녹화·사람 검수·정책 검사는 `NOT_RUN`이다.
- [ ] `git diff --check`와 문서 계약 workflow가 PASS다.
- [ ] PR changed files가 계획 범위와 일치한다.
