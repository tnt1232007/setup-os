# irm https://get.activated.win | iex
# irm https://url.trinitro.io/setup | iex

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "❌ You do not have sufficient privileges to run this script. Please run as administrator."
    Pause
    Exit
}

function Get-UserInput {
    $ws = Read-Host -Prompt "❓ Workspace directory? (default D:\Workspace)"
    $ssh = Read-Host -Prompt "❓ Install SSH server? (y/n)"
    $etm = Read-Host -Prompt "❓ Install entertainment softwares (Plex, Spotify, Steam, MPC-HC)? (y/n)"
    $prg = Read-Host -Prompt "❓ Install programming softwares (JetBrains, DotNet, NVM, Yarn)? (y/n)"
    return @{
        WorkspacePath = if ([string]::IsNullOrWhiteSpace($ws)) { "D:\Workspace" } else { $ws }
        InstallSSHServer = $ssh -match '^[yY]$'
        InstallEntertainmentSoftwares = $etm -match '^[yY]$'
        InstallProgrammingSoftwares = $prg -match '^[yY]$'
    }
}

function Install-CompulsoryModules {
    Write-Output "🔧 Installing compulsory modules..."
    Set-ExecutionPolicy RemoteSigned
    Install-PackageProvider -Name NuGet -Force
    Install-Module -Name PowerShellGet -Force

    Install-Module -Name posh-git -Force
    Install-Module -Name PSReadLine -Force
    Install-Module -Name Recycle -RequiredVersion 1.5.0 -Force
    Install-Module -Name Microsoft.WinGet.Client -Force
    Install-Module -Name Microsoft.WinGet.CommandNotFound -Force
    Repair-WinGetPackageManager
}

function Install-SSHServer {
    Write-Output "🔧 Setting up SSH server..."
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    Start-Service 'sshd'
    Start-Service 'ssh-agent'
    Set-Service -Name 'sshd' -StartupType 'Automatic'
    Set-Service -Name 'ssh-agent' -StartupType 'Automatic'
    New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Program Files\PowerShell\7\pwsh.exe" -PropertyType String -Force
}

function Install-CompulsorySoftwares {
    Write-Output "🔧 Installing compulsory software..."
    winget install -e --id Microsoft.PowerShell --accept-source-agreements --accept-package-agreements
    winget install -e --id Lexikos.AutoHotkey
    winget install -e --id Microsoft.PowerToys
    winget install -e --id Google.Chrome
    winget install -e --id voidtools.Everything.Alpha
    winget install -e --id Bandisoft.Honeyview
    winget install -e --id 7zip.7zip
    winget install -e --id JanDeDobbeleer.OhMyPosh
    winget install -e --id Git.Git
    winget install -e --id Microsoft.VisualStudioCode --override '/VERYSILENT /SP- /MERGETASKS="!runcode,!desktopicon,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath"'
}

function Install-EntertainmentSoftwares {
    Write-Output "🔧 Installing entertainment software..."
    winget install -e --id Spotify.Spotify
    winget install -e --id Plex.Plex --source winget
    winget install -e --id clsid2.mpc-hc
    winget install -e --id Valve.Steam
}

function Install-ProgrammingSoftwares {
    Write-Output "🔧 Installing programming software..."
    winget install -e --id JetBrains.Toolbox
    winget install -e --id Microsoft.DotNet.SDK.Preview
    winget install -e --id CoreyButler.NVMforWindows
    winget install -e --id Yarn.Yarn
}

function Configure-Git {
    Write-Output "🔧 Configuring git..."
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    git config --global user.name "Nhan Ngo"
    git config --global user.email "tnt1232007@gmail.com"
    git config --global rebase.autoStash true
    git config --global pull.rebase true

    $sshPath = "$HOME\.ssh"
    if (-Not (Test-Path -Path $sshPath)) {
        mkdir $sshPath
    }
    $sshKeyPath = "$sshPath\id_ed25519"
    if (-Not (Test-Path -Path "$sshKeyPath")) {
        Write-Output "🔧 Creating new ssh-keys..."
        ssh-keygen -t ed25519 -f "$sshKeyPath" -N '""'
        ssh-keyscan github.com | Out-File -Encoding ascii -Append "$sshPath\known_hosts"
        $body = @{
            title = (hostname)
            key = (Get-Content "$sshKeyPath.pub").Trim()
        } | ConvertTo-Json
        Invoke-RestMethod -Uri "https://api.github.com/user/keys" -Method Post -Headers @{
            Authorization = "Basic dG50MTIzMjAwNzpnaXRodWJfcGF0XzExQUFUWllKUTBWMDZyT01tYjlIOEJfRjdZZjl3UDc2ZVFOU3E2dFVod1RwczN4aVpyOXVOaGl5REx1ZWJjTUFVRVkyMlg3N0FMZHBENGZCdlA="
            Accept = "application/vnd.github.v3+json"
        } -Body $body
    }
}

function Restore-Workspace {
    param (
        [string]$WorkspacePath
    )

    Write-Output "🔧 Restoring projects..."
    if (-Not (Test-Path -Path $WorkspacePath)) {
        New-Item -ItemType Directory -Path $WorkspacePath
    }
    Set-Location $WorkspacePath
    if (-Not (Test-Path -Path "$WorkspacePath\powershell-scripts")) {
        git clone --recurse-submodules -j8 "git@github.com:tnt1232007/powershell-scripts.git"
    }
    if (-Not (Test-Path -Path "$WorkspacePath\autohotkey-scripts")) {
        git clone --recurse-submodules -j8 "git@github.com:tnt1232007/autohotkey-scripts.git"
    }
    if (-Not (Test-Path -Path "$WorkspacePath\configurations")) {
        git clone --recurse-submodules -j8 "git@github.com:tnt1232007/configurations.git"
    }
}

function Restore-Configurations {
    param (
        [string]$WorkspacePath,
        [bool]$InstallSSHServer
    )

    Write-Output "🔧 Restoring configurations..."
    [Environment]::SetEnvironmentVariable("Path", $env:Path + ";$WorkspacePath\powershell-scripts", "Machine")
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    powercfg -h off
    Set-Location "$WorkspacePath\powershell-scripts"
    .\code_workspace_generate.ps1
    .\font_install.ps1
    .\configuration_restore.ps1
    .\explorer_remove_onedrive.ps1
    .\explorer_remove_git_context.ps1
    .\explorer_show_file_extension.ps1
    if ($InstallSSHServer) {
        .\modules\pfwsl\bin\pfw.ps1 add 22
    }
}

Write-Output "🚀 Starting setup script..."
$userInput = Get-UserInput
Install-CompulsoryModules
Install-CompulsorySoftwares
if ($userInput.InstallEntertainmentSoftwares) {
    Install-EntertainmentSoftwares
}
if ($userInput.InstallProgrammingSoftwares) {
    Install-ProgrammingSoftwares
}
if ($userInput.InstallSSHServer) {
    Install-SSHServer
}
Configure-Git
Restore-Workspace -WorkspacePath $userInput.WorkspacePath
Restore-Configurations -WorkspacePath $userInput.WorkspacePath -InstallSSHServer $userInput.InstallSSHServer
Write-Output "✅ Setup script completed successfully."