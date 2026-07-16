$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
function Assert-Contains([string]$Path,[string]$Needle) {
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { throw "Missing file: $Path" }
    $text = [IO.File]::ReadAllText($Path,[Text.Encoding]::UTF8)
    if (-not $text.Contains($Needle)) { throw "Missing '$Needle' in $Path" }
}
$config = Get-Content -Raw -LiteralPath (Join-Path $root '.agent-workflow.json') | ConvertFrom-Json
if ($config.schema_version -ne 2) { throw 'workflow config must use schema v2' }
if ($config.max_recovery_attempts -ne 1 -or $config.stale_run_minutes -ne 15) { throw 'async recovery defaults missing' }
if (@($config.delegation_preserved_dirty_paths).Count -lt 3) { throw 'delegation preserved-dirty allowlist is missing' }
Assert-Contains (Join-Path $root 'docs\AI_DELEGATION_WORKFLOW.md') 'TASK_CONTRACT.md'
Assert-Contains (Join-Path $root 'docs\AI_DELEGATION_WORKFLOW.md') 'Codex 직접 작성 비율 40% 이하'
Assert-Contains (Join-Path $root 'docs\IMAGE_ASSET_WORKFLOW.md') 'ASSET_MANIFEST.json'
Assert-Contains (Join-Path $root 'docs\DIALOGUE_AUTHORING_WORKFLOW.md') 'AI_DELEGATION_WORKFLOW.md'
Assert-Contains (Join-Path $root 'docs\DOCUMENTATION_MAP.md') 'AI_DELEGATION_WORKFLOW.md'
Assert-Contains (Join-Path $root 'docs\BASE_RULES_VERSION.md') 'Base 지식 버전 | v1.6.0'
Assert-Contains (Join-Path $root 'docs\MULTIMODEL_20_TASK_EVALUATION.md') '결과 회수율 | 100% (20/20)'
foreach ($runtime in @('scripts\game-workflow.ps1', 'scripts\GameWorkflow.psm1', 'scripts\run-opencode-worker.ps1')) {
    if (-not (Test-Path -LiteralPath (Join-Path $root $runtime) -PathType Leaf)) { throw "Missing project workflow runtime: $runtime" }
}
$module = Join-Path $root 'scripts\GameWorkflow.psm1'
Import-Module $module -Force
$taskId = 'contract-dirty-allowlist-test'
$git = 'C:\Program Files\Git\cmd\git.exe'
$delegateRoot = Join-Path $env:TEMP ("urban-legend-delegate-" + [guid]::NewGuid().ToString('N'))
$taskWorktree = Join-Path $delegateRoot ".worktrees\$taskId"
try {
    New-Item -ItemType Directory -Path $delegateRoot -Force | Out-Null
    & $git -C $delegateRoot init -q
    [IO.File]::WriteAllText((Join-Path $delegateRoot '.gitignore'), ".worktrees/`n", [Text.UTF8Encoding]::new($false))
    [IO.File]::WriteAllText((Join-Path $delegateRoot 'tracked.txt'), "base`n", [Text.UTF8Encoding]::new($false))
    & $git -C $delegateRoot add .gitignore tracked.txt
    & $git -C $delegateRoot -c user.name=Codex -c user.email=codex@example.invalid commit -qm 'test base'
    [IO.File]::WriteAllText((Join-Path $delegateRoot 'capture.png.import'), "user generated`n", [Text.UTF8Encoding]::new($false))
    $created = New-GameTaskWorktree -RepoPath $delegateRoot -TaskId $taskId -GitPath $git -PreservedDirtyPaths @($config.delegation_preserved_dirty_paths)
    if (-not (Test-Path -LiteralPath $created.worktree -PathType Container)) { throw 'allowlisted user imports should not block a safe worker worktree' }
}
finally {
    if (Test-Path -LiteralPath $taskWorktree -PathType Container) { & $git -C $delegateRoot worktree remove --force $taskWorktree }
    if (Test-Path -LiteralPath $delegateRoot -PathType Container) {
        & $git -C $delegateRoot show-ref --verify --quiet "refs/heads/worker/$taskId"
        if ($LASTEXITCODE -eq 0) { & $git -C $delegateRoot branch -D "worker/$taskId" }
        Remove-Item -LiteralPath $delegateRoot -Recurse -Force
    }
}
'PASS: project multi-model workflow documentation and schema contract'
