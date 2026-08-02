# Package 1 Retarget·Merge Gate

> Decision: `D-2026-08-02-PACKAGE-1-IMPLEMENTATION-APPROVAL`
> Merge authorization: user-approved on 2026-08-02
> Documentation canon PR: #125
> Implementation PR: #126

## Canon merge

```text
PR #125 head: b3d38576b37c60fd36c1b7bdc9018803b917c000
main merge commit: 595d45454621900e858a903fef0598a03349b794
method: merge commit
result: MERGED
```

PR #125 contained the approved Validation canon, Package 1 planning approval, Grill Me persistence decision, Design Spec approval, Implementation Plan, and implementation approval record. Product paths changed by PR #125 were zero.

PR #122 remains a superseded provenance source and is explicitly excluded from merging because it is marked `SOURCE / DO NOT MERGE AS-IS` and is non-mergeable.

## Implementation retarget

PR #126 was retargeted from `agent/v9-4-canon-reconciliation` to `main` after PR #125 merged.

Retargeted diff boundary:

```text
base: main@595d45454621900e858a903fef0598a03349b794
head before this gate record: fd37396fa9133cdcfe0c7b50f471cfb355e9d2a1
merge base: b3d38576b37c60fd36c1b7bdc9018803b917c000
status: mergeable
```

The retargeted diff contains only Package 1 implementation, tests, workflow wiring, and implementation evidence. It excludes the already-merged canon documents from PR #125.

## Pre-merge adversarial checks

- current main exact SHA checked
- PR #125 and #126 metadata checked
- all open PRs checked
- PR #125 and #126 unresolved review threads: zero
- PR #125 and #126 submitted reviews: zero
- Google Sheet exact decision rows checked
- Google Sheet comments: zero
- PR #122 exclusion confirmed
- Package 1 scope checked against changed-file inventory
- Human/New-player/Visual QA remains `NOT_RUN`
- POC remains `NOT_DECLARED`

## Revalidation requirement

This record intentionally moves PR #126 HEAD after retargeting. The new HEAD must pass:

- documentation/static contracts
- Godot 4.7.1 import
- Validation Package 1 focused 4/4
- CORE focused
- ANNUAL-MVP-001 and ANNUAL-MVP-002 focused suites
- full Godot regression 53/53

Only after fresh post-retarget CI succeeds and the final GitHub·Sheet adversarial check remains clean may PR #126 be merged.

## Future Grill Me merge cadence

The user approved this operating rule:

```text
Count approved Grill Me decisions.
At each 10-decision boundary, run a final GitHub + Google Sheet adversarial reconciliation.
Merge the approved decision canon and its separately approved implementation PRs when all required checks pass.
Never merge superseded/source-only/blocked PRs merely to satisfy the count.
```

The count is based on approved Decision IDs, not question attempts or rejected alternatives. This policy requires an authoritative counter and merge-batch record in a follow-up operational Decision after Package 1 lands.
