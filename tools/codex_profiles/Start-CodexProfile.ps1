param(
	[Parameter(Mandatory = $true)]
	[ValidateSet('account-a', 'account-b')]
	[string]$ProfileName,
	[string]$ProfileRoot = (Join-Path $HOME '.codex-profiles'),
	[string]$ProjectPath = 'C:\Users\user\Documents\GitHub\urban-legend',
	[ValidateSet('App', 'Cli')]
	[string]$Surface = 'App',
	[switch]$ValidateOnly
)

$ErrorActionPreference = 'Stop'
$profilePath = Join-Path $ProfileRoot $ProfileName

if (-not (Test-Path -LiteralPath $profilePath -PathType Container)) {
	throw "Codex profile is not installed: $profilePath"
}
if (-not (Test-Path -LiteralPath (Join-Path $profilePath 'config.toml') -PathType Leaf)) {
	throw "Codex profile config is missing: $profilePath"
}
if (-not (Test-Path -LiteralPath $ProjectPath -PathType Container)) {
	throw "Project path does not exist: $ProjectPath"
}

if ($ValidateOnly) {
	"PROFILE_READY profile=$ProfileName home=$profilePath project=$ProjectPath"
	exit 0
}

$running = Get-Process -ErrorAction SilentlyContinue | Where-Object {
	$_.ProcessName -in @('ChatGPT', 'codex', 'codex-code-mode-host')
}
if ($running) {
	throw 'Close every running ChatGPT/Codex process before switching CODEX_HOME profiles.'
}

$env:CODEX_HOME = $profilePath

if ($Surface -eq 'Cli') {
	$codex = Get-Command codex -ErrorAction Stop
	Start-Process -FilePath $codex.Source -WorkingDirectory $ProjectPath
	exit 0
}

$package = Get-AppxPackage -Name 'OpenAI.Codex' -ErrorAction SilentlyContinue | Select-Object -First 1
if ($null -eq $package) {
	throw 'OpenAI Codex desktop app package was not found.'
}

$appPath = Join-Path $package.InstallLocation 'app\ChatGPT.exe'
if (-not (Test-Path -LiteralPath $appPath -PathType Leaf)) {
	throw "Codex desktop executable was not found: $appPath"
}

Start-Process -FilePath $appPath -WorkingDirectory $ProjectPath
