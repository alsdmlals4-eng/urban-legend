param(
	[Nullable[double]]$RemainingPercent
)

$ErrorActionPreference = 'Stop'

if ($null -eq $RemainingPercent) {
	'UNKNOWN'
	exit 0
}

if ($RemainingPercent -lt 0 -or $RemainingPercent -gt 100) {
	throw 'RemainingPercent must be between 0 and 100.'
}

if ($RemainingPercent -le 2) {
	'HARD_STOP'
}
elseif ($RemainingPercent -le 5) {
	'PREPARE'
}
else {
	'CONTINUE'
}
