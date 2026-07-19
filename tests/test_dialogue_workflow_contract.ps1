$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$narrative = Join-Path $repo '[기획서]\01_설정_내러티브\01_설정_내러티브_본책.md'
$appendix = Join-Path $repo '[기획서]\01_설정_내러티브\등록_부록\NARRATIVE_CONTENT_PLAN.md'
$map = Join-Path $repo '[기획서]\00_프로젝트_허브\DOCUMENTATION_MAP.md'
foreach ($path in @($narrative, $appendix, $map)) { if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "Missing narrative routing file: $path" } }
$text = [IO.File]::ReadAllText($narrative, [Text.Encoding]::UTF8)
foreach ($needle in @('책임 범위', '현재 상태', '다음 작업', '검증 경로')) { if (-not $text.Contains($needle)) { throw "Narrative bible is missing: $needle" } }
if (-not ([IO.File]::ReadAllText($map, [Text.Encoding]::UTF8).Contains('01_설정_내러티브'))) { throw 'Documentation map does not route narrative work.' }
'PASS: narrative routing contract'
