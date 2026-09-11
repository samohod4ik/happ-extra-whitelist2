<#
.SYNOPSIS
  Soft-nudge Happ via happ://connect (no disconnect/kill).
.DESCRIPTION
  Use when Happ is already running (or starting) but the TUN / System Proxy
  tunnel is down. Does not stop Happ.exe. Never call happ://disconnect while
  a remote session depends on the tunnel.

  EN: Connect only. RU: Только подключить, не разрывать и не убивать процесс.
#>
[CmdletBinding()]
param()
Start-Process 'happ://connect'
Write-Host 'OK: started happ://connect'
