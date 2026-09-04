param(
    [string]$GodotBinary,
    [string]$SourceMain,
    [string]$SourceValidation,
    [string]$QaRoot,
    [switch]$AllowVersionMismatch,
    [switch]$NonInteractive,
    [switch]$SkipLaunch,
    [ValidateSet('PASS', 'FAIL', 'BLOCKED', 'NOT_RUN')]
    [string]$DefaultChecklistStatus = 'NOT_RUN',
    [switch]$NoPause
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$sourceScript = Join-Path $PSScriptRoot 'start_afterlife_canon_v2_human_qa.ps1'
$sourceChecklist = Join-Path $PSScriptRoot 'afterlife_canon_v2_human_qa_checklist.json'
$repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..'))
$baseRunner = Join-Path $PSScriptRoot 'run_afterlife_canon_v2_human_qa.ps1'
$tempRoot = Join-Path $env:TEMP ("urban-legend-one-click-qa-{0}" -f [Guid]::NewGuid().ToString('N'))
$tempScript = Join-Path $tempRoot 'start_afterlife_canon_v2_human_qa.ps1'
$tempChecklist = Join-Path $tempRoot 'afterlife_canon_v2_human_qa_checklist.json'
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$utf8Bom = New-Object System.Text.UTF8Encoding($true)

function Quote-PowerShellLiteral {
    param([Parameter(Mandatory = $true)][string]$Value)
    return "'{0}'" -f $Value.Replace("'", "''")
}

if (-not (Test-Path -LiteralPath $sourceScript -PathType Leaf)) {
    throw 'ONE_CLICK_ORCHESTRATOR_NOT_FOUND'
}
if (-not (Test-Path -LiteralPath $sourceChecklist -PathType Leaf)) {
    throw 'ONE_CLICK_CHECKLIST_NOT_FOUND'
}
if (-not (Test-Path -LiteralPath $baseRunner -PathType Leaf)) {
    throw 'ONE_CLICK_BASE_RUNNER_NOT_FOUND'
}

New-Item -ItemType Directory -Force -Path $tempRoot | Out-Null
try {
    $scriptText = [System.IO.File]::ReadAllText($sourceScript, $utf8NoBom)
    $checklistText = [System.IO.File]::ReadAllText($sourceChecklist, $utf8NoBom)

    $repoReplacement = '$RepoRoot = {0}' -f (Quote-PowerShellLiteral -Value $repoRoot)
    $runnerReplacement = '$Runner = {0}' -f (Quote-PowerShellLiteral -Value $baseRunner)
    $checklistReplacement = '$ChecklistPath = {0}' -f (Quote-PowerShellLiteral -Value $tempChecklist)

    $scriptText = [regex]::Replace($scriptText, '(?m)^\$RepoRoot = .+$', $repoReplacement)
    $scriptText = [regex]::Replace($scriptText, '(?m)^\$Runner = .+$', $runnerReplacement)
    $scriptText = [regex]::Replace($scriptText, '(?m)^\$ChecklistPath = .+$', $checklistReplacement)

    [System.IO.File]::WriteAllText($tempScript, $scriptText, $utf8Bom)
    [System.IO.File]::WriteAllText($tempChecklist, $checklistText, $utf8Bom)

    $childArgs = @('-NoLogo', '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $tempScript)
    foreach ($name in @('GodotBinary', 'SourceMain', 'SourceValidation', 'QaRoot')) {
        if ($PSBoundParameters.ContainsKey($name) -and -not [string]::IsNullOrWhiteSpace([string]$PSBoundParameters[$name])) {
            $childArgs += "-$name"
            $childArgs += [string]$PSBoundParameters[$name]
        }
    }
    foreach ($name in @('AllowVersionMismatch', 'NonInteractive', 'SkipLaunch', 'NoPause')) {
        if ($PSBoundParameters.ContainsKey($name) -and [bool]$PSBoundParameters[$name]) {
            $childArgs += "-$name"
        }
    }
    $childArgs += '-DefaultChecklistStatus'
    $childArgs += $DefaultChecklistStatus

    $windowsPowerShell = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
    & $windowsPowerShell @childArgs
    $exitCode = $LASTEXITCODE
}
finally {
    Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
}

exit $exitCode
