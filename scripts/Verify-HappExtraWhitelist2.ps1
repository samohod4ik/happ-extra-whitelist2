<#
.SYNOPSIS
  Smoke-verify Happ Extra Whitelist2 setup without printing secrets.
#>
[CmdletBinding()]
param(
  [int] $ExpectedMinutes = 60,
  [string] $TaskName = 'Happ Proxy Autostart'
)

$ErrorActionPreference = 'Continue'
$fail = 0
function Ok($m) { Write-Host "PASS $m" }
function Bad($m) { Write-Host "FAIL $m"; $script:fail++ }

$proc = Get-Process Happ -ErrorAction SilentlyContinue
if ($proc) { Ok "Happ process running (pid $($proc.Id -join ','))" } else { Bad 'Happ process not running' }

$reg = 'HKCU:\Software\Happ\OrganizationDefaults\Preferences\Subscriptions'
if (Test-Path $reg) {
  $p = Get-ItemProperty $reg
  $mins = $p.subsUpdateTimerInMinutes
  if (-not $mins) { $mins = $p.subsAutoUpdateInterval }
  if ("$mins" -eq "$ExpectedMinutes") { Ok "subs interval = $ExpectedMinutes" } else { Bad "subs interval='$mins' expected $ExpectedMinutes" }
  if ("$($p.subsAutoUpdate)".ToLower() -eq 'true') { Ok 'subsAutoUpdate=true' } else { Bad "subsAutoUpdate=$($p.subsAutoUpdate)" }
} else { Bad "registry missing: $reg" }

$task = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
if ($task) { Ok "autostart task '$TaskName' present" } else { Bad "autostart task '$TaskName' missing" }

$rj = Join-Path $env:LOCALAPPDATA 'Happ\routing.json'
if (Test-Path $rj) {
  $j = Get-Content $rj -Raw -Encoding UTF8 | ConvertFrom-Json
  if ($j.useRouting -eq $true) { Ok "useRouting=true active=$($j.activeRoutingName)" } else { Bad "useRouting=$($j.useRouting)" }
  $names = @($j.routings | ForEach-Object { $_.name })
  Ok ("routing profiles: " + ($(if ($names.Count) { $names -join ', ' } else { '(none)' })))
} else { Bad 'routing.json missing' }

Write-Host 'NOTE: Extra Whitelist2 DE/NL selection is UI-side; this script does not read encrypted subs.db.'
if ($fail -gt 0) { Write-Host "RESULT: $fail failure(s)"; exit 1 } else { Write-Host 'RESULT: OK'; exit 0 }
