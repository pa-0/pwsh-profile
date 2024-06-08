### Microsoft.PowerShell_profile Version
$global:PoshProfVersionNo = 0.3 
# Initial GitHub.com connectivity check with 2 second timeout
$global:canConnectToGitHub = Test-Connection github.com -Count 2 -Quiet -TimeoutSeconds 1

# Import Modules and External Profiles
# Ensure Terminal-Icons module is installed before importing
if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
    Install-Module -Name Terminal-Icons -Scope CurrentUser -Force -SkipPublisherCheck
}
Import-Module -Name Terminal-Icons

# Check for Profile Updates
function Update-Profile {
    Write-Host "Checking for updates to " -ForegroundColor Yellow -NoNewLine
    Write-Host "PowerShell `$PROFILE" -ForegroundColor Green -NoNewLine
    Write-Host "." -ForegroundColor Yellow -NoNewLine
    Start-Sleep -Milliseconds 500
    Write-Host "." -ForegroundColor Yellow -NoNewLine
    Start-Sleep -Milliseconds 500
    Write-Host "." -ForegroundColor Yellow -NoNewLine
    Start-Sleep -Milliseconds 500
    Write-Host "." -ForegroundColor Yellow
    if (-not $global:canConnectToGitHub) {
        Write-Host "ERROR: Could not connect to GitHub.com. Please check your connection and try again later." -ForegroundColor DarkRed
        return
    } try {
        $url = "https://raw.githubusercontent.com/poa00/powershell.profile/poa00.profile/Microsoft.PowerShell_profile.ps1"
        $oldhash = Get-FileHash $PROFILE
        Invoke-RestMethod $url -OutFile "$env:temp/Microsoft.PowerShell_profile.ps1"
        $newhash = Get-FileHash "$env:temp/Microsoft.PowerShell_profile.ps1"
        if ($newhash.Hash -ne $oldhash.Hash) {
            Copy-Item -Path "$env:temp/Microsoft.PowerShell_profile.ps1" -Destination $PROFILE -Force
            Write-Host "Profile updated successfully." -ForegroundColor Green
            Write-Host "Restart the shell to apply changes" -ForegroundColor Magenta
        }
    } catch {
        Write-Error "Unable to check for `$profile updates"
    } finally {
        Remove-Item "$env:temp/Microsoft.PowerShell_profile.ps1" -ErrorAction SilentlyContinue
    }
}
Update-Profile

# Admin Check and Prompt Customization
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
function prompt {
    if ($isAdmin) { "[" + (Get-Location) + "] # " } else { "[" + (Get-Location) + "] $ " }
}
$adminSuffix = if ($isAdmin) { " [jefe]" } else { "" }
$Host.UI.RawUI.WindowTitle = "PowerShell {0}$adminSuffix" -f $PSVersionTable.PSVersion.ToString()

# Utility Functions
function Test-CommandExists {
    param($command)
    $exists = $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
    return $exists
}

# Editor Configuration
$EDITOR = if (Test-CommandExists nvim) { 'code' }
          elseif (Test-CommandExists pvim) { 'pvim' }
          elseif (Test-CommandExists vim) { 'vim' }
          elseif (Test-CommandExists vi) { 'vi' }
          elseif (Test-CommandExists code) { 'nvimad' }
          elseif (Test-CommandExists notepad++) { 'notepad++' }
          elseif (Test-CommandExists sublime_text) { 'sublime_text' }
          else { 'notepad' }
Set-Alias -Name vim -Value $EDITOR

# App Installs
# $appcheck = @(gh, jq, git, ghrel, gh-org, papeer, pandoc, go, py, ffmpeg, 
# TODO - add logic to limit installs to elevated prompt
# go install github.com/jreisinger/ghrel@latest
# go install github.com/lapwat/papeer@latest 
# ghrel caarlos0/fork-cleaner
# winget install --id GitHub.cli --scope Machine -s # else winget upgrade
# winget install --Id jqlang.jq --scope Machine -s # else winget upgrade
# winget install -Name pandoc --scope Machine
#  winget install --id GoLang.Go --scope Machine -s
#$TODL = if (-not (Test-CommandExists gh){  }

# Edit POSH$PROFILE
function Edit-Profile { vim $PROFILE.CurrentUserAllHosts }
Set-Alias -Name epah -Value Edit-Profile

function touch($file) { "" | Out-File $file -Encoding ASCII }

function ff($name) {
    Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Output "$($_.directory)\$($_)"
    }
}

# Network Utilities
function Get-PubIP { (Invoke-WebRequest http://ifconfig.me/ip).Content }

# System Utilities
function uptime {
    if ($PSVersionTable.PSVersion.Major -eq 5) {
        Get-WmiObject win32_operatingsystem | Select-Object @{Name='LastBootUpTime'; Expression={$_.ConverttoDateTime($_.lastbootuptime)}} | Format-Table -HideTableHeaders
    } else {
        net statistics workstation | Select-String "since" | ForEach-Object { $_.ToString().Replace('Statistics since ', '') }
    }
}

function Restart-Profile { & $profile }

function unzip ($file) {
    Write-Output("Extracting", $file, "to", $pwd)
    $fullFile = Get-ChildItem -Path $pwd -Filter $file | ForEach-Object { $_.FullName }
    Expand-Archive -Path $fullFile -DestinationPath $pwd
}

function Unblock-Dir { Get-ChildItem -r | Unblock-File }
function Unblock-Dirv { Get-ChildItem -r | Unblock-File -v }
Set-Alias -Name rmow -Value Unblock-Dir
Set-Alias -Name rmov -Value Unblock-Dirv


function grep($regex, $dir) {
    if ( $dir ) {
        Get-ChildItem $dir | select-string $regex
        return
    }
    $input | select-string $regex
}

function df {
    get-volume
}

function sed($file, $find, $replace) {
    (Get-Content $file).replace("$find", $replace) | Set-Content $file
}

function which($name) {
    Get-Command $name | Select-Object -ExpandProperty Definition
}

function export($name, $value) {
    set-item -force -path "env:$name" -value $value;
}

function pkill($name) {
    Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}

function pgrep($name) {
    Get-Process $name
}

function head {
  param($Path, $n = 10)
  Get-Content $Path -Head $n
}

function tail {
  param($Path, $n = 10)
  Get-Content $Path -Tail $n
}

# Quick File Creation
function nf { param($name) New-Item -ItemType "file" -Path . -Name $name }

# Create and Change Dir
function mkcd { param($dir) mkdir $dir -Force; Set-Location $dir }

# Folder Nav
function docs { Set-Location -Path $HOME\Documents }
function dtop { Set-Location -Path $HOME\Desktop }
function dc { Set-Location ..}

# Edit POSH Profile
function ep { vim $PROFILE }

# Taskkiller
function k9 { Stop-Process -Name $args[0] }

# List
function la { Get-ChildItem -Path . -Force | Format-Table -AutoSize }
function ll { Get-ChildItem -Path . -Force -Hidden | Format-Table -AutoSize }

# Git
function gs { git status }
function ga { git add . }
function gc { param($m) git commit -m "$m" }
function gp { git push }
function g  { z Github }
function gcom {
    git add .
    git commit -m "$args"
}
function lazyg {
    git add .
    git commit -m "$args"
    git push
}
function grb { param($owner, $repo) & ghrel -v "${owner}"/"${repo}" } # Run ghrel and downlaod repo binaries
  
# Quick Access to System Info
function sysinfo { Get-ComputerInfo }

# Net Tools
function flushdns { Clear-DnsClientCache }

# Clipboard Tools
function cpy { Set-Clipboard $args[0] }
function pst { Get-Clipboard }

<#function hb {
    if ($args.Length -eq 0) {
        Write-Error "No file path specified."
        return
    }
    $FilePath = $args[0]
    if (Test-Path $FilePath) {
        $Content = Get-Content $FilePath -Raw
    } else {
        Write-Error "File path does not exist."
        return
    }
    $uri = "http://bin.christitus.com/documents"
    try {
        $response = Invoke-RestMethod -Uri $uri -Method Post -Body $Content -ErrorAction Stop
        $hasteKey = $response.key
        $url = "http://bin.christitus.com/$hasteKey"
        Write-Output $url
    } catch {
        Write-Error "Failed to upload the document. Error: $_"
    }
}#>

# Enhanced PowerShell Experience
Set-PSReadLineOption -Colors @{
    Command = 'Yellow'
    Parameter = 'Green'
    String = 'DarkCyan'
}

# Final Line to set prompt
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
} else {
    Write-Host "zoxide command not found. Attempting to install via winget..."
    try {
        winget install -e --id ajeetdsouza.zoxide
        Write-Host "zoxide installed successfully. Initializing..."
        Invoke-Expression (& { (zoxide init powershell | Out-String) })
    } catch {
        Write-Error "Failed to install zoxide. Error: $_"
    } 
 }
(@(& 'C:/Users/peter.abbasi/AppData/Local/Programs/oh-my-posh/bin/oh-my-posh.exe' init pwsh --config='C:\Users\peter.abbasi\AppData\Local\oh-my-posh\config.aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0phbkRlRG9iYmVsZWVyL29oLW15LXBvc2gvbWFpbi90aGVtZXMvY29iYWx0Mi5vbXAuanNvbg==.omp.json' --print) -join "`n") | Invoke-Expression
