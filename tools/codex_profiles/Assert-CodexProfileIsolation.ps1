param(
	[Parameter(Mandatory = $true)]
	[string]$ProfilePath
)

$ErrorActionPreference = 'Stop'

foreach ($relativePath in @('skills\.system', 'plugins')) {
	$path = Join-Path $ProfilePath $relativePath
	if (-not (Test-Path -LiteralPath $path)) {
		continue
	}
	$item = Get-Item -LiteralPath $path -Force
	if ($null -ne $item.LinkType) {
		throw "Account-local state must not be linked or shared: $path"
	}
}

$authPath = Join-Path $ProfilePath 'auth.json'
if (Test-Path -LiteralPath $authPath) {
	$auth = Get-Item -LiteralPath $authPath -Force
	if ($auth.PSIsContainer -or $null -ne $auth.LinkType) {
		throw "Account authentication must be a profile-local regular file: $authPath"
	}
}

[PSCustomObject]@{
	ProfilePath = $ProfilePath
	IsolationValid = $true
	SystemSkillsShared = $false
	AuthShared = $false
	PluginStateShared = $false
}
