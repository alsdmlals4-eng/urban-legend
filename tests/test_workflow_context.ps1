$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$hub = Join-Path $repo '[기획서]\00_프로젝트_허브'
$design = Get-Content -Raw -LiteralPath (Join-Path $hub 'DESIGN_DOCUMENT_REGISTRY.json') | ConvertFrom-Json
$skills = Get-Content -Raw -LiteralPath (Join-Path $hub 'SKILL_REGISTRY.json') | ConvertFrom-Json
if ($design.documents.Count -ne 12) { throw "Expected hub plus 11 responsibility documents; got $($design.documents.Count)." }
$disciplineSkills = @($skills.skills | Where-Object { $_.layer -eq 'discipline' -and $_.status -eq 'ACTIVE' })
$foundationSkills = @($skills.skills | Where-Object { $_.layer -eq 'foundation' -and $_.status -eq 'ACTIVE' })
if ($disciplineSkills.Count -ne 11 -or $foundationSkills.Count -ne 8 -or $skills.discipline_entrypoints.PSObject.Properties.Count -ne 11) { throw 'Expected 11 discipline skills, 8 selected foundation skills, and 11 entrypoints.' }
foreach ($entry in $skills.skills) { if (-not (Test-Path -LiteralPath (Join-Path $repo $entry.path) -PathType Leaf)) { throw "Missing registered skill: $($entry.path)" } }
if (-not (Test-Path -LiteralPath (Join-Path $hub 'MIGRATION_PRESERVATION_LEDGER.md') -PathType Leaf)) { throw 'Migration preservation ledger is missing.' }
'PASS: 11-discipline plus foundation workflow context contract'
