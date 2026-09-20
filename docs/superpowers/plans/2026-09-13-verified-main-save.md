# Verified generic save — implementation plan

Approved continuation of recovery persistence hardening; previous HEAD 156129bf81c28709a98f8b9401f80345fa53c8db. No format/version/content/art changes.

## Choice and evidence

- REJECT direct WRITE on primary: currently truncates before the full payload is available and does not inspect write errors.
- DEFER direct reuse of AfterlifeMigrationTransaction/ValidationSaveRepository: migration identity, journal recovery and validation-only format/legacy guard are deliberately specific. Do not remove their protections to force reuse.
- ADAPT their verified staging pattern inside the existing generic GameState save owner: write a sibling `.pending`, flush, check error and exact bytes, then rename to primary. Retain failed stage for retry; one bounded path, never a stream of backups. M01 and Validation routing unchanged.
- Primary evidence: scripts/core/afterlife_migration_transaction.gd and validation_save_repository.gd; Godot FileAccess and DirAccess official docs https://docs.godotengine.org/en/stable/classes/class_fileaccess.html and https://docs.godotengine.org/en/stable/classes/class_diraccess.html . OS success is not evidence of power-loss durability.

## Sequence / acceptance

1. Add real GameState test with isolated user data/TestSaveGuard. Block the sibling stage using an owned directory; expect false, unchanged primary bytes. RED first.
2. Replace direct write only. Return false on open/write/readback/rename error; keep primary untouched before promotion.
3. Retry after clearing owned test obstacle, verify round trip and no stage after successful rename. Check Windows protected primary refuses promotion and preserves its bytes, then retries successfully.
4. Run recovery-save-retry, existing GUT and M01 migration regressions. Review twice for collisions, save-format drift, stale staging and unsupported success claims.
5. Record evidence and limits in current handoff, selectively commit/push current branch. Preserve unrelated import/uid files and open PRs.

Files: scripts/core/game_state.gd; tests/recovery/generic_save_staging_test.gd; docs/CURRENT_HANDOFF.md.

Limits: single process/local save contract; no multi-process locking, cloud sync, disk-full emulator, hardware-fault or sudden-power-loss certification. Failed `.pending` is never automatically loaded as the player's save. Rollback restores code only; saved JSON format is unchanged.
