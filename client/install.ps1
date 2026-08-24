[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 > $null

function Get-Utf8String ($bytes) {
    return [System.Text.Encoding]::UTF8.GetString([byte[]]$bytes)
}

# 动态获取用户当前实际的 Downloads 路径（支持跨盘符与路径重定向）
function Get-DownloadsFolder {
    $regPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
    $downloadsGuid = "{374DE290-123F-4565-9164-39C4925E467B}"
    
    $folder = (Get-ItemProperty -Path $regPath).$downloadsGuid
    if (-not $folder) {
        $folder = (Get-ItemProperty -Path $regPath)."{7D83EE9B-2244-4E70-B1A5-774182A0A931}"
    }
    
    if ($folder) {
        return [System.Environment]::ExpandEnvironmentVariables($folder)
    } else {
        return [System.IO.Path]::Combine($env:USERPROFILE, "Downloads")
    }
}

$downloadDir = Get-DownloadsFolder

# 确保 Downloads 目录存在
if (-not (Test-Path $downloadDir)) {
    New-Item -ItemType Directory -Path $downloadDir -Force | Out-Null
}

# 完整还原字节流中文解析定义（修复换行拼接引发的 PowerShell 语法错误）
$zh0 = Get-Utf8String @(0xE8,0xAF,0xB7,0xE9,0x80,0x89,0xE6,0x8B,0xA9,0xE8,0xAF,0xAD,0xE8,0xA8,0x80)
$zh1 = (Get-Utf8String @(0xE8,0xAF,0xB7,0xE8,0xBE,0x93,0xE5,0x85,0xA5,0xE6,0x95,0xB0,0xE5,0xAD,0x97)) + " (1-2) [" + (Get-Utf8String @(0xE9,0xBB,0x98,0xE8,0xAE,0xA4)) + " 1]"
$zh2 = "=== " + (Get-Utf8String @(0xE5,0xBF,0xAB,0xE6,0x8D,0xB7,0xE8,0xBD,0xAF,0xE4,0xB8,0x8B,0xE8,0xBD,0xBD,0xE5,0xAE,0x89,0xE8,0xA3,0x85,0xE5,0xB7,0xA5,0xE5,0xB7,0xA1)) + " ==="
$zh3 = (Get-Utf8String @(0xE8,0xAF,0xB7,0xE9,0x80,0x89,0xE6,0x8B,0xA9,0xE8,0xBD,0xAF,0xE4,0xBB,0xA4)) + ":"
$zh4 = (Get-Utf8String @(0xE8,0xAF,0xB7,0xE9,0x80,0x89,0xE6,0x8B,0xA9,0xE5,0xAE,0x89,0xE8,0xA3,0x85,0xE6,0xA8,0xA1,0xE5,0xBC,0x8F)) + " -"
$zh5 = "1. " + (Get-Utf8String @(0xE6,0x90,0xA1,0xE5,0xAE,0x89,0xE8,0xA3,0x85,0x20,0x28,0xE6,0x89,0x93,0xE5,0xBC,0x80,0xE5,0xAE,0x89,0xE8,0xA3,0x85,0xE5,0x8C,0x85,0x2C,0xE8,0x87,0xAA,0xE8,0xA1,0x8C,0xE9,0x80,0x89,0xE6,0x8B,0xA9,0xE4,0xBD,0x8D,0xE7,0xBD,0xAE,0x29))
$zh6 = "2. " + (Get-Utf8String @(0xE9,0x9D,0x99,0xE9,0xBB,0x98,0xE5,0xAE,0x89,0xE8,0xA3,0x85,0x20,0x28,0xE5,0x90,0x8E,0xE5,0x8F,0xB0,0xE8,0x87,0xAA,0xE5,0x8A,0xA8,0xE5,0xAE,0x89,0xE8,0xA3,0x85,0x29))
$zh7 = "0. " + (Get-Utf8String @(0xE9,0x80,0x80,0xE5,0x87,0xBA)) + " / Exit"
$zh8 = Get-Utf8String @(0xE6,0xAD,0xA3,0xE5,0x9C,0xA8,0xE4,0xB8,0x8B,0xE8,0xBD,0xBD)
$zh9 = (Get-Utf8String @(0xE6,0xAD,0xA3,0xE5,0x9C,0xA8,0xE6,0x89,0x93,0xE5,0xBC,0x80,0xE5,0xAE,0x89,0xE8,0xA3,0x85,0xE7,0xA8,0x8B,0xE5,0xBA,0x8F)) + "..."
$zh10 = (Get-Utf8String @(0xE6,0xAD,0xA3,0xE5,0x9C,0xA8,0xE9,0x9D,0x99,0xE9,0xBB,0x98,0xE5,0xAE,0x89,0xE8,0xA3,0x85)) + "..."
$zh11 = (Get-Utf8String @(0xE6,0x93,0x8D,0xE4,0xBD,0x9C,0xE5,0xAE,0x8C,0xE6,0x88,0x90)) + "!"
$zh12 = (Get-Utf8String @(0xE8,0xBE,0x93,0xE5,0x85,0xA5,0xE6,0x97,0xA0,0xE6,0x95,0x88)) + "."
$zh13 = (Get-Utf8String @(0xE6,0xAD,0xA3,0xE5,0x9C,0xA8,0xE6,0x89,0x93,0xE5,0xBC,0x80,0xE5,0x8E,0x8B,0xE7,0xBC,0xA9,0xE5,0x8C,0x85)) + "..."

$str360FirstAid = "360 First Aid Kit (" + (Get-Utf8String @(0xE3,0x80,0x33,0xE3,0x80,0x36,0xE3,0x80,0x30,0xE6,0x80,0xA5,0xE6,0x95,0x91,0xE7,0xAE,0xB1)) + ")"
$str360BrowserX32 = "360 Secure Browser x32 (" + (Get-Utf8String @(0xE3,0x80,0x33,0xE3,0x80,0x36,0xE3,0x80,0x30,0xE6,0x9E,0x81,0xE9,0x80,0x9F,0xE6,0xB5,0x8F,0xE8,0xA7,0x88,0xE5,0x99,0xA8)) + ")"
$str360BrowserX64 = "360 Secure Browser x64 (" + (Get-Utf8String @(0xE3,0x80,0x33,0xE3,0x80,0x36,0xE3,0x80,0x30,0xE6,0x9E,0x81,0xE9,0x80,0x9F,0xE6,0xB5,0x8F,0xE8,0xA7,0x88,0xE5,0x99,0xA8)) + ")"
$strHuorong = "Huorong Security x64 (" + (Get-Utf8String @(0xE7,0x81,0xAB,0xE7,0xBB,0x90,0xE5,0xAE,0x89,0xE5,0x85,0xA8)) + ")"

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
    $txtModeManual        = "1. Manual Install (Open setup UI)"
    $txtModeSilent        = "2. Silent Install (Background install)"
    $txtBack              = "0. Exit"
    $txtDownloading       = "Downloading"
    $txtLaunching         = "Launching installer..."
    $txtOpeningZip        = "Opening archive..."
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
    $txtOpeningZip        = $zh13
    $txtInstallingSilent  = $zh10
    $txtDone              = $zh11
    $txtInvalid           = $zh12
}

$softwareList = @(
    @{ Id = "1"; Name = "Roblox Player"; RawUrl = "https://alist.legspcpd.top/d/Github/exe/RobloxPlayerInstaller.exe"; FileName = "RobloxPlayerInstaller.exe"; SilentArgs = ""; IsZip = $false },
    @{ Id = "2"; Name = "Firefox Installer (Online)"; RawUrl = "https://alist.legspcpd.top/d/Github/exe/Firefox%20Installer.exe"; FileName = "Firefox_Installer.exe"; SilentArgs = "-ms"; IsZip = $false },
    @{ Id = "3"; Name = "Firefox Setup 154.0 (Offline)"; RawUrl = "https://alist.legspcpd.top/d/Github/exe/Firefox%20Setup%20154.0.exe"; FileName = "Firefox_Setup_154.0.exe"; SilentArgs = "-ms"; IsZip = $false },
    @{ Id = "4"; Name = "ChatGPT Installer"; RawUrl = "https://alist.legspcpd.top/d/Github/exe/ChatGPT%20Installer.exe"; FileName = "ChatGPT_Installer.exe"; SilentArgs = "/S"; IsZip = $false },
    @{ Id = "5"; Name = "Google Chrome (Online)"; RawUrl = "https://alist.legspcpd.top/d/Github/ChromeSetup.exe"; FileName = "ChromeSetup.exe"; SilentArgs = "/silent /install"; IsZip = $false },
    @{ Id = "6"; Name = "Google Chrome (151.0 Offline)"; RawUrl = "https://alist.legspcpd.top/d/Github/exe/151.0.7922.174_chrome_installer_uncompressed.exe"; FileName = "chrome_installer_offline.exe"; SilentArgs = "/silent /install"; IsZip = $false },
    @{ Id = "7"; Name = "Old Outlook 2021 (Online)"; RawUrl = "https://alist.legspcpd.top/d/Github/exe/Old%20Outlook%202021.exe"; FileName = "Old_Outlook_2021.exe"; SilentArgs = ""; IsZip = $false },
    @{ Id = "8"; Name = "PotPlayer 64bit"; RawUrl = "https://alist.legspcpd.top/d/Github/exe/PotPlayerSetup64.exe"; FileName = "PotPlayerSetup64.exe"; SilentArgs = "/S"; IsZip = $false },
    @{ Id = "9"; Name = "Bandizip Pro 8.00 Beta 10 x64 Repack"; RawUrl = "https://alist.legspcpd.top/d/Github/exe/Bandizip-Pro-8.00-Beta-10-x64-Repack.exe"; FileName = "Bandizip-Pro-8.00-Beta-10-x64-Repack.exe"; SilentArgs = "/S"; IsZip = $false },
    @{ Id = "10"; Name = "Bandizip Professional 7.46 x64 Repack"; RawUrl = "https://alist.legspcpd.top/d/Github/exe/Bandizip-Professional-7.46-x64-Repack.exe"; FileName = "Bandizip-Professional-7.46-x64-Repack.exe"; SilentArgs = "/S"; IsZip = $false },
    @{ Id = "11"; Name = $str360FirstAid; RawUrl = "https://alist.legspcpd.top/d/Github/exe/360c0mpkill_5.1.64.1289-0701.zip"; FileName = "360c0mpkill.zip"; SilentArgs = ""; IsZip = $true },
    @{ Id = "12"; Name = $str360BrowserX32; RawUrl = "https://alist.legspcpd.top/d/Github/exe/360cse_23.0.1253.0.exe"; FileName = "360cse_x32.exe"; SilentArgs = "/S"; IsZip = $false },
    @{ Id = "13"; Name = $str360BrowserX64; RawUrl = "https://alist.legspcpd.top/d/Github/exe/360csex_23.1.1253.64.exe"; FileName = "360csex_x64.exe"; SilentArgs = "/S"; IsZip = $false },
    @{ Id = "14"; Name = $strHuorong; RawUrl = "https://alist.legspcpd.top/d/Github/exe/sysdiag-all-x64-6.0.11.2-2026.08.23.1.exe"; FileName = "Huorong_x64.exe"; SilentArgs = "/S"; IsZip = $false }
)

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
        # 下载至用户系统实际的 Downloads 目录
        $targetPath = Join-Path $downloadDir $targetApp.FileName
        
        # 隐藏真实 URL，仅显示名称
        Write-Host "${txtDownloading}: $($targetApp.Name) ..." -ForegroundColor Cyan
        
        try {
            $userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
            Invoke-WebRequest -Uri $downloadUrl -OutFile $targetPath -UserAgent $userAgent -UseBasicParsing -ErrorAction Stop
            
            # 压缩包文件直接调用默认解压软件打开
            if ($targetApp.IsZip -or $targetApp.FileName -match '\.(zip|7z|rar|tar|gz)$') {
                Write-Host $txtOpeningZip -ForegroundColor Green
                Invoke-Item -Path $targetPath
            } else {
                if ($modeChoice -eq "1") {
                    Write-Host $txtLaunching -ForegroundColor Green
                    Start-Process -FilePath $targetPath
                } 
                elseif ($modeChoice -eq "2") {
                    Write-Host $txtInstallingSilent -ForegroundColor Green
                    if ($targetApp.SilentArgs) {
                        Start-Process -FilePath $targetPath -ArgumentList $targetApp.SilentArgs -Wait
                    } else {
                        Start-Process -FilePath $targetPath -Wait
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