$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$failures = [System.Collections.Generic.List[string]]::new()
function Require([bool]$Condition, [string]$Message) {
    if (-not $Condition) { $script:failures.Add($Message) }
}
$agents = Get-Content -LiteralPath (Join-Path $repo 'AGENTS.md') -Raw -Encoding utf8
foreach ($owner in @('CURRENT_DECISION_OVERLAY.md', 'CURRENT_HANDOFF.md', 'PROJECT_BASE_ADAPTER.json', 'WORK_MODE_AND_SKILL_ROUTING.md')) {
    Require ($agents.Contains($owner)) "Missing current authority route: $owner"
}
$map = Get-Content -LiteralPath (Join-Path $repo 'docs/DOCUMENTATION_MAP.md') -Raw -Encoding utf8
foreach ($branch in @('CURRENT_DECISION_OVERLAY.md', 'CURRENT_HANDOFF.md', 'VALIDATION_TARGET_CANON.md', 'IMAGE_ASSET_WORKFLOW.md', 'TEST_CHECKLIST.md', 'SKILL_REGISTRY.json')) {
    Require ($map.Contains($branch)) "Documentation map is missing branch: $branch"
}
Require ($map.Contains('Conditional routing')) 'Documentation map must state conditional loading'
$contextPath = Join-Path $repo 'docs/PROJECT_CONTEXT.md'
Require (Test-Path -LiteralPath $contextPath -PathType Leaf) 'Project context must exist'
if (Test-Path -LiteralPath $contextPath) {
    $context = Get-Content -LiteralPath $contextPath -Raw -Encoding utf8
    Require ($agents.Contains('scripts/core/game_state.gd')) 'Protected save owner must be explicitly routed'
}
# Length is diagnostic, not a safety gate: compression must preserve obligations.
Write-Output ("Startup AGENTS words (diagnostic only): " + @($agents -split '\s+' | Where-Object { $_ }).Count)
if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Output "FAIL: $_" }
    exit 1
}
Write-Output 'Workflow context contract passed.'
