$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$hub = Join-Path $repo '[기획서]\00_프로젝트_허브'
$design = Get-Content -Raw -LiteralPath (Join-Path $hub 'DESIGN_DOCUMENT_REGISTRY.json') | ConvertFrom-Json
$skills = Get-Content -Raw -LiteralPath (Join-Path $hub 'SKILL_REGISTRY.json') | ConvertFrom-Json
if ($design.documents.Count -ne 12) { throw "Expected hub plus 11 responsibility documents; got $($design.documents.Count)." }
if ($skills.skills.Count -ne 11 -or $skills.discipline_entrypoints.PSObject.Properties.Count -ne 11) { throw 'Expected 11 one-to-one discipline skills and entrypoints.' }
foreach ($entry in $skills.skills) { if (-not (Test-Path -LiteralPath (Join-Path $repo $entry.path) -PathType Leaf)) { throw "Missing registered skill: $($entry.path)" } }
if (-not (Test-Path -LiteralPath (Join-Path $hub 'MIGRATION_PRESERVATION_LEDGER.md') -PathType Leaf)) { throw 'Migration preservation ledger is missing.' }
'PASS: 11-discipline workflow context contract'
