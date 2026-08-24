# 强制控制台编码为 UTF-8 (65001) 防止输出乱码
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 > $null

# 内部中文转义字符定义
$zh0 = [char]0x8BF7 + [char]0x9009 + [char]0x62E9 + [char]0x8BED + [char]0x8A00
$zh1 = [char]0x8BF7 + [char]0x8F93 + [char]0x5165 + [char]0x6570 + [char]0x5B57 + " (1-2) [" + [char]0x9ED8 + [char]0x8BA4 + " 1]"
$zh2 = "=== " + [char]0x5FEB + [char]0x6377 + [char]0x8F6F + [char]0x4EF6 + [char]0x4E0B + [char]0x8F7D + [char]0x5B89 + [char]0x88C5 + [char]0x5B83 + [char]0x5177 + " ==="
$zh3 = [char]0x8BF7 + [char]0x9009 + [char]0x62E9 + [char]0x4F60 + [char]0x8981 + [char]0x4E0B + [char]0x8F7D + [char]0x5B89 + [char]0x88C5 + [char]0x7684 + [char]0x8F6F + [char]0x4EF6 + ":"
$zh4 = [char]0x8BF7 + [char]0x9009 + [char]0x62E9 + [char]0x5B89 + [char]0x88C5 + [char]0x6A21 + [char]0x0020 + "-" + [char]0x0020
$zh5 = "1. " + [char]0x666E + [char]0x901A + [char]0x5B89 + [char]0x88C5 + " (" + [char]0x6253 + [char]0x5F00 + [char]0x5B89 + [char]0x88C5 + [char]0x5305 + [char]0x002C + [char]0x81EA + [char]0x884C + [char]0x9009 + [char]0x62E9 + [char]0x5B89 + [char]0x88C5 + [char]0x4F4D + [char]0x7F6E + ")"
$zh6 = "2. " + [char]0x9759 + [char]0x9ED8 + [char]0x5B89 + [char]0x88C5 + " (" + [char]0x540E + [char]0x53F0 + [char]0x81EA + [char]0x52A8 + [char]0x5B89 + [char]0x88C5 + ")"
$zh7 = "0. " + [char]0x840C + [char]0x9000 + " / Exit"
$zh8 = [char]0x6B63 + [char]0x5728 + [char]0x4E0B + [char]0x8F7D
$zh9 = [char]0x6B63 + [char]0x5728 + [char]0x6253 + [char]0x5F00 + [char]0x5B89 + [char]0x88C5 + [char]0x5305 + [char]0x7A0B + [char]0x5A8F + "..."
$zh10 = [char]0x6B63 + [char]0x5728 + [char]0x9759 + [char]0x9ED8 + [char]0x5B89 + [char]0x88C5 + "..."
$zh11 = [char]0x64CD + [char]0x4F5C + [char]0x5B8C + [char]0x6210 + "!"
$zh12 = [char]0x8F93 + [char]0x5165 + [char]0x65E0 + [char]0x6548 + "."

# 解决列表乱码的中文 Unicode 变量
$str360FirstAid = [char]0x0033 + [char]0x0036 + [char]0x0030 + [char]0x6025 + [char]0x救 + [char]0x7B01
$str360BrowserX32 = [char]0x0033 + [char]0x0036 + [char]0x0030 + [char]0x6781 + [char]0x901F + [char]0x6D4F + [char]0x8览 + [char]0x5668
$strHuorong = [char]0x706B + [char]0x0052 + [char]0x70B8 + [char]0x5B89 + [char]0x5168

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
    $txtModeManual        = "1. Manual Install (Open setup UI, choose folder manually)"
    $txtModeSilent        = "2. Silent Install (Background automatic install)"
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
        IsZip = $false
    },
    @{ 
        Id = "2"
        Name = "Firefox Installer (Online)"
        RawUrl = "https://alist.legspcpd.top/d/Github/exe/Firefox%20Installer.exe"
        FileName = "Firefox_Installer.exe"
        SilentArgs = "-ms"
        IsZip = $false
    },
    @{ 
        Id = "3"
        Name = "Firefox Setup 154.0 (Offline)"
        RawUrl = "https://alist.legspcpd.top/d/Github/exe/Firefox%20Setup%20154.0.exe"
        FileName = "Firefox_Setup_154.0.exe"
        SilentArgs = "-ms"
        IsZip = $false
    },
    @{ 
        Id = "4"
        Name = "ChatGPT Installer"
        RawUrl = "https://alist.legspcpd.top/d/Github/exe/ChatGPT%20Installer.exe"
        FileName = "ChatGPT_Installer.exe"
        SilentArgs = "/S"
        IsZip = $false
    },
    @{ 
        Id = "5"
        Name = "Google Chrome (Online)"
        RawUrl = "https://alist.legspcpd.top/d/Github/ChromeSetup.exe"
        FileName = "ChromeSetup.exe"
        SilentArgs = "/silent /install"
        IsZip = $false
    },
    @{ 
        Id = "6"
        Name = "Google Chrome (151.0 Offline)"
        RawUrl = "https://alist.legspcpd.top/d/Github/exe/151.0.7922.174_chrome_installer_uncompressed.exe"
        FileName = "chrome_installer_offline.exe"
        SilentArgs = "/silent /install"
        IsZip = $false
    },
    @{ 
        Id = "7"
        Name = "Old Outlook 2021 (Online)"
        RawUrl = "https://alist.legspcpd.top/d/Github/exe/Old%20Outlook%202021.exe"
        FileName = "Old_Outlook_2021.exe"
        SilentArgs = ""
        IsZip = $false
    },
    @{ 
        Id = "8"
        Name = "PotPlayer 64bit"
        RawUrl = "https://alist.legspcpd.top/d/Github/exe/PotPlayerSetup64.exe"
        FileName = "PotPlayerSetup64.exe"
        SilentArgs = "/S"
        IsZip = $false
    },
    @{ 
        Id = "9"
        Name = "Bandizip Pro 8.00 Beta 10 x64 Repack"
        RawUrl = "https://alist.legspcpd.top/d/Github/exe/Bandizip-Pro-8.00-Beta-10-x64-Repack.exe"
        FileName = "Bandizip-Pro-8.00-Beta-10-x64-Repack.exe"
        SilentArgs = "/S"
        IsZip = $false
    },
    @{ 
        Id = "10"
        Name = "Bandizip Professional 7.46 x64 Repack"
        RawUrl = "https://alist.legspcpd.top/d/Github/exe/Bandizip-Professional-7.46-x64-Repack.exe"
        FileName = "Bandizip-Professional-7.46-x64-Repack.exe"
        SilentArgs = "/S"
        IsZip = $false
    },
    @{ 
        Id = "11"
        Name = "360 First Aid Kit (360" + [char]0x6025 + [char]0x6551 + [char]0x7B01 + ")"
        RawUrl = "https://alist.legspcpd.top/d/Github/exe/360c0mpkill_5.1.64.1289-0701.zip"
        FileName = "360c0mpkill.zip"
        SilentArgs = ""
        IsZip = $true
        ExtractExe = "360gar.exe"
    },
    @{ 
        Id = "12"
        Name = "360 Secure Browser x32 (360" + [char]0x6781 + [char]0x901F + [char]0x6D4F + [char]0x8览 + [char]0x5668 + ")"
        RawUrl = "https://alist.legspcpd.top/d/Github/exe/360cse_23.0.1253.0.exe"
        FileName = "360cse_x32.exe"
        SilentArgs = "/S"
        IsZip = $false
    },
    @{ 
        Id = "13"
        Name = "360 Secure Browser x64 (360" + [char]0x6781 + [char]0x901F + [char]0x6D4F + [char]0x8览 + [char]0x5668 + ")"
        RawUrl = "https://alist.legspcpd.top/d/Github/exe/360csex_23.1.1253.64.exe"
        FileName = "360csex_x64.exe"
        SilentArgs = "/S"
        IsZip = $false
    },
    @{ 
        Id = "14"
        Name = "Huorong Security x64 (" + [char]0x706B + [char]0x7220 + [char]0x5B89 + [char]0x5168 + ")"
        RawUrl = "https://alist.legspcpd.top/d/Github/exe/sysdiag-all-x64-6.0.11.2-2026.08.23.1.exe"
        FileName = "Huorong_x64.exe"
        SilentArgs = "/S"
        IsZip = $false
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
            $userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
            Invoke-WebRequest -Uri $downloadUrl -OutFile $tempPath -UserAgent $userAgent -UseBasicParsing -ErrorAction Stop
            
            if ($targetApp.IsZip) {
                $extractDir = Join-Path $env:TEMP ($targetApp.FileName -replace '\.zip$', '')
                Write-Host "Extracting archive..." -ForegroundColor Yellow
                Expand-Archive -Path $tempPath -DestinationPath $extractDir -Force
                $runPath = Join-Path $extractDir $targetApp.ExtractExe
                
                if (Test-Path $runPath) {
                    Write-Host $txtLaunching -ForegroundColor Green
                    Start-Process -FilePath $runPath
                } else {
                    Write-Host "Error: Main executable not found in archive." -ForegroundColor Red
                    Pause
                }
            } else {
                if ($modeChoice -eq "1") {
                    # 模式 1：常规打开安装包界面，让用户自行勾选并选择路径
                    Write-Host $txtLaunching -ForegroundColor Green
                    Start-Process -FilePath $tempPath
                } 
                elseif ($modeChoice -eq "2") {
                    # 模式 2：静默安装
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