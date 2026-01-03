<#
 windows.ps1 -- guidance for Windows users.

 This PowerShell script is not meant to be run automatically. It explains
 how to leverage Windows Subsystem for Linux (WSL) to install the
 dotfiles on a Windows machine. The recommended approach is:

   1. Install WSL2 with your favorite distribution (Ubuntu recommended).
   2. Launch your WSL shell and clone this dotfiles repository.
   3. Inside WSL, run `make` to perform the setup (packages, linking, etc.).

 Directly managing Windows‑native configuration with these dotfiles is
 outside the scope of this repository. Windows users should prefer WSL to
 achieve a Unix‑like environment consistent with macOS and Linux.
#>

Write-Host "This script provides instructions for installing dotfiles on Windows using WSL."
Write-Host "Please follow the README.md instructions in the dotfiles repository."