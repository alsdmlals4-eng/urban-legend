[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$RunRoot,
    [Parameter(Mandatory)][int]$Attempt,
    [Parameter(Mandatory)][string]$OpenCodePath,
    [Parameter(Mandatory)][string]$WorktreePath,
    [Parameter(Mandatory)][string]$Agent,
    [Parameter(Mandatory)][string]$PromptPath,
    [string]$SessionId
)

$ErrorActionPreference = 'Stop'
$eventsPath = Join-Path $RunRoot ("events-{0}.jsonl" -f $Attempt)
$stderrPath = Join-Path $RunRoot ("stderr-{0}.txt" -f $Attempt)
$completionPath = Join-Path $RunRoot ("completion-{0}.json" -f $Attempt)
$startedAt = [DateTime]::UtcNow

try {
    $prompt = [IO.File]::ReadAllText($PromptPath, [Text.Encoding]::UTF8)
    $arguments = @('run','--format','json','--variant','medium','--model','deepseek/deepseek-v4-flash','--agent',$Agent)
    if ($SessionId) { $arguments += @('--session',$SessionId) }
    $arguments += $prompt

    $previous = $ErrorActionPreference
    $previousOutputEncoding = $OutputEncoding
    $previousConsoleEncoding = [Console]::OutputEncoding
    try {
        $ErrorActionPreference = 'Continue'
        $OutputEncoding = [Text.UTF8Encoding]::new($false)
        [Console]::OutputEncoding = [Text.UTF8Encoding]::new($false)
        Push-Location $WorktreePath
        $output = & $OpenCodePath @arguments 2>&1
        $exitCode = $LASTEXITCODE
    }
    finally {
        Pop-Location
        $ErrorActionPreference = $previous
        $OutputEncoding = $previousOutputEncoding
        [Console]::OutputEncoding = $previousConsoleEncoding
    }

    $eventLines = @($output | ForEach-Object { [string]$_ })
    [IO.File]::WriteAllLines($eventsPath, $eventLines, [Text.UTF8Encoding]::new($false))
    if (-not (Test-Path -LiteralPath $stderrPath)) {
        [IO.File]::WriteAllText($stderrPath, '', [Text.UTF8Encoding]::new($false))
    }
}
catch {
    $exitCode = 9001
    [IO.File]::WriteAllText($stderrPath, ($_ | Out-String), [Text.UTF8Encoding]::new($false))
}
finally {
    $completion = [ordered]@{
        attempt = $Attempt
        exit_code = [int]$exitCode
        started_utc = $startedAt.ToString('o')
        completed_utc = [DateTime]::UtcNow.ToString('o')
        duration_ms = [int64]([DateTime]::UtcNow - $startedAt).TotalMilliseconds
        events_path = $eventsPath
        stderr_path = $stderrPath
    }
    [IO.File]::WriteAllText($completionPath, ($completion | ConvertTo-Json -Depth 4), [Text.UTF8Encoding]::new($false))
}
