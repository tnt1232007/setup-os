# irm https://get.activated.win | iex
# irm https://url.trinitro.io/wins-setup | iex

<# Set "n" to skip
$env:INSTALL_MODULES = "n"
$env:INSTALL_COMPULSORY = "n"
$env:INSTALL_ENTERTAINMENT = "n"
$env:INSTALL_PROGRAMMING = "n"
$env:RESTORE_NETWORK_DRIVE = "n"
$env:RESTORE_GIT_CONFIG = "n"
$env:RESTORE_WORKSPACE = "n"
$env:RESTORE_CONFIGURATIONS = "n"
#>

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "❌ You do not have sufficient privileges to run this script. Please run as administrator."
    Pause
    Exit
}

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

function Get-UserInput {
    $ws = Read-Host -Prompt "❓ Workspace directory? (default D:\Workspace)"
    $env:WORKSPACE_PATH = if ([string]::IsNullOrWhiteSpace($ws)) { "D:\Workspace" } else { $ws }
    if (-not $env:INSTALL_MODULES) {
        $env:INSTALL_MODULES = "y"
    }
    if (-not $env:INSTALL_COMPULSORY) {
        $env:INSTALL_COMPULSORY = "y"
    }
    if (-not $env:INSTALL_ENTERTAINMENT) {
        $env:INSTALL_ENTERTAINMENT = Read-Host -Prompt "❓ Install entertainment softwares (Plex, Spotify, Steam, MPC-HC)? (Y/n)"
    }
    if (-not $env:INSTALL_PROGRAMMING) {
        $env:INSTALL_PROGRAMMING = Read-Host -Prompt "❓ Install programming softwares (JetBrains, DotNet, NVM, Yarn)? (Y/n)"
    }
    if (-not $env:RESTORE_NETWORK_DRIVE) {
        $env:RESTORE_NETWORK_DRIVE = "y"
    }
    if (-not $env:RESTORE_GIT_CONFIG) {
        $env:RESTORE_GIT_CONFIG = "y"
    }
    if (-not $env:RESTORE_WORKSPACE) {
        $env:RESTORE_WORKSPACE = "y"
    }
    if (-not $env:RESTORE_CONFIGURATIONS) {
        $env:RESTORE_CONFIGURATIONS = "y"
    }
    if (-not $env:GITHUB_USER_NAME) {
        $env:GITHUB_USER_NAME = Read-Host -Prompt "❓ Git user name?"
    }
    if (-not $env:GITHUB_USER_EMAIL) {
        $env:GITHUB_USER_EMAIL = Read-Host -Prompt "❓ Git user email?"
    }
    if (-not $env:NETWORK_DRIVE_USERNAME) {
        $env:NETWORK_DRIVE_USERNAME = Read-Host -Prompt "❓ Network Drive username?"
    }
    if (-not $env:NETWORK_DRIVE_PASSWORD) {
        $env:NETWORK_DRIVE_PASSWORD = Read-Host -Prompt "❓ Network Drive password?"
    }
}

function Install-CompulsoryModules {
    Write-Output "🔧 Installing compulsory modules..."
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Install-PackageProvider -Name NuGet -Force -ErrorAction SilentlyContinue
    Install-Module -Name PowerShellGet -Force

    Install-Module -Name posh-git -Force
    Install-Module -Name PSReadLine -Force
    Install-Module -Name Recycle -RequiredVersion 1.5.0 -Force
}

function Install-CompulsorySoftwares {
    Write-Output "🔧 Installing compulsory software..."
    winget install -e --id Microsoft.PowerShell --accept-source-agreements --accept-package-agreements
    winget install -e --id AutoHotkey.AutoHotkey
    winget install -e --id Raycast.Raycast
    winget install -e --id Microsoft.PowerToys
    winget install -e --id Bitwarden.Bitwarden
    winget install -e --id Google.Chrome
    winget install -e --id StartIsBack.StartAllBack
    winget install -e --id voidtools.Everything.Alpha
    winget install -e --id Bandisoft.Honeyview
    winget install -e --id 7zip.7zip
    winget install -e --id JanDeDobbeleer.OhMyPosh
    winget install -e --id Git.Git
    winget install -e --id Microsoft.VisualStudioCode --override '/VERYSILENT /SP- /MERGETASKS="!runcode,!desktopicon,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath"'
    winget install -e --id Devolutions.RemoteDesktopManager
}

function Install-EntertainmentSoftwares {
    Write-Output "🔧 Installing entertainment software..."
    winget install -e --id Spotify.Spotify
    winget install -e --id Plex.Plex
    winget install -e --id clsid2.mpc-hc
}

function Install-ProgrammingSoftwares {
    Write-Output "🔧 Installing programming software..."
    winget install -e --id JetBrains.Toolbox
    winget install -e --id Microsoft.DotNet.SDK.Preview
}

function Restore-GitConfig {
    Write-Output "🔧 Restoring git configs..."
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    git config --global user.name $env:GITHUB_USER_NAME
    git config --global user.email $env:GITHUB_USER_EMAIL
    git config --global rebase.autoStash true
    git config --global pull.rebase true

    Write-Output "🔧 Configuring SSH for git..."
    $serviceName = "ssh-agent"
    Start-Process powershell -Verb RunAs -ArgumentList 
@"
    Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue
    Set-Service -Name $serviceName -StartupType Disabled
"@

    git config --global gpg.format ssh
    git config --global core.sshCommand "C:/Windows/System32/OpenSSH/ssh.exe"
    git config --global gpg.ssh.program "C:/Windows/System32/OpenSSH/ssh-keygen.exe"

}

function Confirm-SshConnectivity {
    while ($true) {
        Write-Output ""
        Write-Output "🔧 Verifying SSH key loaded..."
        ssh-add -L

        Write-Output ""
        Write-Output "🔧 Testing SSH connectivity..."
        $githubResult = ssh -T git@github.com 2>&1 | Out-String
        $forgejResult = ssh -T git@git.trinitro.io -p 222 2>&1 | Out-String

        $githubOk = $githubResult -match "successfully authenticated"
        $forgejOk = $forgejResult -match "successfully authenticated"

        if ($githubOk -and $forgejOk) {
            Write-Output "✅ GitHub: OK"
            Write-Output "✅ Forgejo: OK"
            break
        }
        if (-not $githubOk) { Write-Output "❌ GitHub: Failed" }
        if (-not $forgejOk) { Write-Output "❌ Forgejo: Failed" }

        Write-Output ""
        Write-Output "❌ SSH connection failed. Please:"
        Write-Output "   1. Login to Bitwarden and unlock your vault"
        Write-Output "   2. Ensure SSH key is available to the agent"
        Write-Output ""
        Read-Host -Prompt "Press Enter to retry"
    }
}

function Restore-Workspace {
    $wp = $env:WORKSPACE_PATH
    $forgejo = "ssh://git@git.trinitro.io:222/tnt1232007"
    $github = "git@github.com:tnt1232007"
    $repos = @("powershell-scripts", "autohotkey-scripts", "configurations")

    Write-Output "🔧 Restoring projects..."
    if (-Not (Test-Path -Path $wp)) {
        New-Item -ItemType Directory -Path $wp
    }
    Set-Location $wp
    foreach ($repo in $repos) {
        if (-Not (Test-Path -Path "$wp\$repo")) {
            git clone --recurse-submodules -j8 "$forgejo/$repo.git"
            Set-Location "$wp\$repo"
            git remote set-url --add --push origin "$github/$repo.git"
            Set-Location $wp
        }
    }
}

function Restore-Configurations {
    $wp = $env:WORKSPACE_PATH
    Write-Output "🔧 Restoring configurations..."
    [Environment]::SetEnvironmentVariable("Path", $env:Path + ";$wp\powershell-scripts", "Machine")
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    powercfg -h off
    Set-Location "$wp\powershell-scripts"
    .\font_install.ps1
    .\configuration_restore.ps1
    .\explorer_remove_onedrive.ps1
    .\explorer_remove_git_context.ps1
    .\explorer_show_file_extension.ps1
}

function Restore-NetworkDrive {
    param (
        [Parameter(Mandatory=$true)] [string]$NetworkPath,
        [Parameter(Mandatory=$true)] [string]$DriveLetter
    )

    $SecurePassword = ConvertTo-SecureString $env:NETWORK_DRIVE_PASSWORD -AsPlainText -Force
    $Credential = New-Object System.Management.Automation.PSCredential ($env:NETWORK_DRIVE_USERNAME, $SecurePassword)
    try {
        New-PSDrive -Name $DriveLetter.Trim(':') -PSProvider FileSystem -Root $NetworkPath -Credential $Credential -Persist
    } catch {
        New-PSDrive -Name $DriveLetter.Trim(':') -PSProvider FileSystem -Root $NetworkPath
    }
}

Write-Output "🚀 Starting setup script..."
Get-UserInput
if ($env:INSTALL_MODULES -notmatch '^[nN]$') {
    Install-CompulsoryModules
    $env:INSTALL_MODULES = "n"
}
if ($env:INSTALL_COMPULSORY -notmatch '^[nN]$') {
    Install-CompulsorySoftwares
    $env:INSTALL_COMPULSORY = "n"
}
if ($env:INSTALL_ENTERTAINMENT -notmatch '^[nN]$') {
    Install-EntertainmentSoftwares
    $env:INSTALL_ENTERTAINMENT = "n"
}
if ($env:INSTALL_PROGRAMMING -notmatch '^[nN]$') {
    Install-ProgrammingSoftwares
    $env:INSTALL_PROGRAMMING = "n"
}
if ($env:RESTORE_NETWORK_DRIVE -notmatch '^[nN]$') {
    Restore-NetworkDrive -NetworkPath "\\nas-syno\external" -DriveLetter "Z:"
    Restore-NetworkDrive -NetworkPath "\\nas-syno\media" -DriveLetter "Y:"
    $env:RESTORE_NETWORK_DRIVE = "n"
}
if ($env:RESTORE_GIT_CONFIG -notmatch '^[nN]$') {
    Restore-GitConfig
    Confirm-SshConnectivity
    $env:RESTORE_GIT_CONFIG = "n"
}
if ($env:RESTORE_WORKSPACE -notmatch '^[nN]$') {
    Restore-Workspace
    $env:RESTORE_WORKSPACE = "n"
}
if ($env:RESTORE_CONFIGURATIONS -notmatch '^[nN]$') {
    Restore-Configurations
    $env:RESTORE_CONFIGURATIONS = "n"
}