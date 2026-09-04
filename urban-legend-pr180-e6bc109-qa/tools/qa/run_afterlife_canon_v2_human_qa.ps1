param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('Prepare', 'Launch', 'Collect')]
    [string]$Stage,

    [string]$SourceMain,
    [string]$SourceValidation,
    [string]$QaRoot,
    [string]$GodotBinary = "godot",
    [string]$RepoRoot,
    [switch]$WaitForExit
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$DecisionId = "D-2026-08-05-AFTERLIFE-STATION-CANON-V2-MIGRATION-DESIGN"
$ProjectName = "urban-legend"
$MainSaveName = "urban_legend_save.json"
$ValidationSaveName = "urban_legend_validation_save.json"
$ManifestName = "manifest.json"
$ControlName = "source-map.local.json"
$ContentBoundary = "ACTUAL_USER_SAVE_CONTENT_NOT_RECORDED"

function Resolve-FullPath {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [switch]$AllowMissing
    )

    if ($AllowMissing) {
        return [System.IO.Path]::GetFullPath($Path)
    }
    return (Resolve-Path -LiteralPath $Path).Path
}

function Get-Sha256 {
    param([Parameter(Mandatory = $true)][string]$Path)
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}

function Get-AnonymousId {
    param(
        [Parameter(Mandatory = $true)][string]$Prefix,
        [Parameter(Mandatory = $true)][string]$Hash
    )
    return "$Prefix-$($Hash.Substring(0, 12))"
}

function Write-JsonFile {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][object]$Value
    )
    $Value | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $Path -Encoding UTF8
}

function Read-JsonFile {
    param([Parameter(Mandatory = $true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "MISSING_REQUIRED_FILE: $Path"
    }
    return Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
}

function Get-PathComparison {
    if ($env:OS -eq 'Windows_NT') {
        return [System.StringComparison]::OrdinalIgnoreCase
    }
    return [System.StringComparison]::Ordinal
}

function Test-SamePath {
    param(
        [Parameter(Mandatory = $true)][string]$Left,
        [Parameter(Mandatory = $true)][string]$Right
    )
    return [string]::Equals(
        (Resolve-FullPath -Path $Left -AllowMissing),
        (Resolve-FullPath -Path $Right -AllowMissing),
        (Get-PathComparison)
    )
}

function Test-PathWithin {
    param(
        [Parameter(Mandatory = $true)][string]$Candidate,
        [Parameter(Mandatory = $true)][string]$Parent
    )
    $candidateFull = (Resolve-FullPath -Path $Candidate -AllowMissing).TrimEnd('\', '/')
    $parentFull = (Resolve-FullPath -Path $Parent -AllowMissing).TrimEnd('\', '/')
    $separator = [System.IO.Path]::DirectorySeparatorChar
    return $candidateFull.StartsWith("$parentFull$separator", (Get-PathComparison))
}

function Get-DefaultQaRoot {
    $desktop = [Environment]::GetFolderPath('Desktop')
    if ([string]::IsNullOrWhiteSpace($desktop)) {
        $desktop = $env:USERPROFILE
    }
    if ([string]::IsNullOrWhiteSpace($desktop)) {
        throw "QA_ROOT_UNAVAILABLE"
    }
    $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
    return Join-Path $desktop "urban-legend-qa\$stamp"
}

function Get-Layout {
    param([Parameter(Mandatory = $true)][string]$Root)
    $rootFull = Resolve-FullPath -Path $Root -AllowMissing
    $appData = Join-Path $rootFull "AppData\Roaming"
    $userDir = Join-Path $appData "Godot\app_userdata\$ProjectName"
    $evidence = Join-Path $rootFull "evidence"
    $logs = Join-Path $rootFull "logs"
    $control = Join-Path $rootFull ".control"
    return [ordered]@{
        root = $rootFull
        app_data = $appData
        user_dir = $userDir
        evidence = $evidence
        logs = $logs
        control = $control
        manifest = Join-Path $evidence $ManifestName
        control_file = Join-Path $control $ControlName
        qa_main = Join-Path $userDir $MainSaveName
        qa_validation = Join-Path $userDir $ValidationSaveName
    }
}

function Assert-SourcePath {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Destination,
        [Parameter(Mandatory = $true)][string]$Root
    )
    if (-not (Test-Path -LiteralPath $Source -PathType Leaf)) {
        throw "SOURCE_SAVE_NOT_FOUND: $Source"
    }
    if (Test-SamePath -Left $Source -Right $Destination) {
        throw "SOURCE_AND_QA_PATH_COLLISION"
    }
    if (Test-PathWithin -Candidate $Source -Parent $Root) {
        throw "SOURCE_INSIDE_QA_ROOT"
    }
}

function Prepare-QaCopy {
    if ([string]::IsNullOrWhiteSpace($SourceMain)) {
        throw "SOURCE_MAIN_REQUIRED_FOR_PREPARE"
    }

    $resolvedRoot = if ([string]::IsNullOrWhiteSpace($QaRoot)) { Get-DefaultQaRoot } else { $QaRoot }
    $layout = Get-Layout -Root $resolvedRoot
    New-Item -ItemType Directory -Force -Path $layout.user_dir, $layout.evidence, $layout.logs, $layout.control | Out-Null

    $mainSourceFull = Resolve-FullPath -Path $SourceMain
    Assert-SourcePath -Source $mainSourceFull -Destination $layout.qa_main -Root $layout.root
    $mainSourceHash = Get-Sha256 -Path $mainSourceFull
    Copy-Item -LiteralPath $mainSourceFull -Destination $layout.qa_main -Force
    $mainCopyHash = Get-Sha256 -Path $layout.qa_main
    if ($mainCopyHash -ne $mainSourceHash) {
        throw "SOURCE_COPY_HASH_MISMATCH: main"
    }

    $validationRecord = $null
    $validationControl = $null
    if (-not [string]::IsNullOrWhiteSpace($SourceValidation)) {
        $validationSourceFull = Resolve-FullPath -Path $SourceValidation
        Assert-SourcePath -Source $validationSourceFull -Destination $layout.qa_validation -Root $layout.root
        $validationSourceHash = Get-Sha256 -Path $validationSourceFull
        Copy-Item -LiteralPath $validationSourceFull -Destination $layout.qa_validation -Force
        $validationCopyHash = Get-Sha256 -Path $layout.qa_validation
        if ($validationCopyHash -ne $validationSourceHash) {
            throw "SOURCE_COPY_HASH_MISMATCH: validation"
        }
        $validationRecord = [ordered]@{
            anonymous_id = Get-AnonymousId -Prefix "validation" -Hash $validationSourceHash
            sha256 = $validationSourceHash
            bytes = (Get-Item -LiteralPath $validationSourceFull).Length
            qa_relative_path = "AppData/Roaming/Godot/app_userdata/$ProjectName/$ValidationSaveName"
        }
        $validationControl = [ordered]@{
            source_path = $validationSourceFull
            source_sha256 = $validationSourceHash
            qa_path = $layout.qa_validation
        }
    }

    $manifest = [ordered]@{
        decision_id = $DecisionId
        status = "PREPARED"
        created_at_utc = [DateTime]::UtcNow.ToString("o")
        privacy_boundary = $ContentBoundary
        qa_layout = "AppData/Roaming/Godot/app_userdata/$ProjectName"
        main = [ordered]@{
            anonymous_id = Get-AnonymousId -Prefix "main" -Hash $mainSourceHash
            sha256 = $mainSourceHash
            bytes = (Get-Item -LiteralPath $mainSourceFull).Length
            qa_relative_path = "AppData/Roaming/Godot/app_userdata/$ProjectName/$MainSaveName"
        }
        validation = $validationRecord
        automated_classification = "LOCAL_HUMAN_QA_RUNNER_PREPARED"
        actual_user_save = "LOCAL_ONLY_NOT_UPLOADED"
        human_qa = "HUMAN_QA_NOT_RUN"
        ui_accessibility = "UI_ACCESSIBILITY_NOT_RUN"
        merge = "MERGE_NOT_AUTHORIZED"
    }

    $control = [ordered]@{
        warning = "LOCAL_PRIVATE_DO_NOT_UPLOAD"
        qa_root = $layout.root
        qa_appdata = $layout.app_data
        main = [ordered]@{
            source_path = $mainSourceFull
            source_sha256 = $mainSourceHash
            qa_path = $layout.qa_main
        }
        validation = $validationControl
    }

    Write-JsonFile -Path $layout.manifest -Value $manifest
    Write-JsonFile -Path $layout.control_file -Value $control
    Write-Host "PREPARED"
    Write-Host "QA_ROOT=$($layout.root)"
    Write-Host "MANIFEST=$($layout.manifest)"
}

function Launch-QaGame {
    if ([string]::IsNullOrWhiteSpace($QaRoot)) {
        throw "QA_ROOT_REQUIRED_FOR_LAUNCH"
    }
    $layout = Get-Layout -Root $QaRoot
    $null = Read-JsonFile -Path $layout.manifest
    $null = Read-JsonFile -Path $layout.control_file

    $resolvedRepo = if ([string]::IsNullOrWhiteSpace($RepoRoot)) {
        Resolve-FullPath -Path (Join-Path $PSScriptRoot "..\..")
    }
    else {
        Resolve-FullPath -Path $RepoRoot
    }
    if (-not (Test-Path -LiteralPath (Join-Path $resolvedRepo "project.godot") -PathType Leaf)) {
        throw "GODOT_PROJECT_NOT_FOUND: $resolvedRepo"
    }

    $stdout = Join-Path $layout.logs "godot-launch.stdout.log"
    $stderr = Join-Path $layout.logs "godot-launch.stderr.log"
    $PreviousAppData = $env:APPDATA
    $env:APPDATA = $layout.app_data
    try {
        $process = Start-Process -FilePath $GodotBinary `
            -ArgumentList @("--editor", "--path", ".", "--verbose") `
            -WorkingDirectory $resolvedRepo `
            -RedirectStandardOutput $stdout -RedirectStandardError $stderr -PassThru
        $process.Id | Set-Content -LiteralPath (Join-Path $layout.evidence "godot-process-id.txt") -Encoding UTF8
        if ($WaitForExit) {
            $process.WaitForExit()
            if ($process.ExitCode -ne 0) {
                throw "GODOT_LAUNCH_FAILED: $($process.ExitCode)"
            }
        }
    }
    finally {
        $env:APPDATA = $PreviousAppData
    }
    Write-Host "LAUNCHED"
    Write-Host "QA_ROOT=$($layout.root)"
}

function Collect-QaEvidence {
    if ([string]::IsNullOrWhiteSpace($QaRoot)) {
        throw "QA_ROOT_REQUIRED_FOR_COLLECT"
    }
    $layout = Get-Layout -Root $QaRoot
    $manifest = Read-JsonFile -Path $layout.manifest
    $control = Read-JsonFile -Path $layout.control_file

    $mainSourceHashNow = Get-Sha256 -Path ([string]$control.main.source_path)
    if ($mainSourceHashNow -ne [string]$control.main.source_sha256) {
        throw "SOURCE_MUTATED_AFTER_PREPARE: main"
    }

    $validationSourceHashNow = $null
    if ($null -ne $control.validation) {
        $validationSourceHashNow = Get-Sha256 -Path ([string]$control.validation.source_path)
        if ($validationSourceHashNow -ne [string]$control.validation.source_sha256) {
            throw "SOURCE_MUTATED_AFTER_PREPARE: validation"
        }
    }

    $qaMainHash = if (Test-Path -LiteralPath $layout.qa_main -PathType Leaf) { Get-Sha256 -Path $layout.qa_main } else { $null }
    $qaValidationHash = if (Test-Path -LiteralPath $layout.qa_validation -PathType Leaf) { Get-Sha256 -Path $layout.qa_validation } else { $null }
    $transactionArtifacts = @()
    Get-ChildItem -LiteralPath $layout.user_dir -Filter "*.migration.*.json" -File -ErrorAction SilentlyContinue | ForEach-Object {
        $transactionArtifacts += [ordered]@{
            name = $_.Name
            bytes = $_.Length
            sha256 = Get-Sha256 -Path $_.FullName
        }
    }

    $summary = [ordered]@{
        decision_id = $DecisionId
        status = "EVIDENCE_COLLECTED"
        collected_at_utc = [DateTime]::UtcNow.ToString("o")
        privacy_boundary = $ContentBoundary
        source_main_unchanged = $true
        source_main_sha256 = $mainSourceHashNow
        source_validation_unchanged = if ($null -eq $control.validation) { $null } else { $true }
        source_validation_sha256 = $validationSourceHashNow
        qa_main_sha256 = $qaMainHash
        qa_validation_sha256 = $qaValidationHash
        transaction_artifacts = $transactionArtifacts
        review = "HUMAN_REVIEW_REQUIRED"
        human_qa = "HUMAN_QA_NOT_RUN"
        ui_accessibility = "UI_ACCESSIBILITY_NOT_RUN"
        merge = "MERGE_NOT_AUTHORIZED"
    }
    Write-JsonFile -Path (Join-Path $layout.evidence "collection-summary.json") -Value $summary

    $manifest.status = "EVIDENCE_COLLECTED"
    $manifest.automated_classification = "AUTOMATED_LOCAL_HUMAN_QA_RUNNER_PREFLIGHT_GREEN"
    $manifest.human_qa = "HUMAN_QA_NOT_RUN"
    $manifest.ui_accessibility = "UI_ACCESSIBILITY_NOT_RUN"
    $manifest.merge = "MERGE_NOT_AUTHORIZED"
    Write-JsonFile -Path $layout.manifest -Value $manifest

    Write-Host "EVIDENCE_COLLECTED"
    Write-Host "HUMAN_REVIEW_REQUIRED"
    Write-Host "HUMAN_QA_NOT_RUN"
    Write-Host "UI_ACCESSIBILITY_NOT_RUN"
    Write-Host "MERGE_NOT_AUTHORIZED"
    Write-Host "QA_ROOT=$($layout.root)"
}

switch ($Stage) {
    'Prepare' { Prepare-QaCopy }
    'Launch' { Launch-QaGame }
    'Collect' { Collect-QaEvidence }
    default { throw "UNSUPPORTED_STAGE: $Stage" }
}
