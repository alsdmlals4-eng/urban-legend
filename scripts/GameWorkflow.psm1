Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Invoke-Git {
    param(
        [Parameter(Mandatory)][string]$GitPath,
        [Parameter(Mandatory)][string]$WorkingDirectory,
        [Parameter(Mandatory)][string[]]$Arguments,
        [switch]$AllowFailure
    )

    $previousPreference = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        $output = & $GitPath -C $WorkingDirectory @Arguments 2>&1
        $exitCode = $LASTEXITCODE
    }
    finally {
        $ErrorActionPreference = $previousPreference
    }
    if (-not $AllowFailure -and $exitCode -ne 0) {
        throw "git $($Arguments -join ' ') failed ($exitCode): $($output -join [Environment]::NewLine)"
    }
    [pscustomobject]@{ exit_code = $exitCode; output = @($output) }
}

function Test-PathPattern {
    param([string]$Path, [string[]]$Patterns)
    $normalized = $Path.Replace('\','/')
    foreach ($pattern in $Patterns) {
        if ($normalized -like $pattern.Replace('\','/')) { return $true }
    }
    return $false
}

function Test-SafeRelativePath {
    param([Parameter(Mandatory)][string]$Path)
    if ([IO.Path]::IsPathRooted($Path)) { return $false }
    $normalized = $Path.Replace('\','/')
    if ($normalized -match '(^|/)\.\.(/|$)' -or $normalized.StartsWith('/')) { return $false }
    return $true
}

function Resolve-OpenCodeExecutable {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Path)
    if ([IO.Path]::GetFileName($Path) -ieq 'opencode.cmd') {
        $candidate = Join-Path (Split-Path -Parent $Path) 'node_modules\opencode-ai\bin\opencode.exe'
        if (Test-Path -LiteralPath $candidate -PathType Leaf) { return (Resolve-Path -LiteralPath $candidate).Path }
    }
    return $Path
}

function Get-MultiModelTaskRoute {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$TaskText,
        [string[]]$ExpectedFiles = @(),
        [Parameter(Mandatory)]$Config
    )

    $protected = @($ExpectedFiles | Where-Object { Test-PathPattern $_ @($Config.protected_paths) })
    $highRisk = @($Config.high_risk_terms | Where-Object { $TaskText -match [regex]::Escape([string]$_) })
    $reserved = ($protected.Count -gt 0 -or $highRisk.Count -gt 0)
    $dialogue = ($TaskText -match '(?i)rewrite|write|author|revise|수정|작성|리라이트') -and ($TaskText -match '(?i)dialogue|tutorial|character voice|emotion|situational reaction|대사|튜토리얼|말투|감정선|상황.*반응')
    $image = $TaskText -match '(?i)transparent.*png|png.*sprite|character sprite|background asset|raster|concept art|이미지|스프라이트|배경.*자산|콘셉트'
    $design = $TaskText -match '(?i)long.*design|design proposal|ux (copy|writing|plan)|기획서|UX 문구|캐릭터 설정'
    $document = $TaskText -match '(?i)documentation|document rewrite|rewrite.*document|문서.*수정|문서.*작성'
    $readOnly = $TaskText -match '(?i)inspect|investigate|analy[sz]e|explain|research|benchmark|read.?only|조사|분석|설명|읽기.?전용|벤치마크'
    $web = $TaskText -match '(?i)public web|web research|online|sources?|citations?|benchmark|공개.?웹|출처|벤치마크'
    $micro = $TaskText -match '(?i)micro change|20 lines|one file|한 파일.*20줄|20줄.*이하'

    $workType='implementation'; $provider='deepseek'; $agent='builder-flash'; $risk='R1'
    $capabilities=@('read','edit'); $artifacts=@('WORKER_REPORT.txt'); $gate='codex-review'; $verification='bounded-code'; $reasons=@()
    if ($readOnly) {
        $workType=if($web){'web-research'}else{'local-research'}; $provider='deepseek'; $agent=if($web){'research-scout-flash'}else{'scout-flash'}; $risk='R0'
        $capabilities=if($web){@('read','web')}else{@('read')}; $artifacts=@('WORKER_REPORT.txt'); $gate='codex-review'; $verification='evidence-review'
    } elseif ($dialogue) {
        $workType='dialogue-authoring'; $provider='external-gpt'; $agent=$null; $risk=if($reserved){'R3'}else{'R2'}
        $capabilities=@('read','prose-authoring'); $artifacts=@('dialogue_rewrite.patch','dialogue_review.md'); $gate='external-upload'; $verification='dialogue-patch'
    } elseif ($image) {
        $workType='raster-asset'; $provider='imagegen'; $agent=$null; $risk='R2'
        $capabilities=@('read','image-generation'); $artifacts=@('concept-*.png','ASSET_MANIFEST.json'); $gate='concept-selection'; $verification='image-asset'
    } elseif ($design) {
        $workType='creative-design'; $provider='external-gpt'; $agent=$null; $risk='R2'
        $capabilities=@('read','prose-authoring'); $artifacts=@('DESIGN_PROPOSAL.md','DESIGN_REVIEW.md'); $gate='external-upload'; $verification='design-review'
    } elseif ($document) {
        $workType='document-rewrite'; $provider='external-gpt'; $agent=$null; $risk=if($reserved){'R3'}else{'R2'}
        $capabilities=@('read','prose-authoring'); $artifacts=@('document_rewrite.patch','document_review.md'); $gate='external-upload'; $verification='document-patch'
    } elseif ($reserved) {
        $workType='core-implementation'; $provider='codex'; $agent=$null; $risk='R3'
        $capabilities=@('read','edit','core-state'); $artifacts=@('verified-diff'); $gate='user-approval'; $verification='full'; $reasons += @($protected | ForEach-Object { "protected path: $_" }); $reasons += @($highRisk | ForEach-Object { "high-risk term: $_" })
    } elseif ($micro -and $ExpectedFiles.Count -le 1) {
        $workType='micro-change'; $provider='codex'; $agent=$null; $risk='R1'; $capabilities=@('read','edit'); $artifacts=@('verified-diff'); $gate='none'; $verification='targeted'
    } elseif ($ExpectedFiles.Count -ge 3 -and $ExpectedFiles.Count -le 5) {
        $workType='cohesive-draft'; $provider='deepseek'; $agent='builder-flash'; $risk='R2'; $capabilities=@('read','edit'); $artifacts=@('WORKER_REPORT.txt','worktree-diff'); $gate='codex-review'; $verification='draft-only'
    } elseif ($ExpectedFiles.Count -gt 5) {
        $workType='large-implementation'; $provider='codex'; $agent=$null; $risk='R2'; $capabilities=@('read','edit'); $artifacts=@('verified-diff'); $gate='codex-review'; $verification='full'
    }
    if ($reasons.Count -eq 0) { $reasons = @("$workType route") }
    [pscustomobject]@{
        work_type=$workType; provider=$provider; agent=$agent; worker=if($agent){$agent}else{$provider}; risk=$risk
        required_capabilities=@($capabilities); artifact_contract=@($artifacts); approval_gate=$gate
        verification_profile=$verification; codex_reserved=[bool]($reserved -or $provider -eq 'codex')
        requires_user_approval=($gate -eq 'user-approval'); reasons=@($reasons)
    }
}

function Get-GameTaskRisk {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$TaskText,
        [string[]]$ExpectedFiles = @(),
        [Parameter(Mandatory)]$Config
    )

    return Get-MultiModelTaskRoute -TaskText $TaskText -ExpectedFiles $ExpectedFiles -Config $Config
    <# Legacy implementation retained below temporarily for source compatibility. #>
    $reasons = [System.Collections.Generic.List[string]]::new()
    $protected = @($ExpectedFiles | Where-Object { Test-PathPattern $_ @($Config.protected_paths) })
    if ($protected.Count -gt 0) {
        $reasons.Add("protected path: $($protected -join ', ')")
    }

    foreach ($term in @($Config.high_risk_terms)) {
        if ($TaskText -match [regex]::Escape([string]$term)) {
            $reasons.Add("high-risk term: $term")
        }
    }

    if ($ExpectedFiles.Count -ge 3) {
        $reasons.Add("three or more core files")
    }

    if ($reasons.Count -gt 0) {
        return [pscustomobject]@{ risk = 'R3'; worker = 'codex'; requires_user_approval = $true; reasons = @($reasons) }
    }

    $readOnlyPattern = '(?i)inspect|investigate|analy[sz]e|explain|research|benchmark|read.?only|\uC870\uC0AC|\uBD84\uC11D|\uC124\uBA85|\uC77D\uAE30.?\uC804\uC6A9|\uBCA4\uCE58\uB9C8\uD06C'
    if ($ExpectedFiles.Count -eq 0 -and $TaskText -match $readOnlyPattern) {
        $webPattern = '(?i)public web|web research|online|sources?|citations?|benchmark|\uACF5\uAC1C.?(\uC6F9|\uC790\uB8CC)|\uCD9C\uCC98|\uBCA4\uCE58\uB9C8\uD06C'
        $needsWeb = $TaskText -match $webPattern
        $worker = if ($needsWeb) { 'research-scout-flash' } else { 'scout-flash' }
        $capabilities = if ($needsWeb) { @('read','web') } else { @('read') }
        return [pscustomobject]@{ risk = 'R0'; worker = $worker; required_capabilities = $capabilities; requires_user_approval = $false; reasons = @('read-only request') }
    }

    if ($ExpectedFiles.Count -le [int]$Config.low_risk_max_files) {
        return [pscustomobject]@{ risk = 'R1'; worker = 'builder-flash'; required_capabilities = @('read','edit'); requires_user_approval = $false; reasons = @('bounded non-protected change') }
    }

    [pscustomobject]@{ risk = 'R2'; worker = 'codex'; requires_user_approval = $false; reasons = @('standard implementation') }
}

function Test-ExternalArtifactPacket {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$RepoPath,
        [Parameter(Mandatory)][string]$PacketRoot,
        [Parameter(Mandatory)][string[]]$AllowedFiles,
        [Parameter(Mandatory)][string]$PatchName,
        [Parameter(Mandatory)][string]$ReviewName,
        [string[]]$ProtectedPaths = @(),
        [string]$GitPath = 'C:\Program Files\Git\cmd\git.exe'
    )
    $reasons = [System.Collections.Generic.List[string]]::new()
    $patchPath = Join-Path $PacketRoot $PatchName
    $reviewPath = Join-Path $PacketRoot $ReviewName
    if (-not (Test-Path -LiteralPath $patchPath -PathType Leaf)) { $reasons.Add("missing artifact: $PatchName") }
    if (-not (Test-Path -LiteralPath $reviewPath -PathType Leaf)) { $reasons.Add("missing review: $ReviewName") }
    $manifestPath = Join-Path $PacketRoot 'INPUT_MANIFEST.json'
    if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) { $reasons.Add('missing INPUT_MANIFEST.json') }
    else {
        $manifest = [IO.File]::ReadAllText($manifestPath, [Text.Encoding]::UTF8) | ConvertFrom-Json
        foreach ($input in @($manifest.inputs)) {
            if (-not (Test-SafeRelativePath ([string]$input.path))) { $reasons.Add("unsafe manifest path: $($input.path)"); continue }
            $source = Join-Path $RepoPath ([string]$input.path)
            if (-not (Test-Path -LiteralPath $source -PathType Leaf)) { $reasons.Add("source missing: $($input.path)"); continue }
            $actual = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash.ToLowerInvariant()
            if ($actual -ne ([string]$input.sha256).ToLowerInvariant()) { $reasons.Add("source hash mismatch: $($input.path)") }
        }
    }
    if (Test-Path -LiteralPath $patchPath -PathType Leaf) {
        $patchText = [IO.File]::ReadAllText($patchPath, [Text.Encoding]::UTF8)
        $paths = @([regex]::Matches($patchText, '(?m)^\+\+\+\s+(?:b/)?([^\r\n]+)$') | ForEach-Object { $_.Groups[1].Value.Trim() } | Where-Object { $_ -ne '/dev/null' })
        foreach ($path in $paths) {
            if (-not (Test-SafeRelativePath $path)) { $reasons.Add("unsafe patch path: $path"); continue }
            if ($AllowedFiles -notcontains $path) { $reasons.Add("unapproved patch path: $path") }
            if (Test-PathPattern $path $ProtectedPaths) { $reasons.Add("protected patch path: $path") }
        }
        if ($paths.Count -eq 0) { $reasons.Add('patch contains no target path') }
        if ($reasons.Count -eq 0 -and (Test-Path -LiteralPath $GitPath -PathType Leaf) -and (Test-Path -LiteralPath (Join-Path $RepoPath '.git'))) {
            $check = Invoke-Git $GitPath $RepoPath @('apply','--check',$patchPath) -AllowFailure
            if ($check.exit_code -ne 0) { $reasons.Add("git apply --check failed: $($check.output -join ' ')") }
        }
    }
    [pscustomobject]@{ passed=($reasons.Count -eq 0); reasons=@($reasons); patch=$patchPath; review=$reviewPath }
}

function Test-ImageArtifactManifest {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$ArtifactRoot,[Parameter(Mandatory)][string]$ManifestPath)
    $reasons = [System.Collections.Generic.List[string]]::new()
    if (-not (Test-Path -LiteralPath $ManifestPath -PathType Leaf)) { return [pscustomobject]@{passed=$false;state='invalid';reasons=@('manifest missing')} }
    $manifest = [IO.File]::ReadAllText($ManifestPath, [Text.Encoding]::UTF8) | ConvertFrom-Json
    $stage = [string]$manifest.stage
    if ($stage -eq 'concept' -and (@($manifest.assets).Count -lt 2 -or @($manifest.assets).Count -gt 3)) { $reasons.Add('concept stage requires 2-3 assets') }
    if ($stage -eq 'final' -and -not $manifest.selected_concept) { $reasons.Add('final stage requires selected_concept') }
    if ($stage -notin @('concept','final')) { $reasons.Add("unsupported stage: $stage") }
    $root = [IO.Path]::GetFullPath($ArtifactRoot)
    foreach ($asset in @($manifest.assets)) {
        $relative = [string]$asset.file
        if (-not (Test-SafeRelativePath $relative)) { $reasons.Add("unsafe asset path: $relative"); continue }
        $full = [IO.Path]::GetFullPath((Join-Path $root $relative))
        if (-not $full.StartsWith($root + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) { $reasons.Add("asset escapes root: $relative"); continue }
        if ([IO.Path]::GetExtension($full) -ne '.png' -or -not (Test-Path -LiteralPath $full -PathType Leaf)) { $reasons.Add("PNG missing: $relative") }
        if ([int]$asset.width -le 0 -or [int]$asset.height -le 0) { $reasons.Add("invalid dimensions: $relative") }
        if ($manifest.transparent_requested -and -not [bool]$asset.has_alpha) { $reasons.Add("alpha required: $relative") }
        if ($stage -eq 'final' -and -not $asset.reference_image) { $reasons.Add("reference image required: $relative") }
    }
    $state = if ($reasons.Count -gt 0) {'invalid'} elseif ($stage -eq 'concept') {'ready-for-concept-approval'} else {'ready-for-review'}
    [pscustomobject]@{ passed=($reasons.Count -eq 0); state=$state; reasons=@($reasons); stage=$stage }
}

function Get-WorkflowPolicy {
    [CmdletBinding()]
    param([Parameter(Mandatory)]$Config)

    $schemaVersion = if ($Config.PSObject.Properties.Name -contains 'schema_version') { [int]$Config.schema_version } else { 1 }
    $maxRecoveryAttempts = if ($Config.PSObject.Properties.Name -contains 'max_recovery_attempts') { [int]$Config.max_recovery_attempts } else { 1 }
    $staleRunMinutes = if ($Config.PSObject.Properties.Name -contains 'stale_run_minutes') { [int]$Config.stale_run_minutes } else { 15 }
    [pscustomobject]@{
        schema_version = $schemaVersion
        max_recovery_attempts = $maxRecoveryAttempts
        stale_run_minutes = $staleRunMinutes
    }
}

function Test-AgentContractCompatibility {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][ValidateSet('scout-flash','research-scout-flash','builder-flash')][string]$Agent,
        [string[]]$RequiredCapabilities = @('read')
    )

    $capabilities = switch ($Agent) {
        'scout-flash' { @('read') }
        'research-scout-flash' { @('read','web') }
        'builder-flash' { @('read','edit') }
    }
    foreach ($required in $RequiredCapabilities) {
        if ($capabilities -notcontains $required) { return $false }
    }
    return $true
}

function New-GameTaskWorktree {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$RepoPath,
        [Parameter(Mandatory)][ValidatePattern('^[a-z0-9][a-z0-9-]{0,62}$')][string]$TaskId,
        [Parameter(Mandatory)][string]$GitPath,
        [string[]]$PreservedDirtyPaths = @()
    )

    $repo = (Resolve-Path -LiteralPath $RepoPath).Path
    $status = Invoke-Git $GitPath $repo @('status','--porcelain=v1')
    $blocking = @($status.output | ForEach-Object {
        $line = [string]$_
        if ($line.Length -lt 4) { return }
        $path = $line.Substring(3).Trim('"').Replace('\','/')
        if ($path -match ' -> ') { $path = ($path -split ' -> ')[-1].Trim('"') }
        if (-not (Test-PathPattern $path $PreservedDirtyPaths)) { $path }
    })
    if ($blocking.Count -gt 0) { throw "Main worktree has non-preserved changes before delegation: $($blocking -join ', ')" }

    $probe = Invoke-Git $GitPath $repo @('check-ignore','-q','.worktrees/probe') -AllowFailure
    if ($probe.exit_code -ne 0) { throw '.worktrees/ must be ignored before creating task worktrees.' }

    $branch = "worker/$TaskId"
    $worktree = Join-Path $repo ".worktrees\$TaskId"
    if (Test-Path -LiteralPath $worktree) { throw "Task worktree already exists: $worktree" }

    $branchCheck = Invoke-Git $GitPath $repo @('show-ref','--verify','--quiet',"refs/heads/$branch") -AllowFailure
    if ($branchCheck.exit_code -eq 0) { throw "Task branch already exists: $branch" }

    Invoke-Git $GitPath $repo @('worktree','add',$worktree,'-b',$branch) | Out-Null
    [pscustomobject]@{ task_id = $TaskId; branch = $branch; worktree = $worktree }
}

function Get-ChangedFiles {
    param([string]$WorktreePath, [string]$GitPath)
    $status = Invoke-Git $GitPath $WorktreePath @('status','--porcelain=v1','--untracked-files=all')
    $paths = foreach ($line in $status.output) {
        $text = [string]$line
        if ($text.Length -lt 4) { continue }
        $path = $text.Substring(3).Trim('"')
        if ($path -match ' -> ') { $path = ($path -split ' -> ')[-1].Trim('"') }
        $path.Replace('\','/')
    }
    @($paths | Sort-Object -Unique)
}

function Invoke-CapturedPowerShell {
    param([string]$Command, [string]$WorkingDirectory)
    $psi = [System.Diagnostics.ProcessStartInfo]::new()
    $psi.FileName = 'powershell.exe'
    $psi.WorkingDirectory = $WorkingDirectory
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($Command))
    $psi.Arguments = "-NoProfile -NonInteractive -EncodedCommand $encoded"
    $process = [System.Diagnostics.Process]::Start($psi)
    $stdout = $process.StandardOutput.ReadToEnd()
    $stderr = $process.StandardError.ReadToEnd()
    $process.WaitForExit()
    [pscustomobject]@{ command = $Command; exit_code = $process.ExitCode; stdout = $stdout; stderr = $stderr }
}

function ConvertTo-ProcessArgument {
    param([string]$Value)
    if ($Value -notmatch '[\s"]') { return $Value }
    '"' + ($Value -replace '(\\*)"', '$1$1\"' -replace '(\\+)$', '$1$1') + '"'
}

function Invoke-CapturedProcess {
    param([string]$FilePath, [string[]]$Arguments, [string]$WorkingDirectory)
    $psi = [System.Diagnostics.ProcessStartInfo]::new()
    $psi.FileName = $FilePath
    $psi.Arguments = (@($Arguments | ForEach-Object { ConvertTo-ProcessArgument ([string]$_) }) -join ' ')
    $psi.WorkingDirectory = $WorkingDirectory
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $process = [System.Diagnostics.Process]::Start($psi)
    $stdout = $process.StandardOutput.ReadToEnd()
    $stderr = $process.StandardError.ReadToEnd()
    $process.WaitForExit()
    [pscustomobject]@{
        command = "$FilePath $($Arguments -join ' ')"
        exit_code = $process.ExitCode
        stdout = $stdout
        stderr = $stderr
    }
}

function Test-GameTaskWorktree {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$RepoPath,
        [Parameter(Mandatory)][string]$WorktreePath,
        [Parameter(Mandatory)][ValidateSet('R0','R1','R2','R3')][string]$Risk,
        [Parameter(Mandatory)]$Config,
        [Parameter(Mandatory)][string]$GitPath,
        [switch]$SkipCommands
    )

    $reasons = [System.Collections.Generic.List[string]]::new()
    $commandResults = [System.Collections.Generic.List[object]]::new()
    $changed = @(Get-ChangedFiles $WorktreePath $GitPath)

    if ($Risk -eq 'R1' -and $changed.Count -gt [int]$Config.low_risk_max_files) {
        $reasons.Add("changed file count $($changed.Count) exceeds R1 limit $($Config.low_risk_max_files)")
    }

    $protected = @($changed | Where-Object { Test-PathPattern $_ @($Config.protected_paths) })
    if ($protected.Count -gt 0) {
        $reasons.Add("protected path changed: $($protected -join ', ')")
    }

    foreach ($args in @(@('diff','--check'), @('diff','--cached','--check'))) {
        $diffCheck = Invoke-Git $GitPath $WorktreePath $args -AllowFailure
        if ($diffCheck.exit_code -ne 0) {
            $reasons.Add("git $($args -join ' ') failed: $($diffCheck.output -join ' ')")
        }
    }

    if (-not $SkipCommands) {
        if ($Config.PSObject.Properties.Name -contains 'smoke_test') {
            $executable = [string]$Config.smoke_test.executable
            if (-not (Test-Path -LiteralPath $executable -PathType Leaf)) {
                $reasons.Add("smoke-test executable missing: $executable")
            }
            else {
                $arguments = @($Config.smoke_test.arguments | ForEach-Object { ([string]$_).Replace('{worktree}', $WorktreePath) })
                $result = Invoke-CapturedProcess $executable $arguments $WorktreePath
                $commandResults.Add($result)
                if ($result.exit_code -ne 0) {
                    $reasons.Add("smoke test failed ($($result.exit_code)): $($result.command)")
                }
            }
        }
        foreach ($template in @($Config.verification_commands)) {
            $command = ([string]$template).Replace('{worktree}', $WorktreePath.Replace("'", "''"))
            $result = Invoke-CapturedPowerShell $command $WorktreePath
            $commandResults.Add($result)
            if ($result.exit_code -ne 0) {
                $reasons.Add("verification failed ($($result.exit_code)): $command")
            }
        }
    }

    [pscustomobject]@{
        passed = ($reasons.Count -eq 0)
        risk = $Risk
        changed_files = @($changed)
        reasons = @($reasons)
        command_results = @($commandResults)
    }
}

function Complete-GameTask {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$RepoPath,
        [Parameter(Mandatory)][string]$WorktreePath,
        [Parameter(Mandatory)][ValidatePattern('^[a-z0-9][a-z0-9-]{0,62}$')][string]$TaskId,
        [Parameter(Mandatory)][string]$CommitMessage,
        [Parameter(Mandatory)]$Config,
        [Parameter(Mandatory)][string]$GitPath,
        [switch]$SkipCommands
    )

    $verification = Test-GameTaskWorktree -RepoPath $RepoPath -WorktreePath $WorktreePath -Risk R1 -Config $Config -GitPath $GitPath -SkipCommands:$SkipCommands
    if (-not $verification.passed) {
        throw "Task is not eligible for automatic completion: $($verification.reasons -join '; ')"
    }
    if ($verification.changed_files.Count -eq 0) { throw 'Task has no changes to complete.' }

    $mainStatus = Invoke-Git $GitPath $RepoPath @('status','--porcelain=v1')
    if ($mainStatus.output.Count -gt 0) { throw 'Main worktree changed during delegated task.' }

    Invoke-Git $GitPath $WorktreePath @('add','--all') | Out-Null
    Invoke-Git $GitPath $WorktreePath @('commit','-m',$CommitMessage) | Out-Null
    $branch = "worker/$TaskId"
    Invoke-Git $GitPath $RepoPath @('merge','--ff-only',$branch) | Out-Null
    Invoke-Git $GitPath $RepoPath @('worktree','remove',$WorktreePath) | Out-Null
    Invoke-Git $GitPath $RepoPath @('branch','-d',$branch) | Out-Null

    [pscustomobject]@{ merged = $true; task_id = $TaskId; changed_files = @($verification.changed_files) }
}

function Remove-GameTaskWorktree {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$RepoPath,
        [Parameter(Mandatory)][string]$WorktreePath,
        [Parameter(Mandatory)][ValidatePattern('^[a-z0-9][a-z0-9-]{0,62}$')][string]$TaskId,
        [Parameter(Mandatory)][string]$GitPath
    )

    $repo = (Resolve-Path -LiteralPath $RepoPath).Path
    $worktree = (Resolve-Path -LiteralPath $WorktreePath).Path
    $worktreeRoot = [IO.Path]::GetFullPath((Join-Path $repo '.worktrees'))
    if (-not $worktree.StartsWith($worktreeRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Refusing to remove worktree outside .worktrees: $worktree"
    }
    $status = Invoke-Git $GitPath $worktree @('status','--porcelain=v1')
    if ($status.output.Count -gt 0) { throw 'Refusing to remove a worktree with changes.' }
    $expectedBranch = "worker/$TaskId"
    $actualBranch = (Invoke-Git $GitPath $worktree @('branch','--show-current')).output | Select-Object -First 1
    if ($actualBranch -ne $expectedBranch) { throw "Unexpected worktree branch: $actualBranch" }

    Invoke-Git $GitPath $repo @('worktree','remove',$worktree) | Out-Null
    Invoke-Git $GitPath $repo @('branch','-d',$expectedBranch) | Out-Null
    [pscustomobject]@{ removed = $true; task_id = $TaskId; branch = $expectedBranch }
}

Export-ModuleMember -Function Resolve-OpenCodeExecutable,Get-GameTaskRisk,Get-MultiModelTaskRoute,Get-WorkflowPolicy,Test-AgentContractCompatibility,Test-ExternalArtifactPacket,Test-ImageArtifactManifest,New-GameTaskWorktree,Test-GameTaskWorktree,Complete-GameTask,Remove-GameTaskWorktree
