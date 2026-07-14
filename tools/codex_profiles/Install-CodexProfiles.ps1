param(
	[string]$ProfileRoot = (Join-Path $HOME '.codex-profiles'),
	[string]$SharedSkillsRoot = (Join-Path $HOME '.codex\skills'),
	[string]$RepositoryRoot = 'C:\Users\user\Documents\GitHub\urban-legend'
)

$ErrorActionPreference = 'Stop'
$utf8 = [Text.UTF8Encoding]::new($false)
$launcherScript = Join-Path $RepositoryRoot 'tools\codex_profiles\Start-CodexProfile.ps1'

if (-not (Test-Path -LiteralPath $SharedSkillsRoot -PathType Container)) {
	throw "Shared skills root does not exist: $SharedSkillsRoot"
}
if (-not (Test-Path -LiteralPath $launcherScript -PathType Leaf)) {
	throw "Profile launcher does not exist: $launcherScript"
}

New-Item -ItemType Directory -Path $ProfileRoot -Force | Out-Null

$personalSkills = Get-ChildItem -LiteralPath $SharedSkillsRoot -Directory | Where-Object {
	$_.Name -ne '.system' -and ($_.Name -eq '_shared' -or (Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') -PathType Leaf))
}

foreach ($profileName in @('account-a', 'account-b')) {
	$profilePath = Join-Path $ProfileRoot $profileName
	$profileSkills = Join-Path $profilePath 'skills'
	New-Item -ItemType Directory -Path $profileSkills -Force | Out-Null

	$configPath = Join-Path $profilePath 'config.toml'
	if (-not (Test-Path -LiteralPath $configPath)) {
		[IO.File]::WriteAllText($configPath, "cli_auth_credentials_store = `"file`"`r`n", $utf8)
	}

	foreach ($skill in $personalSkills) {
		$linkPath = Join-Path $profileSkills $skill.Name
		if (Test-Path -LiteralPath $linkPath) {
			$item = Get-Item -LiteralPath $linkPath -Force
			$target = @($item.Target)[0]
			if ($item.LinkType -ne 'Junction' -or ([IO.Path]::GetFullPath($target) -ne [IO.Path]::GetFullPath($skill.FullName))) {
				throw "Profile skill path already exists with a different target: $linkPath"
			}
			continue
		}
		New-Item -ItemType Junction -Path $linkPath -Target $skill.FullName | Out-Null
	}
}

$escapedLauncher = $launcherScript.Replace("'", "''")
$wrapperA = "& '$escapedLauncher' -ProfileName account-a @args`r`n"
$wrapperB = "& '$escapedLauncher' -ProfileName account-b @args`r`n"
[IO.File]::WriteAllText((Join-Path $ProfileRoot 'Start-Codex-A.ps1'), $wrapperA, $utf8)
[IO.File]::WriteAllText((Join-Path $ProfileRoot 'Start-Codex-B.ps1'), $wrapperB, $utf8)

[PSCustomObject]@{
	ProfileRoot = $ProfileRoot
	Profiles = @('account-a', 'account-b')
	SharedPersonalSkills = $personalSkills.Count
	AuthCreated = $false
	PluginStateShared = $false
}
