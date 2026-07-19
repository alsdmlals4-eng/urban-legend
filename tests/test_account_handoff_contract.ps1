$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$required = @('AGENTS.md','README.md','[기획서]\00_프로젝트_허브\START_HERE.md','[기획서]\00_프로젝트_허브\ACTIVE_CONTEXT.md','[기획서]\00_프로젝트_허브\DOCUMENTATION_MAP.md','[기획서]\00_프로젝트_허브\DEVELOPMENT_GATES.md')
foreach ($path in $required) { if (-not (Test-Path -LiteralPath (Join-Path $repo $path) -PathType Leaf)) { throw "Missing handoff router: $path" } }
$context = [IO.File]::ReadAllText((Join-Path $repo '[기획서]\00_프로젝트_허브\ACTIVE_CONTEXT.md'), [Text.Encoding]::UTF8)
foreach ($needle in @('현재 단계','다음 작업','읽지 않을 범위')) { if (-not $context.Contains($needle)) { throw "Active Context is missing: $needle" } }
'PASS: project handoff router contract'
