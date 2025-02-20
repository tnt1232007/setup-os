# irm https://get.activated.win | iex
# irm https://url.trinitro.io/setup | iex

# Check for administrative privileges
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
        SSH = $ssh -match '^[yY]$'
        Entertainment = $etm -match '^[yY]$'
        Programming = $prg -match '^[yY]$'
    }
}

function Install-CompulsoryModules {
    Write-Output "🔧 Installing compulsory powershell modules..."
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
    .\modules\pfwsl\bin\pfw.ps1 add 22
}

function Install-CompulsorySoftware {
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

function Install-EntertainmentSoftware {
    Write-Output "🔧 Installing entertainment software..."
    winget install -e --id Spotify.Spotify
    winget install -e --id Plex.Plex --source winget
    winget install -e --id clsid2.mpc-hc
    winget install -e --id Valve.Steam
}

function Install-ProgrammingSoftware {
    Write-Output "🔧 Installing programming software..."
    winget install -e --id JetBrains.Toolbox
    winget install -e --id Microsoft.DotNet.SDK.Preview
    winget install -e --id CoreyButler.NVMforWindows
    winget install -e --id Yarn.Yarn
}

function Configure-Git {
    Write-Output "🔧 Configuring Git..."
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    git config --global user.name "Nhan Ngo"
    git config --global user.email "tnt1232007@gmail.com"
    git config --global rebase.autoStash true
    git config --global pull.rebase true

    Set-Location ~
    $sshKeyPath = "$HOME\.ssh\id_ed25519"
    if (-Not (Test-Path -Path $sshKeyPath)) {
        ssh-keygen -t ed25519 -f "$sshKeyPath" -N '""'
        $github_user = "tnt1232007"
        $github_token = ""
        $body = @{
            title = (hostname)
            key = (Get-Content "$sshKeyPath.pub").Trim()
        } | ConvertTo-Json
        Invoke-RestMethod -Uri "https://api.github.com/user/keys" -Method Post -Headers @{
            Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("${github_user}:${github_token}"))
            Accept = "application/vnd.github.v3+json"
        } -Body $body
        ssh-keyscan github.com >> ~\.ssh\known_hosts
    }
}

function Restore-Workspace {
    Write-Output "🔧 Restoring projects..."
    param (
        [string]$WorkspacePath
    )

    if (-Not (Test-Path -Path $WorkspacePath)) {
        New-Item -ItemType Directory -Path $WorkspacePath
    }
    Set-Location $WorkspacePath
    if (-Not (Test-Path -Path "$WorkspacePath\powershell-scripts")) {
        git clone "git@github.com:tnt1232007/powershell-scripts.git"
    }
    if (-Not (Test-Path -Path "$WorkspacePath\autohotkey-scripts")) {
        git clone "git@github.com:tnt1232007/autohotkey-scripts.git"
    }
    if (-Not (Test-Path -Path "$WorkspacePath\configurations")) {
        git clone "git@github.com:tnt1232007/configurations.git"
    }
}

function Restore-Configurations {
    param (
        [string]$WorkspacePath,
        [bool]$SSH
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
    if ($SSH) {
    }
}

# Main script execution
Write-Output "🚀 Starting setup script..."
$userInput = Get-UserInput

Install-CompulsoryModules
Install-CompulsorySoftware
if ($userInput.Entertainment) {
    Install-EntertainmentSoftware
}
if ($userInput.Programming) {
    Install-ProgrammingSoftware
}
if ($userInput.SSH) {
    Install-SSHServer
}

Configure-Git
Restore-Workspace -WorkspacePath $userInput.WorkspacePath
Restore-Configurations -WorkspacePath $userInput.WorkspacePath -EnableSSH $userInput.SSH
Write-Output "✅ Setup script completed successfully."