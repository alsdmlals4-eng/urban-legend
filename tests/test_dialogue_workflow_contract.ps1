$ErrorActionPreference = 'Stop'

$repo = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$workflowPath = Join-Path $repo 'docs\DIALOGUE_AUTHORING_WORKFLOW.md'

function Assert-Contains {
	param([string]$Text, [string]$Expected, [string]$Message)
	if (-not $Text.Contains($Expected)) { throw $Message }
}

if (-not (Test-Path -LiteralPath $workflowPath -PathType Leaf)) {
	throw 'Dialogue authoring workflow document is missing.'
}

$workflow = [IO.File]::ReadAllText($workflowPath, [Text.Encoding]::UTF8)
Assert-Contains -Text $workflow -Expected 'dialogue_rewrite.patch' -Message 'The external GPT patch artifact is not defined.'
Assert-Contains -Text $workflow -Expected 'dialogue_review.md' -Message 'The external GPT review artifact is not defined.'
Assert-Contains -Text $workflow -Expected 'unified diff' -Message 'The patch format is not defined.'
Assert-Contains -Text $workflow -Expected 'DeepSeek' -Message 'The DeepSeek audit role is not defined.'
Assert-Contains -Text $workflow -Expected 'Codex' -Message 'The Codex integration role is not defined.'
Assert-Contains -Text $workflow -Expected 'no-new-systems' -Message 'The no-new-systems boundary is not defined.'

foreach ($relativePath in @('AGENTS.md', 'docs\DOCUMENTATION_MAP.md', 'docs\AI_WORKFLOW_RULES.md', 'docs\MVP_WORKFLOW_CHECKLIST.md')) {
	$text = [IO.File]::ReadAllText((Join-Path $repo $relativePath), [Text.Encoding]::UTF8)
	Assert-Contains -Text $text -Expected 'DIALOGUE_AUTHORING_WORKFLOW.md' -Message "$relativePath does not route dialogue work to the workflow document."
}

'PASS: dialogue authoring workflow contract'
