[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$zh0 = [char]0x8BF7 + [char]0x9009 + [char]0x62E9 + [char]0x8BED + [char]0x8A00
$zh1 = [char]0x8BF7 + [char]0x8F93 + [char]0x5165 + [char]0x6570 + [char]0x5B57 + " (1-2) [" + [char]0x9ED8 + [char]0x8BA4 + " 1]"
$zh2 = "=== " + [char]0x5FEB + [char]0x6377 + [char]0x8F6F + [char]0x4EF6 + [char]0x4E0B + [char]0x8F7D + [char]0x5B89 + [char]0x88C5 + [char]0x5B83 + [char]0x5177 + " ==="
$zh3 = [char]0x8BF7 + [char]0x9009 + [char]0x62E9 + [char]0x4F60 + [char]0x8981 + [char]0x4E0B + [char]0x8F7D + [char]0x5B89 + [char]0x88C5 + [char]0x7684 + [char]0x8F6F + [char]0x4EF6 + ":"
$zh4 = [char]0x8BF7 + [char]0x9009 + [char]0x62E9 + [char]0x5B89 + [char]0x88C5 + [char]0x6A21 + [char]0x0020 + "-" + [char]0x0020
$zh5 = "1. " + [char]0x666E + [char]0x901A + [char]0x5B89 + [char]0x88C5 + " (" + [char]0x6253 + [char]0x0020 + [char]0x5B89 + [char]0x88C5 + [char]0x5305 + [char]0x754C + [char]0x9762 + ")"
$zh6 = "2. " + [char]0x9759 + [char]0x9ED8 + [char]0x5B89 + [char]0x88C5 + " (" + [char]0x540E + [char]0x53F0 + [char]0x81EA + [char]0x5A92 + [char]0x5B89 + [char]0x88C5 + ")"
$zh7 = "0. " + [char]0x840C + [char]0x9000 + " / Exit"
$zh8 = [char]0x6B63 + [char]0x5728 + [char]0x4E0B + [char]0x8F7D
$zh9 = [char]0x6B63 + [char]0x5728 + [char]0x6253 + [char]0x0020 + [char]0x5B89 + [char]0x88C5 + [char]0x7A0B + [char]0x5A8F + "..."
$zh10 = [char]0x6B63 + [char]0x5728 + [char]0x0020 + [char]0x9759 + [char]0x9ED8 + [char]0x5B89 + [char]0x88C5 + "..."
$zh11 = [char]0x64CD + [char]0x4F5C + [char]0x5B8C + [char]0x6210 + "!"
$zh12 = [char]0x8F93 + [char]0x5165 + [char]0x65E0 + [char]0x6548 + "."

Clear-Host
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host " Select Language / $zh0" -ForegroundColor Yellow
Write-Host " 1. Chinese"
Write-Host " 2. English"
Write-Host "=========================================" -ForegroundColor Cyan
$langChoice = Read-Host "$zh1"
if (-not $langChoice) { $langChoice = "1" }

if ($langChoice -eq "2") {
    $txtTitle             = "=== Software Installation Hub ==="
    $txtSelectApp         = "Select the software you want to install:"
    $txtSelectMode        = "Select installation mode for"
    $txtModeManual        = "1. Manual Install"
    $txtModeSilent        = "2. Silent Install"
    $txtBack              = "0. Exit"
    $txtDownloading       = "Downloading"
    $txtLaunching         = "Launching installer..."
    $txtInstallingSilent  = "Executing silent installation..."
    $txtDone              = "Operation completed!"
    $txtInvalid           = "Invalid selection."
} else {
    $txtTitle             = $zh2
    $txtSelectApp         = $zh3
    $txtSelectMode        = $zh4
    $txtModeManual        = $zh5
    $txtModeSilent        = $zh6
    $txtBack              = $zh7
    $txtDownloading       = $zh8
    $txtLaunching         = $zh9
    $txtInstallingSilent  = $zh10
    $txtDone              = $zh11
    $txtInvalid           = $zh12
}

$softwareList = @(
    @{ 
        Id = "1"
        Name = "Roblox Player"
        RawUrl = "https://alist.legspcpd.top/d/Github/exe/RobloxPlayerInstaller.exe"
        FileName = "RobloxPlayerInstaller.exe"
        SilentArgs = "" 
    },
    @{ 
        Id = "2"
        Name = "Firefox Installer (Online)"
        RawUrl = "https://alist.legspcpd.top/d/Github/exe/Firefox%20Installer.exe"
        FileName = "Firefox_Installer.exe"
        SilentArgs = "-ms"
    },
    @{ 
        Id = "3"
        Name = "Firefox Setup 154.0 (Offline)"
        RawUrl = "https://alist.legspcpd.top/d/Github/exe/Firefox%20Setup%20154.0.exe"
        FileName = "Firefox_Setup_154.0.exe"
        SilentArgs = "-ms"
    },
    @{ 
        Id = "4"
        Name = "ChatGPT Installer"
        RawUrl = "https://alist.legspcpd.top/d/Github/exe/ChatGPT%20Installer.exe"
        FileName = "ChatGPT_Installer.exe"
        SilentArgs = "/S"
    },
    @{ 
        Id = "5"
        Name = "Google Chrome (Online)"
        RawUrl = "https://alist.legspcpd.top/d/Github/ChromeSetup.exe"
        FileName = "ChromeSetup.exe"
        SilentArgs = "/silent /install"
    },
    @{ 
        Id = "6"
        Name = "Google Chrome (151.0 Offline)"
        RawUrl = "https://alist.legspcpd.top/d/Github/exe/151.0.7922.174_chrome_installer_uncompressed.exe"
        FileName = "chrome_installer_offline.exe"
        SilentArgs = "/silent /install"
    },
    @{ 
        Id = "7"
        Name = "Old Outlook 2021 (Online)"
        RawUrl = "https://alist.legspcpd.top/d/Github/exe/Old%20Outlook%202021.exe?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJhZG1pbiIsInR5cGUiOjIsImV4cCI6MTc4Nzk4NDIyMn0.eGVUt_ONIkiEoJuk26RtNHFjyD61ziv-qeeqQwzbGcs"
        FileName = "Old_Outlook_2021.exe"
        SilentArgs = ""
    },
    @{ 
        Id = "8"
        Name = "PotPlayer 64bit"
        RawUrl = "https://alist.legspcpd.top/d/Github/exe/PotPlayerSetup64.exe?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJhZG1pbiIsInR5cGUiOjIsImV4cCI6MTc4Nzk4NDIyMn0.eGVUt_ONIkiEoJuk26RtNHFjyD61ziv-qeeqQwzbGcs"
        FileName = "PotPlayerSetup64.exe"
        SilentArgs = "/S"
    },
    @{ 
        Id = "9"
        Name = "Bandizip Pro 8.00 Beta 10 x64 Repack"
        RawUrl = "https://alist.legspcpd.top/d/Github/exe/Bandizip-Pro-8.00-Beta-10-x64-Repack.exe?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJhZG1pbiIsInR5cGUiOjIsImV4cCI6MTc4Nzk4NDIyMn0.eGVUt_ONIkiEoJuk26RtNHFjyD61ziv-qeeqQwzbGcs"
        FileName = "Bandizip-Pro-8.00-Beta-10-x64-Repack.exe"
        SilentArgs = "/S"
    },
    @{ 
        Id = "10"
        Name = "Bandizip Professional 7.46 x64 Repack"
        RawUrl = "https://alist.legspcpd.top/d/Github/exe/Bandizip-Professional-7.46-x64-Repack.exe?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJhZG1pbiIsInR5cGUiOjIsImV4cCI6MTc4Nzk4NDIyMn0.eGVUt_ONIkiEoJuk26RtNHFjyD61ziv-qeeqQwzbGcs"
        FileName = "Bandizip-Professional-7.46-x64-Repack.exe"
        SilentArgs = "/S"
    }
)

function Get-CleanUrl ($url) {
    return ($url -split '\?')[0]
}

while ($true) {
    Clear-Host
    Write-Host $txtTitle -ForegroundColor Green
    Write-Host $txtSelectApp
    Write-Host "-----------------------------------------"
    
    foreach ($app in $softwareList) {
        Write-Host "$($app.Id). $($app.Name)"
    }
    Write-Host "0. Exit"
    Write-Host "-----------------------------------------"
    
    $selectedId = Read-Host "Input ID"
    if ($selectedId -eq "0") { break }
    
    $targetApp = $softwareList | Where-Object { $_.Id -eq $selectedId }
    
    if ($null -ne $targetApp) {
        Clear-Host
        Write-Host "$txtSelectMode [$($targetApp.Name)]" -ForegroundColor Yellow
        Write-Host "-----------------------------------------"
        Write-Host $txtModeManual
        Write-Host $txtModeSilent
        Write-Host $txtBack
        Write-Host "-----------------------------------------"
        
        $modeChoice = Read-Host "Input ID"
        if ($modeChoice -eq "0") { continue }
        
        $downloadUrl = $targetApp.RawUrl
        $displayUrl = Get-CleanUrl $downloadUrl
        $tempPath = Join-Path $env:TEMP $targetApp.FileName
        
        Write-Host "${txtDownloading}: $displayUrl ..." -ForegroundColor Cyan
        
        try {
            Invoke-WebRequest -Uri $downloadUrl -OutFile $tempPath -UseBasicParsing -ErrorAction Stop
            
            if ($modeChoice -eq "1") {
                Write-Host $txtLaunching -ForegroundColor Green
                Start-Process -FilePath $tempPath
            } 
            elseif ($modeChoice -eq "2") {
                Write-Host $txtInstallingSilent -ForegroundColor Green
                if ($targetApp.SilentArgs) {
                    Start-Process -FilePath $tempPath -ArgumentList $targetApp.SilentArgs -Wait
                } else {
                    Start-Process -FilePath $tempPath -Wait
                }
                Write-Host $txtDone -ForegroundColor Green
                Start-Sleep -Seconds 2
            }
        } 
        catch {
            Write-Host "Error: $_" -ForegroundColor Red
            Pause
        }
    } 
    else {
        Write-Host $txtInvalid -ForegroundColor Red
        Start-Sleep -Seconds 1
    }
}