# GUT 9.7.1 Adoption Validation

## Status

```yaml
validation_id: UL-VAL-20260806-GUT-971-AUTHORITY-ENTRY-GATE
project: alsdmlals4-eng/urban-legend
decision_ids:
  - UL-DEC-ADDON-001
  - UL-DEC-AUTHORITY-001
  - UL-DEC-ENTRY-GATE-001
  - UL-DEC-LOCAL-VALIDATION-001
base_main_at_implementation_start: 47f1e86ea594c2f349d230b245192bae2de67eb0
recorded_preceding_head: 22ac24db211a5d474efcc49a73c2a5369698c1a7
current_head_binding: EXTERNAL_GITHUB_ACTIONS_AND_SHEET
adoption_state: ADOPTED_ACTIVE
promotion_to_adopted_active: APPROVED_BY_MERGED_MAIN_READBACK
promotion_pr_merge: EXTERNAL_GITHUB_AND_SHEET
local_windows_validation: PRECEDING_LOCAL_EVIDENCE_ONLY_NOT_CURRENT_PROMOTION_HEAD
android_device_export_validation: NOT_RUN
human_qa: NOT_RUN
ui_accessibility_qa: NOT_RUN
```

A tracked file cannot embed the SHA or merge state of the commit containing itself without changing that commit. Therefore this document records the preceding validated `main` head. Current exact-head and merge authority remain the GitHub pull-request or merged-main head plus Actions runs bound to that SHA and the synchronized Google Sheet state.

## Merged-main promotion evidence

The previously blocked merged-main readback is complete. The correction in PR #170 was validated on its exact candidate head and then revalidated after merge on `main`.

```yaml
preceding_main: 22ac24db211a5d474efcc49a73c2a5369698c1a7
full_matrix_run: 31131917318
full_matrix_result: SUCCESS
live_editor_run: 31131917489
live_editor_result: SUCCESS
gut_authority_run: 31131917325
gut_authority_job: 92722504253
gut_authority_result: SUCCESS
artifact_id: 8976370660
artifact_name: gut-test-authority-22ac24db211a5d474efcc49a73c2a5369698c1a7
artifact_digest: sha256:3f0c0fd5a2e9bb7a8a7608efa5c3c354f6ecfb5910d902de21566abf5d00177b
focused_contract_tests: 37
gut_tests: 5
gut_assertions: 17
junit_tests: 5
junit_failures: 0
junit_errors: 0
legacy_entrypoints: 58
canon_v2_entrypoints: 7
full_regression_entrypoints: 65
upstream_tree: MATCH_UPSTREAM_AEB5D4F3
protected_diff: PASS
sheet_readback: PASS
```

This evidence satisfies the GUT test-authority lifecycle promotion condition. It does not create Human QA, UI/accessibility QA, Android export/device, or product-image approval claims.

## 1. Scope

This validation covers the approved GUT 9.7.1 test-authority implementation only.

- HiGodot remains the sole Scene·Node·Resource·Project Settings authoring authority.
- GUT is limited to discovery, execution, assertions, doubles and JUnit evidence.
- The project entry gate fails closed when required decision, unresolved, image, GitHub, authority, GUT or Human QA evidence is missing or malformed.
- Product implementation requires GUT `EXACT_HEAD_VALIDATED` or `ADOPTED_ACTIVE`; `TRIAL_APPROVED` is sufficient only for test implementation.
- GUT execution must not mutate `project.godot`, `addons/`, `scripts/`, `scenes/`, `assets/` or `data/`.
- Product game logic, episode data, save schema, product scenes and product assets are outside this implementation scope.

## 2. Official GUT Identity

```yaml
repository: bitwes/Gut
branch: godot_4_7
commit: aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605
version: 9.7.1
compatible_godot: 4.7.x
license: MIT
project_license_path: addons/gut/LICENSE.md
installed_tree_result: MATCH_UPSTREAM_AEB5D4F3
```

The initial project payload did not match the complete official tree. The byte-level comparison found normalized text-resource differences and a different `source_code_pro.fnt` binary. The implementation restored `addons/gut/` from the exact official upstream commit rather than accepting the mismatch.

## 3. Test-First Evidence

### RED 1 — authority and mandatory entry gate

```yaml
head: 84ad99b857cb6e8a131678ad2670870a2ceeb22a
workflow_run: 31106997606
workflow_job: 92634640199
result: FAIL_AS_EXPECTED
summary: 395 tests; new authority and entry-gate ledgers and evaluator were absent.
```

### RED 2 — actual project GUT consumption and CI

```yaml
head: a8152d831d2573ae6a7475d8f12c1f429634149e
workflow_run: 31107883159
workflow_job: 92637809903
result: FAIL_AS_EXPECTED
summary: 400 tests; project GUT test, config, CI workflow and artifact ignore were absent.
existing_full_godot_regression: PASS
```

### RED 3 — complete official upstream identity

```yaml
head: 8d1861cb64cf8446df3416e1a9fca064efe11557
workflow_run: 31108950645
workflow_job: 92641392550
result: FAIL_AS_EXPECTED
initial_comparison_run: 31109084891
initial_comparison_job: 92641826645
initial_result: MISMATCH_UPSTREAM_AEB5D4F3
```

### RED 4 — exact PR HEAD evidence

```yaml
head: 3d47614fea6dba586a25b5dad66b90edb0077c8d
workflow_run: 31109576032
workflow_job: 92643563203
result: FAIL_AS_EXPECTED
summary: The workflow used the default pull-request merge ref rather than the exact PR head.
```

### RED 5 — adversarial evidence and gate integrity review

```yaml
head: 64717f9c5c8e7b97ba5ce99d32e072c9d172f9d4
workflow_run: 31112187375
workflow_job: 92652539451
result: FAIL_AS_EXPECTED
focused_contracts: 37
failures: 9
errors: 4
```

The RED 5 contracts detected only the newly reviewed deficiencies:

- malformed nested evidence raised an exception instead of returning a blocking result;
- negative and non-integer counts could be accepted;
- a non-hex 40-character value could be accepted as a SHA;
- `TRIAL_APPROVED` could authorize product implementation;
- HiGodot authority was incorrectly modeled as an add-on adoption lifecycle;
- the GUT ledger mislabeled preceding-head evidence as the latest exact head;
- recorded assertion and regression counts disagreed with the logs;
- merged `main` had no automatic GUT authority revalidation;
- test and regression logs did not produce a machine-readable summary.

## 4. Historical preceding exact-head evidence

```yaml
head: a03b8bb57fb5ba6486ba65c8700cc41ffd9bf08d
workflow: Validate GUT Test Authority
workflow_run: 31110321360
workflow_job: 92646106146
result: PASS
artifact_id: 8971437085
artifact_name: gut-test-authority-a03b8bb57fb5ba6486ba65c8700cc41ffd9bf08d
artifact_digest: sha256:43dffa37bdf28cfdec9ef3dc234274a4d629ae500e3a02414e1eb8ca7db2d608
artifact_expiry: 2026-08-20T14:22:26Z
```

Verified results from the historical workflow log:

| Gate | Result |
|---|---|
| exact PR head checkout | PASS |
| focused governance contracts | 25 PASS |
| Godot version | 4.7.1 PASS |
| clean Godot import | PASS |
| post-import protected-path diff | PASS |
| installed GUT vs exact upstream tree | MATCH |
| project-owned GUT tests | 5 PASS |
| GUT assertions | 17 PASS |
| JUnit file exists and is nonempty | PASS |
| post-GUT protected-path diff | PASS |
| legacy regression entrypoints | 58 PASS |
| Canon v2 focused entrypoints | 7 PASS |
| full Godot regression entrypoints | 65 PASS |
| final protected repository state | PASS |
| exact-head artifact upload | PASS |

The earlier `20 assertions` and `43 regression tests` claims were inaccurate summaries and are superseded by the log-derived values above.

## 5. Base Adapter and Generated Views

The prior protected baseline was stale relative to current `main`. Existing repository practice was followed:

1. set the canonical protected baseline to audited `main` `47f1e86...`;
2. use the official Base generator at trusted commit `bfdc9e44...`;
3. regenerate the project dashboard, adapter views and snapshot;
4. restore canonical adapter formatting so the semantic adapter change is the baseline SHA only.

```yaml
base_adapter_workflow_run: 31109687066
base_adapter_workflow_job: 92643911307
result: PASS
base_release_identity: 9.4.3
reviewed_base_main_policy_commit: 4f98f968a377f7b6a11aafa4fc94d11bddbebedc
policy_commit_role: REVIEWED_POLICY_EVIDENCE_NOT_RELEASE_IDENTITY
```

## 6. Authority and Entry-Gate Results

### HiGodot

```text
GODOT_AUTHORING / SOLE / ACTIVE_EDITOR_AUTHORITY
```

HiGodot authority is not an add-on adoption lifecycle claim. Its validation requirements remain reviewed project-settings mutation, Godot import/regression and local/Human QA where the requested scope requires them.

### GUT

```text
TEST_EXECUTION / NON_AUTHORING / ADOPTED_ACTIVE
```

GUT product mutation scope is empty. The lifecycle promotion is supported by exact merged-main revalidation, immutable Base-pilot validation, protected-state checks and canonical Sheet readback. Every future candidate still requires exact-head external GitHub and Sheet evidence.

### Entry gate

The evaluator returns exit code `0` only for a scoped `ENTRY_ALLOWED_FOR_*` result. Missing or malformed source objects, invalid counts, generic decision states, open P0/P1, image approval gaps, non-hex or mismatched exact heads, failed checks, open review threads, authority conflicts, scope-inadequate GUT states and required Human QA all return a blocking state and nonzero exit code.

The evaluator consumes a caller-supplied evidence snapshot. It does not independently fetch GitHub or Sheet data; those sources must be read and bound to the exact head before evaluation.

## 7. UID and Import Evidence

The remote Godot 4.7.1 workflow completed a clean import and found no protected tracked or untracked changes under `project.godot`, `addons/`, `scripts/`, `scenes/`, `assets/` or `data/`.

This supports:

```text
REMOTE_GODOT_4_7_1_IMPORT_PASS_ON_RECORDED_HEAD
REMOTE_UID_RESOURCE_STABILITY_PASS_ON_RECORDED_HEAD
```

It does not replace local Windows editor/runtime execution or Android export/device validation.

## 8. Claim Ceiling

```text
GUT_9_7_1_ADOPTED_ACTIVE_ON_RECORDED_PRECEDING_MAIN
GUT_OFFICIAL_UPSTREAM_TREE_MATCH_VERIFIED_ON_RECORDED_HEAD
HIGODOT_SOLE_AUTHORING_CONTRACT_IMPLEMENTED
GUT_TEST_ONLY_CONTRACT_IMPLEMENTED
MANDATORY_ENTRY_GATE_IMPLEMENTED
CURRENT_EXACT_HEAD_EXTERNAL_REVALIDATION_REQUIRED
INDEPENDENT_CODE_REVIEW_NOT_RUN
LOCAL_WINDOWS_VALIDATION_NOT_RUN_ON_CURRENT_PROMOTION_HEAD
ANDROID_DEVICE_EXPORT_NOT_RUN
HUMAN_QA_NOT_RUN
UI_ACCESSIBILITY_QA_NOT_RUN
PROMOTION_PR_MERGE_STATE_EXTERNAL
```
