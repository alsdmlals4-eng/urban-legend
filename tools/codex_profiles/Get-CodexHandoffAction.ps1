param(
	[Nullable[double]]$RemainingPercent
)

$ErrorActionPreference = 'Stop'

if ($null -eq $RemainingPercent) {
	'UNKNOWN'
	exit 0
}

$numericPercent = [double]$RemainingPercent
if ([double]::IsNaN($numericPercent) -or [double]::IsInfinity($numericPercent) -or $numericPercent -lt 0 -or $numericPercent -gt 100) {
	throw 'RemainingPercent must be between 0 and 100.'
}

if ($numericPercent -le 2) {
	'HARD_STOP'
}
elseif ($numericPercent -le 5) {
	'PREPARE'
}
else {
	'CONTINUE'
}
