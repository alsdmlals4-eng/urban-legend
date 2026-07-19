$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$required = @('[기획서]\00_프로젝트_허브\BASE_RULES_VERSION.md','[기획서]\00_프로젝트_허브\ASSET_REGISTRY.json','[기획서]\05_테크니컬아트_콘텐츠_파이프라인\05_테크니컬아트_콘텐츠_파이프라인_본책.md','assets\ASSET_MANIFEST.json')
foreach ($path in $required) { if (-not (Test-Path -LiteralPath (Join-Path $repo $path) -PathType Leaf)) { throw "Missing asset workflow contract file: $path" } }
$asset = Get-Content -Raw -LiteralPath (Join-Path $repo '[기획서]\00_프로젝트_허브\ASSET_REGISTRY.json') | ConvertFrom-Json
if ($asset.qa_capture_library.path -ne 'docs/qa/captures' -or $asset.qa_capture_library.dirty_png_count -ne 47) { throw 'QA evidence registry does not preserve the 47 dirty PNG contract.' }
'PASS: asset and evidence workflow contract'
