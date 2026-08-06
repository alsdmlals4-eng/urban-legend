# Local Exact-SHA Validation Plan Self-Review Addendum

- Decision ID: `UL-DEC-LOCAL-VALIDATION-001`
- Applies to: `docs/superpowers/plans/2026-08-07-local-exact-sha-validation-implementation-plan.md`
- Status: `AUTHORITATIVE_EXECUTION_CORRECTIONS`

This addendum records the plan self-review required before execution. The corrections below supersede only the named steps; every other plan requirement remains unchanged.

## 1. RED change-surface contract timing

In Task 2 Step 1, replace the final change-surface test at the same time the old `ALLOWED_PATHS` constant is replaced. Use:

```python
def test_change_surface_is_bounded_to_local_validation_correction() -> None:
    changed = _changed_paths_from_main()
    assert changed <= LOCAL_CORRECTION_PATHS, (
        f"forbidden changed paths: {sorted(changed - LOCAL_CORRECTION_PATHS)}"
    )
```

Task 3 Step 3 becomes a verification step only; do not edit the change-surface test a second time.

This avoids an unintended `NameError` for the removed `ALLOWED_PATHS` symbol during the RED run.

## 2. Concrete RED evidence expectations

Task 2 Step 2 must verify these concrete failure classes rather than the descriptive phrase `stale single-plugin assertion failure`:

```text
AssertionError from enabled=PackedStringArray("res://addons/godot_ai/plugin.cfg")
NameError for _assert_exact_editor_plugins
missing required adoption surface: tests/gut/test_validation_route_mapper.gd.uid
```

Additional failures are not accepted unless explained and shown to originate from the same two approved blockers.

## 3. Python 3.14 remains informational

Task 4 Step 5 is replaced with this non-blocking compatibility capture:

```powershell
$Python314State = 'NOT_RUN_INFORMATIONAL'
$Python314 = Get-Command py.exe -ErrorAction SilentlyContinue
if ($null -ne $Python314) {
    py -3.14 --version 2>&1 | Tee-Object "$Evidence/python-3.14-version.txt"
    py -3.14 -m unittest discover -s tests -p 'test_*.py' 2>&1 |
        Tee-Object "$Evidence/python-3.14-unittest.log"
    if ($LASTEXITCODE -eq 0) {
        $Python314State = 'PASS_415_INFORMATIONAL'
    } else {
        $Python314State = 'FAIL_INFORMATIONAL'
    }
}
$Python314State | Set-Content "$Evidence/python-3.14-status.txt" -Encoding ascii
```

A Python 3.14 failure does not block the required Python 3.11/3.12/3.13 and Ubuntu 3.12 matrix. It must still be reported truthfully.

Task 7 Step 3 must use:

```powershell
windows_python_3_14_compatibility = $Python314State
```

instead of a hard-coded PASS value.

## 4. PowerShell Godot path argument

Before Task 5 Step 4, define:

```powershell
$ProjectPath = (Get-Location).Path
```

Run GUT with:

```powershell
& $Godot --headless -d -s --path $ProjectPath addons/gut/gut_cmdln.gd `
    -gdir=res://tests/gut `
    -ginclude_subdirs `
    -gexit `
    "-gjunit_xml_file=$JUnit"
```

Do not pass `(Get-Location).Path` directly in argument mode.

## 5. PowerShell 5.1-compatible evidence-relative paths

Task 7 Step 4 must not use `[System.IO.Path]::GetRelativePath`, which is not guaranteed in Windows PowerShell 5.1. Replace the relative-path expression with:

```powershell
$EvidenceRootItem = Get-Item $EvidenceRoot
Get-ChildItem $EvidenceRootItem.FullName -File -Recurse |
    Where-Object { $_.Name -ne 'SHA256SUMS.txt' } |
    Sort-Object FullName |
    ForEach-Object {
        $Hash = (Get-FileHash $_.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
        $Relative = $_.FullName.Substring($EvidenceRootItem.FullName.Length)
        $Relative = $Relative.TrimStart([char[]]@('\', '/')).Replace('\', '/')
        "$Hash  $Relative"
    } | Set-Content "$($EvidenceRootItem.FullName)\SHA256SUMS.txt" -Encoding ascii
```

## 6. Self-review outcome

- Spec coverage: all approved correction, validation, evidence, lifecycle, and synchronization requirements have an execution task.
- Placeholder scan: no `TBD`, `TODO`, deferred implementation, or unspecified error-handling step remains.
- Interface consistency: implementation branch, candidate SHA, Base pilot pin, plugin helper names, UID content, and evidence paths are consistent across tasks.
- Scope: tracked implementation remains exactly two files; PR #169 remains docs-only.
- Lifecycle ceiling: `LOCAL_EXACT_SHA_VALIDATED / REVIEW_PENDING / ADOPTED_ACTIVE_NOT_CLAIMED / MERGE_NOT_AUTHORIZED`.
