param(
    [string]$GodotBinary = "godot"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
if ([string]::IsNullOrWhiteSpace($env:AFTERLIFE_QA_APPDATA)) {
    $env:AFTERLIFE_QA_APPDATA = Join-Path $env:TEMP "afterlife-canon-v2-windows-platform"
}
$env:APPDATA = $env:AFTERLIFE_QA_APPDATA

$UserDataRoot = Join-Path $env:APPDATA "Godot\app_userdata\urban-legend"
$CaseDir = Join-Path $UserDataRoot "afterlife_windows"
$NativePrimary = Join-Path $CaseDir "save.json"
$GodotPrimary = "user://afterlife_windows/save.json"
$Fixture = Join-Path $RepoRoot "tests\fixtures\afterlife_migration\main_mvp039_recovery.json"
$PhaseScript = "res://tests/afterlife_migration/afterlife_windows_platform_phase_test.gd"
$LockScript = "res://tests/afterlife_migration/afterlife_windows_locked_file_test.gd"
$LogDir = Join-Path $env:AFTERLIFE_QA_APPDATA "logs"
$JournalPath = Join-Path $CaseDir "save.migration.journal.json"

New-Item -ItemType Directory -Force -Path $CaseDir | Out-Null
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null

function Get-Sha256 {
    param([Parameter(Mandatory = $true)][string]$Path)
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}

function Remove-TransactionArtifacts {
    Get-ChildItem -LiteralPath $CaseDir -Filter "save.migration.*.json" -ErrorAction SilentlyContinue |
        Remove-Item -Force -ErrorAction SilentlyContinue
}

function Reset-Fixture {
    Remove-TransactionArtifacts
    Copy-Item -LiteralPath $Fixture -Destination $NativePrimary -Force
    if (-not (Test-Path -LiteralPath $NativePrimary)) {
        throw "Fixture copy failed: $NativePrimary"
    }
}

function Invoke-GodotScript {
    param(
        [Parameter(Mandatory = $true)][string]$Script,
        [Parameter(Mandatory = $true)][string]$LogName,
        [string[]]$UserArgs = @()
    )
    $arguments = @("--headless", "--path", $RepoRoot, "--script", $Script)
    if ($UserArgs.Count -gt 0) {
        $arguments += "--"
        $arguments += $UserArgs
    }
    $stdoutPath = Join-Path $LogDir "$LogName.stdout.log"
    $stderrPath = Join-Path $LogDir "$LogName.stderr.log"
    $process = Start-Process -FilePath $GodotBinary -ArgumentList $arguments -Wait -PassThru `
        -RedirectStandardOutput $stdoutPath -RedirectStandardError $stderrPath
    $stdout = Get-Content -LiteralPath $stdoutPath -Raw -ErrorAction SilentlyContinue
    $stderr = Get-Content -LiteralPath $stderrPath -Raw -ErrorAction SilentlyContinue
    $combined = @($stdout, $stderr) -join "`n"
    $combined | Set-Content -LiteralPath (Join-Path $LogDir "$LogName.log") -Encoding UTF8
    if ($process.ExitCode -ne 0) {
        throw "Godot script failed ($($process.ExitCode)): $Script / $LogName"
    }
    return $combined
}

function Wait-TransactionState {
    param(
        [Parameter(Mandatory = $true)][System.Diagnostics.Process]$Process,
        [Parameter(Mandatory = $true)][string]$ExpectedState
    )
    $deadline = [DateTime]::UtcNow.AddSeconds(90)
    while ([DateTime]::UtcNow -lt $deadline) {
        if ($Process.HasExited) {
            throw "Godot exited before journal reached $ExpectedState"
        }
        if (Test-Path -LiteralPath $JournalPath) {
            try {
                $journal = Get-Content -LiteralPath $JournalPath -Raw | ConvertFrom-Json
                if ([string]$journal.state -eq $ExpectedState) {
                    return
                }
            }
            catch {
                # The writer may be between create and close; poll again.
            }
        }
        Start-Sleep -Milliseconds 200
    }
    throw "Timed out waiting for transaction state $ExpectedState"
}

function Invoke-ForcedTerminationRecovery {
    param(
        [Parameter(Mandatory = $true)][string]$HoldMode,
        [Parameter(Mandatory = $true)][string]$ExpectedState,
        [Parameter(Mandatory = $true)][string]$RecoverMode,
        [Parameter(Mandatory = $true)][string]$LogPrefix
    )
    Reset-Fixture
    $sourceHash = Get-Sha256 -Path $NativePrimary
    $stdoutPath = Join-Path $LogDir "$LogPrefix-hold.stdout.log"
    $stderrPath = Join-Path $LogDir "$LogPrefix-hold.stderr.log"
    $arguments = @(
        "--headless", "--path", $RepoRoot,
        "--script", $PhaseScript,
        "--", "--mode", $HoldMode, "--primary", $GodotPrimary
    )
    $process = Start-Process -FilePath $GodotBinary -ArgumentList $arguments -PassThru `
        -RedirectStandardOutput $stdoutPath -RedirectStandardError $stderrPath
    try {
        Wait-TransactionState -Process $process -ExpectedState $ExpectedState
        Stop-Process -Id $process.Id -Force
        $process.WaitForExit()
    }
    finally {
        if (-not $process.HasExited) {
            Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
        }
    }
    Invoke-GodotScript -Script $PhaseScript -LogName "$LogPrefix-recover" `
        -UserArgs @("--mode", $RecoverMode, "--primary", $GodotPrimary) | Out-Null
    $restoredHash = Get-Sha256 -Path $NativePrimary
    if ($restoredHash -ne $sourceHash) {
        throw "$ExpectedState recovery changed source bytes"
    }
    if (Test-Path -LiteralPath $JournalPath) {
        throw "$ExpectedState recovery left a journal"
    }
}

# 1. Exclusive Windows lock: migration must fail closed and source bytes remain unchanged.
Reset-Fixture
$lockHash = Get-Sha256 -Path $NativePrimary
$env:AFTERLIFE_QA_PRIMARY = $GodotPrimary
$env:AFTERLIFE_QA_EXPECTED_HASH = $lockHash
$lock = [System.IO.File]::Open(
    $NativePrimary,
    [System.IO.FileMode]::Open,
    [System.IO.FileAccess]::ReadWrite,
    [System.IO.FileShare]::None
)
try {
    Invoke-GodotScript -Script $LockScript -LogName "exclusive-lock" | Out-Null
}
finally {
    $lock.Dispose()
}
if ((Get-Sha256 -Path $NativePrimary) -ne $lockHash) {
    throw "Exclusive lock path changed source bytes"
}

# 2. PREPARED process termination: the next process must abort and preserve source.
Invoke-ForcedTerminationRecovery -HoldMode "hold_prepared" -ExpectedState "PREPARED" `
    -RecoverMode "recover_prepared" -LogPrefix "prepared-crash"

# 3. COMMITTED_PENDING_RUNTIME_APPLY process termination: the next process must ROLLBACK_RESTORED.
Invoke-ForcedTerminationRecovery -HoldMode "hold_pending" `
    -ExpectedState "COMMITTED_PENDING_RUNTIME_APPLY" -RecoverMode "recover_pending" `
    -LogPrefix "pending-crash"

# 4. Source race must return SOURCE_CHANGED without transaction artifacts.
Reset-Fixture
$raceOutput = Invoke-GodotScript -Script $PhaseScript -LogName "source-changed" `
    -UserArgs @("--mode", "source_changed", "--primary", $GodotPrimary)
if ($raceOutput -notmatch "PASS") {
    throw "SOURCE_CHANGED contract did not complete"
}
Remove-TransactionArtifacts

# 5. Deterministic write failure injection must return WRITE_FAILED and preserve the source.
Reset-Fixture
$writeHash = Get-Sha256 -Path $NativePrimary
$writeOutput = Invoke-GodotScript -Script $PhaseScript -LogName "write-failed-injected" `
    -UserArgs @("--mode", "write_failed", "--primary", $GodotPrimary)
if ($writeOutput -notmatch "PASS") {
    throw "WRITE_FAILED injection contract did not complete"
}
if ((Get-Sha256 -Path $NativePrimary) -ne $writeHash) {
    throw "WRITE_FAILED injection changed source bytes"
}

# 6. Real Windows ACL denial must surface WRITE_FAILED and preserve source bytes.
Reset-Fixture
$aclHash = Get-Sha256 -Path $NativePrimary
$identity = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$aclLog = Join-Path $LogDir "acl.log"
try {
    (& icacls $CaseDir /deny "${identity}:(W)" /T /C) | Set-Content -LiteralPath $aclLog -Encoding UTF8
    if ($LASTEXITCODE -ne 0) {
        throw "icacls deny failed: $LASTEXITCODE"
    }
    Invoke-GodotScript -Script $PhaseScript -LogName "write-failed-acl" `
        -UserArgs @("--mode", "write_acl", "--primary", $GodotPrimary) | Out-Null
}
finally {
    (& icacls $CaseDir /remove:d $identity /T /C) | Add-Content -LiteralPath $aclLog -Encoding UTF8
}
if ((Get-Sha256 -Path $NativePrimary) -ne $aclHash) {
    throw "ACL WRITE_FAILED path changed source bytes"
}

Write-Host "PREPARED"
Write-Host "COMMITTED_PENDING_RUNTIME_APPLY"
Write-Host "ROLLBACK_RESTORED"
Write-Host "SOURCE_CHANGED"
Write-Host "WRITE_FAILED"
Write-Host "AFTERLIFE WINDOWS PLATFORM PREFLIGHT: PASS"
