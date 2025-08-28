# winget-setup

https://learn.microsoft.com/en-us/windows/package-manager/winget/

PowerShell-based installer for winget and bulk app deployment.

## Usage

1. Open PowerShell **as Administrator**  
2. Clone this repo:  
   ```powershell
   git clone https://github.com/divemarkus/winget-setup.git
   cd winget-setup
3. Run the installer:
   ```powershell
   .\install-winget.ps1

### How It Works
* Install-WinGet:

* Calls GitHub’s REST API to grab the latest .msixbundle.

* Uses Add-AppxPackage to install silently.

* Install-Apps:

* Reads apps.txt, filters out comments/empty lines.

* Runs winget install --id <AppId> --exact for each entry.

### Getting Started
* Fork or clone divemarkus/winget-setup.

* Edit apps.txt with your favorite app IDs from the winget package index.

* Run .\install-winget.ps1 as Administrator.

* With this in place, we’ve got a reproducible, version-controlled way to bootstrap new machines or CI images with your standard toolset.
