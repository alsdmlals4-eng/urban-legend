# Local Exact-SHA Validation Correction Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Correct the stale Live Editor plugin contract and missing GDScript UID companion, then produce fail-closed local exact-SHA evidence for the required Windows, Ubuntu, Godot, GUT/JUnit, regression, and Base pilot checks.

**Architecture:** Keep Draft PR #169 as the design-and-plan authority. Create a separate implementation branch directly from project `main` SHA `d79b79a0a51ed533f48be30b77e95cdd8c433ce4`, so the implementation PR contains only the two approved implementation files. The Live Editor test module owns a bounded parser and exact plugin-set assertion; the UID companion is committed as the canonical repository identity. All evidence is generated under ignored `.artifacts/` paths and is synchronized to GitHub and Google Sheet with Decision ID `UL-DEC-LOCAL-VALIDATION-001`.

**Tech Stack:** Git worktrees, Python 3.11/3.12/3.13, optional Python 3.14 compatibility, pytest 8.3.5, jsonschema 4.23.0, Ubuntu 24.04 on WSL2, Godot 4.7.1, GUT 9.7.1, JUnit XML, PowerShell 5.1+/7.x, Git Bash, Base reusable pilot commit `2b595570bd237174b2b962a1eb54588b5ecc508d`.

## Global Constraints

- Decision ID is exactly `UL-DEC-LOCAL-VALIDATION-001` on GitHub and Google Sheet.
- Project implementation base is exactly `d79b79a0a51ed533f48be30b77e95cdd8c433ce4`.
- Base main observed during planning is `4f98f968a377f7b6a11aafa4fc94d11bddbebedc`; re-read Base main before final evidence.
- Immutable Base pilot pin is exactly `2b595570bd237174b2b962a1eb54588b5ecc508d`.
- Required Godot version is `4.7.1.stable.official.a13da4feb`.
- Required implementation change surface is only `tests/test_godot_live_editor_adoption.py` and `tests/gut/test_validation_route_mapper.gd.uid`.
- Do not modify `project.godot`, `addons/gut/**`, `scripts/**`, `scenes/**`, `assets/**`, `data/**`, save schemas, runtime behavior, product images, or UI.
- GitHub Actions remains `ACTIONS_UNAVAILABLE_BUDGET`; no queued job may be represented as local PASS.
- `NOT_RUN`, `BLOCKED`, and `FAIL` are never converted to `PASS`.
- Passing objective local checks permits `LOCAL_EXACT_SHA_VALIDATED`, not `ADOPTED_ACTIVE`.
- Human QA, UI/accessibility QA, Android QA, and product-image approval remain unchanged.

---

### Task 1: Create an isolated exact-main implementation worktree

**Files:**
- No repository file changes.
- Worktree: `C:\Users\user\Documents\GitHub\Ninza\urban-legend-local-validation`
- Branch: `agent/local-exact-sha-validation-implementation-20260807`

**Interfaces:**
- Consumes: project `main` commit `d79b79a0a51ed533f48be30b77e95cdd8c433ce4`.
- Produces: a clean isolated branch whose `origin/main...HEAD` diff can be constrained to the two approved implementation files.

- [ ] **Step 1: Refresh remote refs and verify the authority base**

Run in Windows PowerShell from the existing repository:

```powershell
Set-Location 'C:\Users\user\Documents\GitHub\Ninza\urban-legend'
git fetch origin --prune
$ExpectedBase = 'd79b79a0a51ed533f48be30b77e95cdd8c433ce4'
$OriginMain = (git rev-parse origin/main).Trim()
if ($OriginMain -ne $ExpectedBase) {
    throw "origin/main moved: expected=$ExpectedBase actual=$OriginMain"
}
```

Expected: no exception and `origin/main` equals the approved base.

- [ ] **Step 2: Create the isolated worktree and branch**

```powershell
$Worktree = 'C:\Users\user\Documents\GitHub\Ninza\urban-legend-local-validation'
$Branch = 'agent/local-exact-sha-validation-implementation-20260807'

if (Test-Path $Worktree) {
    throw "worktree path already exists: $Worktree"
}

git worktree add -b $Branch $Worktree $ExpectedBase
Set-Location $Worktree
```

Expected: a new worktree checked out at the exact approved main commit.

- [ ] **Step 3: Verify exact SHA and clean baseline**

```powershell
$ActualHead = (git rev-parse HEAD).Trim()
$Status = @(git status --porcelain --untracked-files=all)
if ($ActualHead -ne $ExpectedBase) {
    throw "implementation worktree HEAD mismatch: $ActualHead"
}
if ($Status.Count -ne 0) {
    $Status | ForEach-Object { Write-Host $_ }
    throw 'implementation worktree is not clean'
}
Write-Host "IMPLEMENTATION_BASE=$ActualHead"
Write-Host 'WORKTREE_BASELINE=CLEAN'
```

Expected: exact SHA and clean worktree.

- [ ] **Step 4: Record the isolated branch checkpoint**

No commit is created in this step. Record the terminal output under:

```text
.artifacts/local-validation/bootstrap.txt
```

Create the ignored artifact directory and capture the checkpoint:

```powershell
New-Item -ItemType Directory -Force '.artifacts/local-validation' | Out-Null
@(
    "decision_id=UL-DEC-LOCAL-VALIDATION-001"
    "implementation_base=$ActualHead"
    "branch=$Branch"
    "worktree_clean=true"
) | Set-Content '.artifacts/local-validation/bootstrap.txt' -Encoding utf8
```

---

### Task 2: Add RED contracts for the plugin parser and UID companion

**Files:**
- Modify: `tests/test_godot_live_editor_adoption.py` near imports/constants, `test_source_authorities_and_main_scene_remain_installed`, and the final change-surface test.
- Test: `tests/test_godot_live_editor_adoption.py`

**Interfaces:**
- Consumes: current `project.godot`, existing `_required_text`, and existing `_changed_paths_from_main`.
- Produces: failing tests that require a bounded exact plugin contract and canonical UID companion before implementation exists.

- [ ] **Step 1: Add RED constants and tests without adding the parser or UID file**

Add these constants near the existing path constants:

```python
UID_COMPANION = ROOT / "tests/gut/test_validation_route_mapper.gd.uid"
UID_COMPANION_TEXT = "uid://ctcbx5pl1hwyl\n"
APPROVED_EDITOR_PLUGINS = (
    "res://addons/godot_ai/plugin.cfg",
    "res://addons/gut/plugin.cfg",
)
LOCAL_CORRECTION_PATHS = {
    "tests/test_godot_live_editor_adoption.py",
    "tests/gut/test_validation_route_mapper.gd.uid",
}
```

Replace the old `ALLOWED_PATHS` constant with `LOCAL_CORRECTION_PATHS`.

Add these two tests before `test_source_authorities_and_main_scene_remain_installed`:

```python
def _expect_plugin_contract_failure(project_text: str) -> None:
    try:
        _assert_exact_editor_plugins(project_text)
    except AssertionError:
        return
    raise AssertionError("editor plugin contract unexpectedly accepted invalid input")


def test_editor_plugin_contract_is_bounded_order_independent_and_fail_closed() -> None:
    godot_ai = "res://addons/godot_ai/plugin.cfg"
    gut = "res://addons/gut/plugin.cfg"
    exact_reversed = f'''[application]
config/name="{godot_ai}"

[editor_plugins]
enabled=PackedStringArray("{gut}", "{godot_ai}")

[rendering]
renderer/rendering_method="gl_compatibility"
'''
    _assert_exact_editor_plugins(exact_reversed)

    invalid_payloads = (
        f'''[editor_plugins]
enabled=PackedStringArray("{godot_ai}")
''',
        f'''[editor_plugins]
enabled=PackedStringArray("{godot_ai}", "{gut}", "res://addons/unapproved/plugin.cfg")
''',
        f'''[editor_plugins]
enabled=PackedStringArray("{godot_ai}", "{gut}", "{gut}")
''',
        f'''[application]
config/name="{godot_ai}"

[editor_plugins]
enabled=PackedStringArray("{gut}")
''',
    )
    for payload in invalid_payloads:
        _expect_plugin_contract_failure(payload)


def test_validation_route_mapper_uid_companion_is_canonical() -> None:
    assert _required_text(UID_COMPANION) == UID_COMPANION_TEXT
```

At this RED stage, `_assert_exact_editor_plugins` is intentionally absent and the UID file is intentionally absent.

- [ ] **Step 2: Run the focused contract and verify RED**

Run in Ubuntu WSL using the existing Python 3.12 virtual environment:

```bash
cd /mnt/c/Users/user/Documents/GitHub/Ninza/urban-legend-local-validation
source ~/.venvs/urban-legend-312/bin/activate
python -m pytest tests/test_godot_live_editor_adoption.py -q \
  2>&1 | tee .artifacts/local-validation/red-live-editor.log
```

Expected: non-zero exit. The log must include all of these causes:

```text
stale single-plugin assertion failure
_assert_exact_editor_plugins is not defined
missing tests/gut/test_validation_route_mapper.gd.uid
```

- [ ] **Step 3: Verify RED did not change protected paths**

```bash
git diff --exit-code -- project.godot addons scripts scenes assets data
git status --short
```

Expected: only `tests/test_godot_live_editor_adoption.py` is modified; no protected product path is changed.

- [ ] **Step 4: Commit the RED contract**

```bash
git add tests/test_godot_live_editor_adoption.py
git commit -m "test: expose local validation correction blockers"
```

Expected: one RED test commit containing no product file changes.

---

### Task 3: Implement the bounded parser and canonical UID companion

**Files:**
- Modify: `tests/test_godot_live_editor_adoption.py` near imports/constants/helpers and `test_source_authorities_and_main_scene_remain_installed`.
- Create: `tests/gut/test_validation_route_mapper.gd.uid`
- Test: `tests/test_godot_live_editor_adoption.py`

**Interfaces:**
- Consumes: project text from `project.godot` and the exact approved plugin tuple.
- Produces: `_editor_plugins(project_text: str) -> tuple[str, ...]` and `_assert_exact_editor_plugins(project_text: str) -> None`.

- [ ] **Step 1: Add parser imports and helpers**

Add these imports:

```python
import re
from collections import Counter
```

Add these helpers after `_required_text`:

```python
def _editor_plugins(project_text: str) -> tuple[str, ...]:
    section = re.search(
        r"(?ms)^\[editor_plugins\]\s*\n(?P<body>.*?)(?=^\[|\Z)",
        project_text,
    )
    assert section is not None, "missing [editor_plugins] section"

    enabled = re.search(
        r"(?ms)^enabled\s*=\s*PackedStringArray\((?P<values>.*?)\)\s*$",
        section.group("body"),
    )
    assert enabled is not None, "missing editor_plugins enabled PackedStringArray"

    raw_values = enabled.group("values")
    plugins = tuple(re.findall(r'"([^"]+)"', raw_values))
    residue = re.sub(r'"[^"]+"', "", raw_values).replace(",", "").strip()
    assert not residue, f"malformed editor plugin list: {residue!r}"
    return plugins


def _assert_exact_editor_plugins(project_text: str) -> None:
    actual = Counter(_editor_plugins(project_text))
    expected = Counter(APPROVED_EDITOR_PLUGINS)
    assert actual == expected, (
        "editor plugin authority mismatch: "
        f"expected={dict(expected)} actual={dict(actual)}"
    )
```

This parser is bounded to `[editor_plugins]`, ignores plugin order, and rejects missing, duplicate, malformed, or unapproved entries.

- [ ] **Step 2: Replace the stale production assertion**

In `test_source_authorities_and_main_scene_remain_installed`, replace:

```python
assert 'enabled=PackedStringArray("res://addons/godot_ai/plugin.cfg")' in project
```

with:

```python
_assert_exact_editor_plugins(project)
```

Keep the existing `addons/godot_ai/plugin.cfg` file assertion, and add:

```python
assert (ROOT / "addons/gut/plugin.cfg").is_file()
```

- [ ] **Step 3: Narrow the changed-path contract to the approved correction files**

Replace the final test with:

```python
def test_change_surface_is_bounded_to_local_validation_correction() -> None:
    changed = _changed_paths_from_main()
    assert changed <= LOCAL_CORRECTION_PATHS, (
        f"forbidden changed paths: {sorted(changed - LOCAL_CORRECTION_PATHS)}"
    )
```

The subset relation is intentional: it passes on the implementation branch and after merge to `main`, where the branch diff becomes empty.

- [ ] **Step 4: Create the canonical UID file with UTF-8, LF, and no BOM**

Run in Windows PowerShell inside the isolated worktree:

```powershell
$UidPath = 'tests/gut/test_validation_route_mapper.gd.uid'
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText(
    (Join-Path (Get-Location) $UidPath),
    "uid://ctcbx5pl1hwyl`n",
    $Utf8NoBom
)
```

Expected Git-blob content:

```text
uid://ctcbx5pl1hwyl
```

with one LF terminator. The canonical SHA-256 of those 20 bytes is:

```text
4243BF1669E3DFD330A9A8D816C5D6F471B41814BF2C2A624B128EE1C03FA9A8
```

- [ ] **Step 5: Run the focused contract and verify GREEN**

```bash
cd /mnt/c/Users/user/Documents/GitHub/Ninza/urban-legend-local-validation
source ~/.venvs/urban-legend-312/bin/activate
python -m pytest tests/test_godot_live_editor_adoption.py -q \
  2>&1 | tee .artifacts/local-validation/green-live-editor.log
```

Expected:

```text
7 passed
```

- [ ] **Step 6: Verify the exact correction surface**

```bash
git diff --name-only origin/main...HEAD
git status --short
git diff --exit-code -- project.godot addons scripts scenes assets data
```

Before the GREEN commit, `git status --short` must show only:

```text
 M tests/test_godot_live_editor_adoption.py
?? tests/gut/test_validation_route_mapper.gd.uid
```

- [ ] **Step 7: Commit the GREEN implementation**

```bash
git add tests/test_godot_live_editor_adoption.py \
  tests/gut/test_validation_route_mapper.gd.uid
git commit -m "fix: restore local exact-SHA validation cleanliness"
```

- [ ] **Step 8: Verify committed content and canonical Git-blob hash**

```bash
python3.12 - <<'PY'
import hashlib
import subprocess

path = "tests/gut/test_validation_route_mapper.gd.uid"
blob = subprocess.run(
    ["git", "show", f"HEAD:{path}"],
    check=True,
    capture_output=True,
).stdout
expected = b"uid://ctcbx5pl1hwyl\n"
assert blob == expected, (blob, expected)
assert hashlib.sha256(blob).hexdigest().upper() == (
    "4243BF1669E3DFD330A9A8D816C5D6F471B41814BF2C2A624B128EE1C03FA9A8"
)
print("UID_GIT_BLOB=PASS")
PY
```

Expected: `UID_GIT_BLOB=PASS`.

---

### Task 4: Run the required Python and Live Editor matrix at one exact implementation SHA

**Files:**
- Create ignored evidence only: `.artifacts/local-validation/<candidate-sha>/python-*` and `live-editor.log`.
- No tracked repository changes.

**Interfaces:**
- Consumes: committed GREEN implementation SHA from Task 3.
- Produces: required Windows 3.11/3.12/3.13, Ubuntu 3.12, and focused Live Editor results tied to one SHA.

- [ ] **Step 1: Freeze the candidate SHA and require a clean worktree**

Run in Windows PowerShell:

```powershell
Set-Location 'C:\Users\user\Documents\GitHub\Ninza\urban-legend-local-validation'
$CandidateSha = (git rev-parse HEAD).Trim()
$Status = @(git status --porcelain --untracked-files=all)
if ($Status.Count -ne 0) {
    $Status | ForEach-Object { Write-Host $_ }
    throw 'candidate worktree is not clean'
}
$Evidence = ".artifacts/local-validation/$CandidateSha"
New-Item -ItemType Directory -Force $Evidence | Out-Null
$CandidateSha | Set-Content "$Evidence/candidate-sha.txt" -Encoding ascii
```

- [ ] **Step 2: Run Windows Python 3.11**

```powershell
py -3.11 --version 2>&1 | Tee-Object "$Evidence/python-3.11-version.txt"
py -3.11 -m unittest discover -s tests -p 'test_*.py' 2>&1 |
    Tee-Object "$Evidence/python-3.11-unittest.log"
if ($LASTEXITCODE -ne 0) { throw 'Windows Python 3.11 suite failed' }
```

Expected: Python 3.11.x and `Ran 415 tests ... OK`.

- [ ] **Step 3: Run Windows Python 3.12**

```powershell
py -3.12 --version 2>&1 | Tee-Object "$Evidence/python-3.12-version.txt"
py -3.12 -m unittest discover -s tests -p 'test_*.py' 2>&1 |
    Tee-Object "$Evidence/python-3.12-unittest.log"
if ($LASTEXITCODE -ne 0) { throw 'Windows Python 3.12 suite failed' }
```

Expected: Python 3.12.x and `Ran 415 tests ... OK`.

- [ ] **Step 4: Run Windows Python 3.13**

```powershell
py -3.13 --version 2>&1 | Tee-Object "$Evidence/python-3.13-version.txt"
py -3.13 -m unittest discover -s tests -p 'test_*.py' 2>&1 |
    Tee-Object "$Evidence/python-3.13-unittest.log"
if ($LASTEXITCODE -ne 0) { throw 'Windows Python 3.13 suite failed' }
```

Expected: Python 3.13.x and `Ran 415 tests ... OK`.

- [ ] **Step 5: Run optional Windows Python 3.14 compatibility**

```powershell
py -3.14 --version 2>&1 | Tee-Object "$Evidence/python-3.14-version.txt"
py -3.14 -m unittest discover -s tests -p 'test_*.py' 2>&1 |
    Tee-Object "$Evidence/python-3.14-unittest.log"
if ($LASTEXITCODE -ne 0) { throw 'optional Python 3.14 compatibility failed' }
```

Expected: informational compatibility PASS. This is not a required lifecycle gate.

- [ ] **Step 6: Run Ubuntu 24.04 / Python 3.12 and focused Live Editor**

Run from PowerShell so the exact candidate SHA is checked inside WSL:

```powershell
$WslCommand = @"
set -euo pipefail
cd /mnt/c/Users/user/Documents/GitHub/Ninza/urban-legend-local-validation
candidate='${CandidateSha}'
test "`$(git rev-parse HEAD)" = "`$candidate"
source ~/.venvs/urban-legend-312/bin/activate
python3.12 --version 2>&1 | tee .artifacts/local-validation/${CandidateSha}/ubuntu-python-3.12-version.txt
python3.12 -m unittest discover -s tests -p 'test_*.py' 2>&1 | tee .artifacts/local-validation/${CandidateSha}/ubuntu-python-3.12-unittest.log
python -m pytest tests/test_godot_live_editor_adoption.py -q 2>&1 | tee .artifacts/local-validation/${CandidateSha}/live-editor.log
test "`$(git rev-parse HEAD)" = "`$candidate"
test -z "`$(git status --porcelain --untracked-files=all)"
"@
wsl -d Ubuntu-24.04 -- bash -lc $WslCommand
if ($LASTEXITCODE -ne 0) { throw 'Ubuntu Python or Live Editor validation failed' }
```

Expected: Ubuntu Python 3.12 suite `415 tests ... OK`, Live Editor `7 passed`, exact SHA unchanged, and clean worktree.

- [ ] **Step 7: Record the Python matrix checkpoint**

```powershell
$AfterPythonSha = (git rev-parse HEAD).Trim()
if ($AfterPythonSha -ne $CandidateSha) { throw 'HEAD moved during Python matrix' }
if (@(git status --porcelain --untracked-files=all).Count -ne 0) {
    throw 'Python matrix left repository changes'
}
'PYTHON_REQUIRED_MATRIX=PASS' | Set-Content "$Evidence/python-matrix-status.txt" -Encoding ascii
'LIVE_EDITOR_CONTRACT=PASS_7_OF_7' | Set-Content "$Evidence/live-editor-status.txt" -Encoding ascii
```

---

### Task 5: Run Godot 4.7.1 import, GUT/JUnit, and maintained regression

**Files:**
- Create ignored evidence only: `.artifacts/local-validation/<candidate-sha>/godot-*`, `gut-*`, `junit.xml`, and regression logs.
- No tracked repository changes.

**Interfaces:**
- Consumes: exact clean candidate SHA, Godot 4.7.1 console executable, GUT 9.7.1, and `tests/run_godot_regression.sh`.
- Produces: import cleanliness, GUT/JUnit, 65-entrypoint regression, and protected-path evidence.

- [ ] **Step 1: Verify Godot and candidate state**

```powershell
$Godot = 'C:\Users\user\Downloads\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe'
$GodotVersion = (& $Godot --version).Trim()
if ($LASTEXITCODE -ne 0 -or $GodotVersion -ne '4.7.1.stable.official.a13da4feb') {
    throw "unexpected Godot version: $GodotVersion"
}
if ((git rev-parse HEAD).Trim() -ne $CandidateSha) { throw 'candidate SHA moved' }
if (@(git status --porcelain --untracked-files=all).Count -ne 0) {
    throw 'pre-Godot worktree is not clean'
}
$GodotVersion | Set-Content "$Evidence/godot-version.txt" -Encoding ascii
```

- [ ] **Step 2: Run headless import and require complete cleanliness**

```powershell
& $Godot --headless --path . --import 2>&1 |
    Tee-Object "$Evidence/godot-import.log"
if ($LASTEXITCODE -ne 0) { throw 'Godot import failed' }

git diff --exit-code -- project.godot addons scripts scenes assets data
if ($LASTEXITCODE -ne 0) { throw 'Godot import changed protected tracked paths' }

$PostImport = @(git status --porcelain --untracked-files=all)
if ($PostImport.Count -ne 0) {
    $PostImport | ForEach-Object { Write-Host $_ }
    throw 'Godot import left repository changes'
}
'GODOT_IMPORT=PASS' | Set-Content "$Evidence/godot-import-status.txt" -Encoding ascii
```

Expected: import exit 0 and no generated `.gd.uid` or other change.

- [ ] **Step 3: Capture pre-GUT state**

```powershell
git status --porcelain --untracked-files=all |
    Set-Content "$Evidence/status-before-gut.txt" -Encoding ascii
git diff -- project.godot addons scripts scenes assets data |
    Set-Content "$Evidence/protected-before-gut.patch" -Encoding utf8
```

Expected: both files are empty.

- [ ] **Step 4: Run GUT and emit JUnit XML**

```powershell
$JUnit = "$Evidence/junit.xml"
& $Godot --headless -d -s --path (Get-Location).Path addons/gut/gut_cmdln.gd `
    -gdir=res://tests/gut `
    -ginclude_subdirs `
    -gexit `
    "-gjunit_xml_file=$JUnit" 2>&1 |
    Tee-Object "$Evidence/gut-output.log"
if ($LASTEXITCODE -ne 0) { throw 'GUT suite failed' }
if (-not (Test-Path $JUnit)) { throw 'GUT JUnit file is missing' }
```

Expected GUT summary:

```text
Tests 5
Asserts 17
```

- [ ] **Step 5: Validate the JUnit result**

```powershell
$env:JUNIT_PATH = (Resolve-Path $JUnit).Path
py -3.12 -c @'
import os
import xml.etree.ElementTree as ET
root = ET.parse(os.environ["JUNIT_PATH"]).getroot()
suites = list(root.iter("testsuite"))
tests = sum(int(s.attrib.get("tests", 0)) for s in suites)
failures = sum(int(s.attrib.get("failures", 0)) for s in suites)
errors = sum(int(s.attrib.get("errors", 0)) for s in suites)
assert (tests, failures, errors) == (5, 0, 0), (tests, failures, errors)
print("JUNIT=5/0/0")
'@ 2>&1 | Tee-Object "$Evidence/junit-validation.log"
if ($LASTEXITCODE -ne 0) { throw 'JUnit validation failed' }
```

- [ ] **Step 6: Enforce the GUT non-authoring boundary**

```powershell
git diff --exit-code -- project.godot addons scripts scenes assets data
if ($LASTEXITCODE -ne 0) { throw 'GUT changed protected paths' }
$AfterGut = @(git status --porcelain --untracked-files=all)
if ($AfterGut.Count -ne 0) {
    $AfterGut | ForEach-Object { Write-Host $_ }
    throw 'GUT changed repository state'
}
```

- [ ] **Step 7: Run the maintained full Godot regression through Git Bash**

```powershell
$GitBash = 'C:\Program Files\Git\bin\bash.exe'
if (-not (Test-Path $GitBash)) { throw "Git Bash not found: $GitBash" }

$BashCommand = @"
set -euo pipefail
cd /c/Users/user/Documents/GitHub/Ninza/urban-legend-local-validation
export GODOT_BIN='/c/Users/user/Downloads/Godot_v4.7.1-stable_win64.exe/Godot_v4.7.1-stable_win64_console.exe'
export GODOT_TEST_TMP='/c/Users/user/AppData/Local/Temp/urban-legend-local-validation-${CandidateSha}'
bash tests/run_godot_regression.sh 2>&1 | tee '.artifacts/local-validation/${CandidateSha}/godot-regression.log'
"@
& $GitBash -lc $BashCommand
if ($LASTEXITCODE -ne 0) { throw 'maintained Godot regression failed' }
```

Expected final summary:

```text
Godot regression suite: 58/58 legacy entrypoints + 7/7 Canon v2 focused entrypoints passed
```

- [ ] **Step 8: Verify final SHA and repository state**

```powershell
if ((git rev-parse HEAD).Trim() -ne $CandidateSha) { throw 'HEAD moved during Godot validation' }
git diff --exit-code -- project.godot addons scripts scenes assets data
if ($LASTEXITCODE -ne 0) { throw 'final protected diff failed' }
$FinalGodotStatus = @(git status --porcelain --untracked-files=all)
if ($FinalGodotStatus.Count -ne 0) {
    $FinalGodotStatus | ForEach-Object { Write-Host $_ }
    throw 'final Godot worktree is not clean'
}
'GUT=PASS_5_TESTS_17_ASSERTS' | Set-Content "$Evidence/gut-status.txt" -Encoding ascii
'JUNIT=PASS_5_0_0' | Set-Content "$Evidence/junit-status.txt" -Encoding ascii
'GODOT_REGRESSION=PASS_58_PLUS_7' | Set-Content "$Evidence/godot-regression-status.txt" -Encoding ascii
'PROTECTED_DIFF=PASS' | Set-Content "$Evidence/protected-diff-status.txt" -Encoding ascii
```

---

### Task 6: Reproduce the immutable Base reusable pilot in Ubuntu WSL

**Files:**
- Create ignored project evidence: `.artifacts/local-validation/<candidate-sha>/base-pilot-evidence/**`.
- Create external cache only: `~/.cache/urban-legend-local-validation/**` inside Ubuntu.
- No tracked repository changes.

**Interfaces:**
- Consumes: exact project candidate SHA, Base pilot pin `2b595570bd237174b2b962a1eb54588b5ecc508d`, descriptor `.godot-live-editor/project-pilot.json`, Python 3.12, jsonschema 4.23.0, pytest 8.3.5, and Linux Godot 4.7.1 archive SHA-256 `c7ff14fd28472c8d4f193043de30278dcf7e5241a1dcf7566b02e27addaa33ba`.
- Produces: a bounded pilot evidence directory or a truthful `BLOCKED/FAIL` result.

- [ ] **Step 1: Prepare exact Base and Linux Godot caches**

Run in Ubuntu WSL:

```bash
set -euo pipefail
PROJECT=/mnt/c/Users/user/Documents/GitHub/Ninza/urban-legend-local-validation
CANDIDATE_SHA="$(git -C "$PROJECT" rev-parse HEAD)"
BASE_PIN=2b595570bd237174b2b962a1eb54588b5ecc508d
CACHE_ROOT="$HOME/.cache/urban-legend-local-validation"
BASE_ROOT="$CACHE_ROOT/Base-$BASE_PIN"
GODOT_ROOT="$CACHE_ROOT/godot-4.7.1"
mkdir -p "$CACHE_ROOT" "$GODOT_ROOT"

if [ ! -d "$BASE_ROOT/.git" ]; then
  git clone https://github.com/alsdmlals4-eng/Base.git "$BASE_ROOT"
fi
git -C "$BASE_ROOT" fetch origin --prune
git -C "$BASE_ROOT" checkout --detach "$BASE_PIN"
test "$(git -C "$BASE_ROOT" rev-parse HEAD)" = "$BASE_PIN"

cd "$GODOT_ROOT"
if [ ! -f godot.zip ]; then
  curl --fail --location --retry 3 --output godot.zip \
    https://github.com/godotengine/godot-builds/releases/download/4.7.1-stable/Godot_v4.7.1-stable_linux.x86_64.zip
fi
echo "c7ff14fd28472c8d4f193043de30278dcf7e5241a1dcf7566b02e27addaa33ba  godot.zip" | sha256sum --check -
if [ ! -x Godot_v4.7.1-stable_linux.x86_64 ]; then
  unzip -o -q godot.zip
  chmod +x Godot_v4.7.1-stable_linux.x86_64
fi
./Godot_v4.7.1-stable_linux.x86_64 --version
```

Expected: Base exact pin and Godot 4.7.1 verified by archive hash.

- [ ] **Step 2: Prepare pinned Python dependencies**

```bash
VENV="$CACHE_ROOT/venv-312"
if [ ! -x "$VENV/bin/python" ]; then
  python3.12 -m venv "$VENV"
fi
"$VENV/bin/python" -m pip install --disable-pip-version-check \
  jsonschema==4.23.0 pytest==8.3.5
"$VENV/bin/python" --version
"$VENV/bin/python" -m pytest --version
```

Expected: Python 3.12 and pytest 8.3.5.

- [ ] **Step 3: Run the bounded Base pilot**

```bash
EVIDENCE="$PROJECT/.artifacts/local-validation/$CANDIDATE_SHA/base-pilot-evidence"
rm -rf "$EVIDENCE"
mkdir -p "$EVIDENCE"

test "$(git -C "$PROJECT" rev-parse HEAD)" = "$CANDIDATE_SHA"
test -z "$(git -C "$PROJECT" status --porcelain --untracked-files=all)"

PYTHONPATH="$BASE_ROOT" "$VENV/bin/python" -m tools.godot_multi_project_pilot \
  --base-root "$BASE_ROOT" \
  --source-root "$PROJECT" \
  --source-commit "$CANDIDATE_SHA" \
  --expected-base-commit "$BASE_PIN" \
  --descriptor "$PROJECT/.godot-live-editor/project-pilot.json" \
  --godot-bin "$GODOT_ROOT/Godot_v4.7.1-stable_linux.x86_64" \
  --output-dir "$EVIDENCE" \
  2>&1 | tee "$PROJECT/.artifacts/local-validation/$CANDIDATE_SHA/base-pilot.log"
```

Expected: exit 0 and a non-empty evidence directory.

- [ ] **Step 4: Verify pilot output and repository immutability**

```bash
test -d "$EVIDENCE"
test -n "$(find "$EVIDENCE" -type f -print -quit)"
test "$(git -C "$PROJECT" rev-parse HEAD)" = "$CANDIDATE_SHA"
test -z "$(git -C "$PROJECT" status --porcelain --untracked-files=all)"
printf '%s\n' 'BASE_PILOT=PASS' \
  > "$PROJECT/.artifacts/local-validation/$CANDIDATE_SHA/base-pilot-status.txt"
```

If download, dependency, engine, descriptor, or pilot execution fails, preserve the log and record `BASE_PILOT=BLOCKED` or `BASE_PILOT=FAIL`; do not write PASS.

---

### Task 7: Finalize evidence, Draft implementation PR, and Sheet synchronization

**Files:**
- Create ignored evidence: `.artifacts/local-validation/<candidate-sha>/summary.json` and `SHA256SUMS.txt`.
- No additional tracked repository changes.
- Update GitHub PR metadata and Google Sheet rows through connectors.

**Interfaces:**
- Consumes: all required PASS evidence from Tasks 4-6, implementation branch exact SHA, current Base main SHA, and Decision ID.
- Produces: bounded `LOCAL_EXACT_SHA_VALIDATED` claim, Draft implementation PR, and synchronized Sheet state without `ADOPTED_ACTIVE` promotion.

- [ ] **Step 1: Verify the final tracked change surface**

```powershell
Set-Location 'C:\Users\user\Documents\GitHub\Ninza\urban-legend-local-validation'
$CandidateSha = (git rev-parse HEAD).Trim()
$Changed = @(git diff --name-only origin/main...HEAD)
$ExpectedChanged = @(
    'tests/gut/test_validation_route_mapper.gd.uid',
    'tests/test_godot_live_editor_adoption.py'
)
if (Compare-Object ($Changed | Sort-Object) ($ExpectedChanged | Sort-Object)) {
    $Changed | ForEach-Object { Write-Host $_ }
    throw 'implementation change surface is not exactly the approved two files'
}
if (@(git status --porcelain --untracked-files=all).Count -ne 0) {
    throw 'final candidate worktree is not clean'
}
```

- [ ] **Step 2: Re-read current Base main and record it separately from the immutable pilot pin**

```powershell
$BaseMain = (
    git ls-remote https://github.com/alsdmlals4-eng/Base.git refs/heads/main
).Split("`t")[0]
if (-not $BaseMain) { throw 'could not read Base main' }
$BaseMain | Set-Content ".artifacts/local-validation/$CandidateSha/base-main-observed.txt" -Encoding ascii
'2b595570bd237174b2b962a1eb54588b5ecc508d' |
    Set-Content ".artifacts/local-validation/$CandidateSha/base-pilot-pin.txt" -Encoding ascii
```

- [ ] **Step 3: Generate the machine-readable summary only after every required gate passed**

```powershell
$Summary = [ordered]@{
    decision_id = 'UL-DEC-LOCAL-VALIDATION-001'
    project_candidate_sha = $CandidateSha
    project_base_sha = 'd79b79a0a51ed533f48be30b77e95cdd8c433ce4'
    base_main_observed = $BaseMain
    base_pilot_pin = '2b595570bd237174b2b962a1eb54588b5ecc508d'
    actions_state = 'ACTIONS_UNAVAILABLE_BUDGET'
    windows_python_3_11 = 'PASS_415'
    windows_python_3_12 = 'PASS_415'
    windows_python_3_13 = 'PASS_415'
    windows_python_3_14_compatibility = 'PASS_415_INFORMATIONAL'
    ubuntu_python_3_12 = 'PASS_415'
    live_editor_contract = 'PASS_7_OF_7'
    godot_version = '4.7.1.stable.official.a13da4feb'
    godot_import = 'PASS_WORKTREE_CLEAN'
    gut = 'PASS_5_TESTS_17_ASSERTS'
    junit = 'PASS_5_TESTS_0_FAILURES_0_ERRORS'
    godot_regression = 'PASS_58_LEGACY_PLUS_7_CANON_V2'
    base_pilot = 'PASS'
    protected_diff = 'PASS'
    uid_git_blob_sha256 = '4243BF1669E3DFD330A9A8D816C5D6F471B41814BF2C2A624B128EE1C03FA9A8'
    lifecycle_claim = 'LOCAL_EXACT_SHA_VALIDATED'
    adopted_active = 'NOT_CLAIMED'
    human_qa = 'NOT_RUN'
    ui_accessibility_qa = 'NOT_RUN'
    android_qa = 'NOT_RUN'
}
$Summary | ConvertTo-Json -Depth 4 |
    Set-Content ".artifacts/local-validation/$CandidateSha/summary.json" -Encoding utf8
```

Do not execute this PASS summary step when any required gate is non-PASS. Instead create a summary with the precise `FAIL`, `BLOCKED`, or `NOT_RUN` value and keep `lifecycle_claim` non-PASS.

- [ ] **Step 4: Generate evidence hashes**

```powershell
$EvidenceRoot = Resolve-Path ".artifacts/local-validation/$CandidateSha"
Get-ChildItem $EvidenceRoot -File -Recurse |
    Where-Object { $_.Name -ne 'SHA256SUMS.txt' } |
    Sort-Object FullName |
    ForEach-Object {
        $Hash = (Get-FileHash $_.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
        $Relative = [System.IO.Path]::GetRelativePath($EvidenceRoot, $_.FullName).Replace('\', '/')
        "$Hash  $Relative"
    } | Set-Content "$EvidenceRoot/SHA256SUMS.txt" -Encoding ascii
```

- [ ] **Step 5: Push the implementation branch**

```powershell
git push --set-upstream origin agent/local-exact-sha-validation-implementation-20260807
```

Expected: the remote implementation branch points to `$CandidateSha`.

- [ ] **Step 6: Open a Draft implementation PR against `main`**

Create the PR with:

```text
Title: fix: restore local exact-SHA validation
Decision: UL-DEC-LOCAL-VALIDATION-001
Base: main
Head: agent/local-exact-sha-validation-implementation-20260807
State: Draft
Changed files: exactly 2
Lifecycle: LOCAL_EXACT_SHA_VALIDATED / REVIEW_PENDING / ADOPTED_ACTIVE_NOT_CLAIMED
Authority spec and plan: Draft PR #169
Actions state: ACTIONS_UNAVAILABLE_BUDGET
```

The PR body must list every command result, exact candidate SHA, Base main observed SHA, Base pilot pin, UID Git-blob hash, and retained non-PASS Human/UI/Android states.

- [ ] **Step 7: Update Draft PR #169 to the approved plan state**

Set its lifecycle text to:

```text
SPEC_APPROVED / IMPLEMENTATION_PLAN_WRITTEN / IMPLEMENTATION_NOT_STARTED_OR_SEPARATE_PR / ADOPTED_ACTIVE_NOT_CLAIMED
```

PR #169 remains docs-only and is not merged without a separate merge approval.

- [ ] **Step 8: Synchronize Google Sheet with the same Decision ID**

Update these exact surfaces:

```text
00_프로젝트_허브!E2:K2
02_현재_확정결정!A98:L98
99_변경이력!A132:H132
```

Use history ID:

```text
UL-SYNC-20260807-LOCAL-VALIDATION-IMPLEMENTATION
```

When all required local checks pass, Sheet lifecycle may state:

```text
LOCAL_EXACT_SHA_VALIDATED / REVIEW_PENDING / ADOPTED_ACTIVE_NOT_CLAIMED
```

It must also retain:

```text
ACTIONS_UNAVAILABLE_BUDGET
HUMAN_QA_NOT_RUN
UI_ACCESSIBILITY_NOT_RUN
ANDROID_QA_NOT_RUN
```

- [ ] **Step 9: Read back GitHub and Sheet values**

Verify:

```text
implementation PR head SHA equals summary project_candidate_sha
implementation PR changed files equal the approved two-file set
02_현재_확정결정 row uses UL-DEC-LOCAL-VALIDATION-001
99_변경이력 row uses UL-SYNC-20260807-LOCAL-VALIDATION-IMPLEMENTATION
00_프로젝트_허브 does not claim ADOPTED_ACTIVE
```

- [ ] **Step 10: Stop at the review gate**

Final permissible state after successful execution:

```text
LOCAL_EXACT_SHA_VALIDATED
IMPLEMENTATION_DRAFT_PR_OPEN
REVIEW_PENDING
ADOPTED_ACTIVE_NOT_CLAIMED
MERGE_NOT_AUTHORIZED
```

No merge, Ready-for-review transition, or lifecycle promotion is included in this implementation plan.
