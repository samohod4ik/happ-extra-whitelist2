<#
.SYNOPSIS
  Local Windows fallback for Happ auto-CONNECT after logon (not the same as --autostart).
.DESCRIPTION
  Official Happ auto-connect is delivered by the subscription provider
  (HTTP headers or #subscription-autoconnect lines). This script does not
  write subscription URLs or invent Preferences registry values.

  What it CAN set locally:
  - A current-user Scheduled Task that soft-nudges happ://connect 30-60s
    after logon, after Happ.exe --autostart has had time to come up.
  - Inspection of existing HKCU Happ Preference value *names* that already
    look like autoconnect (report only; no invented keys).

  Prefer lastused (last selected server). Prefer Extra Whitelist2 DE then NL
  when those remarks exist in the user's subscription.

.NOTES
  EN: Never kills Happ; never calls happ://disconnect.
  RU: Никогда не убивает Happ и не вызывает happ://disconnect.
  Docs: https://www.happ.su/main/dev-docs/app-management
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
  [string] $TaskName = 'Happ Proxy Autoconnect Nudge',
  [ValidateRange(30, 60)]
  [int] $DelaySeconds = 45,
  [switch] $InspectOnly
)

$ErrorActionPreference = 'Stop'

function Write-OfficialAutoconnectGuidance {
  Write-Host @'
--- Happ autoconnect (official, subscription-side) ---
EN: Autostart launches Happ. Autoconnect brings the tunnel up.
    Provider delivery (do not commit URLs). Prefer lastused:
      HTTP headers:
        subscription-autoconnect: 1
        subscription-autoconnect-type: lastused
      or subscription body:
        #subscription-autoconnect: 1
        #subscription-autoconnect-type: lastused
    Types: lastused | lowestdelay | random
    Source: https://www.happ.su/main/dev-docs/app-management
    Local UI: if this Happ build shows Settings auto-connect /
    Автоподключение, enable it. No public registry value is documented.
    lastused = last selected server. Prefer Extra Whitelist2 DE then NL
    when those remarks exist.

RU: Автозапуск только открывает Happ. Автоподключение поднимает туннель.
    Официально задаёт провайдер подписки (URL в репозиторий не писать).
    Предпочтительно lastused. Локальный тумблер в Settings — если есть.
    Реестровых ключей автоподключения вендор не документирует.
    Extra Whitelist2 DE→NL — только если такие remark есть в подписке.
---
'@
}

function Show-ExistingAutoconnectPreferenceNames {
  $root = 'HKCU:\Software\Happ'
  if (-not (Test-Path $root)) {
    Write-Host "NOTE: $root not present (Happ may not have written Preferences yet)."
    return
  }

  $found = 0
  $keys = @($root) + @(Get-ChildItem -Path $root -Recurse -ErrorAction SilentlyContinue | ForEach-Object { $_.PSPath })
  foreach ($key in $keys) {
    $item = Get-Item -LiteralPath $key -ErrorAction SilentlyContinue
    if (-not $item) { continue }
    foreach ($name in $item.GetValueNames()) {
      if ($name -match '(?i)auto[-_]?connect|lastused|autoconnect') {
        $found++
        Write-Host "NOTE: existing Preference name (value redacted): $name @ $($item.Name)"
      }
    }
  }
  if ($found -eq 0) {
    Write-Host 'NOTE: no existing HKCU Happ Preference names matched autoconnect/lastused.'
    Write-Host 'NOTE: not creating invented registry values.'
  }
}

Write-OfficialAutoconnectGuidance
Show-ExistingAutoconnectPreferenceNames

if ($InspectOnly) {
  Write-Host 'OK: inspect-only (no Scheduled Task change).'
  return
}

$action = New-ScheduledTaskAction `
  -Execute (Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe') `
  -Argument '-NoProfile -WindowStyle Hidden -Command "Start-Process ''happ://connect''"'
$trigger = New-ScheduledTaskTrigger -AtLogOn
$trigger.Delay = 'PT{0}S' -f $DelaySeconds
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Limited
$settings = New-ScheduledTaskSettingsSet `
  -AllowStartIfOnBatteries `
  -DontStopIfGoingOnBatteries `
  -StartWhenAvailable `
  -MultipleInstances IgnoreNew

if ($PSCmdlet.ShouldProcess($TaskName, "Register delayed happ://connect (+${DelaySeconds}s after logon)")) {
  Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force | Out-Null
  Write-Host "OK: Scheduled Task '$TaskName' → happ://connect after ${DelaySeconds}s (soft; does not kill Happ)"
}
