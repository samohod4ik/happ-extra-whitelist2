<#
.SYNOPSIS
  Soft-nudge Happ via happ://connect (no disconnect/kill).
.DESCRIPTION
  Local protocol nudge (not the official subscription-autoconnect header).
  Use when Happ is already running (or starting) but the TUN / System Proxy
  tunnel is down. Calling this when the tunnel is already healthy / already
  up is optional and usually should be skipped (can blip remote sessions).

  Does not stop Happ.exe. Never call happ://disconnect while a remote
  session depends on the tunnel.

  EN: Connect only, and only if the tunnel looks down.
  RU: Только подключить, если туннель не поднят; не разрывать и не убивать процесс.
#>
[CmdletBinding()]
param()

$happUp = [bool](Get-Process Happ -ErrorAction SilentlyContinue)
$inet = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings'
$enabled = $false
$server = ''
if (Test-Path $inet) {
  $item = Get-ItemProperty -LiteralPath $inet
  if ($null -ne $item.ProxyEnable) { $enabled = [int]$item.ProxyEnable -eq 1 }
  $server = [string]$item.ProxyServer
}
$looksLocal = $server -match '(?i)(127\.0\.0\.1|localhost):\d+'
if ($happUp -and $enabled -and $looksLocal) {
  Write-Host 'NOTE: tunnel already looks healthy (Happ running; ProxyEnable=1; Happ-like local proxy).'
  Write-Host 'NOTE: happ://connect is optional when already up; skipping to avoid a live-session blip.'
  Write-Host 'OK: skipped happ://connect (already healthy; never disconnect/kill)'
  return
}

Start-Process 'happ://connect'
Write-Host 'OK: started happ://connect'
