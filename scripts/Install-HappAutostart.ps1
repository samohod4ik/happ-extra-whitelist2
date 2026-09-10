<#
.SYNOPSIS
  Ensure a current-user Scheduled Task starts Happ with --autostart at logon.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
  [string] $TaskName = 'Happ Proxy Autostart',
  [string] $HappExe = ''
)

$ErrorActionPreference = 'Stop'

if (-not $HappExe) {
  $candidates = @(
    (Join-Path ${env:ProgramFiles} 'FlyFrogLLC\Happ\Happ.exe'),
    (Join-Path ${env:ProgramFiles(x86)} 'FlyFrogLLC\Happ\Happ.exe')
  )
  $HappExe = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
}

if (-not $HappExe -or -not (Test-Path $HappExe)) {
  throw "Happ.exe not found. Pass -HappExe explicitly."
}

$action = New-ScheduledTaskAction -Execute $HappExe -Argument '--autostart'
$trigger = New-ScheduledTaskTrigger -AtLogOn
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Limited
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

if ($PSCmdlet.ShouldProcess($TaskName, "Register task → $HappExe --autostart")) {
  Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force | Out-Null
  Write-Host "OK: Scheduled Task '$TaskName' → $HappExe --autostart"
}
