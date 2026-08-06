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

# Existing runner delegation contract: -Stage Prepare / -Stage Launch / -Stage Collect / -WaitForExit
$ProjectName = 'urban-legend'
$ExpectedGodotVersion = '4.7.1'
$PrivacyBoundary = 'ACTUAL_USER_SAVE_CONTENT_NOT_RECORDED'
$KnownStates = @(
    'PREFLIGHT', 'READY', 'PREPARED', 'LAUNCHED',
    'HUMAN_REVIEW_RECORDED', 'EVIDENCE_COLLECTED', 'COMPLETE',
    'BLOCKED_NO_MAIN_SAVE', 'BLOCKED_GODOT_NOT_FOUND', 'BLOCKED_GODOT_VERSION',
    'PREPARE_FAILED', 'LAUNCH_FAILED', 'SOURCE_MUTATED', 'COLLECT_FAILED',
    'USER_CANCELLED', 'AUTOMATED_EVIDENCE_COLLECTION_FAILED'
)

$RepoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..'))
$Runner = Join-Path $PSScriptRoot 'run_afterlife_canon_v2_human_qa.ps1'
$ChecklistPath = Join-Path $PSScriptRoot 'afterlife_canon_v2_human_qa_checklist.json'

function Write-JsonFile {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][object]$Value
    )
    $parent = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $parent -PathType Container)) {
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
    }
    $Value | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $Path -Encoding UTF8
}

function Get-RepositoryHead {
    try {
        $head = (& git -C $RepoRoot rev-parse HEAD 2>$null | Select-Object -First 1)
        if (-not [string]::IsNullOrWhiteSpace([string]$head)) {
            return ([string]$head).Trim()
        }
    }
    catch {
    }
    return 'UNKNOWN'
}

function Get-DefaultQaRoot {
    $desktop = [Environment]::GetFolderPath('Desktop')
    if ([string]::IsNullOrWhiteSpace($desktop)) {
        $desktop = $env:USERPROFILE
    }
    if ([string]::IsNullOrWhiteSpace($desktop)) {
        throw 'QA_ROOT_UNAVAILABLE'
    }
    return Join-Path $desktop ("urban-legend-qa\{0}" -f (Get-Date -Format 'yyyyMMdd-HHmmss'))
}

function Resolve-ExecutablePath {
    param([string]$Candidate)
    if ([string]::IsNullOrWhiteSpace($Candidate)) {
        return $null
    }
    if (Test-Path -LiteralPath $Candidate -PathType Leaf) {
        return [System.IO.Path]::GetFullPath($Candidate)
    }
    try {
        $command = Get-Command $Candidate -ErrorAction Stop | Select-Object -First 1
        $resolved = [string]$command.Path
        if ([string]::IsNullOrWhiteSpace($resolved)) {
            $resolved = [string]$command.Source
        }
        if ([string]::IsNullOrWhiteSpace($resolved)) {
            $resolved = [string]$command.Definition
        }
        if (-not [string]::IsNullOrWhiteSpace($resolved)) {
            return [System.IO.Path]::GetFullPath($resolved)
        }
    }
    catch {
    }
    return $null
}

function Add-GodotCandidate {
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [System.Collections.ArrayList]$List,
        [string]$Path,
        [int]$Priority
    )
    $full = Resolve-ExecutablePath -Candidate $Path
    if ([string]::IsNullOrWhiteSpace($full)) {
        return
    }
    foreach ($item in $List) {
        if ([string]::Equals([string]$item.path, $full, [System.StringComparison]::OrdinalIgnoreCase)) {
            return
        }
    }
    [void]$List.Add([pscustomobject]@{ path = $full; priority = $Priority })
}

function Get-BoundedGodotFiles {
    param([string]$Root)
    $results = @()
    if ([string]::IsNullOrWhiteSpace($Root) -or -not (Test-Path -LiteralPath $Root -PathType Container)) {
        return $results
    }
    $results += Get-ChildItem -LiteralPath $Root -Filter 'Godot*.exe' -File -ErrorAction SilentlyContinue
    foreach ($child in (Get-ChildItem -LiteralPath $Root -Directory -ErrorAction SilentlyContinue)) {
        $results += Get-ChildItem -LiteralPath $child.FullName -Filter 'Godot*.exe' -File -ErrorAction SilentlyContinue
    }
    return $results
}

function Test-GodotVersion {
    param([Parameter(Mandatory = $true)][string]$Path)

    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = $Path
    $startInfo.Arguments = '--version'
    $startInfo.UseShellExecute = $false
    $startInfo.RedirectStandardOutput = $true
    $startInfo.RedirectStandardError = $true
    $startInfo.CreateNoWindow = $true

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $startInfo
    try {
        if (-not $process.Start()) {
            return [ordered]@{ path = $Path; raw = ''; semantic = ''; accepted = $false }
        }
        $stdout = $process.StandardOutput.ReadToEnd()
        $stderr = $process.StandardError.ReadToEnd()
        $process.WaitForExit()
        if ($process.ExitCode -ne 0) {
            return [ordered]@{ path = $Path; raw = ''; semantic = ''; accepted = $false }
        }
        $combined = @($stdout, $stderr) -join "`n"
        $raw = [string]($combined -split "`r?`n" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -First 1)
        $raw = $raw.Trim()
        $match = [regex]::Match($raw, '(?<!\d)(\d+\.\d+\.\d+)')
        $semantic = if ($match.Success) { $match.Groups[1].Value } else { '' }
        return [ordered]@{
            path = $Path
            raw = $raw
            semantic = $semantic
            accepted = ($semantic -eq $ExpectedGodotVersion)
        }
    }
    finally {
        $process.Dispose()
    }
}

function Resolve-GodotBinary {
    param([string]$ExplicitPath)

    $candidates = New-Object System.Collections.ArrayList
    Add-GodotCandidate -List $candidates -Path $ExplicitPath -Priority 1
    Add-GodotCandidate -List $candidates -Path $env:GODOT_BINARY -Priority 2

    foreach ($name in @('godot', 'godot4', 'Godot')) {
        Add-GodotCandidate -List $candidates -Path $name -Priority 3
    }

    # Windows App Paths registry is read-only discovery.
    foreach ($registryKey in @(
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\App Paths\Godot.exe',
        'HKLM:\Software\Microsoft\Windows\CurrentVersion\App Paths\Godot.exe'
    )) {
        try {
            $property = Get-ItemProperty -LiteralPath $registryKey -ErrorAction Stop
            $defaultProperty = $property.PSObject.Properties['(default)']
            if ($null -ne $defaultProperty) {
                Add-GodotCandidate -List $candidates -Path ([string]$defaultProperty.Value) -Priority 4
            }
        }
        catch {
        }
    }

    $boundedRoots = @(
        (Join-Path $RepoRoot '.tools\godot'),
        $(if ($env:LOCALAPPDATA) { Join-Path $env:LOCALAPPDATA 'Programs' } else { $null }),
        $(if ($env:USERPROFILE) { Join-Path $env:USERPROFILE 'godot' } else { $null }),
        $(if ($env:USERPROFILE) { Join-Path $env:USERPROFILE 'Downloads' } else { $null }),
        $(if ($env:USERPROFILE) { Join-Path $env:USERPROFILE 'Desktop' } else { $null })
    )
    foreach ($root in $boundedRoots) {
        foreach ($file in (Get-BoundedGodotFiles -Root $root)) {
            Add-GodotCandidate -List $candidates -Path $file.FullName -Priority 5
        }
    }

    $evaluated = @()
    foreach ($candidate in ($candidates | Sort-Object priority, path)) {
        try {
            $version = Test-GodotVersion -Path $candidate.path
            $evaluated += [pscustomobject]@{
                path = $candidate.path
                priority = $candidate.priority
                raw = $version.raw
                semantic = $version.semantic
                accepted = $version.accepted
            }
        }
        catch {
        }
    }

    $accepted = @($evaluated | Where-Object { $_.accepted })
    if ($accepted.Count -eq 0 -and $AllowVersionMismatch) {
        $accepted = @($evaluated | Where-Object { -not [string]::IsNullOrWhiteSpace($_.semantic) })
    }
    if ($accepted.Count -eq 0) {
        if ($evaluated.Count -eq 0) {
            throw 'BLOCKED_GODOT_NOT_FOUND'
        }
        throw 'BLOCKED_GODOT_VERSION'
    }

    $bestPriority = ($accepted | Measure-Object -Property priority -Minimum).Minimum
    $best = @($accepted | Where-Object { $_.priority -eq $bestPriority } | Sort-Object path)
    if ($best.Count -gt 1 -and -not $NonInteractive) {
        Write-Host 'Godot 후보가 여러 개 발견되었습니다.'
        for ($index = 0; $index -lt $best.Count; $index++) {
            Write-Host ("[{0}] {1} ({2})" -f ($index + 1), $best[$index].path, $best[$index].raw)
        }
        do {
            $selection = Read-Host '사용할 번호를 입력하세요'
            $number = 0
            $valid = [int]::TryParse($selection, [ref]$number) -and $number -ge 1 -and $number -le $best.Count
        } until ($valid)
        return $best[$number - 1]
    }
    return $best[0]
}

function Resolve-SourceSaves {
    $main = $SourceMain
    $validation = $SourceValidation
    if ([string]::IsNullOrWhiteSpace($main)) {
        $main = Join-Path $env:APPDATA "Godot\app_userdata\$ProjectName\urban_legend_save.json"
    }
    if ([string]::IsNullOrWhiteSpace($validation)) {
        $defaultValidation = Join-Path $env:APPDATA "Godot\app_userdata\$ProjectName\urban_legend_validation_save.json"
        if (Test-Path -LiteralPath $defaultValidation -PathType Leaf) {
            $validation = $defaultValidation
        }
    }
    if (-not (Test-Path -LiteralPath $main -PathType Leaf)) {
        throw 'BLOCKED_NO_MAIN_SAVE'
    }
    if (-not [string]::IsNullOrWhiteSpace($validation) -and -not (Test-Path -LiteralPath $validation -PathType Leaf)) {
        $validation = $null
    }
    return [ordered]@{
        main = [System.IO.Path]::GetFullPath($main)
        validation = $(if ([string]::IsNullOrWhiteSpace($validation)) { $null } else { [System.IO.Path]::GetFullPath($validation) })
    }
}

function Read-Checklist {
    if (-not (Test-Path -LiteralPath $ChecklistPath -PathType Leaf)) {
        throw 'CHECKLIST_NOT_FOUND'
    }
    $payload = Get-Content -LiteralPath $ChecklistPath -Raw | ConvertFrom-Json
    if ([int]$payload.schema_version -ne 1) {
        throw 'CHECKLIST_SCHEMA_UNSUPPORTED'
    }
    $allowed = @($payload.allowed_statuses | ForEach-Object { [string]$_ })
    if (($allowed -join '|') -ne 'PASS|FAIL|BLOCKED|NOT_RUN') {
        throw 'CHECKLIST_STATUS_SET_INVALID'
    }
    $ids = @{}
    foreach ($item in $payload.items) {
        $id = [string]$item.id
        if ([string]::IsNullOrWhiteSpace($id) -or $ids.ContainsKey($id)) {
            throw 'CHECKLIST_ID_INVALID_OR_DUPLICATE'
        }
        $ids[$id] = $true
    }
    if (@($payload.items).Count -ne 18) {
        throw 'CHECKLIST_ITEM_COUNT_INVALID'
    }
    return $payload
}

function Show-HumanQaChecklist {
    param([Parameter(Mandatory = $true)][object]$Checklist)
    Write-Host ''
    Write-Host '=== 실제 Human QA 체크리스트 ==='
    Write-Host 'Godot 실행 중 아래 항목을 직접 확인하세요. 자동 테스트는 PASS를 대신 판정하지 않습니다.'
    $index = 1
    foreach ($item in $Checklist.items) {
        Write-Host ("{0}. [{1}] {2}" -f $index, $item.id, $item.title_ko)
        $index++
    }
    Write-Host ''
}

function Read-HumanQaResults {
    param([Parameter(Mandatory = $true)][object]$Checklist)
    $results = @()
    $privateNotes = @()
    foreach ($item in $Checklist.items) {
        if ($NonInteractive) {
            $status = $DefaultChecklistStatus
            $note = ''
        }
        else {
            do {
                $raw = Read-Host ("[{0}] PASS / FAIL / BLOCKED / NOT_RUN (빈 값=NOT_RUN)" -f $item.id)
                $status = if ([string]::IsNullOrWhiteSpace($raw)) { 'NOT_RUN' } else { $raw.Trim().ToUpperInvariant() }
                $valid = @('PASS', 'FAIL', 'BLOCKED', 'NOT_RUN') -contains $status
            } until ($valid)
            $note = Read-Host '선택 메모 (개인정보·저장 내용·절대 경로 입력 금지, Enter=없음)'
            if ($note.Length -gt 500 -or $note -match '(?i)[A-Z]:\\') {
                Write-Warning '메모가 개인정보 안전 경계를 벗어나 제거되었습니다.'
                $note = ''
            }
        }
        $results += [ordered]@{
            id = [string]$item.id
            category = [string]$item.category
            title_ko = [string]$item.title_ko
            status = $status
        }
        if (-not [string]::IsNullOrWhiteSpace($note)) {
            $privateNotes += [ordered]@{ id = [string]$item.id; note = $note }
        }
    }
    return [ordered]@{ results = $results; private_notes = $privateNotes }
}

function Write-LauncherState {
    param(
        [Parameter(Mandatory = $true)][string]$Root,
        [Parameter(Mandatory = $true)][string]$State,
        [string]$ErrorCode
    )
    if (-not ($KnownStates -contains $State)) {
        throw "UNKNOWN_LAUNCHER_STATE: $State"
    }
    Write-JsonFile -Path (Join-Path $Root '.control\launcher-state.local.json') -Value ([ordered]@{
        state = $State
        updated_at_utc = [DateTime]::UtcNow.ToString('o')
        error_code = $ErrorCode
    })
}

function Get-ResultCounts {
    param([Parameter(Mandatory = $true)][object[]]$Results)
    $counts = [ordered]@{ PASS = 0; FAIL = 0; BLOCKED = 0; NOT_RUN = 0 }
    foreach ($result in $Results) {
        $status = [string]$result.status
        $counts[$status] = [int]$counts[$status] + 1
    }
    return $counts
}

function Get-HumanQaClassification {
    param([Parameter(Mandatory = $true)][object]$Counts)
    if ([int]$Counts.FAIL -gt 0) { return 'HUMAN_QA_REVIEW_COMPLETE_FAIL' }
    if ([int]$Counts.BLOCKED -gt 0) { return 'HUMAN_QA_REVIEW_BLOCKED' }
    if ([int]$Counts.NOT_RUN -gt 0) { return 'HUMAN_QA_INCOMPLETE' }
    return 'HUMAN_QA_REVIEW_COMPLETE_PASS'
}

function Write-HumanQaSummary {
    param(
        [Parameter(Mandatory = $true)][string]$Root,
        [Parameter(Mandatory = $true)][object[]]$Results,
        [Parameter(Mandatory = $true)][object]$GodotInfo
    )
    $evidence = Join-Path $Root 'evidence'
    $collectionPath = Join-Path $evidence 'collection-summary.json'
    if (-not (Test-Path -LiteralPath $collectionPath -PathType Leaf)) {
        throw 'AUTOMATED_EVIDENCE_COLLECTION_FAILED'
    }
    $collection = Get-Content -LiteralPath $collectionPath -Raw | ConvertFrom-Json
    $counts = Get-ResultCounts -Results $Results
    $classification = Get-HumanQaClassification -Counts $counts
    $summary = [ordered]@{
        schema_version = 1
        generated_at_utc = [DateTime]::UtcNow.ToString('o')
        privacy_boundary = $PrivacyBoundary
        repository = 'alsdmlals4-eng/urban-legend'
        repository_head = Get-RepositoryHead
        godot_version = [string]$GodotInfo.raw
        source_main_unchanged = [bool]$collection.source_main_unchanged
        source_validation_unchanged = $collection.source_validation_unchanged
        automated_runner_status = 'AUTOMATED_LOCAL_HUMAN_QA_RUNNER_PREFLIGHT_GREEN'
        classification = $classification
        counts = $counts
        items = $Results
        privacy_review_required = $true
        merge_authorized = $false
    }
    Write-JsonFile -Path (Join-Path $evidence 'human-qa-summary.json') -Value $summary

    $lines = @(
        '# Human QA Summary',
        '',
        ('- Classification: `{0}`' -f $classification),
        ('- Repository head: `{0}`' -f $summary.repository_head),
        ('- Godot version: `{0}`' -f $summary.godot_version),
        ('- Original main save unchanged: `{0}`' -f $summary.source_main_unchanged),
        ('- PASS / FAIL / BLOCKED / NOT_RUN: {0} / {1} / {2} / {3}' -f $counts.PASS, $counts.FAIL, $counts.BLOCKED, $counts.NOT_RUN),
        ('- Privacy boundary: `{0}`' -f $PrivacyBoundary),
        '- Logs must be manually reviewed for personal information before sharing.',
        '- This result does not authorize merge or release.',
        '',
        '## Checklist'
    )
    foreach ($result in $Results) {
        $lines += ('- [{0}] {1}: {2}' -f $result.status, $result.id, $result.title_ko)
    }
    $lines | Set-Content -LiteralPath (Join-Path $evidence 'HUMAN_QA_SUMMARY.md') -Encoding UTF8
    return $summary
}

function Invoke-ExistingRunner {
    param([Parameter(Mandatory = $true)][hashtable]$Arguments)
    & $Runner @Arguments
}

if (-not (Test-Path -LiteralPath (Join-Path $RepoRoot 'project.godot') -PathType Leaf)) {
    throw 'GODOT_PROJECT_NOT_FOUND'
}
if (-not (Test-Path -LiteralPath $Runner -PathType Leaf)) {
    throw 'BASE_RUNNER_NOT_FOUND'
}
if ($SkipLaunch -and -not $NonInteractive) {
    throw 'SKIP_LAUNCH_REQUIRES_NON_INTERACTIVE'
}

$resolvedQaRoot = if ([string]::IsNullOrWhiteSpace($QaRoot)) { Get-DefaultQaRoot } else { [System.IO.Path]::GetFullPath($QaRoot) }
New-Item -ItemType Directory -Force -Path $resolvedQaRoot | Out-Null
Write-LauncherState -Root $resolvedQaRoot -State 'PREFLIGHT'

try {
    $checklist = Read-Checklist
    $saves = Resolve-SourceSaves
    $godot = Resolve-GodotBinary -ExplicitPath $GodotBinary

    $dirty = (& git -C $RepoRoot status --short 2>$null)
    if ($dirty) {
        Write-Warning '작업 트리에 변경이 있습니다. 이 도구는 정리하거나 삭제하지 않지만 결과 해석 시 주의하세요.'
    }

    Write-Host ("Repository HEAD: {0}" -f (Get-RepositoryHead))
    Write-Host ("Godot: {0}" -f $godot.raw)
    Write-Host 'QA root를 준비했습니다. 원본 저장 내용과 절대 경로는 출력하지 않습니다.'
    Show-HumanQaChecklist -Checklist $checklist

    if (-not $NonInteractive) {
        $confirmation = Read-Host '격리 복사본으로 Human QA를 시작할까요? (Y/N)'
        if ($confirmation.Trim().ToUpperInvariant() -notin @('Y', 'YES')) {
            Write-LauncherState -Root $resolvedQaRoot -State 'USER_CANCELLED'
            Write-Host 'USER_CANCELLED'
            exit 3
        }
    }

    Write-LauncherState -Root $resolvedQaRoot -State 'READY'
    $prepareArguments = @{ Stage = 'Prepare'; SourceMain = $saves.main; QaRoot = $resolvedQaRoot }
    if (-not [string]::IsNullOrWhiteSpace([string]$saves.validation)) {
        $prepareArguments.SourceValidation = $saves.validation
    }
    try {
        Invoke-ExistingRunner -Arguments $prepareArguments
    }
    catch {
        Write-LauncherState -Root $resolvedQaRoot -State 'PREPARE_FAILED' -ErrorCode $_.Exception.Message
        throw
    }
    Write-LauncherState -Root $resolvedQaRoot -State 'PREPARED'

    if (-not $SkipLaunch) {
        try {
            Invoke-ExistingRunner -Arguments @{
                Stage = 'Launch'
                QaRoot = $resolvedQaRoot
                GodotBinary = $godot.path
                RepoRoot = $RepoRoot
                WaitForExit = $true
            }
        }
        catch {
            Write-LauncherState -Root $resolvedQaRoot -State 'LAUNCH_FAILED' -ErrorCode $_.Exception.Message
            throw
        }
        Write-LauncherState -Root $resolvedQaRoot -State 'LAUNCHED'
    }

    $review = Read-HumanQaResults -Checklist $checklist
    Write-JsonFile -Path (Join-Path $resolvedQaRoot '.control\human-notes.local.json') -Value $review.private_notes
    Write-LauncherState -Root $resolvedQaRoot -State 'HUMAN_REVIEW_RECORDED'

    try {
        Invoke-ExistingRunner -Arguments @{ Stage = 'Collect'; QaRoot = $resolvedQaRoot }
    }
    catch {
        $state = if ($_.Exception.Message -match 'SOURCE_MUTATED') { 'SOURCE_MUTATED' } else { 'COLLECT_FAILED' }
        Write-LauncherState -Root $resolvedQaRoot -State $state -ErrorCode $_.Exception.Message
        throw
    }
    Write-LauncherState -Root $resolvedQaRoot -State 'EVIDENCE_COLLECTED'

    $summary = Write-HumanQaSummary -Root $resolvedQaRoot -Results @($review.results) -GodotInfo $godot
    Write-LauncherState -Root $resolvedQaRoot -State 'COMPLETE'

    Write-Host ''
    Write-Host ("Classification: {0}" -f $summary.classification)
    Write-Host ("Evidence: {0}" -f (Join-Path $resolvedQaRoot 'evidence'))
    Write-Host '검토한 evidence만 공유하세요. .control, AppData, 실제 저장 원본은 공유하지 마세요.'
    exit 0
}
catch {
    $message = $_.Exception.Message
    $state = $null
    if ($message -match 'BLOCKED_NO_MAIN_SAVE') { $state = 'BLOCKED_NO_MAIN_SAVE' }
    elseif ($message -match 'BLOCKED_GODOT_NOT_FOUND') { $state = 'BLOCKED_GODOT_NOT_FOUND' }
    elseif ($message -match 'BLOCKED_GODOT_VERSION') { $state = 'BLOCKED_GODOT_VERSION' }
    elseif ($message -match 'SOURCE_MUTATED') { $state = 'SOURCE_MUTATED' }
    if ($null -ne $state) {
        try { Write-LauncherState -Root $resolvedQaRoot -State $state -ErrorCode $message } catch { }
    }
    Write-Error $message
    if ($state -eq 'BLOCKED_NO_MAIN_SAVE') { exit 10 }
    if ($state -eq 'BLOCKED_GODOT_NOT_FOUND') { exit 11 }
    if ($state -eq 'BLOCKED_GODOT_VERSION') { exit 12 }
    if ($state -eq 'SOURCE_MUTATED') { exit 20 }
    exit 1
}
