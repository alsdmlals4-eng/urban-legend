# GUT 9.7.1 Test Framework and Mandatory Entry Gate Implementation Plan

> **Basis contract:** `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION v4.3`
>
> **Execution method:** test-first, exact-HEAD evidence, GPT role-separated review, user-authority gate.

## Status

```yaml
plan_id: UL-PLAN-20260806-GUT-971-AUTHORITY-ENTRY-GATE-V43
project: alsdmlals4-eng/urban-legend
decision_ids:
  - UL-DEC-ADDON-001
  - UL-DEC-AUTHORITY-001
  - UL-DEC-ENTRY-GATE-001
basis_contract: v4.3
prerequisite_baseline_pr: 168
prerequisite_baseline_merge: 375c742bc278b07bac18960710a4cb29156c3578
design_pr: 166
implementation_pr_candidate: 167
plan_state: READY_FOR_IMPLEMENTATION_AFTER_DESIGN_SPEC_MERGE
product_paths_changed_by_plan: false
local_windows_access: BLOCKED_NO_LOCAL_ACCESS
human_qa: NOT_RUN
android_export_device: NOT_RUN
```

## 1. Goal

GUT 9.7.1을 괴이기록국의 공식 Godot 테스트 프레임워크로 채택하되, HiGodot의 Godot 저작 권위와 GUT의 테스트 실행 권위를 분리하고 모든 L1+ 작업을 fail-closed 진입 게이트로 통제한다.

이 계획은 다음 오해를 허용하지 않는다.

- 플러그인 파일이 존재하면 채택이 완료됐다는 주장
- 과거 PR 또는 merge-ref 결과를 current exact HEAD 결과로 재사용
- HiGodot 권위를 GUT add-on adoption lifecycle로 모델링
- 저장소 안의 파일이 자신을 포함한 current commit SHA를 권위 있게 선언
- `TRIAL_APPROVED`만으로 제품 구현 진입
- 누락되거나 malformed된 evidence를 PASS로 간주
- 수동으로 센 assertion·regression 수치를 정본으로 기록
- 자동화 결과를 Human QA PASS로 대체

## 2. v4.3 Entry Order

다음 순서를 변경하지 않는다.

1. 보호 기준선 정합 PR을 exact HEAD에서 검증·병합한다.
2. GUT 채택 명세 Draft PR을 최신 merged main 위에서 검토·병합한다.
3. 구현 PR을 명세가 병합된 main 위에 재기준화한다.
4. 구현 exact HEAD에서 import, GUT, JUnit, 전체 회귀, protected diff, upstream tree, governance contracts를 재실행한다.
5. GPT-A/B/C 역할 분리 검토와 열린 P0/P1·review thread 검사를 통과한다.
6. Decision ID와 exact SHA를 GitHub와 Google Sheet에 동기화한다.
7. merged main을 다시 읽고 main-triggered validation을 확인한 뒤 lifecycle을 재판정한다.

명세 PR이 병합되지 않은 구현 PR은 자동 검증이 성공해도 `BLOCKED_BY_GUT_ADOPTION_SPEC`다.

## 3. Non-Negotiable Authority Model

### 3.1 HiGodot

```text
authority: GODOT_AUTHORING
authority_cardinality: SOLE
authority_state: ACTIVE_EDITOR_AUTHORITY
```

HiGodot은 Scene·Node·Resource·Project Settings 저작 권위다. HiGodot은 GUT adoption lifecycle의 대상이 아니므로 `adoption_state`, `TRIAL_APPROVED`, `ADOPTED_ACTIVE`, `latest_exact_head_validation`을 갖지 않는다.

허용 범위:

- Scene·Node·Resource 생성·편집·저장
- reviewed `project.godot` 변경
- 제품 GDScript 저작

금지 범위:

- 테스트 실패 은폐
- GUT/JUnit 증거 변조
- Human QA PASS 대체

### 3.2 GUT

```text
authority: TEST_EXECUTION
authority_cardinality: NON_AUTHORING
allowed_product_mutations: []
```

허용 범위:

- test discovery와 execution
- assertion, double, stub, spy
- JUnit·test log 생성
- 실패 시 nonzero exit

금지 범위:

- `project.godot`, `addons/`, `scripts/`, `scenes/`, `assets/`, `data/` 정본 수정
- HiGodot mutation command 호출
- 실제 사용자 save 또는 APPDATA 원본 수정
- failure를 success로 변환

생성물은 `.artifacts/gut/` 또는 격리된 `user://test_runs/`로 제한한다.

## 4. GUT Identity Contract

```yaml
repository: bitwes/Gut
branch: godot_4_7
commit: aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605
version: 9.7.1
compatible_godot: 4.7.x
project_godot_target: 4.7.1
license: MIT
license_path: addons/gut/LICENSE.md
```

검증은 `plugin.cfg`와 license text에 그치지 않는다. CI에서 official upstream commit을 별도 checkout하고 `addons/gut/` 전체 tree를 `git diff --no-index --exit-code`로 비교한다.

## 5. Adoption Lifecycle

```text
CANDIDATE
→ TRIAL_APPROVED
→ CONSUMPTION_IMPLEMENTED
→ EXACT_HEAD_VALIDATED
→ ADOPTED_ACTIVE
```

비정상 상태:

```text
DEGRADED
REMOVAL_PENDING
REMOVED
```

### `TRIAL_APPROVED`

필요 증거:

- source, exact version, upstream commit
- license, compatible Godot range
- authority scope
- planned project consumption
- CI and rollback design

### `CONSUMPTION_IMPLEMENTED`

필요 증거:

- project-owned `GutTest`
- deterministic discovery config or exact CLI
- JUnit output path
- CI workflow
- protected-diff gate

### `EXACT_HEAD_VALIDATED`

필요 증거:

- exact PR HEAD checkout
- Godot 4.7.1 import PASS
- focused GUT PASS
- JUnit nonempty, zero failure/error
- governance contracts PASS
- maintained full Godot regression PASS
- upstream tree MATCH
- protected tracked and untracked diff PASS
- evidence artifact bound to exact SHA

### `ADOPTED_ACTIVE`

`EXACT_HEAD_VALIDATED` 이후 merged main 재검증과 GitHub·Sheet exact-SHA readback까지 완료된 상태다.

저장소 tracked file은 자신을 포함한 commit SHA를 self-reference할 수 없다. 따라서 ledger에는 다음을 분리한다.

```text
recorded_preceding_validation: historical evidence
current_head_binding: EXTERNAL_GITHUB_ACTIONS_AND_SHEET
```

`latest_exact_head_validation`이라는 self-referential tracked field를 사용하지 않는다.

## 6. Task 1 — RED Authority Contracts

Create:

- `tests/test_godot_tool_authority_contract.py`
- `docs/operations/GODOT_TOOL_AUTHORITY_LEDGER.json`

RED tests must fail until the ledger proves:

- enabled plugins are declared;
- GUT exact identity is pinned;
- HiGodot is the only `GODOT_AUTHORING` authority;
- HiGodot uses `authority_state`, not add-on adoption lifecycle;
- GUT has zero product mutation scope;
- protected paths are explicit;
- GUT consumption, CI and rollback paths exist;
- current exact-head authority is external;
- recorded validation is explicitly preceding/historical.

Expected RED:

```bash
python -m unittest tests.test_godot_tool_authority_contract -v
```

Expected: FAIL before ledger creation or when any lifecycle/authority field overlaps.

GREEN ledger rules:

```json
{
  "current_exact_head_authority": {
    "mode": "EXTERNAL_GITHUB_ACTIONS_AND_SHEET"
  },
  "tools": [
    {
      "tool_id": "higodot",
      "authority": "GODOT_AUTHORING",
      "authority_state": "ACTIVE_EDITOR_AUTHORITY"
    },
    {
      "tool_id": "gut",
      "authority": "TEST_EXECUTION",
      "adoption_state": "CONSUMPTION_IMPLEMENTED",
      "allowed_product_mutations": [],
      "current_head_binding": "EXTERNAL_GITHUB_ACTIONS_AND_SHEET",
      "recorded_preceding_validation": {
        "state": "PASS"
      }
    }
  ]
}
```

The exact preceding commit/run/artifact values are written only after those runs exist.

## 7. Task 2 — RED Fail-Closed Entry Gate

Create:

- `docs/operations/PROJECT_ENTRY_GATE.json`
- `tools/governance/evaluate_project_entry_gate.py`
- `tests/test_project_entry_gate_contract.py`

Required source objects:

```text
decision
unresolved
images
github
authority
gut
human_qa
```

Structural validation runs before business rules.

Block as `ENTRY_BLOCKED_MISSING_SOURCE` when:

- evidence root is not an object;
- a required source is absent or not an object;
- counts are bool, string, float, null, or negative;
- `required` flags are not booleans;
- scope is unknown.

GitHub evidence is valid only when:

- `head` and `evidence_head` are strings;
- both are the same 40-character hexadecimal SHA;
- checks are `PASS`;
- open review thread count is a nonnegative integer equal to zero.

Generic current authorization states remain forbidden:

```text
READY
AWAITING
CANON_READY
IMPLEMENTATION_PLAN_READY
AUTOMATED_PACKAGE_READY
```

### Scope-specific GUT thresholds

```yaml
DOCS_ONLY:
  - TRIAL_APPROVED
  - CONSUMPTION_IMPLEMENTED
  - EXACT_HEAD_VALIDATED
  - ADOPTED_ACTIVE
TEST_IMPLEMENTATION:
  - TRIAL_APPROVED
  - CONSUMPTION_IMPLEMENTED
  - EXACT_HEAD_VALIDATED
  - ADOPTED_ACTIVE
PRODUCT_IMPLEMENTATION:
  - EXACT_HEAD_VALIDATED
  - ADOPTED_ACTIVE
IMAGE_GENERATION:
  - CONSUMPTION_IMPLEMENTED
  - EXACT_HEAD_VALIDATED
  - ADOPTED_ACTIVE
IMAGE_IMPLEMENTATION:
  - EXACT_HEAD_VALIDATED
  - ADOPTED_ACTIVE
```

`TRIAL_APPROVED` must never authorize product implementation.

Required RED cases:

- missing source
- malformed nested source
- negative count
- non-integer count
- open P0/P1
- generic decision state
- image required but product approval missing
- mismatched SHA
- non-hex SHA
- failed checks
- open review thread
- authority conflict
- product scope with trial-only GUT
- required Human QA not run
- blocked CLI returns nonzero

## 8. Task 3 — Project-Owned GUT Consumption

Create:

- `tests/gut/test_validation_route_mapper.gd`
- `.gutconfig.json`

Target:

```text
scripts/core/validation_route_mapper.gd
ValidationRouteMapper
```

Required cases:

| Input | Expected result |
|---|---|
| `SIT-001`, `active` | `OK`, `dialogue`, dialogue scene |
| `SIT-004`, `suspended` | `OK`, `investigation`, investigation scene |
| `SIT-003`, `active` | `NOT_AVAILABLE` |
| unknown stage | `UNKNOWN_FLOW_STAGE` |
| invalid lifecycle | `INVALID_LIFECYCLE` |

Canonical CLI:

```bash
godot --headless -d -s --path "$PWD" addons/gut/gut_cmdln.gd \
  -gdir=res://tests/gut \
  -ginclude_subdirs \
  -gexit \
  -gjunit_xml_file=.artifacts/gut/junit.xml
```

No tests discovered, nonzero exit, missing JUnit, or JUnit failure/error must fail CI.

## 9. Task 4 — Exact-HEAD Workflow

Create:

- `.github/workflows/validate-gut-test-authority.yml`
- `tests/test_gut_test_authority_ci_contract.py`

Required triggers:

- pull request paths relevant to GUT/authority/gate
- push to `main` for the same relevant paths
- manual dispatch

Exact candidate expression:

```yaml
${{ github.event.pull_request.head.sha || github.sha }}
```

Required stages:

1. checkout exact candidate SHA;
2. checkout exact official GUT upstream commit;
3. record candidate SHA;
4. setup Godot 4.7.1 and Python;
5. run focused governance contracts;
6. clean import and protected-path stability check;
7. capture pre-GUT repository state;
8. compare complete official GUT tree;
9. run GUT and capture stdout log;
10. verify JUnit;
11. enforce GUT non-authoring boundary;
12. run maintained full regression and capture stdout log;
13. derive machine-readable summary from logs/JUnit;
14. verify final protected state;
15. upload exact-head artifact.

Protected paths:

```bash
git diff --exit-code -- project.godot addons scripts scenes assets data
git status --porcelain --untracked-files=all -- project.godot addons scripts scenes assets data
```

## 10. Task 5 — Machine-Readable Evidence

The workflow writes:

```text
.artifacts/gut/candidate-sha.txt
.artifacts/gut/workflow-sha.txt
.artifacts/gut/gut-output.log
.artifacts/gut/full-regression.log
.artifacts/gut/junit.xml
.artifacts/gut/upstream-tree-compare.txt
.artifacts/gut/upstream-tree-result.txt
.artifacts/gut/status-before.txt
.artifacts/gut/status-after.txt
.artifacts/gut/status-final.txt
.artifacts/gut/summary.json
```

`summary.json` is parsed from actual output, not handwritten documentation.

Required fields:

```json
{
  "candidate_sha": "<exact sha>",
  "gut_tests": 0,
  "gut_assertions": 0,
  "junit_tests": 0,
  "junit_failures": 0,
  "junit_errors": 0,
  "legacy_entrypoints": 0,
  "canon_v2_entrypoints": 0,
  "full_regression_entrypoints": 0,
  "upstream_tree": "MATCH_UPSTREAM_<PIN>",
  "protected_diff": "PASS"
}
```

The parser fails if expected summary lines are absent, JUnit disagrees with GUT, or any maintained regression subgroup is incomplete.

## 11. Task 6 — Official Payload Remediation

If installed `addons/gut/` differs from the exact upstream tree:

1. preserve mismatch evidence as RED;
2. do not normalize only selected text files;
3. restore the complete official tree from the pinned commit;
4. rerun import, tree compare, GUT, JUnit and full regression;
5. keep product paths unchanged.

Binary differences such as font payloads are treated as real mismatches.

## 12. Task 7 — Base Adapter and Generated Views

Protected-baseline reconciliation is a prerequisite PR, separate from the GUT design and implementation PRs.

Canonical change:

```text
skills/PROJECT_BASE_ADAPTER.json#/protected_baseline/commit
```

Generated views may change only in canonical adapter provenance/hash fields unless an independently approved Base adoption change exists.

Do not mix these into the design PR. If the implementation PR inherited the same generated view changes before the prerequisite merged, rebase it after merged-main readback and confirm whether those changes disappear from its diff.

## 13. Task 8 — Documentation and Sheet Sync

Create/update only after exact-head evidence exists:

- `docs/validation/GUT_9_7_1_ADOPTION_VALIDATION.md`
- PR body current-head evidence
- Google Sheet rows using the same Decision IDs

Validation documentation must distinguish:

```text
recorded preceding head
current exact PR head
merged main head
local Windows
Android export/device
Human QA
UI/accessibility QA
```

Never claim `ADOPTED_ACTIVE` before merged-main readback.

## 14. GPT Role-Separated Review

### GPT-A — specification compliance

- verifies v4.3 sequence;
- checks source/version/license/compatibility;
- checks authority cardinality and lifecycle;
- checks requested scope against entry-gate result.

### GPT-B — adversarial risk

- searches for mutation overlap;
- malformed evidence bypass;
- stale/self-referential SHA claims;
- manual result-count drift;
- merge-ref mistaken for exact head;
- missing rollback;
- product or save mutation;
- Human QA overclaim.

### GPT-C — integration and release

- checks exact changed files;
- all exact-head workflows;
- review threads and P0/P1;
- Sheet readback;
- merged-main revalidation;
- claim ceiling.

One GPT account may record role-separated COMMENT reviews. It must not misrepresent them as independent human review.

## 15. Merge Rules

A PR may merge only when:

- exact head has not moved since validation;
- all triggered checks are `completed/success`;
- infrastructure failures are rerun and separately classified;
- review threads are zero;
- P0/P1 findings are zero;
- required predecessor PRs are merged;
- current entry gate is allowed for the requested scope;
- Sheet and GitHub do not conflict on the Decision ID and exact SHA.

Under v4.3, a user-directed current-conversation recommended change may use automatic merge after every condition above is satisfied. This does not authorize unrelated PRs or bypass exact-head checks.

## 16. Local and Human Validation Limits

Remote CI supports import, GUT, JUnit, regression and protected-diff claims only.

Without access to the declared Windows project path, report:

```text
LOCAL_SYNC_BLOCKED_NO_LOCAL_ACCESS
GODOT_RUN_BLOCKED_NO_LOCAL_ACCESS
```

Unless actually executed, retain:

```text
ANDROID_EXPORT_DEVICE_NOT_RUN
HUMAN_QA_NOT_RUN
UI_ACCESSIBILITY_QA_NOT_RUN
```

## 17. Removal and Rollback

Triggers:

- incompatible Godot release;
- security or licensing concern;
- persistent CI instability;
- authority violation;
- no continuing project consumption.

Steps:

1. set GUT lifecycle to `REMOVAL_PENDING`;
2. open a dedicated reviewed PR;
3. disable `res://addons/gut/plugin.cfg` through HiGodot or explicitly reviewed project-settings edit;
4. remove `addons/gut/` only after equivalent test coverage exists;
5. remove config/workflow only after replacement evidence path exists;
6. preserve historical JUnit and validation artifacts;
7. run Godot 4.7.1 import and maintained full regression;
8. set lifecycle to `REMOVED` with reason/replacement;
9. synchronize GitHub and Sheet.

## 18. Acceptance Criteria

The implementation is acceptable only when all are true:

- GUT identity matches the complete pinned upstream tree;
- HiGodot is sole authoring authority and is not in add-on lifecycle;
- GUT product mutation scope is empty;
- one project-owned GUT consumer runs;
- deterministic CLI and JUnit exist;
- malformed or missing evidence blocks without exceptions;
- invalid counts and non-hex SHA block;
- product scope rejects trial-only GUT;
- exact PR head and merged main are both revalidated;
- GUT and regression counts come from logs/JUnit;
- protected tracked/untracked diff is empty;
- Decision IDs and exact SHA are synchronized;
- local, Android, Human QA and accessibility claims remain honest;
- no episode data, save schema, narrative, balance or product asset changes occur;
- `ADOPTED_ACTIVE` is not claimed before merged-main readback.

## 19. Claim Ceiling Before Final Merge

```text
GUT_ADOPTION_SPEC_MERGED
GUT_CONSUMPTION_IMPLEMENTED_ON_DRAFT
REMOTE_EXACT_HEAD_VALIDATED
PRODUCT_GAME_PATHS_UNCHANGED
ADOPTED_ACTIVE_NOT_CLAIMED
LOCAL_SYNC_BLOCKED_NO_LOCAL_ACCESS
GODOT_RUN_BLOCKED_NO_LOCAL_ACCESS
ANDROID_EXPORT_DEVICE_NOT_RUN
HUMAN_QA_NOT_RUN
UI_ACCESSIBILITY_QA_NOT_RUN
IMPLEMENTATION_MERGE_REQUIRES_CURRENT_GATE
```
