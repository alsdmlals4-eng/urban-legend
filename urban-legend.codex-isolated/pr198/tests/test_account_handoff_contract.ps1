$ErrorActionPreference = 'Stop'

$repo = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

function Assert-True {
	param([bool]$Condition, [string]$Message)
	if (-not $Condition) { throw $Message }
}

function Assert-Contains {
	param([string]$Text, [string]$Expected, [string]$Message)
	if (-not $Text.Contains($Expected)) { throw $Message }
}

$requiredFiles = @(
	'AGENTS.md',
	'docs\CURRENT_HANDOFF.md',
	'docs\CODEX_ACCOUNT_HANDOFF.md',
	'docs\DOCUMENTATION_MAP.md',
	'tools\codex_profiles\Get-CodexHandoffAction.ps1',
	'tools\codex_profiles\Assert-CodexProfileIsolation.ps1',
	'tools\codex_profiles\Install-CodexProfiles.ps1',
	'tools\codex_profiles\Start-CodexProfile.ps1'
)

foreach ($relativePath in $requiredFiles) {
	Assert-True -Condition (Test-Path -LiteralPath (Join-Path $repo $relativePath) -PathType Leaf) -Message "Missing account handoff file: $relativePath"
}

$agents = [IO.File]::ReadAllText((Join-Path $repo 'AGENTS.md'), [Text.Encoding]::UTF8)
Assert-Contains -Text $agents -Expected '5%' -Message 'AGENTS.md does not define the low-usage preparation threshold.'
Assert-Contains -Text $agents -Expected '2%' -Message 'AGENTS.md does not define the hard-stop threshold.'
Assert-Contains -Text $agents -Expected 'codex/handoff-' -Message 'AGENTS.md does not protect main from incomplete handoff commits.'
Assert-Contains -Text $agents -Expected 'CURRENT_HANDOFF.md' -Message 'AGENTS.md does not require the durable handoff record.'

$handoff = [IO.File]::ReadAllText((Join-Path $repo 'docs\CURRENT_HANDOFF.md'), [Text.Encoding]::UTF8)
foreach ($field in @('status:', 'branch:', 'completed_work_commit:', 'tests:', 'next_action:', 'main_integrated:', 'origin_pushed:')) {
	Assert-Contains -Text $handoff -Expected $field -Message "CURRENT_HANDOFF.md is missing field: $field"
}

$guide = [IO.File]::ReadAllText((Join-Path $repo 'docs\CODEX_ACCOUNT_HANDOFF.md'), [Text.Encoding]::UTF8)
foreach ($rule in @('CODEX_HOME', '/status', '/usage', 'PREPARE', 'HARD_STOP', 'dirty worktree', 'GPT', 'DeepSeek')) {
	Assert-Contains -Text $guide -Expected $rule -Message "Account handoff guide is missing rule: $rule"
}

$actionScript = Join-Path $repo 'tools\codex_profiles\Get-CodexHandoffAction.ps1'
Assert-True -Condition ((& $actionScript -RemainingPercent 6) -eq 'CONTINUE') -Message '6% must continue.'
Assert-True -Condition ((& $actionScript -RemainingPercent 5) -eq 'PREPARE') -Message '5% must prepare a handoff.'
Assert-True -Condition ((& $actionScript -RemainingPercent 2) -eq 'HARD_STOP') -Message '2% must hard-stop implementation.'
Assert-True -Condition ((& $actionScript) -eq 'UNKNOWN') -Message 'Unavailable usage must remain unknown.'
$nanRejected = $false
try {
	& $actionScript -RemainingPercent ([double]::NaN) | Out-Null
}
catch {
	$nanRejected = $true
}
Assert-True -Condition $nanRejected -Message 'NaN usage must be rejected instead of continuing.'

$tempRoot = Join-Path ([IO.Path]::GetTempPath()) ("codex-profile-contract-" + [Guid]::NewGuid().ToString('N'))
$profileRoot = Join-Path $tempRoot 'profiles'
$skillsRoot = Join-Path $tempRoot 'skills'

try {
	New-Item -ItemType Directory -Path (Join-Path $skillsRoot 'urban-legend-game-workflow') -Force | Out-Null
	New-Item -ItemType Directory -Path (Join-Path $skillsRoot 'deepseek-game-workflow') -Force | Out-Null
	New-Item -ItemType Directory -Path (Join-Path $skillsRoot '.system') -Force | Out-Null
	[IO.File]::WriteAllText((Join-Path $skillsRoot 'urban-legend-game-workflow\SKILL.md'), 'test skill', [Text.UTF8Encoding]::new($false))
	[IO.File]::WriteAllText((Join-Path $skillsRoot 'deepseek-game-workflow\SKILL.md'), 'test skill', [Text.UTF8Encoding]::new($false))

	& (Join-Path $repo 'tools\codex_profiles\Install-CodexProfiles.ps1') -ProfileRoot $profileRoot -SharedSkillsRoot $skillsRoot -RepositoryRoot $repo | Out-Null

	foreach ($profileName in @('account-a', 'account-b')) {
		$profilePath = Join-Path $profileRoot $profileName
		Assert-True -Condition (Test-Path -LiteralPath (Join-Path $profilePath 'config.toml') -PathType Leaf) -Message "$profileName config is missing."
		Assert-True -Condition (-not (Test-Path -LiteralPath (Join-Path $profilePath 'auth.json'))) -Message "$profileName installer must not create or share auth.json."
		Assert-True -Condition (-not (Test-Path -LiteralPath (Join-Path $profilePath 'plugins'))) -Message "$profileName installer must not share plugin state."
		Assert-True -Condition (Test-Path -LiteralPath (Join-Path $profilePath 'skills\urban-legend-game-workflow')) -Message "$profileName does not expose shared personal skills."
		Assert-True -Condition (-not (Test-Path -LiteralPath (Join-Path $profilePath 'skills\.system'))) -Message "$profileName must not share .system skills."
	}

	Assert-True -Condition (Test-Path -LiteralPath (Join-Path $profileRoot 'Start-Codex-A.ps1') -PathType Leaf) -Message 'Account A launcher is missing.'
	Assert-True -Condition (Test-Path -LiteralPath (Join-Path $profileRoot 'Start-Codex-B.ps1') -PathType Leaf) -Message 'Account B launcher is missing.'

	$startScript = Join-Path $repo 'tools\codex_profiles\Start-CodexProfile.ps1'
	$validation = & $startScript -ProfileName account-a -ProfileRoot $profileRoot -ProjectPath $repo -ValidateOnly
	Assert-Contains -Text ($validation | Out-String) -Expected 'PROFILE_READY' -Message 'Profile validation did not succeed.'

	$profileA = Join-Path $profileRoot 'account-a'
	$systemTarget = Join-Path $tempRoot 'system-target'
	New-Item -ItemType Directory -Path $systemTarget -Force | Out-Null
	New-Item -ItemType Junction -Path (Join-Path $profileA 'skills\.system') -Target $systemTarget | Out-Null
	$contaminationRejected = $false
	try {
		& (Join-Path $repo 'tools\codex_profiles\Install-CodexProfiles.ps1') -ProfileRoot $profileRoot -SharedSkillsRoot $skillsRoot -RepositoryRoot $repo | Out-Null
	}
	catch {
		$contaminationRejected = $true
	}
	Assert-True -Condition $contaminationRejected -Message 'Installer must reject a shared .system junction.'
	Remove-Item -LiteralPath (Join-Path $profileA 'skills\.system') -Force

	$pluginTarget = Join-Path $tempRoot 'plugin-target'
	New-Item -ItemType Directory -Path $pluginTarget -Force | Out-Null
	New-Item -ItemType Junction -Path (Join-Path $profileA 'plugins') -Target $pluginTarget | Out-Null
	$pluginRejected = $false
	try {
		& $startScript -ProfileName account-a -ProfileRoot $profileRoot -ProjectPath $repo -ValidateOnly | Out-Null
	}
	catch {
		$pluginRejected = $true
	}
	Assert-True -Condition $pluginRejected -Message 'Profile validation must reject shared plugin state.'
	Remove-Item -LiteralPath (Join-Path $profileA 'plugins') -Force

	$authSource = Join-Path $tempRoot 'shared-auth.json'
	[IO.File]::WriteAllText($authSource, '{}', [Text.UTF8Encoding]::new($false))
	New-Item -ItemType HardLink -Path (Join-Path $profileA 'auth.json') -Target $authSource | Out-Null
	$authRejected = $false
	try {
		& $startScript -ProfileName account-a -ProfileRoot $profileRoot -ProjectPath $repo -ValidateOnly | Out-Null
	}
	catch {
		$authRejected = $true
	}
	Assert-True -Condition $authRejected -Message 'Profile validation must reject linked auth.json.'
	Remove-Item -LiteralPath (Join-Path $profileA 'auth.json') -Force

	$previousHome = $env:CODEX_HOME
	$global:observedChildHome = $null
	function global:Get-Process { @() }
	function global:Get-Command { [PSCustomObject]@{ Source = 'codex-test.exe' } }
	function global:Start-Process {
		param([string]$FilePath, [string]$WorkingDirectory)
		$global:observedChildHome = $env:CODEX_HOME
	}
	try {
		$env:CODEX_HOME = 'parent-sentinel'
		& $startScript -ProfileName account-a -ProfileRoot $profileRoot -ProjectPath $repo -Surface Cli
		Assert-True -Condition ($global:observedChildHome -eq $profileA) -Message 'Child process did not receive the selected CODEX_HOME.'
		Assert-True -Condition ($env:CODEX_HOME -eq 'parent-sentinel') -Message 'Launcher did not restore the parent CODEX_HOME.'
	}
	finally {
		Remove-Item Function:\Get-Process -ErrorAction SilentlyContinue
		Remove-Item Function:\Get-Command -ErrorAction SilentlyContinue
		Remove-Item Function:\Start-Process -ErrorAction SilentlyContinue
		Remove-Variable observedChildHome -Scope Global -ErrorAction SilentlyContinue
		if ($null -eq $previousHome) { Remove-Item Env:\CODEX_HOME -ErrorAction SilentlyContinue } else { $env:CODEX_HOME = $previousHome }
	}
}
finally {
	if (Test-Path -LiteralPath $tempRoot) {
		Remove-Item -LiteralPath $tempRoot -Recurse -Force
	}
}

'PASS: dual-account and low-usage handoff contract'
