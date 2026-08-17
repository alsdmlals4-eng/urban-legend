# Tool Hub v2 identity migration design

Date: 2026-08-17
Project: `alsdmlals4-eng/urban-legend`
Base source of truth: current completed `main`

## Problem

The live Windows Base Tool Hub discovered the local `urban-legend` repository but rejected registration with `IDENTITY_MIGRATION_REQUIRED`.

Root-cause trace:

1. Tool Hub registration calls the canonical project identity validator.
2. Windows identity validation reads `skills/PROJECT_BASE_ADAPTER.json`.
3. The validator requires `schema_version == 2`; otherwise it fails closed with `IDENTITY_MIGRATION_REQUIRED`.
4. `urban-legend/main` currently has a valid v1 adapter (`schema_version: 1`) and has no canonical `project.project_id` field.
5. Base already provides the deterministic `migrate_adapter_v1_to_v2()` contract: validate v1, copy it, change `schema_version` to `2`, add the explicitly approved canonical `project_id`, then validate against the v2 schema.

This is therefore a project-canon migration gap, not a user-PC, launcher, browser, clone, or Tool Hub installation failure.

## Goal

Make current `urban-legend` canon satisfy Base Project Adapter v2 identity without changing gameplay, protected assets, project routing semantics, skill content, or visual assets, so the same Windows Tool Hub onboarding path can register the project as `urban-legend`.

## Non-goals

- Do not weaken Tool Hub to accept v1 adapters.
- Do not add a local-only compatibility shim or edit `%LOCALAPPDATA%` state by hand.
- Do not alter unrelated open/draft/ready PRs or branches.
- Do not modify protected gameplay paths (`data/`, `scripts/`, `scenes/`, `assets/`, `addons/`, `project.godot`).
- Do not change Figma routes, approved visual anchors, Godot gameplay behavior, or subscription handoff behavior.

## Approaches considered

### A. Canonical deterministic v1 → v2 adapter migration — recommended

Use Base's existing v2 migration contract and change only the canonical adapter identity fields required by that contract:

- `schema_version: 1` → `2`
- `project.project_id: "urban-legend"`

Preserve every other adapter semantic value byte-for-value where canonical JSON formatting allows, including Base release pins, repository, engine, routing, registries, overrides, GDD state, protected baseline, protected paths, validators, and compatibility declarations.

**Advantages:** fixes the source of truth, preserves fail-closed identity, smallest semantic change, matches the existing Base migration function.

**Risk:** project validators may expose an additional stale contract after the migration. Those failures must be handled as separate evidence, not hidden by broad edits.

### B. Make Tool Hub accept v1

Change Base Tool Hub validation so v1 adapters can register.

**Rejected:** this weakens an intentional identity trust boundary and makes the live path differ from the reviewed v2 contract.

### C. Generate a machine-local v2 adapter shim

Keep project canon at v1 and create an untracked v2 identity file for Tool Hub.

**Rejected:** creates two identity authorities and makes CI/GitHub canon unable to prove what the user PC used.

## Design

### Canonical data change

`skills/PROJECT_BASE_ADAPTER.json` remains the single project identity authority. The migration is generated/checked using Base's deterministic v1 → v2 contract with the explicit canonical ID `urban-legend`.

No repository name or folder-name inference is allowed. `project_id` is explicitly authored as `urban-legend`.

### Protected-baseline behavior

The existing protected baseline and `protected_paths` policy remain unchanged. This migration touches only project operating metadata outside protected gameplay paths. It must not refresh or reinterpret the gameplay baseline merely to make validation pass.

### Error handling

The change remains fail-closed. If the v2 adapter, Base release lock, registry hashes, protected baseline, or project operating validator do not validate, the PR remains blocked. We do not downgrade those errors to warnings and do not broaden the migration to unrelated cleanup.

### Test strategy

TDD sequence:

1. Reproduce current failure from the v1 `main` adapter: hub identity state is `IDENTITY_MIGRATION_REQUIRED` / v2 identity validation rejects it.
2. Add a focused regression test asserting the canonical project adapter is v2 and has `project.project_id == "urban-legend"` (or extend the closest existing project operating-contract test if that is the repository pattern).
3. Apply the deterministic migration.
4. Run the focused adapter/schema/identity tests.
5. Run the repository's project operating-contract validation suite and relevant existing tests.
6. Run GitHub PR CI on the exact head.
7. Only after all required checks are green and the branch is current with `main`, merge through the normal PR path.

### Post-merge live IRG

After merge, the user only needs to:

1. Pull `urban-legend/main` in GitHub Desktop.
2. Restart Base Tool Hub from the desktop shortcut.
3. Click `urban-legend` → `자동 설치 및 연결` once.
4. Observe `REGISTERED` / appearance under `내 프로젝트`.
5. Continue the previously planned Character Studio → Sprite `pose_sequence` → `effect_stages` → Figma Bridge → Godot IRG.

Cloud/CI success will not be reported as the live Windows registration PASS until that user-PC observation occurs.

## Success criteria

- Canonical adapter validates as Base Project Adapter v2.
- Canonical `project.project_id` is exactly `urban-legend`.
- Existing adapter semantics are preserved except the intentional v2 identity fields.
- No protected gameplay path changes.
- Relevant local/CI project operating-contract checks pass on exact PR head.
- No unrelated active PR is modified.
- Post-merge user-PC Tool Hub can progress past `IDENTITY_MIGRATION_REQUIRED`; actual `REGISTERED` remains a live IRG observation.
