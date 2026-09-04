# HiGodot–GUT Authority Separation and Mandatory Entry Gate Design

## Status

```yaml
design_id: UL-DESIGN-20260806-HIGODOT-GUT-ENTRY-GATE
decision_ids:
  - UL-DEC-ADDON-001
  - UL-DEC-AUTHORITY-001
  - UL-DEC-ENTRY-GATE-001
project: alsdmlals4-eng/urban-legend
base_main_at_design: 47f1e86ea594c2f349d230b245192bae2de67eb0
design_state: APPROVED_DIRECTION_RECORDED
implementation_state: NOT_RUN
gut_adoption_phase: TRIAL_APPROVED
merge_authority: REQUIRE_EXPLICIT_EXACT_HEAD_APPROVAL
human_qa: NOT_RUN
ui_accessibility_qa: NOT_RUN
```

## 1. Goal

괴이기록국의 Godot 저작 자동화와 테스트 실행을 서로 다른 권위로 분리한다.

- **HiGodot**은 Godot Scene·Node·Resource·Project Settings를 실제로 생성·편집·저장하는 단일 저작 권위다.
- **GUT 9.7.1**은 저작 결과와 순수 로직을 검증하는 공식 테스트 프레임워크다.
- 두 도구는 같은 파일을 임의로 수정하거나 서로의 역할을 대체하지 않는다.
- 누락 방지는 체크리스트가 아니라 결정·미확정·이미지·exact-HEAD 증거가 불충분하면 실행을 중단하는 필수 진입 게이트다.

## 2. Approved Decisions

### `UL-DEC-ADDON-001 — ADOPT_GUT_9_7_1`

GUT 9.7.1을 괴이기록국의 정식 Godot 테스트 프레임워크로 채택한다.

채택 결정은 즉시 `ADOPTED_ACTIVE`를 뜻하지 않는다. 현재 lifecycle은 다음과 같다.

```text
ADOPTED_BY_DECISION
→ TRIAL_APPROVED
→ CONSUMPTION_IMPLEMENTED
→ EXACT_HEAD_VALIDATED
→ ADOPTED_ACTIVE
```

### `UL-DEC-AUTHORITY-001 — HIGODOT_AUTHORING / GUT_TEST_ONLY`

HiGodot과 GUT의 권위는 도구 이름이 아니라 수행 가능한 mutation 종류로 구분한다.

### `UL-DEC-ENTRY-GATE-001 — MANDATORY_BLOCKING_GATE`

결정 원장만 보거나 단독 `READY`를 신뢰하지 않는다. 작업 범위에 필요한 모든 권위 표면을 읽고 조건을 충족하지 못하면 작업 진입을 차단한다.

## 3. GUT Source, Version, License, Compatibility

### 3.1 Official source

```yaml
repository: https://github.com/bitwes/Gut
branch: godot_4_7
verified_upstream_commit: aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605
commit_message: Version bump, documentation for 9.7.1 release (#847)
plugin_cfg_version: 9.7.1
compatible_godot: 4.7.x
project_godot_target: 4.7.1
license: MIT
license_path: addons/gut/LICENSE.md
```

### 3.2 Verified project evidence

- 프로젝트 `addons/gut/plugin.cfg`는 version `9.7.1`을 선언한다.
- 프로젝트 `addons/gut/LICENSE.md`에는 upstream과 같은 MIT license text가 존재한다.
- `project.godot`에서 `res://addons/gut/plugin.cfg`가 활성화되어 있다.

### 3.3 Evidence limit

다음은 아직 검증되지 않았다.

```text
INSTALLED_GUT_TREE_MATCHES_UPSTREAM_COMMIT = NOT_RUN
GUT_PROJECT_TEST_CONSUMPTION = NOT_IMPLEMENTED
GUT_CLI_CI_EXECUTION = NOT_RUN
GUT_JUNIT_ARTIFACT = NOT_RUN
GUT_PROTECTED_DIFF_GATE = NOT_RUN
```

`plugin.cfg`와 license 일치만으로 전체 설치본이 upstream commit과 동일하다고 주장하지 않는다.

## 4. Authority Model

### 4.1 Authority matrix

| Operation | HiGodot | GUT | CI/Governance | Human |
|---|---:|---:|---:|---:|
| Scene 생성·편집·저장 | ALLOW | DENY | DENY | REVIEW |
| Node 추가·삭제·속성 변경 | ALLOW | DENY | DENY | REVIEW |
| Resource 생성·편집·저장 | ALLOW | DENY | DENY | REVIEW |
| `project.godot` 설정 변경 | ALLOW, approval-gated | DENY | VERIFY | APPROVE |
| 제품 GDScript 작성·수정 | ALLOW | DENY | VERIFY | REVIEW |
| 테스트 스크립트 작성 | ALLOW or code-authoring agent | TEST_CONSUMER | VERIFY | REVIEW |
| 테스트 검색·실행 | OPTIONAL | ALLOW | ALLOW | OBSERVE |
| assertion·double·spy | DENY | ALLOW | VERIFY | OBSERVE |
| JUnit 결과 생성 | DENY | ALLOW | COLLECT | REVIEW |
| 테스트 실패를 PASS로 변경 | DENY | DENY | DENY | DENY |
| Human QA PASS 대체 | DENY | DENY | DENY | ALLOW only after execution |

### 4.2 HiGodot allowed scope

HiGodot은 다음을 수행할 수 있다.

- `.tscn`, `.scn`, `.tres`, `.res` 생성·변경
- Scene Tree와 Node property 변경
- Resource 연결과 해제
- `project.godot`의 autoload, input, display, plugin 설정 변경
- Godot editor에서 필요한 import·저장 작업

보호 경로 변경은 별도 PR, exact HEAD 검증, rollback을 요구한다.

### 4.3 GUT allowed scope

GUT은 다음을 수행할 수 있다.

- `tests/gut/` 아래 test script 검색
- 대상 class·scene의 격리 instance 생성
- method 호출과 assertion
- double, stub, spy
- test report와 JUnit XML 생성
- 실패 시 nonzero exit code 반환

### 4.4 GUT forbidden scope

GUT test 또는 hook은 다음을 수행하면 안 된다.

- `project.godot` 수정
- `addons/`, `scripts/`, `scenes/`, `assets/`, `data/` 정본 파일 수정
- 에피소드 JSON, clue, flag, answer, save schema 수정
- HiGodot mutation command 호출
- 실제 사용자 save 또는 APPDATA 원본 수정
- 실패를 catch하고 성공 exit code로 변환
- CI 밖에서 생성한 결과를 current HEAD 결과로 재사용

테스트 쓰기는 격리된 temporary directory 또는 `user://test_runs/<run_id>/`에만 허용한다.

## 5. GUT Adoption Lifecycle

### 5.1 States

```text
CANDIDATE
TRIAL_APPROVED
CONSUMPTION_IMPLEMENTED
EXACT_HEAD_VALIDATED
ADOPTED_ACTIVE
DEGRADED
REMOVAL_PENDING
REMOVED
```

### 5.2 Transition conditions

#### `TRIAL_APPROVED`

필수 증거:

- source repository
- exact version
- upstream commit
- license
- compatible Godot range
- authority scope
- planned consumption path
- CI design
- rollback procedure

#### `CONSUMPTION_IMPLEMENTED`

필수 증거:

- project-owned `GutTest` file
- `.gutconfig.json` or exact CLI arguments
- CI workflow path
- JUnit output path
- protected-diff check

#### `EXACT_HEAD_VALIDATED`

필수 증거:

- Godot 4.7.1 import success
- focused GUT pass
- existing Python contract pass
- existing full Godot regression pass
- protected tracked diff empty
- JUnit artifact collected
- result tied to exact commit SHA

#### `ADOPTED_ACTIVE`

`EXACT_HEAD_VALIDATED`를 만족하고 adoption ledger·GitHub status·Google Sheet가 같은 Decision ID와 SHA로 동기화된 상태다.

## 6. Initial Project Consumption Path

첫 GUT 소비자는 Scene이나 save mutation이 아니라 순수하고 안정적인 routing contract로 제한한다.

```text
target: scripts/core/validation_route_mapper.gd
class: ValidationRouteMapper
test: tests/gut/test_validation_route_mapper.gd
```

필수 assertion:

| Input | Expected |
|---|---|
| `SIT-001`, `active` | `OK`, `dialogue`, `res://scenes/dialogue_scene.tscn` |
| `SIT-004`, `suspended` | `OK`, `investigation`, `res://scenes/investigation_scene.tscn` |
| `SIT-003`, `active` | `NOT_AVAILABLE` |
| unknown stage, `active` | `UNKNOWN_FLOW_STAGE` |
| `SIT-001`, invalid lifecycle | `INVALID_LIFECYCLE` |

이 테스트는 제품 파일을 쓰지 않고 GUT의 실제 소비 경로와 exit code를 증명한다.

## 7. CLI and CI Contract

### 7.1 Canonical CLI

```bash
godot --headless -d -s --path "$PWD" addons/gut/gut_cmdln.gd \
  -gdir=res://tests/gut \
  -ginclude_subdirs \
  -gexit \
  -gjunit_xml_file=.artifacts/gut/junit.xml
```

Windows runner는 같은 argument 의미를 유지하며 executable path만 platform-specific으로 사용한다.

### 7.2 CI stages

```text
1. checkout exact HEAD
2. verify GUT source/version/license ledger
3. record protected-path baseline
4. Godot 4.7.1 import
5. run focused GUT
6. collect JUnit
7. run existing Python contracts
8. run existing full Godot regression
9. verify protected tracked diff is empty
10. publish evidence with exact SHA
```

### 7.3 Required failure conditions

- GUT exits nonzero
- no tests discovered
- JUnit missing
- JUnit has failure/error
- protected tracked diff exists
- authority ledger missing or incomplete
- installed GUT identity mismatch
- Godot version is not 4.7.x
- current SHA differs from evidence SHA
- generic `READY` is used as entry authorization

### 7.4 Protected-diff command

```bash
git diff --exit-code -- project.godot addons scripts scenes assets data
```

Untracked files under protected paths are also checked separately with `git status --short`.

## 8. Mandatory Entry Gate

### 8.1 Inputs

Every L1+ task must read:

1. `02_현재_확정결정`
2. `04_누락_충돌_감사`
3. current open-decision/unconfirmed records
4. `71_이미지기획_생성목록`
5. `72_이미지검수_승인로그`
6. GitHub exact HEAD and PR metadata
7. required checks and review threads
8. task-specific runtime/Human QA evidence

### 8.2 Scope-aware result states

```text
ENTRY_ALLOWED_FOR_DOCS_ONLY
ENTRY_ALLOWED_FOR_TEST_IMPLEMENTATION
ENTRY_ALLOWED_FOR_PRODUCT_IMPLEMENTATION
ENTRY_ALLOWED_FOR_IMAGE_GENERATION
ENTRY_ALLOWED_FOR_IMAGE_IMPLEMENTATION
ENTRY_BLOCKED_OPEN_P0_P1
ENTRY_BLOCKED_OPEN_DECISION
ENTRY_BLOCKED_IMAGE_EVIDENCE
ENTRY_BLOCKED_EXACT_HEAD_EVIDENCE
ENTRY_BLOCKED_AUTHORITY_CONFLICT
ENTRY_BLOCKED_GUT_CONSUMPTION
ENTRY_BLOCKED_HUMAN_QA
ENTRY_BLOCKED_MISSING_SOURCE
```

### 8.3 Block rules

Entry is blocked when any required source is missing or any condition below is true.

- P0/P1 open
- Decision unapproved or ambiguous
- historical READY is the only permission evidence
- image required but status is `PLANNED`, `BLOCKED_BY_DEMO`, blank, `NOT_RUN`, `OPEN_P2`, or `NOT_PRODUCT_ASSET`
- product image approval, rights, similarity, or runtime verification missing
- GUT needed but consumption or CI not implemented
- HiGodot/GUT role conflict
- protected-path diff from test execution
- exact HEAD checks absent
- Human QA required but `NOT_RUN`

Missing data is `BLOCKED`, not PASS.

## 9. Status Normalization

Standalone current authorization states below are forbidden.

```text
READY
AWAITING
CANON_READY
IMPLEMENTATION_PLAN_READY
AUTOMATED_PACKAGE_READY
```

They may remain in immutable historical text only when accompanied by `HISTORICAL_RECORD / NOT_CURRENT_ENTRY_AUTHORITY`.

Preferred replacements:

```text
CANON_APPROVED / IMPLEMENTATION_NOT_AUTHORIZED
PLAN_RECORDED / EXECUTION_REQUIRES_CURRENT_GATE
AUTOMATED_PACKAGE_AVAILABLE / HUMAN_QA_NOT_RUN
PLANNING_WIREFRAME_REVIEWED / OPEN_P2 / NOT_PRODUCT_ASSET
BRIEF_APPROVED / IMAGE_NOT_GENERATED / PRODUCT_APPROVAL_NOT_STARTED
```

## 10. Image Authority Rules

### `71_이미지기획_생성목록`

This tab plans images. It does not approve product assets.

### `72_이미지검수_승인로그`

Product image readiness requires explicit values for:

- planning match
- actual-screen readability
- implementation feasibility
- consistency
- rights/similarity
- errors and requested fixes
- approval state
- GitHub/asset path
- runtime verification

Blank fields do not mean approval.

`UL-IMG-007` remains planning-wireframe evidence, not a product asset.

## 11. Removal and Rollback Procedure

GUT is a formal dependency, but removal remains possible.

### Removal trigger

- incompatibility with required Godot release
- unmaintained security or licensing issue
- persistent CI instability
- authority violation
- no continuing project consumption path

### Removal steps

1. mark ledger `REMOVAL_PENDING`;
2. disable `res://addons/gut/plugin.cfg` through HiGodot or reviewed config edit;
3. remove `addons/gut/` in a dedicated PR;
4. remove `.gutconfig.json` and GUT workflow only after replacement tests exist;
5. preserve historical JUnit and adoption evidence;
6. run import and full regression;
7. mark ledger `REMOVED` with replacement or reason.

Rollback must never delete product tests without an equivalent validation path.

## 12. UID Separation

GUT adoption does not validate the direct-commit `.uid` changes.

UID validation requires:

- Godot 4.7.1 import
- resource parse and load
- full regression
- post-import diff review
- exact SHA evidence

Unexpected UID or resource rewrites are P0/P1 findings based on affected authority.

## 13. Non-goals

This design does not:

- implement tests or workflow;
- modify `project.godot`;
- modify GUT files;
- approve current `main` as validated;
- validate UID changes;
- perform Human QA;
- approve image product assets;
- merge any PR.

## 14. Acceptance Criteria for the Design PR

- exactly two docs-only files changed;
- authority matrix has no overlapping mutation authority;
- official GUT identity and evidence limit recorded;
- lifecycle prevents immediate `ADOPTED_ACTIVE` claim;
- representative consumption path is concrete;
- CLI, JUnit, no-authoring diff, and CI failure conditions are explicit;
- entry gate reads decisions, unresolved state, image planning, image review, and GitHub evidence;
- generic READY/AWAITING are forbidden as current authorization;
- rollback is complete;
- product implementation, local validation, Human QA, and merge remain `NOT_RUN/NOT_AUTHORIZED`.
