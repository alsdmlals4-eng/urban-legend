$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$failures = [System.Collections.Generic.List[string]]::new()

function Words([string]$RelativePath) {
	$text = Get-Content -LiteralPath (Join-Path $repo $RelativePath) -Raw -Encoding utf8
	return @($text -split '\s+' | Where-Object { $_ }).Count
}

function Require([bool]$Condition, [string]$Message) {
	if (-not $Condition) { $script:failures.Add($Message) }
}

$contextPath = Join-Path $repo 'docs\PROJECT_CONTEXT.md'
Require (Test-Path -LiteralPath $contextPath -PathType Leaf) 'docs/PROJECT_CONTEXT.md must exist'
Require ((Words 'AGENTS.md') -le 450) 'AGENTS.md must be 450 words or fewer'

$map = Get-Content -LiteralPath (Join-Path $repo 'docs\DOCUMENTATION_MAP.md') -Raw -Encoding utf8
foreach ($branch in @('DIALOGUE_AUTHORING_WORKFLOW', 'IMAGE_ASSET_WORKFLOW', 'BENCHMARKING_REFERENCE_GUIDE', 'AI_DELEGATION_WORKFLOW', 'GODOT_NATIVE_UI_ARCHITECTURE', 'MVP037_CAMPAIGN_CORE')) {
	Require ($map.Contains($branch)) "Documentation map is missing branch: $branch"
}
Require ($map.Contains('AI_DELEGATION_WORKFLOW.md')) 'Documentation map must state conditional loading'

if (Test-Path -LiteralPath $contextPath) {
	$context = Get-Content -LiteralPath $contextPath -Raw -Encoding utf8
	Require ($context.Contains('HIGH_RISK_DOMAIN')) 'Project context must distinguish semantic risk from protected paths'
	$activeWords = (Words 'AGENTS.md') + (Words 'docs/BASE_RULES_VERSION.md') + (Words 'docs/DOCUMENTATION_MAP.md') + (Words 'docs/PROJECT_CONTEXT.md')
	Require ($activeWords -le 4056) "Active startup context is $activeWords words; target is 4056"
}

if ($failures.Count -gt 0) {
	$failures | ForEach-Object { Write-Output "FAIL: $_" }
	exit 1
}

Write-Output 'Workflow context contract passed.'
