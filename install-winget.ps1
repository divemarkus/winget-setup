<#
.SYNOPSIS
 Installs winget if missing, then bulk-installs apps from apps.txt.

.DESCRIPTION
 - Checks for winget; if not present, downloads & installs the latest msixbundle.
 - Reads apps.txt, skips blank lines/comments, installs each package via winget.
#>

[CmdletBinding()]
param(
  [string]$AppsFile = "$PSScriptRoot\apps.txt"
)

function Install-WinGet {
  Write-Host "Checking for winget..." -NoNewline
  if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Host "found."
    return
  }
  Write-Host "not found. Installing…"

  # Fetch latest release info
  $apiUrl = 'https://api.github.com/repos/microsoft/winget-cli/releases/latest'
  $release = Invoke-RestMethod -Uri $apiUrl
  $asset   = $release.assets |
             Where-Object { $_.browser_download_url -match '\.msixbundle$' } |
             Select-Object -First 1

  $msixPath = Join-Path $env:TEMP 'winget.msixbundle'
  Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $msixPath -UseBasicParsing

  # Silent install
  Add-AppxPackage -Path $msixPath -ForceApplicationShutdown
  Remove-Item $msixPath -Force

  Write-Host "winget installed."
}

function Install-Apps {
  if (-Not (Test-Path $AppsFile)) {
    Write-Error "Apps file not found: $AppsFile"
    return
  }

  $apps = Get-Content $AppsFile |
          Where-Object { $_.Trim() -and -Not $_.StartsWith('#') }

  foreach ($id in $apps) {
    Write-Host "Installing $id…"
    winget install --id $id --exact `
      --accept-source-agreements `
      --accept-package-agreements
  }
}

# Main
Install-WinGet
Install-Apps
