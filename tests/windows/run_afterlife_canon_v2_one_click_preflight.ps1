param(
    [Parameter(Mandatory = $true)]
    [string]$GodotBinary
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..'))
$source = Join-Path $repoRoot 'tests\fixtures\afterlife_migration\main_mvp039_recovery.json'
$orchestrator = Join-Path $repoRoot 'tools\qa\start_afterlife_canon_v2_human_qa.ps1'
$hostName = if ($PSVersionTable.PSEdition) { [string]$PSVersionTable.PSEdition } else { 'Desktop' }
$qaRoot = Join-Path $env:RUNNER_TEMP ("afterlife-one-click-human-qa\{0}-{1}" -f $hostName, [Guid]::NewGuid().ToString('N'))

if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
    throw "ONE_CLICK_SOURCE_FIXTURE_MISSING"
}
if (-not (Test-Path -LiteralPath $orchestrator -PathType Leaf)) {
    throw "ONE_CLICK_ORCHESTRATOR_MISSING"
}

$before = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash
& $orchestrator `
    -GodotBinary $GodotBinary `
    -SourceMain $source `
    -QaRoot $qaRoot `
    -NonInteractive `
    -SkipLaunch `
    -DefaultChecklistStatus NOT_RUN `
    -NoPause
if ($LASTEXITCODE -ne 0) {
    throw "ONE_CLICK_ORCHESTRATOR_FAILED: $LASTEXITCODE"
}
$after = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash
if ($before -ne $after) {
    throw "ONE_CLICK_SOURCE_MUTATED"
}

$manifestPath = Join-Path $qaRoot 'evidence\manifest.json'
$collectionPath = Join-Path $qaRoot 'evidence\collection-summary.json'
$summaryPath = Join-Path $qaRoot 'evidence\human-qa-summary.json'
$markdownPath = Join-Path $qaRoot 'evidence\HUMAN_QA_SUMMARY.md'
foreach ($required in @($manifestPath, $collectionPath, $summaryPath, $markdownPath)) {
    if (-not (Test-Path -LiteralPath $required -PathType Leaf)) {
        throw "ONE_CLICK_EVIDENCE_MISSING"
    }
}

$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
$collection = Get-Content -LiteralPath $collectionPath -Raw | ConvertFrom-Json
$summary = Get-Content -LiteralPath $summaryPath -Raw | ConvertFrom-Json

if ([string]$manifest.status -ne 'EVIDENCE_COLLECTED') {
    throw "ONE_CLICK_MANIFEST_STATUS_MISMATCH"
}
if (-not [bool]$collection.source_main_unchanged) {
    throw "ONE_CLICK_SOURCE_UNCHANGED_MISMATCH"
}
if ([string]$summary.classification -ne 'HUMAN_QA_INCOMPLETE') {
    throw "ONE_CLICK_HUMAN_CLASSIFICATION_MISMATCH"
}
if ([int]$summary.counts.NOT_RUN -ne 18) {
    throw "ONE_CLICK_NOT_RUN_COUNT_MISMATCH"
}
if ([int]$summary.counts.PASS -ne 0) {
    throw "ONE_CLICK_CI_MUST_NOT_AUTO_PASS"
}
if ([string]$summary.privacy_boundary -ne 'ACTUAL_USER_SAVE_CONTENT_NOT_RECORDED') {
    throw "ONE_CLICK_PRIVACY_BOUNDARY_MISMATCH"
}

$evidenceNames = @(Get-ChildItem -LiteralPath (Join-Path $qaRoot 'evidence') -Recurse -File | ForEach-Object { $_.FullName })
foreach ($name in $evidenceNames) {
    if ($name -match '\\.control\\' -or $name -match '\\AppData\\') {
        throw "ONE_CLICK_PRIVATE_FILE_LEAKED_TO_EVIDENCE"
    }
}

Write-Host "ONE-CLICK HUMAN QA PREFLIGHT: PASS"
Write-Host "PowerShell=$($PSVersionTable.PSVersion)"
Write-Host "Classification=HUMAN_QA_INCOMPLETE"
Write-Host "NOT_RUN=18"
