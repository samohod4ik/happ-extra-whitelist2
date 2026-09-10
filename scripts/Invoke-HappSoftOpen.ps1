<#
.SYNOPSIS
  Soft-nudge Happ via happ://open (no disconnect/kill).
#>
[CmdletBinding()]
param()
Start-Process 'happ://open'
Write-Host 'OK: started happ://open'
